Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B820C361DC0
	for <linux-raid@vger.kernel.org>; Fri, 27 Mar 2026 11:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611081; cv=none; b=k9NUkepZaEqAy7Uo1mmdQHyJaZKWFJuHrtE2T89rYjhA9YZ2VK+692OagTsruXXIbeBVTTjlMNQ5YqIHUDyRmPnE+8S7VVHLRsH2/YIbI/pFJv1IejSNj2yeF7AuDEnlkBg5JMOIRekfLv3NvVEq9HW58Y/D5g9RlCJMFtfq7EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611081; c=relaxed/simple;
	bh=KeAZgmNoQ1sUDEkWya36HJcL7gSNeptMNmaeLJNQ/jE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PX4lDkMOM2vUWtU5APMUJCGzcnLy8lNwjMkJ7zTvTE9BrTqzNyUFtrQbg03GDNKs9AM+H6L5RAnJFX+lb2xpB+DUYg7HsGX1psBb0Pgq2QLhIY4dyvKP0ErFcxkkhVRkTB8n8TZwYzAfJjlBR+yo/tIqCS9Mmme4GPB/QUZU7Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=si4HmD+x; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="si4HmD+x"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4852d27f473so13146725e9.1
        for <linux-raid@vger.kernel.org>; Fri, 27 Mar 2026 04:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774611077; x=1775215877; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6lpGVX/QCmQJUj33QJcU41GXVAqHMjHSyUsmEQf/VZk=;
        b=si4HmD+xpfBLEh2AWk7DlomzGzUlhFO12SB2XP+I4dIW/ALFSS7TG+P0mS9JPaKtd/
         CJNWFkH5WxqpE9RQiQh0g3xGgMA70v6S9I2wHySPqFhwZlaDw8/SFUtERJWD4ir1RHxC
         W5FLi+ohD/i9RpDUYIoG7PYqCUtmBZxh0MyVi/+MJ49T8ePNk9Hhk4LDfAeK/nT/4QiX
         ZGrN6rutC97Mt3M9LuG1S/Iz3i16W3tJHPD3BbIaD3RQMmuntjzV55LXg3fblxx9p8Li
         spiK3tmo8mQlLRdpsKSjicurtfGoCj+6HydwOwHV6D/vNAHcEDx8qYNfkw3ClSGlyF6d
         FYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774611077; x=1775215877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6lpGVX/QCmQJUj33QJcU41GXVAqHMjHSyUsmEQf/VZk=;
        b=rGl7IzzAHAdCE5CkW8fGxmoQEmRAt33q8V2nFEKaULasJ6lEuu5ptKfsdyKSYWyr2v
         302DLQZHdzSC6cq/UNgWP8Cw5YAPBtjS11T68qj0O+sLjHzPdMNTmRLCwuo3ZgJGt6SI
         8d6jsEzGa19Y8/relrvUR+xaIhkq+WSl4n/AuxHO3FmJUf9wa+YxLIawM1O1xkrJJYS+
         s/jx35oxPUrXvmpRuRzAqaPu1pvD6yRSbEb5XRJP3v3ggg+muN1cXWNO2fArqASGvBsh
         RdQ3fj8IjfwMa8l+ncNpFZ/F34gKcxByIgTBonb8gGpiEe1+Y6q7iqU2JMtEXaD/FlAt
         SN5Q==
X-Gm-Message-State: AOJu0Yzz6h1zaQMCrpKJ5bUstb6iF4liGTb8O86y5Jz+QWvp49tZgFBh
	je3tpAr+UovhsH91Y0zAI6Pi0WkYglXe10yx5KLnj4RPSspNMwfjWoNia4GpQ2JHAuB4Vy0DxMk
	ek+INka7jiRzSgJ1B8uIFjhrm1m8ftfLGwVDwz3qsip9rCeL002Dd+UBUTlYZihSyDmYw715REm
	TtELB/1ZAjHRB0R0ASNTat8v9daSPvQg8=
