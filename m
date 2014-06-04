From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: [RFC PATCH 2/4] md: introduce request function mode support
Date: Wed,  4 Jun 2014 19:10:00 +0200
Message-ID: <1401901802-16296-3-git-send-email-sebastian.riemer@profitbricks.com>
References: <20140602202050.14903534@notabene.brown>
 <1401901802-16296-1-git-send-email-sebastian.riemer@profitbricks.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1401901802-16296-1-git-send-email-sebastian.riemer@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Florian-Ewald Mueller <florian-ewald.mueller@profitbricks.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

From: Florian-Ewald Mueller <florian-ewald.mueller@profitbricks.com>

This introduces the writable module parameter 'rq_mode' which is
used to set the I/O mode for all subsequently created MD devices.
Set it to 0 for the default mode (the make request function mode)
in order to process I/O bio-by-bio or set it to 1 for the new
request function mode to process I/O request-by-request. Common
code is shared between both modes.

The advantage of the new mode is that a scheduler can be used and
the block layer cares for I/O statistics.

Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@profitbricks.com>
[spars: merged commits, changed description, fixed checkpatch warnings]
Signed-off-by: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 drivers/md/md.c |  280 +++++++++++++++++++++++++++++++++++++++++++++++++------
 drivers/md/md.h |    7 ++
 2 files changed, 257 insertions(+), 30 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8c653f9..0e5c420 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -56,8 +56,6 @@
 
 #ifdef BIO_ACCOUNTING_EXTENSION
 
