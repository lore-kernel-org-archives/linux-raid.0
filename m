From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 1/6] imsm: avoid overflows for disks over 1TB
Date: Thu, 29 Mar 2012 12:43:00 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B918A205CE@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Calculating array_blocks using info->size causes error on activation of
volume using disks over 1 TB. unsigned long long size parameter
is used instead.

total_blocks, pba_of_lba0, blocks_per_member and num_data_stripes overflow
when using disks over 2TB.

Part of fillers in metadata is used to contain hi bits of the numbers
that are likely to go over 32 bit limit.
Functions are added to get and set such fields as the hi bits are not
adjacent with low bits in the structures.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 super-intel.c |  198 +++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 131 insertions(+), 67 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 958edb5..9147016 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -95,15 +95,16 @@
 #define IMSM_MAX_DEVICES 255
 struct imsm_disk {
 	__u8 serial[MAX_RAID_SERIAL_LEN];/* 0xD8 - 0xE7 ascii serial number */
-	__u32 total_blocks;		 /* 0xE8 - 0xEB total blocks */
+	__u32 total_blocks_lo;		 /* 0xE8 - 0xEB total blocks lo */
 	__u32 scsi_id;			 /* 0xEC - 0xEF scsi ID */
 #define SPARE_DISK      __cpu_to_le32(0x01)  /* Spare */
 #define CONFIGURED_DISK __cpu_to_le32(0x02)  /* Member of some RaidDev */
 #define FAILED_DISK     __cpu_to_le32(0x04)  /* Permanent failure */
 	__u32 status;			 /* 0xF0 - 0xF3 */
 	__u32 owner_cfg_num; /* which config 0,1,2... owns this disk */ 
-#define	IMSM_DISK_FILLERS	4
-	__u32 filler[IMSM_DISK_FILLERS]; /* 0xF4 - 0x107 MPB_DISK_FILLERS for future expansion */
+	__u32 total_blocks_hi;		 /* 0xF4 - 0xF5 total blocks hi */
+#define	IMSM_DISK_FILLERS	3
+	__u32 filler[IMSM_DISK_FILLERS]; /* 0xF5 - 0x107 MPB_DISK_FILLERS for future expansion */
 };
 
 /* map selector for map managment
@@ -114,9 +115,9 @@ struct imsm_disk {
 
 /* RAID map configuration infos. */
 struct imsm_map {
-	__u32 pba_of_lba0;	/* start address of partition */
-	__u32 blocks_per_member;/* blocks per member */
-	__u32 num_data_stripes;	/* number of data stripes */
+	__u32 pba_of_lba0_lo;	/* start address of partition */
+	__u32 blocks_per_member_lo;/* blocks per member */
+	__u32 num_data_stripes_lo;	/* number of data stripes */
 	__u16 blocks_per_strip;
 	__u8  map_state;	/* Normal, Uninitialized, Degraded, Failed */
 #define IMSM_T_STATE_NORMAL 0
@@ -131,7 +132,10 @@ struct imsm_map {
 	__u8  num_domains;	/* number of parity domains */
 	__u8  failed_disk_num;  /* valid only when state is degraded */
 	__u8  ddf;
-	__u32 filler[7];	/* expansion area */
+	__u32 pba_of_lba0_hi;
+	__u32 blocks_per_member_hi;
+	__u32 num_data_stripes_hi;
+	__u32 filler[4];	/* expansion area */
 #define IMSM_ORD_REBUILD (1 << 24)
 	__u32 disk_ord_tbl[1];	/* disk_ord_tbl[num_members],
 				 * top byte contains some flags
@@ -361,7 +365,7 @@ struct intel_super {
 	size_t next_len;
 	int updates_pending; /* count of pending updates for mdmon */
 	int current_vol; /* index of raid device undergoing creation */
-	__u32 create_offset; /* common start for 'current_vol' */
+	unsigned long long create_offset; /* common start for 'current_vol' */
 	__u32 random; /* random data for seeding new family numbers */
 	struct intel_dev *devlist;
 	struct dl {
@@ -870,6 +874,69 @@ static int count_memberships(struct dl *dl, struct intel_super *super)
 
 static __u32 imsm_min_reserved_sectors(struct intel_super *super);
 
+static int split_ull(unsigned long long n, __u32 *lo, __u32 *hi)
+{
+	if (lo == 0 || hi == 0)
+		return 1;
+	*lo = __le32_to_cpu((unsigned)n);
+	*hi = __le32_to_cpu((unsigned)(n >> 32));
+	return 0;
+}
+
+static unsigned long long join_u32(__u32 lo, __u32 hi)
+{
+	return (unsigned long long)__le32_to_cpu(lo) |
+	       (((unsigned long long)__le32_to_cpu(hi)) << 32);
+}
+
+static unsigned long long total_blocks(struct imsm_disk *disk)
+{
+	if (disk == 0)
+		return 0;
+	return join_u32(disk->total_blocks_lo, disk->total_blocks_hi);
+}
+
+static unsigned long long pba_of_lba0(struct imsm_map *map)
+{
+	if (map == 0)
+		return 0;
+	return join_u32(map->pba_of_lba0_lo, map->pba_of_lba0_hi);
+}
+
+static unsigned long long blocks_per_member(struct imsm_map *map)
+{
+	if (map == 0)
+		return 0;
+	return join_u32(map->blocks_per_member_lo, map->blocks_per_member_hi);
+}
+
+static unsigned long long num_data_stripes(struct imsm_map *map)
+{
+	if (map == 0)
+		return 0;
+	return join_u32(map->num_data_stripes_lo, map->num_data_stripes_hi);
+}
+
+static void set_total_blocks(struct imsm_disk *disk, unsigned long long n)
+{
+	split_ull(n, &disk->total_blocks_lo, &disk->total_blocks_hi);
+}
+
+static void set_pba_of_lba0(struct imsm_map *map, unsigned long long n)
+{
+	split_ull(n, &map->pba_of_lba0_lo, &map->pba_of_lba0_hi);
+}
+
+static void set_blocks_per_member(struct imsm_map *map, unsigned long long n)
+{
+	split_ull(n, &map->blocks_per_member_lo, &map->blocks_per_member_hi);
+}
+
+static void set_num_data_stripes(struct imsm_map *map, unsigned long long n)
+{
+	split_ull(n, &map->num_data_stripes_lo, &map->num_data_stripes_hi);
+}
+
 static struct extent *get_extents(struct intel_super *super, struct dl *dl)
 {
 	/* find a list of used extents on the given physical device */
@@ -897,8 +964,8 @@ static struct extent *get_extents(struct intel_super *super, struct dl *dl)
 		struct imsm_map *map = get_imsm_map(dev, MAP_0);
 
 		if (get_imsm_disk_slot(map, dl->index) >= 0) {
-			e->start = __le32_to_cpu(map->pba_of_lba0);
-			e->size = __le32_to_cpu(map->blocks_per_member);
+			e->start = pba_of_lba0(map);
+			e->size = blocks_per_member(map);
 			e++;
 		}
 	}
@@ -911,10 +978,9 @@ static struct extent *get_extents(struct intel_super *super, struct dl *dl)
 	 */
 	if (memberships) {
 		struct extent *last = &rv[memberships - 1];
-		__u32 remainder;
+		unsigned long long remainder;
 
-		remainder = __le32_to_cpu(dl->disk.total_blocks) - 
-			    (last->start + last->size);
+		remainder = total_blocks(&dl->disk) - (last->start + last->size);
 		/* round down to 1k block to satisfy precision of the kernel
 		 * 'size' interface
 		 */
@@ -925,7 +991,7 @@ static struct extent *get_extents(struct intel_super *super, struct dl *dl)
 		if (reservation > remainder)
 			reservation = remainder;
 	}
-	e->start = __le32_to_cpu(dl->disk.total_blocks) - reservation;
+	e->start = total_blocks(&dl->disk) - reservation;
 	e->size = 0;
 	return rv;
 }
@@ -954,7 +1020,7 @@ static __u32 imsm_reserved_sectors(struct intel_super *super, struct dl *dl)
 	for (i = 0; e[i].size; i++)
 		continue;
 
-	rv = __le32_to_cpu(dl->disk.total_blocks) - e[i].start;
+	rv = total_blocks(&dl->disk) - e[i].start;
 
 	free(e);
 
@@ -984,7 +1050,8 @@ static __u32 imsm_min_reserved_sectors(struct intel_super *super)
 {
 	struct extent *e;
 	int i;
-	__u32 min_active, remainder;
+	unsigned long long min_active;
+	__u32 remainder;
 	__u32 rv = MPB_SECTOR_CNT + IMSM_RESERVED_SECTORS;
 	struct dl *dl, *dl_min = NULL;
 
@@ -995,9 +1062,10 @@ static __u32 imsm_min_reserved_sectors(struct intel_super *super)
 	for (dl = super->disks; dl; dl = dl->next) {
 		if (dl->index < 0)
 			continue;
-		if (dl->disk.total_blocks < min_active || min_active == 0) {
+		unsigned long long blocks = total_blocks(&dl->disk);
+		if (blocks < min_active || min_active == 0) {
 			dl_min = dl;
-			min_active = dl->disk.total_blocks;
+			min_active = blocks;
 		}
 	}
 	if (!dl_min)
@@ -1115,13 +1183,13 @@ static void print_imsm_dev(struct intel_super *super,
 	sz += __le32_to_cpu(dev->size_low);
 	printf("     Array Size : %llu%s\n", (unsigned long long)sz,
 	       human_size(sz * 512));
-	sz = __le32_to_cpu(map->blocks_per_member);
+	sz = blocks_per_member(map);
 	printf("   Per Dev Size : %llu%s\n", (unsigned long long)sz,
 	       human_size(sz * 512));
-	printf("  Sector Offset : %u\n",
-		__le32_to_cpu(map->pba_of_lba0));
-	printf("    Num Stripes : %u\n",
-		__le32_to_cpu(map->num_data_stripes));
+	printf("  Sector Offset : %llu\n",
+		pba_of_lba0(map));
+	printf("    Num Stripes : %llu\n",
+		num_data_stripes(map));
 	printf("     Chunk Size : %u KiB",
 		__le16_to_cpu(map->blocks_per_strip) / 2);
 	if (map2)
@@ -1182,7 +1250,7 @@ static void print_imsm_disk(struct imsm_disk *disk, int index, __u32 reserved)
 					    is_configured(disk) ? " active" : "",
 					    is_failed(disk) ? " failed" : "");
 	printf("             Id : %08x\n", __le32_to_cpu(disk->scsi_id));
-	sz = __le32_to_cpu(disk->total_blocks) - reserved;
+	sz = total_blocks(disk) - reserved;
 	printf("    Usable Size : %llu%s\n", (unsigned long long)sz,
 	       human_size(sz * 512));
 }
@@ -2462,9 +2530,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 							  dl->index);
 	}
 
-	info->data_offset	  = __le32_to_cpu(map_to_analyse->pba_of_lba0);
-	info->component_size	  =
-		__le32_to_cpu(map_to_analyse->blocks_per_member);
+	info->data_offset	  = pba_of_lba0(map_to_analyse);
+	info->component_size	  = blocks_per_member(map_to_analyse);
 
 	/* check component size aligment
 	 */
@@ -2525,7 +2592,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 
 			used_disks = imsm_num_data_members(dev, MAP_1);
 			if (used_disks > 0) {
-				array_blocks = map->blocks_per_member *
+				array_blocks = blocks_per_member(map) *
 					used_disks;
 				/* round array size down to closest MB
 				 */
@@ -2709,7 +2776,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 		__u32 reserved = imsm_reserved_sectors(super, super->disks);
 
 		disk = &super->disks->disk;
-		info->data_offset = __le32_to_cpu(disk->total_blocks) - reserved;
+		info->data_offset = total_blocks(&super->disks->disk) - reserved;
 		info->component_size = reserved;
 		info->disk.state  = is_configured(disk) ? (1 << MD_DISK_ACTIVE) : 0;
 		/* we don't change info->disk.raid_disk here because
@@ -3377,7 +3444,7 @@ int check_mpb_migr_compatibility(struct intel_super *super)
 			/* This device is migrating */
 			map0 = get_imsm_map(dev_iter, MAP_0);
 			map1 = get_imsm_map(dev_iter, MAP_1);
-			if (map0->pba_of_lba0 != map1->pba_of_lba0)
+			if (pba_of_lba0(map0) != pba_of_lba0(map1))
 				/* migration optimization area was used */
 				return -1;
 			if (migr_rec->ascending_migr == 0
@@ -3626,7 +3693,7 @@ static struct intel_super *alloc_super(void)
 	if (super) {
 		memset(super, 0, sizeof(*super));
 		super->current_vol = -1;
-		super->create_offset = ~((__u32 ) 0);
+		super->create_offset = ~((unsigned long long) 0);
 	}
 	return super;
 }
@@ -4346,22 +4413,13 @@ static __u16 info_to_blocks_per_strip(mdu_array_info_t *info)
 	return info->chunk_size >> 9;
 }
 
-static __u32 info_to_num_data_stripes(mdu_array_info_t *info, int num_domains)
-{
-	__u32 num_stripes;
-
-	num_stripes = (info->size * 2) / info_to_blocks_per_strip(info);
-	num_stripes /= num_domains;
-
-	return num_stripes;
-}
-
-static __u32 info_to_blocks_per_member(mdu_array_info_t *info)
+static unsigned long long info_to_blocks_per_member(mdu_array_info_t *info,
+						    unsigned long long size)
 {
 	if (info->level == 1)
-		return info->size * 2;
+		return size * 2;
 	else
-		return (info->size * 2) & ~(info_to_blocks_per_strip(info) - 1);
+		return (size * 2) & ~(info_to_blocks_per_strip(info) - 1);
 }
 
 static void imsm_update_version_info(struct intel_super *super)
@@ -4452,7 +4510,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	int i;
 	unsigned long long array_blocks;
 	size_t size_old, size_new;
-	__u32 num_data_stripes;
+	unsigned long long num_data_stripes;
 
 	if (super->orom && mpb->num_raid_devs >= super->orom->vpa) {
 		fprintf(stderr, Name": This imsm-container already has the "
@@ -4540,11 +4598,11 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 
 	strncpy((char *) dev->volume, name, MAX_RAID_SERIAL_LEN);
 	if (info->level == 1)
-		array_blocks = info_to_blocks_per_member(info);
+		array_blocks = info_to_blocks_per_member(info, size);
 	else
 		array_blocks = calc_array_size(info->level, info->raid_disks,
 					       info->layout, info->chunk_size,
-					       info->size*2);
+					       size * 2);
 	/* round array size down to closest MB */
 	array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
 
@@ -4557,8 +4615,8 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	vol->dirty = !info->state;
 	vol->curr_migr_unit = 0;
 	map = get_imsm_map(dev, MAP_0);
-	map->pba_of_lba0 = __cpu_to_le32(super->create_offset);
-	map->blocks_per_member = __cpu_to_le32(info_to_blocks_per_member(info));
+	set_pba_of_lba0(map, super->create_offset);
+	set_blocks_per_member(map, info_to_blocks_per_member(info, size));
 	map->blocks_per_strip = __cpu_to_le16(info_to_blocks_per_strip(info));
 	map->failed_disk_num = ~0;
 	if (info->level > 0)
@@ -4585,8 +4643,10 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	else
 		map->num_domains = 1;
 
-	num_data_stripes = info_to_num_data_stripes(info, map->num_domains);
-	map->num_data_stripes = __cpu_to_le32(num_data_stripes);
+	/* info->size is only int so use the 'size' parameter instead */
+	num_data_stripes = (size * 2) / info_to_blocks_per_strip(info);
+	num_data_stripes /= map->num_domains;
+	set_num_data_stripes(map, num_data_stripes);
 
 	map->num_members = info->raid_disks;
 	for (i = 0; i < map->num_members; i++) {
@@ -4729,8 +4789,8 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 	 */
 	if (super->current_vol == 0) {
 		for (df = super->missing; df; df = df->next) {
-			if (dl->disk.total_blocks > df->disk.total_blocks)
-				df->disk.total_blocks = dl->disk.total_blocks;
+			if (total_blocks(&dl->disk) > total_blocks(&df->disk))
+				set_total_blocks(&df->disk, total_blocks(&dl->disk));
 			_disk = __get_imsm_disk(mpb, df->index);
 			*_disk = df->disk;
 		}
@@ -4869,7 +4929,11 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	get_dev_size(fd, NULL, &size);
 	size /= 512;
 	serialcpy(dd->disk.serial, dd->serial);
-	dd->disk.total_blocks = __cpu_to_le32(size);
+	set_total_blocks(&dd->disk, size);
+	if (__le32_to_cpu(dd->disk.total_blocks_hi) > 0) {
+		struct imsm_super *mpb = super->anchor;
+		mpb->attributes |= MPB_ATTRIB_2TB_DISK;
+	}
 	mark_spare(dd);
 	if (sysfs_disk_to_scsi_id(fd, &id) == 0)
 		dd->disk.scsi_id = __cpu_to_le32(id);
@@ -5356,7 +5420,7 @@ static unsigned long long merge_extents(struct intel_super *super, int sum_exten
 	if (maxsize < reserve)
 		return 0;
 
-	super->create_offset = ~((__u32) 0);
+	super->create_offset = ~((unsigned long long) 0);
 	if (start + reserve > super->create_offset)
 		return 0; /* start overflows create_offset */
 	super->create_offset = start + reserve;
@@ -6597,8 +6661,8 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 				this->array.working_disks++;
 
 			info_d->events = __le32_to_cpu(mpb->generation_num);
-			info_d->data_offset = __le32_to_cpu(map->pba_of_lba0);
-			info_d->component_size = __le32_to_cpu(map->blocks_per_member);
+			info_d->data_offset = pba_of_lba0(map);
+			info_d->component_size = blocks_per_member(map);
 		}
 		/* now that the disk list is up-to-date fixup recovery_start */
 		update_recovery_start(super, dev, this);
@@ -6882,7 +6946,7 @@ static unsigned long long imsm_set_array_size(struct imsm_dev *dev)
 	/* set array size in metadata
 	 */
 	map = get_imsm_map(dev, MAP_0);
-	array_blocks = map->blocks_per_member * used_disks;
+	array_blocks = blocks_per_member(map) * used_disks;
 
 	/* round array size down to closest MB
 	 */
@@ -6997,7 +7061,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 				used_disks = imsm_num_data_members(dev, MAP_0);
 				if (used_disks > 0) {
 					array_blocks =
-						map->blocks_per_member *
+						blocks_per_member(map) *
 						used_disks;
 					/* round array size down to closest MB
 					 */
@@ -7364,9 +7428,9 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 			found = 0;
 			j = 0;
 			pos = 0;
-			array_start = __le32_to_cpu(map->pba_of_lba0);
+			array_start = pba_of_lba0(map);
 			array_end = array_start +
-				    __le32_to_cpu(map->blocks_per_member) - 1;
+				    blocks_per_member(map) - 1;
 
 			do {
 				/* check that we can start at pba_of_lba0 with
@@ -7566,7 +7630,7 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 		di->disk.minor = dl->minor;
 		di->disk.state = 0;
 		di->recovery_start = 0;
-		di->data_offset = __le32_to_cpu(map->pba_of_lba0);
+		di->data_offset = pba_of_lba0(map);
 		di->component_size = a->info.component_size;
 		di->container_member = inst;
 		super->random = random32();
@@ -8292,8 +8356,8 @@ static void imsm_process_update(struct supertype *st,
 		}
 
 		new_map = get_imsm_map(&u->dev, MAP_0);
-		new_start = __le32_to_cpu(new_map->pba_of_lba0);
-		new_end = new_start + __le32_to_cpu(new_map->blocks_per_member);
+		new_start = pba_of_lba0(new_map);
+		new_end = new_start + blocks_per_member(new_map);
 		inf = get_disk_info(u);
 
 		/* handle activate_spare versus create race:
@@ -8303,8 +8367,8 @@ static void imsm_process_update(struct supertype *st,
 		for (i = 0; i < mpb->num_raid_devs; i++) {
 			dev = get_imsm_dev(super, i);
 			map = get_imsm_map(dev, MAP_0);
-			start = __le32_to_cpu(map->pba_of_lba0);
-			end = start + __le32_to_cpu(map->blocks_per_member);
+			start = pba_of_lba0(map);
+			end = start + blocks_per_member(map);
 			if ((new_start >= start && new_start <= end) ||
 			    (start >= new_start && start <= new_end))
 				/* overlap */;
@@ -9165,7 +9229,7 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 
 	write_offset = ((unsigned long long)
 			__le32_to_cpu(migr_rec->dest_1st_member_lba) +
-			__le32_to_cpu(map_dest->pba_of_lba0)) * 512;
+			pba_of_lba0(map_dest)) * 512;
 
 	unit_len = __le32_to_cpu(migr_rec->dest_depth_per_unit) * 512;
 	if (posix_memalign((void **)&buf, 512, unit_len) != 0)
-- 
1.6.4.2

