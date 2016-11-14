From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 4/4] md/raid1,
 raid10: add blktrace records when IO is delayed.
Date: Mon, 14 Nov 2016 16:30:21 +1100
Message-ID: <147910142139.27168.5325871080844069318.stgit@noble>
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

Both raid1 and raid10 will sometimes delay handling an IO request,
such as when resync is happening or there are too many requests queued.

Add some blktrace messsages so we can see when that is happening when
looking for performance artefacts.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c  |    8 ++++++++
 drivers/md/raid10.c |    8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0674e5a0142e..e94db92a4dbf 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -71,6 +71,9 @@ static void allow_barrier(struct r1conf *conf, sector_t start_next_window,
 			  sector_t bi_sector);
 static void lower_barrier(struct r1conf *conf);
 
+#define raid1_log(md, fmt, args...)				\
+	do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid1 " fmt, ##args); } while (0)
+
 static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct pool_info *pi = data;
@@ -868,6 +871,7 @@ static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
 		 * that queue to allow conf->start_next_window
 		 * to increase.
 		 */
+		raid1_log(conf->mddev, "wait barrier");
 		wait_event_lock_irq(conf->wait_barrier,
 				    !conf->array_frozen &&
 				    (!conf->barrier ||
@@ -947,6 +951,7 @@ static void freeze_array(struct r1conf *conf, int extra)
 	 */
 	spin_lock_irq(&conf->resync_lock);
 	conf->array_frozen = 1;
+	raid1_log(conf->mddev, "wait freeze");
 	wait_event_lock_irq_cmd(conf->wait_barrier,
 				conf->nr_pending == conf->nr_queued+extra,
 				conf->resync_lock,
@@ -1157,6 +1162,7 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
 			 * take care not to over-take any writes
 			 * that are 'behind'
 			 */
+			raid1_log(mddev, "wait behind writes");
 			wait_event(bitmap->behind_wait,
 				   atomic_read(&bitmap->behind_writes) == 0);
 		}
@@ -1221,6 +1227,7 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
 	 */
 	if (conf->pending_count >= max_queued_requests) {
 		md_wakeup_thread(mddev->thread);
+		raid1_log(mddev, "wait queued");
 		wait_event(conf->wait_barrier,
 			   conf->pending_count < max_queued_requests);
 	}
@@ -1312,6 +1319,7 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
 				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
 		r1_bio->state = 0;
 		allow_barrier(conf, start_next_window, bio->bi_iter.bi_sector);
+		raid1_log(mddev, "wait rdev %d blocked", blocked_rdev->raid_disk);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
 		start_next_window = wait_barrier(conf, bio);
 		/*
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c3036099ff9a..15e55488a9d2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -106,6 +106,9 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio);
 static void end_reshape_write(struct bio *bio);
 static void end_reshape(struct r10conf *conf);
 
+#define raid10_log(md, fmt, args...)				\
+	do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid10 " fmt, ##args); } while (0)
+
 static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct r10conf *conf = data;
@@ -949,6 +952,7 @@ static void wait_barrier(struct r10conf *conf)
 		 * that queue to get the nr_pending
 		 * count down.
 		 */
+		raid10_log(conf->mddev, "wait barrier");
 		wait_event_lock_irq(conf->wait_barrier,
 				    !conf->barrier ||
 				    (atomic_read(&conf->nr_pending) &&
@@ -1106,6 +1110,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 		/* IO spans the reshape position.  Need to wait for
 		 * reshape to pass
 		 */
+		raid10_log(conf->mddev, "wait reshape");
 		allow_barrier(conf);
 		wait_event(conf->wait_barrier,
 			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
@@ -1125,6 +1130,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 		set_mask_bits(&mddev->flags, 0,
 			      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
 		md_wakeup_thread(mddev->thread);
+		raid10_log(conf->mddev, "wait reshape metadata");
 		wait_event(mddev->sb_wait,
 			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
 
@@ -1222,6 +1228,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 	 */
 	if (conf->pending_count >= max_queued_requests) {
 		md_wakeup_thread(mddev->thread);
+		raid10_log(mddev, "wait queued");
 		wait_event(conf->wait_barrier,
 			   conf->pending_count < max_queued_requests);
 	}
@@ -1349,6 +1356,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 			}
 		}
 		allow_barrier(conf);
+		raid10_log(conf->mddev, "wait rdev %d blocked", blocked_rdev->raid_disk);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
 		wait_barrier(conf);
 		goto retry_write;


