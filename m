From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH] declare raid6_intx32 to fix ia64 build
Date: Thu, 22 Jan 2004 16:00:53 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401221600.53591.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
Cc: mingo@redhat.com, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

This patch against 2.6.2-rc1 fixes a build failure on ia64
and fixes a trivial comment error.

===== drivers/md/raid6algos.c 1.1 vs edited =====
--- 1.1/drivers/md/raid6algos.c	Tue Jan 20 18:50:57 2004
+++ edited/drivers/md/raid6algos.c	Wed Jan 21 17:11:58 2004
@@ -29,6 +29,7 @@
 extern const struct raid6_calls raid6_intx4;
 extern const struct raid6_calls raid6_intx8;
 extern const struct raid6_calls raid6_intx16;
+extern const struct raid6_calls raid6_intx32;
 extern const struct raid6_calls raid6_mmxx1;
 extern const struct raid6_calls raid6_mmxx2;
 extern const struct raid6_calls raid6_sse1x1;
===== drivers/md/raid6int.uc 1.1 vs edited =====
--- 1.1/drivers/md/raid6int.uc	Tue Jan 20 18:50:57 2004
+++ edited/drivers/md/raid6int.uc	Thu Jan 22 15:58:02 2004
@@ -15,7 +15,7 @@
  *
  * $#-way unrolled portable integer math RAID-6 instruction set
  *
- * This file is postprocessed using unroller.pl
+ * This file is postprocessed using unroll.pl
  */
 
 #include "raid6.h"

