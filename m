From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 12 of 27 - Set desc_nr more sanely.
Date: Thu, 18 Jul 2002 23:33:19 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133319.4883@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Set desc_nr more sanely.

Currently rdev->desc_nr is set in sync_sbs which is typcially
called just before writing out the superblocks, which is an
odd place to set it.
It is also called when a new disk is added (which is sane) and
when an old disc is imported ... which is quesitonable.

With this patch it is set when a new disk is added, and when
the superblocks are being analysed, which makes lots of sense.

MULTIPATH is particularly an issue here.  The old code tried
to figure the desc_nr for an rdev by matching device numbers in
the superblock.  This doesn't make a lot of sense as
device numbers can change.  Now MULTIPATH components
get sequential desc_nrs.



 ----------- Diffstat output ------------
 ./drivers/md/md.c |   40 +++++++++++++++-------------------------
 1 files changed, 15 insertions(+), 25 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:02:00	1.6
+++ ./drivers/md/md.c	2002/07/18 12:02:10	1.7
@@ -876,7 +876,6 @@ static void set_this_disk(mddev_t *mddev
 #endif
 		if (kdev_same(mk_kdev(desc->major,desc->minor), rdev->dev)) {
 			rdev->sb->this_disk = *desc;
-			rdev->desc_nr = desc->number;
 			ok = 1;
 			break;
 		}
@@ -1019,14 +1018,11 @@ static mdk_rdev_t *md_import_device(kdev
 			goto abort_free;
 		}
 
-		if (rdev->sb->level != LEVEL_MULTIPATH) {
+		if (rdev->sb->level != LEVEL_MULTIPATH)
 			rdev->old_dev = mk_kdev(rdev->sb->this_disk.major,
 						rdev->sb->this_disk.minor);
-			rdev->desc_nr = rdev->sb->this_disk.number;
-		} else {
+		else
 			rdev->old_dev = NODEV;
-			rdev->desc_nr = -1;
-		}
 	}
 	INIT_LIST_HEAD(&rdev->same_set);
 
@@ -1065,7 +1061,7 @@ abort_free:
 
 static int analyze_sbs(mddev_t * mddev)
 {
-	int out_of_date = 0, i, first;
+	int out_of_date = 0, i;
 	struct list_head *tmp, *tmp2;
 	mdk_rdev_t *rdev, *rdev2, *freshest;
 	mdp_super_t *sb;
@@ -1173,6 +1169,18 @@ static int analyze_sbs(mddev_t * mddev)
 		}
 	}
 
+	/* set rdev->desc_nr for each device.
+	 * for MULTIPATH, we just us sequential number as
+	 * nothing else is meaningful
+	 */
+	i = 0;
+	ITERATE_RDEV(mddev,rdev,tmp) {
+		if (sb->level == LEVEL_MULTIPATH) {
+			rdev->alias_device = !!i;
+			rdev->desc_nr = i++;
+		} else
+			rdev->desc_nr = rdev->sb->this_disk.number;
+	}
 	/*
 	 * Fix up changed device names ... but only if this disk has a
 	 * recent update time. Use faulty checksum ones too.
@@ -1301,7 +1309,6 @@ static int analyze_sbs(mddev_t * mddev)
 	 * Double check wether all devices mentioned in the
 	 * superblock are in the rdev ring.
 	 */
-	first = 1;
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		mdp_disk_t *desc;
 		kdev_t dev;
@@ -1321,23 +1328,6 @@ static int analyze_sbs(mddev_t * mddev)
 		if (!rdev) {
 			MD_BUG();
 			goto abort;
-		}
-		/*
-		 * In the case of Multipath-IO, we have no
-		 * other information source to find out which
-		 * disk is which, only the position of the device
-		 * in the superblock:
-		 */
-		if (mddev->sb->level == LEVEL_MULTIPATH) {
-			if ((rdev->desc_nr != -1) && (rdev->desc_nr != i)) {
-				MD_BUG();
-				goto abort;
-			}
-			rdev->desc_nr = i;
-			if (!first)
-				rdev->alias_device = 1;
-			else
-				first = 0;
 		}
 	}
 
