From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH] md: Unify mddev destruction paths
Date: Thu,  7 Jun 2018 20:52:54 -0400
Message-ID: <20180608005254.6692-1-kent.overstreet@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, shli@kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-raid.ids

Previously, mddev_put() had a couple different paths for freeing a
mddev, due to the fact that the kobject wasn't initialized when the
mddev was first allocated. If we move the kobject_init() to when it's
first allocated and just use kobject_add() later, we can clean all this
up.

This also removes a hack in mddev_put() to avoid freeing biosets under a
spinlock, which involved copying biosets on the stack after the reset
bioset_init() changes.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/md/md.c | 53 +++++++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 35 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fc692b7128..22203eba1e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -84,6 +84,8 @@ static void autostart_arrays(int part);
 static LIST_HEAD(pers_list);
 static DEFINE_SPINLOCK(pers_lock);
 
+static struct kobj_type md_ktype;
+
 struct md_cluster_operations *md_cluster_ops;
 EXPORT_SYMBOL(md_cluster_ops);
 struct module *md_cluster_mod;
@@ -510,11 +512,6 @@ static void mddev_delayed_delete(struct work_struct *ws);
 
 static void mddev_put(struct mddev *mddev)
 {
-	struct bio_set bs, sync_bs;
-
-	memset(&bs, 0, sizeof(bs));
-	memset(&sync_bs, 0, sizeof(sync_bs));
-
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
 	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
@@ -522,30 +519,23 @@ static void mddev_put(struct mddev *mddev)
 		/* Array is not configured at all, and not held active,
 		 * so destroy it */
 		list_del_init(&mddev->all_mddevs);
-		bs = mddev->bio_set;
-		sync_bs = mddev->sync_set;
-		memset(&mddev->bio_set, 0, sizeof(mddev->bio_set));
-		memset(&mddev->sync_set, 0, sizeof(mddev->sync_set));
-		if (mddev->gendisk) {
-			/* We did a probe so need to clean up.  Call
-			 * queue_work inside the spinlock so that
-			 * flush_workqueue() after mddev_find will
-			 * succeed in waiting for the work to be done.
-			 */
-			INIT_WORK(&mddev->del_work, mddev_delayed_delete);
-			queue_work(md_misc_wq, &mddev->del_work);
-		} else
-			kfree(mddev);
+
+		/*
+		 * Call queue_work inside the spinlock so that
+		 * flush_workqueue() after mddev_find will succeed in waiting
+		 * for the work to be done.
+		 */
+		INIT_WORK(&mddev->del_work, mddev_delayed_delete);
+		queue_work(md_misc_wq, &mddev->del_work);
 	}
 	spin_unlock(&all_mddevs_lock);
-	bioset_exit(&bs);
-	bioset_exit(&sync_bs);
 }
 
 static void md_safemode_timeout(struct timer_list *t);
 
 void mddev_init(struct mddev *mddev)
 {
+	kobject_init(&mddev->kobj, &md_ktype);
 	mutex_init(&mddev->open_mutex);
 	mutex_init(&mddev->reconfig_mutex);
 	mutex_init(&mddev->bitmap_info.mutex);
@@ -5215,6 +5205,8 @@ static void md_free(struct kobject *ko)
 		put_disk(mddev->gendisk);
 	percpu_ref_exit(&mddev->writes_pending);
 
+	bioset_exit(&mddev->bio_set);
+	bioset_exit(&mddev->sync_set);
 	kfree(mddev);
 }
 
@@ -5348,8 +5340,7 @@ static int md_alloc(dev_t dev, char *name)
 	mutex_lock(&mddev->open_mutex);
 	add_disk(disk);
 
-	error = kobject_init_and_add(&mddev->kobj, &md_ktype,
-				     &disk_to_dev(disk)->kobj, "%s", "md");
+	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
 	if (error) {
 		/* This isn't possible, but as kobject_init_and_add is marked
 		 * __must_check, we must do something with the result
@@ -5506,7 +5497,7 @@ int md_run(struct mddev *mddev)
 	if (!bioset_initialized(&mddev->sync_set)) {
 		err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 		if (err)
-			goto abort;
+			return err;
 	}
 
 	spin_lock(&pers_lock);
@@ -5519,8 +5510,7 @@ int md_run(struct mddev *mddev)
 		else
 			pr_warn("md: personality for level %s is not loaded!\n",
 				mddev->clevel);
-		err = -EINVAL;
-		goto abort;
+		return -EINVAL;
 	}
 	spin_unlock(&pers_lock);
 	if (mddev->level != pers->level) {
@@ -5533,8 +5523,7 @@ int md_run(struct mddev *mddev)
 	    pers->start_reshape == NULL) {
 		/* This personality cannot handle reshaping... */
 		module_put(pers->owner);
-		err = -EINVAL;
-		goto abort;
+		return -EINVAL;
 	}
 
 	if (pers->sync_request) {
@@ -5603,7 +5592,7 @@ int md_run(struct mddev *mddev)
 		mddev->private = NULL;
 		module_put(pers->owner);
 		bitmap_destroy(mddev);
-		goto abort;
+		return err;
 	}
 	if (mddev->queue) {
 		bool nonrot = true;
@@ -5665,12 +5654,6 @@ int md_run(struct mddev *mddev)
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	sysfs_notify(&mddev->kobj, NULL, "degraded");
 	return 0;
-
-abort:
-	bioset_exit(&mddev->bio_set);
-	bioset_exit(&mddev->sync_set);
-
-	return err;
 }
 EXPORT_SYMBOL_GPL(md_run);
 
-- 
2.17.1
