Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79681D799D;
	Fri, 11 Jul 2025 10:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228932; cv=none; b=QMgicXfjHo1KZeuDqpaODAJFQVfUq+JIZb1jypE+dEf6QBJpcUujWmLIeeK9+w7eyAOd5rxRBJoxpM4Pgc4aTCDJNhN+QKafxoHHOgHOZkfZmlh0k4Ax5fuBJFcxOdqyKskiZADc2owuqFWWmJqbMD4jctkXUeEqUIyQjsAwdfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228932; c=relaxed/simple;
	bh=6ndb9oIpeszOCJduEIXzuAg97HAel/J2V19jXBASrZ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QCc5VXwL2AD1VnaKHkO+Gyv9dPdsi6G80VyOoVYbQEfujKrmvQB1Vos9QklCb8fgruGW2/z9VcKG1rX9GCqF4V8q/ANzuiwvn7KvpYfvRH84tkOzoIzxrUoUFJoF0TwPU2oBRxP+KKAr3SFAyYq7k9KmS5pMAliW6vQlrdEKtoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ubt.. (unknown [210.73.43.2])
	by APP-03 (Coremail) with SMTP id rQCowACXJ3nj4nBo8xESAw--.40582S6;
	Fri, 11 Jul 2025 18:09:40 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-riscv@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH V2 4/5] raid6: riscv: Allow code to be compiled in userspace
Date: Fri, 11 Jul 2025 18:09:29 +0800
Message-Id: <20250711100930.3398336-5-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250711100930.3398336-1-zhangchunyan@iscas.ac.cn>
References: <20250711100930.3398336-1-zhangchunyan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACXJ3nj4nBo8xESAw--.40582S6
X-Coremail-Antispam: 1UD129KBjvAXoWfZw13GrW3tF4kXrW8Jr18Zrb_yoW8ZF18Ko
	Zxuw4Ut3s7Aw15Aws8JFWxWr1jgr12kwnYyrs0kr48Cas8tr13GrZFkayDWayYqF90kw17
	ta45K3Wvga4aqas3n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUOf7k0a2IF6w4kM7kC6x804xWl14x267AKxVWrJVCq3wAFc2x0
	x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87
	I2jVAFwI0_JF0E3s1l82xGYIkIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2
	F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjx
	v20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E
	87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
	kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW2oVWaowAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI
	1lc7CjxVAaw2AFwI0_Jw0_GFylc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7
	xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_
	Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07bnUDAUUUUU=
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAYAB2hw2rUeFAAAsw

To support userspace raid6test, this patch adds __KERNEL__ ifdef for kernel
header inclusions also userspace wrapper definitions to allow code to be
compiled in userspace.

This patch also drops the NSIZE macro, instead of using the vector length,
which can work for both kernel and user space.

Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 lib/raid6/recov_rvv.c |   7 +-
 lib/raid6/rvv.c       | 297 +++++++++++++++++++++---------------------
 lib/raid6/rvv.h       |  17 +++
 3 files changed, 170 insertions(+), 151 deletions(-)

diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
index 500da521a806..8f2be833c015 100644
--- a/lib/raid6/recov_rvv.c
+++ b/lib/raid6/recov_rvv.c
@@ -4,13 +4,8 @@
  * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
  */
 
-#include <asm/vector.h>
 #include <linux/raid/pq.h>
-
-static int rvv_has_vector(void)
-{
-	return has_vector();
-}
+#include "rvv.h"
 
 static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
 				    u8 *dq, const u8 *pbmul,
diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
index 015f3ee4da25..75c9dafedb28 100644
--- a/lib/raid6/rvv.c
+++ b/lib/raid6/rvv.c
@@ -9,17 +9,8 @@
  *	Copyright 2002-2004 H. Peter Anvin
  */
 
-#include <asm/vector.h>
-#include <linux/raid/pq.h>
 #include "rvv.h"
 
-#define NSIZE	(riscv_v_vsize / 32) /* NSIZE = vlenb */
-
-static int rvv_has_vector(void)
-{
-	return has_vector();
-}
-
 #ifdef __riscv_vector
 #error "This code must be built without compiler support for vector"
 #endif
@@ -28,7 +19,7 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
 {
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
-	unsigned long vl, d;
+	unsigned long vl, d, nsize;
 	int z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
@@ -42,8 +33,10 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
 		      : "=&r" (vl)
 	);
 
