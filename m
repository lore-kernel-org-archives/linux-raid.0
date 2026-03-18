Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACBD3D75C4
	for <linux-raid@vger.kernel.org>; Wed, 18 Mar 2026 15:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773846174; cv=none; b=uKW3g848omNh+jlrh/zbP4AhuuPNw0D6T3ls0BVle4Kjwa9umXskRmcgsC4RemetDPZaPJfQcGVuFpPBfJo91z3e026CAzhFF7wI0C0sc4OH7t6UB0yt5GtIg7o2Q8bmsl9n6VvbBQlBtoli9EOq9X8OyDBuH8l8jtZYdAtMgz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773846174; c=relaxed/simple;
	bh=yKBxTRmF78NKuhsiSbdjTnlZFFMRE73Qk9aP1VBrzvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lrOwkCQ1LDtVp2Dw/J0eZDVZH1CW0GZ4j8+FtqJzqO78q/z0wfYIK2aMRsfp0QfSt/izvcNiLlr84/wAFYEUPKXPGIPdigkGY7/TD/33cgu/CSYPvlbZzoHKvMxRU0D030/YVzTuwv/oNJY1lObqPpfKVX5vljGlYeKyDOmmiK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hu9aJCBz; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hu9aJCBz"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a13f6bcbf4so10184645e87.1
        for <linux-raid@vger.kernel.org>; Wed, 18 Mar 2026 08:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773846169; x=1774450969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GfCCpHgQ8JNaauZbesBEyz3ZlGKRin1zXLSVY+rqGfo=;
        b=Hu9aJCBzbyJx5NXvSXK/sZwZPlS8+27X1sgd5t8uWyExrzytYP+mpgrYTCBT+yRaKQ
         tO9YpxKhoAw/aGJAWC0we2Qk+OLrbqFj+7ikmn9rJtAdblATaZLO3AGbKd31Kh8JZ5Ru
         8nqPkNWMeJuNTq8rzNr9qLLMZeO1Jc+k5ZnpqURjT8qYTOzd9TxR5ONgqQt8xuD7oGle
         xoxzwyuO9SxYz6lDJJdxNScOie306jFXgmJYDX/9LIv1IrciRBeeCp/kBRxStm03fIW+
         w/yJvU+/9z284VYoWI7DMTkRL8v1BZKSLCnw026HTxLAhM3NkmUptgKIZIOQe2cNjy1d
         Nzkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773846169; x=1774450969;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GfCCpHgQ8JNaauZbesBEyz3ZlGKRin1zXLSVY+rqGfo=;
        b=Fx37BQMnMY5RUgNgOwmMvMt3O+mo/8ffPG5q3b2lzfOARl/QevPwzq+r9gMOKd+c84
         Tt9itvy4fxVTdOLHvzvRhEwJvuh2g2qB5+V4bag4p7qEn6H6IZq9xoN5rv72kkvtT63A
         DlxXeLwRHbRN3X3zWNJ/20HB/bR0vW6eXleSVB/haXDxw7Via1TvzdIq3Uoe9Ms7eBy9
         iZPYHMcU3faVU4VQfiP6+o//4lG5uO1S+tn5lM0JgYExQcQZr1DLGJDLmes09GrFaL38
         gI1RC+Fm9p/MpdkW03gBab6htb5t5oTb+KhgxOhvNv3RRVpukQq5S9UmIzgxGWkVZF3s
         CzFg==
X-Forwarded-Encrypted: i=1; AJvYcCV00/tdKCL2b/KO6WntkGi/YtQL5l98TO/ZFxP7Yye6GCqvsUOVF1oIi9b3f1MKkQNI9HoT942b3YTp@vger.kernel.org
X-Gm-Message-State: AOJu0YwE79lGKNDkDvUoZbm5ycKB1h1bCOlXgvbHwMA0RwRhH4pgD6Ms
	7NcJQJl8FAfzENIbZrGktY+53iymBjRFR+GZlnZhj8YNQJze3JcTbnTX
