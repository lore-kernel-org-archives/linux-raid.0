From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 2 of 2] RAID Kconfig cleanups, remove experimental tag from RAID-6
Date: Thu, 10 Feb 2005 09:22:47 +1100
Message-ID: <E1Cz0ER-0000Qa-Uh@notabene.cse.unsw.edu.au>
References: <20050210091909.1612.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This patch removes the experimental tag from RAID-6 (unfortunately the 
damage is already done...:-|) and cleans up a few more things in the 
Kconfig file.

Signed-Off-By: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/Kconfig |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff ./drivers/md/Kconfig~current~ ./drivers/md/Kconfig
--- ./drivers/md/Kconfig~current~	2005-02-09 14:32:06.000000000 +1100
+++ ./drivers/md/Kconfig	2005-02-09 14:32:06.000000000 +1100
@@ -93,7 +93,7 @@ config MD_RAID10
 	  mirroring (RAID-1) with easier configuration and more flexable
 	  layout.
 	  Unlike RAID-0, but like RAID-1, RAID-10 requires all devices to
-	  be the same size (or atleast, only as much as the smallest device
+	  be the same size (or at least, only as much as the smallest device
 	  will be used).
 	  RAID-10 provides a variety of layouts that provide different levels
 	  of redundancy and performance.
@@ -102,6 +102,7 @@ config MD_RAID10
 
 	  ftp://ftp.kernel.org/pub/linux/utils/raid/mdadm/
 
+	  If unsure, say Y.
 
 config MD_RAID5
 	tristate "RAID-4/RAID-5 mode"
@@ -120,20 +121,16 @@ config MD_RAID5
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
@@ -150,7 +147,7 @@ config MD_RAID6
 	  this code as a module, choose M here: the module will be
 	  called raid6.
 
-	  If unsure, say N.
+	  If unsure, say Y.
 
 config MD_MULTIPATH
 	tristate "Multipath I/O support"
