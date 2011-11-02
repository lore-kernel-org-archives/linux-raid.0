From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/17] md/raid10: If there is a spare and a replaceable
 device, start replacement.
Date: Wed, 02 Nov 2011 16:25:44 +1100
Message-ID: <20111102052544.17566.73807.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When attempting to add a spare to a RAID10 array, also consider
adding it as a replacement for a replaceable device.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 15e3f73..5993615 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -418,6 +418,9 @@ static void raid10_end_write_request(struct bio *bio, int error)
 			md_error(rdev->mddev, rdev);
 		else {
 			set_bit(WriteErrorSeen,	&rdev->flags);
+			if (!test_and_set_bit(Replaceable, &rdev->flags))
+				set_bit(MD_RECOVERY_NEEDED,
+					&rdev->mddev->recovery);
 			set_bit(R10BIO_WriteError, &r10_bio->state);
 			dec_rdev = 0;
 		}
@@ -1483,8 +1486,25 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		struct mirror_info *p = &conf->mirrors[mirror];
 		if (p->recovery_disabled == mddev->recovery_disabled)
 			continue;
-		if (p->rdev)
-			continue;
+		if (p->rdev) {
+			if (!test_bit(Replaceable, &p->rdev->flags) ||
+			    p->replacement != NULL)
+				continue;
+			clear_bit(In_sync, &rdev->flags);
+			set_bit(Replacement, &rdev->flags);
+			rdev->raid_disk = mirror;
+			err = 0;
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+					  rdev->data_offset << 9);
+			if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
+				blk_queue_max_segments(mddev->queue, 1);
+				blk_queue_segment_boundary(mddev->queue,
+							   PAGE_CACHE_SIZE - 1);
+			}
+			conf->fullsync = 1;
+			rcu_assign_pointer(p->replacement, rdev);
+			break;
+		}
 
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
@@ -1660,6 +1680,9 @@ static void end_sync_write(struct bio *bio, int error)
 			md_error(mddev, rdev);
 		else {
 			set_bit(WriteErrorSeen, &rdev->flags);
+			if (!test_and_set_bit(Replaceable, &rdev->flags))
+				set_bit(MD_RECOVERY_NEEDED,
+					&rdev->mddev->recovery);
 			set_bit(R10BIO_WriteError, &r10_bio->state);
 		}
 	} else if (is_badblock(rdev,
@@ -1854,8 +1877,13 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 					  s << 9,
 					  bio->bi_io_vec[idx].bv_page,
 					  WRITE, false);
-			if (!ok)
+			if (!ok) {
 				set_bit(WriteErrorSeen, &rdev->flags);
+				if (!test_and_set_bit(Replaceable,
+						      &rdev->flags))
+					set_bit(MD_RECOVERY_NEEDED,
+						&rdev->mddev->recovery);
+			}
 		}
 		if (!ok) {
 			/* We don't worry if we cannot set a bad block -
@@ -1973,8 +2001,12 @@ static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
 	if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
 		/* success */
 		return 1;
-	if (rw == WRITE)
+	if (rw == WRITE) {
 		set_bit(WriteErrorSeen, &rdev->flags);
+		if (!test_and_set_bit(Replaceable, &rdev->flags))
+			set_bit(MD_RECOVERY_NEEDED,
+				&rdev->mddev->recovery);
+	}
 	/* need to record an error - either for the block or the device */
 	if (!rdev_set_badblocks(rdev, sector, sectors, 0))
 		md_error(rdev->mddev, rdev);


