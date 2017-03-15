From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 01/15] md/raid5: use md_write_start to count stripes,
 not bios
Date: Wed, 15 Mar 2017 14:05:12 +1100
Message-ID: <148954711202.18641.13511310650583146666.stgit@noble>
References: <148954692173.18641.1294690639716682540.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954692173.18641.1294690639716682540.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

We use md_write_start() to increase the count of pending writes, and
md_write_end() to decrement the count.  We currently count bios
submitted to md/raid5.  Change it count stripe_heads that a WRITE bio
has been attached to.

So now, raid5_make_request() calls md_write_start() and then
md_write_end() to keep the count elevated during the setup of the
request.

add_stripe_bio() calls md_write_start() for each stripe_head, and the
completion routines always call md_write_end(), instead of only
calling it when raid5_dec_bi_active_stripes() returns 0.
make_discard_request also calls md_write_start/end().

The parallel between md_write_{start,end} and use of bi_phys_segments
can be seen in that:
 Whenever we set bi_phys_segments to 1, we now call md_write_start.
 Whenever we increment it on non-read requests with
   raid5_inc_bi_active_stripes(), we now call md_write_start().
 Whenever we decrement bi_phys_segments on non-read requsts with
    raid5_dec_bi_active_stripes(), we now call md_write_end().

This reduces our dependence on keeping a per-bio count of active
stripes in bi_phys_segments.

md_write_inc() is added which parallels md_write_start(), but requires
that a write has already been started, and is certain never to sleep.
This can be used inside a spinlocked region when adding to a write
request.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c          |   17 +++++++++++++++++
 drivers/md/md.h          |    1 +
 drivers/md/raid5-cache.c |    2 +-
 drivers/md/raid5.c       |   27 +++++++++++++--------------
 4 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index af9118711228..bad5771bced4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7916,6 +7916,23 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 }
 EXPORT_SYMBOL(md_write_start);
 
+/* md_write_inc can only be called when md_write_start() has
+ * already been called at least once of the current request.
+ * It increments the counter and is useful when a single request
+ * is split into several parts.  Each part causes an increment and
+ * so needs a matching md_write_end().
+ * Unlike md_write_start(), it is safe to call md_write_inc() inside
+ * a spinlocked region.
+ */
+void md_write_inc(struct mddev *mddev, struct bio *bi)
+{
+	if (bio_data_dir(bi) != WRITE)
+		return;
+	WARN_ON_ONCE(mddev->in_sync || mddev->ro);
+	atomic_inc(&mddev->writes_pending);
+}
+EXPORT_SYMBOL(md_write_inc);
+
 void md_write_end(struct mddev *mddev)
 {
 	if (atomic_dec_and_test(&mddev->writes_pending)) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index e0940064c3ec..0cd12721a536 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -648,6 +648,7 @@ extern void md_wakeup_thread(struct md_thread *thread);
 extern void md_check_recovery(struct mddev *mddev);
 extern void md_reap_sync_thread(struct mddev *mddev);
 extern void md_write_start(struct mddev *mddev, struct bio *bi);
+extern void md_write_inc(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
 extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 64493132470b..f5034ecb4e94 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -318,8 +318,8 @@ r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev,
 	while (wbi && wbi->bi_iter.bi_sector <
 	       dev->sector + STRIPE_SECTORS) {
 		wbi2 = r5_next_bio(wbi, dev->sector);
+		md_write_end(conf->mddev);
 		if (!raid5_dec_bi_active_stripes(wbi)) {
-			md_write_end(conf->mddev);
 			bio_list_add(return_bi, wbi);
 		}
 		wbi = wbi2;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1c554a811d20..cc2d039b4aae 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3273,6 +3273,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 		bi->bi_next = *bip;
 	*bip = bi;
 	raid5_inc_bi_active_stripes(bi);
+	md_write_inc(conf->mddev, bi);
 
 	if (forwrite) {
 		/* check if page is covered */
@@ -3396,10 +3397,9 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
 
 			bi->bi_error = -EIO;
-			if (!raid5_dec_bi_active_stripes(bi)) {
-				md_write_end(conf->mddev);
+			md_write_end(conf->mddev);
+			if (!raid5_dec_bi_active_stripes(bi))
 				bio_list_add(return_bi, bi);
-			}
 			bi = nextbi;
 		}
 		if (bitmap_end)
@@ -3420,10 +3420,9 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
 
 			bi->bi_error = -EIO;
-			if (!raid5_dec_bi_active_stripes(bi)) {
-				md_write_end(conf->mddev);
+			md_write_end(conf->mddev);
+			if (!raid5_dec_bi_active_stripes(bi))
 				bio_list_add(return_bi, bi);
-			}
 			bi = bi2;
 		}
 
@@ -3780,10 +3779,9 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 				while (wbi && wbi->bi_iter.bi_sector <
 					dev->sector + STRIPE_SECTORS) {
 					wbi2 = r5_next_bio(wbi, dev->sector);
-					if (!raid5_dec_bi_active_stripes(wbi)) {
-						md_write_end(conf->mddev);
+					md_write_end(conf->mddev);
+					if (!raid5_dec_bi_active_stripes(wbi))
 						bio_list_add(return_bi, wbi);
-					}
 					wbi = wbi2;
 				}
 				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
@@ -5486,6 +5484,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1; /* over-loaded to count active stripes */
+	md_write_start(mddev, bi);
 
 	stripe_sectors = conf->chunk_sectors *
 		(conf->raid_disks - conf->max_degraded);
@@ -5532,6 +5531,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 			sh->dev[d].towrite = bi;
 			set_bit(R5_OVERWRITE, &sh->dev[d].flags);
 			raid5_inc_bi_active_stripes(bi);
+			md_write_inc(mddev, bi);
 			sh->overwrite_disks++;
 		}
 		spin_unlock_irq(&sh->stripe_lock);
@@ -5554,9 +5554,9 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		release_stripe_plug(mddev, sh);
 	}
 
+	md_write_end(mddev);
 	remaining = raid5_dec_bi_active_stripes(bi);
 	if (remaining == 0) {
-		md_write_end(mddev);
 		bio_endio(bi);
 	}
 }
@@ -5591,8 +5591,6 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 		do_flush = bi->bi_opf & REQ_PREFLUSH;
 	}
 
-	md_write_start(mddev, bi);
-
 	/*
 	 * If array is degraded, better not do chunk aligned read because
 	 * later we might have to read it again in order to reconstruct
@@ -5614,6 +5612,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	last_sector = bio_end_sector(bi);
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
+	md_write_start(mddev, bi);
 
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
@@ -5748,11 +5747,11 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	}
 	finish_wait(&conf->wait_for_overlap, &w);
 
+	if (rw == WRITE)
+		md_write_end(mddev);
 	remaining = raid5_dec_bi_active_stripes(bi);
 	if (remaining == 0) {
 
-		if ( rw == WRITE )
-			md_write_end(mddev);
 
 		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
 					 bi, 0);


