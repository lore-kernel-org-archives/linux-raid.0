From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 9 of 13 - Remove 'alias_device' flag.
Date: Thu, 22 Aug 2002 10:34:19 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E17hfvX-00050U-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

This flag was used by multipath to make sure only
one superblock was written, as there is only one
real device.

The relevant test is now more explicitly dependant on multipath,
and the flag is gone.


 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   10 ++++------
 ./include/linux/raid/md_k.h |    1 -
 2 files changed, 4 insertions(+), 7 deletions(-)

--- ./include/linux/raid/md_k.h	2002/08/21 23:11:27	1.4
+++ ./include/linux/raid/md_k.h	2002/08/21 23:12:58	1.5
@@ -154,7 +154,6 @@ struct mdk_rdev_s
 	mdp_super_t	*sb;
 	unsigned long	sb_offset;
 
-	int alias_device;		/* device alias to the same disk */
 	int faulty;			/* if faulty do not issue IO requests */
 	int in_sync;			/* device is a full member of the array */
 
--- ./drivers/md/md.c	2002/08/21 23:11:27	1.8
+++ ./drivers/md/md.c	2002/08/21 23:12:58	1.9
@@ -906,8 +906,6 @@ static void sync_sbs(mddev_t * mddev)
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		mdp_super_t *this_sb;
 		
-		if (rdev->faulty || rdev->alias_device)
-			continue;
 		this_sb = rdev->sb;
 		if (this_sb != sb)
 			*this_sb = *sb;
@@ -953,16 +951,17 @@ repeat:
 		printk(KERN_INFO "md: ");
 		if (rdev->faulty)
 			printk("(skipping faulty ");
-		if (rdev->alias_device)
-			printk("(skipping alias ");
 
 		printk("%s ", bdev_partition_name(rdev->bdev));
-		if (!rdev->faulty && !rdev->alias_device) {
+		if (!rdev->faulty) {
 			printk("[events: %08lx]",
 				(unsigned long)rdev->sb->events_lo);
 			err += write_disk_sb(rdev);
 		} else
 			printk(")\n");
+		if (!err && mddev->level == LEVEL_MULTIPATH)
+			/* only need to write one superblock... */
+			break;
 	}
 	if (err) {
 		if (--count) {
@@ -1196,7 +1195,6 @@ static int analyze_sbs(mddev_t * mddev)
 	i = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		if (mddev->level == LEVEL_MULTIPATH) {
-			rdev->alias_device = !!i;
 			rdev->desc_nr = i++;
 			rdev->raid_disk = rdev->desc_nr;
 			rdev->in_sync = 1;
