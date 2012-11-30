From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: [PATCH 2/2] lib/raid6: build proper files on corresponding arch
Date: Fri, 30 Nov 2012 13:10:40 -0800
Message-ID: <1354309840-9360-2-git-send-email-james.t.kukunas@linux.intel.com>
References: <1354309840-9360-1-git-send-email-james.t.kukunas@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1354309840-9360-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux Raid <linux-raid@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-raid.ids

From: Yuanhan Liu <yuanhan.liu@linux.intel.com>

sse and avx2 stuff only exist on x86 arch, and we don't need to build
altivec on x86. And we can do that at lib/raid6/Makefile.

Proposed-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 lib/raid6/Makefile      |  9 ++++++---
 lib/raid6/altivec.uc    |  3 ---
 lib/raid6/mmx.c         |  2 +-
 lib/raid6/recov_avx2.c  |  4 ----
 lib/raid6/recov_ssse3.c |  4 ----
 lib/raid6/sse1.c        |  2 +-
 lib/raid6/sse2.c        |  8 ++------
 lib/raid6/test/Makefile | 23 ++++++++++++++++++-----
 8 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index 3430711..9f7c184 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -1,8 +1,11 @@
 obj-$(CONFIG_RAID6_PQ)	+= raid6_pq.o
 
-raid6_pq-y	+= algos.o recov.o recov_ssse3.o recov_avx2.o tables.o int1.o int2.o int4.o \
-		   int8.o int16.o int32.o altivec1.o altivec2.o altivec4.o \
-		   altivec8.o mmx.o sse1.o sse2.o avx2.o
+raid6_pq-y	+= algos.o recov.o tables.o int1.o int2.o int4.o \
+		   int8.o int16.o int32.o
+
+raid6_pq-$(CONFIG_X86) += recov_ssse3.o recov_avx2.o mmx.o sse1.o sse2.o avx2.o
+raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o altivec8.o
+
 hostprogs-y	+= mktables
 
 quiet_cmd_unroll = UNROLL  $@
diff --git a/lib/raid6/altivec.uc b/lib/raid6/altivec.uc
index b71012b..7cc12b5 100644
--- a/lib/raid6/altivec.uc
+++ b/lib/raid6/altivec.uc
@@ -24,13 +24,10 @@
 
 #include <linux/raid/pq.h>
 
-#ifdef CONFIG_ALTIVEC
-
 #include <altivec.h>
 #ifdef __KERNEL__
 # include <asm/cputable.h>
 # include <asm/switch_to.h>
-#endif
 
 /*
  * This is the C data type to use.  We use a vector of
diff --git a/lib/raid6/mmx.c b/lib/raid6/mmx.c
index 279347f..590c71c 100644
--- a/lib/raid6/mmx.c
+++ b/lib/raid6/mmx.c
@@ -16,7 +16,7 @@
  * MMX implementation of RAID-6 syndrome functions
  */
 
-#if defined(__i386__) && !defined(__arch_um__)
+#ifdef CONFIG_X86_32
 
 #include <linux/raid/pq.h>
 #include "x86.h"
diff --git a/lib/raid6/recov_avx2.c b/lib/raid6/recov_avx2.c
index 43a9bab..e1eea43 100644
--- a/lib/raid6/recov_avx2.c
+++ b/lib/raid6/recov_avx2.c
@@ -8,8 +8,6 @@
  * of the License.
  */
 
-#if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
-
 #if CONFIG_AS_AVX2
 
 #include <linux/raid/pq.h>
