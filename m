From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 10 of 10 - Use bd_disk->private data instead of bd_inode->u.generic_ip
Date: Fri, 16 Jan 2004 12:19:41 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AhIeD-0002VC-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

..to access 'mddev' from the inode pointer.  This is already
set up for us.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-16 12:08:10.000000000 +1100
+++ ./drivers/md/md.c	2004-01-16 12:08:45.000000000 +1100
@@ -2406,7 +2406,7 @@ static int md_ioctl(struct inode *inode,
 	 * Commands creating/starting a new array:
 	 */
 
-	mddev = inode->i_bdev->bd_inode->u.generic_ip;
+	mddev = inode->i_bdev->bd_disk->private_data;
 
 	if (!mddev) {
 		BUG();
@@ -2598,29 +2598,26 @@ abort:
 static int md_open(struct inode *inode, struct file *file)
 {
 	/*
-	 * Succeed if we can find or allocate a mddev structure.
+	 * Succeed if we can lock the mddev, which confirms that
+	 * it isn't being stopped right now.
 	 */
-	mddev_t *mddev = mddev_find(iminor(inode));
-	int err = -ENOMEM;
-
-	if (!mddev)
-		goto out;
+	mddev_t *mddev = inode->i_bdev->bd_disk->private_data;
+	int err;
 
 	if ((err = mddev_lock(mddev)))
-		goto put;
+		goto out;
 
 	err = 0;
+	mddev_get(mddev);
 	mddev_unlock(mddev);
-	inode->i_bdev->bd_inode->u.generic_ip = mddev_get(mddev);
- put:
-	mddev_put(mddev);
+
  out:
 	return err;
 }
 
 static int md_release(struct inode *inode, struct file * file)
 {
- 	mddev_t *mddev = inode->i_bdev->bd_inode->u.generic_ip;
+ 	mddev_t *mddev = inode->i_bdev->bd_disk->private_data;
 
 	if (!mddev)
 		BUG();
