From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 13 - Fix assort typos in most recent MD patches..
Date: Thu, 22 Aug 2002 10:33:54 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E17hfv8-0004zt-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Here is a collection of 13 patches against 2.4.31 (plus BK upto cset 1.508)
which fix a few bugs and do some more tidying up.
I have done some testing with most raid levels (not multipath) and it mostly
seems to work.  I think there is still an issue with raid5 when hot-swapping.

Anyone keen to do some testing ?? (I'm between test rigs at the moment.  Last 
one gone into service, new not ordered yet).

### Comments for ChangeSet

1/ Raid0 should not be accessing rdev->sb.

2/ Don't unlock rdev (which releases bdev) until after last use of bdev

3/ Fix typo in a printk ( = should be -)

4/ i should be dd_idx in compute_block




 ----------- Diffstat output ------------
 ./drivers/md/md.c    |    2 +-
 ./drivers/md/raid0.c |    2 +-
 ./drivers/md/raid5.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- ./drivers/md/raid0.c	2002/08/21 11:20:16	1.1
+++ ./drivers/md/raid0.c	2002/08/21 11:24:29	1.2
@@ -87,7 +87,7 @@ static int create_strip_zones (mddev_t *
 	cnt = 0;
 	smallest = NULL;
 	ITERATE_RDEV(mddev, rdev1, tmp1) {
-		int j = rdev1->sb->this_disk.raid_disk;
+		int j = rdev1->raid_disk;
 
 		if (j < 0 || j >= mddev->raid_disks) {
 			printk("raid0: bad disk number %d - aborting!\n", j);
--- ./drivers/md/md.c	2002/08/21 11:20:29	1.1
+++ ./drivers/md/md.c	2002/08/21 11:24:29	1.2
@@ -594,10 +594,10 @@ static void export_rdev(mdk_rdev_t * rde
 		MD_BUG();
 	free_disk_sb(rdev);
 	list_del_init(&rdev->same_set);
-	unlock_rdev(rdev);
 #ifndef MODULE
 	md_autodetect_dev(rdev->bdev->bd_dev);
 #endif
+	unlock_rdev(rdev);
 	rdev->faulty = 0;
 	kfree(rdev);
 }
--- ./drivers/md/raid5.c	2002/08/21 11:20:50	1.1
+++ ./drivers/md/raid5.c	2002/08/21 11:24:29	1.2
@@ -681,7 +681,7 @@ static void compute_block(struct stripe_
 	}
 	if (count != 1)
 		xor_block(count, STRIPE_SIZE, ptr);
-	set_bit(R5_UPTODATE, &sh->dev[i].flags);
+	set_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
 }
 
 static void compute_parity(struct stripe_head *sh, int method)
@@ -1519,7 +1519,7 @@ static int run (mddev_t *mddev)
 		       mddev->raid_disks-mddev->degraded, mddev->raid_disks, conf->algorithm);
 	else
 		printk(KERN_ALERT "raid5: raid level %d set md%d active with %d out of %d devices, algorithm %d\n", conf->level, mdidx(mddev),
-		       mddev->raid_disks = mddev->degraded, mddev->raid_disks, conf->algorithm);
+		       mddev->raid_disks - mddev->degraded, mddev->raid_disks, conf->algorithm);
 
 	print_raid5_conf(conf);
 
