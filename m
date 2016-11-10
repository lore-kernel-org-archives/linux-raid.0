From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 3/4] IMSM: Add support for 4Kn sector size drives
Date: Thu, 10 Nov 2016 15:28:17 +0100
Message-ID: <1478788098-32041-4-git-send-email-pawel.baldysiak@intel.com>
References: <1478788098-32041-1-git-send-email-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1478788098-32041-1-git-send-email-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

This patch adds support for drives with 4Kn sector size
for IMSM metadata. Mixing member drives with 4Kn and 512
is not allowed. Some offsets were aligned with sector size.
Internal metadata representation and all calculations
are still based on 512-byte sector sizes. This
implementation converts only sector based values
when reading/writing to drive, because they needs to be
stored in metadata according to accual member drive sector size.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 199 +++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 154 insertions(+), 45 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 8a2d993..fa3e96d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -318,14 +318,15 @@ static void set_migr_type(struct imsm_dev *dev, __u8 migr_type)
 	}
 }
 
-static unsigned int sector_count(__u32 bytes)
+static unsigned int sector_count(__u32 bytes, unsigned int sector_size)
 {
-	return ROUND_UP(bytes, 512) / 512;
+	return ROUND_UP(bytes, sector_size) / sector_size;
 }
 
-static unsigned int mpb_sectors(struct imsm_super *mpb)
+static unsigned int mpb_sectors(struct imsm_super *mpb,
+					unsigned int sector_size)
 {
-	return sector_count(__le32_to_cpu(mpb->mpb_size));
+	return sector_count(__le32_to_cpu(mpb->mpb_size), sector_size);
 }
 
 struct intel_dev {
@@ -915,12 +916,12 @@ static unsigned long long num_data_stripes(struct imsm_map *map)
 		return 0;
 	return join_u32(map->num_data_stripes_lo, map->num_data_stripes_hi);
 }
+#endif
 
 static void set_total_blocks(struct imsm_disk *disk, unsigned long long n)
 {
 	split_ull(n, &disk->total_blocks_lo, &disk->total_blocks_hi);
 }
-#endif
 
 static void set_pba_of_lba0(struct imsm_map *map, unsigned long long n)
 {
@@ -1122,6 +1123,8 @@ static unsigned long long min_acceptable_spare_size_imsm(struct supertype *st)
 
 static int is_gen_migration(struct imsm_dev *dev);
 
+#define IMSM_4K_DIV 8
+
 #ifndef MDASSEMBLE
 static __u64 blocks_per_migr_unit(struct intel_super *super,
 				  struct imsm_dev *dev);
@@ -1253,6 +1256,48 @@ static void print_imsm_disk(struct imsm_disk *disk, int index, __u32 reserved)
 	       human_size(sz * 512));
 }
 
+void convert_to_4k_imsm_disk(struct imsm_disk *disk)
+{
+	set_total_blocks(disk, (total_blocks(disk)/IMSM_4K_DIV));
+}
+
+void convert_to_4k(struct intel_super *super)
+{
+	struct imsm_super *mpb = super->anchor;
+	struct imsm_disk *disk;
+	int i;
+
+	for (i = 0; i < mpb->num_disks ; i++) {
+		disk = __get_imsm_disk(mpb, i);
+		/* disk */
+		convert_to_4k_imsm_disk(disk);
+	}
+	for (i = 0; i < mpb->num_raid_devs; i++) {
+		struct imsm_dev *dev = __get_imsm_dev(mpb, i);
+		struct imsm_map *map = get_imsm_map(dev, MAP_0);
+		/* dev */
+		split_ull((join_u32(dev->size_low, dev->size_high)/IMSM_4K_DIV),
+				 &dev->size_low, &dev->size_high);
+		dev->vol.curr_migr_unit /= IMSM_4K_DIV;
+
+		/* map0 */
+		set_blocks_per_member(map, blocks_per_member(map)/IMSM_4K_DIV);
+		map->blocks_per_strip /= IMSM_4K_DIV;
+		set_pba_of_lba0(map, pba_of_lba0(map)/IMSM_4K_DIV);
+
+		if (dev->vol.migr_state) {
+			/* map1 */
+			map = get_imsm_map(dev, MAP_1);
+			set_blocks_per_member(map,
+			    blocks_per_member(map)/IMSM_4K_DIV);
+			map->blocks_per_strip /= IMSM_4K_DIV;
+			set_pba_of_lba0(map, pba_of_lba0(map)/IMSM_4K_DIV);
+		}
+	}
+
+	mpb->check_sum = __gen_imsm_checksum(mpb);
+}
+
 void examine_migr_rec_imsm(struct intel_super *super)
 {
 	struct migr_record *migr_rec = super->migr_rec;
@@ -1310,6 +1355,45 @@ void examine_migr_rec_imsm(struct intel_super *super)
 	}
 }
 #endif /* MDASSEMBLE */
