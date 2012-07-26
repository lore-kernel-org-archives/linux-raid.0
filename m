From: NeilBrown <neilb@suse.de>
Subject: [PATCH 2/4] blk: centralize non-request unplug handling.
Date: Thu, 26 Jul 2012 12:58:30 +1000
Message-ID: <20120726025830.32180.61903.stgit@notabene.brown>
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

Both md and umem has similar code for getting notified on an
blk_finish_plug event.
Centralize this code in block/ and allow each driver to
provide its distinctive difference.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 block/blk-core.c       |   25 +++++++++++++++++++++
 drivers/block/umem.c   |   35 +++++-------------------------
 drivers/md/md.c        |   56 ++++--------------------------------------------
 drivers/md/md.h        |    8 ++++++-
 include/linux/blkdev.h |    8 +++++--
 5 files changed, 49 insertions(+), 83 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 93eb3e4..7296d3d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2914,6 +2914,31 @@ static void flush_plug_callbacks(struct blk_plug *plug)
 	}
 }
 
+struct blk_plug_cb *blk_check_plugged(blk_plug_cb_fn unplug, void *data,
+				      int size)
+{
+	struct blk_plug *plug = current->plug;
+	struct blk_plug_cb *cb;
+
+	if (!plug)
+		return NULL;
+
+	list_for_each_entry(cb, &plug->cb_list, list)
+		if (cb->callback == unplug && cb->data == data)
+			return cb;
+
+	/* Not currently on the callback list */
+	BUG_ON(size < sizeof(*cb));
+	cb = kzalloc(size, GFP_ATOMIC);
+	if (cb) {
+		cb->data = data;
+		cb->callback = unplug;
+		list_add(&cb->list, &plug->cb_list);
+	}
+	return cb;
+}
+EXPORT_SYMBOL(blk_check_plugged);
+
 void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 {
 	struct request_queue *q;
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 9a72277..6ef3489 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -513,42 +513,19 @@ static void process_page(unsigned long data)
 	}
 }
 
-struct mm_plug_cb {
-	struct blk_plug_cb cb;
-	struct cardinfo *card;
-};
-
 static void mm_unplug(struct blk_plug_cb *cb)
 {
-	struct mm_plug_cb *mmcb = container_of(cb, struct mm_plug_cb, cb);
+	struct cardinfo *card = cb->data;
 
-	spin_lock_irq(&mmcb->card->lock);
-	activate(mmcb->card);
-	spin_unlock_irq(&mmcb->card->lock);
-	kfree(mmcb);
+	spin_lock_irq(&card->lock);
+	activate(card);
+	spin_unlock_irq(&card->lock);
+	kfree(cb);
 }
 
 static int mm_check_plugged(struct cardinfo *card)
 {
-	struct blk_plug *plug = current->plug;
-	struct mm_plug_cb *mmcb;
-
-	if (!plug)
-		return 0;
-
-	list_for_each_entry(mmcb, &plug->cb_list, cb.list) {
-		if (mmcb->cb.callback == mm_unplug && mmcb->card == card)
-			return 1;
-	}
-	/* Not currently on the callback list */
-	mmcb = kmalloc(sizeof(*mmcb), GFP_ATOMIC);
-	if (!mmcb)
-		return 0;
-
-	mmcb->card = card;
-	mmcb->cb.callback = mm_unplug;
-	list_add(&mmcb->cb.list, &plug->cb_list);
-	return 1;
+	return !!blk_check_plugged(mm_unplug, card, sizeof(struct blk_plug_cb));
 }
 
 static void mm_make_request(struct request_queue *q, struct bio *bio)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3438117..b493fa4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -498,59 +498,13 @@ void md_flush_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_flush_request);
 
-/* Support for plugging.
- * This mirrors the plugging support in request_queue, but does not
- * require having a whole queue or request structures.
- * We allocate an md_plug_cb for each md device and each thread it gets
- * plugged on.  This links tot the private plug_handle structure in the
- * personality data where we keep a count of the number of outstanding
- * plugs so other code can see if a plug is active.
- */
-struct md_plug_cb {
-	struct blk_plug_cb cb;
-	struct mddev *mddev;
-};
-
-static void plugger_unplug(struct blk_plug_cb *cb)
+void md_unplug(struct blk_plug_cb *cb)
 {
-	struct md_plug_cb *mdcb = container_of(cb, struct md_plug_cb, cb);
-	md_wakeup_thread(mdcb->mddev->thread);
-	kfree(mdcb);
-}
-
-/* Check that an unplug wakeup will come shortly.
- * If not, wakeup the md thread immediately
- */
-int mddev_check_plugged(struct mddev *mddev)
-{
-	struct blk_plug *plug = current->plug;
-	struct md_plug_cb *mdcb;
-
-	if (!plug)
-		return 0;
-
-	list_for_each_entry(mdcb, &plug->cb_list, cb.list) {
-		if (mdcb->cb.callback == plugger_unplug &&
-		    mdcb->mddev == mddev) {
-			/* Already on the list, move to top */
-			if (mdcb != list_first_entry(&plug->cb_list,
-						    struct md_plug_cb,
-						    cb.list))
-				list_move(&mdcb->cb.list, &plug->cb_list);
-			return 1;
-		}
-	}
-	/* Not currently on the callback list */
-	mdcb = kmalloc(sizeof(*mdcb), GFP_ATOMIC);
-	if (!mdcb)
-		return 0;
-
-	mdcb->mddev = mddev;
-	mdcb->cb.callback = plugger_unplug;
-	list_add(&mdcb->cb.list, &plug->cb_list);
-	return 1;
+	struct mddev *mddev = cb->data;
+	md_wakeup_thread(mddev->thread);
+	kfree(cb);
 }
-EXPORT_SYMBOL_GPL(mddev_check_plugged);
+EXPORT_SYMBOL(md_unplug);
 
 static inline struct mddev *mddev_get(struct mddev *mddev)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 91786c4..8f998e0 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -627,6 +627,12 @@ extern struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 				   struct mddev *mddev);
 extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 				   struct mddev *mddev);
-extern int mddev_check_plugged(struct mddev *mddev);
 extern void md_trim_bio(struct bio *bio, int offset, int size);
+
+extern void md_unplug(struct blk_plug_cb *cb);
+static inline int mddev_check_plugged(struct mddev *mddev)
+{
+	return !!blk_check_plugged(md_unplug, mddev,
+				   sizeof(struct blk_plug_cb));
+}
 #endif /* _MD_MD_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 07954b0..68ba19d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -911,11 +911,15 @@ struct blk_plug {
 };
 #define BLK_MAX_REQUEST_COUNT 16
 
+struct blk_plug_cb;
+typedef void (*blk_plug_cb_fn)(struct blk_plug_cb *);
 struct blk_plug_cb {
 	struct list_head list;
-	void (*callback)(struct blk_plug_cb *);
+	blk_plug_cb_fn callback;
+	void *data;
 };
-
+extern struct blk_plug_cb *blk_check_plugged(blk_plug_cb_fn unplug,
+					     void *data, int size);
 extern void blk_start_plug(struct blk_plug *);
 extern void blk_finish_plug(struct blk_plug *);
 extern void blk_flush_plug_list(struct blk_plug *, bool);


