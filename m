From: Mike Tran <mhtran@us.ibm.com>
Subject: [PATCH] Version 1 super block
Date: Sat, 15 Jan 2005 20:50:22 -0600
Message-ID: <41E9D66E.9080100@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070809030405040005070307"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070809030405040005070307
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hello Neil,

I found 2 problems in the kernel MD driver:
1) if disk index 0 is used, counting of max_dev is wrong
2) missing checksum calculation

Please consider the attached patch for 2.6.10 kernel.
--
Thanks,
Mike T.


--------------070809030405040005070307
Content-Type: text/plain;
 name="md-2.6.10.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md-2.6.10.patch"

--- a/linux-2.6.10/drivers/md/md.c	2005-01-15 07:52:14.000000000 -0600
+++ b/linux-2.6.10/drivers/md/md.c	2005-01-15 07:52:14.000000000 -0600
@@ -939,9 +939,13 @@
 		sb->resync_offset = cpu_to_le64(0);
 
 	max_dev = 0;
-	ITERATE_RDEV(mddev,rdev2,tmp)
+	i = 0;
+	ITERATE_RDEV(mddev,rdev2,tmp) {
+		i++;
 		if (rdev2->desc_nr > max_dev)
 			max_dev = rdev2->desc_nr;
+	}
+	max_dev = max(max_dev, i);
 	
 	sb->max_dev = cpu_to_le32(max_dev);
 	for (i=0; i<max_dev;i++)
@@ -958,6 +962,7 @@
 	}
 
 	sb->recovery_offset = cpu_to_le64(0); /* not supported yet */
+	sb->sb_csum = calc_sb_1_csum(sb);
 }
 
 

--------------070809030405040005070307--
