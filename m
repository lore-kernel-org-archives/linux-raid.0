From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 6 of 10 - Don't do_md_stop and array when do_md_run fails.
Date: Fri, 16 Jan 2004 12:19:39 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AhIeB-0002Uc-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Current code calls do_md_stop to clean up if do_md_run
fails, but this is 
  a/ not needed as do_md_run cleans up itself
  b/ bad as it could try to clean up after an -EBUSY error !!!

 ----------- Diffstat output ------------
 ./drivers/md/md.c |   15 +--------------
 1 files changed, 1 insertion(+), 14 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-16 12:05:40.000000000 +1100
+++ ./drivers/md/md.c	2004-01-16 12:06:25.000000000 +1100
@@ -1764,10 +1764,8 @@ static void autorun_array(mddev_t *mddev
 	printk("\n");
 
 	err = do_md_run (mddev);
-	if (err) {
+	if (err)
 		printk(KERN_WARNING "md :do_md_run() returned %d\n", err);
-		do_md_stop (mddev, 0);
-	}
 }
 
 /*
@@ -2569,19 +2567,8 @@ static int md_ioctl(struct inode *inode,
 			goto done_unlock;
 
 		case RUN_ARRAY:
-		{
 			err = do_md_run (mddev);
-			/*
-			 * we have to clean up the mess if
-			 * the array cannot be run for some
-			 * reason ...
-			 * ->pers will not be set, to superblock will
-			 * not be updated.
-			 */
-			if (err)
-				do_md_stop (mddev, 0);
 			goto done_unlock;
-		}
 
 		default:
 			if (_IOC_TYPE(cmd) == MD_MAJOR)