+	nsize = vl;
+
 	 /* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
-	for (d = 0; d < bytes; d += NSIZE * 1) {
+	for (d = 0; d < bytes; d += nsize * 1) {
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
@@ -51,7 +44,7 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
 			      "vmv.v.v	v1, v0\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE])
+			      [wp0]"r"(&dptr[z0][d + 0 * nsize])
 		);
 
 		for (z = z0 - 1 ; z >= 0 ; z--) {
@@ -75,7 +68,7 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
 				      "vxor.vv	v0, v0, v2\n"
 				      ".option	pop\n"
 				      : :
-				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
+				      [wd0]"r"(&dptr[z][d + 0 * nsize]),
 				      [x1d]"r"(0x1d)
 			);
 		}
@@ -90,8 +83,8 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
 			      "vse8.v	v1, (%[wq0])\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&p[d + NSIZE * 0]),
-			      [wq0]"r"(&q[d + NSIZE * 0])
+			      [wp0]"r"(&p[d + nsize * 0]),
+			      [wq0]"r"(&q[d + nsize * 0])
 		);
 	}
 }
@@ -101,7 +94,7 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
 {
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
-	unsigned long vl, d;
+	unsigned long vl, d, nsize;
 	int z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
@@ -115,8 +108,10 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
 		      : "=&r" (vl)
 	);
 
+	nsize = vl;
+
 	/* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
-	for (d = 0 ; d < bytes ; d += NSIZE * 1) {
+	for (d = 0 ; d < bytes ; d += nsize * 1) {
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
@@ -124,7 +119,7 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
 			      "vmv.v.v	v1, v0\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE])
+			      [wp0]"r"(&dptr[z0][d + 0 * nsize])
 		);
 
 		/* P/Q data pages */
@@ -149,7 +144,7 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
 				      "vxor.vv	v0, v0, v2\n"
 				      ".option	pop\n"
 				      : :
-				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
+				      [wd0]"r"(&dptr[z][d + 0 * nsize]),
 				      [x1d]"r"(0x1d)
 			);
 		}
@@ -189,8 +184,8 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
 			      "vse8.v	v3, (%[wq0])\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&p[d + NSIZE * 0]),
-			      [wq0]"r"(&q[d + NSIZE * 0])
+			      [wp0]"r"(&p[d + nsize * 0]),
+			      [wq0]"r"(&q[d + nsize * 0])
 		);
 	}
 }
@@ -199,7 +194,7 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
 {
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
-	unsigned long vl, d;
+	unsigned long vl, d, nsize;
 	int z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
@@ -213,11 +208,13 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
 		      : "=&r" (vl)
 	);
 
+	nsize = vl;
+
 	/*
 	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
 	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
 	 */
-	for (d = 0; d < bytes; d += NSIZE * 2) {
+	for (d = 0; d < bytes; d += nsize * 2) {
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
@@ -227,8 +224,8 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
 			      "vmv.v.v	v5, v4\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
-			      [wp1]"r"(&dptr[z0][d + 1 * NSIZE])
+			      [wp0]"r"(&dptr[z0][d + 0 * nsize]),
+			      [wp1]"r"(&dptr[z0][d + 1 * nsize])
 		);
 
 		for (z = z0 - 1; z >= 0; z--) {
@@ -260,8 +257,8 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
 				      "vxor.vv	v4, v4, v6\n"
 				      ".option	pop\n"
 				      : :
-				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
-				      [wd1]"r"(&dptr[z][d + 1 * NSIZE]),
+				      [wd0]"r"(&dptr[z][d + 0 * nsize]),
+				      [wd1]"r"(&dptr[z][d + 1 * nsize]),
 				      [x1d]"r"(0x1d)
 			);
 		}
@@ -278,10 +275,10 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
 			      "vse8.v	v5, (%[wq1])\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&p[d + NSIZE * 0]),
-			      [wq0]"r"(&q[d + NSIZE * 0]),
-			      [wp1]"r"(&p[d + NSIZE * 1]),
-			      [wq1]"r"(&q[d + NSIZE * 1])
+			      [wp0]"r"(&p[d + nsize * 0]),
+			      [wq0]"r"(&q[d + nsize * 0]),
+			      [wp1]"r"(&p[d + nsize * 1]),
+			      [wq1]"r"(&q[d + nsize * 1])
 		);
 	}
 }
