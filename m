From: Gayatri Kammela <gayatri.kammela@intel.com>
Subject: [PATCH 2/4] lib/raid6: Add AVX512 optimized recovery functions
Date: Tue,  2 Aug 2016 16:30:38 -0700
Message-ID: <1470180638-7581-1-git-send-email-gayatri.kammela@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com, james.t.kukunas@linux.intel.com, fenghua.yu@intel.com, megha.dey@linux.intel.com, ravi.v.shankar@intel.com, Gayatri Kammela <gayatri.kammela@intel.com>
List-Id: linux-raid.ids

Optimize RAID6 recovery functions to take advantage of
the 512-bit ZMM integer instructions introduced in AVX512.

AVX512 optimized recovery functions, which is simply based
on recov_avx2.c written by Jim Kukunas

This patch was tested and benchmarked before submission on
a hardware that has AVX512 flags to support such instructions

Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
---
 include/linux/raid/pq.h  |   1 +
 lib/raid6/Makefile       |   2 +-
 lib/raid6/algos.c        |   3 +
 lib/raid6/recov_avx512.c | 335 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 340 insertions(+), 1 deletion(-)
 create mode 100644 lib/raid6/recov_avx512.c

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 0c529a5..1abd895 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -118,6 +118,7 @@ struct raid6_recov_calls {
 extern const struct raid6_recov_calls raid6_recov_intx1;
 extern const struct raid6_recov_calls raid6_recov_ssse3;
 extern const struct raid6_recov_calls raid6_recov_avx2;
+extern const struct raid6_recov_calls raid6_recov_avx512;
 
 extern const struct raid6_calls raid6_neonx1;
 extern const struct raid6_calls raid6_neonx2;
diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index 8948268..cd05ee1 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -3,7 +3,7 @@ obj-$(CONFIG_RAID6_PQ)	+= raid6_pq.o
 raid6_pq-y	+= algos.o recov.o tables.o int1.o int2.o int4.o \
 		   int8.o int16.o int32.o
 
-raid6_pq-$(CONFIG_X86) += recov_ssse3.o recov_avx2.o mmx.o sse1.o sse2.o avx2.o avx512.o
+raid6_pq-$(CONFIG_X86) += recov_ssse3.o recov_avx2.o mmx.o sse1.o sse2.o avx2.o avx512.o recov_avx512.o
 raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o altivec8.o
 raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o neon8.o
 raid6_pq-$(CONFIG_TILEGX) += tilegx8.o
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index f5f090c..149d947 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -98,6 +98,9 @@ void (*raid6_datap_recov)(int, size_t, int, void **);
 EXPORT_SYMBOL_GPL(raid6_datap_recov);
 
 const struct raid6_recov_calls *const raid6_recov_algos[] = {
+#ifdef CONFIG_AS_AVX512
+	&raid6_recov_avx512,
+#endif
 #ifdef CONFIG_AS_AVX2
 	&raid6_recov_avx2,
 #endif
diff --git a/lib/raid6/recov_avx512.c b/lib/raid6/recov_avx512.c
new file mode 100644
index 0000000..3e00f34
--- /dev/null
+++ b/lib/raid6/recov_avx512.c
@@ -0,0 +1,335 @@
+/*
+ * Copyright (C) 2012 Intel Corporation
+ *
+ * Author: Megha Dey <megha.dey@linux.intel.com>
+ * Author: Gayatri Kammela <gayatri.kammela@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#ifdef CONFIG_AS_AVX512
+
+#include <linux/raid/pq.h>
+#include "x86.h"
+
+static int raid6_has_avx512(void)
+{
+	return boot_cpu_has(X86_FEATURE_AVX2) &&
+		boot_cpu_has(X86_FEATURE_AVX) &&
+		boot_cpu_has(X86_FEATURE_AVX512F) &&
+		boot_cpu_has(X86_FEATURE_AVX512BW) &&
+		boot_cpu_has(X86_FEATURE_AVX512VL) &&
+		boot_cpu_has(X86_FEATURE_AVX512DQ);
+}
+
+static void raid6_2data_recov_avx512(int disks, size_t bytes, int faila,
+		int failb, void **ptrs)
+{
+	u8 *p, *q, *dp, *dq;
+	const u8 *pbmul;	/* P multiplier table for B data */
+	const u8 *qmul;		/* Q multiplier table (for both) */
+	const u8 x0f = 0x0f;
+
+	p = (u8 *)ptrs[disks-2];
+	q = (u8 *)ptrs[disks-1];
+
+	/*
+	 * Compute syndrome with zero for the missing data pages
+	 * Use the dead data pages as temporary storage for
+	 * delta p and delta q
+	 */
+
+	dp = (u8 *)ptrs[faila];
+	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[disks-2] = dp;
+	dq = (u8 *)ptrs[failb];
+	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[disks-1] = dq;
+
+	raid6_call.gen_syndrome(disks, bytes, ptrs);
+
+	/* Restore pointer table */
+	ptrs[faila]   = dp;
+	ptrs[failb]   = dq;
+	ptrs[disks-2] = p;
+	ptrs[disks-1] = q;
+
+	/* Now, pick the proper data tables */
+	pbmul = raid6_vgfmul[raid6_gfexi[failb-faila]];
+	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
+		raid6_gfexp[failb]]];
+
+	kernel_fpu_begin();
+
+	/* zmm0 = x0f[16] */
+	asm volatile("vpbroadcastb %0, %%zmm7" : : "m" (x0f));
+
+	while (bytes) {
+#ifdef CONFIG_X86_64
+		asm volatile("vmovdqa64 %0, %%zmm1" : : "m" (q[0]));
+		asm volatile("vmovdqa64 %0, %%zmm9" : : "m" (q[64]));
+		asm volatile("vmovdqa64 %0, %%zmm0" : : "m" (p[0]));
+		asm volatile("vmovdqa64 %0, %%zmm8" : : "m" (p[64]));
+		asm volatile("vpxorq %0, %%zmm1, %%zmm1" : : "m" (dq[0]));
+		asm volatile("vpxorq %0, %%zmm9, %%zmm9" : : "m" (dq[64]));
+		asm volatile("vpxorq %0, %%zmm0, %%zmm0" : : "m" (dp[0]));
+		asm volatile("vpxorq %0, %%zmm8, %%zmm8" : : "m" (dp[64]));
+
+		/*
+		 * 1 = dq[0]  ^ q[0]
+		 * 9 = dq[64] ^ q[64]
+		 * 0 = dp[0]  ^ p[0]
+		 * 8 = dp[64] ^ p[64]
+		 */
+
+		asm volatile("vbroadcasti64x2 %0, %%zmm4" : : "m" (qmul[0]));
+		asm volatile("vbroadcasti64x2 %0, %%zmm5" : : "m" (qmul[16]));
+
+		asm volatile("vpsraw $4, %zmm1, %zmm3");
+		asm volatile("vpsraw $4, %zmm9, %zmm12");
+		asm volatile("vpandq %zmm7, %zmm1, %zmm1");
+		asm volatile("vpandq %zmm7, %zmm9, %zmm9");
+		asm volatile("vpandq %zmm7, %zmm3, %zmm3");
+		asm volatile("vpandq %zmm7, %zmm12, %zmm12");
+		asm volatile("vpshufb %zmm9, %zmm4, %zmm14");
+		asm volatile("vpshufb %zmm1, %zmm4, %zmm4");
+		asm volatile("vpshufb %zmm12, %zmm5, %zmm15");
+		asm volatile("vpshufb %zmm3, %zmm5, %zmm5");
+		asm volatile("vpxorq %zmm14, %zmm15, %zmm15");
+		asm volatile("vpxorq %zmm4, %zmm5, %zmm5");
+
+		/*
+		 * 5 = qx[0]
+		 * 15 = qx[64]
+		 */
+
+		asm volatile("vbroadcasti64x2 %0, %%zmm4" : : "m" (pbmul[0]));
+		asm volatile("vbroadcasti64x2 %0, %%zmm1" : : "m" (pbmul[16]));
+		asm volatile("vpsraw $4, %zmm0, %zmm2");
+		asm volatile("vpsraw $4, %zmm8, %zmm6");
+		asm volatile("vpandq %zmm7, %zmm0, %zmm3");
+		asm volatile("vpandq %zmm7, %zmm8, %zmm14");
+		asm volatile("vpandq %zmm7, %zmm2, %zmm2");
+		asm volatile("vpandq %zmm7, %zmm6, %zmm6");
+		asm volatile("vpshufb %zmm14, %zmm4, %zmm12");
+		asm volatile("vpshufb %zmm3, %zmm4, %zmm4");
+		asm volatile("vpshufb %zmm6, %zmm1, %zmm13");
+		asm volatile("vpshufb %zmm2, %zmm1, %zmm1");
+		asm volatile("vpxorq %zmm4, %zmm1, %zmm1");
+		asm volatile("vpxorq %zmm12, %zmm13, %zmm13");
+
+		/*
+		 * 1  = pbmul[px[0]]
+		 * 13 = pbmul[px[64]]
+		 */
+		asm volatile("vpxorq %zmm5, %zmm1, %zmm1");
+		asm volatile("vpxorq %zmm15, %zmm13, %zmm13");
+
+		/*
+		 * 1 = db = DQ
+		 * 13 = db[64] = DQ[64]
+		 */
+		asm volatile("vmovdqa64 %%zmm1, %0" : "=m" (dq[0]));
+		asm volatile("vmovdqa64 %%zmm13,%0" : "=m" (dq[64]));
+		asm volatile("vpxorq %zmm1, %zmm0, %zmm0");
+		asm volatile("vpxorq %zmm13, %zmm8, %zmm8");
+
+		asm volatile("vmovdqa64 %%zmm0, %0" : "=m" (dp[0]));
+		asm volatile("vmovdqa64 %%zmm8, %0" : "=m" (dp[64]));
+
+		bytes -= 128;
+		p += 128;
+		q += 128;
+		dp += 128;
+		dq += 128;
+#else
+		asm volatile("vmovdqa64 %0, %%zmm1" : : "m" (*q));
+		asm volatile("vmovdqa64 %0, %%zmm0" : : "m" (*p));
+		asm volatile("vpxorq %0, %%zmm1, %%zmm1" : : "m" (*dq));
+		asm volatile("vpxorq %0, %%zmm0, %%zmm0" : : "m" (*dp));
+
+		/* 1 = dq ^ q;  0 = dp ^ p */
+
+		asm volatile("vbroadcasti64x2 %0, %%zmm4" : : "m" (qmul[0]));
+		asm volatile("vbroadcasti64x2 %0, %%zmm5" : : "m" (qmul[16]));
+
+		/*
+		 * 1 = dq ^ q
+		 * 3 = dq ^ p >> 4
+		 */
+		asm volatile("vpsraw $4, %zmm1, %zmm3");
+		asm volatile("vpandq %zmm7, %zmm1, %zmm1");
+		asm volatile("vpandq %zmm7, %zmm3, %zmm3");
+		asm volatile("vpshufb %zmm1, %zmm4, %zmm4");
+		asm volatile("vpshufb %zmm3, %zmm5, %zmm5");
+		asm volatile("vpxorq %zmm4, %zmm5, %zmm5");
+
+		/* 5 = qx */
+
+		asm volatile("vbroadcasti64x2 %0, %%zmm4" : : "m" (pbmul[0]));
+		asm volatile("vbroadcasti64x2 %0, %%zmm1" : : "m" (pbmul[16]));
+
+		asm volatile("vpsraw $4, %zmm0, %zmm2");
+		asm volatile("vpandq %zmm7, %zmm0, %zmm3");
+		asm volatile("vpandq %zmm7, %zmm2, %zmm2");
+		asm volatile("vpshufb %zmm3, %zmm4, %zmm4");
+		asm volatile("vpshufb %zmm2, %zmm1, %zmm1");
+		asm volatile("vpxorq %zmm4, %zmm1, %zmm1");
+
+		/* 1 = pbmul[px] */
+		asm volatile("vpxorq %zmm5, %zmm1, %zmm1");
+		/* 1 = db = DQ */
+		asm volatile("vmovdqa64 %%zmm1, %0" : "=m" (dq[0]));
+
+		asm volatile("vpxorq %zmm1, %zmm0, %zmm0");
+		asm volatile("vmovdqa64 %%zmm0, %0" : "=m" (dp[0]));
+
+		bytes -= 64;
+		p += 64;
+		q += 64;
+		dp += 64;
+		dq += 64;
+#endif
+	}
+
+	kernel_fpu_end();
+}
+
+static void raid6_datap_recov_avx512(int disks, size_t bytes, int faila,
+		void **ptrs)
+{
+	u8 *p, *q, *dq;
+	const u8 *qmul;		/* Q multiplier table */
+	const u8 x0f = 0x0f;
+
+	p = (u8 *)ptrs[disks-2];
+	q = (u8 *)ptrs[disks-1];
+
+	/*
+	 * Compute syndrome with zero for the missing data page
+	 * Use the dead data page as temporary storage for delta q
+	 */
+
+	dq = (u8 *)ptrs[faila];
+	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[disks-1] = dq;
+
+	raid6_call.gen_syndrome(disks, bytes, ptrs);
+
+	/* Restore pointer table */
+	ptrs[faila]   = dq;
+	ptrs[disks-1] = q;
+
+	/* Now, pick the proper data tables */
+	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
+
+	kernel_fpu_begin();
+
+	asm volatile("vpbroadcastb %0, %%zmm7" : : "m" (x0f));
+
+	while (bytes) {
+#ifdef CONFIG_X86_64
+		asm volatile("vmovdqa64 %0, %%zmm3" : : "m" (dq[0]));
+		asm volatile("vmovdqa64 %0, %%zmm8" : : "m" (dq[64]));
+		asm volatile("vpxorq %0, %%zmm3, %%zmm3" : : "m" (q[0]));
+		asm volatile("vpxorq %0, %%zmm8, %%zmm8" : : "m" (q[64]));
+
+		/*
+		 * 3 = q[0] ^ dq[0]
+		 * 8 = q[64] ^ dq[64]
+		 */
+		asm volatile("vbroadcasti64x2 %0, %%zmm0" : : "m" (qmul[0]));
+		asm volatile("vmovapd %zmm0, %zmm13");
+		asm volatile("vbroadcasti64x2 %0, %%zmm1" : : "m" (qmul[16]));
+		asm volatile("vmovapd %zmm1, %zmm14");
+
+		asm volatile("vpsraw $4, %zmm3, %zmm6");
+		asm volatile("vpsraw $4, %zmm8, %zmm12");
+		asm volatile("vpandq %zmm7, %zmm3, %zmm3");
+		asm volatile("vpandq %zmm7, %zmm8, %zmm8");
+		asm volatile("vpandq %zmm7, %zmm6, %zmm6");
+		asm volatile("vpandq %zmm7, %zmm12, %zmm12");
+		asm volatile("vpshufb %zmm3, %zmm0, %zmm0");
+		asm volatile("vpshufb %zmm8, %zmm13, %zmm13");
+		asm volatile("vpshufb %zmm6, %zmm1, %zmm1");
+		asm volatile("vpshufb %zmm12, %zmm14, %zmm14");
+		asm volatile("vpxorq %zmm0, %zmm1, %zmm1");
+		asm volatile("vpxorq %zmm13, %zmm14, %zmm14");
+
+		/*
+		 * 1  = qmul[q[0]  ^ dq[0]]
+		 * 14 = qmul[q[64] ^ dq[64]]
+		 */
+		asm volatile("vmovdqa64 %0, %%zmm2" : : "m" (p[0]));
+		asm volatile("vmovdqa64 %0, %%zmm12" : : "m" (p[64]));
+		asm volatile("vpxorq %zmm1, %zmm2, %zmm2");
+		asm volatile("vpxorq %zmm14, %zmm12, %zmm12");
+
+		/*
+		 * 2  = p[0]  ^ qmul[q[0]  ^ dq[0]]
+		 * 12 = p[64] ^ qmul[q[64] ^ dq[64]]
+		 */
+
+		asm volatile("vmovdqa64 %%zmm1, %0" : "=m" (dq[0]));
+		asm volatile("vmovdqa64 %%zmm14, %0" : "=m" (dq[64]));
+		asm volatile("vmovdqa64 %%zmm2, %0" : "=m" (p[0]));
+		asm volatile("vmovdqa64 %%zmm12,%0" : "=m" (p[64]));
+
+		bytes -= 128;
+		p += 128;
+		q += 128;
+		dq += 128;
+#else
+		asm volatile("vmovdqa64 %0, %%zmm3" : : "m" (dq[0]));
+		asm volatile("vpxorq %0, %%zmm3, %%zmm3" : : "m" (q[0]));
+
+		/* 3 = q ^ dq */
+
+		asm volatile("vbroadcasti64x2 %0, %%zmm0" : : "m" (qmul[0]));
+		asm volatile("vbroadcasti64x2 %0, %%zmm1" : : "m" (qmul[16]));
+
+		asm volatile("vpsraw $4, %zmm3, %zmm6");
+		asm volatile("vpandq %zmm7, %zmm3, %zmm3");
+		asm volatile("vpandq %zmm7, %zmm6, %zmm6");
+		asm volatile("vpshufb %zmm3, %zmm0, %zmm0");
+		asm volatile("vpshufb %zmm6, %zmm1, %zmm1");
+		asm volatile("vpxorq %zmm0, %zmm1, %zmm1");
+
+		/* 1 = qmul[q ^ dq] */
+
+		asm volatile("vmovdqa64 %0, %%zmm2" : : "m" (p[0]));
+		asm volatile("vpxorq %zmm1, %zmm2, %zmm2");
+
+		/* 2 = p ^ qmul[q ^ dq] */
+
+		asm volatile("vmovdqa64 %%zmm1, %0" : "=m" (dq[0]));
+		asm volatile("vmovdqa64 %%zmm2, %0" : "=m" (p[0]));
+
+		bytes -= 64;
+		p += 64;
+		q += 64;
+		dq += 64;
+#endif
+	}
+
+	kernel_fpu_end();
+}
+
+const struct raid6_recov_calls raid6_recov_avx512 = {
+	.data2 = raid6_2data_recov_avx512,
+	.datap = raid6_datap_recov_avx512,
+	.valid = raid6_has_avx512,
+#ifdef CONFIG_X86_64
+	.name = "avx512x2",
+#else
+	.name = "avx512x1",
+#endif
+	.priority = 3,
+};
+
+#else
+#warning "your version of binutils lacks AVX512 support"
+#endif
-- 
1.9.1

