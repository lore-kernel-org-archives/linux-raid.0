From: Mark Bellon <mbellon@mvista.com>
Subject: 2.4.25 MD RAID 1 driver - memory leak?
Date: Tue, 23 Mar 2004 16:14:37 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4060C4DD.2070506@mvista.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080507040504030800040900"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.
--------------080507040504030800040900
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

If I'm reading things correctly I believe there is a memory leak in the 
RAID 1 driver. A patch is attached for the fix.

The end_sync_read function forwards the read operation (r1_bh) that 
completed by the raid1_reschedule_retry function. The r1_bh->cmd value 
is SPECIAL. If the R1BH_Uptodate bit is not set a message is printed and 
md_done_sync is called - but raid1_free_buf is not called. Look a few 
lines above at the "!sum_bhs" case for comparison.

mark


--------------080507040504030800040900
Content-Type: text/plain;
 name="raid1-patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raid1-patch"

--- raid1.c.orig	2004-03-23 16:09:48.000000000 -0700
+++ raid1.c	2004-03-23 16:09:18.000000000 -0700
@@ -1252,6 +1252,7 @@
 
 				printk (IO_ERROR, partition_name(bh->b_dev), bh->b_blocknr);
 				md_done_sync(mddev, bh->b_size>>9, 0);
+				raid1_free_buf(r1_bh);
 			}
 
 			break;

--------------080507040504030800040900--

