From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 1/4] md: add block tracing for bio_remapping
Date: Mon, 14 Nov 2016 16:30:21 +1100
Message-ID: <147910142095.27168.11356591734977480053.stgit@noble>
References: <147910131504.27168.6566119701315109161.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147910131504.27168.6566119701315109161.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The block tracing infrastructure (accessed with blktrace/blkparse)
supports the tracing of mapping bios from one device to another.
This is currently used when a bio in a partition is mapped to the
whole device, when bios are mapped by dm, and for mapping in md/raid5.
Other md personalities do not include this tracing yet, so add it.

When a read-error is detected we redirect the request to a different device.
This could justifiably be seen as a new mapping for the originial bio,
or a secondary mapping for the bio that errors.  This patch uses
the second option.

When md is used under dm-raid, the mappings are not traced as we do
not have access to the block device number of the parent.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/linear.c |    8 +++++++-
 drivers/md/raid0.c  |    8 +++++++-
 drivers/md/raid1.c  |   33 ++++++++++++++++++++++++++++++---
 drivers/md/raid10.c |   29 +++++++++++++++++++++++++++--
 4 files changed, 71 insertions(+), 7 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 9c7d4f5483ea..8c0bccfa53a2 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -21,6 +21,7 @@
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <trace/events/block.h>
 #include "md.h"
 #include "linear.h"
 
@@ -256,8 +257,13 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
 			/* Just ignore it */
 			bio_endio(split);
-		} else
+		} else {
+			if (mddev->gendisk)
+				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
+						      split, disk_devt(mddev->gendisk),
+						      bio->bi_iter.bi_sector);
 			generic_make_request(split);
+		}
 	} while (split != bio);
 	return;
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index b3ba77a3c3bc..841b3ad0f5ff 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -21,6 +21,7 @@
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <trace/events/block.h>
 #include "md.h"
 #include "raid0.h"
 #include "raid5.h"
@@ -491,8 +492,13 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
 			/* Just ignore it */
 			bio_endio(split);
-		} else
+		} else {
+			if (mddev->gendisk)
+				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
+						      split, disk_devt(mddev->gendisk),
+						      bio->bi_iter.bi_sector);
 			generic_make_request(split);
+		}
 	} while (split != bio);
 }
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9ac61cd85e5c..3710a792a149 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -37,6 +37,7 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/ratelimit.h>
+#include <trace/events/block.h>
 #include "md.h"
 #include "raid1.h"
 #include "bitmap.h"
@@ -743,6 +744,7 @@ static void flush_pending_writes(struct r1conf *conf)
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
 			struct md_rdev *rdev = (void*)bio->bi_bdev;
+			struct r1bio *r1_bio = bio->bi_private;
 			bio->bi_next = NULL;
 			bio->bi_bdev = rdev->bdev;
 			if (test_bit(Faulty, &rdev->flags)) {
@@ -752,8 +754,13 @@ static void flush_pending_writes(struct r1conf *conf)
 					    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 				/* Just ignore it */
 				bio_endio(bio);
-			else
+			else {
+				if (conf->mddev->gendisk)
+					trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
+							      bio, disk_devt(conf->mddev->gendisk),
+							      r1_bio->sector);
 				generic_make_request(bio);
+			}
 			bio = next;
 		}
 	} else
@@ -1022,6 +1029,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		struct md_rdev *rdev = (void*)bio->bi_bdev;
+		struct r1bio *r1_bio = bio->bi_private;
 		bio->bi_next = NULL;
 		bio->bi_bdev = rdev->bdev;
 		if (test_bit(Faulty, &rdev->flags)) {
@@ -1031,8 +1039,13 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 				    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 			/* Just ignore it */
 			bio_endio(bio);
-		else
+		else {
+			if (mddev->gendisk)
+				trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
+						      bio, disk_devt(mddev->gendisk),
+						      r1_bio->sector);
 			generic_make_request(bio);
+		}
 		bio = next;
 	}
 	kfree(plug);
@@ -1162,6 +1175,11 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
 		bio_set_op_attrs(read_bio, op, do_sync);
 		read_bio->bi_private = r1_bio;
 
