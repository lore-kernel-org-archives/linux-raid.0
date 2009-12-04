From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 04/22] md: support barrier requests on all personalities.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.60521.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Previously barriers were only supported on RAID1.  This is because
other levels requires synchronisation across all devices and so needed
a different approach.
Here is that approach.

When a barrier arrives, we send a zero-length barrier to every active
device.  When that completes - and if the original request was not
empty -  we submit the barrier request itself (with the barrier flag
cleared) and the submit a fresh load of zero length barriers.

The barrier request itself is asynchronous, but any subsequent
request will block until the barrier completes.

The reason for clearing the barrier flag is that a barrier request is
allowed to fail.  If we pass a non-empty barrier through a striping
raid level it is conceivable that part of it could succeed and part
could fail.  That would be way too hard to deal with.
So if the first run of zero length barriers succeed, we assume all is
sufficiently well that we send the request and ignore errors in the
second run of barriers.

RAID5 needs extra care as write requests may not have been submitted
to the underlying devices yet.  So we flush the stripe cache before
proceeding with the barrier.

Note that the second set of zero-length barriers are submitted
immediately after the original request is submitted.  Thus when
a personality finds mddev->barrier to be set during make_request,
it should not return from make_request until the corresponding
per-device request(s) have been queued.

That will be done in later patches.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/linear.c    |    2 -
 drivers/md/md.c        |  117 +++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/md.h        |   12 +++++
 drivers/md/multipath.c |    2 -
 drivers/md/raid0.c     |    2 -
 drivers/md/raid10.c    |    2 -
 drivers/md/raid5.c     |    8 +++
 7 files changed, 138 insertions(+), 7 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 1ceceb3..3b3f77c 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -292,7 +292,7 @@ static int linear_make_request (struct request_queue *q, struct bio *bio)
 	int cpu;
 
 	if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER))) {
-		bio_endio(bio, -EOPNOTSUPP);
+		md_barrier_request(mddev, bio);
 		return 0;
 	}
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 20a3660..ffe92db 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -217,12 +217,12 @@ static int md_make_request(struct request_queue *q, struct bio *bio)
 		return 0;
 	}
 	rcu_read_lock();
