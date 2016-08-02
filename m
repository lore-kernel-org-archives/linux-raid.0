From: Gayatri Kammela <gayatri.kammela@intel.com>
Subject: [PATCH 4/4] (DO NOT APPLY) lib/raid6: Add unroll by 8 to AVX512 optimized gen_syndrome functions
Date: Tue,  2 Aug 2016 16:32:33 -0700
Message-ID: <1470180753-7748-1-git-send-email-gayatri.kammela@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com, james.t.kukunas@linux.intel.com, fenghua.yu@intel.com, megha.dey@linux.intel.com, ravi.v.shankar@intel.com, Gayatri Kammela <gayatri.kammela@intel.com>
List-Id: linux-raid.ids

Optimize RAID6 gen_syndrome functions by further unrolling by 8 to take
advantage of all the 32 ZMM registers.

Note: In theory avx512 unroll by 8 gen_syndrome function should perfom
better than the rest of gen_syndrome functions, but it is outperformed
by avx512 unroll by 4 gen_syndrome function when tested in user as well
as kernel space.

This is posted for reference only, to allow others to make their own
experiments.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
---
 include/linux/raid/pq.h |   1 +
 lib/raid6/algos.c       |   1 +
 lib/raid6/avx512.c      | 172 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 174 insertions(+)

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 1abd895..b4db38e 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -105,6 +105,7 @@ extern const struct raid6_calls raid6_avx2x4;
 extern const struct raid6_calls raid6_avx512x1;
 extern const struct raid6_calls raid6_avx512x2;
 extern const struct raid6_calls raid6_avx512x4;
