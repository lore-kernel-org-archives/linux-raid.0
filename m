From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 4 - Fix up freeing of kmalloc structures
Date: Thu, 05 Jun 2003 11:51:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19Njun-0005Fs-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

Some paths free things twice, others free un-initialised values :-(
Not any more.

 ----------- Diffstat output ------------
 ./drivers/md/raid0.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-06-05 11:07:50.000000000 +1000
+++ ./drivers/md/raid0.c	2003-06-05 11:09:02.000000000 +1000
@@ -85,10 +85,8 @@ static int create_strip_zones (mddev_t *
 	conf->devlist = kmalloc(sizeof(mdk_rdev_t*)*
 				conf->nr_strip_zones*mddev->raid_disks,
 				GFP_KERNEL);
-	if (!conf->devlist) {
-		kfree(conf);
+	if (!conf->devlist)
 		return 1;
-	}
 
 	memset(conf->strip_zone, 0,sizeof(struct strip_zone)*
 				   conf->nr_strip_zones);
@@ -193,8 +191,6 @@ static int create_strip_zones (mddev_t *
 	printk("raid0: done.\n");
 	return 0;
  abort:
-	kfree(conf->devlist);
-	kfree(conf->strip_zone);
 	return 1;
 }
 
@@ -235,6 +231,8 @@ static int raid0_run (mddev_t *mddev)
 		goto out;
 	mddev->private = (void *)conf;
  
+	conf->strip_zone = NULL;
+	conf->devlist = NULL;
 	if (create_strip_zones (mddev)) 
 		goto out_free_conf;
 
@@ -273,7 +271,7 @@ static int raid0_run (mddev_t *mddev)
 				nb_zone*sizeof(struct strip_zone*));
 	conf->hash_table = kmalloc (sizeof (struct strip_zone *)*nb_zone, GFP_KERNEL);
 	if (!conf->hash_table)
-		goto out_free_zone_conf;
+		goto out_free_conf;
 	size = conf->strip_zone[cur].size;
 
 	for (i=0; i< nb_zone; i++) {
@@ -296,12 +294,11 @@ static int raid0_run (mddev_t *mddev)
 	blk_queue_merge_bvec(&mddev->queue, raid0_mergeable_bvec);
 	return 0;
 
-out_free_zone_conf:
-	kfree(conf->strip_zone);
-	conf->strip_zone = NULL;
-
 out_free_conf:
-	kfree (conf->devlist);
+	if (conf->strip_zone)
+		kfree(conf->strip_zone);
+	if (conf->devlist)
+		kfree (conf->devlist);
 	kfree(conf);
 	mddev->private = NULL;
 out:
