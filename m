From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 05/10] md/raid1: factor out flush_bio_list()
Date: Wed, 05 Apr 2017 14:05:51 +1000
Message-ID: <149136515088.25893.7996973954831165493.stgit@noble>
References: <149136485390.25893.1797855041954158826.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149136485390.25893.1797855041954158826.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

flush_pending_writes() and raid1_unplug() each contain identical
copies of a fairly large slab of code.  So factor that out into
new flush_bio_list() to simplify maintenance.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c |   67 +++++++++++++++++++++-------------------------------
 1 file changed, 27 insertions(+), 40 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d15268fff052..a70283753a35 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -787,6 +787,31 @@ static int raid1_congested(struct mddev *mddev, int bits)
 	return ret;
 }
 
+static void flush_bio_list(struct r1conf *conf, struct bio *bio)
+{
+	/* flush any pending bitmap writes to
+	 * disk before proceeding w/ I/O */
+	bitmap_unplug(conf->mddev->bitmap);
+	wake_up(&conf->wait_barrier);
+
+	while (bio) { /* submit pending writes */
+		struct bio *next = bio->bi_next;
+		struct md_rdev *rdev = (void*)bio->bi_bdev;
+		bio->bi_next = NULL;
+		bio->bi_bdev = rdev->bdev;
+		if (test_bit(Faulty, &rdev->flags)) {
+			bio->bi_error = -EIO;
+			bio_endio(bio);
+		} else if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
+				    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+			/* Just ignore it */
+			bio_endio(bio);
+		else
+			generic_make_request(bio);
+		bio = next;
+	}
+}
+
 static void flush_pending_writes(struct r1conf *conf)
 {
 	/* Any writes that have been queued but are awaiting
@@ -799,27 +824,7 @@ static void flush_pending_writes(struct r1conf *conf)
 		bio = bio_list_get(&conf->pending_bio_list);
 		conf->pending_count = 0;
 		spin_unlock_irq(&conf->device_lock);
-		/* flush any pending bitmap writes to
-		 * disk before proceeding w/ I/O */
-		bitmap_unplug(conf->mddev->bitmap);
-		wake_up(&conf->wait_barrier);
-
-		while (bio) { /* submit pending writes */
-			struct bio *next = bio->bi_next;
-			struct md_rdev *rdev = (void*)bio->bi_bdev;
-			bio->bi_next = NULL;
-			bio->bi_bdev = rdev->bdev;
-			if (test_bit(Faulty, &rdev->flags)) {
-				bio->bi_error = -EIO;
-				bio_endio(bio);
-			} else if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
-					    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
-				/* Just ignore it */
-				bio_endio(bio);
-			else
-				generic_make_request(bio);
-			bio = next;
-		}
+		flush_bio_list(conf, bio);
 	} else
 		spin_unlock_irq(&conf->device_lock);
 }
@@ -1152,25 +1157,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 
 	/* we aren't scheduling, so we can do the write-out directly. */
 	bio = bio_list_get(&plug->pending);
-	bitmap_unplug(mddev->bitmap);
-	wake_up(&conf->wait_barrier);
-
-	while (bio) { /* submit pending writes */
-		struct bio *next = bio->bi_next;
-		struct md_rdev *rdev = (void*)bio->bi_bdev;
-		bio->bi_next = NULL;
-		bio->bi_bdev = rdev->bdev;
-		if (test_bit(Faulty, &rdev->flags)) {
-			bio->bi_error = -EIO;
-			bio_endio(bio);
-		} else if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
-				    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
-			/* Just ignore it */
-			bio_endio(bio);
-		else
-			generic_make_request(bio);
-		bio = next;
-	}
+	flush_bio_list(conf, bio);
 	kfree(plug);
 }
 


