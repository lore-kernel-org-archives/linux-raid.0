From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 4 of 6 - Get rid of vmalloc/vfree from raid0
Date: Thu, 08 May 2003 11:39:44 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19DaNs-0004up-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

raid0 currently uses vmalloc instead of kmalloc.  This patch
changes to kmalloc.
There is one allocation that can occasionally be very large - the hash_table.
A subsequent patch will address this issue.

 ----------- Diffstat output ------------
 ./drivers/md/raid0.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-05-02 16:40:59.000000000 +1000
+++ ./drivers/md/raid0.c	2003-05-02 16:41:23.000000000 +1000
@@ -75,8 +75,8 @@ static int create_strip_zones (mddev_t *
 	}
 	printk("raid0: FINAL %d zones\n", conf->nr_strip_zones);
 
-	conf->strip_zone = vmalloc(sizeof(struct strip_zone)*
-				conf->nr_strip_zones);
+	conf->strip_zone = kmalloc(sizeof(struct strip_zone)*
+				conf->nr_strip_zones, GFP_KERNEL);
 	if (!conf->strip_zone)
 		return 1;
 
@@ -163,7 +163,7 @@ static int create_strip_zones (mddev_t *
 	printk("raid0: done.\n");
 	return 0;
  abort:
-	vfree(conf->strip_zone);
+	kfree(conf->strip_zone);
 	return 1;
 }
 
@@ -200,7 +200,7 @@ static int raid0_run (mddev_t *mddev)
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 
-	conf = vmalloc(sizeof (raid0_conf_t));
+	conf = kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
 	if (!conf)
 		goto out;
 	mddev->private = (void *)conf;
@@ -233,7 +233,7 @@ static int raid0_run (mddev_t *mddev)
 
 	printk("raid0 : Allocating %Zd bytes for hash.\n",
 				nb_zone*sizeof(struct raid0_hash));
-	conf->hash_table = vmalloc (sizeof (struct raid0_hash)*nb_zone);
+	conf->hash_table = kmalloc (sizeof (struct raid0_hash)*nb_zone, GFP_KERNEL);
 	if (!conf->hash_table)
 		goto out_free_zone_conf;
 	size = conf->strip_zone[cur].size;
@@ -277,14 +277,14 @@ static int raid0_run (mddev_t *mddev)
 	return 0;
 
 out_free_zone_conf:
-	vfree(conf->strip_zone);
+	kfree(conf->strip_zone);
 	conf->strip_zone = NULL;
 
  out_free_pool:
 	mempool_destroy(conf->pool);
 
 out_free_conf:
-	vfree(conf);
+	kfree(conf);
 	mddev->private = NULL;
 out:
 	return 1;
@@ -294,13 +294,13 @@ static int raid0_stop (mddev_t *mddev)
 {
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 
-	vfree (conf->hash_table);
+	kfree (conf->hash_table);
 	conf->hash_table = NULL;
-	vfree (conf->strip_zone);
+	kfree (conf->strip_zone);
 	conf->strip_zone = NULL;
 	if (conf->pool)
 		mempool_destroy(conf->pool);
-	vfree (conf);
+	kfree (conf);
 	mddev->private = NULL;
 
 	return 0;
