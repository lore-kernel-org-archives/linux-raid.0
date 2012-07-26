From: NeilBrown <neilb@suse.de>
Subject: [PATCH 4/4] blk: pass from_schedule to non-request unplug functions.
Date: Thu, 26 Jul 2012 12:58:30 +1000
Message-ID: <20120726025830.32180.24794.stgit@notabene.brown>
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

This will allow md/raid to know why the unplug was called,
and will be able to act according - if !from_schedule it
is safe to perform tasks which could themselves schedule.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 block/blk-core.c       |    6 +++---
 drivers/block/umem.c   |    2 +-
 drivers/md/md.c        |    2 +-
 drivers/md/md.h        |    2 +-
 include/linux/blkdev.h |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bf38a5b..c3b17c3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2896,7 +2896,7 @@ static void queue_unplugged(struct request_queue *q, unsigned int depth,
 
 }
 
-static void flush_plug_callbacks(struct blk_plug *plug)
+static void flush_plug_callbacks(struct blk_plug *plug, bool from_schedule)
 {
 	LIST_HEAD(callbacks);
 
@@ -2908,7 +2908,7 @@ static void flush_plug_callbacks(struct blk_plug *plug)
 							  struct blk_plug_cb,
 							  list);
 			list_del(&cb->list);
-			cb->callback(cb);
+			cb->callback(cb, from_schedule);
 		}
 	}
 }
@@ -2948,7 +2948,7 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 
 	BUG_ON(plug->magic != PLUG_MAGIC);
 
-	flush_plug_callbacks(plug);
+	flush_plug_callbacks(plug, from_schedule);
 	if (list_empty(&plug->list))
 		return;
 
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 6ef3489..eb0d821 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -513,7 +513,7 @@ static void process_page(unsigned long data)
 	}
 }
 
-static void mm_unplug(struct blk_plug_cb *cb)
+static void mm_unplug(struct blk_plug_cb *cb, bool from_schedule)
 {
 	struct cardinfo *card = cb->data;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b493fa4..db02d2e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -498,7 +498,7 @@ void md_flush_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_flush_request);
 
-void md_unplug(struct blk_plug_cb *cb)
+void md_unplug(struct blk_plug_cb *cb, bool from_schedule)
 {
 	struct mddev *mddev = cb->data;
 	md_wakeup_thread(mddev->thread);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8f998e0..f385b03 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -629,7 +629,7 @@ extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 				   struct mddev *mddev);
 extern void md_trim_bio(struct bio *bio, int offset, int size);
 
-extern void md_unplug(struct blk_plug_cb *cb);
+extern void md_unplug(struct blk_plug_cb *cb, bool from_schedule);
 static inline int mddev_check_plugged(struct mddev *mddev)
 {
 	return !!blk_check_plugged(md_unplug, mddev,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 68ba19d..2698866 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -912,7 +912,7 @@ struct blk_plug {
 #define BLK_MAX_REQUEST_COUNT 16
 
 struct blk_plug_cb;
-typedef void (*blk_plug_cb_fn)(struct blk_plug_cb *);
+typedef void (*blk_plug_cb_fn)(struct blk_plug_cb *, bool);
 struct blk_plug_cb {
 	struct list_head list;
 	blk_plug_cb_fn callback;


