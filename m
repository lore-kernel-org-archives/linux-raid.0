Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31E23D47AD
	for <linux-raid@vger.kernel.org>; Tue, 31 Mar 2026 07:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774943399; cv=none; b=nLW5ouQmSxnGQCwjoBZTKvFNNfGzoozCvu1eHSxjGmtBVUPq/EYYWXXBALupFUCasmyg7iHwAqnZ8N5VL7p+OgwmkTSgWVojnS0mdP85DfAIROlsZY3iSFrQ8+EAR/2DXG/c56CFRoYCgFh47eu0x9joZuMATuC2pzNuzM8Bvzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774943399; c=relaxed/simple;
	bh=CGCIXIbANKjnlVIWdJjOlF+xSkzvo1pAWMhL/x0wZTI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WeyrVDAKQZcYSK6ROeOAl2b6IYEhsdJZT8R7viA5hyknRQxa9wVSKNMwCHLCABa9nznRpnnaMURLqzUMk3VAcH1ynZiOuLn6/vbGPjs1DIQewGLiV11m3I67NEoqmG6E1FF0AAXekzLvmJCrEl3nXUnj6/AiZYv0xmfnCKxBxT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JwIITIID; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JwIITIID"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48532df52c5so58039195e9.1
        for <linux-raid@vger.kernel.org>; Tue, 31 Mar 2026 00:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774943395; x=1775548195; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tqBesCV1iVGFjs/+MQv4dUKUK6pO8mTUu//mtGexVyc=;
        b=JwIITIIDtNWLtw8/9foU7XbBAl9SDw0MXiE+LFAlFjg9GFNKwkuI/MjJFhy+ZSbUak
         miczWziHZoUtuOJ+91IOwbhlm88BWjoLdcTF39r45g02T1PKqOhBCshzrEFE/K0M8PJK
         TYtQ/tDIzMxYZisQ1mIiCxkIWNJC/6+YXBq+w23Uu2TlBEqfeF9YJfwCgmBLcIMT9GOs
         qQtNwlAUigtqHw44Rcxh+kixy3opRIPCauFsPg5h0HVbn6gHgIT1vTg2B9nWEgsZiwkx
         a2NWQXEypufR/2h08X8CUvosb0o1XSxHk/ozMAlMOKU1c0T63copMPxQ06a1QF/WAz3l
         zdXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774943395; x=1775548195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tqBesCV1iVGFjs/+MQv4dUKUK6pO8mTUu//mtGexVyc=;
        b=iCC4LXnPqRvdHUUY5Jxx0f/Vbmfc7Kpky2SR+z0/RYIIcX4RpVqp3Wkd663jqu3272
         czWHsRrjf02ur7QyWp10tpP0PsInHLRqB6KVH2unRbYzn8sa56Qffi6AJGS7AhkJ6iZr
         hH8L7ByNR7A4QY5kGuYMBJv3ywrflPWAz1tIr9oaINRXWXKJj23F1hK3KK/uGBe1yGGM
         ocZrh26HvCR5OnfdfTsfBsXHvGFb7AmDah10K7ylbJJfrLG9u6dsPTUNXGkaUb68Q0ml
         rs8dj+mJVmTBerWcjsAae2Ase0Npyly5/TT3B8QIblSs0Pw26pBG437uepMvkzgBpWxM
         O65w==
X-Gm-Message-State: AOJu0Yzu1ONFgUCfjYpViYMp2GPcZS7oBw5sNt29YVoMkrtBhE1Kkt4q
	9T1mD96LURhHs1MmXYjATJ84NUUdI1FI4vdO5Qg2Af/nHWOY7zld/ljncmR25h15sIqzHEWEL3c
	cAAJ3lhaCmSyxICxdVmO4AsJE2VnXDYtVycKlqQZgytGF3GSYt8kk3aY8UiiB9Pwr9/0MfkeVyg
	fUoAJbY7rnHAUvRcn/drUUSCAQuM5+oUQ=