-	if (mddev->suspended) {
+	if (mddev->suspended || mddev->barrier) {
 		DEFINE_WAIT(__wait);
 		for (;;) {
 			prepare_to_wait(&mddev->sb_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
-			if (!mddev->suspended)
+			if (!mddev->suspended && !mddev->barrier)
 				break;
 			rcu_read_unlock();
 			schedule();
@@ -264,10 +264,122 @@ static void mddev_resume(mddev_t *mddev)
 
 int mddev_congested(mddev_t *mddev, int bits)
 {
+	if (mddev->barrier)
+		return 1;
 	return mddev->suspended;
 }
 EXPORT_SYMBOL(mddev_congested);
 
+/*
+ * Generic barrier handling for md
+ */
+
+static void md_end_barrier(struct bio *bio, int err)
+{
+	mdk_rdev_t *rdev = bio->bi_private;
+	mddev_t *mddev = rdev->mddev;
+	if (err == -EOPNOTSUPP && mddev->barrier != (void*)1)
+		set_bit(BIO_EOPNOTSUPP, &mddev->barrier->bi_flags);
+
+	rdev_dec_pending(rdev, mddev);
+
+	if (atomic_dec_and_test(&mddev->flush_pending)) {
+		if (mddev->barrier == (void*)1) {
+			/* This was a post-request barrier */
+			mddev->barrier = NULL;
+			wake_up(&mddev->sb_wait);
+		} else
+			/* The pre-request barrier has finished */
+			schedule_work(&mddev->barrier_work);
+	}
+	bio_put(bio);
+}
+
+static void md_submit_barrier(struct work_struct *ws)
+{
+	mddev_t *mddev = container_of(ws, mddev_t, barrier_work);
+	struct bio *bio = mddev->barrier;
+
+	atomic_set(&mddev->flush_pending, 1);
+
+	if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags))
+		bio_endio(bio, -EOPNOTSUPP);
+	else if (bio->bi_size == 0)
+		/* an empty barrier - all done */
+		bio_endio(bio, 0);
+	else {
+		mdk_rdev_t *rdev;
+
+		bio->bi_rw &= ~(1<<BIO_RW_BARRIER);
+		if (mddev->pers->make_request(mddev->queue, bio))
+			generic_make_request(bio);
+		mddev->barrier = (void*)1;
+		rcu_read_lock();
+		list_for_each_entry_rcu(rdev, &mddev->disks, same_set)
+			if (rdev->raid_disk >= 0 &&
+			    !test_bit(Faulty, &rdev->flags)) {
+				/* Take two references, one is dropped
+				 * when request finishes, one after
+				 * we reclaim rcu_read_lock
+				 */
+				struct bio *bi;
+				atomic_inc(&rdev->nr_pending);
+				atomic_inc(&rdev->nr_pending);
+				rcu_read_unlock();
+				bi = bio_alloc(GFP_KERNEL, 0);
+				bi->bi_end_io = md_end_barrier;
+				bi->bi_private = rdev;
+				bi->bi_bdev = rdev->bdev;
+				atomic_inc(&mddev->flush_pending);
+				submit_bio(WRITE_BARRIER, bi);
+				rcu_read_lock();
+				rdev_dec_pending(rdev, mddev);
+			}
+		rcu_read_unlock();
+	}
+	if (atomic_dec_and_test(&mddev->flush_pending)) {
+		mddev->barrier = NULL;
+		wake_up(&mddev->sb_wait);
+	}
+}
+
+void md_barrier_request(mddev_t *mddev, struct bio *bio)
+{
+	mdk_rdev_t *rdev;
+
+	spin_lock_irq(&mddev->write_lock);
+	wait_event_lock_irq(mddev->sb_wait,
+			    !mddev->barrier,
+			    mddev->write_lock, /*nothing*/);
+	mddev->barrier = bio;
+	spin_unlock_irq(&mddev->write_lock);
+
+	atomic_set(&mddev->flush_pending, 1);
+	INIT_WORK(&mddev->barrier_work, md_submit_barrier);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(rdev, &mddev->disks, same_set)
+		if (rdev->raid_disk >= 0 &&
+		    !test_bit(Faulty, &rdev->flags)) {
+			struct bio *bi;
+
+			atomic_inc(&rdev->nr_pending);
+			atomic_inc(&rdev->nr_pending);
+			rcu_read_unlock();
+			bi = bio_alloc(GFP_KERNEL, 0);
+			bi->bi_end_io = md_end_barrier;
+			bi->bi_private = rdev;
+			bi->bi_bdev = rdev->bdev;
+			atomic_inc(&mddev->flush_pending);
+			submit_bio(WRITE_BARRIER, bi);
+			rcu_read_lock();
+			rdev_dec_pending(rdev, mddev);
+		}
+	rcu_read_unlock();
+	if (atomic_dec_and_test(&mddev->flush_pending))
+		schedule_work(&mddev->barrier_work);
+}
+EXPORT_SYMBOL(md_barrier_request);
 
 static inline mddev_t *mddev_get(mddev_t *mddev)
 {
@@ -374,6 +486,7 @@ static mddev_t * mddev_find(dev_t unit)
 	atomic_set(&new->openers, 0);
 	atomic_set(&new->active_io, 0);
 	spin_lock_init(&new->write_lock);
+	atomic_set(&new->flush_pending, 0);
 	init_waitqueue_head(&new->sb_wait);
 	init_waitqueue_head(&new->recovery_wait);
 	new->reshape_position = MaxSector;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 57ae80c..77f0aad 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -291,6 +291,17 @@ struct mddev_s
 								*/
 
 	struct list_head		all_mddevs;
+
+	/* Generic barrier handling.
+	 * If there is a pending barrier request, all other
+	 * writes are blocked while the devices are flushed.
+	 * The last to finish a flush schedules a worker to
+	 * submit the barrier request (without the barrier flag),
+	 * then submit more flush requests.
+	 */
+	struct bio *barrier;
+	atomic_t flush_pending;
+	struct work_struct barrier_work;
 };
 
 
@@ -431,6 +442,7 @@ extern void md_done_sync(mddev_t *mddev, int blocks, int ok);
 extern void md_error(mddev_t *mddev, mdk_rdev_t *rdev);
 
 extern int mddev_congested(mddev_t *mddev, int bits);
+extern void md_barrier_request(mddev_t *mddev, struct bio *bio);
 extern void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 			   sector_t sector, int size, struct page *page);
 extern void md_super_wait(mddev_t *mddev);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index ee7646f..cbc0a99 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -145,7 +145,7 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
 	int cpu;
 
 	if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER))) {
-		bio_endio(bio, -EOPNOTSUPP);
+		md_barrier_request(mddev, bio);
 		return 0;
 	}
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d3a4ce0..122d07a 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -453,7 +453,7 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 	int cpu;
 
 	if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER))) {
-		bio_endio(bio, -EOPNOTSUPP);
+		md_barrier_request(mddev, bio);
 		return 0;
 	}
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c2cb7b8..2fbf867 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -804,7 +804,7 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	mdk_rdev_t *blocked_rdev;
 
 	if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER))) {
-		bio_endio(bio, -EOPNOTSUPP);
+		md_barrier_request(mddev, bio);
 		return 0;
 	}
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d29215d..ecf89c8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3866,7 +3866,13 @@ static int make_request(struct request_queue *q, struct bio * bi)
 	int cpu, remaining;
 
 	if (unlikely(bio_rw_flagged(bi, BIO_RW_BARRIER))) {
-		bio_endio(bi, -EOPNOTSUPP);
+		/* Drain all pending writes.  We only really need
+		 * to ensure they have been submitted, but this is
+		 * easier.
+		 */
+		mddev->pers->quiesce(mddev, 1);
+		mddev->pers->quiesce(mddev, 0);
+		md_barrier_request(mddev, bi);
 		return 0;
 	}
 


