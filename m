From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] Don't include networking in md drivers
Date: Fri, 6 Jun 2003 17:40:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030606164017.GC28581@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linus Torvalds <torvalds@transmeta.com>, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Including <net/checksum.h> drags in 60+ network include files we don't
need.  Change this to <asm/checksum.h> and fix up associated breakage.

Index: drivers/md/linear.c
===================================================================
RCS file: /var/cvs/linux-2.5/drivers/md/linear.c,v
retrieving revision 1.12
diff -u -p -r1.12 linear.c
--- drivers/md/linear.c	8 Apr 2003 15:19:10 -0000	1.12
+++ drivers/md/linear.c	6 Jun 2003 16:21:45 -0000
@@ -21,6 +21,7 @@
 #include <linux/raid/md.h>
 #include <linux/slab.h>
 #include <linux/bio.h>
+#include <linux/init.h>
 #include <linux/raid/linear.h>
 
 #define MAJOR_NR MD_MAJOR
Index: drivers/md/raid0.c
===================================================================
RCS file: /var/cvs/linux-2.5/drivers/md/raid0.c,v
retrieving revision 1.10
diff -u -p -r1.10 raid0.c
--- drivers/md/raid0.c	8 Apr 2003 15:19:11 -0000	1.10
+++ drivers/md/raid0.c	6 Jun 2003 16:22:17 -0000
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/raid/raid0.h>
 #include <linux/bio.h>
+#include <linux/init.h>
 
 #define MAJOR_NR MD_MAJOR
 #define MD_DRIVER
Index: drivers/md/raid1.c
===================================================================
RCS file: /var/cvs/linux-2.5/drivers/md/raid1.c,v
retrieving revision 1.14
diff -u -p -r1.14 raid1.c
--- drivers/md/raid1.c	5 May 2003 17:07:00 -0000	1.14
+++ drivers/md/raid1.c	6 Jun 2003 16:22:32 -0000
@@ -24,6 +24,7 @@
 
 #include <linux/raid/raid1.h>
 #include <linux/bio.h>
+#include <linux/init.h>
 
 #define MAJOR_NR MD_MAJOR
 #define MD_DRIVER
Index: drivers/md/raid5.c
===================================================================
RCS file: /var/cvs/linux-2.5/drivers/md/raid5.c,v
retrieving revision 1.11
diff -u -p -r1.11 raid5.c
--- drivers/md/raid5.c	8 Apr 2003 15:19:11 -0000	1.11
+++ drivers/md/raid5.c	6 Jun 2003 16:22:40 -0000
@@ -22,6 +22,7 @@
 #include <linux/raid/raid5.h>
 #include <linux/bio.h>
 #include <linux/highmem.h>
+#include <linux/init.h>
 #include <asm/bitops.h>
 #include <asm/atomic.h>
 
Index: drivers/md/xor.c
===================================================================
RCS file: /var/cvs/linux-2.5/drivers/md/xor.c,v
retrieving revision 1.3
diff -u -p -r1.3 xor.c
--- drivers/md/xor.c	30 Aug 2002 19:59:37 -0000	1.3
+++ drivers/md/xor.c	6 Jun 2003 16:26:10 -0000
@@ -18,6 +18,7 @@
 
 #define BH_TRACE 0
 #include <linux/module.h>
+#include <linux/init.h>
 #include <linux/raid/md.h>
 #include <linux/raid/xor.h>
 #include <asm/xor.h>
Index: include/asm-alpha/checksum.h
===================================================================
RCS file: /var/cvs/linux-2.5/include/asm-alpha/checksum.h,v
retrieving revision 1.3
diff -u -p -r1.3 checksum.h
--- include/asm-alpha/checksum.h	21 Oct 2002 03:45:59 -0000	1.3
+++ include/asm-alpha/checksum.h	6 Jun 2003 16:32:40 -0000
@@ -1,6 +1,7 @@
 #ifndef _ALPHA_CHECKSUM_H
 #define _ALPHA_CHECKSUM_H
 
