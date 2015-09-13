From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 17/39] md: drop null test before destroy functions
Date: Sun, 13 Sep 2015 14:15:10 +0200
Message-ID: <1442146532-9100-18-git-send-email-Julia.Lawall@lip6.fr>
References: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>
Cc: sergey.senozhatsky@gmail.com, kernel-janitors@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Remove unneeded NULL test.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ expression x; @@
-if (x != NULL)
  \(kmem_cache_destroy\|mempool_destroy\|dma_pool_destroy\)(x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/md/multipath.c |    3 +--
 drivers/md/raid1.c     |    6 ++----
 drivers/md/raid10.c    |    9 +++------
 drivers/md/raid5.c     |    3 +--
 4 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 15ef2c6..09a12d7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2271,8 +2271,7 @@ static void shrink_stripes(struct r5conf *conf)
 	       drop_one_stripe(conf))
 		;
 
-	if (conf->slab_cache)
-		kmem_cache_destroy(conf->slab_cache);
+	kmem_cache_destroy(conf->slab_cache);
 	conf->slab_cache = NULL;
 }
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4517f06..5f4f553 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2843,8 +2843,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 
  abort:
 	if (conf) {
-		if (conf->r1bio_pool)
-			mempool_destroy(conf->r1bio_pool);
+		mempool_destroy(conf->r1bio_pool);
 		kfree(conf->mirrors);
 		safe_put_page(conf->tmppage);
 		kfree(conf->poolinfo);
@@ -2946,8 +2945,7 @@ static void raid1_free(struct mddev *mddev, void *priv)
 {
 	struct r1conf *conf = priv;
 
-	if (conf->r1bio_pool)
-		mempool_destroy(conf->r1bio_pool);
+	mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);
 	safe_put_page(conf->tmppage);
 	kfree(conf->poolinfo);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index d222522..d132f06 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -470,8 +470,7 @@ static int multipath_run (struct mddev *mddev)
 	return 0;
 
 out_free_conf:
-	if (conf->pool)
-		mempool_destroy(conf->pool);
+	mempool_destroy(conf->pool);
 	kfree(conf->multipaths);
 	kfree(conf);
 	mddev->private = NULL;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0fc33eb..7c99a40 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3486,8 +3486,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 		printk(KERN_ERR "md/raid10:%s: couldn't allocate memory.\n",
 		       mdname(mddev));
 	if (conf) {
-		if (conf->r10bio_pool)
-			mempool_destroy(conf->r10bio_pool);
+		mempool_destroy(conf->r10bio_pool);
 		kfree(conf->mirrors);
 		safe_put_page(conf->tmppage);
 		kfree(conf);
@@ -3682,8 +3681,7 @@ static int run(struct mddev *mddev)
 
 out_free_conf:
 	md_unregister_thread(&mddev->thread);
-	if (conf->r10bio_pool)
-		mempool_destroy(conf->r10bio_pool);
+	mempool_destroy(conf->r10bio_pool);
 	safe_put_page(conf->tmppage);
 	kfree(conf->mirrors);
 	kfree(conf);
@@ -3696,8 +3694,7 @@ static void raid10_free(struct mddev *mddev, void *priv)
 {
 	struct r10conf *conf = priv;
 
-	if (conf->r10bio_pool)
-		mempool_destroy(conf->r10bio_pool);
+	mempool_destroy(conf->r10bio_pool);
 	safe_put_page(conf->tmppage);
 	kfree(conf->mirrors);
 	kfree(conf->mirrors_old);
