From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 24/28] md: pass mddev to make_request functions rather than
	request_queue
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.45766.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We used to pass the personality make_request function direct
to the block layer so the first argument had to be a queue.
But now we have the intermediary md_make_request so it makes
at lot more sense to pass a struct mddev_s.
It makes it possible to have an mddev without its own queue too.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/faulty.c    |    3 +--
 drivers/md/linear.c    |    7 +++----
 drivers/md/md.c        |    4 ++--
 drivers/md/md.h        |    2 +-
 drivers/md/multipath.c |    3 +--
 drivers/md/raid0.c     |    7 +++----
 drivers/md/raid1.c     |    3 +--
 drivers/md/raid10.c    |    7 +++----
 drivers/md/raid5.c     |    8 +++-----
 9 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 608a8d3..bd4348f 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -168,9 +168,8 @@ static void add_sector(conf_t *conf, sector_t start, int mode)
 		conf->nfaults = n+1;
 }
 
-static int make_request(struct request_queue *q, struct bio *bio)
+static int make_request(mddev_t *mddev, struct bio *bio)
 {
-	mddev_t *mddev = q->queuedata;
 	conf_t *conf = mddev->private;
 	int failit = 0;
 
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 93acbb2..cb58c35 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -285,9 +285,8 @@ static int linear_stop (mddev_t *mddev)
 	return 0;
 }
 
-static int linear_make_request (struct request_queue *q, struct bio *bio)
+static int linear_make_request (mddev_t *mddev, struct bio *bio)
 {
-	mddev_t *mddev = q->queuedata;
 	dev_info_t *tmp_dev;
 	sector_t start_sector;
 
@@ -327,9 +326,9 @@ static int linear_make_request (struct request_queue *q, struct bio *bio)
 
 		bp = bio_split(bio, end_sector - bio->bi_sector);
 
-		if (linear_make_request(q, &bp->bio1))
+		if (linear_make_request(mddev, &bp->bio1))
 			generic_make_request(&bp->bio1);
-		if (linear_make_request(q, &bp->bio2))
+		if (linear_make_request(mddev, &bp->bio2))
 			generic_make_request(&bp->bio2);
 		bio_pair_release(bp);
 		return 0;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ebc0fc9..967df62 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -240,7 +240,7 @@ static int md_make_request(struct request_queue *q, struct bio *bio)
 	atomic_inc(&mddev->active_io);
 	rcu_read_unlock();
 
-	rv = mddev->pers->make_request(q, bio);
+	rv = mddev->pers->make_request(mddev, bio);
 
 	cpu = part_stat_lock();
 	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
@@ -354,7 +354,7 @@ static void md_submit_barrier(struct work_struct *ws)
 		bio_endio(bio, 0);
 	else {
 		bio->bi_rw &= ~(1<<BIO_RW_BARRIER);
-		if (mddev->pers->make_request(mddev->queue, bio))
+		if (mddev->pers->make_request(mddev, bio))
 			generic_make_request(bio);
 		mddev->barrier = POST_REQUEST_BARRIER;
 		submit_barriers(mddev);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 3225e25..a536f54 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -330,7 +330,7 @@ struct mdk_personality
 	int level;
 	struct list_head list;
 	struct module *owner;
-	int (*make_request)(struct request_queue *q, struct bio *bio);
+	int (*make_request)(mddev_t *mddev, struct bio *bio);
 	int (*run)(mddev_t *mddev);
 	int (*stop)(mddev_t *mddev);
 	void (*status)(struct seq_file *seq, mddev_t *mddev);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 5b4e291..50bf8e6 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -135,9 +135,8 @@ static void multipath_unplug(struct request_queue *q)
 }
 
 
-static int multipath_make_request (struct request_queue *q, struct bio * bio)
+static int multipath_make_request(mddev_t *mddev, struct bio * bio)
 {
-	mddev_t *mddev = q->queuedata;
 	multipath_conf_t *conf = mddev->private;
 	struct multipath_bh * mp_bh;
 	struct multipath_info *multipath;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d535f9b..9f9c6b7 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -465,9 +465,8 @@ static inline int is_io_in_chunk_boundary(mddev_t *mddev,
 	}
 }
 
-static int raid0_make_request(struct request_queue *q, struct bio *bio)
+static int raid0_make_request(mddev_t *mddev, struct bio *bio)
 {
-	mddev_t *mddev = q->queuedata;
 	unsigned int chunk_sects;
 	sector_t sector_offset;
 	struct strip_zone *zone;
@@ -495,9 +494,9 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 		else
 			bp = bio_split(bio, chunk_sects -
 				       sector_div(sector, chunk_sects));
-		if (raid0_make_request(q, &bp->bio1))
+		if (raid0_make_request(mddev, &bp->bio1))
 			generic_make_request(&bp->bio1);
-		if (raid0_make_request(q, &bp->bio2))
+		if (raid0_make_request(mddev, &bp->bio2))
 			generic_make_request(&bp->bio2);
 
 		bio_pair_release(bp);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d751a5a..dd0ef70 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -773,9 +773,8 @@ do_sync_io:
 	return NULL;
 }
 
-static int make_request(struct request_queue *q, struct bio * bio)
+static int make_request(mddev_t *mddev, struct bio * bio)
 {
-	mddev_t *mddev = q->queuedata;
 	conf_t *conf = mddev->private;
 	mirror_info_t *mirror;
 	r1bio_t *r1_bio;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 00d2af6..4800299 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -788,9 +788,8 @@ static void unfreeze_array(conf_t *conf)
 	spin_unlock_irq(&conf->resync_lock);
 }
 
-static int make_request(struct request_queue *q, struct bio * bio)
+static int make_request(mddev_t *mddev, struct bio * bio)
 {
-	mddev_t *mddev = q->queuedata;
 	conf_t *conf = mddev->private;
 	mirror_info_t *mirror;
 	r10bio_t *r10_bio;
@@ -824,9 +823,9 @@ static int make_request(struct request_queue *q, struct bio * bio)
 		 */
 		bp = bio_split(bio,
 			       chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
-		if (make_request(q, &bp->bio1))
+		if (make_request(mddev, &bp->bio1))
 			generic_make_request(&bp->bio1);
-		if (make_request(q, &bp->bio2))
+		if (make_request(mddev, &bp->bio2))
 			generic_make_request(&bp->bio2);
 
 		bio_pair_release(bp);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 231afda..2882a26 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3753,9 +3753,8 @@ static int bio_fits_rdev(struct bio *bi)
 }
 
 
-static int chunk_aligned_read(struct request_queue *q, struct bio * raid_bio)
+static int chunk_aligned_read(mddev_t *mddev, struct bio * raid_bio)
 {
-	mddev_t *mddev = q->queuedata;
 	raid5_conf_t *conf = mddev->private;
 	int dd_idx;
 	struct bio* align_bi;
@@ -3870,9 +3869,8 @@ static struct stripe_head *__get_priority_stripe(raid5_conf_t *conf)
 	return sh;
 }
 
-static int make_request(struct request_queue *q, struct bio * bi)
+static int make_request(mddev_t *mddev, struct bio * bi)
 {
-	mddev_t *mddev = q->queuedata;
 	raid5_conf_t *conf = mddev->private;
 	int dd_idx;
 	sector_t new_sector;
@@ -3896,7 +3894,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 
 	if (rw == READ &&
 	     mddev->reshape_position == MaxSector &&
-	     chunk_aligned_read(q,bi))
+	     chunk_aligned_read(mddev,bi))
 		return 0;
 
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);


