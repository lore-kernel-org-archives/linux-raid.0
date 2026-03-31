Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08C13CE48F
	for <linux-raid@vger.kernel.org>; Tue, 31 Mar 2026 07:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774943399; cv=none; b=QWCzSNtqZKxJqp8qn2PJtkez0vcvpIDYflF2qDP/Q/aaPMBJSEzRO7Rg46o2cqaYpUn7kcphSqBLPeq/X1htSs98qvlsE5E+OciHTIasNYOGr5mWAyWbpvtCVRwHt4tBLsPJFJzFRtzMv0e1LxSOPvq+NJKIs8YVSmSdrjoNuVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774943399; c=relaxed/simple;
	bh=atBxVpG1MRmFlSg8zHVJ3O+nq6TSdfbnEAK7Y/PFMms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ObCe3piYq9AzUdNsxmRVNZeyX7qes3pzER+sQ/eiEjgFAKCRFxlFEK59J1SSr/VzoJguwRf6SApuYQRzdyAHWfdoyDWLP62RtwJoFqPCQYM+TS0J7PdSnr6SQLIMmOS8LSyHRKQyooXIsYj/AU5u1n/touhxBdzCiUStb0uJwBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tkFM5u5e; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tkFM5u5e"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so49245105e9.3
        for <linux-raid@vger.kernel.org>; Tue, 31 Mar 2026 00:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774943396; x=1775548196; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gi9Cem+79JlTHpKD7Csp1LYarBVlhKoya6zNjC01wME=;
        b=tkFM5u5eyV7VW8DltqgTtYToaWCMiVAQql0F1/bzFRvnc41mZYzcjDIfe3dCM0kR4X
         Bz5hCxYq8mrjTT2FMK0Ib0ogL8TIs9aVXe2iDwV4KmqBH3ppxAWoxyNL66JRVz00VfSJ
         fXzFjkxt7sUkjB8v9qYuqAnH1WRbIP7V39BCRfmMrRJNQfQhz3kYBbvRGbcu1SAxhWNl
         u3i5xee9vDRL0g67mteGZSw/SwhaL41iJVBIKHtyLcwq1FPLuHjEZ2MviPPXWkGrUry0
         tWNRjK3xRfhjJYNzMQ8gJqA4WKOBVAvcb2hDpMpgl1ksXtE9mXFbJTy5mW17cd4K9zMA
         leSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774943396; x=1775548196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gi9Cem+79JlTHpKD7Csp1LYarBVlhKoya6zNjC01wME=;
        b=E1KtEzxS5zzkluv0bOTXR93UmxuvA7pGnoN32r5qOKVznBRBzlQIEYQHKZzXUaNI9B
         //hiskG5HtOq44TlSpF2eHjaQUj50gFqLx0B6FcW8CM5ks4Ts6avLUh8bhQw0q069uys
         o+B4YYTS0QeW6IxF7BMEENp/4qpcykazpft6xU0K2jOfiHNd1jK1sBD2uPIN255BQkyA
         ffFT9nSndBb7ztLY6bPttjBFmrsJgFyU6ryhz/Pf0/ApSeZ3TPjBzdTqjL1ZmD+vJZAd
         tXd4sGtu2j5EcsBIXqA1zvGHTzLBCLEQKS3YMR/cxHgfxpH7+riz5TOC0U7dnTJJhVWm
         Zs4Q==
X-Gm-Message-State: AOJu0YxUJSsMPy7OG9aWEgQR01PSEQaqYap3wcbAkyfP46AznOBwhvm7
	CdzsGAoXSdmoiAX9PHNcZWR7OveFy++JlAVbsBTrKQHV1hgudB5npdS+twfiqcN1cb+1F9Q/TLe
	JQycGiqW7gBFKCzGbBQtbswfK0608csGiZVFwqZJmH/OLima2vSVsqLOAMNVfWwpY7H7rtVtkQ9
	tR828VR8Mn2+RYlq7FEK813sFdiyQAfGk=