@@ -291,7 +288,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 {
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
-	unsigned long vl, d;
+	unsigned long vl, d, nsize;
 	int z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
@@ -305,11 +302,13 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 		      : "=&r" (vl)
 	);
 
+	nsize = vl;
+
 	/*
 	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
 	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
 	 */
-	for (d = 0; d < bytes; d += NSIZE * 2) {
+	for (d = 0; d < bytes; d += nsize * 2) {
 		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
@@ -319,8 +318,8 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 			      "vmv.v.v	v5, v4\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
-			      [wp1]"r"(&dptr[z0][d + 1 * NSIZE])
+			      [wp0]"r"(&dptr[z0][d + 0 * nsize]),
+			      [wp1]"r"(&dptr[z0][d + 1 * nsize])
 		);
 
 		/* P/Q data pages */
@@ -353,8 +352,8 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 				      "vxor.vv	v4, v4, v6\n"
 				      ".option	pop\n"
 				      : :
-				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
-				      [wd1]"r"(&dptr[z][d + 1 * NSIZE]),
+				      [wd0]"r"(&dptr[z][d + 0 * nsize]),
+				      [wd1]"r"(&dptr[z][d + 1 * nsize]),
 				      [x1d]"r"(0x1d)
 			);
 		}
@@ -407,10 +406,10 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 			      "vse8.v	v7, (%[wq1])\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&p[d + NSIZE * 0]),
-			      [wq0]"r"(&q[d + NSIZE * 0]),
-			      [wp1]"r"(&p[d + NSIZE * 1]),
-			      [wq1]"r"(&q[d + NSIZE * 1])
+			      [wp0]"r"(&p[d + nsize * 0]),
+			      [wq0]"r"(&q[d + nsize * 0]),
+			      [wp1]"r"(&p[d + nsize * 1]),
+			      [wq1]"r"(&q[d + nsize * 1])
 		);
 	}
 }
@@ -419,7 +418,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 {
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
-	unsigned long vl, d;
+	unsigned long vl, d, nsize;
 	int z, z0;
 
 	z0 = disks - 3;	/* Highest data disk */
@@ -433,13 +432,15 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 		      : "=&r" (vl)
 	);
 
+	nsize = vl;
+
 	/*
 	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
 	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
 	 * v8:wp2, v9:wq2, v10:wd2/w22, v11:w12
 	 * v12:wp3, v13:wq3, v14:wd3/w23, v15:w13
 	 */
-	for (d = 0; d < bytes; d += NSIZE * 4) {
+	for (d = 0; d < bytes; d += nsize * 4) {
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
@@ -453,10 +454,10 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 			      "vmv.v.v	v13, v12\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
-			      [wp1]"r"(&dptr[z0][d + 1 * NSIZE]),
-			      [wp2]"r"(&dptr[z0][d + 2 * NSIZE]),
-			      [wp3]"r"(&dptr[z0][d + 3 * NSIZE])
+			      [wp0]"r"(&dptr[z0][d + 0 * nsize]),
+			      [wp1]"r"(&dptr[z0][d + 1 * nsize]),
+			      [wp2]"r"(&dptr[z0][d + 2 * nsize]),
+			      [wp3]"r"(&dptr[z0][d + 3 * nsize])
 		);
 
 		for (z = z0 - 1; z >= 0; z--) {
@@ -504,10 +505,10 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 				      "vxor.vv	v12, v12, v14\n"
 				      ".option	pop\n"
 				      : :
-				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
-				      [wd1]"r"(&dptr[z][d + 1 * NSIZE]),
-				      [wd2]"r"(&dptr[z][d + 2 * NSIZE]),
-				      [wd3]"r"(&dptr[z][d + 3 * NSIZE]),
+				      [wd0]"r"(&dptr[z][d + 0 * nsize]),
+				      [wd1]"r"(&dptr[z][d + 1 * nsize]),
+				      [wd2]"r"(&dptr[z][d + 2 * nsize]),
+				      [wd3]"r"(&dptr[z][d + 3 * nsize]),
 				      [x1d]"r"(0x1d)
 			);
 		}