+extern const struct raid6_calls raid6_avx512x8;
 extern const struct raid6_calls raid6_tilegx8;
 
 struct raid6_recov_calls {
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 149d947..85ba18a 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -67,6 +67,7 @@ const struct raid6_calls * const raid6_algos[] = {
 	&raid6_avx512x1,
 	&raid6_avx512x2,
 	&raid6_avx512x4,
+	&raid6_avx512x8,
 #endif
 #endif
 #ifdef CONFIG_ALTIVEC
diff --git a/lib/raid6/avx512.c b/lib/raid6/avx512.c
index b1188a6..6a74327 100644
--- a/lib/raid6/avx512.c
+++ b/lib/raid6/avx512.c
@@ -289,6 +289,178 @@ const struct raid6_calls raid6_avx512x4 = {
 	"avx512x4",
 	1                       /* Has cache hints */
 };
+
+/*
+ * Unrolled-by-8 AVX512 implementation
+ */
+static void raid6_avx5128_gen_syndrome(int disks, size_t bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	int d, z, z0;
+
+	z0 = disks - 3;         /* Highest data disk */
+	p = dptr[z0+1];         /* XOR parity */
+	q = dptr[z0+2];         /* RS syndrome */
+
+	kernel_fpu_begin();
+
+	asm volatile("vmovdqa64 %0,%%zmm0\n\t"
+		     "vpxorq %%zmm1,%%zmm1,%%zmm1\n\t"       /* Zero temp */
+		     "vpxorq %%zmm2,%%zmm2,%%zmm2\n\t"       /* P[0] */
+		     "vpxorq %%zmm3,%%zmm3,%%zmm3\n\t"       /* P[1] */
+		     "vpxorq %%zmm4,%%zmm4,%%zmm4\n\t"       /* Q[0] */
+		     "vpxorq %%zmm6,%%zmm6,%%zmm6\n\t"       /* Q[1] */
+		     "vpxorq %%zmm10,%%zmm10,%%zmm10\n\t"    /* P[2] */
+		     "vpxorq %%zmm11,%%zmm11,%%zmm11\n\t"    /* P[3] */
+		     "vpxorq %%zmm12,%%zmm12,%%zmm12\n\t"    /* Q[2] */
+		     "vpxorq %%zmm14,%%zmm14,%%zmm14\n\t"    /* Q[3] */
+		     "vpxorq %%zmm16,%%zmm16,%%zmm16\n\t"    /* P[4] */
+		     "vpxorq %%zmm18,%%zmm18,%%zmm18\n\t"    /* P[5] */
+		     "vpxorq %%zmm20,%%zmm20,%%zmm20\n\t"    /* Q[4] */
+		     "vpxorq %%zmm22,%%zmm22,%%zmm22\n\t"    /* Q[5] */
+		     "vpxorq %%zmm24,%%zmm24,%%zmm24\n\t"    /* P[6] */
+		     "vpxorq %%zmm26,%%zmm26,%%zmm26\n\t"    /* P[7] */
+		     "vpxorq %%zmm28,%%zmm28,%%zmm28\n\t"    /* Q[6] */
+		     "vpxorq %%zmm30,%%zmm30,%%zmm30"        /* Q[7] */
+		     :
+		     : "m" (raid6_avx512_constants.x1d[0]));
+
+	for (d = 0; d < bytes; d += 512) {
+		for (z = z0; z >= 0; z--) {
+			asm volatile("prefetchnta %0\n\t"
+				     "prefetchnta %1\n\t"
+				     "prefetchnta %2\n\t"
+				     "prefetchnta %3\n\t"
+				     "vpcmpgtb %%zmm4,%%zmm1,%%k1\n\t"
+				     "vpcmpgtb %%zmm6,%%zmm1,%%k2\n\t"
+				     "vpcmpgtb %%zmm12,%%zmm1,%%k3\n\t"
+				     "vpcmpgtb %%zmm14,%%zmm1,%%k4\n\t"
+				     "vpmovm2b %%k1,%%zmm5\n\t"
+				     "vpmovm2b %%k2,%%zmm7\n\t"
+				     "vpmovm2b %%k3,%%zmm13\n\t"
+				     "vpmovm2b %%k4,%%zmm15\n\t"
+				     "vpaddb %%zmm4,%%zmm4,%%zmm4\n\t"
+				     "vpaddb %%zmm6,%%zmm6,%%zmm6\n\t"
+				     "vpaddb %%zmm12,%%zmm12,%%zmm12\n\t"
+				     "vpaddb %%zmm14,%%zmm14,%%zmm14\n\t"
+				     "vpandd %%zmm0,%%zmm5,%%zmm5\n\t"
+				     "vpandd %%zmm0,%%zmm7,%%zmm7\n\t"
+				     "vpandd %%zmm0,%%zmm13,%%zmm13\n\t"
+				     "vpandd %%zmm0,%%zmm15,%%zmm15\n\t"
+				     "vpxorq %%zmm5,%%zmm4,%%zmm4\n\t"
+				     "vpxorq %%zmm7,%%zmm6,%%zmm6\n\t"
+				     "vpxorq %%zmm13,%%zmm12,%%zmm12\n\t"
+				     "vpxorq %%zmm15,%%zmm14,%%zmm14\n\t"
+				     "vmovdqa64 %0,%%zmm5\n\t"
+				     "vmovdqa64 %1,%%zmm7\n\t"
+				     "vmovdqa64 %2,%%zmm13\n\t"
+				     "vmovdqa64 %3,%%zmm15\n\t"
+				     "vpxorq %%zmm5,%%zmm2,%%zmm2\n\t"
+				     "vpxorq %%zmm7,%%zmm3,%%zmm3\n\t"
+				     "vpxorq %%zmm13,%%zmm10,%%zmm10\n\t"
+				     "vpxorq %%zmm15,%%zmm11,%%zmm11\n\t"
+				     "vpxorq %%zmm5,%%zmm4,%%zmm4\n\t"
+				     "vpxorq %%zmm7,%%zmm6,%%zmm6\n\t"
+				     "vpxorq %%zmm13,%%zmm12,%%zmm12\n\t"
+				     "vpxorq %%zmm15,%%zmm14,%%zmm14\n\t"
+				     "prefetchnta %4\n\t"
+				     "prefetchnta %5\n\t"
+				     "prefetchnta %6\n\t"
+				     "prefetchnta %7\n\t"
+				     "vpcmpgtb %%zmm20,%%zmm1,%%k5\n\t"
+				     "vpcmpgtb %%zmm22,%%zmm1,%%k6\n\t"
+				     "vpcmpgtb %%zmm28,%%zmm1,%%k7\n\t"
+				     "vpcmpgtb %%zmm30,%%zmm1,%%k1\n\t"
+				     "vpmovm2b %%k5,%%zmm21\n\t"
+				     "vpmovm2b %%k6,%%zmm23\n\t"
+				     "vpmovm2b %%k7,%%zmm29\n\t"
+				     "vpmovm2b %%k1,%%zmm31\n\t"
+				     "vpaddb %%zmm20,%%zmm20,%%zmm20\n\t"
+				     "vpaddb %%zmm22,%%zmm22,%%zmm22\n\t"
+				     "vpaddb %%zmm28,%%zmm28,%%zmm28\n\t"
+				     "vpaddb %%zmm30,%%zmm30,%%zmm30\n\t"
+				     "vpandd %%zmm0,%%zmm21,%%zmm21\n\t"
+				     "vpandd %%zmm0,%%zmm23,%%zmm23\n\t"
+				     "vpandd %%zmm0,%%zmm29,%%zmm29\n\t"
+				     "vpandd %%zmm0,%%zmm31,%%zmm31\n\t"
+				     "vpxorq %%zmm21,%%zmm20,%%zmm20\n\t"
+				     "vpxorq %%zmm23,%%zmm22,%%zmm22\n\t"
+				     "vpxorq %%zmm29,%%zmm28,%%zmm28\n\t"
+				     "vpxorq %%zmm31,%%zmm30,%%zmm30\n\t"
+				     "vmovdqa64 %4,%%zmm21\n\t"
+				     "vmovdqa64 %5,%%zmm23\n\t"
+				     "vmovdqa64 %6,%%zmm29\n\t"
+				     "vmovdqa64 %7,%%zmm31\n\t"
+				     "vpxorq %%zmm21,%%zmm16,%%zmm16\n\t"
+				     "vpxorq %%zmm23,%%zmm18,%%zmm18\n\t"
+				     "vpxorq %%zmm29,%%zmm24,%%zmm24\n\t"
+				     "vpxorq %%zmm31,%%zmm26,%%zmm26\n\t"
+				     "vpxorq %%zmm21,%%zmm20,%%zmm20\n\t"
+				     "vpxorq %%zmm23,%%zmm22,%%zmm22\n\t"
+				     "vpxorq %%zmm29,%%zmm28,%%zmm28\n\t"
+				     "vpxorq %%zmm31,%%zmm30,%%zmm30"
+				     :
+				     : "m" (dptr[z][d]), "m" (dptr[z][d+64]),
+				       "m" (dptr[z][d+128]),
+				       "m" (dptr[z][d+192]),
+				       "m" (dptr[z][d+256]),
+				       "m" (dptr[z][d+320]),
+				       "m" (dptr[z][d+384]),
+				       "m" (dptr[z][d+448]));
+		}
+		asm volatile("vmovntdq %%zmm2,%0\n\t"
+			     "vpxorq %%zmm2,%%zmm2,%%zmm2\n\t"
+			     "vmovntdq %%zmm3,%1\n\t"
+			     "vpxorq %%zmm3,%%zmm3,%%zmm3\n\t"
+			     "vmovntdq %%zmm10,%2\n\t"
+			     "vpxorq %%zmm10,%%zmm10,%%zmm10\n\t"
+			     "vmovntdq %%zmm11,%3\n\t"
+			     "vpxorq %%zmm11,%%zmm11,%%zmm11\n\t"
+			     "vmovntdq %%zmm4,%4\n\t"
+			     "vpxorq %%zmm4,%%zmm4,%%zmm4\n\t"
+			     "vmovntdq %%zmm6,%5\n\t"
+			     "vpxorq %%zmm6,%%zmm6,%%zmm6\n\t"
+			     "vmovntdq %%zmm12,%6\n\t"
+			     "vpxorq %%zmm12,%%zmm12,%%zmm12\n\t"
+			     "vmovntdq %%zmm14,%7\n\t"
+			     "vpxorq %%zmm14,%%zmm14,%%zmm14\n\t"
+			     "vmovntdq %%zmm16,%8\n\t"
+			     "vpxorq %%zmm16,%%zmm16,%%zmm16\n\t"
+			     "vmovntdq %%zmm18,%9\n\t"
+			     "vpxorq %%zmm18,%%zmm18,%%zmm18\n\t"
+			     "vmovntdq %%zmm24,%10\n\t"
+			     "vpxorq %%zmm24,%%zmm24,%%zmm24\n\t"
+			     "vmovntdq %%zmm26,%11\n\t"
+			     "vpxorq %%zmm26,%%zmm26,%%zmm26\n\t"
+			     "vmovntdq %%zmm20,%12\n\t"
+			     "vpxorq %%zmm20,%%zmm20,%%zmm20\n\t"
+			     "vmovntdq %%zmm22,%13\n\t"
+			     "vpxorq %%zmm22,%%zmm22,%%zmm22\n\t"
+			     "vmovntdq %%zmm28,%14\n\t"
+			     "vpxorq %%zmm28,%%zmm28,%%zmm28\n\t"
+			     "vmovntdq %%zmm30,%15\n\t"
+			     "vpxorq %%zmm30,%%zmm30,%%zmm30"
+			     :
+			     : "m" (p[d]), "m" (p[d+64]), "m" (p[d+128]),
+			       "m" (p[d+192]), "m" (q[d]), "m" (q[d+64]),
+			       "m" (q[d+128]), "m" (q[d+192]), "m" (p[d+256]),
+			       "m" (p[d+320]), "m" (p[d+384]), "m" (p[d+448]),
+			       "m" (q[d+256]), "m" (q[d+320]), "m" (q[d+384]),
+			       "m" (q[d+448]));
+	}
+
+	asm volatile("sfence" : : : "memory");
+	kernel_fpu_end();
+}
+
+const struct raid6_calls raid6_avx512x8 = {
+	raid6_avx5128_gen_syndrome,
+	NULL,                   /* XOR not yet implemented */
+	raid6_have_avx512,
+	"avx512x8",
+	1                       /* Has cache hints */
+};
 #endif
 
 #endif /* CONFIG_AS_AVX512 */
-- 
1.9.1
