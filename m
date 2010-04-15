From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 16/28] md: move io accounting out of personalities into
	md_make_request
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.90105.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

While I generally prefer letting personalities do as much as possible,
given that we have a central md_make_request anyway we may as well use
it to simplify code.
Also this centralises knowledge of ->gendisk which will help later.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/linear.c    |    8 --------
 drivers/md/md.c        |   11 +++++++++++
 drivers/md/multipath.c |    8 --------
 drivers/md/raid0.c     |    8 --------
 drivers/md/raid1.c     |    7 -------
 drivers/md/raid10.c    |    7 -------
 drivers/md/raid5.c     |    8 +-------
 7 files changed, 12 insertions(+), 45 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index bb2a231..93acbb2 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -287,23 +287,15 @@ static int linear_stop (mddev_t *mddev)
 
 static int linear_make_request (struct request_queue *q, struct bio *bio)
 {
-	const int rw = bio_data_dir(bio);
 	mddev_t *mddev = q->queuedata;
 	dev_info_t *tmp_dev;
 	sector_t start_sector;
-	int cpu;
 
 	if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER))) {
 		md_barrier_request(mddev, bio);
 		return 0;
 	}
 
-	cpu = part_stat_lock();
-	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
-	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
-		      bio_sectors(bio));
-	part_stat_unlock();
-
 	rcu_read_lock();
 	tmp_dev = which_dev(mddev, bio->bi_sector);
 	start_sector = tmp_dev->end_sector - tmp_dev->rdev->sectors;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index afe1065..16f032b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -214,8 +214,11 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
  */
 static int md_make_request(struct request_queue *q, struct bio *bio)
 {
+	const int rw = bio_data_dir(bio);
 	mddev_t *mddev = q->queuedata;
 	int rv;
+	int cpu;
+
 	if (mddev == NULL || mddev->pers == NULL) {
 		bio_io_error(bio);
 		return 0;
@@ -236,7 +239,15 @@ static int md_make_request(struct request_queue *q, struct bio *bio)
 	}
 	atomic_inc(&mddev->active_io);
 	rcu_read_unlock();
+
 	rv = mddev->pers->make_request(q, bio);
+
+	cpu = part_stat_lock();
+	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
+	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
+		      bio_sectors(bio));
+	part_stat_unlock();
+
 	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
 		wake_up(&mddev->sb_wait);
 
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 97befd5..5b4e291 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -141,8 +141,6 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
 	multipath_conf_t *conf = mddev->private;
 	struct multipath_bh * mp_bh;
 	struct multipath_info *multipath;
-	const int rw = bio_data_dir(bio);
-	int cpu;
 
 	if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER))) {
 		md_barrier_request(mddev, bio);
@@ -154,12 +152,6 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
 
-	cpu = part_stat_lock();
-	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
-	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
-		      bio_sectors(bio));
-	part_stat_unlock();
-
 	mp_bh->path = multipath_map(conf);
 	if (mp_bh->path < 0) {
 		bio_endio(bio, -EIO);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index afddf62..d535f9b 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -472,20 +472,12 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 	sector_t sector_offset;
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
-	const int rw = bio_data_dir(bio);
-	int cpu;
 
 	if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER))) {
 		md_barrier_request(mddev, bio);
 		return 0;
 	}
 
-	cpu = part_stat_lock();
-	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
-	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
-		      bio_sectors(bio));
-	part_stat_unlock();
-
 	chunk_sects = mddev->chunk_sectors;
 	if (unlikely(!is_io_in_chunk_boundary(mddev, chunk_sects, bio))) {
 		sector_t sector = bio->bi_sector;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ff6f97b..d63f3ee 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -787,7 +787,6 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	struct page **behind_pages = NULL;
 	const int rw = bio_data_dir(bio);
 	const bool do_sync = bio_rw_flagged(bio, BIO_RW_SYNCIO);
-	int cpu;
 	bool do_barriers;
 	mdk_rdev_t *blocked_rdev;
 
@@ -833,12 +832,6 @@ static int make_request(struct request_queue *q, struct bio * bio)
 
 	bitmap = mddev->bitmap;
 
-	cpu = part_stat_lock();
-	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
-	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
-		      bio_sectors(bio));
-	part_stat_unlock();
-
 	/*
 	 * make_request() can abort the operation when READA is being
 	 * used and no empty request is available.
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index beab7f6..00d2af6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -795,7 +795,6 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	mirror_info_t *mirror;
 	r10bio_t *r10_bio;
 	struct bio *read_bio;
-	int cpu;
 	int i;
 	int chunk_sects = conf->chunk_mask + 1;
 	const int rw = bio_data_dir(bio);
@@ -850,12 +849,6 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	 */
 	wait_barrier(conf);
 
-	cpu = part_stat_lock();
-	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
-	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
-		      bio_sectors(bio));
-	part_stat_unlock();
-
 	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
 	r10_bio->master_bio = bio;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7bfeba3..c6ae7c1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3879,7 +3879,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
 	const int rw = bio_data_dir(bi);
-	int cpu, remaining;
+	int remaining;
 
 	if (unlikely(bio_rw_flagged(bi, BIO_RW_BARRIER))) {
 		/* Drain all pending writes.  We only really need
@@ -3894,12 +3894,6 @@ static int make_request(struct request_queue *q, struct bio * bi)
 
 	md_write_start(mddev, bi);
 
-	cpu = part_stat_lock();
-	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
-	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
-		      bio_sectors(bi));
-	part_stat_unlock();
-
 	if (rw == READ &&
 	     mddev->reshape_position == MaxSector &&
 	     chunk_aligned_read(q,bi))