@@ -528,14 +529,14 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 			      "vse8.v	v13, (%[wq3])\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&p[d + NSIZE * 0]),
-			      [wq0]"r"(&q[d + NSIZE * 0]),
-			      [wp1]"r"(&p[d + NSIZE * 1]),
-			      [wq1]"r"(&q[d + NSIZE * 1]),
-			      [wp2]"r"(&p[d + NSIZE * 2]),
-			      [wq2]"r"(&q[d + NSIZE * 2]),
-			      [wp3]"r"(&p[d + NSIZE * 3]),
-			      [wq3]"r"(&q[d + NSIZE * 3])
+			      [wp0]"r"(&p[d + nsize * 0]),
+			      [wq0]"r"(&q[d + nsize * 0]),
+			      [wp1]"r"(&p[d + nsize * 1]),
+			      [wq1]"r"(&q[d + nsize * 1]),
+			      [wp2]"r"(&p[d + nsize * 2]),
+			      [wq2]"r"(&q[d + nsize * 2]),
+			      [wp3]"r"(&p[d + nsize * 3]),
+			      [wq3]"r"(&q[d + nsize * 3])
 		);
 	}
 }
@@ -545,7 +546,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 {
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
-	unsigned long vl, d;
+	unsigned long vl, d, nsize;
 	int z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
@@ -559,13 +560,15 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 		      : "=&r" (vl)
 	);
 
+	nsize = vl;
+
 	/*
 	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
 	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
 	 * v8:wp2, v9:wq2, v10:wd2/w22, v11:w12
 	 * v12:wp3, v13:wq3, v14:wd3/w23, v15:w13
 	 */
-	for (d = 0; d < bytes; d += NSIZE * 4) {
+	for (d = 0; d < bytes; d += nsize * 4) {
 		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
@@ -579,10 +582,10 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 			      "vmv.v.v	v13, v12\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
-			      [wp1]"r"(&dptr[z0][d + 1 * NSIZE]),
-			      [wp2]"r"(&dptr[z0][d + 2 * NSIZE]),
-			      [wp3]"r"(&dptr[z0][d + 3 * NSIZE])
+			      [wp0]"r"(&dptr[z0][d + 0 * nsize]),
+			      [wp1]"r"(&dptr[z0][d + 1 * nsize]),
+			      [wp2]"r"(&dptr[z0][d + 2 * nsize]),
+			      [wp3]"r"(&dptr[z0][d + 3 * nsize])
 		);
 
 		/* P/Q data pages */
@@ -631,10 +634,10 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 				      "vxor.vv	v12, v12, v14\n"
 				      ".option	pop\n"
 				      : :
-				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
-				      [wd1]"r"(&dptr[z][d + 1 * NSIZE]),
-				      [wd2]"r"(&dptr[z][d + 2 * NSIZE]),
-				      [wd3]"r"(&dptr[z][d + 3 * NSIZE]),
+				      [wd0]"r"(&dptr[z][d + 0 * nsize]),
+				      [wd1]"r"(&dptr[z][d + 1 * nsize]),
+				      [wd2]"r"(&dptr[z][d + 2 * nsize]),
+				      [wd3]"r"(&dptr[z][d + 3 * nsize]),
 				      [x1d]"r"(0x1d)
 			);
 		}
@@ -713,14 +716,14 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 			      "vse8.v	v15, (%[wq3])\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&p[d + NSIZE * 0]),
-			      [wq0]"r"(&q[d + NSIZE * 0]),
-			      [wp1]"r"(&p[d + NSIZE * 1]),
-			      [wq1]"r"(&q[d + NSIZE * 1]),
-			      [wp2]"r"(&p[d + NSIZE * 2]),
-			      [wq2]"r"(&q[d + NSIZE * 2]),
-			      [wp3]"r"(&p[d + NSIZE * 3]),
-			      [wq3]"r"(&q[d + NSIZE * 3])
+			      [wp0]"r"(&p[d + nsize * 0]),
+			      [wq0]"r"(&q[d + nsize * 0]),
+			      [wp1]"r"(&p[d + nsize * 1]),
+			      [wq1]"r"(&q[d + nsize * 1]),
+			      [wp2]"r"(&p[d + nsize * 2]),
+			      [wq2]"r"(&q[d + nsize * 2]),
+			      [wp3]"r"(&p[d + nsize * 3]),
+			      [wq3]"r"(&q[d + nsize * 3])
 		);
 	}
 }