@@ -323,5 +321,3 @@ const struct raid6_recov_calls raid6_recov_avx2 = {
 #else
 #warning "your version of binutils lacks AVX2 support"
 #endif
-
-#endif
diff --git a/lib/raid6/recov_ssse3.c b/lib/raid6/recov_ssse3.c
index ecb710c..a916832 100644
--- a/lib/raid6/recov_ssse3.c
+++ b/lib/raid6/recov_ssse3.c
@@ -7,8 +7,6 @@
  * of the License.
  */
 
-#if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
-
 #include <linux/raid/pq.h>
 #include "x86.h"
 
@@ -332,5 +330,3 @@ const struct raid6_recov_calls raid6_recov_ssse3 = {
 #endif
 	.priority = 1,
 };
-
-#endif
diff --git a/lib/raid6/sse1.c b/lib/raid6/sse1.c
index 10dd919..f762971 100644
--- a/lib/raid6/sse1.c
+++ b/lib/raid6/sse1.c
@@ -21,7 +21,7 @@
  * worthwhile as a separate implementation.
  */
 
-#if defined(__i386__) && !defined(__arch_um__)
+#ifdef CONFIG_X86_32
 
 #include <linux/raid/pq.h>
 #include "x86.h"
diff --git a/lib/raid6/sse2.c b/lib/raid6/sse2.c
index bc2d57d..85b82c8 100644
--- a/lib/raid6/sse2.c
+++ b/lib/raid6/sse2.c
@@ -17,8 +17,6 @@
  *
  */
 
-#if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
-
 #include <linux/raid/pq.h>
 #include "x86.h"
 
@@ -159,9 +157,7 @@ const struct raid6_calls raid6_sse2x2 = {
 	1			/* Has cache hints */
 };
 
-#endif
-
-#if defined(__x86_64__) && !defined(__arch_um__)
+#ifdef CONFIG_X86_64
 
 /*
  * Unrolled-by-4 SSE2 implementation
@@ -259,4 +255,4 @@ const struct raid6_calls raid6_sse2x4 = {
 	1			/* Has cache hints */
 };
 
-#endif
+#endif /* CONFIG_X86_64 */
diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index 754cbac..087332d 100644
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@ -10,16 +10,31 @@ LD	 = ld
 AWK	 = awk -f
 AR	 = ar
 RANLIB	 = ranlib
+OBJS	 = int1.o int2.o int4.o int8.o int16.o int32.o recov.o algos.o tables.o
 
 ARCH := $(shell uname -m 2>/dev/null | sed -e /s/i.86/i386/)
 ifeq ($(ARCH),i386)
         CFLAGS += -DCONFIG_X86_32
+        IS_X86 = yes
 endif
 ifeq ($(ARCH),x86_64)
         CFLAGS += -DCONFIG_X86_64
+        IS_X86 = yes
+endif
+
+ifeq ($(IS_X86),yes)
+        OBJS   += mmx.o sse1.o sse2.o avx2.o recov_ssse3.o recov_avx2.o
+        CFLAGS += $(shell echo "vpbroadcastb %xmm0, %ymm1" |	\
+                    gcc -c -x assembler - >&/dev/null &&	\
+                    rm ./-.o && echo -DCONFIG_AS_AVX2=1)
+else
+        HAS_ALTIVEC := $(shell echo -e '\#include <altivec.h>\nvector int a;' |\
+                         gcc -c -x c - >&/dev/null && \
+                         rm ./-.o && echo yes)
+        ifeq ($(HAS_ALTIVEC),yes)
+                OBJS += altivec1.o altivec2.o altivec4.o altivec8.o
+        endif
 endif
-CFLAGS += $(shell echo "vpbroadcastb %xmm0, %ymm1"| gcc -c -x assembler - &&\
-	     rm ./-.o && echo -DCONFIG_AS_AVX2=1)
 
 .c.o:
 	$(CC) $(CFLAGS) -c -o $@ $<
@@ -32,9 +47,7 @@ CFLAGS += $(shell echo "vpbroadcastb %xmm0, %ymm1"| gcc -c -x assembler - &&\
 
 all:	raid6.a raid6test
 
-raid6.a: int1.o int2.o int4.o int8.o int16.o int32.o mmx.o sse1.o sse2.o avx2.o \
-	 altivec1.o altivec2.o altivec4.o altivec8.o recov.o recov_ssse3.o recov_avx2.o algos.o \
-	 tables.o
+raid6.a: $(OBJS)
 	 rm -f $@
 	 $(AR) cq $@ $^
 	 $(RANLIB) $@
-- 
1.8.0

