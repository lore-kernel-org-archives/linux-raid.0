From: Xiao Ni <xni@redhat.com>
Subject: [RFC PATCH] MD: fix lock contention for flush bios
Date: Wed, 24 Jan 2018 10:43:54 +0800
Message-ID: <1516761834-4701-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, neilb@suse.com, ming.lei@redhat.com, ncroxon@redhat.com
List-Id: linux-raid.ids

There is a lock contention when there are many processes which send flush bios
to md device. eg. Create many lvs on one raid device and mkfs.xfs on each lv.

Now it just can handle flush request sequentially. It needs to wait mddev->flush_bio
to be NULL, otherwise get mddev->lock.

This patch remove mddev->flush_bio and allocat one bio for each flush bio.
I did a test with command dbench -s 128 -t 4800. This is the test result:

=================Before the patch============================

 Operation      Count    AvgLat    MaxLat
 ----------------------------------------
 NTCreateX     124271     5.128 12752.344
 Close          96922     0.645  6250.826
 Rename          5141     1.556  6747.033
 Unlink         20283     5.045 12752.294
 Qpathinfo     111872     0.012   250.069
 Qfileinfo      25684     0.004     0.293
 Qfsinfo        18535     0.007     0.646
 Sfileinfo      11763     0.014     0.571
 Find           41018     0.026     0.869
 WriteX         88616  6750.094 80740.875
 ReadX         179250     0.018  1749.302
 LockX            328     0.008     0.042
 UnlockX          328     0.004     0.023
 Flush           9650  1688.288 38998.814

Throughput 1.01668 MB/sec (sync open)  128 clients  128 procs  max_latency=80740.883 ms

========================after patch============================
 128  cleanup 600 sec
   0  cleanup 600 sec

 Operation      Count    AvgLat    MaxLat
 ----------------------------------------
 NTCreateX      52444     1.403  1499.920
 Close          45740     0.035  1000.301
 Rename          2090     0.073     1.591
 Unlink          5032     5.855  1251.375
 Qpathinfo      44493     0.167   501.498
 Qfileinfo      16261     0.004     0.577
 Qfsinfo         5887     0.011     1.133
 Sfileinfo       6303     0.022     1.277
 Find           15321     0.034     1.041
 WriteX         62730  1197.684  3247.813
 ReadX          60379     0.013     2.408
 LockX             48     0.010     0.039
 UnlockX           48     0.004     0.006
 Flush           4370   382.070   999.735

Throughput 5.06007 MB/sec (sync open)  128 clients  128 procs  max_latency=3247.823 ms

The test was did on one raid10 with 4 SSDs.

Suggested-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 105 +++++++++++++++++++++++++-------------------------------
 drivers/md/md.h |  14 ++++----
 2 files changed, 54 insertions(+), 65 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e4dee0..1e562f5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -409,33 +409,61 @@ static int md_congested(void *data, int bits)
 	return mddev_congested(mddev, bits);
 }
 
