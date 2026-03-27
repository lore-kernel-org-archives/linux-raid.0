Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D9B353EC1
	for <linux-raid@vger.kernel.org>; Fri, 27 Mar 2026 11:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611079; cv=none; b=m38zvIqklE9PFlTZHG3tsprEM5f+v0+hisMLjEwgpQyXKrLWMHgbU6OD5TiS9vVfcnmZPD13dAO6VWJBiAS4TN3Kd/LLvj+epk2c9m/U9lkoBDbGjGrlRRi+A+8643AF07zKiMbRvKduSbZYQkhU9nnUgbdKDtLmTTvSCNpb74Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611079; c=relaxed/simple;
	bh=/k+ptR4NvwhJsEP6CwMqnMvU4noDtEwLrgtKewnsPbU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ShCvJ3vMw+m7ylZTFKMX7dCj+f2PMfrZECxe49B4NkFMGK3CD8dvtGi8VfsvdIo194qw4u/ru5OcN1GN9uRvN7zEVrWnU8jdL6P7L8TEEK1qrdvJjep+6WMv8VoZKnvAZdwKz3CHMwdBwOU7QvRkdP2kv8ZrZPWr7C9wHWKUQXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X01Qkz+6; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X01Qkz+6"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-66794cee91cso1807961a12.2
        for <linux-raid@vger.kernel.org>; Fri, 27 Mar 2026 04:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774611073; x=1775215873; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=seTWwXkopHCFQH4qNJ5KGWFEAy5p+6D4jhEUPgOpMvo=;
        b=X01Qkz+6HNHnFSViVh7ka9QOhWpVNAGqTu4y4MsCE4vCbG4Icc4yKlF0jamYX3ye+8
         ZGiW13CjQuLDGzrSifHxRRfcLni4rzbEDCtU+aRxzBao56Pq5JkgNDQsOATzHUqAFlTL
         eq+bsB8gBx8JLOpEi6LsDNK/095+1eEwjRGTGknEw31xhjfpPk1i0t3LGcmgzXK4bMam
         mu5HUZpic2tJVYmgImPQq9XtlxBdQyGFJE9Q+ub5jGwn/51B6JZrIqGiDnC2V8aH3LeC
         cuW8x4oXusc1chlgbELbGtT35vXRT2RRjtsQPS5I0HlyesqofIaXYX5o2L+Osu2Bsm/+
         myRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774611073; x=1775215873;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=seTWwXkopHCFQH4qNJ5KGWFEAy5p+6D4jhEUPgOpMvo=;
        b=TBxBxkQyF8BJJKn+yl5bHwZNz+Tb53Jocley2Sm6Z9kI3ELRJ+8YbaKi3jVMl8t8Og
         US+Q5kcXWo8xjw5HPRKTgBjltXScbQR6oD2/70d09ONG3bFtA1MoO01sSps9buaB8iy4
         YbXApp+nBiIIoH2GRp7IY6Z6yzj2+8KmJkDMU4R0myHBae/3bT0/pH1sBccnZI6oMafL
         aA19a0rMb6LybdNI9QKeDertHu0zIehnWIkEZO49xpLlxcCnlaAxEiyE2lWtpwQ6yuIu
         4VyX3R9V5e3u9DYHzJUb7cC4+tmnlaVk9JGFJiWhcILlVp0GqULNCFal0TS7Zs24e2Bc
         Bw7w==
X-Gm-Message-State: AOJu0Yx490OnjxFRBBepKy4wG7TO/1+AisyZplP007GagAH084w89CBg
	8GigLvNZezF1cq9XCcqQ/FSj63M+G6gZY3llEA7t4l60ciIG4+Zg1rLmcfWFqAAxR7IatNodkd5
	RERRYyTGDEpPMTMqU9jHjW1qpssZyx2/QzkzSnEt9vTgRoU9fEX9NlxDKlPZizjQIpvq0jZcdVG
	ht2H5+cZ/BHD1Y4rtBG72TcnpR4vItJiQ=
