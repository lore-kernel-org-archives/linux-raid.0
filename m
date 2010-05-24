From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] md: fix raid6test build error
Date: Mon, 24 May 2010 22:05:27 +0900
Message-ID: <1274706327-13581-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

Fix userspace raid6test build error.

Tested with:
	make -C drivers/md/raid6test/
	./drivers/md/raid6test/raid6test

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 drivers/md/raid6algos.c       |    2 +-
 drivers/md/raid6test/Makefile |   20 ++++++++++----------
 include/linux/raid/pq.h       |    2 ++
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid6algos.c b/drivers/md/raid6algos.c
index 1f8784b..df7ff72 100644
--- a/drivers/md/raid6algos.c
+++ b/drivers/md/raid6algos.c
@@ -17,11 +17,11 @@
  */
 
 #include <linux/raid/pq.h>
-#include <linux/gfp.h>
 #ifndef __KERNEL__
 #include <sys/mman.h>
 #include <stdio.h>
 #else
+#include <linux/gfp.h>
 #if !RAID6_USE_EMPTY_ZERO_PAGE
 /* In .bss so it's zeroed */
 const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(256)));
diff --git a/drivers/md/raid6test/Makefile b/drivers/md/raid6test/Makefile
index 2874cbe..0674b29 100644
--- a/drivers/md/raid6test/Makefile
+++ b/drivers/md/raid6test/Makefile
@@ -36,34 +36,34 @@ raid6test: test.c raid6.a
 	$(CC) $(CFLAGS) -o raid6test $^
 
 raid6altivec1.c: raid6altivec.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=1 < raid6altivec.uc > $@
+	$(AWK) -f ../unroll.awk -vN=1 < raid6altivec.uc > $@
 
 raid6altivec2.c: raid6altivec.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=2 < raid6altivec.uc > $@
+	$(AWK) -f ../unroll.awk -vN=2 < raid6altivec.uc > $@
 
 raid6altivec4.c: raid6altivec.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=4 < raid6altivec.uc > $@
+	$(AWK) -f ../unroll.awk -vN=4 < raid6altivec.uc > $@
 
 raid6altivec8.c: raid6altivec.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=8 < raid6altivec.uc > $@
+	$(AWK) -f ../unroll.awk -vN=8 < raid6altivec.uc > $@
 
 raid6int1.c: raid6int.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=1 < raid6int.uc > $@
+	$(AWK) -f ../unroll.awk -vN=1 < raid6int.uc > $@
 
 raid6int2.c: raid6int.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=2 < raid6int.uc > $@
+	$(AWK) -f ../unroll.awk -vN=2 < raid6int.uc > $@
 
 raid6int4.c: raid6int.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=4 < raid6int.uc > $@
+	$(AWK) -f ../unroll.awk -vN=4 < raid6int.uc > $@
 
 raid6int8.c: raid6int.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=8 < raid6int.uc > $@
+	$(AWK) -f ../unroll.awk -vN=8 < raid6int.uc > $@
 
 raid6int16.c: raid6int.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=16 < raid6int.uc > $@
+	$(AWK) -f ../unroll.awk -vN=16 < raid6int.uc > $@
 
 raid6int32.c: raid6int.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=32 < raid6int.uc > $@
+	$(AWK) -f ../unroll.awk -vN=32 < raid6int.uc > $@
 
 raid6tables.c: mktables
 	./mktables > raid6tables.c
diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 1cbbd2c..5be078f 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -62,7 +62,9 @@ extern const char raid6_empty_zero_page[PAGE_SIZE];
 #define disable_kernel_altivec()
 
 #define EXPORT_SYMBOL(sym)
+#define EXPORT_SYMBOL_GPL(sym)
 #define MODULE_LICENSE(licence)
+#define MODULE_DESCRIPTION(_description)
 #define subsys_initcall(x)
 #define module_exit(x)
 #endif /* __KERNEL__ */
-- 
1.6.0.6

