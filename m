From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 12 of 12 - Add new superblock format for md
Date: Wed, 12 Mar 2003 14:59:38 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18sxP0-0004qW-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

Superblock format '1' resolves a number of issues with
superblock format '0'.
It is more dense and can support many more sub-devices.
It does not contains un-needed redundancy.
It adds a few new useful fields

 ----------- Diffstat output ------------
 ./drivers/md/md.c           |  213 +++++++++++++++++++++++++++++++++++++++++++-
 ./include/linux/raid/md_p.h |   53 ++++++++++
 2 files changed, 264 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-12 13:46:37.000000000 +1100
+++ ./drivers/md/md.c	2003-03-12 13:46:39.000000000 +1100
@@ -763,6 +763,210 @@ static void super_90_sync(mddev_t *mddev
 	sb->sb_csum = calc_sb_csum(sb);
 }
 
+/*
+ * version 1 superblock
+ */
+
+static unsigned int calc_sb_1_csum(struct mdp_superblock_1 * sb)
+{
+	unsigned int disk_csum, csum;
+	int size = 256 + sb->max_dev*2;
+
+	disk_csum = sb->sb_csum;
+	sb->sb_csum = 0;
+	csum = csum_partial((void *)sb, size, 0);
+	sb->sb_csum = disk_csum;
+	return csum;
+}
+
+static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
+{
+	struct mdp_superblock_1 *sb;
+	int ret;
+	sector_t sb_offset;
+
+	/*
+	 * Calculate the position of the superblock.
+	 * It is always aligned to a 4K boundary and
+	 * depeding on minor_version, it can be:
+	 * 0: At least 8K, but less than 12K, from end of device
+	 * 1: At start of device
+	 * 2: 4K from start of device.
+	 */
+	switch(minor_version) {
+	case 0:
+		sb_offset = rdev->bdev->bd_inode->i_size >> 9;
+		sb_offset -= 8*2;
+		sb_offset &= ~(4*2);
+		/* convert from sectors to K */
+		sb_offset /= 2;
+		break;
+	case 1:
+		sb_offset = 0;
+		break;
+	case 2:
+		sb_offset = 4;
+		break;
+	default:
+		return -EINVAL;
+	}
+	rdev->sb_offset = sb_offset;
+
+	ret = read_disk_sb(rdev);
+	if (ret) return ret;
+
+
+	sb = (struct mdp_superblock_1*)page_address(rdev->sb_page);
+
+	if (sb->magic != cpu_to_le32(MD_SB_MAGIC) ||
+	    sb->major_version != cpu_to_le32(1) ||
+	    le32_to_cpu(sb->max_dev) > (4096-256)/2 ||
+	    le64_to_cpu(sb->super_offset) != (rdev->sb_offset<<1) ||
+	    sb->feature_map != 0)
+		return -EINVAL;
+
+	if (calc_sb_1_csum(sb) != sb->sb_csum) {
+		printk(BAD_CSUM, bdev_partition_name(rdev->bdev));
+		return -EINVAL;
+	}
+	rdev->preferred_minor = 0xffff;
+	rdev->data_offset = le64_to_cpu(sb->data_offset);
+
+	if (refdev == 0)
+		return 1;
+	else {
+		__u64 ev1, ev2;
+		struct mdp_superblock_1 *refsb = 
+			(struct mdp_superblock_1*)page_address(refdev->sb_page);
+
+		if (memcmp(sb->set_uuid, refsb->set_uuid, 16) != 0 ||
+		    sb->level != refsb->level ||
+		    sb->layout != refsb->layout ||
+		    sb->chunksize != refsb->chunksize) {
+			printk(KERN_WARNING "md: %s has strangely different superblock to %s\n",
+			       bdev_partition_name(rdev->bdev),
+			       bdev_partition_name(refdev->bdev));
+			return -EINVAL;
+		}
+		ev1 = le64_to_cpu(sb->events);
+		ev2 = le64_to_cpu(refsb->events);
+
+		if (ev1 > ev2)
+			return 1;
+	}
+	if (minor_version) 
+		rdev->size = ((rdev->bdev->bd_inode->i_size>>9) - le64_to_cpu(sb->data_offset)) / 2;
+	else
+		rdev->size = rdev->sb_offset;
+	if (rdev->size < le64_to_cpu(sb->data_size)/2)
+		return -EINVAL;
+	rdev->size = le64_to_cpu(sb->data_size)/2;
+	if (le32_to_cpu(sb->chunksize))
+		rdev->size &= ~((sector_t)le32_to_cpu(sb->chunksize)/2 - 1);
+	return 0;
+}
+
+static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	struct mdp_superblock_1 *sb = (struct mdp_superblock_1*)page_address(rdev->sb_page);
+
+	if (mddev->raid_disks == 0) {
+		mddev->major_version = 1;
+		mddev->minor_version = 0;
+		mddev->patch_version = 0;
+		mddev->persistent = 1;
+		mddev->chunk_size = le32_to_cpu(sb->chunksize) << 9;
+		mddev->ctime = le64_to_cpu(sb->ctime) & ((1ULL << 32)-1);
+		mddev->utime = le64_to_cpu(sb->utime) & ((1ULL << 32)-1);
+		mddev->level = le32_to_cpu(sb->level);
+		mddev->layout = le32_to_cpu(sb->layout);
+		mddev->raid_disks = le32_to_cpu(sb->raid_disks);
+		mddev->size = (u32)le64_to_cpu(sb->size);
+		mddev->events = le64_to_cpu(sb->events);
+		
+		mddev->recovery_cp = le64_to_cpu(sb->resync_offset);
+		memcpy(mddev->uuid, sb->set_uuid, 16);
+
+		mddev->max_disks =  (4096-256)/2;
+	} else {
+		__u64 ev1;
+		ev1 = le64_to_cpu(sb->events);
+		++ev1;
+		if (ev1 < mddev->events)
+			return -EINVAL;
+	}
+
+	if (mddev->level != LEVEL_MULTIPATH) {
+		int role;
+		rdev->desc_nr = le32_to_cpu(sb->dev_number);
+		role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
+		switch(role) {
+		case 0xffff: /* spare */
+			rdev->in_sync = 0;
+			rdev->faulty = 0;
+			rdev->raid_disk = -1;
+			break;
+		case 0xfffe: /* faulty */
+			rdev->in_sync = 0;
+			rdev->faulty = 1;
+			rdev->raid_disk = -1;
+			break;
+		default:
+			rdev->in_sync = 1;
+			rdev->faulty = 0;
+			rdev->raid_disk = role;
+			break;
+		}
+	}
+	return 0;
+}
+
+static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	struct mdp_superblock_1 *sb;
+	struct list_head *tmp;
+	mdk_rdev_t *rdev2;
+	int max_dev, i;
+	/* make rdev->sb match mddev and rdev data. */
+
+	sb = (struct mdp_superblock_1*)page_address(rdev->sb_page);
+
+	sb->feature_map = 0;
+	sb->pad0 = 0;
+	memset(sb->pad1, 0, sizeof(sb->pad1));
+	memset(sb->pad2, 0, sizeof(sb->pad2));
+	memset(sb->pad3, 0, sizeof(sb->pad3));
+
+	sb->utime = cpu_to_le64((__u64)mddev->utime);
+	sb->events = cpu_to_le64(mddev->events);
+	if (mddev->in_sync)
+		sb->resync_offset = cpu_to_le64(mddev->recovery_cp);
+	else
+		sb->resync_offset = cpu_to_le64(0);
+
+	max_dev = 0;
+	ITERATE_RDEV(mddev,rdev2,tmp)
+		if (rdev2->desc_nr > max_dev)
+			max_dev = rdev2->desc_nr;
+	
+	sb->max_dev = max_dev;
+	for (i=0; i<max_dev;i++)
+		sb->dev_roles[max_dev] = cpu_to_le16(0xfffe);
+	
+	ITERATE_RDEV(mddev,rdev2,tmp) {
+		i = rdev2->desc_nr;
+		if (rdev2->faulty)
+			sb->dev_roles[i] = cpu_to_le16(0xfffe);
+		else if (rdev2->in_sync)
+			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
+		else
+			sb->dev_roles[i] = cpu_to_le16(0xffff);
+	}
+
+	sb->recovery_offset = cpu_to_le64(0); /* not supported yet */
+}
+
+
 struct super_type super_types[] = {
 	[0] = {
 		.name	= "0.90.0",
@@ -771,9 +975,14 @@ struct super_type super_types[] = {
 		.validate_super	= super_90_validate,
 		.sync_super	= super_90_sync,
 	},
+	[1] = {
+		.name	= "md-1",
+		.owner	= THIS_MODULE,
+		.load_super	= super_1_load,
+		.validate_super	= super_1_validate,
+		.sync_super	= super_1_sync,
+	},
 };
-
-
 	
 static mdk_rdev_t * match_dev_unit(mddev_t *mddev, mdk_rdev_t *dev)
 {

diff ./include/linux/raid/md_p.h~current~ ./include/linux/raid/md_p.h
--- ./include/linux/raid/md_p.h~current~	2003-03-12 13:46:37.000000000 +1100
+++ ./include/linux/raid/md_p.h	2003-03-12 13:46:39.000000000 +1100
@@ -173,5 +173,58 @@ static inline __u64 md_event(mdp_super_t
 	return (ev<<32)| sb->events_lo;
 }
 
+/*
+ * The version-1 superblock :
+ * All numeric fields are little-endian.
+ *
+ * total size: 256 bytes plus 2 per device.
+ *  1K allows 384 devices.
+ */
+struct mdp_superblock_1 {
+	/* constant array information - 128 bytes */
+	__u32	magic;		/* MD_SB_MAGIC: 0xa92b4efc - little endian */
+	__u32	major_version;	/* 1 */
+	__u32	feature_map;	/* 0 for now */
+	__u32	pad0;		/* always set to 0 when writing */
+
+	__u8	set_uuid[16];	/* user-space generated. */
+	char	set_name[32];	/* set and interpreted by user-space */
+
+	__u64	ctime;		/* lo 40 bits are seconds, top 24 are microseconds or 0*/
+	__u32	level;		/* -4 (multipath), -1 (linear), 0,1,4,5 */
+	__u32	layout;		/* only for raid5 currently */
+	__u64	size;		/* used size of component devices, in 512byte sectors */
+
+	__u32	chunksize;	/* in 512byte sectors */
+	__u32	raid_disks;
+	__u8	pad1[128-92];	/* set to 0 when written */
+
+	/* constant this-device information - 64 bytes */
+	__u64	data_offset;	/* sector start of data, often 0 */
+	__u64	data_size;	/* sectors in this device that can be used for data */
+	__u64	super_offset;	/* sector start of this superblock */
+	__u64	recovery_offset;/* sectors before this offset (from data_offset) have been recovered */
+	__u32	dev_number;	/* permanent identifier of this  device - not role in raid */
+	__u32	cnt_corrected_read; /* number of read errors that were corrected by re-writing */
+	__u8	device_uuid[16]; /* user-space setable, ignored by kernel */
+	__u8	pad2[64-56];	/* set to 0 when writing */
+
+	/* array state information - 64 bytes */
+	__u64	utime;		/* 40 bits second, 24 btes microseconds */
+	__u64	events;		/* incremented when superblock updated */
+	__u64	resync_offset;	/* data before this offset (from data_offset) known to be in sync */
+	__u32	sb_csum;	/* checksum upto devs[max_dev] */
+	__u32	max_dev;	/* size of devs[] array to consider */
+	__u8	pad3[64-40];	/* set to 0 when writing */
+
+	/* device state information. Indexed by dev_number.
+	 * 2 bytes per device
+	 * Note there are no per-device state flags. State information is rolled
+	 * into the 'roles' value.  If a device is spare or faulty, then it doesn't
+	 * have a meaningful role.
+	 */
+	__u16	dev_roles[0];	/* role in array, or 0xffff for a spare, or 0xfffe for faulty */
+};
+
 #endif 
 
