From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: [PATCH] raid5: add AVX optimized RAID5 checksumming
Date: Thu, 29 Mar 2012 14:44:18 -0700
Message-ID: <1333057458-2986-2-git-send-email-james.t.kukunas@linux.intel.com>
References: <1333057458-2986-1-git-send-email-james.t.kukunas@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1333057458-2986-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: hpa@zytor.com, neilb@suse.de
List-Id: linux-raid.ids

Optimize RAID5 xor checksumming by taking advantage of
256-bit YMM registers introduced in AVX.

Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/xor_32.h  |    8 ++-
 arch/x86/include/asm/xor_64.h  |   10 ++-
 arch/x86/include/asm/xor_avx.h |  184 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 200 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/xor_avx.h

diff --git a/arch/x86/include/asm/xor_32.h b/arch/x86/include/asm/xor_32.h
index 133b40a..1799baa 100644
--- a/arch/x86/include/asm/xor_32.h
+++ b/arch/x86/include/asm/xor_32.h
@@ -861,6 +861,9 @@ static struct xor_block_template xor_block_pIII_sse = {
 	.do_5 = xor_sse_5,
 };
 
+/* Also try the AVX routines */
+#include "xor_avx.h"
+
 /* Also try the generic routines.  */
 #include <asm-generic/xor.h>
 
