From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md -  Resolve problem with refcounting of md arrays.
Date: Mon, 28 Jul 2003 16:56:43 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19h1w3-0002rB-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Because an md array may not exist yet when the device it opened, the ->active
count, which is incremented on opening if the array exists, is not 100% reliable.
This patch changes md to test inode->i_bdev->bd_openers rather than mddev->active
to test if an array is still in used before stopping it.

(patch against 2.4.22-pre9)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-07-28 16:24:11.000000000 +1000
+++ ./drivers/md/md.c	2003-07-28 16:26:48.000000000 +1000
@@ -1805,10 +1805,12 @@ static int do_md_stop(mddev_t * mddev, i
 	int err = 0, resync_interrupted = 0;
 	kdev_t dev = mddev_to_kdev(mddev);
 
+#if 0 /* ->active is not currently reliable */
 	if (atomic_read(&mddev->active)>1) {
 		printk(STILL_IN_USE, mdidx(mddev));
 		OUT(-EBUSY);
 	}
+#endif
 
 	if (mddev->pers) {
 		/*
@@ -2742,12 +2744,17 @@ static int md_ioctl(struct inode *inode,
 			goto done_unlock;
 
 		case STOP_ARRAY:
-			if (!(err = do_md_stop (mddev, 0)))
+			if (inode->i_bdev->bd_openers > 1)
+				err = -EBUSY;
+			else if (!(err = do_md_stop (mddev, 0)))
 				mddev = NULL;
 			goto done_unlock;
 
 		case STOP_ARRAY_RO:
-			err = do_md_stop (mddev, 1);
+			if (inode->i_bdev->bd_openers > 1)
+				err = -EBUSY;
+			else 
+				err = do_md_stop (mddev, 1);
 			goto done_unlock;
 
 	/*
