From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 14 of 22 - Second step to tidying mddev refcounts and locking
Date: Wed, 19 Jun 2002 10:53:09 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54773.177802.684600@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



This patch gets md_open to use mddev_find instead of kdev_to_mddev, thus
creating the mddev if necessary.
This guarantees that md_release will be able to find an mddev to
mddev_put.

Now that we are certain of getting the refcount right at open/close time,
we don't need the "countdev" stuff.  If START_ARRAY happens to start and
array other than that the one that is currently opened, it won't confuse
things at all.


 ----------- Diffstat output ------------
 ./drivers/md/md.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

--- ./drivers/md/md.c	2002/06/18 04:40:56	1.13
+++ ./drivers/md/md.c	2002/06/18 04:47:43	1.14
@@ -1809,7 +1809,7 @@
  *
  * If "unit" is allocated, then bump its reference count
  */
-static void autorun_devices(kdev_t countdev)
+static void autorun_devices(void)
 {
 	struct list_head candidates;
 	struct list_head *tmp;
@@ -1863,9 +1863,7 @@
 			list_del_init(&rdev->pending);
 		}
 		autorun_array(mddev);
-		if (minor(countdev) != mdidx(mddev))
-		    mddev_put(mddev);
-		/* else put will happen at md_close time */
+		mddev_put(mddev);
 	}
 	printk(KERN_INFO "md: ... autorun DONE.\n");
 }
@@ -1902,7 +1900,7 @@
 #define AUTORUNNING KERN_INFO \
 "md: auto-running md%d.\n"
 
-static int autostart_array(kdev_t startdev, kdev_t countdev)
+static int autostart_array(kdev_t startdev)
 {
 	int err = -EINVAL, i;
 	mdp_super_t *sb = NULL;
@@ -1962,7 +1960,7 @@
 	/*
 	 * possibly return codes
 	 */
-	autorun_devices(countdev);
+	autorun_devices();
 	return 0;
 
 abort:
@@ -2549,7 +2547,7 @@
 			/*
 			 * possibly make it lock the array ...
 			 */
-			err = autostart_array(val_to_kdev(arg), dev);
+			err = autostart_array(val_to_kdev(arg));
 			if (err) {
 				printk(KERN_WARNING "md: autostart %s failed!\n",
 					partition_name(val_to_kdev(arg)));
@@ -2701,19 +2699,23 @@
 static int md_open(struct inode *inode, struct file *file)
 {
 	/*
-	 * Always succeed, but increment the usage count
+	 * Succeed if we can find or allocate a mddev structure.
 	 */
-	mddev_t *mddev = kdev_to_mddev(inode->i_rdev);
-	if (mddev)
-		mddev_get(mddev);
-	return (0);
+	mddev_t *mddev = mddev_find(minor(inode->i_rdev));
+
+	if (mddev) 
+		return 0; /* and we "own" a reference */
+	else
+		return -ENOMEM;
 }
 
 static int md_release(struct inode *inode, struct file * file)
 {
 	mddev_t *mddev = kdev_to_mddev(inode->i_rdev);
-	if (mddev)
-		mddev_put(mddev);
+	if (!mddev)
+		BUG();
+	mddev_put(mddev);
+
 	return 0;
 }
 
@@ -3548,7 +3550,7 @@
 	}
 	dev_cnt = 0;
 
-	autorun_devices(to_kdev_t(-1));
+	autorun_devices();
 }
 
 static struct {
