From: Shaohua Li <shli@kernel.org>
Subject: [patch 07/10 v3] md: personality can provide unplug private data
Date: Mon, 25 Jun 2012 15:24:54 +0800
Message-ID: <20120625072653.743080746@kernel.org>
References: <20120625072447.268095276@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=md-plug-add-callback.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

Allow personality providing unplug private data. Next patch will use it.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/md.c     |   31 +++++++++++++------------------
 drivers/md/md.h     |   20 +++++++++++++++++++-
 drivers/md/raid1.c  |    2 +-
 drivers/md/raid10.c |    2 +-
 drivers/md/raid5.c  |    2 +-
 5 files changed, 35 insertions(+), 22 deletions(-)

Index: linux/drivers/md/md.c
===================================================================
--- linux.orig/drivers/md/md.c	2012-06-25 14:36:13.668642048 +0800
+++ linux/drivers/md/md.c	2012-06-25 14:38:33.106889041 +0800
@@ -498,22 +498,13 @@ void md_flush_request(struct mddev *mdde
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
 
 static void plugger_unplug(struct blk_plug_cb *cb)
 {
 	struct md_plug_cb *mdcb = container_of(cb, struct md_plug_cb, cb);
+
+	if (mdcb->unplug)
+		mdcb->unplug(mdcb);
 	if (atomic_dec_and_test(&mdcb->mddev->plug_cnt))
 		md_wakeup_thread(mdcb->mddev->thread);
 	kfree(mdcb);
@@ -522,13 +513,14 @@ static void plugger_unplug(struct blk_pl
 /* Check that an unplug wakeup will come shortly.
  * If not, wakeup the md thread immediately
  */
-int mddev_check_plugged(struct mddev *mddev)
+struct md_plug_cb *mddev_check_plugged(struct mddev *mddev,
+	md_unplug_func_t unplug, size_t size)
 {
 	struct blk_plug *plug = current->plug;
 	struct md_plug_cb *mdcb;
 
 	if (!plug)
-		return 0;
+		return NULL;
 
 	list_for_each_entry(mdcb, &plug->cb_list, cb.list) {
 		if (mdcb->cb.callback == plugger_unplug &&
@@ -538,19 +530,22 @@ int mddev_check_plugged(struct mddev *md
 						    struct md_plug_cb,
 						    cb.list))
 				list_move(&mdcb->cb.list, &plug->cb_list);
-			return 1;
+			return mdcb;
 		}
 	}
 	/* Not currently on the callback list */
-	mdcb = kmalloc(sizeof(*mdcb), GFP_ATOMIC);
+	mdcb = kmalloc(sizeof(*mdcb) + size, GFP_ATOMIC);
 	if (!mdcb)
-		return 0;
+		return NULL;
 
 	mdcb->mddev = mddev;
 	mdcb->cb.callback = plugger_unplug;
 	atomic_inc(&mddev->plug_cnt);
 	list_add(&mdcb->cb.list, &plug->cb_list);
-	return 1;
+	mdcb->unplug = unplug;
+	if (size)
+		memset((void *)(mdcb + 1), 0, size);
+	return mdcb;
 }
 EXPORT_SYMBOL_GPL(mddev_check_plugged);
 
Index: linux/drivers/md/md.h
===================================================================
--- linux.orig/drivers/md/md.h	2012-06-25 14:36:13.676641948 +0800
+++ linux/drivers/md/md.h	2012-06-25 14:38:33.106889041 +0800
@@ -630,6 +630,24 @@ extern struct bio *bio_clone_mddev(struc
 				   struct mddev *mddev);
 extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 				   struct mddev *mddev);
-extern int mddev_check_plugged(struct mddev *mddev);
+
+/* Support for plugging.
+ * This mirrors the plugging support in request_queue, but does not
+ * require having a whole queue or request structures.
+ * We allocate an md_plug_cb for each md device and each thread it gets
+ * plugged on.  This links tot the private plug_handle structure in the
+ * personality data where we keep a count of the number of outstanding
+ * plugs so other code can see if a plug is active.
+ */
+struct md_plug_cb;
+typedef void (*md_unplug_func_t)(struct md_plug_cb *mdcb);
+struct md_plug_cb {
+	struct blk_plug_cb cb;
+	struct mddev *mddev;
+	md_unplug_func_t unplug;
+};
+
+extern struct md_plug_cb *mddev_check_plugged(struct mddev *mddev,
+	md_unplug_func_t unplug, size_t size);
 extern void md_trim_bio(struct bio *bio, int offset, int size);
 #endif /* _MD_MD_H */
Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-06-25 14:36:13.696641695 +0800
+++ linux/drivers/md/raid1.c	2012-06-25 14:38:33.110889008 +0800
@@ -1034,7 +1034,7 @@ read_again:
 	 * the bad blocks.  Each set of writes gets it's own r1bio
 	 * with a set of bios attached.
 	 */
-	plugged = mddev_check_plugged(mddev);
+	plugged = !!mddev_check_plugged(mddev, NULL, 0);
 
 	disks = conf->raid_disks * 2;
  retry_write:
Index: linux/drivers/md/raid10.c
===================================================================
--- linux.orig/drivers/md/raid10.c	2012-06-25 14:36:13.684641847 +0800
+++ linux/drivers/md/raid10.c	2012-06-25 14:38:33.110889008 +0800
@@ -1239,7 +1239,7 @@ read_again:
 	 * of r10_bios is recored in bio->bi_phys_segments just as with
 	 * the read case.
 	 */
-	plugged = mddev_check_plugged(mddev);
+	plugged = !!mddev_check_plugged(mddev, NULL, 0);
 
 	r10_bio->read_slot = -1; /* make sure repl_bio gets freed */
 	raid10_find_phys(conf, r10_bio);
Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-25 14:38:13.899130571 +0800
+++ linux/drivers/md/raid5.c	2012-06-25 14:38:33.110889008 +0800
@@ -4012,7 +4012,7 @@ static void make_request(struct mddev *m
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
 
-	plugged = mddev_check_plugged(mddev);
+	plugged = !!mddev_check_plugged(mddev, NULL, 0);
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
 		int previous;

