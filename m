Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E421B85C5;
	Fri, 20 Dec 2024 11:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734695253; cv=none; b=bHXF1cGupeZHiMdmosvIrDn/aDPS3SMSrQ36SpEmZpzOqmwkdG8eZpbS6CiEJDCfJkdhCITursI2MwkMNu3ewEOCZ7PMo/U/HUQJ7sojTlaUdEivWmflCzHZiB1j0hgP+a0I1Gghtf6wuYvPYFs0oF70JZ9BJFoWQeP0+UX54vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734695253; c=relaxed/simple;
	bh=j1lBjMGo0repZhHGzNTMROmem+RajbDrP7VK6D3VV5k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Szg2ooAFkHgZ33sqRWhWtX/A3NkTofEF+hUKFhr5x2FW4NZLEQOcig4smfurZ15qzw+LtlT+Ay9P0P4MKDPy054F3HeA5kr0/2/3UFZlnfpzWrfSZ5Bro9ZleMNvUWO/ODUjIeYPGyVp5MXkoXNjovhETVX1MehRgb3MHLd13cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ubt.. (unknown [210.73.53.31])
	by APP-03 (Coremail) with SMTP id rQCowADnzjGxV2VnCDj9Ag--.49562S2;
	Fri, 20 Dec 2024 19:40:34 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-riscv@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [RFC PATCH] raid6: Add RISC-V SIMD syndrome and recovery calculations
Date: Fri, 20 Dec 2024 19:40:23 +0800
Message-Id: <20241220114023.667347-1-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADnzjGxV2VnCDj9Ag--.49562S2
X-Coremail-Antispam: 1UD129KBjvAXoWftFWfZr1xKw13tw4UWw1xKrg_yoW8Kw45Wo
	ZF9w18JFn7u345Xa4akFyUWr13Z34fKa1ktwsFvr48AFZaq3WYgrs7Kw4UGayavFn8Kw12
	vFy5Xw47Xw45twsxn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYn7k0a2IF6w4kM7kC6x804xWl14x267AKxVW8JVW5JwAFc2x0
	x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj4
	1l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0
	I7IYx2IY6xkF7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwV
	C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43
	MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
	0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
	wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
	W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
	cVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUgHanUUUUU
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiCRARB2dlSgIm5wAAsE

The assembly is originally based on the ARM NEON and int.uc, but uses
RISC-V vector instructions to implement the RAID6 syndrome and
recovery calculations.

The functions are tested on QEMU.

Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 include/linux/raid/pq.h |   4 +
 lib/raid6/Makefile      |   3 +
 lib/raid6/algos.c       |   8 +
 lib/raid6/recov_rvv.c   | 229 +++++++++++++
 lib/raid6/rvv.c         | 715 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 959 insertions(+)
 create mode 100644 lib/raid6/recov_rvv.c
 create mode 100644 lib/raid6/rvv.c

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 98030accf641..4c21f06c662a 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -108,6 +108,9 @@ extern const struct raid6_calls raid6_vpermxor4;
 extern const struct raid6_calls raid6_vpermxor8;
 extern const struct raid6_calls raid6_lsx;
 extern const struct raid6_calls raid6_lasx;
