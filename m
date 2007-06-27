From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 03/19] xor: make 'xor_blocks' a library routine for
	use with async_tx
Date: Tue, 26 Jun 2007 18:50:50 -0700
Message-ID: <20070627015049.18962.54083.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, christopher.leech@intel.com, shannon.nelson@intel.com, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

The async_tx api tries to use a dma engine for an operation, but will fall
back to an optimized software routine otherwise.  Xor support is
implemented using the raid5 xor routines.  For organizational purposes this
routine is moved to a common area.

The following fixes are also made:
* rename xor_block => xor_blocks, suggested by Adrian Bunk
* ensure that xor.o initializes before md.o in the built-in case
* checkpatch.pl fixes
* mark calibrate_xor_blocks __init, Adrian Bunk

Cc: Adrian Bunk <bunk@stusta.de>
Cc: NeilBrown <neilb@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/Kconfig           |    6 ++
 crypto/Makefile          |    6 ++
 crypto/xor.c             |  156 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/Kconfig       |    1 
 drivers/md/Makefile      |    4 +
 drivers/md/md.c          |    2 -
 drivers/md/raid5.c       |   10 +--
 drivers/md/xor.c         |  154 ---------------------------------------------
 include/linux/raid/xor.h |    2 -
 9 files changed, 178 insertions(+), 163 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4ca0ab3..b749a1a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1,4 +1,10 @@
 #
+# Generic algorithms support
+#
+config XOR_BLOCKS
+	tristate
+
+#
 # Cryptographic API Configuration
 #
 
diff --git a/crypto/Makefile b/crypto/Makefile
index cce46a1..68e934b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -50,3 +50,9 @@ obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
+
+#
+# generic algorithms and the async_tx api
+#
+obj-$(CONFIG_XOR_BLOCKS) += xor.o
+
diff --git a/crypto/xor.c b/crypto/xor.c
new file mode 100644
index 0000000..8281ac5
--- /dev/null
+++ b/crypto/xor.c
@@ -0,0 +1,156 @@
+/*
+ * xor.c : Multiple Devices driver for Linux
+ *
+ * Copyright (C) 1996, 1997, 1998, 1999, 2000,
+ * Ingo Molnar, Matti Aarnio, Jakub Jelinek, Richard Henderson.
+ *
+ * Dispatch optimized RAID-5 checksumming functions.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * (for example /usr/src/linux/COPYING); if not, write to the Free
+ * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#define BH_TRACE 0
+#include <linux/module.h>
+#include <linux/raid/md.h>
+#include <linux/raid/xor.h>
+#include <asm/xor.h>
+
+/* The xor routines to use.  */
+static struct xor_block_template *active_template;
+
+void
+xor_blocks(unsigned int count, unsigned int bytes, void **ptr)
+{
+	unsigned long *p0, *p1, *p2, *p3, *p4;
+
+	p0 = (unsigned long *) ptr[0];
+	p1 = (unsigned long *) ptr[1];
+	if (count == 2) {
+		active_template->do_2(bytes, p0, p1);
+		return;
+	}
+
+	p2 = (unsigned long *) ptr[2];
+	if (count == 3) {
+		active_template->do_3(bytes, p0, p1, p2);
+		return;
+	}
+
+	p3 = (unsigned long *) ptr[3];
+	if (count == 4) {
+		active_template->do_4(bytes, p0, p1, p2, p3);
+		return;
+	}
+
+	p4 = (unsigned long *) ptr[4];
+	active_template->do_5(bytes, p0, p1, p2, p3, p4);
+}
+EXPORT_SYMBOL(xor_blocks);
+
+/* Set of all registered templates.  */
+static struct xor_block_template *template_list;
+
+#define BENCH_SIZE (PAGE_SIZE)
+
+static void
+do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
+{
+	int speed;
+	unsigned long now;
+	int i, count, max;
+
+	tmpl->next = template_list;
+	template_list = tmpl;
+
+	/*
+	 * Count the number of XORs done during a whole jiffy, and use
+	 * this to calculate the speed of checksumming.  We use a 2-page
+	 * allocation to have guaranteed color L1-cache layout.
+	 */
+	max = 0;
+	for (i = 0; i < 5; i++) {
+		now = jiffies;
+		count = 0;
+		while (jiffies == now) {
+			mb(); /* prevent loop optimzation */
+			tmpl->do_2(BENCH_SIZE, b1, b2);
+			mb();
+			count++;
+			mb();
+		}
+		if (count > max)
+			max = count;
+	}
+
+	speed = max * (HZ * BENCH_SIZE / 1024);
+	tmpl->speed = speed;
+
+	printk(KERN_INFO "   %-10s: %5d.%03d MB/sec\n", tmpl->name,
+	       speed / 1000, speed % 1000);
+}
+
+static int __init
+calibrate_xor_blocks(void)
+{
+	void *b1, *b2;
+	struct xor_block_template *f, *fastest;
+
+	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
+	if (!b1) {
+		printk(KERN_WARNING "xor: Yikes!  No memory available.\n");
+		return -ENOMEM;
+	}
+	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
+
+	/*
+	 * If this arch/cpu has a short-circuited selection, don't loop through
+	 * all the possible functions, just test the best one
+	 */
+
+	fastest = NULL;
+
+#ifdef XOR_SELECT_TEMPLATE
+		fastest = XOR_SELECT_TEMPLATE(fastest);
+#endif
+
+#define xor_speed(templ)	do_xor_speed((templ), b1, b2)
+
+	if (fastest) {
+		printk(KERN_INFO "xor: automatically using best "
+			"checksumming function: %s\n",
+			fastest->name);
+		xor_speed(fastest);
+	} else {
+		printk(KERN_INFO "xor: measuring checksumming speed\n");
+		XOR_TRY_TEMPLATES;
+		fastest = template_list;
+		for (f = fastest; f; f = f->next)
+			if (f->speed > fastest->speed)
+				fastest = f;
+	}
+
+	printk(KERN_INFO "xor: using function: %s (%d.%03d MB/sec)\n",
+	       fastest->name, fastest->speed / 1000, fastest->speed % 1000);
+
+#undef xor_speed
+
+	free_pages((unsigned long)b1, 2);
+
+	active_template = fastest;
+	return 0;
+}
+
+static __exit void xor_exit(void) { }
+
+MODULE_LICENSE("GPL");
+
+/* when built-in xor.o must initialize before drivers/md/md.o */
+core_initcall(calibrate_xor_blocks);
+module_exit(xor_exit);
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 7df934d..24d93d0 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -109,6 +109,7 @@ config MD_RAID10
 config MD_RAID456
 	tristate "RAID-4/RAID-5/RAID-6 mode"
 	depends on BLK_DEV_MD