+		if (mddev->gendisk)
+			trace_block_bio_remap(bdev_get_queue(read_bio->bi_bdev),
+					      read_bio, disk_devt(mddev->gendisk),
+					      r1_bio->sector);
+
 		if (max_sectors < r1_bio->sectors) {
 			/* could not read all from this device, so we will
 			 * need another r1_bio.
@@ -2290,6 +2308,8 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	struct bio *bio;
 	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
+	dev_t bio_dev;
+	sector_t bio_sector;
 
 	clear_bit(R1BIO_ReadError, &r1_bio->state);
 	/* we got a read error. Maybe the drive is bad.  Maybe just
@@ -2303,6 +2323,8 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 
 	bio = r1_bio->bios[r1_bio->read_disk];
 	bdevname(bio->bi_bdev, b);
+	bio_dev = bio->bi_bdev->bd_dev;
+	bio_sector = conf->mirrors[r1_bio->read_disk].rdev->data_offset + r1_bio->sector;
 	bio_put(bio);
 	r1_bio->bios[r1_bio->read_disk] = NULL;
 
@@ -2353,6 +2375,8 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 			else
 				mbio->bi_phys_segments++;
 			spin_unlock_irq(&conf->device_lock);
+			trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
+					      bio, bio_dev, bio_sector);
 			generic_make_request(bio);
 			bio = NULL;
 
@@ -2367,8 +2391,11 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 				sectors_handled;
 
 			goto read_more;
-		} else
+		} else {
+			trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
+					      bio, bio_dev, bio_sector);
 			generic_make_request(bio);
+		}
 	}
 }
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5290be3d5c26..d144c3425824 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -25,6 +25,7 @@
 #include <linux/seq_file.h>
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
+#include <trace/events/block.h>
 #include "md.h"
 #include "raid10.h"
 #include "raid0.h"
@@ -859,6 +860,7 @@ static void flush_pending_writes(struct r10conf *conf)
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
 			struct md_rdev *rdev = (void*)bio->bi_bdev;
+			struct r10bio *r10_bio = bio->bi_private;
 			bio->bi_next = NULL;
 			bio->bi_bdev = rdev->bdev;
 			if (test_bit(Faulty, &rdev->flags)) {
@@ -868,8 +870,13 @@ static void flush_pending_writes(struct r10conf *conf)
 					    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 				/* Just ignore it */
 				bio_endio(bio);
-			else
+			else {
+				if (conf->mddev->gendisk)
+					trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
+							      bio, disk_devt(conf->mddev->gendisk),
+							      r10_bio->sector);
 				generic_make_request(bio);
+			}
 			bio = next;
 		}
 	} else
@@ -1042,6 +1049,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		struct md_rdev *rdev = (void*)bio->bi_bdev;
+		struct r10bio *r10_bio = bio->bi_private;
 		bio->bi_next = NULL;
 		bio->bi_bdev = rdev->bdev;
 		if (test_bit(Faulty, &rdev->flags)) {
@@ -1051,8 +1059,13 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 				    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 			/* Just ignore it */
 			bio_endio(bio);
-		else
+		else {
+			if (conf->mddev->gendisk)
+				trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
+						      bio, disk_devt(conf->mddev->gendisk),
+						      r10_bio->sector);
 			generic_make_request(bio);
+		}
 		bio = next;
 	}
 	kfree(plug);
@@ -1165,6 +1178,10 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 		bio_set_op_attrs(read_bio, op, do_sync);
 		read_bio->bi_private = r10_bio;
 
+		if (mddev->gendisk)
+			trace_block_bio_remap(bdev_get_queue(read_bio->bi_bdev),
+					      read_bio, disk_devt(mddev->gendisk),
+					      r10_bio->sector);
 		if (max_sectors < r10_bio->sectors) {
 			/* Could not read all from this device, so we will
 			 * need another r10_bio.
@@ -2496,6 +2513,8 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	char b[BDEVNAME_SIZE];
 	unsigned long do_sync;
 	int max_sectors;
+	dev_t bio_dev;
+	sector_t bio_last_sector;
 
 	/* we got a read error. Maybe the drive is bad.  Maybe just
 	 * the block and we can fix it.
@@ -2507,6 +2526,8 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	 */
 	bio = r10_bio->devs[slot].bio;
 	bdevname(bio->bi_bdev, b);
+	bio_dev = bio->bi_bdev->bd_dev;
+	bio_last_sector = r10_bio->devs[slot].addr + rdev->data_offset + r10_bio->sectors;
 	bio_put(bio);
 	r10_bio->devs[slot].bio = NULL;
 
@@ -2546,6 +2567,10 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	bio_set_op_attrs(bio, REQ_OP_READ, do_sync);
 	bio->bi_private = r10_bio;
 	bio->bi_end_io = raid10_end_read_request;
+	trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
+			      bio, bio_dev,
+			      bio_last_sector - r10_bio->sectors);
+
 	if (max_sectors < r10_bio->sectors) {
 		/* Drat - have to split this up more */
 		struct bio *mbio = r10_bio->master_bio;


