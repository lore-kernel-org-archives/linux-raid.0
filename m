From: Mark Bellon <mbellon@mvista.com>
Subject: Re: 2.4.25 MD RAID 1 driver - syncing hung due to I/O error
Date: Wed, 24 Mar 2004 09:09:28 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4061B2B8.8030202@mvista.com>
References: <4060C4DD.2070506@mvista.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050802080304020007020201"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4060C4DD.2070506@mvista.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.
--------------050802080304020007020201
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

One of my disks has a bad block and hung while syncing (as the source of 
the sync) when it was read. A patch is attached for the fix.

The sync_request_done function is called after each sync I/O request 
completes regardless of the error outcome.
See end_sync_write and the "!sum_bhs" case a few lines above the patch 
location for references. If sync_request_done is not called the 
accounting is not updated and sooner or later things will hang. The 
R1BH_Uptodate not set case (read I/O error) does not do this and the 
problem occurs.

mark

--------------050802080304020007020201
Content-Type: text/plain;
 name="raid1-patch-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raid1-patch-2"

--- raid1.c.orig	2004-03-23 17:18:29.000000000 -0700
+++ raid1.c	2004-03-23 17:18:48.000000000 -0700
@@ -1251,6 +1251,7 @@
 				 */
 
 				printk (IO_ERROR, partition_name(bh->b_dev), bh->b_blocknr);
+				sync_request_done(bh->b_blocknr, conf);
 				md_done_sync(mddev, bh->b_size>>9, 0);
 				raid1_free_buf(r1_bh);
 			}

--------------050802080304020007020201--

