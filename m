From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 004 of 7] Fail IO request to md that require a barrier.
Date: Tue, 02 Aug 2005 19:53:41 +1000
Message-ID: <E1DztSv-0004VX-NK@notabene.cse.unsw.edu.au>
References: <20050802193525.12307.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


md does not yet support BIO_RW_BARRIER, so be honest about it
and fail (-EOPNOTSUPP) any such requests.


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/linear.c    |    5 +++++
 ./drivers/md/multipath.c |    5 +++++
 ./drivers/md/raid0.c     |    5 +++++
 ./drivers/md/raid1.c     |    4 ++++
 ./drivers/md/raid10.c    |    5 +++++
 ./drivers/md/raid5.c     |    5 +++++
 ./drivers/md/raid6main.c |    5 +++++
 7 files changed, 34 insertions(+)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2005-08-02 15:23:02.000000000 +1000
+++ ./drivers/md/linear.c	2005-08-02 15:23:02.000000000 +1000
@@ -238,6 +238,11 @@ static int linear_make_request (request_
 	dev_info_t *tmp_dev;
 	sector_t block;
 
+	if (unlikely(bio_barrier(bio))) {
+		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+		return 0;
+	}
+
 	if (bio_data_dir(bio)==WRITE) {
 		disk_stat_inc(mddev->gendisk, writes);
 		disk_stat_add(mddev->gendisk, write_sectors, bio_sectors(bio));

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2005-08-02 15:23:02.000000000 +1000
+++ ./drivers/md/multipath.c	2005-08-02 15:23:02.000000000 +1000
@@ -169,6 +169,11 @@ static int multipath_make_request (reque
 	struct multipath_bh * mp_bh;
 	struct multipath_info *multipath;
 
+	if (unlikely(bio_barrier(bio))) {
+		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+		return 0;
+	}
+
 	mp_bh = mempool_alloc(conf->pool, GFP_NOIO);
 
 	mp_bh->master_bio = bio;

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2005-08-02 15:23:02.000000000 +1000
+++ ./drivers/md/raid0.c	2005-08-02 15:23:02.000000000 +1000
@@ -404,6 +404,11 @@ static int raid0_make_request (request_q
 	unsigned long chunk;
 	sector_t block, rsect;
 
+	if (unlikely(bio_barrier(bio))) {
+		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+		return 0;
+	}
+
 	if (bio_data_dir(bio)==WRITE) {
 		disk_stat_inc(mddev->gendisk, writes);
 		disk_stat_add(mddev->gendisk, write_sectors, bio_sectors(bio));

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-08-02 15:23:02.000000000 +1000
+++ ./drivers/md/raid1.c	2005-08-02 15:23:02.000000000 +1000
@@ -555,6 +555,10 @@ static int make_request(request_queue_t 
 	unsigned long flags;
 	struct bio_list bl;
 
+	if (unlikely(bio_barrier(bio))) {
+		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+		return 0;
+	}
 
 	/*
 	 * Register the new request and wait if the reconstruction

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-08-02 15:22:31.000000000 +1000
+++ ./drivers/md/raid10.c	2005-08-02 15:23:02.000000000 +1000
@@ -669,6 +669,11 @@ static int make_request(request_queue_t 
 	int i;
 	int chunk_sects = conf->chunk_mask + 1;
 
+	if (unlikely(bio_barrier(bio))) {
+		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+		return 0;
+	}
+
 	/* If this request crosses a chunk boundary, we need to
 	 * split it.  This will only happen for 1 PAGE (or less) requests.
 	 */

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-08-02 15:22:06.000000000 +1000
+++ ./drivers/md/raid5.c	2005-08-02 15:23:02.000000000 +1000
@@ -1411,6 +1411,11 @@ static int make_request (request_queue_t
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
 
+	if (unlikely(bio_barrier(bi))) {
+		bio_endio(bi, bi->bi_size, -EOPNOTSUPP);
+		return 0;
+	}
+
 	md_write_start(mddev, bi);
 
 	if (bio_data_dir(bi)==WRITE) {

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-08-02 15:22:06.000000000 +1000
+++ ./drivers/md/raid6main.c	2005-08-02 15:23:02.000000000 +1000
@@ -1570,6 +1570,11 @@ static int make_request (request_queue_t
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
 
+	if (unlikely(bio_barrier(bi))) {
+		bio_endio(bi, bi->bi_size, -EOPNOTSUPP);
+		return 0;
+	}
+
 	md_write_start(mddev, bi);
 
 	if (bio_data_dir(bi)==WRITE) {
