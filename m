From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 11 of 22 - Get rid of "OUT" macro in md.c
Date: Wed, 19 Jun 2002 10:52:11 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54715.981060.97803@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



It doesn't really help clarity or brevity.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

--- ./drivers/md/md.c	2002/06/18 04:29:32	1.10
+++ ./drivers/md/md.c	2002/06/18 04:33:08	1.11
@@ -1654,21 +1654,21 @@
 #undef TOO_BIG_CHUNKSIZE
 #undef BAD_CHUNKSIZE
 
-#define OUT(x) do { err = (x); goto out; } while (0)
-
 static int restart_array(mddev_t *mddev)
 {
-	int err = 0;
+	int err;
 
 	/*
 	 * Complain if it has no devices
 	 */
+	err = -ENXIO;
 	if (list_empty(&mddev->disks))
-		OUT(-ENXIO);
+		goto out;
 
 	if (mddev->pers) {
+		err = -EBUSY;
 		if (!mddev->ro)
-			OUT(-EBUSY);
+			goto out;
 
 		mddev->ro = 0;
 		set_device_ro(mddev_to_kdev(mddev), 0);
@@ -1681,6 +1681,7 @@
 		md_recover_arrays();
 		if (mddev->pers->restart_resync)
 			mddev->pers->restart_resync(mddev);
+		err = 0;
 	} else {
 		printk(KERN_ERR "md: md%d has no personality assigned.\n",
 			mdidx(mddev));
@@ -1703,7 +1704,8 @@
 
 	if (atomic_read(&mddev->active)>1) {
 		printk(STILL_IN_USE, mdidx(mddev));
-		OUT(-EBUSY);
+		err = -EBUSY;
+		goto out;
 	}
 
 	if (mddev->pers) {
@@ -1731,16 +1733,18 @@
 		invalidate_device(dev, 1);
 
 		if (ro) {
+			err  = -ENXIO;
 			if (mddev->ro)
-				OUT(-ENXIO);
+				goto out;
 			mddev->ro = 1;
 		} else {
 			if (mddev->ro)
 				set_device_ro(dev, 0);
 			if (mddev->pers->stop(mddev)) {
+				err = -EBUSY;
 				if (mddev->ro)
 					set_device_ro(dev, 1);
-				OUT(-EBUSY);
+				goto out;
 			}
 			if (mddev->ro)
 				mddev->ro = 0;
@@ -1766,14 +1770,12 @@
 	if (!ro) {
 		printk(KERN_INFO "md: md%d stopped.\n", mdidx(mddev));
 		free_mddev(mddev);
-
 	} else
 		printk(KERN_INFO "md: md%d switched to read-only mode.\n", mdidx(mddev));
+	err = 0;
 out:
 	return err;
 }
-
-#undef OUT
 
 /*
  * We have to safely support old arrays too.
