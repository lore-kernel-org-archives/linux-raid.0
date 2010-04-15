From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 28/28] md/raid1: delay reads that could overtake
	behind-writes.
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.90114.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When a raid1 array is configured to support write-behind
on some devices, it normally only reads from other devices.
If all devices are write-behind (because the rest have failed)
it is possible for a read request to be serviced before a
behind-write request, which would appear as data corruption.

So when forced to read from a WriteMostly device, wait for any
write-behind to complete, and don't start any more behind-writes.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |    4 +++-
 drivers/md/bitmap.h |    1 +
 drivers/md/raid1.c  |   25 ++++++++++++++++++-------
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 49d6080..c9c6a34 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1356,7 +1356,8 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
 {
 	if (!bitmap) return;
 	if (behind) {
-		atomic_dec(&bitmap->behind_writes);
+		if (atomic_dec_and_test(&bitmap->behind_writes))
+			wake_up(&bitmap->behind_wait);
 		PRINTK(KERN_DEBUG "dec write-behind count %d/%d\n",
 		  atomic_read(&bitmap->behind_writes), bitmap->max_write_behind);
 	}
@@ -1680,6 +1681,7 @@ int bitmap_create(mddev_t *mddev)
 	atomic_set(&bitmap->pending_writes, 0);
 	init_waitqueue_head(&bitmap->write_wait);
 	init_waitqueue_head(&bitmap->overflow_wait);
+	init_waitqueue_head(&bitmap->behind_wait);
 
 	bitmap->mddev = mddev;
 
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index aa82b7c..3797dea 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -240,6 +240,7 @@ struct bitmap {
 	atomic_t pending_writes; /* pending writes to the bitmap file */
 	wait_queue_head_t write_wait;
 	wait_queue_head_t overflow_wait;
+	wait_queue_head_t behind_wait;
 
 	struct sysfs_dirent *sysfs_can_clear;
 };
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d0d32f0..3744fe2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -857,6 +857,15 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		}
 		mirror = conf->mirrors + rdisk;
 
+		if (test_bit(WriteMostly, &mirror->rdev->flags) &&
+		    bitmap) {
+			/* Reading from a write-mostly device must
+			 * take care not to over-take any writes
+			 * that are 'behind'
+			 */
+			wait_event(bitmap->behind_wait,
+				   atomic_read(&bitmap->behind_writes) == 0);
+		}
 		r1_bio->read_disk = rdisk;
 
 		read_bio = bio_clone(bio, GFP_NOIO);
@@ -933,10 +942,14 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		set_bit(R1BIO_Degraded, &r1_bio->state);
 	}
 
-	/* do behind I/O ? */
+	/* do behind I/O ?
+	 * Not if there are too many, or cannot allocate memory,
+	 * or a reader on WriteMostly is waiting for behind writes 
+	 * to flush */
 	if (bitmap &&
 	    (atomic_read(&bitmap->behind_writes)
 	     < mddev->bitmap_info.max_write_behind) &&
+	    !waitqueue_active(&bitmap->behind_wait) &&
 	    (behind_pages = alloc_behind_pages(bio)) != NULL)
 		set_bit(R1BIO_BehindIO, &r1_bio->state);
 
@@ -2143,15 +2156,13 @@ static int stop(mddev_t *mddev)
 {
 	conf_t *conf = mddev->private;
 	struct bitmap *bitmap = mddev->bitmap;
-	int behind_wait = 0;
 
 	/* wait for behind writes to complete */
-	while (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
-		behind_wait++;
-		printk(KERN_INFO "raid1: behind writes in progress on device %s, waiting to stop (%d)\n", mdname(mddev), behind_wait);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(HZ); /* wait a second */
+	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
+		printk(KERN_INFO "raid1: behind writes in progress on device %s, waiting to stop.\n", mdname(mddev));
 		/* need to kick something here to make sure I/O goes? */
+		wait_event(bitmap->behind_wait,
+			   atomic_read(&bitmap->behind_writes) == 0);
 	}
 
 	raise_barrier(conf);


