From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 10 - fix return code in set_disk_faulty()
Date: Fri, 16 Jan 2004 12:19:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AhIe9-0002Tv-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


From: Mike Tran <mhtran@us.ibm.com>

If cannot find the device, return error (ENODEV)
Otherwise, return success (0)

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-16 11:58:51.000000000 +1100
+++ ./drivers/md/md.c	2004-01-16 11:59:05.000000000 +1100
@@ -2354,10 +2354,10 @@ static int set_disk_faulty(mddev_t *mdde
 
 	rdev = find_rdev(mddev, dev);
 	if (!rdev)
-		return 0;
+		return -ENODEV;
 
 	md_error(mddev, rdev);
-	return 1;
+	return 0;
 }
 
 static int md_ioctl(struct inode *inode, struct file *file,
