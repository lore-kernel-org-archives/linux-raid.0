Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D6836BCE7
	for <linux-raid@vger.kernel.org>; Wed, 18 Mar 2026 15:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773846168; cv=none; b=tKzhglc9qm3LFlLPSbQwYPcx8+vT0C/PyZeMP6nQFjnQS16qBkXhWYYlCZr/sYI+xbK0rO6E0xWPNcmQoFEIar0Kkbx7q+v3Khp9IKUYOEh80q+NrADB12uXkfrWIDgbg0abXry0CkyXFfmvvO++bDdTk0QPMxceeh78Z+T1d3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773846168; c=relaxed/simple;
	bh=yKBxTRmF78NKuhsiSbdjTnlZFFMRE73Qk9aP1VBrzvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gB/UbMksxjPRN8ygFfCfoxlzsOP07gjNxhTnhupuX5ccQt0aQ0xSRjTwCv0f8crCBy9bG64NJahRKTl/hDSU1vcBlA7aA14h9T9zBFUHwJmXwQjw+y81J9IvTo1G65GVbd9mw46/TJM2U/xzqtKoppIDZq8Ou4zgwygScoCocss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XrQr9UIO; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XrQr9UIO"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38a2a59baa6so57793871fa.2
        for <linux-raid@vger.kernel.org>; Wed, 18 Mar 2026 08:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773846163; x=1774450963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GfCCpHgQ8JNaauZbesBEyz3ZlGKRin1zXLSVY+rqGfo=;
        b=XrQr9UIODLFhWMpldvvChW6rMpy0fM3+3M0w8MxxGcVhQCjVPD8GZG+PUMNj89B02j
         r9dq4RTzx8z1zM7vV3V5Qx6rF362jnS6xQVJ2T1iLMXKZyp/CdeTfmI4GEK+fjuaK8+F
         Z8mr4PDX0YrMmedM9tcUMMjsrn0DKuKK6tv/FRllzf/8OK9jQp0Ztd1JdkS/h2JX0tWl
         mqCmyA9LRjspJoz3uNb6Ry1fhVCUo6pnng0esIUrYHueyBTHF5i+9bJ5xNxqh5l7+Euf
         kxMjUizgSsvgtd7kCnejRy2YLYNyJcll7MreJec8xsfe41Yq4yM5OGH5h2CZvETgtm3C
         obRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773846163; x=1774450963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GfCCpHgQ8JNaauZbesBEyz3ZlGKRin1zXLSVY+rqGfo=;
        b=BVe/F/TOvfNvzccKTTgmhb8zQTodl1bOkVi/B8Vee7lg8Xboe/I6B9KD0fisBNeLY9
         T3z9UAC4hVlS8Gf8SJjBi/pIQfOp4NxkfKCRenQdnn++qxLgzUT+4BiEAMxALEuZh7Fl
         +VlCNXkFOpW42oqPPiy4pqAo6v/QsE+7qQ6KbpxZa9zI1oh4Sw7d/SBehudUPym7N9gq
         cK6rm8FoXOVDhPFVpDShA7shh+OJfLETGPgTQG8KuE6GM2wxHeXjHBBezIcbLzytAgL+
         AQX3kGJLoJBFWbpbAAYoNmb9E5n6HvZPuiECcT3S3VJRufktdUCEZLFGyc5uB5lf7ZoL
         EufA==
X-Forwarded-Encrypted: i=1; AJvYcCWKrZn3xA8OLeRk6FG6olABZah+rjK55npZ9W0TOkrdEhXmoVxd/DdUiNeQHydJ+Yj8MBFLQi5QlbmH@vger.kernel.org
X-Gm-Message-State: AOJu0YyrJh9wDmolEwRy3Gfzbm5o11AHlM22fVsjf0TGD2fPihxXKBNF
	k560U4adGemXIRkVbzLu6zjlg6ndskGnLm+JVwX21qVbS3U9PUwGXGrmFLKLixq/
X-Gm-Gg: ATEYQzycoAyQw0kwVpF35ep9QU7PUGGiLlfniPyIlZGT4cMKFA55IFUPyZk81v763vt
	Atd3Hb6UMpAB9ZKIA436MSj/y3wDTSQ2BcY/LEq2e9wPB/aLbevQKWyxa8+C8kkDSsWMKmd+vKD
	5N9BjwUsWORdZOtQrL+gjeWH+KJYERQYaaI84/IusCRGGSOH5rVvMxtMJwPDcFFspDsSNpe17XT
	tqr2b9hm/E3IoLY8Sp+bWZyysNWhY1FdXLr+huwtz8tOQKgbUcc3b/mYeXSjP3roW78AjTShSJB
	BWyM3fmh2JYrI3kk2RR5ZnIESLgjZgTRWcGc5kPmyRzot/ICJF25h34+za/BjrpcySwyKfv+FME
	Uh5Tz/BjVp99r0bl+YJC7jKH9wGEfgQz80YhLTKe6hHKCO87+gd//eDtlM3LCyxNwW1prjFa4uN
	p0ykLO3azaMn3WL9DkcZGukPywOQ5aUYAxM1wk
X-Received: by 2002:a2e:bc26:0:b0:38b:d799:e061 with SMTP id 38308e7fff4ca-38bd799e3d5mr13192261fa.18.1773846162766;
        Wed, 18 Mar 2026 08:02:42 -0700 (PDT)
Received: from lima-dev.. ([178.137.234.67])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38bd517e0e8sm6601891fa.17.2026.03.18.08.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 08:02:42 -0700 (PDT)
From: Demian Shulhan <demyansh@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>
Cc: Li Nan <linan122@huawei.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Demian Shulhan <demyansh@gmail.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v2] raid6: arm64: add SVE optimized implementation for syndrome generation
Date: Wed, 18 Mar 2026 15:01:42 +0000
Message-ID: <20260318150142.3080390-1-demyansh@gmail.com>
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