@@ -871,6 +874,8 @@ do {							\
 	xor_speed(&xor_block_8regs_p);			\
 	xor_speed(&xor_block_32regs);			\
 	xor_speed(&xor_block_32regs_p);			\
+	if (cpu_has_avx)				\
+		xor_speed(&xor_block_avx);		\
 	if (cpu_has_xmm)				\
 		xor_speed(&xor_block_pIII_sse);		\
 	if (cpu_has_mmx) {				\
@@ -883,6 +888,7 @@ do {							\
    We may also be able to load into the L1 only depending on how the cpu
    deals with a load to a line that is being prefetched.  */
 #define XOR_SELECT_TEMPLATE(FASTEST)			\
-	(cpu_has_xmm ? &xor_block_pIII_sse : FASTEST)
+	(cpu has_avx ? &xor_block_avx : \
+	cpu_has_xmm ? &xor_block_pIII_sse : FASTEST)
 
 #endif /* _ASM_X86_XOR_32_H */
diff --git a/arch/x86/include/asm/xor_64.h b/arch/x86/include/asm/xor_64.h
index 1549b5e..d331b41 100644
--- a/arch/x86/include/asm/xor_64.h
+++ b/arch/x86/include/asm/xor_64.h
@@ -347,15 +347,23 @@ static struct xor_block_template xor_block_sse = {
 	.do_5 = xor_sse_5,
 };
 
+
+/* Also try the AVX routines */
+#include "xor_avx.h"
+
 #undef XOR_TRY_TEMPLATES
 #define XOR_TRY_TEMPLATES			\
 do {						\
+	if (cpu_has_avx)			\
+		xor_speed(&xor_block_avx);	\
 	xor_speed(&xor_block_sse);		\
 } while (0)
 
 /* We force the use of the SSE xor block because it can write around L2.
    We may also be able to load into the L1 only depending on how the cpu
    deals with a load to a line that is being prefetched.  */
-#define XOR_SELECT_TEMPLATE(FASTEST) (&xor_block_sse)
+#define XOR_SELECT_TEMPLATE(FASTEST) \
+	(cpu_has_avx ? &xor_block_avx : \
+		&xor_block_sse)
 
 #endif /* _ASM_X86_XOR_64_H */
diff --git a/arch/x86/include/asm/xor_avx.h b/arch/x86/include/asm/xor_avx.h
new file mode 100644
index 0000000..dda165b
--- /dev/null
+++ b/arch/x86/include/asm/xor_avx.h
@@ -0,0 +1,184 @@
+#ifndef _ASM_X86_XOR_AVX_H
+#define _ASM_X86_XOR_AVX_H
+
+/*
+ * Optimized RAID-5 checksumming functions for AVX
+ *
+ * Copyright (C) 2012 Intel Corporation
+ * Author: Jim Kukunas <james.t.kukunas@linux.intel.com>
+ *
+ * Based on Ingo Molnar and Zach Brown's respective MMX and SSE routines
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <asm/i387.h>
+
+#define ALIGN32 __attribute__((aligned(32)))
+
+#define YMM_SAVED_REGS 4
+
+#define YMMS_SAVE \
+do { \
+	preempt_disable(); \
+	cr0 = read_cr0(); \
+	clts(); \
+	asm volatile("vmovaps %%ymm0, %0" : "=m" (ymm_save[0]) : : "memory"); \
+	asm volatile("vmovaps %%ymm1, %0" : "=m" (ymm_save[32]) : : "memory"); \
+	asm volatile("vmovaps %%ymm2, %0" : "=m" (ymm_save[64]) : : "memory"); \
+	asm volatile("vmovaps %%ymm3, %0" : "=m" (ymm_save[96]) : : "memory"); \
+} while (0);
+
+#define YMMS_RESTORE \
+do { \
+	asm volatile("sfence" : : : "memory"); \
+	asm volatile("vmovaps %0, %%ymm3" : : "m" (ymm_save[96])); \
+	asm volatile("vmovaps %0, %%ymm2" : : "m" (ymm_save[64])); \
+	asm volatile("vmovaps %0, %%ymm1" : : "m" (ymm_save[32])); \
+	asm volatile("vmovaps %0, %%ymm0" : : "m" (ymm_save[0])); \
+	write_cr0(cr0); \
+	preempt_enable(); \
+} while (0);
+
+#define BLOCK4(i) \
+		BLOCK(32 * i, 0) \
+		BLOCK(32 * (i + 1), 1) \
+		BLOCK(32 * (i + 2), 2) \
+		BLOCK(32 * (i + 3), 3)
+
+#define BLOCK16() \
+		BLOCK4(0) \
+		BLOCK4(4) \
+		BLOCK4(8) \
+		BLOCK4(12)
+
+static void xor_avx_2(unsigned long bytes, unsigned long *p0, unsigned long *p1)
+{
+	unsigned long cr0, lines = bytes >> 9;
+	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+
+	YMMS_SAVE
+
+	while (lines--) {
+#undef BLOCK
+#define BLOCK(i, reg) \
+	asm volatile("vmovdqa %0, %%ymm" #reg : : "m" (p1[i / sizeof(*p1)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm"  #reg : : \
+		"m" (p0[i / sizeof(*p0)])); \
+	asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (p0[i / sizeof(*p0)]));
+
+		BLOCK16()
+
+		p0 = (unsigned long *)((uintptr_t)p0 + 512);
+		p1 = (unsigned long *)((uintptr_t)p1 + 512);
+	}
+
+	YMMS_RESTORE
+}
+
+static void xor_avx_3(unsigned long bytes, unsigned long *p0, unsigned long *p1,
+	unsigned long *p2)
+{
+	unsigned long cr0, lines = bytes >> 9;
+	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+
+	YMMS_SAVE
+
+	while (lines--) {
+#undef BLOCK
+#define BLOCK(i, reg) \
+	asm volatile("vmovdqa %0, %%ymm" #reg : : "m" (p2[i / sizeof(*p2)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p1[i / sizeof(*p1)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p0[i / sizeof(*p0)])); \
+	asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (p0[i / sizeof(*p0)]));
+
+		BLOCK16()
+
+		p0 = (unsigned long *)((uintptr_t)p0 + 512);
+		p1 = (unsigned long *)((uintptr_t)p1 + 512);
+		p2 = (unsigned long *)((uintptr_t)p2 + 512);
+	}
+
+	YMMS_RESTORE
+}
+
+static void xor_avx_4(unsigned long bytes, unsigned long *p0, unsigned long *p1,
+	unsigned long *p2, unsigned long *p3)
+{
+	unsigned long cr0, lines = bytes >> 9;
+	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+
+	YMMS_SAVE
+
+	while (lines--) {
+#undef BLOCK
+#define BLOCK(i, reg) \
+	asm volatile("vmovdqa %0, %%ymm" #reg : : "m" (p3[i / sizeof(*p3)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p2[i / sizeof(*p2)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p1[i / sizeof(*p1)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p0[i / sizeof(*p0)])); \
+	asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (p0[i / sizeof(*p0)]));
+
+		BLOCK16();
+
+		p0 = (unsigned long *)((uintptr_t)p0 + 512);
+		p1 = (unsigned long *)((uintptr_t)p1 + 512);
+		p2 = (unsigned long *)((uintptr_t)p2 + 512);
+		p3 = (unsigned long *)((uintptr_t)p3 + 512);
+	}
+
+	YMMS_RESTORE
+}
+
+static void xor_avx_5(unsigned long bytes, unsigned long *p0, unsigned long *p1,
+	unsigned long *p2, unsigned long *p3, unsigned long *p4)
+{
+	unsigned long cr0, lines = bytes >> 9;
+	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+
+	YMMS_SAVE
+
+	while (lines--) {
+#undef BLOCK
+#define BLOCK(i, reg) \
+	asm volatile("vmovdqa %0, %%ymm" #reg : : "m" (p4[i / sizeof(*p4)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p3[i / sizeof(*p3)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p2[i / sizeof(*p2)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p1[i / sizeof(*p1)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p0[i / sizeof(*p0)])); \
+	asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (p0[i / sizeof(*p0)]));
+
+		BLOCK16()
+
+		p0 = (unsigned long *)((uintptr_t)p0 + 512);
+		p1 = (unsigned long *)((uintptr_t)p1 + 512);
+		p2 = (unsigned long *)((uintptr_t)p2 + 512);
+		p3 = (unsigned long *)((uintptr_t)p3 + 512);
+		p4 = (unsigned long *)((uintptr_t)p4 + 512);
+	}
+
+	YMMS_RESTORE
+}
+
+static struct xor_block_template xor_block_avx = {
+	.name = "avx",
+	.do_2 = xor_avx_2,
+	.do_3 = xor_avx_3,
+	.do_4 = xor_avx_4,
+	.do_5 = xor_avx_5,
+};
+
+#endif
+
-- 
1.7.8.5

