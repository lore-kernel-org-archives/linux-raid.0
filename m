From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 09/13] md-new-param-to_sync_page_io
Date: Wed, 12 Jan 2011 09:12:47 +1100
Message-ID: <20110111221247.12732.38080.stgit@notabene.brown>
References: <20110111221050.12732.31647.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111221050.12732.31647.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids

From: Jonathan Brassow <jbrassow@redhat.com>

Add new parameter to 'sync_page_io'.

The new parameter allows us to distinguish between metadata and data
operations.  This becomes important later when we add the ability to
use separate devices for data and metadata.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
---

 drivers/md/bitmap.c |    4 ++--
 drivers/md/md.c     |    9 ++++++---
 drivers/md/md.h     |    4 ++--
 drivers/md/raid1.c  |   28 ++++++++++++----------------
 drivers/md/raid10.c |   12 ++++++------
 5 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5a1ffe3..1977765 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -210,11 +210,11 @@ static struct page *read_sb_page(mddev_t *mddev, loff_t offset,
 		    || test_bit(Faulty, &rdev->flags))
 			continue;
 
-		target = rdev->sb_start + offset + index * (PAGE_SIZE/512);
+		target = offset + index * (PAGE_SIZE/512);
 
 		if (sync_page_io(rdev, target,
 				 roundup(size, bdev_logical_block_size(rdev->bdev)),
-				 page, READ)) {
+				 page, READ, true)) {
 			page->index = index;
 			attach_page_buffers(page, NULL); /* so that free_buffer will
 							  * quietly no-op */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0a0d7c2..0bc10cc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -795,7 +795,7 @@ static void bi_complete(struct bio *bio, int error)
 }
 
 int sync_page_io(mdk_rdev_t *rdev, sector_t sector, int size,
-		 struct page *page, int rw)
+		 struct page *page, int rw, bool metadata_op)
 {
 	struct bio *bio = bio_alloc_mddev(GFP_NOIO, 1, rdev->mddev);
 	struct completion event;
@@ -804,7 +804,10 @@ int sync_page_io(mdk_rdev_t *rdev, sector_t sector, int size,
 	rw |= REQ_SYNC | REQ_UNPLUG;
 
 	bio->bi_bdev = rdev->bdev;
-	bio->bi_sector = sector;
+	if (metadata_op)
+		bio->bi_sector = sector + rdev->sb_start;
+	else
+		bio->bi_sector = sector + rdev->data_offset;
 	bio_add_page(bio, page, size, 0);
 	init_completion(&event);
 	bio->bi_private = &event;
@@ -829,7 +832,7 @@ static int read_disk_sb(mdk_rdev_t * rdev, int size)
 		return 0;
 
 
-	if (!sync_page_io(rdev, rdev->sb_start, size, rdev->sb_page, READ))
+	if (!sync_page_io(rdev, 0, size, rdev->sb_page, READ, true))
 		goto fail;
 	rdev->sb_loaded = 1;
 	return 0;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 229675a..7e4f358 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -498,8 +498,8 @@ extern void md_flush_request(mddev_t *mddev, struct bio *bio);
 extern void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 			   sector_t sector, int size, struct page *page);
 extern void md_super_wait(mddev_t *mddev);
-extern int sync_page_io(mdk_rdev_t *rdev, sector_t sector, int size,
-			struct page *page, int rw);
+extern int sync_page_io(mdk_rdev_t *rdev, sector_t sector, int size, 
+			struct page *page, int rw, bool metadata_op);
 extern void md_do_sync(mddev_t *mddev);
 extern void md_new_event(mddev_t *mddev);
 extern int md_allow_write(mddev_t *mddev);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d50056b..a23ffa3 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1365,10 +1365,10 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 					 */
 					rdev = conf->mirrors[d].rdev;
 					if (sync_page_io(rdev,
-							 sect + rdev->data_offset,
+							 sect,
 							 s<<9,
 							 bio->bi_io_vec[idx].bv_page,
-							 READ)) {
+							 READ, false)) {
 						success = 1;
 						break;
 					}
@@ -1391,10 +1391,10 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 					rdev = conf->mirrors[d].rdev;
 					atomic_add(s, &rdev->corrected_errors);
 					if (sync_page_io(rdev,
-							 sect + rdev->data_offset,
+							 sect,
 							 s<<9,
 							 bio->bi_io_vec[idx].bv_page,
-							 WRITE) == 0)
+							 WRITE, false) == 0)
 						md_error(mddev, rdev);
 				}
 				d = start;
@@ -1406,10 +1406,10 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 						continue;
 					rdev = conf->mirrors[d].rdev;
 					if (sync_page_io(rdev,
-							 sect + rdev->data_offset,
+							 sect,
 							 s<<9,
 							 bio->bi_io_vec[idx].bv_page,
-							 READ) == 0)
+							 READ, false) == 0)
 						md_error(mddev, rdev);
 				}
 			} else {
@@ -1489,10 +1489,8 @@ static void fix_read_error(conf_t *conf, int read_disk,
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags) &&
-			    sync_page_io(rdev,
-					 sect + rdev->data_offset,
-					 s<<9,
-					 conf->tmppage, READ))
+			    sync_page_io(rdev, sect, s<<9,
+					 conf->tmppage, READ, false))
 				success = 1;
 			else {
 				d++;
@@ -1515,9 +1513,8 @@ static void fix_read_error(conf_t *conf, int read_disk,
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags)) {
-				if (sync_page_io(rdev,
-						 sect + rdev->data_offset,
-						 s<<9, conf->tmppage, WRITE)
+				if (sync_page_io(rdev, sect, s<<9,
+						 conf->tmppage, WRITE, false)
 				    == 0)
 					/* Well, this device is dead */
 					md_error(mddev, rdev);
@@ -1532,9 +1529,8 @@ static void fix_read_error(conf_t *conf, int read_disk,
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags)) {
-				if (sync_page_io(rdev,
-						 sect + rdev->data_offset,
-						 s<<9, conf->tmppage, READ)
+				if (sync_page_io(rdev, sect, s<<9,
+						 conf->tmppage, READ, false)
 				    == 0)
 					/* Well, this device is dead */
 					md_error(mddev, rdev);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 03825cb..69b6595 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1560,9 +1560,9 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 				rcu_read_unlock();
 				success = sync_page_io(rdev,
 						       r10_bio->devs[sl].addr +
-						       sect + rdev->data_offset,
+						       sect,
 						       s<<9,
-						       conf->tmppage, READ);
+						       conf->tmppage, READ, false);
 				rdev_dec_pending(rdev, mddev);
 				rcu_read_lock();
 				if (success)
@@ -1599,8 +1599,8 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 				atomic_add(s, &rdev->corrected_errors);
 				if (sync_page_io(rdev,
 						 r10_bio->devs[sl].addr +
-						 sect + rdev->data_offset,
-						 s<<9, conf->tmppage, WRITE)
+						 sect,
+						 s<<9, conf->tmppage, WRITE, false)
 				    == 0) {
 					/* Well, this device is dead */
 					printk(KERN_NOTICE
@@ -1636,9 +1636,9 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 				rcu_read_unlock();
 				if (sync_page_io(rdev,
 						 r10_bio->devs[sl].addr +
-						 sect + rdev->data_offset,
+						 sect,
 						 s<<9, conf->tmppage,
-						 READ) == 0) {
+						 READ, false) == 0) {
 					/* Well, this device is dead */
 					printk(KERN_NOTICE
 					       "md/raid10:%s: unable to read back "


