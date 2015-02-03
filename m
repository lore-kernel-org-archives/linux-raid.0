From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 11/26] md: rename ->stop to ->free
Date: Wed, 04 Feb 2015 08:42:29 +1100
Message-ID: <20150203214229.3448.86153.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Now that the ->stop function only frees the private data,
rename is accordingly.

Also pass in the private pointer as an arg rather than using
mddev->private.  This flexibility will be useful in level_store().

Finally, don't clear ->private.  It doesn't make sense to clear
it seeing that isn't what we free, and it is no longer necessary
to clear ->private (it was some time ago before  ->to_remove was
introduced).

Setting ->to_remove in ->free() is a bit of a wart, but not a
big problem at the moment.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/faulty.c    |    8 +++-----
 drivers/md/linear.c    |    9 +++------
 drivers/md/md.c        |   10 +++++-----
 drivers/md/md.h        |    2 +-
 drivers/md/multipath.c |   10 ++++------
 drivers/md/raid0.c     |   12 +++++-------
 drivers/md/raid1.c     |   14 ++++++--------
 drivers/md/raid10.c    |    8 +++-----
 drivers/md/raid5.c     |   12 +++++-------
 9 files changed, 35 insertions(+), 50 deletions(-)

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index e8b4574956c7..1277eb26b58a 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -332,13 +332,11 @@ static int run(struct mddev *mddev)
 	return 0;
 }
 
-static int stop(struct mddev *mddev)
+static void faulty_free(struct mddev *mddev, void *priv)
 {
-	struct faulty_conf *conf = mddev->private;
+	struct faulty_conf *conf = priv;
 
 	kfree(conf);
-	mddev->private = NULL;
-	return 0;
 }
 
 static struct md_personality faulty_personality =
@@ -348,7 +346,7 @@ static struct md_personality faulty_personality =
 	.owner		= THIS_MODULE,
 	.make_request	= make_request,
 	.run		= run,
-	.stop		= stop,
+	.free		= faulty_free,
 	.status		= status,
 	.check_reshape	= reshape,
 	.size		= faulty_size,
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index c201555b9c6c..fa7d577f3d12 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -249,14 +249,11 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
 	return 0;
 }
 
-static int linear_stop (struct mddev *mddev)
+static void linear_free(struct mddev *mddev, void *priv)
 {
-	struct linear_conf *conf = mddev->private;
+	struct linear_conf *conf = priv;
 
 	kfree(conf);
-	mddev->private = NULL;
-
-	return 0;
 }
 
 static void linear_make_request(struct mddev *mddev, struct bio *bio)
@@ -335,7 +332,7 @@ static struct md_personality linear_personality =
 	.owner		= THIS_MODULE,
 	.make_request	= linear_make_request,
 	.run		= linear_run,
-	.stop		= linear_stop,
+	.free		= linear_free,
 	.status		= linear_status,
 	.hot_add_disk	= linear_add,
 	.size		= linear_size,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 58f140bef999..2920fd004865 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -293,8 +293,8 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 /* mddev_suspend makes sure no new requests are submitted
  * to the device, and that any requests that have been submitted
  * are completely handled.
- * Once ->stop is called and completes, the module will be completely
- * unused.
+ * Once mddev_detach() is called and completes, the module will be
+ * completely unused.
  */
 void mddev_suspend(struct mddev *mddev)
 {
@@ -3374,7 +3374,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	/* Looks like we have a winner */
 	mddev_suspend(mddev);
 	mddev_detach(mddev);
-	mddev->pers->stop(mddev);
+	mddev->pers->free(mddev, mddev->private);
 
 	if (mddev->pers->sync_request == NULL &&
 	    pers->sync_request != NULL) {
@@ -4940,7 +4940,7 @@ int md_run(struct mddev *mddev)
 	}
 	if (err) {
 		mddev_detach(mddev);
-		mddev->pers->stop(mddev);
+		mddev->pers->free(mddev, mddev->private);
 		module_put(mddev->pers->owner);
 		mddev->pers = NULL;
 		bitmap_destroy(mddev);
@@ -5137,7 +5137,7 @@ static void __md_stop(struct mddev *mddev)
 {
 	mddev->ready = 0;
 	mddev_detach(mddev);
-	mddev->pers->stop(mddev);
+	mddev->pers->free(mddev, mddev->private);
 	if (mddev->pers->sync_request && mddev->to_remove == NULL)
 		mddev->to_remove = &md_redundancy_group;
 	module_put(mddev->pers->owner);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index bee5b852c33f..37e7c17e56a6 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -465,7 +465,7 @@ struct md_personality
 	struct module *owner;
 	void (*make_request)(struct mddev *mddev, struct bio *bio);
 	int (*run)(struct mddev *mddev);
-	int (*stop)(struct mddev *mddev);
+	void (*free)(struct mddev *mddev, void *priv);
 	void (*status)(struct seq_file *seq, struct mddev *mddev);
 	/* error_handler must set ->faulty and clear ->in_sync
 	 * if appropriate, and should abort recovery if needed
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 9fe34453835b..ac3ede2bd00e 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -399,7 +399,7 @@ static int multipath_run (struct mddev *mddev)
 	/*
 	 * copy the already verified devices into our private MULTIPATH
 	 * bookkeeping area. [whatever we allocate in multipath_run(),
-	 * should be freed in multipath_stop()]
+	 * should be freed in multipath_free()]
 	 */
 
 	conf = kzalloc(sizeof(struct mpconf), GFP_KERNEL);
@@ -500,15 +500,13 @@ out:
 	return -EIO;
 }
 
-static int multipath_stop (struct mddev *mddev)
+static void multipath_free(struct mddev *mddev, void *priv)
 {
-	struct mpconf *conf = mddev->private;
+	struct mpconf *conf = priv;
 
 	mempool_destroy(conf->pool);
 	kfree(conf->multipaths);
 	kfree(conf);
-	mddev->private = NULL;
-	return 0;
 }
 
 static struct md_personality multipath_personality =
@@ -518,7 +516,7 @@ static struct md_personality multipath_personality =
 	.owner		= THIS_MODULE,
 	.make_request	= multipath_make_request,
 	.run		= multipath_run,
-	.stop		= multipath_stop,
+	.free		= multipath_free,
 	.status		= multipath_status,
 	.error_handler	= multipath_error,
 	.hot_add_disk	= multipath_add_disk,
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 01dfca94b663..a13f738a7b39 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -415,7 +415,7 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
 	return array_sectors;
 }
 
-static int raid0_stop(struct mddev *mddev);
+static void raid0_free(struct mddev *mddev, void *priv);
 
 static int raid0_run(struct mddev *mddev)
 {
@@ -468,20 +468,18 @@ static int raid0_run(struct mddev *mddev)
 
 	ret = md_integrity_register(mddev);
 	if (ret)
-		raid0_stop(mddev);
+		raid0_free(mddev, conf);
 
 	return ret;
 }
 
-static int raid0_stop(struct mddev *mddev)
+static void raid0_free(struct mddev *mddev, void *priv)
 {
-	struct r0conf *conf = mddev->private;
+	struct r0conf *conf = priv;
 
 	kfree(conf->strip_zone);
 	kfree(conf->devlist);
 	kfree(conf);
-	mddev->private = NULL;
-	return 0;
 }
 
 /*
@@ -715,7 +713,7 @@ static struct md_personality raid0_personality=
 	.owner		= THIS_MODULE,
 	.make_request	= raid0_make_request,
 	.run		= raid0_run,
-	.stop		= raid0_stop,
+	.free		= raid0_free,
 	.status		= raid0_status,
 	.size		= raid0_size,
 	.takeover	= raid0_takeover,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fccea0b39808..5dd0c2e59ab9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2872,7 +2872,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	return ERR_PTR(err);
 }
 
-static int stop(struct mddev *mddev);
+static void raid1_free(struct mddev *mddev, void *priv);
 static int run(struct mddev *mddev)
 {
 	struct r1conf *conf;
@@ -2894,7 +2894,7 @@ static int run(struct mddev *mddev)
 	/*
 	 * copy the already verified devices into our private RAID1
 	 * bookkeeping area. [whatever we allocate in run(),
-	 * should be freed in stop()]
+	 * should be freed in raid1_free()]
 	 */
 	if (mddev->private == NULL)
 		conf = setup_conf(mddev);
@@ -2956,14 +2956,14 @@ static int run(struct mddev *mddev)
 	ret =  md_integrity_register(mddev);
 	if (ret) {
 		md_unregister_thread(&mddev->thread);
-		stop(mddev);
+		raid1_free(mddev, conf);
 	}
 	return ret;
 }
 
