From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 9 of 22 - Discard functions that have been "not yet" for a long time
Date: Wed, 19 Jun 2002 10:51:44 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54688.95261.464387@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Discard functions that have been "not yet" for a long time

It is not clear what these should do, or if they will ever be
needed, so let's clean them out.  They can easily be recreated
if there is a need.



 ----------- Diffstat output ------------
 ./drivers/md/md.c |   50 --------------------------------------------------
 1 files changed, 50 deletions(-)

--- ./drivers/md/md.c	2002/06/18 04:18:33	1.8
+++ ./drivers/md/md.c	2002/06/18 04:20:52	1.9
@@ -2503,36 +2503,6 @@
 }
 #undef SET_SB
 
-static int set_disk_info(mddev_t * mddev, void * arg)
-{
-	printk(KERN_INFO "md: not yet");
-	return -EINVAL;
-}
-
-static int clear_array(mddev_t * mddev)
-{
-	printk(KERN_INFO "md: not yet");
-	return -EINVAL;
-}
-
-static int write_raid_info(mddev_t * mddev)
-{
-	printk(KERN_INFO "md: not yet");
-	return -EINVAL;
-}
-
-static int protect_array(mddev_t * mddev)
-{
-	printk(KERN_INFO "md: not yet");
-	return -EINVAL;
-}
-
-static int unprotect_array(mddev_t * mddev)
-{
-	printk(KERN_INFO "md: not yet");
-	return -EINVAL;
-}
-
 static int set_disk_faulty(mddev_t *mddev, kdev_t dev)
 {
 	mdk_rdev_t *rdev;
@@ -2767,10 +2737,6 @@
 
 	switch (cmd)
 	{
-		case CLEAR_ARRAY:
-			err = clear_array(mddev);
-			goto done_unlock;
-
 		case ADD_NEW_DISK:
 		{
 			mdu_disk_info_t info;
@@ -2789,22 +2755,6 @@
 
 		case HOT_ADD_DISK:
 			err = hot_add_disk(mddev, val_to_kdev(arg));
-			goto done_unlock;
-
-		case SET_DISK_INFO:
-			err = set_disk_info(mddev, (void *)arg);
-			goto done_unlock;
-
-		case WRITE_RAID_INFO:
-			err = write_raid_info(mddev);
-			goto done_unlock;
-
-		case UNPROTECT_ARRAY:
-			err = unprotect_array(mddev);
-			goto done_unlock;
-
-		case PROTECT_ARRAY:
-			err = protect_array(mddev);
 			goto done_unlock;
 
 		case SET_DISK_FAULTY:
