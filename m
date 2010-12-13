From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 11/16] mdadm: support backup operations for imsm
Date: Mon, 13 Dec 2010 15:46:25 +0100
Message-ID: <20101213144625.4384.82582.stgit@gklab-170-024.igk.intel.com>
References: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

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
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdmon.c       |    9 ++
 super-intel.c |  267 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 274 insertions(+), 2 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index 85890de..8afb4de 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -575,3 +575,12 @@ void reshape_free_fdlist(int *fdlist,
 	;
 }
 
+int restore_stripes(int *dest, unsigned long long *offsets,
+		    int raid_disks, int chunk_size, int level, int layout,
+		    int source, unsigned long long read_offset,
+		    unsigned long long start, unsigned long long length,
+		    char *src_buf)
+{
+	return 1;
+}
+
diff --git a/super-intel.c b/super-intel.c
index 349e583..b328828 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1591,7 +1591,6 @@ static int imsm_level_to_layout(int level)
 /*
  * load_imsm_migr_rec - read imsm migration record
  */
-__attribute__((unused))
 static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 {
 	unsigned long long dsize;
@@ -1646,7 +1645,6 @@ static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 /*
  * write_imsm_migr_rec - write imsm migration record
  */
-__attribute__((unused))
 static int write_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 {
 	unsigned long long dsize;
@@ -6448,6 +6446,264 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned ind
 		__free_imsm_disk(dl);
 	}
 }
+
+int open_backup_targets(struct mdinfo *info, int raid_disks, int *raid_fds)
+{
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
+			raid_fds[sd->disk.raid_disk] = -1;
+			continue;
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
+	char nm[30];
+	int fd;
+
+	memset(migr_rec, 0, sizeof(struct migr_record));
+	migr_rec->family_num = __cpu_to_le32(super->anchor->family_num);
+
+	migr_rec->ascending_migr =
+		__cpu_to_le32((info->delta_disks > 0) ? 1 : 0);
+
+	prev_data_disks = info->array.raid_disks;
+	if ((info->array.level == 5) || (info->array.level == 4))
+		prev_data_disks--;
+	new_data_disks = info->array.raid_disks + info->delta_disks;
+	if ((info->new_level == 5) || (info->new_level == 4))
+		new_data_disks--;
+
+	new_array_sectors = info->component_size;
+	new_array_sectors &= ~(unsigned long long)((info->new_chunk / 512) - 1);
+	new_array_sectors *= new_data_disks;
+	new_array_sectors = (new_array_sectors >> SECT_PER_MB_SHIFT)
+		<< SECT_PER_MB_SHIFT;
+
+	migr_rec->post_migr_vol_cap = __cpu_to_le32(new_array_sectors);
+	migr_rec->post_migr_vol_cap_hi = __cpu_to_le32(new_array_sectors >> 32);
+
+	prev_stripe_sectors =  info->array.chunk_size/512 * prev_data_disks;
+	new_stripe_sectors = info->new_chunk/512 * new_data_disks;
+
+	new_array_sectors =
+		info->component_size * new_data_disks / blocks_per_unit;
+	migr_rec->num_migr_units = __cpu_to_le32(new_array_sectors);
+	migr_rec->dest_depth_per_unit =
+		__cpu_to_le32(blocks_per_unit / new_data_disks);
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
+					RAID_DISK_RESERVED_BLOCKS_IMSM_HI);
+	return;
+}
+
+int save_backup_imsm(struct supertype *st, struct mdinfo *info,
+		     void *buf, unsigned long write_offset,
+		     int length)
+{
+	int rv = -1;
+	struct intel_super *super = st->sb;
+	unsigned long long *target_offsets = NULL;
+	int *targets = NULL;
+	int new_disks, new_odata;
+	int i;
+
+	if (info->reshape_progress == 0)
+		init_migr_record_imsm(super, info, length/512);
+
+	new_disks = info->array.raid_disks + info->delta_disks;
+	new_odata = new_disks;
+	if ((info->new_level == 5) || (info->new_level == 4))
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
+			    0,     /* input buf offset
+				    * always 0 buf is already offseted */
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
+			if (targets[i] >= 0)
+				close(targets[i]);
+		free(targets);
+	}
+	if (target_offsets)
+		free(target_offsets);
+
+	return rv;
+}
+
+void discard_backup_imsm(struct supertype *st, struct mdinfo *info)
+{
+	struct intel_super *super = st->sb;
+	load_imsm_migr_rec(super, info);
+	if (__le32_to_cpu(super->migr_rec->blocks_per_unit) == 0) {
+		dprintf("ERROR: blocks_per_unit = 0!!!\n");
+		return;
+	}
+
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
 #endif /* MDASSEMBLE */
 
 static char disk_by_path[] = "/dev/disk/by-path/";
@@ -8615,6 +8871,13 @@ struct superswitch super_imsm = {
 	.manage_reshape = imsm_manage_reshape,
 	.reshape_array	= imsm_reshape_array,
 
+	/* for external backup area
+	 *
+	 */
+	.save_backup = save_backup_imsm,
+	.discard_backup = discard_backup_imsm,
+	.recover_backup = recover_backup_imsm,
+
 	.external	= 1,
 	.name = "imsm",
 