-static int stop(struct mddev *mddev)
+static void raid1_free(struct mddev *mddev, void *priv)
 {
-	struct r1conf *conf = mddev->private;
+	struct r1conf *conf = priv;
 
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
@@ -2971,8 +2971,6 @@ static int stop(struct mddev *mddev)
 	safe_put_page(conf->tmppage);
 	kfree(conf->poolinfo);
 	kfree(conf);
-	mddev->private = NULL;
-	return 0;
 }
 
 static int raid1_resize(struct mddev *mddev, sector_t sectors)
@@ -3155,7 +3153,7 @@ static struct md_personality raid1_personality =
 	.owner		= THIS_MODULE,
 	.make_request	= make_request,
 	.run		= run,
-	.stop		= stop,
+	.free		= raid1_free,
 	.status		= status,
 	.error_handler	= error,
 	.hot_add_disk	= raid1_add_disk,
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 654fdae906aa..d1203cddb024 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3798,9 +3798,9 @@ out:
 	return -EIO;
 }
 
-static int stop(struct mddev *mddev)
+static void raid10_free(struct mddev *mddev, void *priv)
 {
-	struct r10conf *conf = mddev->private;
+	struct r10conf *conf = priv;
 
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
@@ -3809,8 +3809,6 @@ static int stop(struct mddev *mddev)
 	kfree(conf->mirrors_old);
 	kfree(conf->mirrors_new);
 	kfree(conf);
-	mddev->private = NULL;
-	return 0;
 }
 
 static void raid10_quiesce(struct mddev *mddev, int state)
@@ -4692,7 +4690,7 @@ static struct md_personality raid10_personality =
 	.owner		= THIS_MODULE,
 	.make_request	= make_request,
 	.run		= run,
-	.stop		= stop,
+	.free		= raid10_free,
 	.status		= status,
 	.error_handler	= error,
 	.hot_add_disk	= raid10_add_disk,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 482526077647..dab908b2aa9a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6313,14 +6313,12 @@ abort:
 	return -EIO;
 }
 
-static int stop(struct mddev *mddev)
+static void raid5_free(struct mddev *mddev, void *priv)
 {
-	struct r5conf *conf = mddev->private;
+	struct r5conf *conf = priv;
 
 	free_conf(conf);
-	mddev->private = NULL;
 	mddev->to_remove = &raid5_attrs_group;
-	return 0;
 }
 
 static void status(struct seq_file *seq, struct mddev *mddev)
@@ -7094,7 +7092,7 @@ static struct md_personality raid6_personality =
 	.owner		= THIS_MODULE,
 	.make_request	= make_request,
 	.run		= run,
-	.stop		= stop,
+	.free		= raid5_free,
 	.status		= status,
 	.error_handler	= error,
 	.hot_add_disk	= raid5_add_disk,
@@ -7118,7 +7116,7 @@ static struct md_personality raid5_personality =
 	.owner		= THIS_MODULE,
 	.make_request	= make_request,
 	.run		= run,
-	.stop		= stop,
+	.free		= raid5_free,
 	.status		= status,
 	.error_handler	= error,
 	.hot_add_disk	= raid5_add_disk,
@@ -7143,7 +7141,7 @@ static struct md_personality raid4_personality =
 	.owner		= THIS_MODULE,
 	.make_request	= make_request,
 	.run		= run,
-	.stop		= stop,
+	.free		= raid5_free,
 	.status		= status,
 	.error_handler	= error,
 	.hot_add_disk	= raid5_add_disk,