-#include <linux/ratelimit.h>
-
 struct md_bio_private {
 	void		(*orig_bio_endio)(struct bio *, int);
 	void		*orig_bio_private;
@@ -68,6 +66,30 @@ struct md_bio_private {
 
 static struct kmem_cache *md_bio_private_cache __read_mostly;
 
+#endif	/* BIO_ACCOUNTING_EXTENSION */
+
+#ifdef MD_REQUEST_FUNCTION
+
+struct md_request_clone {
+	struct work_struct work;
+	struct mddev	*mdp;
+	struct request	*req;
+	struct bio_list	bios;
+	atomic_t	cnt;
+	int		err;
+};
+
+#define MD_RQ_MODE_DEFAULT	0
+
+static unsigned int rq_mode __read_mostly = MD_RQ_MODE_DEFAULT;
+static struct kmem_cache *md_request_clone_cache __read_mostly;
+
+#endif	/* MD_REQUEST_FUNCTION */
+
+#if defined BIO_ACCOUNTING_EXTENSION || defined MD_REQUEST_FUNCTION
+
+#include <linux/ratelimit.h>
+
 static DEFINE_RATELIMIT_STATE(md_ratelimit_state,
 			DEFAULT_RATELIMIT_INTERVAL,
 			DEFAULT_RATELIMIT_BURST);
@@ -78,7 +100,7 @@ static inline int __must_check md_valid_ptr(const void *p)
 }
 #define VALID_PTR(p)	md_valid_ptr(p)
 
-#endif	/* BIO_ACCOUNTING_EXTENSION */
+#endif	/* BIO_ACCOUNTING_EXTENSION || MD_REQUEST_FUNCTION */
 
 #ifndef MODULE
 static void autostart_arrays(int part);
@@ -326,31 +348,17 @@ static void md_bio_endio(struct bio *bio, int err)
 
 #endif	/* BIO_ACCOUNTING_EXTENSION */
 
-/* Rather than calling directly into the personality make_request function,
- * IO requests come here first so that we can check if the device is
- * being suspended pending a reconfiguration.
- * We hold a refcount over the call to ->make_request.  By the time that
- * call has finished, the bio has been linked into some internal structure
- * and so is visible to ->quiesce(), so we don't need the refcount any more.
- */
-static void md_make_request(struct request_queue *q, struct bio *bio)
+static inline int md_make_request_head(struct mddev *mddev, struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
-	struct mddev *mddev = q->queuedata;
-	int cpu;
-	unsigned int sectors;
-#ifdef BIO_ACCOUNTING_EXTENSION
-	struct md_bio_private *mbp;
-#endif	/* BIO_ACCOUNTING_EXTENSION */
 
-	if (mddev == NULL || mddev->pers == NULL
-	    || !mddev->ready) {
+	if (mddev == NULL || mddev->pers == NULL || !mddev->ready) {
 		bio_io_error(bio);
-		return;
+		return 1;
 	}
 	if (mddev->ro == 1 && unlikely(rw == WRITE)) {
 		bio_endio(bio, bio_sectors(bio) == 0 ? 0 : -EROFS);
-		return;
+		return 1;
 	}
 	smp_rmb(); /* Ensure implications of  'active' are visible */
 	rcu_read_lock();
@@ -369,6 +377,39 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 	}
 	atomic_inc(&mddev->active_io);
 	rcu_read_unlock();
+	return 0;
+}
+
+static inline void md_make_request_body(struct mddev *mddev, struct bio *bio)
+{
+	mddev->pers->make_request(mddev, bio);
+}
+
+static inline void md_make_request_tail(struct mddev *mddev, struct bio *bio)
+{
+	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
+		wake_up(&mddev->sb_wait);
+}
+
+/* Rather than calling directly into the personality make_request function,
+ * IO requests come here first so that we can check if the device is
+ * being suspended pending a reconfiguration.
+ * We hold a refcount over the call to ->make_request.  By the time that
+ * call has finished, the bio has been linked into some internal structure
+ * and so is visible to ->quiesce(), so we don't need the refcount any more.
+ */
+static void md_make_request(struct request_queue *q, struct bio *bio)
+{
+	const int rw = bio_data_dir(bio);
+	struct mddev *mddev = q->queuedata;
+	int cpu;
+	unsigned int sectors;
+#ifdef BIO_ACCOUNTING_EXTENSION
+	struct md_bio_private *mbp;
+#endif	/* BIO_ACCOUNTING_EXTENSION */
+
+	if (unlikely(md_make_request_head(mddev, bio)))
+		return;
 
 	/*
 	 * save the sectors now since our bio can
@@ -397,7 +438,7 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 		bio->bi_private = mbp;
 	}
 #endif	/* BIO_ACCOUNTING_EXTENSION */
-	mddev->pers->make_request(mddev, bio);
+	md_make_request_body(mddev, bio);
 
 #ifndef BIO_ACCOUNTING_EXTENSION
 	cpu = part_stat_lock();
@@ -406,10 +447,131 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 	part_stat_unlock();
 #endif	/* !BIO_ACCOUNTING_EXTENSION */
 
-	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
-		wake_up(&mddev->sb_wait);
+	md_make_request_tail(mddev, bio);
+}
+
+#ifdef MD_REQUEST_FUNCTION
+
+static inline void md_make_request_bio(struct mddev *mddev, struct bio *bio)
+{
+	if (unlikely(md_make_request_head(mddev, bio)))
+		return;
+	md_make_request_body(mddev, bio);
+	md_make_request_tail(mddev, bio);
+}
+
+static inline void md_request_clone_release(struct md_request_clone *rcl)
+{
+	if (atomic_dec_and_test(&rcl->cnt)) {
+		blk_end_request_all(rcl->req, rcl->err);
+		kmem_cache_free(md_request_clone_cache, rcl);
+	}
+}
+
+static void md_request_bio_endio(struct bio *bio, int err)
+{
+	struct md_request_clone *rcl = bio->bi_private;
+
+	if (unlikely(err < 0))
+		rcl->err = err;
+
+	bio_put(bio);
+	md_request_clone_release(rcl);
+}
+
+static void md_request_clone_worker(struct work_struct *wkp)
+{
+	struct md_request_clone *rcl =
+		container_of(wkp, struct md_request_clone, work);
+	struct bio_list *blp = &rcl->bios;
+	struct mddev *mddev = rcl->mdp;
+	struct bio *bio;
+
+	bio = bio_list_pop(blp);
+	while (VALID_PTR(bio)) {
+		md_make_request_bio(mddev, bio);
+		bio = bio_list_pop(blp);
+	}
+	md_request_clone_release(rcl);
 }
 
+static inline int md_process_request(struct mddev *mddev, struct request *req)
+{
+	struct md_request_clone *rcl;
+
+	struct bio *bio, *clone;
+	int error;
+
+	rcl = kmem_cache_alloc(md_request_clone_cache, GFP_NOIO);
+	if (unlikely(!VALID_PTR(rcl))) {
+		if (__ratelimit(&md_ratelimit_state))
+			pr_warn("%s: [%s] kmem_cache_alloc failed\n",
+				__func__, mdname(mddev));
+		return -ENOMEM;
+	}
+	rcl->err = 0;
+	rcl->req = req;
+	rcl->mdp = mddev;
+	atomic_set(&rcl->cnt, 1);
+	bio_list_init(&rcl->bios);
+	bio = req->bio;
+	while (VALID_PTR(bio)) {
+		clone = bio_clone(bio, GFP_NOWAIT);
+		if (unlikely(!VALID_PTR(clone))) {
+			if (__ratelimit(&md_ratelimit_state))
+				pr_warn("%s: [%s] bio_clone failed\n",
+					__func__, mdname(mddev));
+			error = -ENOMEM;
+			goto error_out;
+		}
+		clone->bi_private = rcl;
+		clone->bi_end_io = md_request_bio_endio;
+		bio_list_add(&rcl->bios, clone);
+		atomic_inc(&rcl->cnt);
+		bio = bio->bi_next;
+	}
+	INIT_WORK(&rcl->work, md_request_clone_worker);
+	queue_work(mddev->request_wq, &rcl->work);
+	return 0;
+error_out:
+	bio = bio_list_pop(&rcl->bios);
+	while (VALID_PTR(bio)) {
+		bio_put(bio);
+		bio = bio_list_pop(&rcl->bios);
+	}
+	kmem_cache_free(md_request_clone_cache, rcl);
+	return error;
+}
+
+#ifndef blk_fs_request
+#define blk_fs_request(p)	((p)->cmd_type == REQ_TYPE_FS)
+#endif	/* !blk_fs_request */
+
+static void md_request_function(struct request_queue *rqp)
+{
+	struct mddev *mddev = rqp->queuedata;
+
+	struct request *req;
+	int rc;
+
+	while ((req = blk_fetch_request(rqp)) != NULL) {
+		if (unlikely(!blk_fs_request(req))) {
+			if (__ratelimit(&md_ratelimit_state))
+				pr_warn("%s: [%s] non-fs request\n",
+					__func__, mdname(mddev));
+			__blk_end_request_all(req, -ENOTSUPP);
+			continue;
+		}
+		spin_unlock_irq(rqp->queue_lock);
+		rc = md_process_request(mddev, req);
+		spin_lock_irq(rqp->queue_lock);
+		if (unlikely(rc < 0))
+			__blk_end_request_all(req, rc);
+	}
+}
+
+#endif	/* MD_REQUEST_FUNCTION */
+
 /* mddev_suspend makes sure no new requests are submitted
  * to the device, and that any requests that have been submitted
  * are completely handled.
@@ -567,8 +729,15 @@ static void mddev_put(struct mddev *mddev)
 			 */
 			INIT_WORK(&mddev->del_work, mddev_delayed_delete);
 			queue_work(md_misc_wq, &mddev->del_work);
-		} else
+		} else {
+#ifdef MD_REQUEST_FUNCTION
+			if (likely(VALID_PTR(mddev->request_wq))) {
+				destroy_workqueue(mddev->request_wq);
+				mddev->request_wq = NULL;
+			}
+#endif	/* MD_REQUEST_FUNCTION */
 			kfree(mddev);
+		}
 	}
 	spin_unlock(&all_mddevs_lock);
 	if (bs)
