From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 15 of 22 - Get rid of kdev_to_mddev
Date: Wed, 19 Jun 2002 10:53:29 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54793.393264.150340@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Only two users of kdev_to_mddev remain, md_release and
md_queue_proc.

For md_release we can store the mddev in the md_inode
at md_open time so we can find it easily.

For md_queue_proc, we use mddev_find because we only have the
device number to work with.  Hopefully the ->queue function
will get more arguements one day...


 ----------- Diffstat output ------------
 ./drivers/md/md.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

--- ./drivers/md/md.c	2002/06/18 04:47:43	1.14
+++ ./drivers/md/md.c	2002/06/18 04:53:10	1.15
@@ -132,13 +132,6 @@
 
 static mddev_t *mddev_map[MAX_MD_DEVS];
 
-static inline mddev_t * kdev_to_mddev (kdev_t dev)
-{
-	if (major(dev) != MD_MAJOR)
-		BUG();
-        return mddev_map[minor(dev)];
-}
-
 static int md_fail_request (request_queue_t *q, struct bio *bio)
 {
 	bio_io_error(bio);
@@ -2703,15 +2696,17 @@
 	 */
 	mddev_t *mddev = mddev_find(minor(inode->i_rdev));
 
-	if (mddev) 
+	if (mddev) {
+		inode->i_bdev->bd_inode->u.generic_ip = mddev;
 		return 0; /* and we "own" a reference */
-	else
+	} else
 		return -ENOMEM;
 }
 
 static int md_release(struct inode *inode, struct file * file)
 {
-	mddev_t *mddev = kdev_to_mddev(inode->i_rdev);
+ 	mddev_t *mddev = inode->i_bdev->bd_inode->u.generic_ip;
+
 	if (!mddev)
 		BUG();
 	mddev_put(mddev);
@@ -3439,11 +3434,14 @@
 
 request_queue_t * md_queue_proc(kdev_t dev)
 {
-	mddev_t *mddev = kdev_to_mddev(dev);
-	if (mddev == NULL)
-		return BLK_DEFAULT_QUEUE(MAJOR_NR);
-	else
-		return &mddev->queue;
+	mddev_t *mddev = mddev_find(minor(dev));
+	request_queue_t *q = BLK_DEFAULT_QUEUE(MAJOR_NR);
+	if (!mddev || atomic_read(&mddev->active)<2)
+		BUG();
+	if (mddev->pers)
+		q = &mddev->queue;
+	mddev_put(mddev); /* the caller must hold a reference... */
+	return q;
 }
 
 int __init md_init(void)
