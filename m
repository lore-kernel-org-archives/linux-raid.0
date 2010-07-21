From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 08/10] mdadm: support backup operations for imsm
Date: Wed, 21 Jul 2010 12:21:17 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040804E2A49C9@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Maciej Trela <maciej.trela@intel.com>

Add support for the following operations:
save_backup() - save critical data stripes to Migration Copy Area and
	      update the current migration unit status.
	      Use restore_stripes() to form a destination stripe,
	      and to write it to the Copy Area.
	      save_backup() initialize migration record at the
	      beginning of the reshape.

discard_backup() - critical data was successfully migrated by the kernel.
		 Update the current unit status in the migration record.

recover_backup() - recover critical data from the Migration Copy Area
		 while assembling an array.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 Makefile      |    4 -
 super-intel.c |  265 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 264 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 56e5ed9..b2eae82 100644
--- a/Makefile
+++ b/Makefile
@@ -97,12 +97,12 @@ SRCS =  mdadm.c config.c mdstat.c  ReadMe.c util.c Manage.c Assemble.c Build.c \  MON_OBJS = mdmon.o monitor.o managemon.o util.o mdstat.o sysfs.o config.o \
 	Kill.o sg_io.o dlink.o ReadMe.o super0.o super1.o super-intel.o \
 	super-ddf.o sha1.o crc32.o msg.o bitmap.o \
-	platform-intel.o probe_roms.o
+	platform-intel.o probe_roms.o restripe.o
 
 MON_SRCS = mdmon.c monitor.c managemon.c util.c mdstat.c sysfs.c config.c \
 	Kill.c sg_io.c dlink.c ReadMe.c super0.c super1.c super-intel.c \
 	super-ddf.c sha1.c crc32.c msg.c bitmap.c \
-	platform-intel.c probe_roms.c
+	platform-intel.c probe_roms.c restripe.c
 
 STATICSRC = pwgr.c
 STATICOBJS = pwgr.o
diff --git a/super-intel.c b/super-intel.c index 46c3ef6..35c6e61 100755
--- a/super-intel.c
+++ b/super-intel.c
@@ -1486,7 +1486,6 @@ static int imsm_level_to_layout(int level)
 /*
  * load_imsm_migr_rec - read imsm migration record
  */
-__attribute__((unused))
 static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)  {
 	unsigned long long dsize;
@@ -1541,7 +1540,6 @@ static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 /*
  * write_imsm_migr_rec - write imsm migration record
  */
-__attribute__((unused))
 static int write_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)  {
 	unsigned long long dsize;
@@ -2490,7 +2488,6 @@ static void migrate(struct imsm_dev *dev, struct intel_super *super,
 			set_imsm_ord_tbl_ent(src, i, ord_to_idx(ord));
 		}
 	}
-
 	if (migr_type == MIGR_GEN_MIGR)
 		/* Clear migration record */
 		memset(super->migr_rec, 0, sizeof(struct migr_record)); @@ -6361,6 +6358,260 @@ abort:
 
 	return ret_val;
 }
