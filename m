From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - raid in 2.5.15 - 1 of 3 - Change MD Superblock IO to go straight to submit_bio
Date: Wed, 15 May 2002 15:22:11 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15585.61571.485873.565925@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is the first of three patches which combine to make raid5 work in
2.5.15.  Most of the work is in the third patch.
There is still more work to do, but with these patches it seems to
work, at least for ext2 with 1K and 4K block sizes.

NeilBrown


### Comments for ChangeSet
The current code hits the page cache for the block device
which requires memory allocation which can sometimes cause
a deadlock (if it blocks the raid5d thread).

This code takes the page that holds the superblock, and
passes it to submit_bh in a suitable bio wrapper.


 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   92 +++++++++++++++++++++-----------------------
 ./include/linux/raid/md_k.h |    5 +-
 2 files changed, 48 insertions(+), 49 deletions(-)

--- ./include/linux/raid/md_k.h	2002/05/15 01:16:20	1.1
+++ ./include/linux/raid/md_k.h	2002/05/15 04:07:51	1.2
@@ -169,8 +169,9 @@
 
 	struct block_device *bdev;	/* block device handle */
 
-	mdp_super_t *sb;
-	unsigned long sb_offset;
+	struct page	*sb_page;
+	mdp_super_t	*sb;
+	unsigned long	sb_offset;
 
 	int alias_device;		/* device alias to the same disk */
 	int faulty;			/* if faulty do not issue IO requests */
--- ./drivers/md/md.c	2002/05/14 05:38:33	1.1
+++ ./drivers/md/md.c	2002/05/15 04:07:51	1.2
@@ -436,14 +436,15 @@
 
 static int alloc_disk_sb(mdk_rdev_t * rdev)
 {
-	if (rdev->sb)
+	if (rdev->sb_page)
 		MD_BUG();
 
-	rdev->sb = (mdp_super_t *) __get_free_page(GFP_KERNEL);
-	if (!rdev->sb) {
+	rdev->sb_page = alloc_page(GFP_KERNEL);
+	if (!rdev->sb_page) {
 		printk(OUT_OF_MEM);
 		return -EINVAL;
 	}
+	rdev->sb = (mdp_super_t *) page_address(rdev->sb_page);
 	clear_page(rdev->sb);
 
 	return 0;
@@ -451,9 +452,10 @@
 
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
@@ -462,13 +464,42 @@
 	}
 }
 
+
+static void bi_complete(struct bio *bio)
+{
+	complete((struct completion*)bio->bi_private);
+}
+
+static int sync_page_io(struct block_device *bdev, sector_t sector, int size,
+		   struct page *page, int rw)
+{
+	struct bio bio;
+	struct bio_vec vec;
+	struct completion event;
+
+	bio_init(&bio);
+	bio.bi_io_vec = &vec;
+	vec.bv_page = page;
+	vec.bv_len = size;
+	vec.bv_offset = 0;
+	bio.bi_vcnt = 1;
+	bio.bi_idx = 0;
+	bio.bi_size = size;
+	bio.bi_bdev = bdev;
+	bio.bi_sector = sector;
+	init_completion(&event);
+	bio.bi_private = &event;
+	bio.bi_end_io = bi_complete;
+	submit_bio(rw, &bio);
+	run_task_queue(&tq_disk);
+	wait_for_completion(&event);
+
+	return test_bit(BIO_UPTODATE, &bio.bi_flags);
+}
+
 static int read_disk_sb(mdk_rdev_t * rdev)
 {
-	struct address_space *mapping = rdev->bdev->bd_inode->i_mapping;
-	struct page *page;
-	char *p;
 	unsigned long sb_offset;
-	int n = PAGE_CACHE_SIZE / BLOCK_SIZE;
 
 	if (!rdev->sb) {
 		MD_BUG();
@@ -483,24 +514,14 @@
 	 */
 	sb_offset = calc_dev_sboffset(rdev->dev, rdev->mddev, 1);
 	rdev->sb_offset = sb_offset;
-	page = read_cache_page(mapping, sb_offset/n,
-			(filler_t *)mapping->a_ops->readpage, NULL);
-	if (IS_ERR(page))
-		goto out;
-	wait_on_page_locked(page);
-	if (!PageUptodate(page))
-		goto fail;
-	if (PageError(page))
+
+	if (!sync_page_io(rdev->bdev, sb_offset<<1, MD_SB_BYTES, rdev->sb_page, READ))
 		goto fail;
-	p = (char *)page_address(page) + BLOCK_SIZE * (sb_offset % n);
-	memcpy((char*)rdev->sb, p, MD_SB_BYTES);
-	page_cache_release(page);
+
 	printk(KERN_INFO " [events: %08lx]\n", (unsigned long)rdev->sb->events_lo);
 	return 0;
 
 fail:
-	page_cache_release(page);
-out:
 	printk(NO_SB,partition_name(rdev->dev));
 	return -EINVAL;
 }
@@ -893,11 +914,6 @@
 
 static int write_disk_sb(mdk_rdev_t * rdev)
 {
-	struct block_device *bdev = rdev->bdev;
-	struct address_space *mapping = bdev->bd_inode->i_mapping;
-	struct page *page;
-	unsigned offs;
-	int error;
 	kdev_t dev = rdev->dev;
 	unsigned long sb_offset, size;
 
@@ -933,29 +949,11 @@
 	}
 
 	printk(KERN_INFO "(write) %s's sb offset: %ld\n", partition_name(dev), sb_offset);
-	fsync_bdev(bdev);
-	page = grab_cache_page(mapping, sb_offset/(PAGE_CACHE_SIZE/BLOCK_SIZE));
-	offs = sb_offset % (PAGE_CACHE_SIZE/BLOCK_SIZE);
-	if (!page)
+
+	if (!sync_page_io(rdev->bdev, sb_offset<<1, MD_SB_BYTES, rdev->sb_page, WRITE))
 		goto fail;
-	error = mapping->a_ops->prepare_write(NULL, page, offs,
-						offs + MD_SB_BYTES);
-	if (error)
-		goto unlock;
-	memcpy((char *)page_address(page) + offs, rdev->sb, MD_SB_BYTES);
-	error = mapping->a_ops->commit_write(NULL, page, offs,
-						offs + MD_SB_BYTES);
-	if (error)
-		goto unlock;
-	unlock_page(page);
-	wait_on_page_locked(page);
-	page_cache_release(page);
-	fsync_bdev(bdev);
 skip:
 	return 0;
-unlock:
-	unlock_page(page);
-	page_cache_release(page);
 fail:
 	printk("md: write_disk_sb failed for device %s\n", partition_name(dev));
 	return 1;