@@ -729,7 +732,7 @@ static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **
 {
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
-	unsigned long vl, d;
+	unsigned long vl, d, nsize;
 	int z, z0;
 
 	z0 = disks - 3;	/* Highest data disk */
@@ -743,6 +746,8 @@ static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **
 		      : "=&r" (vl)
 	);
 
+	nsize = vl;
+
 	/*
 	 * v0:wp0,   v1:wq0,  v2:wd0/w20,  v3:w10
 	 * v4:wp1,   v5:wq1,  v6:wd1/w21,  v7:w11
@@ -753,7 +758,7 @@ static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **
 	 * v24:wp6, v25:wq6, v26:wd6/w26, v27:w16
 	 * v28:wp7, v29:wq7, v30:wd7/w27, v31:w17
 	 */
-	for (d = 0; d < bytes; d += NSIZE * 8) {
+	for (d = 0; d < bytes; d += nsize * 8) {
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
@@ -775,14 +780,14 @@ static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **
 			      "vmv.v.v	v29, v28\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
-			      [wp1]"r"(&dptr[z0][d + 1 * NSIZE]),
-			      [wp2]"r"(&dptr[z0][d + 2 * NSIZE]),
-			      [wp3]"r"(&dptr[z0][d + 3 * NSIZE]),
-			      [wp4]"r"(&dptr[z0][d + 4 * NSIZE]),
-			      [wp5]"r"(&dptr[z0][d + 5 * NSIZE]),
-			      [wp6]"r"(&dptr[z0][d + 6 * NSIZE]),
-			      [wp7]"r"(&dptr[z0][d + 7 * NSIZE])
+			      [wp0]"r"(&dptr[z0][d + 0 * nsize]),
+			      [wp1]"r"(&dptr[z0][d + 1 * nsize]),
+			      [wp2]"r"(&dptr[z0][d + 2 * nsize]),
+			      [wp3]"r"(&dptr[z0][d + 3 * nsize]),
+			      [wp4]"r"(&dptr[z0][d + 4 * nsize]),
+			      [wp5]"r"(&dptr[z0][d + 5 * nsize]),
+			      [wp6]"r"(&dptr[z0][d + 6 * nsize]),
+			      [wp7]"r"(&dptr[z0][d + 7 * nsize])
 		);
 
 		for (z = z0 - 1; z >= 0; z--) {
@@ -862,14 +867,14 @@ static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **
 				      "vxor.vv	v28, v28, v30\n"
 				      ".option	pop\n"
 				      : :
-				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
-				      [wd1]"r"(&dptr[z][d + 1 * NSIZE]),
-				      [wd2]"r"(&dptr[z][d + 2 * NSIZE]),
-				      [wd3]"r"(&dptr[z][d + 3 * NSIZE]),
-				      [wd4]"r"(&dptr[z][d + 4 * NSIZE]),
-				      [wd5]"r"(&dptr[z][d + 5 * NSIZE]),
-				      [wd6]"r"(&dptr[z][d + 6 * NSIZE]),
-				      [wd7]"r"(&dptr[z][d + 7 * NSIZE]),
+				      [wd0]"r"(&dptr[z][d + 0 * nsize]),
+				      [wd1]"r"(&dptr[z][d + 1 * nsize]),
+				      [wd2]"r"(&dptr[z][d + 2 * nsize]),
+				      [wd3]"r"(&dptr[z][d + 3 * nsize]),
+				      [wd4]"r"(&dptr[z][d + 4 * nsize]),
+				      [wd5]"r"(&dptr[z][d + 5 * nsize]),
+				      [wd6]"r"(&dptr[z][d + 6 * nsize]),
+				      [wd7]"r"(&dptr[z][d + 7 * nsize]),
 				      [x1d]"r"(0x1d)
 			);
 		}
@@ -898,22 +903,22 @@ static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **
 			      "vse8.v	v29, (%[wq7])\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&p[d + NSIZE * 0]),
