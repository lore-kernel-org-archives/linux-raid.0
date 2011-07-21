From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 26/34] md/raid10: Make use of new recovery_disabled handling
Date: Thu, 21 Jul 2011 12:32:27 +1000
Message-ID: <20110721023227.6728.50267.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When we get a read error during recovery, RAID10 previously
arranged for the recovering device to appear to fail so that
the recovery stops and doesn't restart.  This is misleading and wrong.

Instead, make use of the new recovery_disabled handling and mark
the target device and having recovery disabled.

Add appropriate checks in add_disk and remove_disk so that devices
are removed and not re-added when recovery is disabled.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   62 ++++++++++++++++++++++++++++++---------------------
 drivers/md/raid10.h |    5 ++++
 2 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1725ec1..5583201 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1099,7 +1099,6 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	conf_t *conf = mddev->private;
 	int err = -EEXIST;
 	int mirror;
-	mirror_info_t *p;
 	int first = 0;
 	int last = conf->raid_disks - 1;
 
@@ -1119,32 +1118,36 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 		mirror = rdev->saved_raid_disk;
 	else
 		mirror = first;
-	for ( ; mirror <= last ; mirror++)
-		if ( !(p=conf->mirrors+mirror)->rdev) {
-
-			disk_stack_limits(mddev->gendisk, rdev->bdev,
-					  rdev->data_offset << 9);
-			/* as we don't honour merge_bvec_fn, we must
-			 * never risk violating it, so limit
-			 * ->max_segments to one lying with a single
-			 * page, as a one page request is never in
-			 * violation.
-			 */
-			if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
-				blk_queue_max_segments(mddev->queue, 1);
-				blk_queue_segment_boundary(mddev->queue,
-							   PAGE_CACHE_SIZE - 1);
-			}
+	for ( ; mirror <= last ; mirror++) {
+		mirror_info_t *p = &conf->mirrors[mirror];
+		if (p->recovery_disabled == mddev->recovery_disabled)
+			continue;
+		if (!p->rdev)
+			continue;
 
-			p->head_position = 0;
-			rdev->raid_disk = mirror;
-			err = 0;
-			if (rdev->saved_raid_disk != mirror)
-				conf->fullsync = 1;
-			rcu_assign_pointer(p->rdev, rdev);
-			break;
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset << 9);
+		/* as we don't honour merge_bvec_fn, we must
+		 * never risk violating it, so limit
+		 * ->max_segments to one lying with a single
+		 * page, as a one page request is never in
+		 * violation.
+		 */
+		if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
+			blk_queue_max_segments(mddev->queue, 1);
+			blk_queue_segment_boundary(mddev->queue,
+						   PAGE_CACHE_SIZE - 1);
 		}
 
+		p->head_position = 0;
+		rdev->raid_disk = mirror;
+		err = 0;
+		if (rdev->saved_raid_disk != mirror)
+			conf->fullsync = 1;
+		rcu_assign_pointer(p->rdev, rdev);
+		break;
+	}
+
 	md_integrity_add_rdev(rdev, mddev);
 	print_conf(conf);
 	return err;
@@ -1169,6 +1172,7 @@ static int raid10_remove_disk(mddev_t *mddev, int number)
 		 * is not possible.
 		 */
 		if (!test_bit(Faulty, &rdev->flags) &&
+		    mddev->recovery_disabled != p->recovery_disabled &&
 		    enough(conf)) {
 			err = -EBUSY;
 			goto abort;
@@ -1383,8 +1387,14 @@ static void recovery_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 	md_sync_acct(conf->mirrors[d].rdev->bdev, wbio->bi_size >> 9);
 	if (test_bit(R10BIO_Uptodate, &r10_bio->state))
 		generic_make_request(wbio);
-	else
-		bio_endio(wbio, -EIO);
+	else {
+		printk(KERN_NOTICE
+		       "md/raid10:%s: recovery aborted due to read error\n",
+		       mdname(mddev));
+		conf->mirrors[d].recovery_disabled = mddev->recovery_disabled;
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+		bio_endio(wbio, 0);
+	}
 }
 
 
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 944b110..a485914 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -6,6 +6,11 @@ typedef struct mirror_info mirror_info_t;
 struct mirror_info {
 	mdk_rdev_t	*rdev;
 	sector_t	head_position;
+	int		recovery_disabled;	/* matches
+						 * mddev->recovery_disabled
+						 * when we shouldn't try
+						 * recovering this device.
+						 */
 };
 
 typedef struct r10bio_s r10bio_t;


