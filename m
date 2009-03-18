From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 01/13] md/raid6: move raid6 data processing to raid6_pq.ko
Date: Wed, 18 Mar 2009 12:20:21 -0700
Message-ID: <20090318192021.20375.69678.stgit@dwillia2-linux.ch.intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Move the raid6 data processing routines into a standalone module
(raid6_pq) to prepare them to be called from async_tx wrappers and other
non-md drivers/modules.  This precludes a circular dependency of raid456
needing the async modules for data processing while those modules in
turn depend on raid456 for the base level synchronous raid6 routines.

To support this move:
1/ The exportable definitions in raid6.h move to include/linux/raid/pq.h
2/ The raid6_call, recovery calls, and table symbols are exported
3/ Extra #ifdef __KERNEL__ statements to enable the userspace raid6test to
   compile

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/Kconfig            |    4 ++++
 drivers/md/Makefile           |    4 +++-
 drivers/md/mktables.c         |   14 +++++++++++++-
 drivers/md/raid5.c            |   12 +-----------
 drivers/md/raid5.h            |    2 ++
 drivers/md/raid6algos.c       |   21 ++++++++++++++++++++-
 drivers/md/raid6altivec.uc    |    2 +-
 drivers/md/raid6int.uc        |    2 +-
 drivers/md/raid6mmx.c         |    2 +-
 drivers/md/raid6recov.c       |    8 +++++---
 drivers/md/raid6sse1.c        |    2 +-
 drivers/md/raid6sse2.c        |    2 +-
 drivers/md/raid6test/Makefile |    2 +-
 drivers/md/raid6test/test.c   |    2 +-
 include/linux/raid/pq.h       |    3 ---
 15 files changed, 55 insertions(+), 27 deletions(-)
 rename drivers/md/raid6.h => include/linux/raid/pq.h (97%)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 2281b50..449d0b9 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -121,6 +121,7 @@ config MD_RAID10
 config MD_RAID456
 	tristate "RAID-4/RAID-5/RAID-6 mode"
 	depends on BLK_DEV_MD
+	select MD_RAID6_PQ
 	select ASYNC_MEMCPY
 	select ASYNC_XOR
 	---help---
@@ -180,6 +181,9 @@ config MD_RAID5_RESHAPE
 
 	  If unsure, say Y.
 
+config MD_RAID6_PQ
+	tristate
+
 config MD_MULTIPATH
 	tristate "Multipath I/O support"
 	depends on BLK_DEV_MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 3b118da..45cc595 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -9,7 +9,8 @@ dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 		    dm-snap-persistent.o
 dm-mirror-y	+= dm-raid1.o
 md-mod-y	+= md.o bitmap.o
-raid456-y	+= raid5.o raid6algos.o raid6recov.o raid6tables.o \
+raid456-y	+= raid5.o
+raid6_pq-y	+= raid6algos.o raid6recov.o raid6tables.o \
 		   raid6int1.o raid6int2.o raid6int4.o \
 		   raid6int8.o raid6int16.o raid6int32.o \
 		   raid6altivec1.o raid6altivec2.o raid6altivec4.o \
@@ -26,6 +27,7 @@ obj-$(CONFIG_MD_LINEAR)		+= linear.o
 obj-$(CONFIG_MD_RAID0)		+= raid0.o
 obj-$(CONFIG_MD_RAID1)		+= raid1.o
 obj-$(CONFIG_MD_RAID10)		+= raid10.o
+obj-$(CONFIG_MD_RAID6_PQ)	+= raid6_pq.o
 obj-$(CONFIG_MD_RAID456)	+= raid456.o
 obj-$(CONFIG_MD_MULTIPATH)	+= multipath.o
 obj-$(CONFIG_MD_FAULTY)		+= faulty.o
diff --git a/drivers/md/mktables.c b/drivers/md/mktables.c
index b61d576..3b15008 100644
--- a/drivers/md/mktables.c
+++ b/drivers/md/mktables.c
@@ -59,7 +59,7 @@ int main(int argc, char *argv[])
 	uint8_t v;
 	uint8_t exptbl[256], invtbl[256];
 
-	printf("#include \"raid6.h\"\n");
+	printf("#include <linux/raid/pq.h>\n");
 
 	/* Compute multiplication table */
 	printf("\nconst u8  __attribute__((aligned(256)))\n"
@@ -76,6 +76,9 @@ int main(int argc, char *argv[])
 		printf("\t},\n");
 	}
 	printf("};\n");
+	printf("#ifdef __KERNEL__\n");
+	printf("EXPORT_SYMBOL(raid6_gfmul);\n");
+	printf("#endif\n");
 
 	/* Compute power-of-2 table (exponent) */
 	v = 1;
