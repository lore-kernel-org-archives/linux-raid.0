From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 23 of 27 - Move persistent from superblock to mddev
Date: Thu, 18 Jul 2002 23:34:21 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133421.5018@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Move persistent from superblock to mddev

Tidyup calc_dev_sboffset and calc_dev_size on the way



 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   59 ++++++++++++++++++++------------------------
 ./include/linux/raid/md_k.h |    2 +
 2 files changed, 30 insertions(+), 31 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:07:15	1.14
+++ ./drivers/md/md.c	2002/07/18 12:07:58	1.15
@@ -297,24 +297,20 @@ char * partition_name(kdev_t dev)
 	return dname->name;
 }
 
-static unsigned int calc_dev_sboffset(mdk_rdev_t *rdev, mddev_t *mddev,
-						int persistent)
+static unsigned int calc_dev_sboffset(struct block_device *bdev)
 {
-	unsigned int size = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
-	if (persistent)
-		size = MD_NEW_SIZE_BLOCKS(size);
-	return size;
+	unsigned int size = bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
+	return MD_NEW_SIZE_BLOCKS(size);
 }
 
-static unsigned int calc_dev_size(mdk_rdev_t *rdev, mddev_t *mddev, int persistent)
+static unsigned int calc_dev_size(struct block_device *bdev, mddev_t *mddev)
 {
 	unsigned int size;
 
-	size = calc_dev_sboffset(rdev, mddev, persistent);
-	if (!mddev->sb) {
-		MD_BUG();
-		return size;
-	}
+	if (mddev->persistent)
+		size = calc_dev_sboffset(bdev);
+	else
+		size = bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
 	if (mddev->sb->chunk_size)
 		size &= ~(mddev->sb->chunk_size/1024 - 1);
 	return size;
@@ -450,7 +446,7 @@ static int read_disk_sb(mdk_rdev_t * rde
 	 *
 	 * It also happens to be a multiple of 4Kb.
 	 */
-	sb_offset = calc_dev_sboffset(rdev, rdev->mddev, 1);
+	sb_offset = calc_dev_sboffset(rdev->bdev);
 	rdev->sb_offset = sb_offset;
 
 	if (!sync_page_io(rdev->bdev, sb_offset<<1, MD_SB_BYTES, rdev->sb_page, READ))
@@ -814,7 +810,7 @@ static int write_disk_sb(mdk_rdev_t * rd
 		return 1;
 	}
 
-	sb_offset = calc_dev_sboffset(rdev, rdev->mddev, 1);
+	sb_offset = calc_dev_sboffset(rdev->bdev);
 	if (rdev->sb_offset != sb_offset) {
 		printk(KERN_INFO "%s's sb offset has changed from %ld to %ld, skipping\n",
 		       partition_name(dev), rdev->sb_offset, sb_offset);
@@ -825,7 +821,7 @@ static int write_disk_sb(mdk_rdev_t * rd
 	 * its size has changed to zero silently, and the MD code does
 	 * not yet know that it's faulty.
 	 */
-	size = calc_dev_size(rdev, rdev->mddev, 1);
+	size = calc_dev_size(rdev->bdev, rdev->mddev);
 	if (size != rdev->size) {
 		printk(KERN_INFO "%s's size has changed from %ld to %ld since import, skipping\n",
 		       partition_name(dev), rdev->size, size);
@@ -863,6 +859,7 @@ static int sync_sbs(mddev_t * mddev)
 	int active=0, working=0,failed=0,spare=0,nr_disks=0;
 
 	sb = mddev->sb;
+	sb->not_persistent = !mddev->persistent;
 
 	sb->disks[0].state = (1<<MD_DISK_REMOVED);
 	ITERATE_RDEV(mddev,rdev,tmp) {
@@ -942,7 +939,7 @@ repeat:
 	 * do not write anything to disk if using
 	 * nonpersistent superblocks
 	 */
-	if (mddev->sb->not_persistent)
+	if (!mddev->persistent)
 		return;
 
 	printk(KERN_INFO "md: updating md%d RAID superblock on device\n",
@@ -1153,6 +1150,7 @@ static int analyze_sbs(mddev_t * mddev)
 	}
 	memcpy (sb, freshest->sb, sizeof(*sb));
 
+	mddev->persistent = ! sb->not_persistent;
 	/*
 	 * at this point we have picked the 'best' superblock
 	 * from all available superblocks.
@@ -1230,7 +1228,7 @@ abort:
 
 static int device_size_calculation(mddev_t * mddev)
 {
-	int data_disks = 0, persistent;
+	int data_disks = 0;
 	unsigned int readahead;
 	mdp_super_t *sb = mddev->sb;
 	struct list_head *tmp;
@@ -1241,7 +1239,7 @@ static int device_size_calculation(mddev
 	 * (we have to do this after having validated chunk_size,
 	 * because device size has to be modulo chunk_size)
 	 */
-	persistent = !mddev->sb->not_persistent;
+
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		if (rdev->faulty)
 			continue;
@@ -1249,7 +1247,7 @@ static int device_size_calculation(mddev
 			MD_BUG();
 			continue;
 		}
-		rdev->size = calc_dev_size(rdev, mddev, persistent);
+		rdev->size = calc_dev_size(rdev->bdev, mddev);
 		if (rdev->size < sb->chunk_size / 1024) {
 			printk(KERN_WARNING
 				"md: Dev %s smaller than chunk_size: %ldk < %dk\n",
@@ -1849,7 +1847,7 @@ static int get_array_info(mddev_t * mdde
 	SET_FROM_SB(nr_disks);
 	SET_FROM_SB(raid_disks);
 	SET_FROM_SB(md_minor);
-	SET_FROM_SB(not_persistent);
+	info.not_persistent= !mddev->persistent;
 
 	SET_FROM_SB(utime);
 	SET_FROM_SB(state);
@@ -1911,7 +1909,7 @@ static int get_disk_info(mddev_t * mddev
 
 static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 {
-	int size, persistent;
+	int size;
 	mdk_rdev_t *rdev;
 	kdev_t dev;
 	dev = mk_kdev(info->major,info->minor);
@@ -1958,12 +1956,11 @@ static int add_new_disk(mddev_t * mddev,
 
 		bind_rdev_to_array(rdev, mddev);
 
-		persistent = !mddev->sb->not_persistent;
-		if (!persistent)
+		if (!mddev->persistent)
 			printk(KERN_INFO "md: nonpersistent superblock ...\n");
 
-		size = calc_dev_size(rdev, mddev, persistent);
-		rdev->sb_offset = calc_dev_sboffset(rdev, mddev, persistent);
+		size = calc_dev_size(rdev->bdev, mddev);
+		rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
 
 		if (!mddev->sb->size || (mddev->sb->size > size))
 			mddev->sb->size = size;
@@ -2053,7 +2050,7 @@ busy:
 
 static int hot_add_disk(mddev_t * mddev, kdev_t dev)
 {
-	int i, err, persistent;
+	int i, err;
 	unsigned int size;
 	mdk_rdev_t *rdev;
 
@@ -2074,8 +2071,8 @@ static int hot_add_disk(mddev_t * mddev,
 		printk(KERN_WARNING "md: error, md_import_device() returned %ld\n", PTR_ERR(rdev));
 		return -EINVAL;
 	}
-	persistent = !mddev->sb->not_persistent;
-	size = calc_dev_size(rdev, mddev, persistent);
+
+	size = calc_dev_size(rdev->bdev, mddev);
 
 	if (size < mddev->sb->size) {
 		printk(KERN_WARNING "md%d: disk size %d blocks < array size %d\n",
@@ -2098,7 +2095,7 @@ static int hot_add_disk(mddev_t * mddev,
 	 * noticed in interrupt contexts ...
 	 */
 	rdev->size = size;
-	rdev->sb_offset = calc_dev_sboffset(rdev, mddev, persistent);
+	rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
 
 	for (i = mddev->sb->raid_disks; i < MD_SB_DISKS; i++)
 		if (find_rdev_nr(mddev,i)==NULL)
@@ -2155,7 +2152,7 @@ static int set_array_info(mddev_t * mdde
 	SET_SB(nr_disks);
 	SET_SB(raid_disks);
 	SET_SB(md_minor);
-	SET_SB(not_persistent);
+	mddev->persistent    = ! info->not_persistent;
 
 	SET_SB(state);
 
@@ -3329,7 +3326,7 @@ static struct {
  *             invoked program now).  Added ability to initialise all
  *             the MD devices (by specifying multiple "md=" lines)
  *             instead of just one.  -- KTK
- * 18May2000: Added support for persistant-superblock arrays:
+ * 18May2000: Added support for persistent-superblock arrays:
  *             md=n,0,factor,fault,device-list   uses RAID0 for device n
  *             md=n,-1,factor,fault,device-list  uses LINEAR for device n
  *             md=n,device-list      reads a RAID superblock from the devices
--- ./include/linux/raid/md_k.h	2002/07/18 12:07:15	1.9
+++ ./include/linux/raid/md_k.h	2002/07/18 12:07:58	1.10
@@ -175,6 +175,8 @@ struct mddev_s
 	int				sb_dirty;
 	int				ro;
 
+	int				persistent;
+
 	struct mdk_thread_s		*sync_thread;	/* doing resync or reconstruct */
 	unsigned long			curr_resync;	/* blocks scheduled */
 	unsigned long			resync_mark;	/* a recent timestamp */