X-Received: from wmej1.prod.google.com ([2002:a05:600c:42c1:b0:485:2f7d:fb25])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3f0a:b0:485:4eaf:eb54
 with SMTP id 5b1f17b1804b1-48727ec733dmr31154955e9.20.1774611076504; Fri, 27
 Mar 2026 04:31:16 -0700 (PDT)
Date: Fri, 27 Mar 2026 12:30:52 +0100
In-Reply-To: <20260327113047.4043492-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260327113047.4043492-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6962; i=ardb@kernel.org;
 h=from:subject; bh=jQxXgoeTfEfEV6TdnBWqYTOjj0B+qysu4R1Bj4bXvm0=;
 b=kA0DAAoWMG4JVi59LVwByyZiAGnGam2isQG2Eu8szjpLuEHSYkgaDSsdEEBpiP9XG1vHwI5pr
 4h1BAAWCgAdFiEEEJv97rnLkRp9Q5odMG4JVi59LVwFAmnGam0ACgkQMG4JVi59LVxWLQEAhsm1
 9x13Cv7LfiIl3A9yCpEMUfgJ4sggvT118mK3FCAA/izZrlF7RQau6pVt3F4WSaQNTl9xjdPIOyr qRCu4qbEH
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260327113047.4043492-11-ardb+git@google.com>
Subject: [PATCH 4/5] xor/arm64: Use shared NEON intrinsics implementation from
 32-bit ARM
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
 lib/raid/xor/arm64/xor-neon.c | 170 +-------------------
 lib/raid/xor/arm64/xor-neon.h |   3 +
 lib/raid/xor/arm64/xor_arch.h |   4 +-
 3 files changed, 5 insertions(+), 172 deletions(-)

diff --git a/lib/raid/xor/arm64/xor-neon.c b/lib/raid/xor/arm64/xor-neon.c
index 97ef3cb92496..43fa5236fd41 100644
--- a/lib/raid/xor/arm64/xor-neon.c
+++ b/lib/raid/xor/arm64/xor-neon.c
@@ -1,179 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * Authors: Jackie Liu <liuyun01@kylinos.cn>
- * Copyright (C) 2018,Tianjin KYLIN Information Technology Co., Ltd.
- */
 
 #include <linux/cache.h>
 #include <asm/neon-intrinsics.h>
 #include "xor_impl.h"
-#include "xor_arch.h"
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
+#include "../arm/xor-neon.c"
 
 static inline uint64x2_t eor3(uint64x2_t p, uint64x2_t q, uint64x2_t r)
 {
diff --git a/lib/raid/xor/arm64/xor-neon.h b/lib/raid/xor/arm64/xor-neon.h
index 514699ba8f5f..d49e7a7f0e14 100644
--- a/lib/raid/xor/arm64/xor-neon.h
+++ b/lib/raid/xor/arm64/xor-neon.h
@@ -1,5 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 
+extern struct xor_block_template xor_block_neon;
+extern struct xor_block_template xor_block_eor3;
+
 void xor_gen_neon_inner(void *dest, void **srcs, unsigned int src_cnt,
 		unsigned int bytes);
 void xor_gen_eor3_inner(void *dest, void **srcs, unsigned int src_cnt,
diff --git a/lib/raid/xor/arm64/xor_arch.h b/lib/raid/xor/arm64/xor_arch.h
index 5dbb40319501..7c9d16324c33 100644
--- a/lib/raid/xor/arm64/xor_arch.h
+++ b/lib/raid/xor/arm64/xor_arch.h
@@ -4,9 +4,7 @@
  * Copyright (C) 2018,Tianjin KYLIN Information Technology Co., Ltd.
  */
 #include <asm/simd.h>
-
-extern struct xor_block_template xor_block_neon;
-extern struct xor_block_template xor_block_eor3;
+#include "xor-neon.h"
 
 static __always_inline void __init arch_xor_init(void)
 {
-- 
2.53.0.1018.g2bb0e51243-goog

