From: Gayatri Kammela <gayatri.kammela@intel.com>
Subject: [PATCH v2 4/6] lib/raid6: Add AVX512 optimized xor_syndrome functions
Date: Fri, 12 Aug 2016 18:03:22 -0700
Message-ID: <1471050204-26361-5-git-send-email-gayatri.kammela@intel.com>
References: <1471050204-26361-1-git-send-email-gayatri.kammela@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471050204-26361-1-git-send-email-gayatri.kammela@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, linux-kernel@vger.kernel.org, ravi.v.shankar@intel.com, Gayatri Kammela <gayatri.kammela@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Megha Dey <megha.dey@linux.intel.com>
List-Id: linux-raid.ids

Optimize RAID6 xor_syndrome functions to take advantage of the 512-bit
ZMM integer instructions introduced in AVX512.

AVX512 optimized xor_syndrome functions, which is simply based on sse2.c
written by hpa.

The patch was tested and benchmarked before submission on
a hardware that has AVX512 flags to support such instructions

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Megha Dey <megha.dey@linux.intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
---
 lib/raid6/avx512.c | 281 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 278 insertions(+), 3 deletions(-)

diff --git a/lib/raid6/avx512.c b/lib/raid6/avx512.c
index b1188a6e51a6..f524a7972006 100644
--- a/lib/raid6/avx512.c
+++ b/lib/raid6/avx512.c
@@ -103,9 +103,68 @@ static void raid6_avx5121_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_avx5121_xor_syndrome(int disks, int start, int stop,
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
+	for (d = 0 ; d < bytes ; d += 64) {
+		asm volatile("vmovdqa64 %0,%%zmm4\n\t"
+			     "vmovdqa64 %1,%%zmm2\n\t"
+			     "vpxorq %%zmm4,%%zmm2,%%zmm2"
+			     :
+			     : "m" (dptr[z0][d]),  "m" (p[d]));
+		/* P/Q data pages */
+		for (z = z0-1 ; z >= start ; z--) {
+			asm volatile("vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
+				     "vpcmpgtb %%zmm4,%%zmm5,%%k1\n\t"
+				     "vpmovm2b %%k1,%%zmm5\n\t"
+				     "vpaddb %%zmm4,%%zmm4,%%zmm4\n\t"
+				     "vpandq %%zmm0,%%zmm5,%%zmm5\n\t"
+				     "vpxorq %%zmm5,%%zmm4,%%zmm4\n\t"
+				     "vmovdqa64 %0,%%zmm5\n\t"
+				     "vpxorq %%zmm5,%%zmm2,%%zmm2\n\t"
+				     "vpxorq %%zmm5,%%zmm4,%%zmm4"
+				     :
+				     : "m" (dptr[z][d]));
+		}
+		/* P/Q left side optimization */
+		for (z = start-1 ; z >= 0 ; z--) {
+			asm volatile("vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
+				     "vpcmpgtb %%zmm4,%%zmm5,%%k1\n\t"
+				     "vpmovm2b %%k1,%%zmm5\n\t"
+				     "vpaddb %%zmm4,%%zmm4,%%zmm4\n\t"
+				     "vpandq %%zmm0,%%zmm5,%%zmm5\n\t"
+				     "vpxorq %%zmm5,%%zmm4,%%zmm4"
+				     :
+				     : );
+		}
+		asm volatile("vpxorq %0,%%zmm4,%%zmm4\n\t"
+		/* Don't use movntdq for r/w memory area < cache line */
+			     "vmovdqa64 %%zmm4,%0\n\t"
+			     "vmovdqa64 %%zmm2,%1"
+			     :
+			     : "m" (q[d]), "m" (p[d]));
+	}
+
+	asm volatile("sfence" : : : "memory");
+	kernel_fpu_end();
+}
+
 const struct raid6_calls raid6_avx512x1 = {
 	raid6_avx5121_gen_syndrome,
-	NULL,                   /* XOR not yet implemented */
+	raid6_avx5121_xor_syndrome,
 	raid6_have_avx512,
 	"avx512x1",
 	1                       /* Has cache hints */
@@ -176,9 +235,93 @@ static void raid6_avx5122_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
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
+	for (d = 0 ; d < bytes ; d += 128) {
+		asm volatile("vmovdqa64 %0,%%zmm4\n\t"
+			     "vmovdqa64 %1,%%zmm6\n\t"
+			     "vmovdqa64 %2,%%zmm2\n\t"
+			     "vmovdqa64 %3,%%zmm3\n\t"
+			     "vpxorq %%zmm4,%%zmm2,%%zmm2\n\t"
+			     "vpxorq %%zmm6,%%zmm3,%%zmm3"
+			     :
+			     : "m" (dptr[z0][d]), "m" (dptr[z0][d+64]),
+			       "m" (p[d]), "m" (p[d+64]));
+		/* P/Q data pages */
+		for (z = z0-1 ; z >= start ; z--) {
+			asm volatile("vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
+				     "vpxorq %%zmm7,%%zmm7,%%zmm7\n\t"
+				     "vpcmpgtb %%zmm4,%%zmm5,%%k1\n\t"
+				     "vpcmpgtb %%zmm6,%%zmm7,%%k2\n\t"
+				     "vpmovm2b %%k1,%%zmm5\n\t"
+				     "vpmovm2b %%k2,%%zmm7\n\t"
+				     "vpaddb %%zmm4,%%zmm4,%%zmm4\n\t"
+				     "vpaddb %%zmm6,%%zmm6,%%zmm6\n\t"
+				     "vpandq %%zmm0,%%zmm5,%%zmm5\n\t"
+				     "vpandq %%zmm0,%%zmm7,%%zmm7\n\t"
+				     "vpxorq %%zmm5,%%zmm4,%%zmm4\n\t"
+				     "vpxorq %%zmm7,%%zmm6,%%zmm6\n\t"
+				     "vmovdqa64 %0,%%zmm5\n\t"
+				     "vmovdqa64 %1,%%zmm7\n\t"
+				     "vpxorq %%zmm5,%%zmm2,%%zmm2\n\t"
+				     "vpxorq %%zmm7,%%zmm3,%%zmm3\n\t"
+				     "vpxorq %%zmm5,%%zmm4,%%zmm4\n\t"
+				     "vpxorq %%zmm7,%%zmm6,%%zmm6"
+				     :
+				     : "m" (dptr[z][d]),  "m" (dptr[z][d+64]));
+		}
+		/* P/Q left side optimization */
+		for (z = start-1 ; z >= 0 ; z--) {
+			asm volatile("vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
+				     "vpxorq %%zmm7,%%zmm7,%%zmm7\n\t"
+				     "vpcmpgtb %%zmm4,%%zmm5,%%k1\n\t"
+				     "vpcmpgtb %%zmm6,%%zmm7,%%k2\n\t"
+				     "vpmovm2b %%k1,%%zmm5\n\t"
+				     "vpmovm2b %%k2,%%zmm7\n\t"
+				     "vpaddb %%zmm4,%%zmm4,%%zmm4\n\t"
+				     "vpaddb %%zmm6,%%zmm6,%%zmm6\n\t"
+				     "vpandq %%zmm0,%%zmm5,%%zmm5\n\t"
+				     "vpandq %%zmm0,%%zmm7,%%zmm7\n\t"
+				     "vpxorq %%zmm5,%%zmm4,%%zmm4\n\t"
+				     "vpxorq %%zmm7,%%zmm6,%%zmm6"
+				     :
+				     : );
+		}
+		asm volatile("vpxorq %0,%%zmm4,%%zmm4\n\t"
+			     "vpxorq %1,%%zmm6,%%zmm6\n\t"
+			     /* Don't use movntdq for r/w
+			      * memory area < cache line
+			      */
+			     "vmovdqa64 %%zmm4,%0\n\t"
+			     "vmovdqa64 %%zmm6,%1\n\t"
+			     "vmovdqa64 %%zmm2,%2\n\t"
+			     "vmovdqa64 %%zmm3,%3"
+			     :
+			     : "m" (q[d]), "m" (q[d+64]), "m" (p[d]),
+			       "m" (p[d+64]));
+	}
+
+	asm volatile("sfence" : : : "memory");
+	kernel_fpu_end();
+}
+
 const struct raid6_calls raid6_avx512x2 = {
 	raid6_avx5122_gen_syndrome,
-	NULL,                   /* XOR not yet implemented */
+	raid6_avx5122_xor_syndrome,
 	raid6_have_avx512,
 	"avx512x2",
 	1                       /* Has cache hints */
@@ -282,9 +425,141 @@ static void raid6_avx5124_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
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
+		     :: "m" (raid6_avx512_constants.x1d[0]));
+
+	for (d = 0 ; d < bytes ; d += 256) {
+		asm volatile("vmovdqa64 %0,%%zmm4\n\t"
+			     "vmovdqa64 %1,%%zmm6\n\t"
+			     "vmovdqa64 %2,%%zmm12\n\t"
+			     "vmovdqa64 %3,%%zmm14\n\t"
+			     "vmovdqa64 %4,%%zmm2\n\t"
+			     "vmovdqa64 %5,%%zmm3\n\t"
+			     "vmovdqa64 %6,%%zmm10\n\t"
+			     "vmovdqa64 %7,%%zmm11\n\t"
+			     "vpxorq %%zmm4,%%zmm2,%%zmm2\n\t"
+			     "vpxorq %%zmm6,%%zmm3,%%zmm3\n\t"
+			     "vpxorq %%zmm12,%%zmm10,%%zmm10\n\t"
+			     "vpxorq %%zmm14,%%zmm11,%%zmm11"
+			     :
+			     : "m" (dptr[z0][d]), "m" (dptr[z0][d+64]),
+			       "m" (dptr[z0][d+128]), "m" (dptr[z0][d+192]),
+			       "m" (p[d]), "m" (p[d+64]), "m" (p[d+128]),
+			       "m" (p[d+192]));
+		/* P/Q data pages */
+		for (z = z0-1 ; z >= start ; z--) {
+			asm volatile("vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
+				     "vpxorq %%zmm7,%%zmm7,%%zmm7\n\t"
+				     "vpxorq %%zmm13,%%zmm13,%%zmm13\n\t"
+				     "vpxorq %%zmm15,%%zmm15,%%zmm15\n\t"
+				     "prefetchnta %0\n\t"
+				     "prefetchnta %2\n\t"
+				     "vpcmpgtb %%zmm4,%%zmm5,%%k1\n\t"
+				     "vpcmpgtb %%zmm6,%%zmm7,%%k2\n\t"
+				     "vpcmpgtb %%zmm12,%%zmm13,%%k3\n\t"
+				     "vpcmpgtb %%zmm14,%%zmm15,%%k4\n\t"
+				     "vpmovm2b %%k1,%%zmm5\n\t"
+				     "vpmovm2b %%k2,%%zmm7\n\t"
+				     "vpmovm2b %%k3,%%zmm13\n\t"
+				     "vpmovm2b %%k4,%%zmm15\n\t"
+				     "vpaddb %%zmm4,%%zmm4,%%zmm4\n\t"
+				     "vpaddb %%zmm6,%%zmm6,%%zmm6\n\t"
+				     "vpaddb %%zmm12,%%zmm12,%%zmm12\n\t"
+				     "vpaddb %%Zmm14,%%zmm14,%%zmm14\n\t"
+				     "vpandq %%zmm0,%%zmm5,%%zmm5\n\t"
+				     "vpandq %%zmm0,%%zmm7,%%zmm7\n\t"
+				     "vpandq %%zmm0,%%zmm13,%%zmm13\n\t"
+				     "vpandq %%zmm0,%%zmm15,%%zmm15\n\t"
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
+				     "vpxorq %%zmm15,%%zmm14,%%zmm14"
+				     :
+				     : "m" (dptr[z][d]), "m" (dptr[z][d+64]),
+				       "m" (dptr[z][d+128]),
+				       "m" (dptr[z][d+192]));
+		}
+		asm volatile("prefetchnta %0\n\t"
+			     "prefetchnta %1\n\t"
+			     :
+			     : "m" (q[d]), "m" (q[d+128]));
+		/* P/Q left side optimization */
+		for (z = start-1 ; z >= 0 ; z--) {
+			asm volatile("vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
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
+				     "vpaddb %%zmm4,%%zmm4,%%zmm4\n\t"
+				     "vpaddb %%zmm6,%%zmm6,%%zmm6\n\t"
+				     "vpaddb %%zmm12,%%zmm12,%%zmm12\n\t"
+				     "vpaddb %%zmm14,%%zmm14,%%zmm14\n\t"
+				     "vpandq %%zmm0,%%zmm5,%%zmm5\n\t"
+				     "vpandq %%zmm0,%%zmm7,%%zmm7\n\t"
+				     "vpandq %%zmm0,%%zmm13,%%zmm13\n\t"
+				     "vpandq %%zmm0,%%zmm15,%%zmm15\n\t"
+				     "vpxorq %%zmm5,%%zmm4,%%zmm4\n\t"
+				     "vpxorq %%zmm7,%%zmm6,%%zmm6\n\t"
+				     "vpxorq %%zmm13,%%zmm12,%%zmm12\n\t"
+				     "vpxorq %%zmm15,%%zmm14,%%zmm14"
+				     :
+				     : );
+		}
+		asm volatile("vmovntdq %%zmm2,%0\n\t"
+			     "vmovntdq %%zmm3,%1\n\t"
+			     "vmovntdq %%zmm10,%2\n\t"
+			     "vmovntdq %%zmm11,%3\n\t"
+			     "vpxorq %4,%%zmm4,%%zmm4\n\t"
+			     "vpxorq %5,%%zmm6,%%zmm6\n\t"
+			     "vpxorq %6,%%zmm12,%%zmm12\n\t"
+			     "vpxorq %7,%%zmm14,%%zmm14\n\t"
+			     "vmovntdq %%zmm4,%4\n\t"
+			     "vmovntdq %%zmm6,%5\n\t"
+			     "vmovntdq %%zmm12,%6\n\t"
+			     "vmovntdq %%zmm14,%7"
+			     :
+			     : "m" (p[d]),  "m" (p[d+64]), "m" (p[d+128]),
+			       "m" (p[d+192]), "m" (q[d]),  "m" (q[d+64]),
+			       "m" (q[d+128]), "m" (q[d+192]));
+	}
+	asm volatile("sfence" : : : "memory");
+	kernel_fpu_end();
+}
 const struct raid6_calls raid6_avx512x4 = {
 	raid6_avx5124_gen_syndrome,
-	NULL,                   /* XOR not yet implemented */
+	raid6_avx5124_xor_syndrome,
 	raid6_have_avx512,
 	"avx512x4",
 	1                       /* Has cache hints */
-- 
2.7.4