X-Received: from wmph38.prod.google.com ([2002:a05:600c:49a6:b0:486:fe68:2045])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:621b:b0:483:9139:4c1d
 with SMTP id 5b1f17b1804b1-48727d87f18mr281347235e9.14.1774943394851; Tue, 31
 Mar 2026 00:49:54 -0700 (PDT)
Date: Tue, 31 Mar 2026 09:49:43 +0200
In-Reply-To: <20260331074940.55502-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260331074940.55502-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=8240; i=ardb@kernel.org;
 h=from:subject; bh=2HOdmXCw5GMomfEjnLJM2NrjzlJj2ghqB/RAm4StiJM=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN0zczuu1Vxe435Xjm832Ey3SfZ8uqB3+9+bLxgnXt1j
 fDP/5VlHaUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAiilsZGW7wGG97EF578yXP
 pCdu14velHx3Pih5am/YzBXW1y1Zjh9nZDjnnr5gfbQkx/7juq5zvJekB9mGbuOe83PXErPrSip 7ozgB
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260331074940.55502-10-ardb+git@google.com>
Subject: [PATCH v2 3/5] xor/arm: Replace vectorized implementation with
 arm64's intrinsics
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-raid@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Drop the XOR implementation generated by the vectorizer: this has always
been a bit of a hack, and now that arm64 has an intrinsics version that
works on ARM too, let's use that instead.

So copy the part of the arm64 code that can be shared (so not the EOR3
version). The arm64 code will be updated in a subsequent patch to share
this implementation.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/raid/xor/arm/xor-neon.c | 183 ++++++++++++++++++--
 lib/raid/xor/arm/xor-neon.h |   7 +
 lib/raid/xor/arm/xor_arch.h |   7 +-
 lib/raid/xor/xor-8regs.c    |   2 -
 4 files changed, 174 insertions(+), 25 deletions(-)

diff --git a/lib/raid/xor/arm/xor-neon.c b/lib/raid/xor/arm/xor-neon.c
index 23147e3a7904..a3e2b4af8d36 100644
--- a/lib/raid/xor/arm/xor-neon.c
+++ b/lib/raid/xor/arm/xor-neon.c
@@ -1,26 +1,175 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
+ * Authors: Jackie Liu <liuyun01@kylinos.cn>
+ * Copyright (C) 2018,Tianjin KYLIN Information Technology Co., Ltd.
  */
 
 #include "xor_impl.h"
-#include "xor_arch.h"
+#include "xor-neon.h"
 
-#ifndef __ARM_NEON__
-#error You should compile this file with '-march=armv7-a -mfloat-abi=softfp -mfpu=neon'
-#endif
+#include <asm/neon-intrinsics.h>
 
-/*
- * Pull in the reference implementations while instructing GCC (through
- * -ftree-vectorize) to attempt to exploit implicit parallelism and emit
- * NEON instructions. Clang does this by default at O2 so no pragma is
- * needed.
- */
-#ifdef CONFIG_CC_IS_GCC
-#pragma GCC optimize "tree-vectorize"
-#endif
+static void __xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 */
+		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
+		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
+		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
+		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
+
+		/* store */
+		vst1q_u64(dp1 +  0, v0);
+		vst1q_u64(dp1 +  2, v1);
+		vst1q_u64(dp1 +  4, v2);
+		vst1q_u64(dp1 +  6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+	} while (--lines > 0);
+}
+
+static void __xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+	uint64_t *dp3 = (uint64_t *)p3;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 */
+		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
+		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
+		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
+		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
+
+		/* p1 ^= p3 */
+		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
+
+		/* store */
+		vst1q_u64(dp1 +  0, v0);
+		vst1q_u64(dp1 +  2, v1);
+		vst1q_u64(dp1 +  4, v2);
+		vst1q_u64(dp1 +  6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+	} while (--lines > 0);
+}
+
+static void __xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+	uint64_t *dp3 = (uint64_t *)p3;
+	uint64_t *dp4 = (uint64_t *)p4;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 */
+		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
+		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
+		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
+		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
+
+		/* p1 ^= p3 */
+		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
+
+		/* p1 ^= p4 */
+		v0 = veorq_u64(v0, vld1q_u64(dp4 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp4 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp4 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp4 +  6));
+
+		/* store */
+		vst1q_u64(dp1 +  0, v0);
+		vst1q_u64(dp1 +  2, v1);
+		vst1q_u64(dp1 +  4, v2);
+		vst1q_u64(dp1 +  6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+		dp4 += 8;
+	} while (--lines > 0);
+}
+
+static void __xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4,
+		const unsigned long * __restrict p5)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+	uint64_t *dp3 = (uint64_t *)p3;
+	uint64_t *dp4 = (uint64_t *)p4;
+	uint64_t *dp5 = (uint64_t *)p5;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 */
+		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
+		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
+		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
+		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
+
+		/* p1 ^= p3 */
+		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
+
+		/* p1 ^= p4 */
+		v0 = veorq_u64(v0, vld1q_u64(dp4 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp4 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp4 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp4 +  6));
+
+		/* p1 ^= p5 */
+		v0 = veorq_u64(v0, vld1q_u64(dp5 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp5 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp5 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp5 +  6));
+
+		/* store */
+		vst1q_u64(dp1 +  0, v0);
+		vst1q_u64(dp1 +  2, v1);
+		vst1q_u64(dp1 +  4, v2);
+		vst1q_u64(dp1 +  6, v3);
 