@@ -92,6 +95,9 @@ int main(int argc, char *argv[])
 		}
 	}
 	printf("};\n");
+	printf("#ifdef __KERNEL__\n");
+	printf("EXPORT_SYMBOL(raid6_gfexp);\n");
+	printf("#endif\n");
 
 	/* Compute inverse table x^-1 == x^254 */
 	printf("\nconst u8 __attribute__((aligned(256)))\n"
@@ -104,6 +110,9 @@ int main(int argc, char *argv[])
 		}
 	}
 	printf("};\n");
+	printf("#ifdef __KERNEL__\n");
+	printf("EXPORT_SYMBOL(raid6_gfinv);\n");
+	printf("#endif\n");
 
 	/* Compute inv(2^x + 1) (exponent-xor-inverse) table */
 	printf("\nconst u8 __attribute__((aligned(256)))\n"
@@ -115,6 +124,9 @@ int main(int argc, char *argv[])
 			       (j == 7) ? '\n' : ' ');
 	}
 	printf("};\n");
+	printf("#ifdef __KERNEL__\n");
+	printf("EXPORT_SYMBOL(raid6_gfexi);\n");
+	printf("#endif\n");
 
 	return 0;
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 70b50af..21626cc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -45,11 +45,11 @@
 
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
+#include <linux/raid/pq.h>
 #include <linux/async_tx.h>
 #include <linux/seq_file.h>
 #include "md.h"
 #include "raid5.h"
-#include "raid6.h"
 #include "bitmap.h"
 
 /*
@@ -94,11 +94,6 @@
 
 #define printk_rl(args...) ((void) (printk_ratelimit() && printk(args)))
 
-#if !RAID6_USE_EMPTY_ZERO_PAGE
-/* In .bss so it's zeroed */
-const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(256)));
-#endif
-
 /*
  * We maintain a biased count of active stripes in the bottom 16 bits of
  * bi_phys_segments, and a count of processed stripes in the upper 16 bits
@@ -5131,11 +5126,6 @@ static struct mdk_personality raid4_personality =
 
 static int __init raid5_init(void)
 {
-	int e;
-
-	e = raid6_select_algo();
-	if ( e )
-		return e;
 	register_md_personality(&raid6_personality);
 	register_md_personality(&raid5_personality);
 	register_md_personality(&raid4_personality);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index c172371..2934ee0 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -269,6 +269,8 @@ struct r6_state {
 #define READ_MODIFY_WRITE	2
 /* not a write method, but a compute_parity mode */
 #define	CHECK_PARITY		3
+/* Additional compute_parity mode -- updates the parity w/o LOCKING */
+#define UPDATE_PARITY		4
 
 /*
  * Stripe state
diff --git a/drivers/md/raid6algos.c b/drivers/md/raid6algos.c
index 1f6a3c8..34e57ff 100644
--- a/drivers/md/raid6algos.c
+++ b/drivers/md/raid6algos.c
@@ -16,10 +16,16 @@
  * Algorithm list and algorithm selection for RAID-6
  */
 
-#include "raid6.h"
+#include <linux/raid/pq.h>
 #ifndef __KERNEL__
 #include <sys/mman.h>
 #include <stdio.h>
+#else
+#if !RAID6_USE_EMPTY_ZERO_PAGE
+/* In .bss so it's zeroed */
+const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(256)));
+EXPORT_SYMBOL(raid6_empty_zero_page);
+#endif
 #endif
 
 struct raid6_calls raid6_call;
@@ -79,6 +85,7 @@ const struct raid6_calls * const raid6_algos[] = {
 #else
 /* Need more time to be stable in userspace */
 #define RAID6_TIME_JIFFIES_LG2	9
+#define time_before(x, y) ((x) < (y))
 #endif
 
 /* Try to pick the best algorithm */
@@ -152,3 +159,15 @@ int __init raid6_select_algo(void)
 
 	return best ? 0 : -EINVAL;
 }
+
+static void raid6_exit(void)
+{
+	do { } while (0);
+}
+
+#ifdef __KERNEL__
+EXPORT_SYMBOL_GPL(raid6_call);
+subsys_initcall(raid6_select_algo);
+module_exit(raid6_exit);
+MODULE_LICENSE("GPL");
+#endif
diff --git a/drivers/md/raid6altivec.uc b/drivers/md/raid6altivec.uc
index 2175806..699dfee 100644
--- a/drivers/md/raid6altivec.uc
+++ b/drivers/md/raid6altivec.uc
@@ -22,7 +22,7 @@
  * bracked this with preempt_disable/enable or in a lock)
  */
 
