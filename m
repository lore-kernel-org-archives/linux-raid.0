From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 16 of 22 - Next small step to improved mddev management.
Date: Wed, 19 Jun 2002 10:53:46 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54810.345638.115570@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



md_ioctl doesn't need to mddev_find, as the mddev must
be in the bd_inode->u.generic_ip.  This means we don't need
to mddev_put either.



 ----------- Diffstat output ------------
 ./drivers/md/md.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

--- ./drivers/md/md.c	2002/06/18 04:53:10	1.15
+++ ./drivers/md/md.c	2002/06/18 04:56:12	1.16
@@ -2490,10 +2490,10 @@
 	 * Commands creating/starting a new array:
 	 */
 
-	mddev = mddev_find(minor);
+	mddev = inode->i_bdev->bd_inode->u.generic_ip;
 
 	if (!mddev) {
-		err = -ENOMEM;
+		BUG();
 		goto abort;
 	}
 
@@ -2679,7 +2679,6 @@
 done_unlock:
 abort_unlock:
 	unlock_mddev(mddev);
-	mddev_put(mddev);
 
 	return err;
 done:
