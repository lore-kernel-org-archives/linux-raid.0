From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 1 of 27 - Remove bdput calls from raid personalities.
Date: Thu, 18 Jul 2002 23:31:46 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133146.4736@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Linus (and others)
 here is another patch-bomb for md/raid.

Currently the structure of the raid superblock is deeply entwined into
the code.  Lots of bits of code query and update the superblock.  The
main thrust of this series of patches is to move all of the important
information in the the mddev structure (which describes the whole
array) or the rdev structure (which describes a component device).

The information then gets initialised in these structures when the
superblock is read, and the superblock is regenerated from info in
these structures when the superblock is written.
This will mean that it is easier to support different superblock
formats, and all means that a lot of data redundancy is removed.

On the way to effecting these changes a lot of tidying up gets done,
particularly in multipath, but also elsewhere.

I must admit that I haven't heavily tested the end result of these
patches.  That will come...

I foresee about one more patch-bomb like this to get md into a state
where I can start making functional enhancements and can verify
correctness more easily.

This and the follow 26 patches are cummulative against 2.5.26.
I don't foresee backporting much if any of this to 2.4.

NeilBrown


### Comments for ChangeSet
Remove bdput calls from raid personalities.

Some of the md personalities currently hold a counted reference
on a bdev.  This is not necessary as the main md module will always
hold a counted reference in the rdev.
This patch removes the code to take and drop these unnecessary 
references.




 ----------- Diffstat output ------------
 ./drivers/md/linear.c    |   11 +----------
 ./drivers/md/multipath.c |    8 --------
 ./drivers/md/raid1.c     |   10 ----------
 3 files changed, 1 insertion(+), 28 deletions(-)

--- ./drivers/md/linear.c	2002/07/18 11:57:38	1.1
+++ ./drivers/md/linear.c	2002/07/18 11:57:48	1.2
@@ -61,7 +61,6 @@ static int linear_run (mddev_t *mddev)
 		}
 
 		disk->bdev = rdev->bdev;
-		atomic_inc(&rdev->bdev->bd_count);
 		disk->size = rdev->size;
 
 		if (!conf->smallest || (disk->size < conf->smallest->size))
@@ -112,12 +111,8 @@ static int linear_run (mddev_t *mddev)
 	return 0;
 
 out:
-	if (conf) {
-		for (i = 0; i < MD_SB_DISKS; i++)
-			if (conf->disks[i].bdev)
-				bdput(conf->disks[i].bdev);
+	if (conf)
 		kfree(conf);
-	}
 	MOD_DEC_USE_COUNT;
 	return 1;
 }
@@ -125,11 +120,7 @@ out:
 static int linear_stop (mddev_t *mddev)
 {
 	linear_conf_t *conf = mddev_to_conf(mddev);
-	int i;
   
-	for (i = 0; i < MD_SB_DISKS; i++)
-		if (conf->disks[i].bdev)
-			bdput(conf->disks[i].bdev);
 	kfree(conf->hash_table);
 	kfree(conf);
 
--- ./drivers/md/multipath.c	2002/07/18 11:57:39	1.1
+++ ./drivers/md/multipath.c	2002/07/18 11:57:49	1.2
@@ -881,7 +881,6 @@ static int multipath_run (mddev_t *mddev
 		disk->number = desc->number;
 		disk->raid_disk = desc->raid_disk;
 		disk->bdev = rdev->bdev;
-		atomic_inc(&rdev->bdev->bd_count);
 		disk->operational = 0;
 		disk->spare = 1;
 		disk->used_slot = 1;
@@ -1006,9 +1005,6 @@ static int multipath_run (mddev_t *mddev
 
 out_free_conf:
 	multipath_shrink_mpbh(conf);
-	for (i = 0; i < MD_SB_DISKS; i++)
-		if (conf->multipaths[i].bdev)
-			bdput(conf->multipaths[i].bdev);
 	kfree(conf);
 	mddev->private = NULL;
 out:
@@ -1031,13 +1027,9 @@ out:
 static int multipath_stop (mddev_t *mddev)
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
-	int i;
 
 	md_unregister_thread(conf->thread);
 	multipath_shrink_mpbh(conf);
-	for (i = 0; i < MD_SB_DISKS; i++)
-		if (conf->multipaths[i].bdev)
-			bdput(conf->multipaths[i].bdev);
 	kfree(conf);
 	mddev->private = NULL;
 	MOD_DEC_USE_COUNT;
--- ./drivers/md/raid1.c	2002/07/18 11:57:39	1.1
+++ ./drivers/md/raid1.c	2002/07/18 11:57:49	1.2
@@ -1301,7 +1301,6 @@ static int run(mddev_t *mddev)
 			disk->number = descriptor->number;
 			disk->raid_disk = disk_idx;
 			disk->bdev = rdev->bdev;
-			atomic_inc(&rdev->bdev->bd_count);
 			disk->operational = 0;
 			disk->write_only = 0;
 			disk->spare = 0;
@@ -1333,7 +1332,6 @@ static int run(mddev_t *mddev)
 			disk->number = descriptor->number;
 			disk->raid_disk = disk_idx;
 			disk->bdev = rdev->bdev;
-			atomic_inc(&rdev->bdev->bd_count);
 			disk->operational = 1;
 			disk->write_only = 0;
 			disk->spare = 0;
@@ -1348,7 +1346,6 @@ static int run(mddev_t *mddev)
 			disk->number = descriptor->number;
 			disk->raid_disk = disk_idx;
 			disk->bdev = rdev->bdev;
-			atomic_inc(&rdev->bdev->bd_count);
 			disk->operational = 0;
 			disk->write_only = 0;
 			disk->spare = 1;
@@ -1434,9 +1431,6 @@ static int run(mddev_t *mddev)
 out_free_conf:
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
-	for (i = 0; i < MD_SB_DISKS; i++)
-		if (conf->mirrors[i].bdev)
-			bdput(conf->mirrors[i].bdev);
 	kfree(conf);
 	mddev->private = NULL;
 out:
@@ -1447,14 +1441,10 @@ out:
 static int stop(mddev_t *mddev)
 {
 	conf_t *conf = mddev_to_conf(mddev);
-	int i;
 
 	md_unregister_thread(conf->thread);
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
-	for (i = 0; i < MD_SB_DISKS; i++)
-		if (conf->mirrors[i].bdev)
-			bdput(conf->mirrors[i].bdev);
 	kfree(conf);
 	mddev->private = NULL;
 	MOD_DEC_USE_COUNT;