-#include "raid6.h"
+#include <linux/raid/pq.h>
 
 #ifdef CONFIG_ALTIVEC
 
diff --git a/drivers/md/raid6int.uc b/drivers/md/raid6int.uc
index 32a0bac..f9bf9cb 100644
--- a/drivers/md/raid6int.uc
+++ b/drivers/md/raid6int.uc
@@ -18,7 +18,7 @@
  * This file is postprocessed using unroll.pl
  */
 
-#include "raid6.h"
+#include <linux/raid/pq.h>
 
 /*
  * This is the C data type to use
diff --git a/drivers/md/raid6mmx.c b/drivers/md/raid6mmx.c
index 804cb50..e7f6c13 100644
--- a/drivers/md/raid6mmx.c
+++ b/drivers/md/raid6mmx.c
@@ -18,7 +18,7 @@
 
 #if defined(__i386__) && !defined(__arch_um__)
 
-#include "raid6.h"
+#include <linux/raid/pq.h>
 #include "raid6x86.h"
 
 /* Shared with raid6sse1.c */
diff --git a/drivers/md/raid6recov.c b/drivers/md/raid6recov.c
index 7a98b86..844d27d 100644
--- a/drivers/md/raid6recov.c
+++ b/drivers/md/raid6recov.c
@@ -18,7 +18,7 @@
  * the syndrome.)
  */
 
-#include "raid6.h"
+#include <linux/raid/pq.h>
 
 /* Recover two failed data blocks. */
 void raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
@@ -98,8 +98,10 @@ void raid6_datap_recov(int disks, size_t bytes, int faila, void **ptrs)
 	}
 }
 
-
-#ifndef __KERNEL__		/* Testing only */
+#ifdef __KERNEL__
+EXPORT_SYMBOL_GPL(raid6_2data_recov);
+EXPORT_SYMBOL_GPL(raid6_datap_recov);
+#else 		/* Testing only */
 
 /* Recover two failed blocks. */
 void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, void **ptrs)
diff --git a/drivers/md/raid6sse1.c b/drivers/md/raid6sse1.c
index 15c5889..b274dd5 100644
--- a/drivers/md/raid6sse1.c
+++ b/drivers/md/raid6sse1.c
@@ -23,7 +23,7 @@
 
 #if defined(__i386__) && !defined(__arch_um__)
 
-#include "raid6.h"
+#include <linux/raid/pq.h>
 #include "raid6x86.h"
 
 /* Defined in raid6mmx.c */
diff --git a/drivers/md/raid6sse2.c b/drivers/md/raid6sse2.c
index 2e92e96..6ed6c6c 100644
--- a/drivers/md/raid6sse2.c
+++ b/drivers/md/raid6sse2.c
@@ -19,7 +19,7 @@
 
 #if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
 
-#include "raid6.h"
+#include <linux/raid/pq.h>
 #include "raid6x86.h"
 
 static const struct raid6_sse_constants {
diff --git a/drivers/md/raid6test/Makefile b/drivers/md/raid6test/Makefile
index 78e0396..58ffdf4 100644
--- a/drivers/md/raid6test/Makefile
+++ b/drivers/md/raid6test/Makefile
@@ -5,7 +5,7 @@
 
 CC	 = gcc
 OPTFLAGS = -O2			# Adjust as desired
-CFLAGS	 = -I.. -g $(OPTFLAGS)
+CFLAGS	 = -I.. -I ../../../include -g $(OPTFLAGS)
 LD	 = ld
 PERL	 = perl
 AR	 = ar
diff --git a/drivers/md/raid6test/test.c b/drivers/md/raid6test/test.c
index 559cc41..7a93031 100644
--- a/drivers/md/raid6test/test.c
+++ b/drivers/md/raid6test/test.c
@@ -17,7 +17,7 @@
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
-#include "raid6.h"
+#include <linux/raid/pq.h>
 
 #define NDISKS		16	/* Including P and Q */
 
diff --git a/drivers/md/raid6.h b/include/linux/raid/pq.h
similarity index 97%
rename from drivers/md/raid6.h
rename to include/linux/raid/pq.h
index 8a9c823..a019670 100644
--- a/drivers/md/raid6.h
+++ b/include/linux/raid/pq.h
@@ -19,9 +19,6 @@
 #define RAID6_USE_EMPTY_ZERO_PAGE 0
 #include <linux/blkdev.h>
 
-/* Additional compute_parity mode -- updates the parity w/o LOCKING */
-#define UPDATE_PARITY	4
-
 /* We need a pre-zeroed page... if we don't want to use the kernel-provided
    one define it here */
 #if RAID6_USE_EMPTY_ZERO_PAGE