@@ -4923,6 +5092,13 @@ static void md_free(struct kobject *ko)
 	if (mddev->queue)
 		blk_cleanup_queue(mddev->queue);
 
+#ifdef MD_REQUEST_FUNCTION
+	if (likely(VALID_PTR(mddev->request_wq))) {
+		destroy_workqueue(mddev->request_wq);
+		mddev->request_wq = NULL;
+	}
+#endif	/* MD_REQUEST_FUNCTION */
+
 	kfree(mddev);
 }
 
@@ -4990,12 +5166,32 @@ static int md_alloc(dev_t dev, char *name)
 	}
 
 	error = -ENOMEM;
-	mddev->queue = blk_alloc_queue(GFP_KERNEL);
-	if (!mddev->queue)
-		goto abort;
+#ifdef MD_REQUEST_FUNCTION
+	if (!rq_mode) {
+#endif	/* MD_REQUEST_FUNCTION */
+		mddev->queue = blk_alloc_queue(GFP_KERNEL);
+		if (!mddev->queue)
+			goto abort;
+		blk_queue_make_request(mddev->queue, md_make_request);
+#ifdef MD_REQUEST_FUNCTION
+	} else {
+		mddev->request_wq =
+			create_singlethread_workqueue(mdname(mddev));
+		if (unlikely(!VALID_PTR(mddev->request_wq))) {
+			pr_warn("%s: create_singlethread_workqueue (%s) "
+				"failed\n", __func__, mdname(mddev));
+			goto abort;
+		}
+		mddev->queue = blk_init_queue(md_request_function, NULL);
+		if (!mddev->queue) {
+			destroy_workqueue(mddev->request_wq);
+			mddev->request_wq = NULL;
+			goto abort;
+		}
+	}
+#endif	/* MD_REQUEST_FUNCTION */
 	mddev->queue->queuedata = mddev;
 