-			      [wq0]"r"(&q[d + NSIZE * 0]),
-			      [wp1]"r"(&p[d + NSIZE * 1]),
-			      [wq1]"r"(&q[d + NSIZE * 1]),
-			      [wp2]"r"(&p[d + NSIZE * 2]),
-			      [wq2]"r"(&q[d + NSIZE * 2]),
-			      [wp3]"r"(&p[d + NSIZE * 3]),
-			      [wq3]"r"(&q[d + NSIZE * 3]),
-			      [wp4]"r"(&p[d + NSIZE * 4]),
-			      [wq4]"r"(&q[d + NSIZE * 4]),
-			      [wp5]"r"(&p[d + NSIZE * 5]),
-			      [wq5]"r"(&q[d + NSIZE * 5]),
-			      [wp6]"r"(&p[d + NSIZE * 6]),
-			      [wq6]"r"(&q[d + NSIZE * 6]),
-			      [wp7]"r"(&p[d + NSIZE * 7]),
-			      [wq7]"r"(&q[d + NSIZE * 7])
+			      [wp0]"r"(&p[d + nsize * 0]),
+			      [wq0]"r"(&q[d + nsize * 0]),
+			      [wp1]"r"(&p[d + nsize * 1]),
+			      [wq1]"r"(&q[d + nsize * 1]),
+			      [wp2]"r"(&p[d + nsize * 2]),
+			      [wq2]"r"(&q[d + nsize * 2]),
+			      [wp3]"r"(&p[d + nsize * 3]),
+			      [wq3]"r"(&q[d + nsize * 3]),
+			      [wp4]"r"(&p[d + nsize * 4]),
+			      [wq4]"r"(&q[d + nsize * 4]),
+			      [wp5]"r"(&p[d + nsize * 5]),
+			      [wq5]"r"(&q[d + nsize * 5]),
+			      [wp6]"r"(&p[d + nsize * 6]),
+			      [wq6]"r"(&q[d + nsize * 6]),
+			      [wp7]"r"(&p[d + nsize * 7]),
+			      [wq7]"r"(&q[d + nsize * 7])
 		);
 	}
 }
@@ -923,7 +928,7 @@ static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
 {
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
-	unsigned long vl, d;
+	unsigned long vl, d, nsize;
 	int z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
@@ -937,6 +942,8 @@ static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
 		      : "=&r" (vl)
 	);
 
+	nsize = vl;
+
 	/*
 	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
 	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
@@ -947,7 +954,7 @@ static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
 	 * v24:wp6, v25:wq6, v26:wd6/w26, v27:w16
 	 * v28:wp7, v29:wq7, v30:wd7/w27, v31:w17
 	 */
-	for (d = 0; d < bytes; d += NSIZE * 8) {
+	for (d = 0; d < bytes; d += nsize * 8) {
 		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
@@ -969,14 +976,14 @@ static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
 			      "vmv.v.v	v29, v28\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
-			      [wp1]"r"(&dptr[z0][d + 1 * NSIZE]),
-			      [wp2]"r"(&dptr[z0][d + 2 * NSIZE]),
-			      [wp3]"r"(&dptr[z0][d + 3 * NSIZE]),
-			      [wp4]"r"(&dptr[z0][d + 4 * NSIZE]),
-			      [wp5]"r"(&dptr[z0][d + 5 * NSIZE]),
-			      [wp6]"r"(&dptr[z0][d + 6 * NSIZE]),
-			      [wp7]"r"(&dptr[z0][d + 7 * NSIZE])
+			      [wp0]"r"(&dptr[z0][d + 0 * nsize]),
+			      [wp1]"r"(&dptr[z0][d + 1 * nsize]),
+			      [wp2]"r"(&dptr[z0][d + 2 * nsize]),
+			      [wp3]"r"(&dptr[z0][d + 3 * nsize]),
+			      [wp4]"r"(&dptr[z0][d + 4 * nsize]),
+			      [wp5]"r"(&dptr[z0][d + 5 * nsize]),
+			      [wp6]"r"(&dptr[z0][d + 6 * nsize]),
+			      [wp7]"r"(&dptr[z0][d + 7 * nsize])
 		);
 
 		/* P/Q data pages */
@@ -1057,14 +1064,14 @@ static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
 				      "vxor.vv	v28, v28, v30\n"
 				      ".option	pop\n"
 				      : :
-				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
-				      [wd1]"r"(&dptr[z][d + 1 * NSIZE]),
-				      [wd2]"r"(&dptr[z][d + 2 * NSIZE]),
-				      [wd3]"r"(&dptr[z][d + 3 * NSIZE]),
-				      [wd4]"r"(&dptr[z][d + 4 * NSIZE]),
-				      [wd5]"r"(&dptr[z][d + 5 * NSIZE]),
-				      [wd6]"r"(&dptr[z][d + 6 * NSIZE]),
-				      [wd7]"r"(&dptr[z][d + 7 * NSIZE]),
+				      [wd0]"r"(&dptr[z][d + 0 * nsize]),
+				      [wd1]"r"(&dptr[z][d + 1 * nsize]),
+				      [wd2]"r"(&dptr[z][d + 2 * nsize]),
+				      [wd3]"r"(&dptr[z][d + 3 * nsize]),
+				      [wd4]"r"(&dptr[z][d + 4 * nsize]),
+				      [wd5]"r"(&dptr[z][d + 5 * nsize]),
+				      [wd6]"r"(&dptr[z][d + 6 * nsize]),
+				      [wd7]"r"(&dptr[z][d + 7 * nsize]),
 				      [x1d]"r"(0x1d)
 			);
 		}