X-Received: from wmg15.prod.google.com ([2002:a05:600c:22cf:b0:483:a1ee:5eca])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e15:b0:477:7ae0:cd6e
 with SMTP id 5b1f17b1804b1-48727d5a16fmr261564395e9.5.1774943396116; Tue, 31
 Mar 2026 00:49:56 -0700 (PDT)
Date: Tue, 31 Mar 2026 09:49:44 +0200
In-Reply-To: <20260331074940.55502-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260331074940.55502-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=7427; i=ardb@kernel.org;
 h=from:subject; bh=CV0qFP0DlqNmCBgCBDEE3xAee2gYtqdznvlLU2UGzTs=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN0zawPW8+tUVdv/t0rwljXElDoosL0Z0XOxmVqT+Unl
 l1Kz7bsKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPhq2D4zSbmci9xYqzP7Zyl
 p/x6D1sEct4/wKPuJb2mdnd8U/TvTkaGuSe1jU9MP9/+pmPns75jas4JM6+XNfRF7p8cdtK2df9 WNgA=
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260331074940.55502-11-ardb+git@google.com>
Subject: [PATCH v2 4/5] xor/arm64: Use shared NEON intrinsics implementation
 from 32-bit ARM
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-raid@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Tweak the arm64 code so that the pure NEON intrinsics implementation of
XOR is shared between arm64 and ARM.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/raid/xor/Makefile         |   3 +-
 lib/raid/xor/arm/xor-neon.c   |   4 +
 lib/raid/xor/arm64/xor-neon.c | 172 +-------------------
 3 files changed, 9 insertions(+), 170 deletions(-)

diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
index 4d633dfd5b90..b27bf5156784 100644
--- a/lib/raid/xor/Makefile
+++ b/lib/raid/xor/Makefile
@@ -19,7 +19,8 @@ xor-$(CONFIG_ARM)		+= arm/xor.o
 ifeq ($(CONFIG_ARM),y)
 xor-$(CONFIG_KERNEL_MODE_NEON)	+= arm/xor-neon.o arm/xor-neon-glue.o
 endif
-xor-$(CONFIG_ARM64)		+= arm64/xor-neon.o arm64/xor-neon-glue.o
+xor-$(CONFIG_ARM64)		+= arm/xor-neon.o arm64/xor-neon.o \
+				   arm64/xor-neon-glue.o
 xor-$(CONFIG_CPU_HAS_LSX)	+= loongarch/xor_simd.o
 xor-$(CONFIG_CPU_HAS_LSX)	+= loongarch/xor_simd_glue.o
 xor-$(CONFIG_ALTIVEC)		+= powerpc/xor_vmx.o powerpc/xor_vmx_glue.o
diff --git a/lib/raid/xor/arm/xor-neon.c b/lib/raid/xor/arm/xor-neon.c
index a3e2b4af8d36..c7c3cf634e23 100644
--- a/lib/raid/xor/arm/xor-neon.c
+++ b/lib/raid/xor/arm/xor-neon.c
@@ -173,3 +173,7 @@ static void __xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
 
 __DO_XOR_BLOCKS(neon_inner, __xor_neon_2, __xor_neon_3, __xor_neon_4,
 		__xor_neon_5);
+
+#ifdef CONFIG_ARM64
+extern typeof(__xor_neon_2) __xor_eor3_2 __alias(__xor_neon_2);
+#endif
diff --git a/lib/raid/xor/arm64/xor-neon.c b/lib/raid/xor/arm64/xor-neon.c
index 97ef3cb92496..e44016c363f1 100644
--- a/lib/raid/xor/arm64/xor-neon.c
+++ b/lib/raid/xor/arm64/xor-neon.c
@@ -1,8 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * Authors: Jackie Liu <liuyun01@kylinos.cn>
- * Copyright (C) 2018,Tianjin KYLIN Information Technology Co., Ltd.
- */
 
 #include <linux/cache.h>
 #include <asm/neon-intrinsics.h>