-	blk_queue_make_request(mddev->queue, md_make_request);
 	blk_set_stacking_limits(&mddev->queue->limits);
 
 	disk = alloc_disk(1 << shift);
@@ -8714,11 +8910,23 @@ static int __init md_init(void)
 #ifdef BIO_ACCOUNTING_EXTENSION
 	md_bio_private_cache = KMEM_CACHE(md_bio_private, 0);
 	if (unlikely(!VALID_PTR(md_bio_private_cache))) {
-		pr_err("%s: KMEM_CACHE failed\n", __func__);
+		pr_err("%s: KMEM_CACHE (bio_priv) failed\n", __func__);
 		return -ENOMEM;
 	}
 #endif	/* BIO_ACCOUNTING_EXTENSION */
 
+#ifdef MD_REQUEST_FUNCTION
+	md_request_clone_cache = KMEM_CACHE(md_request_clone, 0);
+	if (unlikely(!VALID_PTR(md_request_clone_cache))) {
+		pr_err("%s: KMEM_CACHE (req_clone) failed\n", __func__);
+#ifdef BIO_ACCOUNTING_EXTENSION
+		kmem_cache_destroy(md_bio_private_cache);
+		md_bio_private_cache = NULL;
+#endif	/* BIO_ACCOUNTING_EXTENSION */
+		return -ENOMEM;
+	}
+#endif	/* MD_REQUEST_FUNCTION */
+
 	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
 	if (!md_wq)
 		goto err_wq;
@@ -8856,6 +9064,13 @@ static __exit void md_exit(void)
 	destroy_workqueue(md_misc_wq);
 	destroy_workqueue(md_wq);
 
+#ifdef MD_REQUEST_FUNCTION
+	if (likely(VALID_PTR(md_request_clone_cache))) {
+		kmem_cache_destroy(md_request_clone_cache);
+		md_request_clone_cache = NULL;
+	}
+#endif	/* MD_REQUEST_FUNCTION */
+
 #ifdef BIO_ACCOUNTING_EXTENSION
 	if (likely(VALID_PTR(md_bio_private_cache))) {
 		kmem_cache_destroy(md_bio_private_cache);
@@ -8887,6 +9102,11 @@ module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
 
 module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
 
+#ifdef MD_REQUEST_FUNCTION
+module_param(rq_mode, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(rq_mode, " this module's io input mode (default: 0 [make request mode])");
+#endif	/* MD_REQUEST_FUNCTION */
+
 EXPORT_SYMBOL(register_md_personality);
 EXPORT_SYMBOL(unregister_md_personality);
 EXPORT_SYMBOL(md_error);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f0e9171..8d639e0 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -25,6 +25,10 @@
 #include <linux/workqueue.h>
 
 #if 1
+#define MD_REQUEST_FUNCTION
+#endif
+
+#if 1
 #define BIO_ACCOUNTING_EXTENSION
 #endif
 
@@ -455,6 +459,9 @@ struct mddev {
 #ifdef BIO_ACCOUNTING_EXTENSION
 	struct md_stats stats;
 #endif	/* BIO_ACCOUNTING_EXTENSION */
+#ifdef MD_REQUEST_FUNCTION
+	struct workqueue_struct *request_wq;
+#endif	/* MD_REQUEST_FUNCTION */
 };
 
 
-- 
1.7.9.5

