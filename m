From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/26] md: split detach operation out from ->stop.
Date: Wed, 04 Feb 2015 08:42:29 +1100
Message-ID: <20150203214229.3448.1661.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Each md personality has a 'stop' operation which does two
things:
 1/ it finalizes some aspects of the array to ensure nothing
    is accessing the ->private data
 2/ it frees the ->private data.

All the steps in '1' can apply to all arrays and so can be
performed in common code.

This is useful as in the case where we change the personality which
manages an array (in level_store()), it would be helpful to do
step 1 early, and step 2 later.

So split the 'step 1' functionality out into a new mddev_detach().

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/linear.c    |    1 -
 drivers/md/md.c        |   30 ++++++++++++++++++++++++++----
 drivers/md/multipath.c |    2 --
 drivers/md/raid0.c     |    1 -
 drivers/md/raid1.c     |   18 +++---------------
 drivers/md/raid10.c    |    8 --------
 drivers/md/raid5.c     |    1 -
 7 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index b3e717adbc9b..c201555b9c6c 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -253,7 +253,6 @@ static int linear_stop (struct mddev *mddev)
 {
 	struct linear_conf *conf = mddev->private;
 
-	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	kfree(conf);
 	mddev->private = NULL;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9f0ff7187136..58f140bef999 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -72,6 +72,7 @@ static struct workqueue_struct *md_misc_wq;
 
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
+static void mddev_detach(struct mddev *mddev);
 
 /*
  * Default number of read corrections we'll attempt on an rdev
@@ -3372,6 +3373,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 
 	/* Looks like we have a winner */
 	mddev_suspend(mddev);
+	mddev_detach(mddev);
 	mddev->pers->stop(mddev);
 
 	if (mddev->pers->sync_request == NULL &&
@@ -4928,18 +4930,17 @@ int md_run(struct mddev *mddev)
 		       (unsigned long long)mddev->array_sectors / 2,
 		       (unsigned long long)mddev->pers->size(mddev, 0, 0) / 2);
 		err = -EINVAL;
-		mddev->pers->stop(mddev);
 	}
 	if (err == 0 && mddev->pers->sync_request &&
 	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
 		err = bitmap_create(mddev);
-		if (err) {
+		if (err)
 			printk(KERN_ERR "%s: failed to create bitmap (%d)\n",
 			       mdname(mddev), err);
-			mddev->pers->stop(mddev);
-		}
 	}
 	if (err) {
+		mddev_detach(mddev);
+		mddev->pers->stop(mddev);
 		module_put(mddev->pers->owner);
 		mddev->pers = NULL;
 		bitmap_destroy(mddev);
@@ -5112,9 +5113,30 @@ void md_stop_writes(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_stop_writes);
 
+static void mddev_detach(struct mddev *mddev)
+{
+	struct bitmap *bitmap = mddev->bitmap;
+	/* wait for behind writes to complete */
+	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
+		printk(KERN_INFO "md:%s: behind writes in progress - waiting to stop.\n",
+		       mdname(mddev));
+		/* need to kick something here to make sure I/O goes? */
+		wait_event(bitmap->behind_wait,
+			   atomic_read(&bitmap->behind_writes) == 0);
+	}
+	if (mddev->pers->quiesce) {
+		mddev->pers->quiesce(mddev, 1);
+		mddev->pers->quiesce(mddev, 0);
+	}
+	md_unregister_thread(&mddev->thread);
+	if (mddev->queue)
+		blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
+}
+
 static void __md_stop(struct mddev *mddev)
 {
 	mddev->ready = 0;
+	mddev_detach(mddev);
 	mddev->pers->stop(mddev);
 	if (mddev->pers->sync_request && mddev->to_remove == NULL)
 		mddev->to_remove = &md_redundancy_group;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index fedb1b31877d..9fe34453835b 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -504,8 +504,6 @@ static int multipath_stop (struct mddev *mddev)
 {
 	struct mpconf *conf = mddev->private;
 
-	md_unregister_thread(&mddev->thread);
-	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	mempool_destroy(conf->pool);
 	kfree(conf->multipaths);
 	kfree(conf);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 3770c9675b17..01dfca94b663 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -477,7 +477,6 @@ static int raid0_stop(struct mddev *mddev)
 {
 	struct r0conf *conf = mddev->private;
 
-	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	kfree(conf->strip_zone);
 	kfree(conf->devlist);
 	kfree(conf);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 45c512a4b75d..fccea0b39808 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2954,29 +2954,17 @@ static int run(struct mddev *mddev)
 	}
 
 	ret =  md_integrity_register(mddev);
-	if (ret)
+	if (ret) {
+		md_unregister_thread(&mddev->thread);
 		stop(mddev);
+	}
 	return ret;
 }
 
 static int stop(struct mddev *mddev)
 {
 	struct r1conf *conf = mddev->private;
-	struct bitmap *bitmap = mddev->bitmap;
-
-	/* wait for behind writes to complete */
-	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
-		printk(KERN_INFO "md/raid1:%s: behind writes in progress - waiting to stop.\n",
-		       mdname(mddev));
-		/* need to kick something here to make sure I/O goes? */
-		wait_event(bitmap->behind_wait,
-			   atomic_read(&bitmap->behind_writes) == 0);
-	}
-
-	freeze_array(conf, 0);
-	unfreeze_array(conf);
 
-	md_unregister_thread(&mddev->thread);
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 407c81a820f4..654fdae906aa 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3802,14 +3802,6 @@ static int stop(struct mddev *mddev)
 {
 	struct r10conf *conf = mddev->private;
 
-	raise_barrier(conf, 0);
-	lower_barrier(conf);
-
-	md_unregister_thread(&mddev->thread);
-	if (mddev->queue)
-		/* the unplug fn references 'conf'*/
-		blk_sync_queue(mddev->queue);
-
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
 	safe_put_page(conf->tmppage);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2d4a2cc85eb2..482526077647 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6317,7 +6317,6 @@ static int stop(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
 
-	md_unregister_thread(&mddev->thread);
 	free_conf(conf);
 	mddev->private = NULL;
 	mddev->to_remove = &raid5_attrs_group;