+
+void convert_from_4k(struct intel_super *super)
+{
+	struct imsm_super *mpb = super->anchor;
+	struct imsm_disk *disk;
+	int i;
+
+	for (i = 0; i < mpb->num_disks ; i++) {
+		disk = __get_imsm_disk(mpb, i);
+		/* disk */
+		set_total_blocks(disk, (total_blocks(disk)*IMSM_4K_DIV));
+	}
+
+	for (i = 0; i < mpb->num_raid_devs; i++) {
+		struct imsm_dev *dev = __get_imsm_dev(mpb, i);
+		struct imsm_map *map = get_imsm_map(dev, MAP_0);
+		/* dev */
+		split_ull((join_u32(dev->size_low, dev->size_high)*IMSM_4K_DIV),
+				 &dev->size_low, &dev->size_high);
+		dev->vol.curr_migr_unit *= IMSM_4K_DIV;
+
+		/* map0 */
+		set_blocks_per_member(map, blocks_per_member(map)*IMSM_4K_DIV);
+		map->blocks_per_strip *= IMSM_4K_DIV;
+		set_pba_of_lba0(map, pba_of_lba0(map)*IMSM_4K_DIV);
+
+		if (dev->vol.migr_state) {
+			/* map1 */
+			map = get_imsm_map(dev, MAP_1);
+			set_blocks_per_member(map,
+			    blocks_per_member(map)*IMSM_4K_DIV);
+			map->blocks_per_strip *= IMSM_4K_DIV;
+			set_pba_of_lba0(map, pba_of_lba0(map)*IMSM_4K_DIV);
+		}
+	}
+
+	mpb->check_sum = __gen_imsm_checksum(mpb);
+}
+
 /*******************************************************************************
  * function: imsm_check_attributes
  * Description: Function checks if features represented by attributes flags
@@ -1430,7 +1514,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	sum = __le32_to_cpu(mpb->check_sum);
 	printf("       Checksum : %08x %s\n", sum,
 		__gen_imsm_checksum(mpb) == sum ? "correct" : "incorrect");
-	printf("    MPB Sectors : %d\n", mpb_sectors(mpb));
+	printf("    MPB Sectors : %d\n", mpb_sectors(mpb, super->sector_size));
 	printf("          Disks : %d\n", mpb->num_disks);
 	printf("   RAID Devices : %d\n", mpb->num_raid_devs);
 	print_imsm_disk(__get_imsm_disk(mpb, super->disks->index), super->disks->index, reserved);
@@ -1527,7 +1611,7 @@ static void export_examine_super_imsm(struct supertype *st)
 
 static int copy_metadata_imsm(struct supertype *st, int from, int to)
 {
-	/* The second last 512byte sector of the device contains
+	/* The second last sector of the device contains
 	 * the "struct imsm_super" metadata.
 	 * This contains mpb_size which is the size in bytes of the
 	 * extended metadata.  This is located immediately before
@@ -1540,7 +1624,9 @@ static int copy_metadata_imsm(struct supertype *st, int from, int to)
 	unsigned long long dsize, offset;
 	int sectors;
 	struct imsm_super *sb;
-	int written = 0;
+	struct intel_super *super = st->sb;
+	unsigned int sector_size = super->sector_size;
+	unsigned int written = 0;
 
 	if (posix_memalign(&buf, 4096, 4096) != 0)
 		return 1;
@@ -1548,21 +1634,21 @@ static int copy_metadata_imsm(struct supertype *st, int from, int to)
 	if (!get_dev_size(from, NULL, &dsize))
 		goto err;
 
-	if (lseek64(from, dsize-1024, 0) < 0)
+	if (lseek64(from, dsize-(2*sector_size), 0) < 0)
 		goto err;
-	if (read(from, buf, 512) != 512)
+	if (read(from, buf, sector_size) != sector_size)
 		goto err;
 	sb = buf;
 	if (strncmp((char*)sb->sig, MPB_SIGNATURE, MPB_SIG_LEN) != 0)
 		goto err;
 
-	sectors = mpb_sectors(sb) + 2;
-	offset = dsize - sectors * 512;
+	sectors = mpb_sectors(sb, sector_size) + 2;
+	offset = dsize - sectors * sector_size;
 	if (lseek64(from, offset, 0) < 0 ||
 	    lseek64(to, offset, 0) < 0)
 		goto err;
-	while (written < sectors * 512) {
-		int n = sectors*512 - written;
+	while (written < sectors * sector_size) {
+		int n = sectors*sector_size - written;
 		if (n > 4096)
 			n = 4096;
 		if (read(from, buf, n) != n)
@@ -2678,13 +2764,14 @@ int imsm_reshape_blocks_arrays_changes(struct intel_super *super)
 }
 static unsigned long long imsm_component_size_aligment_check(int level,
 					      int chunk_size,
+					      unsigned int sector_size,
 					      unsigned long long component_size)
 {
 	unsigned int component_size_alligment;
 
 	/* check component size aligment
 	*/