X-Gm-Gg: ATEYQzywOYReYtP+7B1HW92C9u+Y4NyVPXNWTJJ3hAM8HbfQDwIRqTBiMEtfiWgX34K
	shfcOl8glR85PFaGRxg+OmqBitSQjJ81ZFJKePXtzLL0i9G3pSuPAlaDQP7zL9E1kuTO9v0fTlv
	Pk40QScGDUgF4Hk45hriThaj5waqmRE1n3qKfoLj5nr8Br8OHl2Rcmo7v93XCXue/GR+hcufqmH
	GYRNYwTSzg2lEBeDHK/Z80CiWlw0wKm7cQYtXVAwg6l1+bvn5hH7dO6uD91qOVxM9toKd0yO7sA
	dE/DdHAiYH/uRLxCoT61xMrh8qNHK132Ir/DvjiYU1oMD/GwXBe7gHSrOyZ5q2TAawhxUP4egjD
	LnNK1QjuL7igc5egcO/MFieB+WH6fdHGxkLz4pb2jPi5WjF9Iklhe6fHHJ6Uhush5JO/pMfV7Mw
	NwtWpzqNetbZ2F2ME4203D8lu5s9H3jLWHbFtn
X-Received: by 2002:a05:6512:40d0:20b0:59e:1880:2ef7 with SMTP id 2adb3069b0e04-5a279588459mr1153980e87.11.1773846169002;
        Wed, 18 Mar 2026 08:02:49 -0700 (PDT)
Received: from lima-dev.. ([178.137.234.67])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a279c6e1adsm578781e87.49.2026.03.18.08.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 08:02:48 -0700 (PDT)
From: Demian Shulhan <demyansh@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>
Cc: Li Nan <linan122@huawei.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Demian Shulhan <demyansh@gmail.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v2] raid6: arm64: add SVE optimized implementation for syndrome generation
Date: Wed, 18 Mar 2026 15:02:45 +0000
Message-ID: <20260318150245.3080719-1-demyansh@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement Scalable Vector Extension (SVE) optimized routines for RAID6
syndrome generation and recovery on ARM64.

The SVE instruction set allows for variable vector lengths (from 128 to
2048 bits), scaling automatically with the hardware capabilities. This
implementation handles arbitrary SVE vector lengths using the `cntb`
instruction to determine the runtime vector length.

The implementation introduces `svex1`, `svex2`, and `svex4` algorithms.
The `svex4` algorithm utilizes loop unrolling by 4 blocks per iteration
and manual software pipelining (interleaving memory loads with XORs)
to minimize instruction dependency stalls and maximize CPU pipeline
utilization and memory bandwidth.

Performance was tested on an AWS Graviton3 (Neoverse-V1) instance which
features 256-bit SVE vector length. The `svex4` implementation outperforms
the existing 128-bit `neonx4` baseline for syndrome generation:

raid6: svex4    gen() 19688 MB/s
raid6: svex2    gen() 18610 MB/s
raid6: svex1    gen() 19254 MB/s
raid6: neonx8   gen() 18554 MB/s
raid6: neonx4   gen() 19612 MB/s
raid6: neonx2   gen() 16248 MB/s
raid6: neonx1   gen() 13591 MB/s
raid6: using algorithm svex4 gen() 19688 MB/s
raid6: .... xor() 11212 MB/s, rmw enabled
raid6: using neon recovery algorithm

Note that for the recovery path (`xor_syndrome`), NEON may still be
selected dynamically by the algorithm benchmark, as the recovery
workload is heavily memory-bound.

Signed-off-by: Demian Shulhan <demyansh@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603181940.cFwYmYoi-lkp@intel.com/
---
 include/linux/raid/pq.h |   3 +
 lib/raid6/Makefile      |   5 +
 lib/raid6/algos.c       |   5 +
 lib/raid6/sve.c         | 675 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 688 insertions(+)
 create mode 100644 lib/raid6/sve.c

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 2467b3be15c9..787cc57aea9d 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -140,6 +140,9 @@ extern const struct raid6_calls raid6_neonx1;
 extern const struct raid6_calls raid6_neonx2;
 extern const struct raid6_calls raid6_neonx4;
 extern const struct raid6_calls raid6_neonx8;
+extern const struct raid6_calls raid6_svex1;
+extern const struct raid6_calls raid6_svex2;
+extern const struct raid6_calls raid6_svex4;
 
 /* Algorithm list */
 extern const struct raid6_calls * const raid6_algos[];
diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index 5be0a4e60ab1..6cdaa6f206fb 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -8,6 +8,7 @@ raid6_pq-$(CONFIG_X86) += recov_ssse3.o recov_avx2.o mmx.o sse1.o sse2.o avx2.o
 raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o altivec8.o \
                               vpermxor1.o vpermxor2.o vpermxor4.o vpermxor8.o
 raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
+raid6_pq-$(CONFIG_ARM64_SVE) += sve.o
 raid6_pq-$(CONFIG_S390) += s390vx8.o recov_s390xc.o
 raid6_pq-$(CONFIG_LOONGARCH) += loongarch_simd.o recov_loongarch_simd.o
 raid6_pq-$(CONFIG_RISCV_ISA_V) += rvv.o recov_rvv.o