-/*
- * Generic flush handling for md
- */
+static void submit_flushes(struct work_struct *ws)
+{
+	struct flush_info *fi = container_of(ws, struct flush_info, flush_work);
+	struct mddev *mddev = fi->mddev;
+	struct bio *bio = fi->bio;
+
+	bio->bi_opf &= ~REQ_PREFLUSH;
+	md_handle_request(mddev, bio);
 
-static void md_end_flush(struct bio *bio)
+	kfree(fi);
+}
+
+
+static void md_end_flush(struct bio *flush_bio)
 {
-	struct md_rdev *rdev = bio->bi_private;
-	struct mddev *mddev = rdev->mddev;
+	struct flush_info *fi = flush_bio->bi_private;
+	struct bio *bio = fi->bio;
+	struct mddev *mddev = fi->mddev;
+	struct md_rdev *rdev;
 
-	rdev_dec_pending(rdev, mddev);
+	rcu_read_lock();
+		rdev_for_each_rcu(rdev, mddev)
+			rdev_dec_pending(rdev, mddev);
+	rcu_read_unlock();
 
-	if (atomic_dec_and_test(&mddev->flush_pending)) {
-		/* The pre-request flush has finished */
-		queue_work(md_wq, &mddev->flush_work);
+	if (bio->bi_iter.bi_size == 0)
+		/* an empty barrier - all done */
+		bio_endio(bio);
+	else {
+		INIT_WORK(&fi->flush_work, submit_flushes);
+		queue_work(md_wq, &fi->flush_work);
 	}
-	bio_put(bio);
 }
 
-static void md_submit_flush_data(struct work_struct *ws);
-
-static void submit_flushes(struct work_struct *ws)
+void md_flush_request(struct mddev *mddev, struct bio *bio)
 {
-	struct mddev *mddev = container_of(ws, struct mddev, flush_work);
 	struct md_rdev *rdev;
+	struct flush_info *fi;
+	struct bio *f_bio;
+
+	fi = kmalloc(sizeof(*fi), GFP_NOIO);
+	if (fi == NULL) {
+		pr_err("md: %s failed to alloc memory for flush bio\n",
+		       mdname(mddev));
+		bio->bi_status = BLK_STS_IOERR;
+		bio_endio(bio);
+	}
+
+	fi->bio = bio;
+	fi->mddev = mddev;
+	f_bio = &fi->flush_bio;
+	bio_init(f_bio, NULL, 0);
+	f_bio->bi_private = fi;
+	f_bio->bi_end_io = md_end_flush;
 
-	INIT_WORK(&mddev->flush_work, md_submit_flush_data);
-	atomic_set(&mddev->flush_pending, 1);
 	rcu_read_lock();
 	rdev_for_each_rcu(rdev, mddev)
 		if (rdev->raid_disk >= 0 &&
@@ -449,54 +477,16 @@ static void submit_flushes(struct work_struct *ws)
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
 			bi = bio_alloc_mddev(GFP_NOIO, 0, mddev);
-			bi->bi_end_io = md_end_flush;
-			bi->bi_private = rdev;
 			bio_set_dev(bi, rdev->bdev);
 			bi->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
-			atomic_inc(&mddev->flush_pending);
+			bio_chain(bi, f_bio);
 			submit_bio(bi);
 			rcu_read_lock();
 			rdev_dec_pending(rdev, mddev);
 		}
 	rcu_read_unlock();
-	if (atomic_dec_and_test(&mddev->flush_pending))
-		queue_work(md_wq, &mddev->flush_work);
-}
-
-static void md_submit_flush_data(struct work_struct *ws)
-{
-	struct mddev *mddev = container_of(ws, struct mddev, flush_work);
-	struct bio *bio = mddev->flush_bio;
-
-	/*
-	 * must reset flush_bio before calling into md_handle_request to avoid a
-	 * deadlock, because other bios passed md_handle_request suspend check
-	 * could wait for this and below md_handle_request could wait for those
-	 * bios because of suspend check
-	 */
-	mddev->flush_bio = NULL;
-	wake_up(&mddev->sb_wait);
-
-	if (bio->bi_iter.bi_size == 0)
-		/* an empty barrier - all done */
-		bio_endio(bio);
-	else {
-		bio->bi_opf &= ~REQ_PREFLUSH;
-		md_handle_request(mddev, bio);
-	}
-}
-
-void md_flush_request(struct mddev *mddev, struct bio *bio)
-{
-	spin_lock_irq(&mddev->lock);
-	wait_event_lock_irq(mddev->sb_wait,
-			    !mddev->flush_bio,
-			    mddev->lock);
-	mddev->flush_bio = bio;
-	spin_unlock_irq(&mddev->lock);
 
-	INIT_WORK(&mddev->flush_work, submit_flushes);
-	queue_work(md_wq, &mddev->flush_work);
+	bio_endio(f_bio);
 }
 EXPORT_SYMBOL(md_flush_request);
 
@@ -555,7 +545,6 @@ void mddev_init(struct mddev *mddev)
 	atomic_set(&mddev->openers, 0);
 	atomic_set(&mddev->active_io, 0);
 	spin_lock_init(&mddev->lock);
-	atomic_set(&mddev->flush_pending, 0);
 	init_waitqueue_head(&mddev->sb_wait);
 	init_waitqueue_head(&mddev->recovery_wait);
 	mddev->reshape_position = MaxSector;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7d6bcf0..16e7f03 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -252,6 +252,13 @@ enum mddev_sb_flags {
 	MD_SB_NEED_REWRITE,	/* metadata write needs to be repeated */
 };
 
+struct flush_info {
+	struct bio *bio;
+	struct bio flush_bio;
+	struct mddev *mddev;
+	struct work_struct flush_work;
+};
+
 struct mddev {
 	void				*private;
 	struct md_personality		*pers;
@@ -457,13 +464,6 @@ struct mddev {
 						   * metadata and bitmap writes
 						   */
 
-	/* Generic flush handling.
-	 * The last to finish preflush schedules a worker to submit
-	 * the rest of the request (without the REQ_PREFLUSH flag).
-	 */
-	struct bio *flush_bio;
-	atomic_t flush_pending;
-	struct work_struct flush_work;
 	struct work_struct event_work;	/* used by dm to report failure event */
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
 	struct md_cluster_info		*cluster_info;
-- 
2.7.4

