From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 3 of 4] Delete unplug timer before shutting down md array.
Date: Tue, 02 Nov 2004 14:37:45 +1100
Message-ID: <E1COpUP-000392-Hw@notabene.cse.unsw.edu.au>
References: <20041102143440.12019.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


As the unplug timer can potentially fire at any time, and
and it access data that is released by the md ->stop function,
we need to del_timer_sync before releasing that data.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/linear.c    |    1 +
 ./drivers/md/multipath.c |    1 +
 ./drivers/md/raid0.c     |    1 +
 ./drivers/md/raid1.c     |    1 +
 ./drivers/md/raid10.c    |    1 +
 ./drivers/md/raid5.c     |    1 +
 ./drivers/md/raid6main.c |    1 +
 7 files changed, 7 insertions(+)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2004-11-02 14:20:12.000000000 +1100
+++ ./drivers/md/linear.c	2004-11-02 14:20:18.000000000 +1100
@@ -231,6 +231,7 @@ static int linear_stop (mddev_t *mddev)
 {
 	linear_conf_t *conf = mddev_to_conf(mddev);
   
+	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
 	kfree(conf->hash_table);
 	kfree(conf);
 

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2004-11-02 14:20:18.000000000 +1100
+++ ./drivers/md/multipath.c	2004-11-02 14:20:18.000000000 +1100
@@ -566,6 +566,7 @@ static int multipath_stop (mddev_t *mdde
 
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
+	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
 	mempool_destroy(conf->pool);
 	kfree(conf->multipaths);
 	kfree(conf);

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2004-11-02 14:20:18.000000000 +1100
+++ ./drivers/md/raid0.c	2004-11-02 14:20:18.000000000 +1100
@@ -385,6 +385,7 @@ static int raid0_stop (mddev_t *mddev)
 {
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 
+	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
 	kfree (conf->hash_table);
 	conf->hash_table = NULL;
 	kfree (conf->strip_zone);

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-11-02 14:20:18.000000000 +1100
+++ ./drivers/md/raid1.c	2004-11-02 14:20:18.000000000 +1100
@@ -1293,6 +1293,7 @@ static int stop(mddev_t *mddev)
 
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
+	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
 	if (conf->mirrors)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2004-11-02 14:20:18.000000000 +1100
+++ ./drivers/md/raid10.c	2004-11-02 14:20:18.000000000 +1100
@@ -1744,6 +1744,7 @@ static int stop(mddev_t *mddev)
 
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
+	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
 	if (conf->mirrors)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-11-02 14:20:18.000000000 +1100
+++ ./drivers/md/raid5.c	2004-11-02 14:20:18.000000000 +1100
@@ -1707,6 +1707,7 @@ static int stop (mddev_t *mddev)
 	mddev->thread = NULL;
 	shrink_stripes(conf);
 	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
+	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
 	kfree(conf);
 	mddev->private = NULL;
 	return 0;

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-11-02 14:20:15.000000000 +1100
+++ ./drivers/md/raid6main.c	2004-11-02 14:20:18.000000000 +1100
@@ -1878,6 +1878,7 @@ static int stop (mddev_t *mddev)
 	mddev->thread = NULL;
 	shrink_stripes(conf);
 	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
+	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
 	kfree(conf);
 	mddev->private = NULL;
 	return 0;