@@ -1195,22 +1202,22 @@ static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
 			      "vse8.v	v31, (%[wq7])\n"
 			      ".option	pop\n"
 			      : :
-			      [wp0]"r"(&p[d + NSIZE * 0]),
-			      [wq0]"r"(&q[d + NSIZE * 0]),
-			      [wp1]"r"(&p[d + NSIZE * 1]),
-			      [wq1]"r"(&q[d + NSIZE * 1]),
-			      [wp2]"r"(&p[d + NSIZE * 2]),
-			      [wq2]"r"(&q[d + NSIZE * 2]),
-			      [wp3]"r"(&p[d + NSIZE * 3]),
-			      [wq3]"r"(&q[d + NSIZE * 3]),
-			      [wp4]"r"(&p[d + NSIZE * 4]),
-			      [wq4]"r"(&q[d + NSIZE * 4]),
-			      [wp5]"r"(&p[d + NSIZE * 5]),
-			      [wq5]"r"(&q[d + NSIZE * 5]),
-			      [wp6]"r"(&p[d + NSIZE * 6]),
-			      [wq6]"r"(&q[d + NSIZE * 6]),
-			      [wp7]"r"(&p[d + NSIZE * 7]),
-			      [wq7]"r"(&q[d + NSIZE * 7])
+			      [wp0]"r"(&p[d + nsize * 0]),
+			      [wq0]"r"(&q[d + nsize * 0]),
+			      [wp1]"r"(&p[d + nsize * 1]),
+			      [wq1]"r"(&q[d + nsize * 1]),
+			      [wp2]"r"(&p[d + nsize * 2]),
+			      [wq2]"r"(&q[d + nsize * 2]),
+			      [wp3]"r"(&p[d + nsize * 3]),
+			      [wq3]"r"(&q[d + nsize * 3]),
+			      [wp4]"r"(&p[d + nsize * 4]),
+			      [wq4]"r"(&q[d + nsize * 4]),
+			      [wp5]"r"(&p[d + nsize * 5]),
+			      [wq5]"r"(&q[d + nsize * 5]),
+			      [wp6]"r"(&p[d + nsize * 6]),
+			      [wq6]"r"(&q[d + nsize * 6]),
+			      [wp7]"r"(&p[d + nsize * 7]),
+			      [wq7]"r"(&q[d + nsize * 7])
 		);
 	}
 }
diff --git a/lib/raid6/rvv.h b/lib/raid6/rvv.h
index 94044a1b707b..6d0708a2c8a4 100644
--- a/lib/raid6/rvv.h
+++ b/lib/raid6/rvv.h
@@ -7,6 +7,23 @@
  * Definitions for RISC-V RAID-6 code
  */
 
+#ifdef __KERNEL__
+#include <asm/vector.h>
+#else
+#define kernel_vector_begin()
+#define kernel_vector_end()
+#include <sys/auxv.h>
+#include <asm/hwcap.h>
+#define has_vector() (getauxval(AT_HWCAP) & COMPAT_HWCAP_ISA_V)
+#endif
+
+#include <linux/raid/pq.h>
+
+static int rvv_has_vector(void)
+{
+	return has_vector();
+}
+
 #define RAID6_RVV_WRAPPER(_n)						\
 	static void raid6_rvv ## _n ## _gen_syndrome(int disks,		\
 					size_t bytes, void **ptrs)	\
-- 
2.34.1

