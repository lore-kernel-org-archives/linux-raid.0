From: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] RAID Kconfig cleanups, remove experimental tag from RAID-6
Date: Tue, 08 Feb 2005 14:10:25 -0800
Message-ID: <420938D1.10904@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080900080408040905030604"
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080900080408040905030604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch removes the experimental tag from RAID-6 (unfortunately the 
damage is already done...:-|) and cleans up a few more things in the 
Kconfig file.

Signed-Off-By: H. Peter Anvin <hpa@zytor.com>


--------------080900080408040905030604
Content-Type: text/x-patch;
 name="raid-kconfig.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raid-kconfig.diff"

Index: linux-2.5/drivers/md/Kconfig
===================================================================
RCS file: /home/hpa/kernel/bkcvs/linux-2.5/drivers/md/Kconfig,v
retrieving revision 1.17
diff -u -r1.17 Kconfig
--- linux-2.5/drivers/md/Kconfig	15 Jan 2005 23:46:55 -0000	1.17
+++ linux-2.5/drivers/md/Kconfig	8 Feb 2005 22:02:42 -0000
@@ -93,7 +93,7 @@
 	  mirroring (RAID-1) with easier configuration and more flexable
 	  layout.
 	  Unlike RAID-0, but like RAID-1, RAID-10 requires all devices to
-	  be the same size (or atleast, only as much as the smallest device
+	  be the same size (or at least, only as much as the smallest device
 	  will be used).
 	  RAID-10 provides a variety of layouts that provide different levels
 	  of redundancy and performance.
@@ -102,6 +102,7 @@
 
 	  ftp://ftp.kernel.org/pub/linux/utils/raid/mdadm/
 
+	  If unsure, say Y.
 
 config MD_RAID5
 	tristate "RAID-4/RAID-5 mode"
@@ -120,20 +121,16 @@
 	  <http://www.tldp.org/docs.html#howto>. There you will also
 	  learn where to get the supporting user space utilities raidtools.
 
-	  If you want to use such a RAID-4/RAID-5 set, say Y.  To compile
-	  this code as a module, choose M here: the module will be called raid5.
+	  If you want to use such a RAID-4/RAID-5 set, say Y.  To
+	  compile this code as a module, choose M here: the module
+	  will be called raid5.
 
 	  If unsure, say Y.
 
 config MD_RAID6
-	tristate "RAID-6 mode (EXPERIMENTAL)"
-	depends on BLK_DEV_MD && EXPERIMENTAL
+	tristate "RAID-6 mode"
+	depends on BLK_DEV_MD
 	---help---
-	  WARNING: RAID-6 is currently highly experimental.  If you
-	  use it, there is no guarantee whatsoever that it won't
-	  destroy your data, eat your disk drives, insult your mother,
-	  or re-appoint George W. Bush.
-
 	  A RAID-6 set of N drives with a capacity of C MB per drive
 	  provides the capacity of C * (N - 2) MB, and protects
 	  against a failure of any two drives. For a given sector
@@ -150,7 +147,7 @@
 	  this code as a module, choose M here: the module will be
 	  called raid6.
 
-	  If unsure, say N.
+	  If unsure, say Y.
 
 config MD_MULTIPATH
 	tristate "Multipath I/O support"

--------------080900080408040905030604--