+extern const struct raid6_calls raid6_rvvx1;
+extern const struct raid6_calls raid6_rvvx2;
+extern const struct raid6_calls raid6_rvvx4;
 
 struct raid6_recov_calls {
 	void (*data2)(int, size_t, int, int, void **);
@@ -125,6 +128,7 @@ extern const struct raid6_recov_calls raid6_recov_s390xc;
 extern const struct raid6_recov_calls raid6_recov_neon;
 extern const struct raid6_recov_calls raid6_recov_lsx;
 extern const struct raid6_recov_calls raid6_recov_lasx;
+extern const struct raid6_recov_calls raid6_recov_rvv;
 
 extern const struct raid6_calls raid6_neonx1;
 extern const struct raid6_calls raid6_neonx2;
diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index 29127dd05d63..e62fb7cd773e 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -10,6 +10,9 @@ raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o altivec8.o \
 raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
 raid6_pq-$(CONFIG_S390) += s390vx8.o recov_s390xc.o
 raid6_pq-$(CONFIG_LOONGARCH) += loongarch_simd.o recov_loongarch_simd.o
+raid6_pq-$(CONFIG_RISCV_ISA_V) += rvv.o recov_rvv.o
+CFLAGS_rvv.o += -march=rv64gcv
+CFLAGS_recov_rvv.o += -march=rv64gcv
 
 hostprogs	+= mktables
 
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index cd2e88ee1f14..0a388a605131 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -80,6 +80,11 @@ const struct raid6_calls * const raid6_algos[] = {
 #ifdef CONFIG_CPU_HAS_LSX
 	&raid6_lsx,
 #endif
+#endif
+#ifdef CONFIG_RISCV_ISA_V
+	&raid6_rvvx1,
+	&raid6_rvvx2,
+	&raid6_rvvx4,
 #endif
 	&raid6_intx8,
 	&raid6_intx4,
@@ -115,6 +120,9 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
 #ifdef CONFIG_CPU_HAS_LSX
 	&raid6_recov_lsx,
 #endif
+#endif
+#ifdef CONFIG_RISCV_ISA_V
+	&raid6_recov_rvv,
 #endif
 	&raid6_recov_intx1,
 	NULL
diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
new file mode 100644
index 000000000000..8ae74803ea7f
--- /dev/null
+++ b/lib/raid6/recov_rvv.c
@@ -0,0 +1,229 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2024 Institute of Software, CAS.
+ * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
+ */
+
+#include <asm/simd.h>
+#include <asm/vector.h>
+#include <crypto/internal/simd.h>
+#include <linux/raid/pq.h>
+
+static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
+			      u8 *dq, const u8 *pbmul,
+			      const u8 *qmul)
+{
+	asm volatile (
+		".option	push\n"
+		".option	arch,+v\n"
+		"vsetvli	x0, %[avl], e8, m1, ta, ma\n"
+		: :
+		[avl]"r"(16)
+	);
+
+	/*
+	 * while ( bytes-- ) {
+	 *	uint8_t px, qx, db;
+	 *
+	 *	px	  = *p ^ *dp;
+	 *	qx	  = qmul[*q ^ *dq];
+	 *	*dq++ = db = pbmul[px] ^ qx;
+	 *	*dp++ = db ^ px;
+	 *	p++; q++;
+	 * }
+	 */
+	while (bytes) {
+		/*
+		 * v0:px, v1:dp,
+		 * v2:qx, v3:dq,
+		 * v4:vx, v5:vy,
+		 * v6:qm0, v7:qm1,
+		 * v8:pm0, v9:pm1,
+		 * v14:p/qm[vx], v15:p/qm[vy]
+		 */
+		asm volatile (
+			"vle8.v		v0, (%[px])\n"
+			"vle8.v		v1, (%[dp])\n"
+			"vxor.vv	v0, v0, v1\n"
+			"vle8.v		v2, (%[qx])\n"
+			"vle8.v		v3, (%[dq])\n"
+			"vxor.vv	v4, v2, v3\n"
+			"vsrl.vi	v5, v4, 4\n"
+			"vand.vi	v4, v4, 0xf\n"
+			"vle8.v		v6, (%[qm0])\n"
+			"vle8.v		v7, (%[qm1])\n"
+			"vrgather.vv	v14, v6, v4\n" /* v14 = qm[vx] */
+			"vrgather.vv	v15, v7, v5\n" /* v15 = qm[vy] */
+			"vxor.vv	v2, v14, v15\n" /* v2 = qmul[*q ^ *dq] */
+
+			"vsrl.vi	v5, v0, 4\n"
+			"vand.vi	v4, v0, 0xf\n"
+			"vle8.v		v8, (%[pm0])\n"
+			"vle8.v		v9, (%[pm1])\n"
+			"vrgather.vv	v14, v8, v4\n" /* v14 = pm[vx] */
+			"vrgather.vv	v15, v9, v5\n" /* v15 = pm[vy] */
+			"vxor.vv	v4, v14, v15\n" /* v4 = pbmul[px] */
+			"vxor.vv	v3, v4, v2\n" /* v3 = db = pbmul[px] ^ qx */
+			"vxor.vv	v1, v3, v0\n" /* v1 = db ^ px; */
+			"vse8.v		v3, (%[dq])\n"
+			"vse8.v		v1, (%[dp])\n"
+			: :
+			[px]"r"(p),
+			[dp]"r"(dp),
+			[qx]"r"(q),
+			[dq]"r"(dq),
+			[qm0]"r"(qmul),
+			[qm1]"r"(qmul + 16),
+			[pm0]"r"(pbmul),
+			[pm1]"r"(pbmul + 16)
+			:);
+
+		bytes -= 16;
+		p += 16;
+		q += 16;
+		dp += 16;
+		dq += 16;
+	}
+
+	asm volatile (".option pop\n");
+}
+
+static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, uint8_t *dq,
+			      const uint8_t *qmul)
+{
+	asm volatile (
+		".option	push\n"
+		".option	arch,+v\n"
+		"vsetvli	x0, %[avl], e8, m1, ta, ma\n"
+		: :
+		[avl]"r"(16)
+	);
+
+	/*
+	 * while (bytes--) {
+	 *  *p++ ^= *dq = qmul[*q ^ *dq];
+	 *  q++; dq++;
+	 * }
+	 */
+	while (bytes) {
+		/*
+		 * v0:vx, v1:vy,
+		 * v2:dq, v3:p,
+		 * v4:qm0, v5:qm1,
+		 * v10:m[vx], v11:m[vy]
+		 */
+		asm volatile (
+			"vle8.v		v0, (%[vx])\n"
+			"vle8.v		v2, (%[dq])\n"
+			"vxor.vv	v0, v0, v2\n"
+			"vsrl.vi	v1, v0, 4\n"
+			"vand.vi	v0, v0, 0xf\n"
+			"vle8.v		v4, (%[qm0])\n"
+			"vle8.v		v5, (%[qm1])\n"
+			"vrgather.vv	v10, v4, v0\n"
+			"vrgather.vv	v11, v5, v1\n"
+			"vxor.vv	v0, v10, v11\n"
+			"vle8.v		v1, (%[vy])\n"
+			"vxor.vv	v1, v0, v1\n"
+			"vse8.v		v0, (%[dq])\n"
+			"vse8.v		v1, (%[vy])\n"
+			: :
+			[vx]"r"(q),
+			[vy]"r"(p),
+			[dq]"r"(dq),
+			[qm0]"r"(qmul),
+			[qm1]"r"(qmul + 16)
+			:);
+
+		bytes -= 16;
+		p += 16;
+		q += 16;
+		dq += 16;
+	}
+
+	asm volatile (".option pop\n");
+}
+
+
+static void raid6_2data_recov_rvv(int disks, size_t bytes, int faila,
+		int failb, void **ptrs)
+{
+	u8 *p, *q, *dp, *dq;
+	const u8 *pbmul;	/* P multiplier table for B data */
+	const u8 *qmul;		/* Q multiplier table (for both) */
+
+	p = (u8 *)ptrs[disks - 2];
+	q = (u8 *)ptrs[disks - 1];
+
+	/*
+	 * Compute syndrome with zero for the missing data pages
+	 * Use the dead data pages as temporary storage for
+	 * delta p and delta q
+	 */
+	dp = (u8 *)ptrs[faila];
+	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[disks - 2] = dp;
+	dq = (u8 *)ptrs[failb];
+	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[disks - 1] = dq;
+
+	raid6_call.gen_syndrome(disks, bytes, ptrs);
+
+	/* Restore pointer table */
+	ptrs[faila]     = dp;
+	ptrs[failb]     = dq;
+	ptrs[disks - 2] = p;
+	ptrs[disks - 1] = q;
+
+	/* Now, pick the proper data tables */
+	pbmul = raid6_vgfmul[raid6_gfexi[failb-faila]];
+	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
+					 raid6_gfexp[failb]]];
+
+	if (crypto_simd_usable()) {
+		kernel_vector_begin();
+		__raid6_2data_recov_rvv(bytes, p, q, dp, dq, pbmul, qmul);
+		kernel_vector_end();
+	}
+}
+
+static void raid6_datap_recov_rvv(int disks, size_t bytes, int faila,
+		void **ptrs)
+{
+	u8 *p, *q, *dq;
+	const u8 *qmul;		/* Q multiplier table */
+
+	p = (u8 *)ptrs[disks - 2];
+	q = (u8 *)ptrs[disks - 1];
+
+	/*
+	 * Compute syndrome with zero for the missing data page
+	 * Use the dead data page as temporary storage for delta q
+	 */
+	dq = (u8 *)ptrs[faila];
+	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[disks - 1] = dq;
+
+	raid6_call.gen_syndrome(disks, bytes, ptrs);
+
+	/* Restore pointer table */
+	ptrs[faila]     = dq;
+	ptrs[disks - 1] = q;
+
+	/* Now, pick the proper data tables */
+	qmul = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
+
+	if (crypto_simd_usable()) {
+		kernel_vector_begin();
+		__raid6_datap_recov_rvv(bytes, p, q, dq, qmul);
+		kernel_vector_end();
+	}
+}
+
+const struct raid6_recov_calls raid6_recov_rvv = {
+	.data2		= raid6_2data_recov_rvv,
+	.datap		= raid6_datap_recov_rvv,
+	.valid		= NULL,
+	.name		= "rvv",
+	.priority	= 1,
+};
diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
new file mode 100644
index 000000000000..21f5432506da
--- /dev/null
+++ b/lib/raid6/rvv.c
@@ -0,0 +1,715 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RAID-6 syndrome calculation using RISCV vector instructions
+ *
+ * Copyright 2024 Institute of Software, CAS.
+ * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
+ *
+ * Based on neon.uc:
+ *	Copyright 2002-2004 H. Peter Anvin
+ */
+
+#include <asm/simd.h>
+#include <asm/vector.h>
+#include <crypto/internal/simd.h>
+#include <linux/raid/pq.h>
+#include <linux/types.h>
+
+#define NSIZE	(riscv_v_vsize / 32) /* NSIZE = vlenb */
+
+static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	int d, z, z0;
+	u8 *p, *q;
+
+	z0 = disks - 3;		/* Highest data disk */
+	p = dptr[z0+1];		/* XOR parity */
+	q = dptr[z0+2];		/* RS syndrome */
+
+	asm volatile (
+		".option	push\n"
+		".option	arch,+v\n"
+		"vsetvli	t0, x0, e8, m1, ta, ma\n"
+	);
+
+	 /* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
+	for (d = 0 ; d < bytes ; d += NSIZE*1) {
+		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
+		asm volatile (
+			"vle8.v	v0, (%[wp0])\n"
+			"vle8.v	v1, (%[wp0])\n"
+			: :
+			[wp0]"r"(&dptr[z0][d+0*NSIZE])
+		);
+
+		for (z = z0-1 ; z >= 0 ; z--) {
+			/*
+			 * w2$$ = MASK(wq$$);
+			 * w1$$ = SHLBYTE(wq$$);
+			 * w2$$ &= NBYTES(0x1d);
+			 * w1$$ ^= w2$$;
+			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
+			 * wq$$ = w1$$ ^ wd$$;
+			 * wp$$ ^= wd$$;
+			 */
+			asm volatile (
+				"vsra.vi	v2, v1, 7\n"
+				"vsll.vi	v3, v1, 1\n"
+				"vand.vx	v2, v2, %[x1d]\n"
+				"vxor.vv	v3, v3, v2\n"
+				"vle8.v		v2, (%[wd0])\n"
+				"vxor.vv	v1, v3, v2\n"
+				"vxor.vv	v0, v0, v2\n"
+				: :
+				[wd0]"r"(&dptr[z][d+0*NSIZE]),
+				[x1d]"r"(0x1d)
+			);
+		}
+
+		/*
+		 * *(unative_t *)&p[d+NSIZE*$$] = wp$$;
+		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
+		 */
+		asm volatile (
+			"vse8.v		v0, (%[wp0])\n"
+			"vse8.v		v1, (%[wq0])\n"
+			: :
+			[wp0]"r"(&p[d+NSIZE*0]),
+			[wq0]"r"(&q[d+NSIZE*0])
+		);
+	}
+
+	asm volatile (".option pop\n");
+}
+
+static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
+				    unsigned long bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	int d, z, z0;
+
+	z0 = stop;		/* P/Q right side optimization */
+	p = dptr[disks-2];	/* XOR parity */
+	q = dptr[disks-1];	/* RS syndrome */
+
+	asm volatile (
+		".option push\n"
+		".option arch,+v\n"
+		"vsetvli	t0, x0, e8, m1, ta, ma\n"
+	);
+
+	/* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
+	for (d = 0 ; d < bytes ; d += NSIZE*1) {
+		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
+		asm volatile (
+			"vle8.v	v0, (%[wp0])\n"
+			"vle8.v	v1, (%[wp0])\n"
+			: :
+			[wp0]"r"(&dptr[z0][d+0*NSIZE])
+		);
+
+		/* P/Q data pages */
+		for (z = z0-1 ; z >= start ; z--) {
+			/*
+			 * w2$$ = MASK(wq$$);
+			 * w1$$ = SHLBYTE(wq$$);
+			 * w2$$ &= NBYTES(0x1d);
+			 * w1$$ ^= w2$$;
+			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
+			 * wq$$ = w1$$ ^ wd$$;
+			 * wp$$ ^= wd$$;
+			 */
+			asm volatile (
+				"vsra.vi	v2, v1, 7\n"
+				"vsll.vi	v3, v1, 1\n"
+				"vand.vx	v2, v2, %[x1d]\n"
+				"vxor.vv	v3, v3, v2\n"
+				"vle8.v		v2, (%[wd0])\n"
+				"vxor.vv	v1, v3, v2\n"
+				"vxor.vv	v0, v0, v2\n"
+				: :
+				[wd0]"r"(&dptr[z][d+0*NSIZE]),
+				[x1d]"r"(0x1d)
+			);
+		}
+
+		/* P/Q left side optimization */
+		for (z = start-1 ; z >= 0 ; z--) {
+			/*
+			 * w2$$ = MASK(wq$$);
+			 * w1$$ = SHLBYTE(wq$$);
+			 * w2$$ &= NBYTES(0x1d);
+			 * wq$$ = w1$$ ^ w2$$;
+			 */
+			asm volatile (
+				"vsra.vi	v2, v1, 7\n"
+				"vsll.vi	v3, v1, 1\n"
+				"vand.vx	v2, v2, %[x1d]\n"
+				"vxor.vv	v1, v3, v2\n"
+				: :
+				[x1d]"r"(0x1d)
+			);
+		}
+
+		/*
+		 * *(unative_t *)&p[d+NSIZE*$$] ^= wp$$;
+		 * *(unative_t *)&q[d+NSIZE*$$] ^= wq$$;
+		 * v0:wp0, v1:wq0, v2:p0, v3:q0
+		 */
+		asm volatile (
+			"vle8.v		v2, (%[wp0])\n"
+			"vle8.v		v3, (%[wq0])\n"
+			"vxor.vv	v2, v2, v0\n"
+			"vxor.vv	v3, v3, v1\n"
+			"vse8.v		v2, (%[wp0])\n"
+			"vse8.v		v3, (%[wq0])\n"
+			: :
+			[wp0]"r"(&p[d+NSIZE*0]),
+			[wq0]"r"(&q[d+NSIZE*0])
+		);
+	}
+
+	asm volatile (".option pop\n");
+}
+
+static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	int d, z, z0;
+	u8 *p, *q;
+
+	z0 = disks - 3;		/* Highest data disk */
+	p = dptr[z0+1];		/* XOR parity */
+	q = dptr[z0+2];		/* RS syndrome */
+
+	asm volatile (
+		".option	push\n"
+		".option	arch,+v\n"
+		"vsetvli	t0, x0, e8, m1, ta, ma\n"
+	);
+
+	/*
+	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
+	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
+	 */
+	for (d = 0 ; d < bytes ; d += NSIZE*2) {
+		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
+		asm volatile (
+			"vle8.v	v0, (%[wp0])\n"
+			"vle8.v	v1, (%[wp0])\n"
+			"vle8.v	v4, (%[wp1])\n"
+			"vle8.v	v5, (%[wp1])\n"
+			: :
+			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
+			[wp1]"r"(&dptr[z0][d+1*NSIZE])
+		);
+
+		for (z = z0-1 ; z >= 0 ; z--) {
+			/*
+			 * w2$$ = MASK(wq$$);
+			 * w1$$ = SHLBYTE(wq$$);
+			 * w2$$ &= NBYTES(0x1d);
+			 * w1$$ ^= w2$$;
+			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
+			 * wq$$ = w1$$ ^ wd$$;
+			 * wp$$ ^= wd$$;
+			 */
+			asm volatile (
+				"vsra.vi	v2, v1, 7\n"
+				"vsll.vi	v3, v1, 1\n"
+				"vand.vx	v2, v2, %[x1d]\n"
+				"vxor.vv	v3, v3, v2\n"
+				"vle8.v		v2, (%[wd0])\n"
+				"vxor.vv	v1, v3, v2\n"
+				"vxor.vv	v0, v0, v2\n"
+
+				"vsra.vi	v6, v5, 7\n"
+				"vsll.vi	v7, v5, 1\n"
+				"vand.vx	v6, v6, %[x1d]\n"
+				"vxor.vv	v7, v7, v6\n"
+				"vle8.v		v6, (%[wd1])\n"
+				"vxor.vv	v5, v7, v6\n"
+				"vxor.vv	v4, v4, v6\n"
+				: :
+				[wd0]"r"(&dptr[z][d+0*NSIZE]),
+				[wd1]"r"(&dptr[z][d+1*NSIZE]),
+				[x1d]"r"(0x1d)
+			);
+		}
+
+		/*
+		 * *(unative_t *)&p[d+NSIZE*$$] = wp$$;
+		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
+		 */
+		asm volatile (
+			"vse8.v		v0, (%[wp0])\n"
+			"vse8.v		v1, (%[wq0])\n"
+			"vse8.v		v4, (%[wp1])\n"
+			"vse8.v		v5, (%[wq1])\n"
+			: :
+			[wp0]"r"(&p[d+NSIZE*0]),
+			[wq0]"r"(&q[d+NSIZE*0]),
+			[wp1]"r"(&p[d+NSIZE*1]),
+			[wq1]"r"(&q[d+NSIZE*1])
+		);
+	}
+
+	asm volatile (".option pop\n");
+}
+
+static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
+					 unsigned long bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	int d, z, z0;
+
+	z0 = stop;		/* P/Q right side optimization */
+	p = dptr[disks-2];	/* XOR parity */
+	q = dptr[disks-1];	/* RS syndrome */
+
+	asm volatile (
+		".option push\n"
+		".option arch,+v\n"
+		"vsetvli	t0, x0, e8, m1, ta, ma\n"
+	);
+
+	/*
+	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
+	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
+	 */
+	for (d = 0 ; d < bytes ; d += NSIZE*2) {
+		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
+		asm volatile (
+			"vle8.v	v0, (%[wp0])\n"
+			"vle8.v	v1, (%[wp0])\n"
+			"vle8.v	v4, (%[wp1])\n"
+			"vle8.v	v5, (%[wp1])\n"
+			: :
+			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
+			[wp1]"r"(&dptr[z0][d+1*NSIZE])
+		);
+
+		/* P/Q data pages */
+		for (z = z0-1 ; z >= start ; z--) {
+			/*
+			 * w2$$ = MASK(wq$$);
+			 * w1$$ = SHLBYTE(wq$$);
+			 * w2$$ &= NBYTES(0x1d);
+			 * w1$$ ^= w2$$;
+			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
+			 * wq$$ = w1$$ ^ wd$$;
+			 * wp$$ ^= wd$$;
+			 */
+			asm volatile (
+				"vsra.vi	v2, v1, 7\n"
+				"vsll.vi	v3, v1, 1\n"
+				"vand.vx	v2, v2, %[x1d]\n"
+				"vxor.vv	v3, v3, v2\n"
+				"vle8.v		v2, (%[wd0])\n"
+				"vxor.vv	v1, v3, v2\n"
+				"vxor.vv	v0, v0, v2\n"
+
+				"vsra.vi	v6, v5, 7\n"
+				"vsll.vi	v7, v5, 1\n"
+				"vand.vx	v6, v6, %[x1d]\n"
+				"vxor.vv	v7, v7, v6\n"
+				"vle8.v		v6, (%[wd1])\n"
+				"vxor.vv	v5, v7, v6\n"
+				"vxor.vv	v4, v4, v6\n"
+				: :
+				[wd0]"r"(&dptr[z][d+0*NSIZE]),
+				[wd1]"r"(&dptr[z][d+1*NSIZE]),
+				[x1d]"r"(0x1d)
+			);
+		}
+
+		/* P/Q left side optimization */
+		for (z = start-1 ; z >= 0 ; z--) {
+			/*
+			 * w2$$ = MASK(wq$$);
+			 * w1$$ = SHLBYTE(wq$$);
+			 * w2$$ &= NBYTES(0x1d);
+			 * wq$$ = w1$$ ^ w2$$;
+			 */
+			asm volatile (
+				"vsra.vi	v2, v1, 7\n"
+				"vsll.vi	v3, v1, 1\n"
+				"vand.vx	v2, v2, %[x1d]\n"
+				"vxor.vv	v1, v3, v2\n"
+
+				"vsra.vi	v6, v5, 7\n"
+				"vsll.vi	v7, v5, 1\n"
+				"vand.vx	v6, v6, %[x1d]\n"
+				"vxor.vv	v5, v7, v6\n"
+				: :
+				[x1d]"r"(0x1d)
+			);
+		}
+
+		/*
+		 * *(unative_t *)&p[d+NSIZE*$$] ^= wp$$;
+		 * *(unative_t *)&q[d+NSIZE*$$] ^= wq$$;
+		 * v0:wp0, v1:wq0, v2:p0, v3:q0
+		 * v4:wp1, v5:wq1, v6:p1, v7:q1
+		 */
+		asm volatile (
+			"vle8.v		v2, (%[wp0])\n"
+			"vle8.v		v3, (%[wq0])\n"
+			"vxor.vv	v2, v2, v0\n"
+			"vxor.vv	v3, v3, v1\n"
+			"vse8.v		v2, (%[wp0])\n"
+			"vse8.v		v3, (%[wq0])\n"
+
+			"vle8.v		v6, (%[wp1])\n"
+			"vle8.v		v7, (%[wq1])\n"
+			"vxor.vv	v6, v6, v4\n"
+			"vxor.vv	v7, v7, v5\n"
+			"vse8.v		v6, (%[wp1])\n"
+			"vse8.v		v7, (%[wq1])\n"
+			: :
+			[wp0]"r"(&p[d+NSIZE*0]),
+			[wq0]"r"(&q[d+NSIZE*0]),
+			[wp1]"r"(&p[d+NSIZE*1]),
+			[wq1]"r"(&q[d+NSIZE*1])
+		);
+	}
+
+	asm volatile (".option pop\n");
+}
+
+static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	int d, z, z0;
+	u8 *p, *q;
+
+	z0 = disks - 3;	/* Highest data disk */
+	p = dptr[z0+1];	/* XOR parity */
+	q = dptr[z0+2];	/* RS syndrome */
+
+	asm volatile (
+		".option	push\n"
+		".option	arch,+v\n"
+		"vsetvli	t0, x0, e8, m1, ta, ma\n"
+	);
+
+	/*
+	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
+	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
+	 * v8:wp2, v9:wq2, v10:wd2/w22, v11:w12
+	 * v12:wp3, v13:wq3, v14:wd3/w23, v15:w13
+	 */
+	for (d = 0 ; d < bytes ; d += NSIZE*4) {
+		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
+		asm volatile (
+			"vle8.v v0, (%[wp0])\n"
+			"vle8.v v1, (%[wp0])\n"
+			"vle8.v v4, (%[wp1])\n"
+			"vle8.v v5, (%[wp1])\n"
+			"vle8.v v8, (%[wp2])\n"
+			"vle8.v v9, (%[wp2])\n"
+			"vle8.v v12, (%[wp3])\n"
+			"vle8.v v13, (%[wp3])\n"
+			: :
+			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
+			[wp1]"r"(&dptr[z0][d+1*NSIZE]),
+			[wp2]"r"(&dptr[z0][d+2*NSIZE]),
+			[wp3]"r"(&dptr[z0][d+3*NSIZE])
+		);
+
+		for (z = z0-1 ; z >= 0 ; z--) {
+			/*
+			 * w2$$ = MASK(wq$$);
+			 * w1$$ = SHLBYTE(wq$$);
+			 * w2$$ &= NBYTES(0x1d);
+			 * w1$$ ^= w2$$;
+			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
+			 * wq$$ = w1$$ ^ wd$$;
+			 * wp$$ ^= wd$$;
+			 */
+			asm volatile (
+				"vsra.vi	v2, v1, 7\n"
+				"vsll.vi	v3, v1, 1\n"
+				"vand.vx	v2, v2, %[x1d]\n"
+				"vxor.vv	v3, v3, v2\n"
+				"vle8.v		v2, (%[wd0])\n"
+				"vxor.vv	v1, v3, v2\n"
+				"vxor.vv	v0, v0, v2\n"
+
+				"vsra.vi	v6, v5, 7\n"
+				"vsll.vi	v7, v5, 1\n"
+				"vand.vx	v6, v6, %[x1d]\n"
+				"vxor.vv	v7, v7, v6\n"
+				"vle8.v		v6, (%[wd1])\n"
+				"vxor.vv	v5, v7, v6\n"
+				"vxor.vv	v4, v4, v6\n"
+
+				"vsra.vi	v10, v9, 7\n"
+				"vsll.vi	v11, v9, 1\n"
+				"vand.vx	v10, v10, %[x1d]\n"
+				"vxor.vv	v11, v11, v10\n"
+				"vle8.v		v10, (%[wd2])\n"
+				"vxor.vv	v9, v11, v10\n"
+				"vxor.vv	v8, v8, v10\n"
+
+				"vsra.vi	v14, v13, 7\n"
+				"vsll.vi	v15, v13, 1\n"
+				"vand.vx	v14, v14, %[x1d]\n"
+				"vxor.vv	v15, v15, v14\n"
+				"vle8.v		v14, (%[wd3])\n"
+				"vxor.vv	v13, v15, v14\n"
+				"vxor.vv	v12, v12, v14\n"
+				: :
+				[wd0]"r"(&dptr[z][d+0*NSIZE]),
+				[wd1]"r"(&dptr[z][d+1*NSIZE]),
+				[wd2]"r"(&dptr[z][d+2*NSIZE]),
+				[wd3]"r"(&dptr[z][d+3*NSIZE]),
+				[x1d]"r"(0x1d)
+			);
+		}
+
+		/*
+		 * *(unative_t *)&p[d+NSIZE*$$] = wp$$;
+		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
+		 */
+		asm volatile (
+			"vse8.v	v0, (%[wp0])\n"
+			"vse8.v	v1, (%[wq0])\n"
+			"vse8.v	v4, (%[wp1])\n"
+			"vse8.v	v5, (%[wq1])\n"
+			"vse8.v	v8, (%[wp2])\n"
+			"vse8.v	v9, (%[wq2])\n"
+			"vse8.v	v12, (%[wp3])\n"
+			"vse8.v	v13, (%[wq3])\n"
+			: :
+			[wp0]"r"(&p[d+NSIZE*0]),
+			[wq0]"r"(&q[d+NSIZE*0]),
+			[wp1]"r"(&p[d+NSIZE*1]),
+			[wq1]"r"(&q[d+NSIZE*1]),
+			[wp2]"r"(&p[d+NSIZE*2]),
+			[wq2]"r"(&q[d+NSIZE*2]),
+			[wp3]"r"(&p[d+NSIZE*3]),
+			[wq3]"r"(&q[d+NSIZE*3])
+		);
+	}
+
+	asm volatile (".option pop\n");
+}
+
+static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
+					unsigned long bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	int d, z, z0;
+
+	z0 = stop;		/* P/Q right side optimization */
+	p = dptr[disks-2];	/* XOR parity */
+	q = dptr[disks-1];	/* RS syndrome */
+
+	asm volatile (
+		".option push\n"
+		".option arch,+v\n"
+		"vsetvli	t0, x0, e8, m1, ta, ma\n"
+	);
+
+	/*
+	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
+	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
+	 * v8:wp2, v9:wq2, v10:wd2/w22, v11:w12
+	 * v12:wp3, v13:wq3, v14:wd3/w23, v15:w13
+	 */
+	for (d = 0 ; d < bytes ; d += NSIZE*4) {
+		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
+		asm volatile (
+			"vle8.v v0, (%[wp0])\n"
+			"vle8.v v1, (%[wp0])\n"
+			"vle8.v v4, (%[wp1])\n"
+			"vle8.v v5, (%[wp1])\n"
+			"vle8.v v8, (%[wp2])\n"
+			"vle8.v v9, (%[wp2])\n"
+			"vle8.v v12, (%[wp3])\n"
+			"vle8.v v13, (%[wp3])\n"
+			: :
+			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
+			[wp1]"r"(&dptr[z0][d+1*NSIZE]),
+			[wp2]"r"(&dptr[z0][d+2*NSIZE]),
+			[wp3]"r"(&dptr[z0][d+3*NSIZE])
+		);
+
+		/* P/Q data pages */
+		for (z = z0-1 ; z >= start ; z--) {
+			/*
+			 * w2$$ = MASK(wq$$);
+			 * w1$$ = SHLBYTE(wq$$);
+			 * w2$$ &= NBYTES(0x1d);
+			 * w1$$ ^= w2$$;
+			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
+			 * wq$$ = w1$$ ^ wd$$;
+			 * wp$$ ^= wd$$;
+			 */
+			asm volatile (
+				"vsra.vi	v2, v1, 7\n"
+				"vsll.vi	v3, v1, 1\n"
+				"vand.vx	v2, v2, %[x1d]\n"
+				"vxor.vv	v3, v3, v2\n"
+				"vle8.v		v2, (%[wd0])\n"
+				"vxor.vv	v1, v3, v2\n"
+				"vxor.vv	v0, v0, v2\n"
+
+				"vsra.vi	v6, v5, 7\n"
+				"vsll.vi	v7, v5, 1\n"
+				"vand.vx	v6, v6, %[x1d]\n"
+				"vxor.vv	v7, v7, v6\n"
+				"vle8.v		v6, (%[wd1])\n"
+				"vxor.vv	v5, v7, v6\n"
+				"vxor.vv	v4, v4, v6\n"
+
+				"vsra.vi	v10, v9, 7\n"
+				"vsll.vi	v11, v9, 1\n"
+				"vand.vx	v10, v10, %[x1d]\n"
+				"vxor.vv	v11, v11, v10\n"
+				"vle8.v		v10, (%[wd2])\n"
+				"vxor.vv	v9, v11, v10\n"
+				"vxor.vv	v8, v8, v10\n"
+
+				"vsra.vi	v14, v13, 7\n"
+				"vsll.vi	v15, v13, 1\n"
+				"vand.vx	v14, v14, %[x1d]\n"
+				"vxor.vv	v15, v15, v14\n"
+				"vle8.v		v14, (%[wd3])\n"
+				"vxor.vv	v13, v15, v14\n"
+				"vxor.vv	v12, v12, v14\n"
+				: :
+				[wd0]"r"(&dptr[z][d+0*NSIZE]),
+				[wd1]"r"(&dptr[z][d+1*NSIZE]),
+				[wd2]"r"(&dptr[z][d+2*NSIZE]),
+				[wd3]"r"(&dptr[z][d+3*NSIZE]),
+				[x1d]"r"(0x1d)
+			);
+		}
+
+		/* P/Q left side optimization */
+		for (z = start-1 ; z >= 0 ; z--) {
+			/*
+			 * w2$$ = MASK(wq$$);
+			 * w1$$ = SHLBYTE(wq$$);
+			 * w2$$ &= NBYTES(0x1d);
+			 * wq$$ = w1$$ ^ w2$$;
+			 */
+			asm volatile (
+				"vsra.vi	v2, v1, 7\n"
+				"vsll.vi	v3, v1, 1\n"
+				"vand.vx	v2, v2, %[x1d]\n"
+				"vxor.vv	v1, v3, v2\n"
+
+				"vsra.vi	v6, v5, 7\n"
+				"vsll.vi	v7, v5, 1\n"
+				"vand.vx	v6, v6, %[x1d]\n"
+				"vxor.vv	v5, v7, v6\n"
+
+				"vsra.vi	v10, v9, 7\n"
+				"vsll.vi	v11, v9, 1\n"
+				"vand.vx	v10, v10, %[x1d]\n"
+				"vxor.vv	v9, v11, v10\n"
+
+				"vsra.vi	v14, v13, 7\n"
+				"vsll.vi	v15, v13, 1\n"
+				"vand.vx	v14, v14, %[x1d]\n"
+				"vxor.vv	v13, v15, v14\n"
+				: :
+				[x1d]"r"(0x1d)
+			);
+		}
+
+		/*
+		 * *(unative_t *)&p[d+NSIZE*$$] ^= wp$$;
+		 * *(unative_t *)&q[d+NSIZE*$$] ^= wq$$;
+		 * v0:wp0, v1:wq0, v2:p0, v3:q0
+		 * v4:wp1, v5:wq1, v6:p1, v7:q1
+		 * v8:wp2, v9:wq2, v10:p2, v11:q2
+		 * v12:wp3, v13:wq3, v14:p3, v15:q3
+		 */
+		asm volatile (
+			"vle8.v		v2, (%[wp0])\n"
+			"vle8.v		v3, (%[wq0])\n"
+			"vxor.vv	v2, v2, v0\n"
+			"vxor.vv	v3, v3, v1\n"
+			"vse8.v		v2, (%[wp0])\n"
+			"vse8.v		v3, (%[wq0])\n"
+
+			"vle8.v		v6, (%[wp1])\n"
+			"vle8.v		v7, (%[wq1])\n"
+			"vxor.vv	v6, v6, v4\n"
+			"vxor.vv	v7, v7, v5\n"
+			"vse8.v		v6, (%[wp1])\n"
+			"vse8.v		v7, (%[wq1])\n"
+
+			"vle8.v		v10, (%[wp2])\n"
+			"vle8.v		v11, (%[wq2])\n"
+			"vxor.vv	v10, v10, v8\n"
+			"vxor.vv	v11, v11, v9\n"
+			"vse8.v		v10, (%[wp2])\n"
+			"vse8.v		v11, (%[wq2])\n"
+
+			"vle8.v		v14, (%[wp3])\n"
+			"vle8.v		v15, (%[wq3])\n"
+			"vxor.vv	v14, v14, v12\n"
+			"vxor.vv	v15, v15, v13\n"
+			"vse8.v		v14, (%[wp3])\n"
+			"vse8.v		v15, (%[wq3])\n"
+			: :
+			[wp0]"r"(&p[d+NSIZE*0]),
+			[wq0]"r"(&q[d+NSIZE*0]),
+			[wp1]"r"(&p[d+NSIZE*1]),
+			[wq1]"r"(&q[d+NSIZE*1]),
+			[wp2]"r"(&p[d+NSIZE*2]),
+			[wq2]"r"(&q[d+NSIZE*2]),
+			[wp3]"r"(&p[d+NSIZE*3]),
+			[wq3]"r"(&q[d+NSIZE*3])
+		);
+	}
+
+	asm volatile (".option pop\n");
+}
+
+#define RAID6_RVV_WRAPPER(_n)						\
+	static void raid6_rvv ## _n ## _gen_syndrome(int disks,		\
+					size_t bytes, void **ptrs)	\
+	{								\
+		void raid6_rvv ## _n  ## _gen_syndrome_real(int,	\
+						unsigned long, void**);	\
+		if (crypto_simd_usable()) {				\
+			kernel_vector_begin();				\
+			raid6_rvv ## _n ## _gen_syndrome_real(disks,	\
+					(unsigned long)bytes, ptrs);	\
+			kernel_vector_end();				\
+		}							\
+	}								\
+	static void raid6_rvv ## _n ## _xor_syndrome(int disks,		\
+					int start, int stop,		\
+					size_t bytes, void **ptrs)	\
+	{								\
+		void raid6_rvv ## _n  ## _xor_syndrome_real(int,	\
+				int, int, unsigned long, void**);	\
+		if (crypto_simd_usable()) {				\
+			kernel_vector_begin();				\
+		raid6_rvv ## _n ## _xor_syndrome_real(disks,		\
+			start, stop, (unsigned long)bytes, ptrs);	\
+			kernel_vector_end();				\
+		}							\
+	}								\
+	struct raid6_calls const raid6_rvvx ## _n = {			\
+		raid6_rvv ## _n ## _gen_syndrome,			\
+		raid6_rvv ## _n ## _xor_syndrome,			\
+		NULL,							\
+		"rvvx" #_n,						\
+		0							\
+	}
+
+RAID6_RVV_WRAPPER(1);
+RAID6_RVV_WRAPPER(2);
+RAID6_RVV_WRAPPER(4);
-- 
2.34.1