@@ -67,6 +68,10 @@ CFLAGS_REMOVE_neon2.o += $(CC_FLAGS_NO_FPU)
 CFLAGS_REMOVE_neon4.o += $(CC_FLAGS_NO_FPU)
 CFLAGS_REMOVE_neon8.o += $(CC_FLAGS_NO_FPU)
 CFLAGS_REMOVE_recov_neon_inner.o += $(CC_FLAGS_NO_FPU)
+
+CFLAGS_sve.o += $(CC_FLAGS_FPU)
+CFLAGS_REMOVE_sve.o += $(CC_FLAGS_NO_FPU)
+
 targets += neon1.c neon2.c neon4.c neon8.c
 $(obj)/neon%.c: $(src)/neon.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 799e0e5eac26..0ae73c3a4be3 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -66,6 +66,11 @@ const struct raid6_calls * const raid6_algos[] = {
 	&raid6_neonx2,
 	&raid6_neonx1,
 #endif
+#ifdef CONFIG_ARM64_SVE
+	&raid6_svex4,
+	&raid6_svex2,
+	&raid6_svex1,
+#endif
 #ifdef CONFIG_LOONGARCH
 #ifdef CONFIG_CPU_HAS_LASX
 	&raid6_lasx,
diff --git a/lib/raid6/sve.c b/lib/raid6/sve.c
new file mode 100644
index 000000000000..d52937f806d4
--- /dev/null
+++ b/lib/raid6/sve.c
@@ -0,0 +1,675 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RAID-6 syndrome calculation using ARM SVE instructions
+ */
+
+#include <linux/raid/pq.h>
+
+#ifdef __KERNEL__
+#include <asm/simd.h>
+#include <linux/cpufeature.h>
+#else
+#define scoped_ksimd()
+#define system_supports_sve() (1)
+#endif
+
+static void raid6_sve1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	long z0 = disks - 3;
+
+	p = dptr[z0 + 1];
+	q = dptr[z0 + 2];
+
+	asm volatile(
+		".arch armv8.2-a+sve\n"
+		"ptrue p0.b\n"
+		"cntb x3\n"
+		"mov w4, #0x1d\n"
+		"dup z4.b, w4\n"
+		"mov x5, #0\n"
+
+		"0:\n"
+		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
+		"ld1b z0.b, p0/z, [x6, x5]\n"
+		"mov z1.d, z0.d\n"
+
+		"mov w7, %w[z0]\n"
+		"sub w7, w7, #1\n"
+
+		"1:\n"
+		"cmp w7, #0\n"
+		"blt 2f\n"
+
+		"mov z3.d, z1.d\n"
+		"asr z3.b, p0/m, z3.b, #7\n"
+		"lsl z1.b, p0/m, z1.b, #1\n"
+
+		"and z3.d, z3.d, z4.d\n"
+		"eor z1.d, z1.d, z3.d\n"
+
+		"sxtw x8, w7\n"
+		"ldr x6, [%[dptr], x8, lsl #3]\n"
+		"ld1b z2.b, p0/z, [x6, x5]\n"
+
+		"eor z1.d, z1.d, z2.d\n"
+		"eor z0.d, z0.d, z2.d\n"
+
+		"sub w7, w7, #1\n"
+		"b 1b\n"
+		"2:\n"
+
+		"st1b z0.b, p0, [%[p], x5]\n"
+		"st1b z1.b, p0, [%[q], x5]\n"
+
+		"add x5, x5, x3\n"
+		"cmp x5, %[bytes]\n"
+		"blt 0b\n"
+		:
+		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
+		  [p] "r" (p), [q] "r" (q)
+		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
+		  "z0", "z1", "z2", "z3", "z4"
+	);
+}
+
+static void raid6_sve1_xor_syndrome_real(int disks, int start, int stop,
+					 unsigned long bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	long z0 = stop;
+
+	p = dptr[disks - 2];
+	q = dptr[disks - 1];
+
+	asm volatile(
+		".arch armv8.2-a+sve\n"
+		"ptrue p0.b\n"
+		"cntb x3\n"
+		"mov w4, #0x1d\n"
+		"dup z4.b, w4\n"
+		"mov x5, #0\n"
+
+		"0:\n"
+		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
+		"ld1b z1.b, p0/z, [x6, x5]\n"
+		"ld1b z0.b, p0/z, [%[p], x5]\n"
+		"eor z0.d, z0.d, z1.d\n"
+
+		"mov w7, %w[z0]\n"
+		"sub w7, w7, #1\n"
+
+		"1:\n"
+		"cmp w7, %w[start]\n"
+		"blt 2f\n"
+
+		"mov z3.d, z1.d\n"
+		"asr z3.b, p0/m, z3.b, #7\n"
+		"lsl z1.b, p0/m, z1.b, #1\n"
+		"and z3.d, z3.d, z4.d\n"
+		"eor z1.d, z1.d, z3.d\n"
+
+		"sxtw x8, w7\n"
+		"ldr x6, [%[dptr], x8, lsl #3]\n"
+		"ld1b z2.b, p0/z, [x6, x5]\n"
+
+		"eor z1.d, z1.d, z2.d\n"
+		"eor z0.d, z0.d, z2.d\n"
+
+		"sub w7, w7, #1\n"
+		"b 1b\n"
+		"2:\n"
+
+		"mov w7, %w[start]\n"
+		"sub w7, w7, #1\n"
+		"3:\n"
+		"cmp w7, #0\n"
+		"blt 4f\n"
+
+		"mov z3.d, z1.d\n"
+		"asr z3.b, p0/m, z3.b, #7\n"
+		"lsl z1.b, p0/m, z1.b, #1\n"
+		"and z3.d, z3.d, z4.d\n"
+		"eor z1.d, z1.d, z3.d\n"
+
+		"sub w7, w7, #1\n"
+		"b 3b\n"
+		"4:\n"
+
+		"ld1b z2.b, p0/z, [%[q], x5]\n"
+		"eor z1.d, z1.d, z2.d\n"
+
+		"st1b z0.b, p0, [%[p], x5]\n"
+		"st1b z1.b, p0, [%[q], x5]\n"
+
+		"add x5, x5, x3\n"
+		"cmp x5, %[bytes]\n"
+		"blt 0b\n"
+		:
+		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
+		  [p] "r" (p), [q] "r" (q), [start] "r" (start)
+		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
+		  "z0", "z1", "z2", "z3", "z4"
+	);
+}
+
+static void raid6_sve2_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	long z0 = disks - 3;
+
+	p = dptr[z0 + 1];
+	q = dptr[z0 + 2];
+
+	asm volatile(
+		".arch armv8.2-a+sve\n"
+		"ptrue p0.b\n"
+		"cntb x3\n"
+		"mov w4, #0x1d\n"
+		"dup z4.b, w4\n"
+		"mov x5, #0\n"
+
+		"0:\n"
+		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
+		"ld1b z0.b, p0/z, [x6, x5]\n"
+		"add x8, x5, x3\n"
+		"ld1b z5.b, p0/z, [x6, x8]\n"
+		"mov z1.d, z0.d\n"
+		"mov z6.d, z5.d\n"
+
+		"mov w7, %w[z0]\n"
+		"sub w7, w7, #1\n"
+
+		"1:\n"
+		"cmp w7, #0\n"
+		"blt 2f\n"
+
+		"mov z3.d, z1.d\n"
+		"asr z3.b, p0/m, z3.b, #7\n"
+		"lsl z1.b, p0/m, z1.b, #1\n"
+		"and z3.d, z3.d, z4.d\n"
+		"eor z1.d, z1.d, z3.d\n"
+
+		"mov z8.d, z6.d\n"
+		"asr z8.b, p0/m, z8.b, #7\n"
+		"lsl z6.b, p0/m, z6.b, #1\n"
+		"and z8.d, z8.d, z4.d\n"
+		"eor z6.d, z6.d, z8.d\n"
+
+		"sxtw x8, w7\n"
+		"ldr x6, [%[dptr], x8, lsl #3]\n"
+		"ld1b z2.b, p0/z, [x6, x5]\n"
+		"add x8, x5, x3\n"
+		"ld1b z7.b, p0/z, [x6, x8]\n"
+
+		"eor z1.d, z1.d, z2.d\n"
+		"eor z0.d, z0.d, z2.d\n"
+
+		"eor z6.d, z6.d, z7.d\n"
+		"eor z5.d, z5.d, z7.d\n"
+
+		"sub w7, w7, #1\n"
+		"b 1b\n"
+		"2:\n"
+
+		"st1b z0.b, p0, [%[p], x5]\n"
+		"st1b z1.b, p0, [%[q], x5]\n"
+		"add x8, x5, x3\n"
+		"st1b z5.b, p0, [%[p], x8]\n"
+		"st1b z6.b, p0, [%[q], x8]\n"
+
+		"add x5, x5, x3\n"
+		"add x5, x5, x3\n"
+		"cmp x5, %[bytes]\n"
+		"blt 0b\n"
+		:
+		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
+		  [p] "r" (p), [q] "r" (q)
+		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
+		  "z0", "z1", "z2", "z3", "z4",
+		  "z5", "z6", "z7", "z8"
+	);
+}
+
+static void raid6_sve2_xor_syndrome_real(int disks, int start, int stop,
+					 unsigned long bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	long z0 = stop;
+
+	p = dptr[disks - 2];
+	q = dptr[disks - 1];
+
+	asm volatile(
+		".arch armv8.2-a+sve\n"
+		"ptrue p0.b\n"
+		"cntb x3\n"
+		"mov w4, #0x1d\n"
+		"dup z4.b, w4\n"
+		"mov x5, #0\n"
+
+		"0:\n"
+		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
+		"ld1b z1.b, p0/z, [x6, x5]\n"
+		"add x8, x5, x3\n"
+		"ld1b z6.b, p0/z, [x6, x8]\n"
+
+		"ld1b z0.b, p0/z, [%[p], x5]\n"
+		"ld1b z5.b, p0/z, [%[p], x8]\n"
+
+		"eor z0.d, z0.d, z1.d\n"
+		"eor z5.d, z5.d, z6.d\n"
+
+		"mov w7, %w[z0]\n"
+		"sub w7, w7, #1\n"
+
+		"1:\n"
+		"cmp w7, %w[start]\n"
+		"blt 2f\n"
+
+		"mov z3.d, z1.d\n"
+		"asr z3.b, p0/m, z3.b, #7\n"
+		"lsl z1.b, p0/m, z1.b, #1\n"
+		"and z3.d, z3.d, z4.d\n"
+		"eor z1.d, z1.d, z3.d\n"
+
+		"mov z8.d, z6.d\n"
+		"asr z8.b, p0/m, z8.b, #7\n"
+		"lsl z6.b, p0/m, z6.b, #1\n"
+		"and z8.d, z8.d, z4.d\n"
+		"eor z6.d, z6.d, z8.d\n"
+
+		"sxtw x8, w7\n"
+		"ldr x6, [%[dptr], x8, lsl #3]\n"
+		"ld1b z2.b, p0/z, [x6, x5]\n"
+		"add x8, x5, x3\n"
+		"ld1b z7.b, p0/z, [x6, x8]\n"
+
+		"eor z1.d, z1.d, z2.d\n"
+		"eor z0.d, z0.d, z2.d\n"
+
+		"eor z6.d, z6.d, z7.d\n"
+		"eor z5.d, z5.d, z7.d\n"
+
+		"sub w7, w7, #1\n"
+		"b 1b\n"
+		"2:\n"
+
+		"mov w7, %w[start]\n"
+		"sub w7, w7, #1\n"
+		"3:\n"
+		"cmp w7, #0\n"
+		"blt 4f\n"
+
+		"mov z3.d, z1.d\n"
+		"asr z3.b, p0/m, z3.b, #7\n"
+		"lsl z1.b, p0/m, z1.b, #1\n"
+		"and z3.d, z3.d, z4.d\n"
+		"eor z1.d, z1.d, z3.d\n"
+
+		"mov z8.d, z6.d\n"
+		"asr z8.b, p0/m, z8.b, #7\n"
+		"lsl z6.b, p0/m, z6.b, #1\n"
+		"and z8.d, z8.d, z4.d\n"
+		"eor z6.d, z6.d, z8.d\n"
+
+		"sub w7, w7, #1\n"
+		"b 3b\n"
+		"4:\n"
+
+		"ld1b z2.b, p0/z, [%[q], x5]\n"
+		"eor z1.d, z1.d, z2.d\n"
+		"st1b z0.b, p0, [%[p], x5]\n"
+		"st1b z1.b, p0, [%[q], x5]\n"
+
+		"add x8, x5, x3\n"
+		"ld1b z7.b, p0/z, [%[q], x8]\n"
+		"eor z6.d, z6.d, z7.d\n"
+		"st1b z5.b, p0, [%[p], x8]\n"
+		"st1b z6.b, p0, [%[q], x8]\n"
+
+		"add x5, x5, x3\n"
+		"add x5, x5, x3\n"
+		"cmp x5, %[bytes]\n"
+		"blt 0b\n"
+		:
+		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
+		  [p] "r" (p), [q] "r" (q), [start] "r" (start)
+		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
+		  "z0", "z1", "z2", "z3", "z4",
+		  "z5", "z6", "z7", "z8"
+	);
+}
+
+static void raid6_sve4_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	long z0 = disks - 3;
+
+	p = dptr[z0 + 1];
+	q = dptr[z0 + 2];
+
+	asm volatile(
+		".arch armv8.2-a+sve\n"
+		"ptrue p0.b\n"
+		"cntb x3\n"
+		"mov w4, #0x1d\n"
+		"dup z4.b, w4\n"
+		"mov x5, #0\n"
+
+		"0:\n"
+		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
+		"ld1b z0.b, p0/z, [x6, x5]\n"
+		"add x8, x5, x3\n"
+		"ld1b z5.b, p0/z, [x6, x8]\n"
+		"add x8, x8, x3\n"
+		"ld1b z10.b, p0/z, [x6, x8]\n"
+		"add x8, x8, x3\n"
+		"ld1b z15.b, p0/z, [x6, x8]\n"
+
+		"mov z1.d, z0.d\n"
+		"mov z6.d, z5.d\n"
+		"mov z11.d, z10.d\n"
+		"mov z16.d, z15.d\n"
+
+		"mov w7, %w[z0]\n"
+		"sub w7, w7, #1\n"
+
+		"1:\n"
+		"cmp w7, #0\n"
+		"blt 2f\n"
+
+		// software pipelining: load data early
+		"sxtw x8, w7\n"
+		"ldr x6, [%[dptr], x8, lsl #3]\n"
+		"ld1b z2.b, p0/z, [x6, x5]\n"
+		"add x8, x5, x3\n"
+		"ld1b z7.b, p0/z, [x6, x8]\n"
+		"add x8, x8, x3\n"
+		"ld1b z12.b, p0/z, [x6, x8]\n"
+		"add x8, x8, x3\n"
+		"ld1b z17.b, p0/z, [x6, x8]\n"
+
+		// math block 1
+		"mov z3.d, z1.d\n"
+		"asr z3.b, p0/m, z3.b, #7\n"
+		"lsl z1.b, p0/m, z1.b, #1\n"
+		"and z3.d, z3.d, z4.d\n"
+		"eor z1.d, z1.d, z3.d\n"
+		"eor z1.d, z1.d, z2.d\n"
+		"eor z0.d, z0.d, z2.d\n"
+
+		// math block 2
+		"mov z8.d, z6.d\n"
+		"asr z8.b, p0/m, z8.b, #7\n"
+		"lsl z6.b, p0/m, z6.b, #1\n"
+		"and z8.d, z8.d, z4.d\n"
+		"eor z6.d, z6.d, z8.d\n"
+		"eor z6.d, z6.d, z7.d\n"
+		"eor z5.d, z5.d, z7.d\n"
+
+		// math block 3
+		"mov z13.d, z11.d\n"
+		"asr z13.b, p0/m, z13.b, #7\n"
+		"lsl z11.b, p0/m, z11.b, #1\n"
+		"and z13.d, z13.d, z4.d\n"
+		"eor z11.d, z11.d, z13.d\n"
+		"eor z11.d, z11.d, z12.d\n"
+		"eor z10.d, z10.d, z12.d\n"
+
+		// math block 4
+		"mov z18.d, z16.d\n"
+		"asr z18.b, p0/m, z18.b, #7\n"
+		"lsl z16.b, p0/m, z16.b, #1\n"
+		"and z18.d, z18.d, z4.d\n"
+		"eor z16.d, z16.d, z18.d\n"
+		"eor z16.d, z16.d, z17.d\n"
+		"eor z15.d, z15.d, z17.d\n"
+
+		"sub w7, w7, #1\n"
+		"b 1b\n"
+		"2:\n"
+
+		"st1b z0.b, p0, [%[p], x5]\n"
+		"st1b z1.b, p0, [%[q], x5]\n"
+		"add x8, x5, x3\n"
+		"st1b z5.b, p0, [%[p], x8]\n"
+		"st1b z6.b, p0, [%[q], x8]\n"
+		"add x8, x8, x3\n"
+		"st1b z10.b, p0, [%[p], x8]\n"
+		"st1b z11.b, p0, [%[q], x8]\n"
+		"add x8, x8, x3\n"
+		"st1b z15.b, p0, [%[p], x8]\n"
+		"st1b z16.b, p0, [%[q], x8]\n"
+
+		"add x8, x3, x3\n"
+		"add x5, x5, x8, lsl #1\n"
+		"cmp x5, %[bytes]\n"
+		"blt 0b\n"
+		:
+		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
+		  [p] "r" (p), [q] "r" (q)
+		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
+		  "z0", "z1", "z2", "z3", "z4",
+		  "z5", "z6", "z7", "z8",
+		  "z10", "z11", "z12", "z13",
+		  "z15", "z16", "z17", "z18"
+	);
+}
+
+static void raid6_sve4_xor_syndrome_real(int disks, int start, int stop,
+					 unsigned long bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	long z0 = stop;
+
+	p = dptr[disks - 2];
+	q = dptr[disks - 1];
+
+	asm volatile(
+		".arch armv8.2-a+sve\n"
+		"ptrue p0.b\n"
+		"cntb x3\n"
+		"mov w4, #0x1d\n"
+		"dup z4.b, w4\n"
+		"mov x5, #0\n"
+
+		"0:\n"
+		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
+		"ld1b z1.b, p0/z, [x6, x5]\n"
+		"add x8, x5, x3\n"
+		"ld1b z6.b, p0/z, [x6, x8]\n"
+		"add x8, x8, x3\n"
+		"ld1b z11.b, p0/z, [x6, x8]\n"
+		"add x8, x8, x3\n"
+		"ld1b z16.b, p0/z, [x6, x8]\n"
+
+		"ld1b z0.b, p0/z, [%[p], x5]\n"
+		"add x8, x5, x3\n"
+		"ld1b z5.b, p0/z, [%[p], x8]\n"
+		"add x8, x8, x3\n"
+		"ld1b z10.b, p0/z, [%[p], x8]\n"
+		"add x8, x8, x3\n"
+		"ld1b z15.b, p0/z, [%[p], x8]\n"
+
+		"eor z0.d, z0.d, z1.d\n"
+		"eor z5.d, z5.d, z6.d\n"
+		"eor z10.d, z10.d, z11.d\n"
+		"eor z15.d, z15.d, z16.d\n"
+
+		"mov w7, %w[z0]\n"
+		"sub w7, w7, #1\n"
+
+		"1:\n"
+		"cmp w7, %w[start]\n"
+		"blt 2f\n"
+
+		// software pipelining: load data early
+		"sxtw x8, w7\n"
+		"ldr x6, [%[dptr], x8, lsl #3]\n"
+		"ld1b z2.b, p0/z, [x6, x5]\n"
+		"add x8, x5, x3\n"
+		"ld1b z7.b, p0/z, [x6, x8]\n"
+		"add x8, x8, x3\n"
+		"ld1b z12.b, p0/z, [x6, x8]\n"
+		"add x8, x8, x3\n"
+		"ld1b z17.b, p0/z, [x6, x8]\n"
+
+		// math block 1
+		"mov z3.d, z1.d\n"
+		"asr z3.b, p0/m, z3.b, #7\n"
+		"lsl z1.b, p0/m, z1.b, #1\n"
+		"and z3.d, z3.d, z4.d\n"
+		"eor z1.d, z1.d, z3.d\n"
+		"eor z1.d, z1.d, z2.d\n"
+		"eor z0.d, z0.d, z2.d\n"
+
+		// math block 2
+		"mov z8.d, z6.d\n"
+		"asr z8.b, p0/m, z8.b, #7\n"
+		"lsl z6.b, p0/m, z6.b, #1\n"
+		"and z8.d, z8.d, z4.d\n"
+		"eor z6.d, z6.d, z8.d\n"
+		"eor z6.d, z6.d, z7.d\n"
+		"eor z5.d, z5.d, z7.d\n"
+
+		// math block 3
+		"mov z13.d, z11.d\n"
+		"asr z13.b, p0/m, z13.b, #7\n"
+		"lsl z11.b, p0/m, z11.b, #1\n"
+		"and z13.d, z13.d, z4.d\n"
+		"eor z11.d, z11.d, z13.d\n"
+		"eor z11.d, z11.d, z12.d\n"
+		"eor z10.d, z10.d, z12.d\n"
+
+		// math block 4
+		"mov z18.d, z16.d\n"
+		"asr z18.b, p0/m, z18.b, #7\n"
+		"lsl z16.b, p0/m, z16.b, #1\n"
+		"and z18.d, z18.d, z4.d\n"
+		"eor z16.d, z16.d, z18.d\n"
+		"eor z16.d, z16.d, z17.d\n"
+		"eor z15.d, z15.d, z17.d\n"
+
+		"sub w7, w7, #1\n"
+		"b 1b\n"
+		"2:\n"
+
+		"mov w7, %w[start]\n"
+		"sub w7, w7, #1\n"
+		"3:\n"
+		"cmp w7, #0\n"
+		"blt 4f\n"
+
+		// math block 1
+		"mov z3.d, z1.d\n"
+		"asr z3.b, p0/m, z3.b, #7\n"
+		"lsl z1.b, p0/m, z1.b, #1\n"
+		"and z3.d, z3.d, z4.d\n"
+		"eor z1.d, z1.d, z3.d\n"
+
+		// math block 2
+		"mov z8.d, z6.d\n"
+		"asr z8.b, p0/m, z8.b, #7\n"
+		"lsl z6.b, p0/m, z6.b, #1\n"
+		"and z8.d, z8.d, z4.d\n"
+		"eor z6.d, z6.d, z8.d\n"
+
+		// math block 3
+		"mov z13.d, z11.d\n"
+		"asr z13.b, p0/m, z13.b, #7\n"
+		"lsl z11.b, p0/m, z11.b, #1\n"
+		"and z13.d, z13.d, z4.d\n"
+		"eor z11.d, z11.d, z13.d\n"
+
+		// math block 4
+		"mov z18.d, z16.d\n"
+		"asr z18.b, p0/m, z18.b, #7\n"
+		"lsl z16.b, p0/m, z16.b, #1\n"
+		"and z18.d, z18.d, z4.d\n"
+		"eor z16.d, z16.d, z18.d\n"
+
+		"sub w7, w7, #1\n"
+		"b 3b\n"
+		"4:\n"
+
+		// Load q and XOR
+		"ld1b z2.b, p0/z, [%[q], x5]\n"
+		"add x8, x5, x3\n"
+		"ld1b z7.b, p0/z, [%[q], x8]\n"
+		"add x8, x8, x3\n"
+		"ld1b z12.b, p0/z, [%[q], x8]\n"
+		"add x8, x8, x3\n"
+		"ld1b z17.b, p0/z, [%[q], x8]\n"
+
+		"eor z1.d, z1.d, z2.d\n"
+		"eor z6.d, z6.d, z7.d\n"
+		"eor z11.d, z11.d, z12.d\n"
+		"eor z16.d, z16.d, z17.d\n"
+
+		// Store results
+		"st1b z0.b, p0, [%[p], x5]\n"
+		"st1b z1.b, p0, [%[q], x5]\n"
+		"add x8, x5, x3\n"
+		"st1b z5.b, p0, [%[p], x8]\n"
+		"st1b z6.b, p0, [%[q], x8]\n"
+		"add x8, x8, x3\n"
+		"st1b z10.b, p0, [%[p], x8]\n"
+		"st1b z11.b, p0, [%[q], x8]\n"
+		"add x8, x8, x3\n"
+		"st1b z15.b, p0, [%[p], x8]\n"
+		"st1b z16.b, p0, [%[q], x8]\n"
+
+		"add x8, x3, x3\n"
+		"add x5, x5, x8, lsl #1\n"
+		"cmp x5, %[bytes]\n"
+		"blt 0b\n"
+		:
+		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
+		  [p] "r" (p), [q] "r" (q), [start] "r" (start)
+		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
+		  "z0", "z1", "z2", "z3", "z4",
+		  "z5", "z6", "z7", "z8",
+		  "z10", "z11", "z12", "z13",
+		  "z15", "z16", "z17", "z18"
+	);
+}
+
+#define RAID6_SVE_WRAPPER(_n)						\
+	static void raid6_sve ## _n ## _gen_syndrome(int disks,		\
+					size_t bytes, void **ptrs)	\
+	{								\
+		scoped_ksimd()						\
+		raid6_sve ## _n ## _gen_syndrome_real(disks,		\
+					(unsigned long)bytes, ptrs);	\
+	}								\
+	static void raid6_sve ## _n ## _xor_syndrome(int disks,		\
+					int start, int stop,		\
+					size_t bytes, void **ptrs)	\
+	{								\
+		scoped_ksimd()						\
+		raid6_sve ## _n ## _xor_syndrome_real(disks,		\
+				start, stop, (unsigned long)bytes, ptrs);\
+	}								\
+	struct raid6_calls const raid6_svex ## _n = {			\
+		raid6_sve ## _n ## _gen_syndrome,			\
+		raid6_sve ## _n ## _xor_syndrome,			\
+		raid6_have_sve,						\
+		"svex" #_n,						\
+		0							\
+	}
+
+static int raid6_have_sve(void)
+{
+	return system_supports_sve();
+}
+
+RAID6_SVE_WRAPPER(1);
+RAID6_SVE_WRAPPER(2);
+RAID6_SVE_WRAPPER(4);
-- 
2.43.0