-	component_size_alligment = component_size % (chunk_size/512);
+	component_size_alligment = component_size % (chunk_size/sector_size);
 
 	dprintf("(Level: %i, chunk_size = %i, component_size = %llu), component_size_alligment = %u\n",
 		level, chunk_size, component_size,
@@ -2795,6 +2882,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	info->component_size = imsm_component_size_aligment_check(
 							info->array.level,
 							info->array.chunk_size,
+							super->sector_size,
 							info->component_size);
 
 	memset(info->uuid, 0, sizeof(info->uuid));
@@ -3615,8 +3703,9 @@ static int parse_raid_devices(struct intel_super *super)
 	if (__le32_to_cpu(mpb->mpb_size) + space_needed > super->len) {
 		void *buf;
 
-		len = ROUND_UP(__le32_to_cpu(mpb->mpb_size) + space_needed, 512);
-		if (posix_memalign(&buf, 512, len) != 0)
+		len = ROUND_UP(__le32_to_cpu(mpb->mpb_size) + space_needed,
+			      super->sector_size);
+		if (posix_memalign(&buf, 4096, len) != 0)
 			return 1;
 
 		memcpy(buf, super->buf, super->len);
@@ -3689,31 +3778,32 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 {
 	unsigned long long dsize;
 	unsigned long long sectors;
+	unsigned int sector_size = super->sector_size;
 	struct stat;
 	struct imsm_super *anchor;
 	__u32 check_sum;
 
 	get_dev_size(fd, NULL, &dsize);
-	if (dsize < 1024) {
+	if (dsize < 2*sector_size) {
 		if (devname)
 			pr_err("%s: device to small for imsm\n",
 			       devname);
 		return 1;
 	}
 
-	if (lseek64(fd, dsize - (512 * 2), SEEK_SET) < 0) {
+	if (lseek64(fd, dsize - (sector_size * 2), SEEK_SET) < 0) {
 		if (devname)
 			pr_err("Cannot seek to anchor block on %s: %s\n",
 			       devname, strerror(errno));
 		return 1;
 	}
 
-	if (posix_memalign((void**)&anchor, 512, 512) != 0) {
+	if (posix_memalign((void **)&anchor, sector_size, sector_size) != 0) {
 		if (devname)
 			pr_err("Failed to allocate imsm anchor buffer on %s\n", devname);
 		return 1;
 	}
-	if (read(fd, anchor, 512) != 512) {
+	if (read(fd, anchor, sector_size) != sector_size) {
 		if (devname)
 			pr_err("Cannot read anchor block on %s: %s\n",
 			       devname, strerror(errno));
@@ -3733,17 +3823,17 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 
 	/* capability and hba must be updated with new super allocation */
 	find_intel_hba_capability(fd, super, devname);
-	super->len = ROUND_UP(anchor->mpb_size, 512);
-	if (posix_memalign(&super->buf, 512, super->len) != 0) {
+	super->len = ROUND_UP(anchor->mpb_size, sector_size);
+	if (posix_memalign(&super->buf, 4096, super->len) != 0) {
 		if (devname)
 			pr_err("unable to allocate %zu byte mpb buffer\n",
 			       super->len);
 		free(anchor);
 		return 2;
 	}
-	memcpy(super->buf, anchor, 512);
+	memcpy(super->buf, anchor, sector_size);
 
-	sectors = mpb_sectors(anchor) - 1;
+	sectors = mpb_sectors(anchor, sector_size) - 1;
 	free(anchor);
 
 	if (posix_memalign(&super->migr_rec_buf, 512, MIGR_REC_BUF_SIZE) != 0) {
@@ -3768,14 +3858,15 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 	}
 
 	/* read the extended mpb */
-	if (lseek64(fd, dsize - (512 * (2 + sectors)), SEEK_SET) < 0) {
+	if (lseek64(fd, dsize - (sector_size * (2 + sectors)), SEEK_SET) < 0) {
 		if (devname)
 			pr_err("Cannot seek to extended mpb on %s: %s\n",
 			       devname, strerror(errno));
 		return 1;
 	}
 
-	if ((unsigned)read(fd, super->buf + 512, super->len - 512) != super->len - 512) {
+	if ((unsigned int)read(fd, super->buf + sector_size,
+		    super->len - sector_size) != super->len - sector_size) {
 		if (devname)
 			pr_err("Cannot read extended mpb on %s: %s\n",
 			       devname, strerror(errno));
@@ -3836,6 +3927,8 @@ load_and_parse_mpb(int fd, struct intel_super *super, char *devname, int keep_fd
 	err = load_imsm_mpb(fd, super, devname);
 	if (err)
 		return err;
+	if (super->sector_size == 4096)
+		convert_from_4k(super);
 	err = load_imsm_disk(fd, super, devname, keep_fd);
 	if (err)
 		return err;
@@ -4733,6 +4826,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	 * so st->sb is already set.
 	 */
 	struct intel_super *super = st->sb;
+	unsigned int sector_size = super->sector_size;
 	struct imsm_super *mpb = super->anchor;
 	struct intel_dev *dv;
 	struct imsm_dev *dev;
@@ -4754,9 +4848,9 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	size_new = disks_to_mpb_size(info->nr_disks);
 	if (size_new > size_old) {
 		void *mpb_new;
-		size_t size_round = ROUND_UP(size_new, 512);
+		size_t size_round = ROUND_UP(size_new, sector_size);
 
-		if (posix_memalign(&mpb_new, 512, size_round) != 0) {
+		if (posix_memalign(&mpb_new, sector_size, size_round) != 0) {
 			pr_err("could not allocate new mpb\n");
 			return 0;
 		}
@@ -4911,10 +5005,10 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
 	if (info)
 		mpb_size = disks_to_mpb_size(info->nr_disks);
 	else
-		mpb_size = 512;
+		mpb_size = 4096;
 
 	super = alloc_super();
-	if (super && posix_memalign(&super->buf, 512, mpb_size) != 0) {
+	if (super && posix_memalign(&super->buf, 4096, mpb_size) != 0) {
 		free(super);
 		super = NULL;
 	}
@@ -5261,9 +5355,9 @@ static int remove_from_super_imsm(struct supertype *st, mdu_disk_info_t *dk)
 static int store_imsm_mpb(int fd, struct imsm_super *mpb);
 
 static union {
-	char buf[512];
+	char buf[4096];
 	struct imsm_super anchor;
-} spare_record __attribute__ ((aligned(512)));
+} spare_record __attribute__ ((aligned(4096)));
 
 /* spare records have their own family number and do not have any defined raid
  * devices
@@ -5294,6 +5388,9 @@ static int write_super_imsm_spares(struct intel_super *super, int doclose)
 		if (__le32_to_cpu(d->disk.total_blocks_hi) > 0)
 			spare->attributes |= MPB_ATTRIB_2TB_DISK;
 
+		if (super->sector_size == 4096)
+			convert_to_4k_imsm_disk(&spare->disk[0]);
+
 		sum = __gen_imsm_checksum(spare);
 		spare->family_num = __cpu_to_le32(sum);
 		spare->orig_family_num = 0;
@@ -5317,6 +5414,7 @@ static int write_super_imsm_spares(struct intel_super *super, int doclose)
 static int write_super_imsm(struct supertype *st, int doclose)
 {
 	struct intel_super *super = st->sb;
+	unsigned int sector_size = super->sector_size;
 	struct imsm_super *mpb = super->anchor;
 	struct dl *d;
 	__u32 generation;
@@ -5377,6 +5475,9 @@ static int write_super_imsm(struct supertype *st, int doclose)
 	if (clear_migration_record)
 		memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SIZE);
 
+	if (sector_size == 4096)
+		convert_to_4k(super);
+
 	/* write the mpb for disks that compose raid devices */
 	for (d = super->disks; d ; d = d->next) {
 		if (d->index < 0 || is_failed(&d->disk))
@@ -5500,6 +5601,8 @@ static int store_super_imsm(struct supertype *st, int fd)
 		return 1;
 
 #ifndef MDASSEMBLE
+	if (super->sector_size == 4096)
+		convert_to_4k(super);
 	return store_imsm_mpb(fd, mpb);
 #else
 	return 1;
@@ -7574,27 +7677,30 @@ static int store_imsm_mpb(int fd, struct imsm_super *mpb)
 	__u32 mpb_size = __le32_to_cpu(mpb->mpb_size);
 	unsigned long long dsize;
 	unsigned long long sectors;
+	unsigned int sector_size;
 
+	get_dev_sector_size(fd, NULL, &sector_size);
 	get_dev_size(fd, NULL, &dsize);
 
-	if (mpb_size > 512) {
+	if (mpb_size > sector_size) {
 		/* -1 to account for anchor */
-		sectors = mpb_sectors(mpb) - 1;
+		sectors = mpb_sectors(mpb, sector_size) - 1;
 
 		/* write the extended mpb to the sectors preceeding the anchor */
-		if (lseek64(fd, dsize - (512 * (2 + sectors)), SEEK_SET) < 0)
+		if (lseek64(fd, dsize - (sector_size * (2 + sectors)),
+		   SEEK_SET) < 0)
 			return 1;
 
-		if ((unsigned long long)write(fd, buf + 512, 512 * sectors)
-		    != 512 * sectors)
+		if ((unsigned long long)write(fd, buf + sector_size,
+		   sector_size * sectors) != sector_size * sectors)
 			return 1;
 	}
 
 	/* first block is stored on second to last sector of the disk */
-	if (lseek64(fd, dsize - (512 * 2), SEEK_SET) < 0)
+	if (lseek64(fd, dsize - (sector_size * 2), SEEK_SET) < 0)
 		return 1;
 
-	if (write(fd, buf, 512) != 512)
+	if (write(fd, buf, sector_size) != sector_size)
 		return 1;
 
 	return 0;
@@ -8830,6 +8936,7 @@ static int imsm_prepare_update(struct supertype *st,
 	 */
 	enum imsm_update_type type;
 	struct intel_super *super = st->sb;
+	unsigned int sector_size = super->sector_size;
 	struct imsm_super *mpb = super->anchor;
 	size_t buf_len;
 	size_t len = 0;
@@ -9066,12 +9173,13 @@ static int imsm_prepare_update(struct supertype *st,
 		 * if this allocation fails process_update will notice that
 		 * ->next_len is set and ->next_buf is NULL
 		 */
-		buf_len = ROUND_UP(__le32_to_cpu(mpb->mpb_size) + len, 512);
+		buf_len = ROUND_UP(__le32_to_cpu(mpb->mpb_size) + len,
+				  sector_size);
 		if (super->next_buf)
 			free(super->next_buf);
 
 		super->next_len = buf_len;
-		if (posix_memalign(&super->next_buf, 512, buf_len) == 0)
+		if (posix_memalign(&super->next_buf, sector_size, buf_len) == 0)
 			memset(super->next_buf, 0, buf_len);
 		else
 			super->next_buf = NULL;
@@ -9566,6 +9674,7 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 	int new_disks, i, err;
 	char *buf = NULL;
 	int retval = 1;
+	unsigned int sector_size = super->sector_size;
 	unsigned long curr_migr_unit = __le32_to_cpu(migr_rec->curr_migr_unit);
 	unsigned long num_migr_units = __le32_to_cpu(migr_rec->num_migr_units);
 	char buffer[20];
@@ -9602,7 +9711,7 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 			pba_of_lba0(map_dest)) * 512;
 
 	unit_len = __le32_to_cpu(migr_rec->dest_depth_per_unit) * 512;
-	if (posix_memalign((void **)&buf, 512, unit_len) != 0)
+	if (posix_memalign((void **)&buf, sector_size, unit_len) != 0)
 		goto abort;
 	targets = xcalloc(new_disks, sizeof(int));
 
@@ -10148,7 +10257,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 		 */
 		geo->size = imsm_component_size_aligment_check(
 				    get_imsm_raid_level(dev->vol.map),
-				    chunk * 1024,
+				    chunk * 1024, super->sector_size,
 				    geo->size * 2);
 		if (geo->size == 0) {
 			pr_err("Error. Size expansion is supported only (current size is %llu, requested size /rounded/ is 0).\n",
@@ -10182,7 +10291,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 			 */
 			max_size = imsm_component_size_aligment_check(
 					get_imsm_raid_level(dev->vol.map),
-					chunk * 1024,
+					chunk * 1024, super->sector_size,
 					max_size);
 		}
 		if (geo->size == MAX_SIZE) {
-- 
2.7.4