+
+int open_backup_targets(struct mdinfo *info, int raid_disks, int 
+*raid_fds) {
+	struct mdinfo *sd;
+
+	for (sd = info->devs ; sd ; sd = sd->next) {
+		if (sd->disk.state & (1<<MD_DISK_FAULTY)) {
+			dprintf("disk is faulty!!\n");
+			continue;
+		}
+
+		if ((sd->disk.raid_disk >= raid_disks) ||
+		    (sd->disk.raid_disk < 0)) {
+			dprintf("incorrect slot = %d!!\n", sd->disk.raid_disk);
+			return -1;
+		}
+		char *dn = map_dev(sd->disk.major,
+				   sd->disk.minor, 1);
+		raid_fds[sd->disk.raid_disk] = dev_open(dn, O_RDWR);
+		if (raid_fds[sd->disk.raid_disk] < 0) {
+			fprintf(stderr, "cannot open component\n");
+			return -1;
+		}
+	}
+	return 0;
+}
+
+#define RAID_DISK_RESERVED_BLOCKS_IMSM_HI 417
+
+void init_migr_record_imsm(struct intel_super *super, struct mdinfo *info,
+			   unsigned blocks_per_unit)
+{
+	struct migr_record *migr_rec = super->migr_rec;
+	int new_data_disks, prev_data_disks;
+	long long unsigned new_array_sectors;
+	int prev_stripe_sectors, new_stripe_sectors;
+	unsigned long long dsize, dev_sectors;
+	long long unsigned min_dev_sectors = -1LLU;
+	struct mdinfo *sd;
+	char nm[20];
+	int fd;
+
+	memset(migr_rec, 0, sizeof(struct migr_record));
+	migr_rec->family_num = __cpu_to_le32(super->anchor->family_num);
+
+	migr_rec->ascending_migr = __cpu_to_le32((info->delta_disks > 0) ? 1 : 
+0);
+
+	prev_data_disks = info->array.raid_disks;
+	if (info->array.level == 5)
+		prev_data_disks--;
+	new_data_disks = info->array.raid_disks + info->delta_disks;
+	if (info->new_level == 5)
+		new_data_disks--;
+
+	new_array_sectors = info->component_size;
+	new_array_sectors &= ~(unsigned long long)((info->new_chunk / 512) - 1);
+	new_array_sectors *= new_data_disks;
+	new_array_sectors = (new_array_sectors >> SECT_PER_MB_SHIFT)
+		<< SECT_PER_MB_SHIFT;
+
+	migr_rec->post_migr_vol_cap = __cpu_to_le32(new_array_sectors);
+	migr_rec->post_migr_vol_cap_hi = __cpu_to_le32(new_array_sectors >> 
+32);
+
+	prev_stripe_sectors =  info->array.chunk_size/512 * prev_data_disks;
+	new_stripe_sectors = info->new_chunk/512 * new_data_disks;
+
+	new_array_sectors = info->component_size * new_data_disks / blocks_per_unit;
+	migr_rec->num_migr_units = __cpu_to_le32(new_array_sectors);
+	migr_rec->dest_depth_per_unit = __cpu_to_le32(blocks_per_unit / new_data_disks);
+	migr_rec->blocks_per_unit = __cpu_to_le32(blocks_per_unit);
+
+	/* Find the smallest dev */
+	for (sd = info->devs ; sd ; sd = sd->next) {
+		sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
+		fd = dev_open(nm, O_RDONLY);
+		if (fd < 0)
+			continue;
+		get_dev_size(fd, NULL, &dsize);
+		dev_sectors = dsize / 512;
+		if (dev_sectors < min_dev_sectors)
+			min_dev_sectors = dev_sectors;
+		close(fd);
+	}
+	migr_rec->ckpt_area_pba = __cpu_to_le32(min_dev_sectors -
+						RAID_DISK_RESERVED_BLOCKS_IMSM_HI);
+	return;
+}
+
+int save_backup_imsm(struct supertype *st, struct mdinfo *info,
+		     void *buf, unsigned long write_offset,
+		     int length)
+{
+	struct intel_super *super = st->sb;
+	unsigned long long *target_offsets = NULL;
+	int *targets = NULL;
+	int new_disks, new_odata;
+	int i, rv = -1;
+
+	if (info->reshape_progress == 0)
+		init_migr_record_imsm(super, info, length/512);
+
+	new_disks = info->array.raid_disks + info->delta_disks;
+	new_odata = new_disks;
+	if (info->new_level == 5)
+		new_odata--;
+
+	targets = malloc(new_disks * sizeof(int));
+	if (!targets)
+		goto abort;
+
+	target_offsets = malloc(new_disks * sizeof(unsigned long long));
+	if (!target_offsets)
+		goto abort;
+
+	for (i = 0; i < new_disks; i++) {
+		targets[i] = -1;
+		target_offsets[i] = (unsigned long long)
+		  __le32_to_cpu(super->migr_rec->ckpt_area_pba) * 512;
+		target_offsets[i] -= write_offset / new_odata;
+	}
+
+	open_backup_targets(info, new_disks, targets);
+
+	if (restore_stripes(targets, /* list of dest devices */
+			    target_offsets, /* migration record offsets */
+			    new_disks,
+			    info->new_chunk,
+			    info->new_level,
+			    info->new_layout,
+			    0,     /* source backup file descriptor */
+			    0,     /*input buf offset - always 0 buf is already offseted */
+			    write_offset,
+			    info->new_chunk * new_odata,
+			    buf) != 0) {
+		fprintf(stderr, Name ": Error restoring stripes\n");
+		goto abort;
+	}
+
+	super->migr_rec->curr_migr_unit =
+	  __cpu_to_le32(info->reshape_progress /
+			__le32_to_cpu(super->migr_rec->blocks_per_unit) + 1);
+	super->migr_rec->rec_status = __cpu_to_le32(UNIT_SRC_IN_CP_AREA);
+	super->migr_rec->dest_1st_member_lba =
+	  __cpu_to_le32((__le32_to_cpu(super->migr_rec->curr_migr_unit) - 1)
+			* __le32_to_cpu(super->migr_rec->dest_depth_per_unit));
+
+	write_imsm_migr_rec(super, info);
+ abort:
+	if (targets) {
+		for (i = 0; i < new_disks; i++)
+			if (targets[i])
+				close(targets[i]);
+		free(targets);
+	}
+	if (target_offsets)
+		free(target_offsets);
+	return rv;
+}
+
+void discard_backup_imsm(struct supertype *st, struct mdinfo *info) {
+	struct intel_super *super = st->sb;
+	if (__le32_to_cpu(super->migr_rec->blocks_per_unit) == 0) {
+		load_imsm_migr_rec(super, info);
+		if (__le32_to_cpu(super->migr_rec->blocks_per_unit) == 0) {
+			dprintf("ERROR: blocks_per_unit = 0!!!\n");
+			return;
+		}
+	}
+	super->migr_rec->curr_migr_unit =
+	  __cpu_to_le32(info->reshape_progress /
+			__le32_to_cpu(super->migr_rec->blocks_per_unit) + 1);
+	super->migr_rec->rec_status = __cpu_to_le32(UNIT_SRC_NORMAL);
+	super->migr_rec->dest_1st_member_lba =
+	  __cpu_to_le32((__le32_to_cpu(super->migr_rec->curr_migr_unit) - 1)
+			* __le32_to_cpu(super->migr_rec->dest_depth_per_unit));
+	write_imsm_migr_rec(super, info);
+}
+
+int recover_backup_imsm(struct supertype *st, struct mdinfo *info,
+			void *ptr, int length)
+{
+	struct intel_super *super = st->sb;
+	unsigned long long read_offset;
+	unsigned long long write_offset;
+	unsigned unit_len;
+	int *targets = NULL;
+	int new_disks, i;
+	char *buf = NULL;
+	int retval = 1;
+
+	if (__le32_to_cpu(super->migr_rec->rec_status) == UNIT_SRC_NORMAL)
+		return 0;
+	if (__le32_to_cpu(super->migr_rec->curr_migr_unit)
+	    >= __le32_to_cpu(super->migr_rec->num_migr_units))
+		return 0;
+
+	new_disks = info->array.raid_disks + info->delta_disks;
+
+	read_offset = (unsigned long long)
+			__le32_to_cpu(super->migr_rec->ckpt_area_pba) * 512;
+
+	write_offset = ((unsigned long long)
+			__le32_to_cpu(super->migr_rec->dest_1st_member_lba) +
+			info->data_offset) * 512;
+
+	unit_len = __le32_to_cpu(super->migr_rec->dest_depth_per_unit) * 512;
+	if (posix_memalign((void **)&buf, 512, unit_len) != 0)
+		goto abort;
+	targets = malloc(new_disks * sizeof(int));
+	if (!targets)
+		goto abort;
+
+	open_backup_targets(info, new_disks, targets);
+
+	for (i = 0; i < new_disks; i++) {
+		if (lseek64(targets[i], read_offset, SEEK_SET) < 0) {
+			fprintf(stderr,
+				Name ": Cannot seek to block: %s\n",
+				strerror(errno));
+			goto abort;
+		}
+		if (read(targets[i], buf, unit_len) != unit_len) {
+			fprintf(stderr,
+				Name ": Cannot read copy area block: %s\n",
+				strerror(errno));
+			goto abort;
+		}
+		if (lseek64(targets[i], write_offset, SEEK_SET) < 0) {
+			fprintf(stderr,
+				Name ": Cannot seek to block: %s\n",
+				strerror(errno));
+			goto abort;
+		}
+		if (write(targets[i], buf, unit_len) != unit_len) {
+			fprintf(stderr,
+				Name ": Cannot restore block: %s\n",
+				strerror(errno));
+			goto abort;
+		}
+	}
+	retval = 0;
+abort:
+	if (targets) {
+		for (i = 0; i < new_disks; i++)
+			if (targets[i])
+				close(targets[i]);
+		free(targets);
+	}
+	if (buf)
+		free(buf);
+	return retval;
+}
+
 #endif /* MDASSEMBLE */
 
 struct superswitch super_imsm = {
@@ -6394,6 +6645,14 @@ struct superswitch super_imsm = {
 	.default_layout = imsm_level_to_layout,
 	.is_allowed	= imsm_is_allowed,
 	.grow_array	= imsm_grow_array,
+
+	/* for external backup area
+	 *
+	 */
+	.save_backup = save_backup_imsm,
+	.discard_backup = discard_backup_imsm,
+	.recover_backup = recover_backup_imsm,
+
 	.external	= 1,
 	.name = "imsm",
 