-#define NO_TEMPLATE
-#include "../xor-8regs.c"
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+		dp4 += 8;
+		dp5 += 8;
+	} while (--lines > 0);
+}
 
-__DO_XOR_BLOCKS(neon_inner, xor_8regs_2, xor_8regs_3, xor_8regs_4, xor_8regs_5);
+__DO_XOR_BLOCKS(neon_inner, __xor_neon_2, __xor_neon_3, __xor_neon_4,
+		__xor_neon_5);
diff --git a/lib/raid/xor/arm/xor-neon.h b/lib/raid/xor/arm/xor-neon.h
new file mode 100644
index 000000000000..406e0356f05b
--- /dev/null
+++ b/lib/raid/xor/arm/xor-neon.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+extern struct xor_block_template xor_block_arm4regs;
+extern struct xor_block_template xor_block_neon;
+
+void xor_gen_neon_inner(void *dest, void **srcs, unsigned int src_cnt,
+		unsigned int bytes);
diff --git a/lib/raid/xor/arm/xor_arch.h b/lib/raid/xor/arm/xor_arch.h
index 775ff835df65..f1ddb64fe62a 100644
--- a/lib/raid/xor/arm/xor_arch.h
+++ b/lib/raid/xor/arm/xor_arch.h
@@ -3,12 +3,7 @@
  *  Copyright (C) 2001 Russell King
  */
 #include <asm/neon.h>
-
-extern struct xor_block_template xor_block_arm4regs;
-extern struct xor_block_template xor_block_neon;
-
-void xor_gen_neon_inner(void *dest, void **srcs, unsigned int src_cnt,
-		unsigned int bytes);
+#include "xor-neon.h"
 
 static __always_inline void __init arch_xor_init(void)
 {
diff --git a/lib/raid/xor/xor-8regs.c b/lib/raid/xor/xor-8regs.c
index 1edaed8acffe..46b3c8bdc27f 100644
--- a/lib/raid/xor/xor-8regs.c
+++ b/lib/raid/xor/xor-8regs.c
@@ -93,11 +93,9 @@ xor_8regs_5(unsigned long bytes, unsigned long * __restrict p1,
 	} while (--lines > 0);
 }
 
-#ifndef NO_TEMPLATE
 DO_XOR_BLOCKS(8regs, xor_8regs_2, xor_8regs_3, xor_8regs_4, xor_8regs_5);
 
 struct xor_block_template xor_block_8regs = {
 	.name		= "8regs",
 	.xor_gen	= xor_gen_8regs,
 };
-#endif /* NO_TEMPLATE */
-- 
2.53.0.1018.g2bb0e51243-goog

