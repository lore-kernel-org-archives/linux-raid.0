From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 3 - Avoid buffer cache when doing IO of RAID superblock.
Date: Tue, 17 Dec 2002 13:00:49 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18O72P-0000pU-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



superblock IO sometimes happens when memory might be tight,
and can lead to a deadlock if raid1d or raid5d initiate it.

With this patch, superblock IO happens without any memory
allocation.


 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   82 ++++++++++++++++++++++++--------------------
 ./include/linux/raid/md_k.h |    1 
 2 files changed, 47 insertions(+), 36 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2002-12-16 16:29:19.000000000 +1100
+++ ./drivers/md/md.c	2002-12-16 16:29:27.000000000 +1100
@@ -445,21 +445,22 @@ static int alloc_disk_sb(mdk_rdev_t * rd
 	if (rdev->sb)
 		MD_BUG();
 
-	rdev->sb = (mdp_super_t *) __get_free_page(GFP_KERNEL);
-	if (!rdev->sb) {
+	rdev->sb_page = alloc_page(GFP_KERNEL);
+	if (!rdev->sb_page) {
 		printk(OUT_OF_MEM);
 		return -EINVAL;
 	}
-	md_clear_page(rdev->sb);
+	rdev->sb = (mdp_super_t *) page_address(rdev->sb_page);
 
 	return 0;
 }
 
 static void free_disk_sb(mdk_rdev_t * rdev)
 {
-	if (rdev->sb) {
-		free_page((unsigned long) rdev->sb);
+	if (rdev->sb_page) {
+		page_cache_release(rdev->sb_page);
 		rdev->sb = NULL;
+		rdev->sb_page = NULL;
 		rdev->sb_offset = 0;
 		rdev->size = 0;
 	} else {
@@ -468,12 +469,43 @@ static void free_disk_sb(mdk_rdev_t * rd
 	}
 }
 
+
+static void bh_complete(struct buffer_head *bh, int uptodate)
+{
+
+	if (uptodate)
+		set_bit(BH_Uptodate, &bh->b_state);
+
+	complete((struct completion*)bh->b_private);
+}
+
+static int sync_page_io(kdev_t dev, unsigned long sector, int size,
+			struct page *page, int rw)
+{
+	struct buffer_head bh;
+	struct completion event;
+
+	init_completion(&event);
+	init_buffer(&bh, bh_complete, &event);
+	bh.b_rdev = dev;
+	bh.b_rsector = sector;
+	bh.b_state	= (1 << BH_Req) | (1 << BH_Mapped);
+	bh.b_size = size;
+	bh.b_page = page;
+	bh.b_reqnext = NULL;
+	bh.b_data = page_address(page);
+	generic_make_request(rw, &bh);
+
+	run_task_queue(&tq_disk);
+	wait_for_completion(&event);
+
+	return test_bit(BH_Uptodate, &bh.b_state);
+}
+
 static int read_disk_sb(mdk_rdev_t * rdev)
 {
 	int ret = -EINVAL;
-	struct buffer_head *bh = NULL;
 	kdev_t dev = rdev->dev;
-	mdp_super_t *sb;
 	unsigned long sb_offset;
 
 	if (!rdev->sb) {
@@ -487,22 +519,14 @@ static int read_disk_sb(mdk_rdev_t * rde
 	 */
 	sb_offset = calc_dev_sboffset(rdev->dev, rdev->mddev, 1);
 	rdev->sb_offset = sb_offset;
-	fsync_dev(dev);
-	set_blocksize (dev, MD_SB_BYTES);
-	bh = bread (dev, sb_offset / MD_SB_BLOCKS, MD_SB_BYTES);
-
-	if (bh) {
-		sb = (mdp_super_t *) bh->b_data;
-		memcpy (rdev->sb, sb, MD_SB_BYTES);
-	} else {
-		printk(NO_SB,partition_name(rdev->dev));
-		goto abort;
+
+	if (!sync_page_io(dev, sb_offset<<1, MD_SB_BYTES, rdev->sb_page, READ)) {
+		printk(NO_SB,partition_name(dev));
+		return -EINVAL;
 	}
 	printk(KERN_INFO " [events: %08lx]\n", (unsigned long)rdev->sb->events_lo);
 	ret = 0;
 abort:
-	if (bh)
-		brelse (bh);
 	return ret;
 }
 
@@ -890,10 +914,8 @@ static mdk_rdev_t * find_rdev_all(kdev_t
 
 static int write_disk_sb(mdk_rdev_t * rdev)
 {
-	struct buffer_head *bh;
 	kdev_t dev;
 	unsigned long sb_offset, size;
-	mdp_super_t *sb;
 
 	if (!rdev->sb) {
 		MD_BUG();
@@ -928,23 +950,11 @@ static int write_disk_sb(mdk_rdev_t * rd
 	}
 
 	printk(KERN_INFO "(write) %s's sb offset: %ld\n", partition_name(dev), sb_offset);
-	fsync_dev(dev);
-	set_blocksize(dev, MD_SB_BYTES);
-	bh = getblk(dev, sb_offset / MD_SB_BLOCKS, MD_SB_BYTES);
-	if (!bh) {
-		printk(GETBLK_FAILED, partition_name(dev));
+
+	if (!sync_page_io(dev, sb_offset<<1, MD_SB_BYTES, rdev->sb_page, WRITE)) {
+		printk("md: write_disk_sb failed for device %s\n", partition_name(dev));
 		return 1;
 	}
-	memset(bh->b_data,0,bh->b_size);
-	sb = (mdp_super_t *) bh->b_data;
-	memcpy(sb, rdev->sb, MD_SB_BYTES);
-
-	mark_buffer_uptodate(bh, 1);
-	mark_buffer_dirty(bh);
-	ll_rw_block(WRITE, 1, &bh);
-	wait_on_buffer(bh);
-	brelse(bh);
-	fsync_dev(dev);
 skip:
 	return 0;
 }

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2002-12-16 16:29:27.000000000 +1100
+++ ./include/linux/raid/md_k.h	2002-12-16 16:29:27.000000000 +1100
@@ -171,6 +171,7 @@ struct mdk_rdev_s
 	struct block_device *bdev;	/* block device handle */
 
 	mdp_super_t *sb;
+	struct page *sb_page;
 	unsigned long sb_offset;
 
 	int alias_device;		/* device alias to the same disk */