+	select XOR_BLOCKS
 	---help---
 	  A RAID-5 set of N drives with a capacity of C MB per drive provides
 	  the capacity of C * (N - 1) MB, and protects against a failure
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 3875408..71eb45f 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -17,7 +17,7 @@ raid456-objs	:= raid5.o raid6algos.o raid6recov.o raid6tables.o \
 hostprogs-y	:= mktables
 
 # Note: link order is important.  All raid personalities
-# and xor.o must come before md.o, as they each initialise 
+# and must come before md.o, as they each initialise 
 # themselves, and md.o may use the personalities when it 
 # auto-initialised.
 
@@ -25,7 +25,7 @@ obj-$(CONFIG_MD_LINEAR)		+= linear.o
 obj-$(CONFIG_MD_RAID0)		+= raid0.o
 obj-$(CONFIG_MD_RAID1)		+= raid1.o
 obj-$(CONFIG_MD_RAID10)		+= raid10.o
-obj-$(CONFIG_MD_RAID456)	+= raid456.o xor.o
+obj-$(CONFIG_MD_RAID456)	+= raid456.o
 obj-$(CONFIG_MD_MULTIPATH)	+= multipath.o
 obj-$(CONFIG_MD_FAULTY)		+= faulty.o
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1c54f3c..33beaa7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5814,7 +5814,7 @@ static __exit void md_exit(void)
 	}
 }
 
-module_init(md_init)
+subsys_initcall(md_init);
 module_exit(md_exit)
 
 static int get_ro(char *buffer, struct kernel_param *kp)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 061375e..5adbe0b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -918,7 +918,7 @@ static void copy_data(int frombio, struct bio *bio,
 
 #define check_xor() 	do { 						\
 			   if (count == MAX_XOR_BLOCKS) {		\
-				xor_block(count, STRIPE_SIZE, ptr);	\
+				xor_blocks(count, STRIPE_SIZE, ptr);	\
 				count = 1;				\
 			   }						\
 			} while(0)
@@ -949,7 +949,7 @@ static void compute_block(struct stripe_head *sh, int dd_idx)
 		check_xor();
 	}
 	if (count != 1)
-		xor_block(count, STRIPE_SIZE, ptr);
+		xor_blocks(count, STRIPE_SIZE, ptr);
 	set_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
 }
 
@@ -1004,7 +1004,7 @@ static void compute_parity5(struct stripe_head *sh, int method)
 		break;
 	}
 	if (count>1) {
-		xor_block(count, STRIPE_SIZE, ptr);
+		xor_blocks(count, STRIPE_SIZE, ptr);
 		count = 1;
 	}
 	
@@ -1038,7 +1038,7 @@ static void compute_parity5(struct stripe_head *sh, int method)
 			}
 	}
 	if (count != 1)
-		xor_block(count, STRIPE_SIZE, ptr);
+		xor_blocks(count, STRIPE_SIZE, ptr);
 	
 	if (method != CHECK_PARITY) {
 		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
@@ -1160,7 +1160,7 @@ static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 			check_xor();
 		}
 		if (count != 1)
-			xor_block(count, STRIPE_SIZE, ptr);
+			xor_blocks(count, STRIPE_SIZE, ptr);
 		if (!nozero) set_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
 		else clear_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
 	}
diff --git a/drivers/md/xor.c b/drivers/md/xor.c
deleted file mode 100644
index 324897c..0000000
--- a/drivers/md/xor.c
+++ /dev/null
@@ -1,154 +0,0 @@
-/*
- * xor.c : Multiple Devices driver for Linux
- *
- * Copyright (C) 1996, 1997, 1998, 1999, 2000,
- * Ingo Molnar, Matti Aarnio, Jakub Jelinek, Richard Henderson.
- *
- * Dispatch optimized RAID-5 checksumming functions.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * You should have received a copy of the GNU General Public License
- * (for example /usr/src/linux/COPYING); if not, write to the Free
- * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#define BH_TRACE 0
-#include <linux/module.h>
-#include <linux/raid/md.h>
-#include <linux/raid/xor.h>
-#include <asm/xor.h>
-
-/* The xor routines to use.  */
-static struct xor_block_template *active_template;
-
-void
-xor_block(unsigned int count, unsigned int bytes, void **ptr)
-{
-	unsigned long *p0, *p1, *p2, *p3, *p4;
-
-	p0 = (unsigned long *) ptr[0];
-	p1 = (unsigned long *) ptr[1];
-	if (count == 2) {
-		active_template->do_2(bytes, p0, p1);
-		return;
-	}
-
-	p2 = (unsigned long *) ptr[2];
-	if (count == 3) {
-		active_template->do_3(bytes, p0, p1, p2);
-		return;
-	}
-
-	p3 = (unsigned long *) ptr[3];
-	if (count == 4) {
-		active_template->do_4(bytes, p0, p1, p2, p3);
-		return;
-	}
-
-	p4 = (unsigned long *) ptr[4];
-	active_template->do_5(bytes, p0, p1, p2, p3, p4);
-}
-
-/* Set of all registered templates.  */
-static struct xor_block_template *template_list;
-
-#define BENCH_SIZE (PAGE_SIZE)
-
-static void
-do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
-{
-	int speed;
-	unsigned long now;
-	int i, count, max;
-
-	tmpl->next = template_list;
-	template_list = tmpl;
-
-	/*
-	 * Count the number of XORs done during a whole jiffy, and use
-	 * this to calculate the speed of checksumming.  We use a 2-page
-	 * allocation to have guaranteed color L1-cache layout.
-	 */
-	max = 0;
-	for (i = 0; i < 5; i++) {
-		now = jiffies;
-		count = 0;
-		while (jiffies == now) {
-			mb();
-			tmpl->do_2(BENCH_SIZE, b1, b2);
-			mb();
-			count++;
-			mb();
-		}
-		if (count > max)
-			max = count;
-	}
-
-	speed = max * (HZ * BENCH_SIZE / 1024);
-	tmpl->speed = speed;
-
-	printk("   %-10s: %5d.%03d MB/sec\n", tmpl->name,
-	       speed / 1000, speed % 1000);
-}
-
-static int
-calibrate_xor_block(void)
-{
-	void *b1, *b2;
-	struct xor_block_template *f, *fastest;
-
-	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
-	if (! b1) {
-		printk("raid5: Yikes!  No memory available.\n");
-		return -ENOMEM;
-	}
-	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
-
-	/*
-	 * If this arch/cpu has a short-circuited selection, don't loop through all
-	 * the possible functions, just test the best one
-	 */
-
-	fastest = NULL;
-
-#ifdef XOR_SELECT_TEMPLATE
-		fastest = XOR_SELECT_TEMPLATE(fastest);
-#endif
-
-#define xor_speed(templ)	do_xor_speed((templ), b1, b2)
-
-	if (fastest) {
-		printk(KERN_INFO "raid5: automatically using best checksumming function: %s\n",
-			fastest->name);
-		xor_speed(fastest);
-	} else {
-		printk(KERN_INFO "raid5: measuring checksumming speed\n");
-		XOR_TRY_TEMPLATES;
-		fastest = template_list;
-		for (f = fastest; f; f = f->next)
-			if (f->speed > fastest->speed)
-				fastest = f;
-	}
-
-	printk("raid5: using function: %s (%d.%03d MB/sec)\n",
-	       fastest->name, fastest->speed / 1000, fastest->speed % 1000);
-
-#undef xor_speed
-
-	free_pages((unsigned long)b1, 2);
-
-	active_template = fastest;
-	return 0;
-}
-
-static __exit void xor_exit(void) { }
-
-EXPORT_SYMBOL(xor_block);
-MODULE_LICENSE("GPL");
-
-module_init(calibrate_xor_block);
-module_exit(xor_exit);
diff --git a/include/linux/raid/xor.h b/include/linux/raid/xor.h
index f0d67cb..7d6c20b 100644
--- a/include/linux/raid/xor.h
+++ b/include/linux/raid/xor.h
@@ -5,7 +5,7 @@
 
 #define MAX_XOR_BLOCKS 5
 
-extern void xor_block(unsigned int count, unsigned int bytes, void **ptr);
+extern void xor_blocks(unsigned int count, unsigned int bytes, void **ptr);
 
 struct xor_block_template {
         struct xor_block_template *next;