X-Received: from edf13.prod.google.com ([2002:a05:6402:21cd:b0:65c:72cb:9cb6])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4403:b0:66a:7888:eb25
 with SMTP id 4fb4d7f45d1cf-66b28b565e5mr1539633a12.14.1774611073181; Fri, 27
 Mar 2026 04:31:13 -0700 (PDT)
Date: Fri, 27 Mar 2026 12:30:49 +0100
In-Reply-To: <20260327113047.4043492-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260327113047.4043492-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2728; i=ardb@kernel.org;
 h=from:subject; bh=pWCvbcZutt7tsEk4C4u4+maMWpN4r9I10BVKJhnTMSU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfNYVuaEiz1G8vFRB9b5u280vOp8ffOl8KC/3TP2tPQz5
 QUIXhPrKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABNJF2f4n7Asa8a/xeF/madr
 v1uZN+2g8/Z7c87EyEit0qy/f8RocirD/6wDV3o2P/LwmVPy54Vx/Z2wX5uaY79ubfq9r8/JJ+d dHCMA
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260327113047.4043492-8-ardb+git@google.com>
Subject: [PATCH 1/5] ARM: Add a neon-intrinsics.h header like on arm64
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-raid@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Add a header asm/neon-intrinsics.h similar to the one that arm64 has.
This makes it possible for NEON intrinsics code to be shared seamlessly
between ARM and arm64.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/neon-intrinsics.h | 64 ++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/arm/include/asm/neon-intrinsics.h b/arch/arm/include/asm/neon-intrinsics.h
new file mode 100644
index 000000000000..3fe0b5ab9659
--- /dev/null
+++ b/arch/arm/include/asm/neon-intrinsics.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __ASM_NEON_INTRINSICS_H
+#define __ASM_NEON_INTRINSICS_H
+
+#ifndef __ARM_NEON__
+#error You should compile this file with '-march=armv7-a -mfloat-abi=softfp -mfpu=neon'
+#endif
+
+#include <asm-generic/int-ll64.h>
+
+/*
+ * The C99 types uintXX_t that are usually defined in 'stdint.h' are not as
+ * unambiguous on ARM as you would expect. For the types below, there is a
+ * difference on ARM between GCC built for bare metal ARM, GCC built for glibc
+ * and the kernel itself, which results in build errors if you try to build
+ * with -ffreestanding and include 'stdint.h' (such as when you include
+ * 'arm_neon.h' in order to use NEON intrinsics)
+ *
+ * As the typedefs for these types in 'stdint.h' are based on builtin defines
+ * supplied by GCC, we can tweak these to align with the kernel's idea of those
+ * types, so 'linux/types.h' and 'stdint.h' can be safely included from the
+ * same source file (provided that -ffreestanding is used).
+ *
+ *                    int32_t     uint32_t          intptr_t     uintptr_t
+ * bare metal GCC     long        unsigned long     int          unsigned int
+ * glibc GCC          int         unsigned int      int          unsigned int
+ * kernel             int         unsigned int      long         unsigned long
+ */
+
+#ifdef __INT32_TYPE__
+#undef __INT32_TYPE__
+#define __INT32_TYPE__		int
+#endif
+
+#ifdef __UINT32_TYPE__
+#undef __UINT32_TYPE__
+#define __UINT32_TYPE__		unsigned int
+#endif
+
+#ifdef __INTPTR_TYPE__
+#undef __INTPTR_TYPE__
+#define __INTPTR_TYPE__		long
+#endif
+
+#ifdef __UINTPTR_TYPE__
+#undef __UINTPTR_TYPE__
+#define __UINTPTR_TYPE__	unsigned long
+#endif
+
+/*
+ * genksyms chokes on the ARM NEON instrinsics system header, but we
+ * don't export anything it defines anyway, so just disregard when
+ * genksyms execute.
+ */
+#ifndef __GENKSYMS__
+#include <arm_neon.h>
+#endif
+
+#ifdef CONFIG_CC_IS_CLANG
+#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
+#endif
+
+#endif /* __ASM_NEON_INTRINSICS_H */
-- 
2.53.0.1018.g2bb0e51243-goog