+#include <linux/in6.h>
 
 /*
  *	This is a version of ip_compute_csum() optimized for IP headers,
Index: include/asm-arm/checksum.h
===================================================================
RCS file: /var/cvs/linux-2.5/include/asm-arm/checksum.h,v
retrieving revision 1.3
diff -u -p -r1.3 checksum.h
--- include/asm-arm/checksum.h	21 Oct 2002 03:45:59 -0000	1.3
+++ include/asm-arm/checksum.h	6 Jun 2003 16:32:53 -0000
@@ -9,6 +9,8 @@
 #ifndef __ASM_ARM_CHECKSUM_H
 #define __ASM_ARM_CHECKSUM_H
 
+#include <linux/in6.h>
+
 /*
  * computes the checksum of a memory block at buff, length len,
  * and adds in "sum" (32-bit)
Index: include/asm-m68k/checksum.h
===================================================================
RCS file: /var/cvs/linux-2.5/include/asm-m68k/checksum.h,v
retrieving revision 1.4
diff -u -p -r1.4 checksum.h
--- include/asm-m68k/checksum.h	5 Nov 2002 18:10:50 -0000	1.4
+++ include/asm-m68k/checksum.h	6 Jun 2003 16:33:29 -0000
@@ -1,6 +1,8 @@
 #ifndef _M68K_CHECKSUM_H
 #define _M68K_CHECKSUM_H
 
+#include <linux/in6.h>
+
 /*
  * computes the checksum of a memory block at buff, length len,
  * and adds in "sum" (32-bit)
Index: include/asm-m68knommu/checksum.h
===================================================================
RCS file: /var/cvs/linux-2.5/include/asm-m68knommu/checksum.h,v
retrieving revision 1.2
diff -u -p -r1.2 checksum.h
--- include/asm-m68knommu/checksum.h	5 Nov 2002 18:10:51 -0000	1.2
+++ include/asm-m68knommu/checksum.h	6 Jun 2003 16:33:36 -0000
@@ -1,6 +1,8 @@
 #ifndef _M68K_CHECKSUM_H
 #define _M68K_CHECKSUM_H
 
+#include <linux/in6.h>
+
 /*
  * computes the checksum of a memory block at buff, length len,
  * and adds in "sum" (32-bit)
Index: include/asm-mips/checksum.h
===================================================================
RCS file: /var/cvs/linux-2.5/include/asm-mips/checksum.h,v
retrieving revision 1.3
diff -u -p -r1.3 checksum.h
--- include/asm-mips/checksum.h	21 Oct 2002 03:46:02 -0000	1.3
+++ include/asm-mips/checksum.h	6 Jun 2003 16:33:44 -0000
@@ -8,6 +8,7 @@
 #ifndef _ASM_CHECKSUM_H
 #define _ASM_CHECKSUM_H
 
+#include <linux/in6.h>
 #include <asm/uaccess.h>
 
 /*
Index: include/asm-mips64/checksum.h
===================================================================
RCS file: /var/cvs/linux-2.5/include/asm-mips64/checksum.h,v
retrieving revision 1.3
diff -u -p -r1.3 checksum.h
--- include/asm-mips64/checksum.h	21 Oct 2002 03:46:02 -0000	1.3
+++ include/asm-mips64/checksum.h	6 Jun 2003 16:33:50 -0000
@@ -10,6 +10,7 @@
 #ifndef _ASM_CHECKSUM_H
 #define _ASM_CHECKSUM_H
 
+#include <linux/in6.h>
 #include <asm/uaccess.h>
 
 /*
Index: include/asm-parisc/checksum.h
===================================================================
RCS file: /var/cvs/linux-2.5/include/asm-parisc/checksum.h,v
retrieving revision 1.6
diff -u -p -r1.6 checksum.h
--- include/asm-parisc/checksum.h	6 Dec 2002 06:51:05 -0000	1.6
+++ include/asm-parisc/checksum.h	6 Jun 2003 16:20:57 -0000
@@ -1,6 +1,8 @@
 #ifndef _PARISC_CHECKSUM_H
 #define _PARISC_CHECKSUM_H
 
+#include <linux/in6.h>
+
 /*
  * computes the checksum of a memory block at buff, length len,
  * and adds in "sum" (32-bit)
Index: include/asm-sh/checksum.h
===================================================================
RCS file: /var/cvs/linux-2.5/include/asm-sh/checksum.h,v
retrieving revision 1.3
diff -u -p -r1.3 checksum.h
--- include/asm-sh/checksum.h	21 Oct 2002 03:46:06 -0000	1.3
+++ include/asm-sh/checksum.h	6 Jun 2003 16:34:11 -0000
@@ -10,6 +10,7 @@
  */
 
 #include <linux/config.h>
+#include <linux/in6.h>
 
 /*
  * computes the checksum of a memory block at buff, length len,
Index: include/linux/raid/md.h
===================================================================
RCS file: /var/cvs/linux-2.5/include/linux/raid/md.h,v
retrieving revision 1.9
diff -u -p -r1.9 md.h
--- include/linux/raid/md.h	27 May 2003 17:29:13 -0000	1.9
+++ include/linux/raid/md.h	6 Jun 2003 16:20:20 -0000
@@ -30,7 +30,7 @@
 #include <linux/seq_file.h>
 #include <linux/smp_lock.h>
 #include <linux/delay.h>
-#include <net/checksum.h>
+#include <asm/checksum.h>
 #include <linux/random.h>
 #include <linux/kernel_stat.h>
 #include <asm/io.h>

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
