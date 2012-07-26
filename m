From: NeilBrown <neilb@suse.de>
Subject: [PATCH 1/4] md: remove plug_cnt feature of plugging.
Date: Thu, 26 Jul 2012 12:58:30 +1000
Message-ID: <20120726025829.32180.72916.stgit@notabene.brown>
References: <20120726025650.32180.65163.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120726025650.32180.65163.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

This seemed like a good idea at the time, but after further thought I
cannot see it making a difference other than very occasionally and
testing to try to exercise the case it is most likely to help did not
show any performance difference by removing it.

So remove the counting of active plugs and allow 'pending writes' to
be activated at any time, not just when no plugs are active.

This is only relevant when there is a write-intent bitmap, and the
updating of the bitmap will likely introduce enough delay that
the single-threading of bitmap updates will be enough to collect large
numbers of updates together.

Removing this will make it easier to centralise the unplug code, and
will clear the other for other unplug enhancements which have a
measurable effect.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c     |    5 +----
 drivers/md/md.h     |    3 ---
 drivers/md/raid1.c  |    3 +--
 drivers/md/raid10.c |    3 +--
 drivers/md/raid5.c  |    5 ++---
 5 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d5ab449..3438117 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -514,8 +514,7 @@ struct md_plug_cb {
 static void plugger_unplug(struct blk_plug_cb *cb)
 {
 	struct md_plug_cb *mdcb = container_of(cb, struct md_plug_cb, cb);
-	if (atomic_dec_and_test(&mdcb->mddev->plug_cnt))
-		md_wakeup_thread(mdcb->mddev->thread);
+	md_wakeup_thread(mdcb->mddev->thread);
 	kfree(mdcb);
 }
 
@@ -548,7 +547,6 @@ int mddev_check_plugged(struct mddev *mddev)
 
 	mdcb->mddev = mddev;
 	mdcb->cb.callback = plugger_unplug;
-	atomic_inc(&mddev->plug_cnt);
 	list_add(&mdcb->cb.list, &plug->cb_list);
 	return 1;
 }
@@ -602,7 +600,6 @@ void mddev_init(struct mddev *mddev)
 	atomic_set(&mddev->active, 1);
 	atomic_set(&mddev->openers, 0);
 	atomic_set(&mddev->active_io, 0);
-	atomic_set(&mddev->plug_cnt, 0);
 	spin_lock_init(&mddev->write_lock);
 	atomic_set(&mddev->flush_pending, 0);
 	init_waitqueue_head(&mddev->sb_wait);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7b4a3c3..91786c4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -266,9 +266,6 @@ struct mddev {
 	int				new_chunk_sectors;
 	int				reshape_backwards;
 
-	atomic_t			plug_cnt;	/* If device is expecting
-							 * more bios soon.
-							 */
 	struct md_thread		*thread;	/* management thread */
 	struct md_thread		*sync_thread;	/* doing resync or reconstruct */
 	sector_t			curr_resync;	/* last block scheduled */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cacd008..36a8fc0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2173,8 +2173,7 @@ static void raid1d(struct mddev *mddev)
 	blk_start_plug(&plug);
 	for (;;) {
 
-		if (atomic_read(&mddev->plug_cnt) == 0)
-			flush_pending_writes(conf);
+		flush_pending_writes(conf);
 
 		spin_lock_irqsave(&conf->device_lock, flags);
 		if (list_empty(head)) {
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8da6282..5d33603 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2660,8 +2660,7 @@ static void raid10d(struct mddev *mddev)
 	blk_start_plug(&plug);
 	for (;;) {
 
-		if (atomic_read(&mddev->plug_cnt) == 0)
-			flush_pending_writes(conf);
+		flush_pending_writes(conf);
 
 		spin_lock_irqsave(&conf->device_lock, flags);
 		if (list_empty(head)) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c2192a2..3caf08a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4552,7 +4552,7 @@ static void raid5d(struct mddev *mddev)
 	while (1) {
 		struct bio *bio;
 
-		if (atomic_read(&mddev->plug_cnt) == 0 &&
+		if (
 		    !list_empty(&conf->bitmap_list)) {
 			/* Now is a good time to flush some bitmap updates */
 			conf->seq_flush++;
@@ -4562,8 +4562,7 @@ static void raid5d(struct mddev *mddev)
 			conf->seq_write = conf->seq_flush;
 			activate_bit_delay(conf);
 		}
-		if (atomic_read(&mddev->plug_cnt) == 0)
-			raid5_activate_delayed(conf);
+		raid5_activate_delayed(conf);
 
 		while ((bio = remove_bio_from_retry(conf))) {
 			int ok;