@@ -10,170 +6,8 @@
 #include "xor_arch.h"
 #include "xor-neon.h"
 
-static void __xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
-		const unsigned long * __restrict p2)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 */
-		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
-		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
-		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
-		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
-
-		/* store */
-		vst1q_u64(dp1 +  0, v0);
-		vst1q_u64(dp1 +  2, v1);
-		vst1q_u64(dp1 +  4, v2);
-		vst1q_u64(dp1 +  6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-	} while (--lines > 0);
-}
-
-static void __xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
-		const unsigned long * __restrict p2,
-		const unsigned long * __restrict p3)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 */
-		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
-		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
-		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
-		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
-
-		/* p1 ^= p3 */
-		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
-
-		/* store */
-		vst1q_u64(dp1 +  0, v0);
-		vst1q_u64(dp1 +  2, v1);
-		vst1q_u64(dp1 +  4, v2);
-		vst1q_u64(dp1 +  6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-	} while (--lines > 0);
-}
-
-static void __xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
-		const unsigned long * __restrict p2,
-		const unsigned long * __restrict p3,
-		const unsigned long * __restrict p4)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-	uint64_t *dp4 = (uint64_t *)p4;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 */
-		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
-		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
-		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
-		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
-
-		/* p1 ^= p3 */
-		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
-
-		/* p1 ^= p4 */
-		v0 = veorq_u64(v0, vld1q_u64(dp4 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp4 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp4 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp4 +  6));
-
-		/* store */
-		vst1q_u64(dp1 +  0, v0);
-		vst1q_u64(dp1 +  2, v1);
-		vst1q_u64(dp1 +  4, v2);
-		vst1q_u64(dp1 +  6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-		dp4 += 8;
-	} while (--lines > 0);
-}
-
-static void __xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
-		const unsigned long * __restrict p2,
-		const unsigned long * __restrict p3,
-		const unsigned long * __restrict p4,
-		const unsigned long * __restrict p5)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-	uint64_t *dp4 = (uint64_t *)p4;
-	uint64_t *dp5 = (uint64_t *)p5;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 */
-		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
-		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
-		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
-		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
-
-		/* p1 ^= p3 */
-		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
-
-		/* p1 ^= p4 */
-		v0 = veorq_u64(v0, vld1q_u64(dp4 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp4 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp4 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp4 +  6));
-
-		/* p1 ^= p5 */
-		v0 = veorq_u64(v0, vld1q_u64(dp5 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp5 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp5 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp5 +  6));
-
-		/* store */
-		vst1q_u64(dp1 +  0, v0);
-		vst1q_u64(dp1 +  2, v1);
-		vst1q_u64(dp1 +  4, v2);
-		vst1q_u64(dp1 +  6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-		dp4 += 8;
-		dp5 += 8;
-	} while (--lines > 0);
-}
-
-__DO_XOR_BLOCKS(neon_inner, __xor_neon_2, __xor_neon_3, __xor_neon_4,
-		__xor_neon_5);
+extern void __xor_eor3_2(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2);
 
 static inline uint64x2_t eor3(uint64x2_t p, uint64x2_t q, uint64x2_t r)
 {
@@ -308,5 +142,5 @@ static void __xor_eor3_5(unsigned long bytes, unsigned long * __restrict p1,
 	} while (--lines > 0);
 }
 
-__DO_XOR_BLOCKS(eor3_inner, __xor_neon_2, __xor_eor3_3, __xor_eor3_4,
+__DO_XOR_BLOCKS(eor3_inner, __xor_eor3_2, __xor_eor3_3, __xor_eor3_4,
 		__xor_eor3_5);
-- 
2.53.0.1018.g2bb0e51243-goog

