From: Gayatri Kammela <gayatri.kammela@intel.com>
Subject: [PATCH v2 6/6] (DO NOT APPLY) lib/raid6: Add unroll by 8 to AVX512 optimized xor_syndrome functions.
Date: Fri, 12 Aug 2016 18:03:24 -0700
Message-ID: <1471050204-26361-7-git-send-email-gayatri.kammela@intel.com>
References: <1471050204-26361-1-git-send-email-gayatri.kammela@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1471050204-26361-1-git-send-email-gayatri.kammela@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, linux-kernel@vger.kernel.org, ravi.v.shankar@intel.com, Gayatri Kammela <gayatri.kammela@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Megha Dey <megha.dey@linux.intel.com>
List-Id: linux-raid.ids

Optimize RAID6 xor_syndrome functions by further unrolling by 8 to take
advantage of all the 32 ZMM registers.

Note: In theory avx512 unroll by 8 xor_syndrome function should perfom
better than the rest of xor_syndrome functions, but it is outperformed
by avx512 unroll by 4 xor_syndrome function when tested in userspace.

This is posted for reference only, to allow others to make their own
experiments.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Megha Dey <megha.dey@linux.intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
---
 lib/raid6/avx512.c | 235 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 234 insertions(+), 1 deletion(-)

diff --git a/lib/raid6/avx512.c b/lib/raid6/avx512.c
index 221ce46362cf..59e67366a84d 100644
--- a/lib/raid6/avx512.c
+++ b/lib/raid6/avx512.c
@@ -729,9 +729,242 @@ static void raid6_avx5128_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_avx5128_xor_syndrome(int disks, int start, int stop,
+				       size_t bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	int d, z, z0;
+
+	z0 = stop;		/* P/Q right side optimization */
+	p = dptr[disks-2];	/* XOR parity */
+	q = dptr[disks-1];	/* RS syndrome */
+
+	kernel_fpu_begin();
+
+	asm volatile("vmovdqa64 %0,%%zmm0"
+		     : : "m" (raid6_avx512_constants.x1d[0]));
+
+	for (d = 0 ; d < bytes ; d += 512) {
+		asm volatile("vmovdqa64 %0,%%zmm4\n\t"
+			     "vmovdqa64 %1,%%zmm6\n\t"
+			     "vmovdqa64 %2,%%zmm12\n\t"
+			     "vmovdqa64 %3,%%zmm14\n\t"
+			     "vmovdqa64 %4,%%zmm20\n\t"
+			     "vmovdqa64 %5,%%zmm22\n\t"
+			     "vmovdqa64 %6,%%zmm28\n\t"
+			     "vmovdqa64 %7,%%zmm30\n\t"
+			     "vmovdqa64 %8,%%zmm2\n\t"
+			     "vmovdqa64 %9,%%zmm3\n\t"
+			     "vmovdqa64 %10,%%zmm10\n\t"
+			     "vmovdqa64 %11,%%zmm11\n\t"
+			     "vmovdqa64 %12,%%zmm16\n\t"
+			     "vmovdqa64 %13,%%zmm18\n\t"
+			     "vmovdqa64 %14,%%zmm24\n\t"
+			     "vmovdqa64 %15,%%zmm26\n\t"
+			     "vpxorq %%zmm4,%%zmm2,%%zmm2\n\t"
+			     "vpxorq %%zmm6,%%zmm3,%%zmm3\n\t"
+			     "vpxorq %%zmm12,%%zmm10,%%zmm10\n\t"
+			     "vpxorq %%zmm14,%%zmm11,%%zmm11\n\t"
+			     "vpxorq %%zmm20,%%zmm16,%%zmm16\n\t"
+			     "vpxorq %%zmm22,%%zmm18,%%zmm18\n\t"
+			     "vpxorq %%zmm28,%%zmm24,%%zmm24\n\t"
+			     "vpxorq %%zmm30,%%zmm26,%%zmm26"
+			     :
+			     : "m" (dptr[z0][d]), "m" (dptr[z0][d+64]),
+			       "m" (dptr[z0][d+128]), "m" (dptr[z0][d+192]),
+			       "m" (dptr[z0][d+256]), "m" (dptr[z0][d+320]),
+			       "m" (dptr[z0][d+384]), "m" (dptr[z0][d+448]),
+			       "m" (p[d]), "m" (p[d+64]), "m" (p[d+128]),
+			       "m" (p[d+192]), "m" (p[d+256]), "m" (p[d+320]),
+			       "m" (p[d+384]), "m" (p[d+448]));
+		/* P/Q data pages */
+		for (z = z0-1 ; z >= start ; z--) {
+			asm volatile("prefetchnta %0\n\t"
+				     "prefetchnta %2\n\t"
+				     "prefetchnta %4\n\t"
+				     "prefetchnta %6\n\t"
+				     "vpxorq %%zmm21,%%zmm21,%%zmm21\n\t"
+				     "vpxorq %%zmm23,%%zmm23,%%zmm23\n\t"
+				     "vpxorq %%zmm29,%%zmm29,%%zmm29\n\t"
+				     "vpxorq %%zmm31,%%zmm31,%%zmm31\n\t"
+				     "vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
+				     "vpxorq %%zmm7,%%zmm7,%%zmm7\n\t"
+				     "vpxorq %%zmm13,%%zmm13,%%zmm13\n\t"
+				     "vpxorq %%zmm15,%%zmm15,%%zmm15\n\t"
+				     "vpcmpgtb %%zmm4,%%zmm5,%%k1\n\t"
+				     "vpcmpgtb %%zmm6,%%zmm7,%%k2\n\t"
+				     "vpcmpgtb %%zmm12,%%zmm13,%%k3\n\t"
+				     "vpcmpgtb %%zmm14,%%zmm15,%%k4\n\t"
+				     "vpmovm2b %%k1,%%zmm5\n\t"
+				     "vpmovm2b %%k2,%%zmm7\n\t"
+				     "vpmovm2b %%k3,%%zmm13\n\t"
+				     "vpmovm2b %%k4,%%zmm15\n\t"
+				     "vpcmpgtb %%zmm20,%%zmm21,%%k5\n\t"
+				     "vpcmpgtb %%zmm22,%%zmm23,%%k6\n\t"
+				     "vpcmpgtb %%zmm28,%%zmm29,%%k7\n\t"
+				     "vpcmpgtb %%zmm30,%%zmm31,%%k1\n\t"
+				     "vpmovm2b %%k5,%%zmm21\n\t"
+				     "vpmovm2b %%k6,%%zmm23\n\t"
+				     "vpmovm2b %%k7,%%zmm29\n\t"
+				     "vpmovm2b %%k1,%%zmm31\n\t"
+				     "vpaddb %%zmm4,%%zmm4,%%zmm4\n\t"
+				     "vpaddb %%zmm6,%%zmm6,%%zmm6\n\t"
+				     "vpaddb %%zmm12,%%zmm12,%%zmm12\n\t"
+				     "vpaddb %%zmm14,%%zmm14,%%zmm14\n\t"
+				     "vpaddb %%zmm20,%%zmm20,%%zmm20\n\t"
+				     "vpaddb %%zmm22,%%zmm22,%%zmm22\n\t"
+				     "vpaddb %%zmm28,%%zmm28,%%zmm28\n\t"
+				     "vpaddb %%zmm30,%%zmm30,%%zmm30\n\t"
+				     "vpandq %%zmm0,%%zmm5,%%zmm5\n\t"
+				     "vpandq %%zmm0,%%zmm7,%%zmm7\n\t"
+				     "vpandq %%zmm0,%%zmm13,%%zmm13\n\t"
+				     "vpandq %%zmm0,%%zmm15,%%zmm15\n\t"
+				     "vpandq %%zmm0,%%zmm21,%%zmm21\n\t"
+				     "vpandq %%zmm0,%%zmm23,%%zmm23\n\t"
+				     "vpandq %%zmm0,%%zmm29,%%zmm29\n\t"
+				     "vpandq %%zmm0,%%zmm31,%%zmm31\n\t"
+				     "vpxorq %%zmm5,%%zmm4,%%zmm4\n\t"
+				     "vpxorq %%zmm7,%%zmm6,%%zmm6\n\t"
+				     "vpxorq %%zmm13,%%zmm12,%%zmm12\n\t"
+				     "vpxorq %%zmm15,%%zmm14,%%zmm14\n\t"
+				     "vpxorq %%zmm21,%%zmm20,%%zmm20\n\t"
+				     "vpxorq %%zmm23,%%zmm22,%%zmm22\n\t"
+				     "vpxorq %%zmm29,%%zmm28,%%zmm28\n\t"
+				     "vpxorq %%zmm31,%%zmm30,%%zmm30\n\t"
+				     "vmovdqa64 %0,%%zmm5\n\t"
+				     "vmovdqa64 %1,%%zmm7\n\t"
+				     "vmovdqa64 %2,%%zmm13\n\t"
+				     "vmovdqa64 %3,%%zmm15\n\t"
+				     "vmovdqa64 %4,%%zmm21\n\t"
+				     "vmovdqa64 %5,%%zmm23\n\t"
+				     "vmovdqa64 %6,%%zmm29\n\t"
+				     "vmovdqa64 %7,%%zmm31\n\t"
+				     "vpxorq %%zmm5,%%zmm2,%%zmm2\n\t"
+				     "vpxorq %%zmm7,%%zmm3,%%zmm3\n\t"
+				     "vpxorq %%zmm13,%%zmm10,%%zmm10\n\t"
+				     "vpxorq %%zmm15,%%zmm11,%%zmm11\n\t"
+				     "vpxorq %%zmm21,%%zmm16,%%zmm16\n\t"
+				     "vpxorq %%zmm23,%%zmm18,%%zmm18\n\t"
+				     "vpxorq %%zmm29,%%zmm24,%%zmm24\n\t"
+				     "vpxorq %%zmm31,%%zmm26,%%zmm26\n\t"
+				     "vpxorq %%zmm5,%%zmm4,%%zmm4\n\t"
+				     "vpxorq %%zmm7,%%zmm6,%%zmm6\n\t"
+				     "vpxorq %%zmm13,%%zmm12,%%zmm12\n\t"
+				     "vpxorq %%zmm15,%%zmm14,%%zmm14\n\t"
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
+		asm volatile("prefetchnta %0\n\t"
+			     "prefetchnta %1\n\t"
+			     "prefetchnta %2\n\t"
+			     "prefetchnta %3"
+			     :
+			     : "m" (q[d]), "m" (q[d+128]), "m" (q[d+256]),
+			       "m" (q[d+384]));
+		/* P/Q left side optimization */
+		for (z = start-1 ; z >= 0 ; z--) {
+			asm volatile("vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
+				     "vpxorq %%zmm7,%%zmm7,%%zmm7\n\t"
+				     "vpxorq %%zmm13,%%zmm13,%%zmm13\n\t"
+				     "vpxorq %%zmm15,%%zmm15,%%zmm15\n\t"
+				     "vpxorq %%zmm21,%%zmm21,%%zmm21\n\t"
+				     "vpxorq %%zmm23,%%zmm23,%%zmm23\n\t"
+				     "vpxorq %%zmm29,%%zmm29,%%zmm29\n\t"
+				     "vpxorq %%zmm31,%%zmm31,%%zmm31\n\t"
+				     "vpcmpgtb %%zmm4,%%zmm5,%%k1\n\t"
+				     "vpcmpgtb %%zmm6,%%zmm7,%%k2\n\t"
+				     "vpcmpgtb %%zmm12,%%zmm13,%%k3\n\t"
+				     "vpcmpgtb %%zmm14,%%zmm15,%%k4\n\t"
+				     "vpmovm2b %%k1,%%zmm5\n\t"
+				     "vpmovm2b %%k2,%%zmm7\n\t"
+				     "vpmovm2b %%k3,%%zmm13\n\t"
+				     "vpmovm2b %%k4,%%zmm15\n\t"
+				     "vpcmpgtb %%zmm20,%%zmm21,%%k5\n\t"
+				     "vpcmpgtb %%zmm22,%%zmm23,%%k6\n\t"
+				     "vpcmpgtb %%zmm28,%%zmm29,%%k7\n\t"
+				     "vpcmpgtb %%zmm30,%%zmm31,%%k1\n\t"
+				     "vpmovm2b %%k5,%%zmm21\n\t"
+				     "vpmovm2b %%k6,%%zmm23\n\t"
+				     "vpmovm2b %%k7,%%zmm29\n\t"
+				     "vpmovm2b %%k1,%%zmm31\n\t"
+				     "vpaddb %%zmm4,%%zmm4,%%zmm4\n\t"
+				     "vpaddb %%zmm6,%%zmm6,%%zmm6\n\t"
+				     "vpaddb %%zmm12,%%zmm12,%%zmm12\n\t"
+				     "vpaddb %%zmm14,%%zmm14,%%zmm14\n\t"
+				     "vpaddb %%zmm20,%%zmm20,%%zmm20\n\t"
+				     "vpaddb %%zmm22,%%zmm22,%%zmm22\n\t"
+				     "vpaddb %%zmm28,%%zmm28,%%zmm28\n\t"
+				     "vpaddb %%zmm30,%%zmm30,%%zmm30\n\t"
+				     "vpandq %%zmm0,%%zmm5,%%zmm5\n\t"
+				     "vpandq %%zmm0,%%zmm7,%%zmm7\n\t"
+				     "vpandq %%zmm0,%%zmm13,%%zmm13\n\t"
+				     "vpandq %%zmm0,%%zmm15,%%zmm15\n\t"
+				     "vpandq %%zmm0,%%zmm21,%%zmm21\n\t"
+				     "vpandq %%zmm0,%%zmm23,%%zmm23\n\t"
+				     "vpandq %%zmm0,%%zmm29,%%zmm29\n\t"
+				     "vpandq %%zmm0,%%zmm31,%%zmm31\n\t"
+				     "vpxorq %%zmm5,%%zmm4,%%zmm4\n\t"
+				     "vpxorq %%zmm7,%%zmm6,%%zmm6\n\t"
+				     "vpxorq %%zmm13,%%zmm12,%%zmm12\n\t"
+				     "vpxorq %%zmm15,%%zmm14,%%zmm14\n\t"
+				     "vpxorq %%zmm21,%%zmm20,%%zmm20\n\t"
+				     "vpxorq %%zmm23,%%zmm22,%%zmm22\n\t"
+				     "vpxorq %%zmm29,%%zmm28,%%zmm28\n\t"
+				     "vpxorq %%zmm31,%%zmm30,%%zmm30"
+				     :
+				     : );
+		}
+		asm volatile("vmovntdq %%zmm2,%0\n\t"
+			     "vmovntdq %%zmm3,%1\n\t"
+			     "vmovntdq %%zmm10,%2\n\t"
+			     "vmovntdq %%zmm11,%3\n\t"
+			     "vmovntdq %%zmm16,%4\n\t"
+			     "vmovntdq %%zmm18,%5\n\t"
+			     "vmovntdq %%zmm24,%6\n\t"
+			     "vmovntdq %%zmm26,%7"
+			     :
+			     : "m" (p[d]),  "m" (p[d+64]),  "m" (p[d+128]),
+			       "m" (p[d+192]), "m" (p[d+256]),  "m" (p[d+320]),
+			       "m" (p[d+384]), "m" (p[d+448]));
+		asm volatile("vpxorq %0,%%zmm4,%%zmm4\n\t"
+			     "vpxorq %1,%%zmm6,%%zmm6\n\t"
+			     "vpxorq %2,%%zmm12,%%zmm12\n\t"
+			     "vpxorq %3,%%zmm14,%%zmm14\n\t"
+			     "vpxorq %4,%%zmm20,%%zmm20\n\t"
+			     "vpxorq %5,%%zmm22,%%zmm22\n\t"
+			     "vpxorq %6,%%zmm28,%%zmm28\n\t"
+			     "vpxorq %7,%%zmm30,%%zmm30\n\t"
+			     "vmovntdq %%zmm4,%0\n\t"
+			     "vmovntdq %%zmm6,%1\n\t"
+			     "vmovntdq %%zmm12,%2\n\t"
+			     "vmovntdq %%zmm14,%3\n\t"
+			     "vmovntdq %%zmm20,%4\n\t"
+			     "vmovntdq %%zmm22,%5\n\t"
+			     "vmovntdq %%zmm28,%6\n\t"
+			     "vmovntdq %%zmm30,%7"
+			     :
+			     : "m" (q[d]), "m" (q[d+64]), "m" (q[d+128]),
+			       "m" (q[d+192]), "m" (q[d+256]), "m" (q[d+320]),
+			       "m" (q[d+384]), "m" (q[d+448]));
+	}
+	asm volatile("sfence" : : : "memory");
+	kernel_fpu_end();
+}
+
 const struct raid6_calls raid6_avx512x8 = {
 	raid6_avx5128_gen_syndrome,
-	NULL,                   /* XOR not yet implemented */
+	raid6_avx5128_xor_syndrome,
 	raid6_have_avx512,
 	"avx512x8",
 	1                       /* Has cache hints */
-- 
2.7.4

