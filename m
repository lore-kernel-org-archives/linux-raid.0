From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 11 of 12] Allow md to update multiple superblocks in parallel.
Date: Wed, 23 Mar 2005 16:47:11 +1100
Message-ID: <E1DDyhz-0004H2-O3@notabene.cse.unsw.edu.au>
References: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


currently, md updates all superblocks (one on each device)
in series.  It waits for one write to complete before starting
the next.  This isn't a big problem as superblock updates don't
happen that often.
However it is neater to do it in parallel, and if the drives
in the array have gone to "sleep" after a period of idleness, then
waking them is parallel is faster (and someone else should be 
worrying about power drain).

Futher, we will need parallel superblock updates for a future
patch which keeps the intent-logging bitmap near the superblock.

Also remove the silly code that retired superblock updates 
100 times.  This simply never made sense.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c           |   85 ++++++++++++++++++++++++--------------------
 ./include/linux/raid/md_k.h |    1 
 2 files changed, 49 insertions(+), 37 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-03-22 17:25:24.000000000 +1100
+++ ./drivers/md/md.c	2005-03-22 17:31:49.000000000 +1100
@@ -328,6 +328,40 @@ static void free_disk_sb(mdk_rdev_t * rd
 }
 
 
+static int super_written(struct bio *bio, unsigned int bytes_done, int error)
+{
+	mdk_rdev_t *rdev = bio->bi_private;
+	if (bio->bi_size)
+		return 1;
+
+	if (error || !test_bit(BIO_UPTODATE, &bio->bi_flags))
+		md_error(rdev->mddev, rdev);
+
+	if (atomic_dec_and_test(&rdev->mddev->pending_writes))
+		wake_up(&rdev->mddev->sb_wait);
+	return 0;
+}
+
+void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
+		   sector_t sector, int size, struct page *page)
+{
+	/* write first size bytes of page to sector of rdev
+	 * Increment mddev->pending_writes before returning
+	 * and decrement it on completion, waking up sb_wait
+	 * if zero is reached.
+	 * If an error occurred, call md_error
+	 */
+	struct bio *bio = bio_alloc(GFP_KERNEL, 1);
+
+	bio->bi_bdev = rdev->bdev;
+	bio->bi_sector = sector;
+	bio_add_page(bio, page, size, 0);
+	bio->bi_private = rdev;
+	bio->bi_end_io = super_written;
+	atomic_inc(&mddev->pending_writes);
+	submit_bio((1<<BIO_RW)|(1<<BIO_RW_SYNC), bio);
+}
+
 static int bi_complete(struct bio *bio, unsigned int bytes_done, int error)
 {
 	if (bio->bi_size)
@@ -1240,30 +1274,6 @@ void md_print_devices(void)
 }
 
 
-static int write_disk_sb(mdk_rdev_t * rdev)
-{
-	char b[BDEVNAME_SIZE];
-	if (!rdev->sb_loaded) {
-		MD_BUG();
-		return 1;
-	}
-	if (rdev->faulty) {
-		MD_BUG();
-		return 1;
-	}
-
-	dprintk(KERN_INFO "(write) %s's sb offset: %llu\n",
-		bdevname(rdev->bdev,b),
-	       (unsigned long long)rdev->sb_offset);
-  
-	if (sync_page_io(rdev->bdev, rdev->sb_offset<<1, MD_SB_BYTES, rdev->sb_page, WRITE))
-		return 0;
-
-	printk("md: write_disk_sb failed for device %s\n", 
-		bdevname(rdev->bdev,b));
-	return 1;
-}
-
 static void sync_sbs(mddev_t * mddev)
 {
 	mdk_rdev_t *rdev;
@@ -1278,7 +1288,7 @@ static void sync_sbs(mddev_t * mddev)
 
 static void md_update_sb(mddev_t * mddev)
 {
-	int err, count = 100;
+	int err;
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
 	int sync_req;
@@ -1298,6 +1308,7 @@ repeat:
 		MD_BUG();
 		mddev->events --;
 	}
+	mddev->sb_dirty = 2;
 	sync_sbs(mddev);
 
 	/*
@@ -1325,24 +1336,24 @@ repeat:
 
 		dprintk("%s ", bdevname(rdev->bdev,b));
 		if (!rdev->faulty) {
-			err += write_disk_sb(rdev);
+			md_super_write(mddev,rdev,
+				       rdev->sb_offset<<1, MD_SB_BYTES,
+				       rdev->sb_page);
+			dprintk(KERN_INFO "(write) %s's sb offset: %llu\n",
+				bdevname(rdev->bdev,b),
+				(unsigned long long)rdev->sb_offset);
+
 		} else
 			dprintk(")\n");
-		if (!err && mddev->level == LEVEL_MULTIPATH)
+		if (mddev->level == LEVEL_MULTIPATH)
 			/* only need to write one superblock... */
 			break;
 	}
-	if (err) {
-		if (--count) {
-			printk(KERN_ERR "md: errors occurred during superblock"
-				" update, repeating\n");
-			goto repeat;
-		}
-		printk(KERN_ERR \
-			"md: excessive errors occurred during superblock update, exiting\n");
-	}
+	wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
+	/* if there was a failure, sb_dirty was set to 1, and we re-write super */
+
 	spin_lock(&mddev->write_lock);
-	if (mddev->in_sync != sync_req) {
+	if (mddev->in_sync != sync_req|| mddev->sb_dirty == 1) {
 		/* have to write it out again */
 		spin_unlock(&mddev->write_lock);
 		goto repeat;

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-03-22 17:11:00.000000000 +1100
+++ ./include/linux/raid/md_k.h	2005-03-22 17:29:38.000000000 +1100
@@ -262,6 +262,7 @@ struct mddev_s
 
 	spinlock_t			write_lock;
 	wait_queue_head_t		sb_wait;	/* for waiting on superblock updates */
+	atomic_t			pending_writes;	/* number of active superblock writes */
 
 	unsigned int			safemode;	/* if set, update "clean" superblock
 							 * when no writes pending.
