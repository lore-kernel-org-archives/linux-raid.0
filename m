From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 9 of 14 - Remove dependancy on MD_SB_DISKS from multipath
Date: Tue, 27 May 2003 13:01:14 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19KUiA-0003HI-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

Multipath has a dependancy on MD_SB_DISKS which is no
longer authoritative.  We change it to use a separately
allocated array.

 ----------- Diffstat output ------------
 ./drivers/md/multipath.c         |   18 +++++++++++++++---
 ./include/linux/raid/multipath.h |    2 +-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-05-27 11:58:24.000000000 +1000
+++ ./drivers/md/multipath.c	2003-05-27 11:58:25.000000000 +1000
@@ -58,7 +58,7 @@ static void mp_pool_free(void *mpb, void
 static int multipath_map (mddev_t *mddev, mdk_rdev_t **rdevp)
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
-	int i, disks = mddev->max_disks;
+	int i, disks = conf->raid_disks;
 
 	/*
 	 * Later we do read balancing on the read side 
@@ -146,7 +146,7 @@ static int multipath_read_balance (multi
 {
 	int disk;
 
-	for (disk = 0; disk < conf->mddev->max_disks; disk++) {
+	for (disk = 0; disk < conf->raid_disks; disk++) {
 		mdk_rdev_t *rdev = conf->multipaths[disk].rdev;
 		if (rdev && rdev->in_sync)
 			return disk;
@@ -246,7 +246,7 @@ static void print_multipath_conf (multip
 	printk(" --- wd:%d rd:%d\n", conf->working_disks,
 			 conf->raid_disks);
 
-	for (i = 0; i < conf->mddev->max_disks; i++) {
+	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->multipaths + i;
 		if (tmp->rdev)
 			printk(" disk%d, o:%d, dev:%s\n",
@@ -385,6 +385,15 @@ static int multipath_run (mddev_t *mddev
 	}
 	memset(conf, 0, sizeof(*conf));
 
+	conf->multipaths = kmalloc(sizeof(struct multipath_info)*mddev->raid_disks,
+				   GFP_KERNEL);
+	if (!conf->multipaths) {
+		printk(KERN_ERR 
+			"multipath: couldn't allocate memory for md%d\n",
+			mdidx(mddev));
+		goto out_free_conf;
+	}
+
 	conf->working_disks = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		disk_idx = rdev->raid_disk;
@@ -443,6 +452,8 @@ static int multipath_run (mddev_t *mddev
 out_free_conf:
 	if (conf->pool)
 		mempool_destroy(conf->pool);
+	if (conf->multipaths)
+		kfree(conf->multipaths);
 	kfree(conf);
 	mddev->private = NULL;
 out:
@@ -456,6 +467,7 @@ static int multipath_stop (mddev_t *mdde
 
 	md_unregister_thread(mddev->thread);
 	mempool_destroy(conf->pool);
+	kfree(conf->multipaths);
 	kfree(conf);
 	mddev->private = NULL;
 	return 0;

diff ./include/linux/raid/multipath.h~current~ ./include/linux/raid/multipath.h
--- ./include/linux/raid/multipath.h~current~	2003-05-27 11:58:24.000000000 +1000
+++ ./include/linux/raid/multipath.h	2003-05-27 11:58:25.000000000 +1000
@@ -9,7 +9,7 @@ struct multipath_info {
 
 struct multipath_private_data {
 	mddev_t			*mddev;
-	struct multipath_info	multipaths[MD_SB_DISKS];
+	struct multipath_info	*multipaths;
 	int			raid_disks;
 	int			working_disks;
 	spinlock_t		device_lock;
