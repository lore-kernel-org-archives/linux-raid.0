From: Mike Tran <mhtran@us.ibm.com>
Subject: [PATCH] md - fix return code in set_disk_faulty()
Date: 04 Nov 2003 14:04:50 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1067976289.11698.17.camel@dyn95395183>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

### Comment
	If cannot find the device, return error (ENODEV)
	Otherwise, return success (0)

--- a/linux-2.6.0-test9/drivers/md/md.c	2003-10-25 13:43:16.000000000 -0500
+++ b/linux-2.6.0-test9/drivers/md/md.c	2003-11-04 13:48:24.000000000 -0600
@@ -2354,10 +2354,10 @@
 
 	rdev = find_rdev(mddev, dev);
 	if (!rdev)
-		return 0;
+		return -ENODEV;
 
 	md_error(mddev, rdev);
-	return 1;
+	return 0;
 }
 
 static int md_ioctl(struct inode *inode, struct file *file,



Regards,
-- Mike T.

