From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 04/22] imsm: Add support for copy area and backup operations
Date: Thu, 02 Jun 2011 16:48:43 +0200
Message-ID: <20110602144843.27355.98362.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

This patch adds methods of manipulating migration record:
init_migr_record_imsm() - initiate migration record at the beginning of
     the reshape process
write_imsm_migr_rec() - saves migration record to array.
     Migration record is stored on 2 first disks in array only.
save_backup_imsm() - saves critical data stripes to Migration Copy Area
     and updates the current migration unit status.
     Uses restore_stripes() to format a destination stripe, and to write it
     to the Migration Copy Area.
save_checkpoint_imsm() - Updates the current unit status in the
     migration record.

Migration record is written to 2 first array disks only (similar to reading
operation).

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |  279 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 279 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ffc41e7..1f7d008 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1885,6 +1885,57 @@ out:
 	return retval;
 }
 
+/*******************************************************************************
+ * Function:	write_imsm_migr_rec
+ * Description:	Function writes imsm migration record
+ *		(at the last sector of disk)
+ * Parameters:
+ *	super	: imsm internal array info
+ * Returns:
+ *	 0 : success
+ *	-1 : if fail
+ ******************************************************************************/
+static int write_imsm_migr_rec(struct supertype *st)
+{
+	struct intel_super *super = st->sb;
+	unsigned long long dsize;
+	char nm[30];
+	int fd = -1;
+	int retval = -1;
+	struct dl *sd;
+
+	for (sd = super->disks ; sd ; sd = sd->next) {
+		/* write to 2 first slots only */
+		if ((sd->index < 0) || (sd->index > 1))
+			continue;
+		sprintf(nm, "%d:%d", sd->major, sd->minor);
+		fd = dev_open(nm, O_RDWR);
+		if (fd < 0)
+			continue;
+		get_dev_size(fd, NULL, &dsize);
+		if (lseek64(fd, dsize - 512, SEEK_SET) < 0) {
+			fprintf(stderr,
+				Name ": Cannot seek to anchor block: %s\n",
+				strerror(errno));
+			goto out;
+		}
+		if (write(fd, super->migr_rec_buf, 512) != 512) {
+			fprintf(stderr,
+				Name ": Cannot write migr record block: %s\n",
+				strerror(errno));
+			goto out;
+		}
+		close(fd);
+		fd = -1;
+	}
+
+	retval = 0;
+ out:
+	if (fd >= 0)
+		close(fd);
+	return retval;
+}
+
 static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info, char *dmap)
 {
 	struct intel_super *super = st->sb;
@@ -7262,6 +7313,234 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned ind
 	}
 }
 
+/*******************************************************************************
+ * Function:	open_backup_targets
+ * Description:	Function opens file descriptors for all devices given in
+ *		info->devs
+ * Parameters:
+ *	info		: general array info
+ *	raid_disks	: number of disks
+ *	raid_fds	: table of device's file descriptors
+ * Returns:
+ *	 0 : success
+ *	-1 : fail
+ ******************************************************************************/
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
+/*******************************************************************************
+ * Function:	init_migr_record_imsm
+ * Description:	Function inits imsm migration record
+ * Parameters:
+ *	super	: imsm internal array info
+ *	dev	: device under migration
+ *	info	: general array info to find the smallest device
+ * Returns:
+ *	none
+ ******************************************************************************/
+void init_migr_record_imsm(struct supertype *st, struct imsm_dev *dev,
+			   struct mdinfo *info)
+{
+	struct intel_super *super = st->sb;
+	struct migr_record *migr_rec = super->migr_rec;
+	int new_data_disks;
+	unsigned long long dsize, dev_sectors;
+	long long unsigned min_dev_sectors = -1LLU;
+	struct mdinfo *sd;
+	char nm[30];
+	int fd;
+	struct imsm_map *map_dest = get_imsm_map(dev, 0);
+	struct imsm_map *map_src = get_imsm_map(dev, 1);
+	unsigned long long num_migr_units;
+
+	unsigned long long array_blocks =
+		(((unsigned long long)__le32_to_cpu(dev->size_high)) << 32) +
+		__le32_to_cpu(dev->size_low);
+
+	memset(migr_rec, 0, sizeof(struct migr_record));
+	migr_rec->family_num = __cpu_to_le32(super->anchor->family_num);
+
+	/* only ascending reshape supported now */
+	migr_rec->ascending_migr = __cpu_to_le32(1);
+
+	migr_rec->dest_depth_per_unit = GEN_MIGR_AREA_SIZE /
+		max(map_dest->blocks_per_strip, map_src->blocks_per_strip);
+	migr_rec->dest_depth_per_unit *= map_dest->blocks_per_strip;
+	new_data_disks = imsm_num_data_members(dev, 0);
+	migr_rec->blocks_per_unit =
+		__cpu_to_le32(migr_rec->dest_depth_per_unit * new_data_disks);
+	migr_rec->dest_depth_per_unit =
+		__cpu_to_le32(migr_rec->dest_depth_per_unit);
+
+	num_migr_units =
+		array_blocks / __le32_to_cpu(migr_rec->blocks_per_unit);
+
+	if (array_blocks % __le32_to_cpu(migr_rec->blocks_per_unit))
+		num_migr_units++;
+	migr_rec->num_migr_units = __cpu_to_le32(num_migr_units);
+
+	migr_rec->post_migr_vol_cap =  dev->size_low;
+	migr_rec->post_migr_vol_cap_hi = dev->size_high;
+
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
+
+	write_imsm_migr_rec(st);
+
+	return;
+}
+
+/*******************************************************************************
+ * Function:	save_backup_imsm
+ * Description:	Function saves critical data stripes to Migration Copy Area
+ *		and updates the current migration unit status.
+ *		Use restore_stripes() to form a destination stripe,
+ *		and to write it to the Copy Area.
+ * Parameters:
+ *	st		: supertype information
+ *	info		: general array info
+ *	buf		: input buffer
+ *	write_offset	: address of data to backup
+ *	length		: length of data to backup (blocks_per_unit)
+ * Returns:
+ *	 0 : success
+ *,	-1 : fail
+ ******************************************************************************/
+int save_backup_imsm(struct supertype *st,
+		     struct imsm_dev *dev,
+		     struct mdinfo *info,
+		     void *buf,
+		     int new_data,
+		     int length)
+{
+	int rv = -1;
+	struct intel_super *super = st->sb;
+	unsigned long long *target_offsets = NULL;
+	int *targets = NULL;
+	int i;
+	struct imsm_map *map_dest = get_imsm_map(dev, 0);
+	int new_disks = map_dest->num_members;
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
+	}
+
+	if (open_backup_targets(info, new_disks, targets))
+		goto abort;
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
+			    0,
+			    length,
+			    buf) != 0) {
+		fprintf(stderr, Name ": Error restoring stripes\n");
+		goto abort;
+	}
+
+	rv = 0;
+
+abort:
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
+/*******************************************************************************
+ * Function:	save_checkpoint_imsm
+ * Description:	Function called for current unit status update
+ *		in the migration record. It writes it to disk.
+ * Parameters:
+ *	super	: imsm internal array info
+ *	info	: general array info
+ * Returns:
+ *	0: success
+ *	1: failure
+ ******************************************************************************/
+int save_checkpoint_imsm(struct supertype *st, struct mdinfo *info, int state)
+{
+	struct intel_super *super = st->sb;
+	load_imsm_migr_rec(super, info);
+	if (__le32_to_cpu(super->migr_rec->blocks_per_unit) == 0) {
+		dprintf("ERROR: blocks_per_unit = 0!!!\n");
+		return 1;
+	}
+
+	super->migr_rec->curr_migr_unit =
+	  __cpu_to_le32(info->reshape_progress /
+			__le32_to_cpu(super->migr_rec->blocks_per_unit));
+	super->migr_rec->rec_status = __cpu_to_le32(state);
+	super->migr_rec->dest_1st_member_lba =
+	  __cpu_to_le32((__le32_to_cpu(super->migr_rec->curr_migr_unit))
+			* __le32_to_cpu(super->migr_rec->dest_depth_per_unit));
+	if (write_imsm_migr_rec(st) < 0) {
+		dprintf("imsm: Cannot write migration record "
+			"outside backup area\n");
+		return 1;
+	}
+
+	return 0;
+}
+
 static char disk_by_path[] = "/dev/disk/by-path/";
 
 static const char *imsm_get_disk_controller_domain(const char *path)

