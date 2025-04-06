Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D91204F94;
	Sun,  6 Apr 2025 16:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743955390; cv=none; b=NYPGb6CTtZ25Z8JK6A+HtBzBmcdDLBKNvQx6LEhUFHuZDnNFT4hzXNQ3t+2+jdq6QbxLN2k19bihn8fIw6xkNdyveHq9MVkZwLYKkCNMrxsUX4Tjtfsh2aTZCbGNMGz2rAa6L8aOGM4lu9AkdtjhXqZ+oIdpz0aAmwCz4nAG9t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743955390; c=relaxed/simple;
	bh=H0WW8RYwcUflIu5fzLmBXcIBidBGU+JERRJbHZy4w1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cBpeLWYKmCQi/G6QWVr0vKjfFZylIHcyayx3agqp2DcpRWTNHB2j5gNVlZSYr66yXthTGcEu2yvQMBIKfg1PXdrJaiVw+OZzSfLqXtxkHcZIuXSDY9kXj19GX2dDyO7L4jANkZHA+VcrqPo7K1kjbTFfxtk6jL0UtnJqbMYWQjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g5tFn+ZA; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g5tFn+ZA"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac339f53df9so600660866b.1;
        Sun, 06 Apr 2025 09:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743955386; x=1744560186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2Gg4zdNGw4akh+G3YWEPNIUcWbldggC7anYYxwmPl2A=;
        b=g5tFn+ZAH2eJeblE/MDuq/66BSoRwC/Yew6Ek2VRuYmTkNHMFzfJq8q02tFFHymSYi
         HN5L1ZtCCxbEJboESkws+4kl4QC0V8NFH0DTk9d/nV1W5Wia1uB5rBqJSuEKCU16OSEB
         cTa31A4bqEAzc+1cUgmKULWpDkqogFsE0iIcjMp9kLoHvriuR1CBPZ2BRPkcASlT5yFs
         j+wKxTeKtvFXev2Ipxil8eh989CBQmETqJArwUT3RzNUfV/uoFWybCNsD7h6KwHNAXBk
         KxF8Rm/q02ro9I4OjI94lbqMSHnAQyD6NV4Zfs0dSgrygNj5GFtezwe1G5Ec8/dcuwL3
         buhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743955386; x=1744560186;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Gg4zdNGw4akh+G3YWEPNIUcWbldggC7anYYxwmPl2A=;
        b=LyVO/BjtB4TsVbFhY/bwxd2WuvK/hC5ZeY42j4JOFH9NrQ3aF+ERPoih8AQWUs/ujd
         SBaxfP6pVBCVdW3ZwPA6QIKuQNrR7bwHwn1zJv+tb++rnNuxUBPiqfEWHbfgbHKI8S61
         BI+c4B9wMUJR7C698jICoyrwpAWwCMuBW9SzOwTEfMvu1mQSskMA66UCIMZHFRLlH8R5
         fwkcvMbJsxpqJqBYGmyXeYZh+AsJ8i8+3drvrwyuCUbTsYexviDKmkk3JB/UZj2stpG/
         hZCkzqn7be7wvzKYZAwumm6xrMv+hn7HtEvt+3JWQdNJQjWLFOM4K5QDC6dObkHShU83
         cU8w==
X-Forwarded-Encrypted: i=1; AJvYcCUJwwmYWk5xcvEW90ahW7VXKZB/XyQmd2NnkqDu8BUeRLT6GmI3J3+Ca4shDKgVzA8KgIk1fwZjuhaJoN0=@vger.kernel.org
X-Gm-Message-State: AOJu0YygNAH+/16rb+hCKkXa1ntYROSSDFfNxCjGstUCPOCh7ze0sdYl
	0r+XHKv6jEUkJdFnwPwU/yeINAnOVa2ycL8PtFF1rjLo0Tlf8+LOJqBlXHalAiY=
X-Gm-Gg: ASbGncuYPbDo8XHz7itQ58QIViYrhjdW0aR8BwkJioNfdkLVYa4Ep1fUhZULEK7kXh0
	tzcYnB5gxATF6gYAMvO7XNM1RZlW+pylb8PgdTjexiU5WhkAIJeBcxw3sS1lg14UdbPYTbWtoGw
	LLJZK0IjM2oYkjc3noQErr5AC42tenw8bpN8rk/L0biSXiJeZ6H9UAgLpsZfLsylezoP0bkJ7U5
	7W2Xey1AF6rb1Z4gAmHydKLgzZFBRslRSgxFJN3WSy/w/NZC7WsHDw4B7szJgAFTVwPE3jL44qt
	lCTzl42ZBqsUSD+idYRjclhU7e8O2N6oRaqrvDGubMU/boxw6btB6g==
X-Google-Smtp-Source: AGHT+IEn/yrvpZmrdrTvvbNeg/z624E6vdfCD/lwZ+eQTne5AKLKEg5mLv2yQzmDzgzjQiEcMmFoPQ==
X-Received: by 2002:a17:907:7206:b0:ac6:b729:9285 with SMTP id a640c23a62f3a-ac7d1b9faebmr1022796766b.55.1743955385521;
        Sun, 06 Apr 2025 09:03:05 -0700 (PDT)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c0185118sm594963066b.134.2025.04.06.09.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Apr 2025 09:03:05 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-raid@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH REPOST] lib/raid6: Remove always defined CONFIG_AS_AVX512
Date: Sun,  6 Apr 2025 18:02:01 +0200
Message-ID: <20250406160247.17750-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current minimum required version of binutils is 2.25,
which supports AVX-512 instruction mnemonics.

Remove CONFIG_AS_AVX512 which is always defined.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Reposted: To include software raid and x86 people.
---
 lib/raid6/algos.c        | 6 ------
 lib/raid6/avx512.c       | 4 ----
 lib/raid6/recov_avx512.c | 6 ------
 lib/raid6/test/Makefile  | 3 ---
 4 files changed, 19 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index cd2e88ee1f14..dfd3f800ac9b 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -28,10 +28,8 @@ EXPORT_SYMBOL_GPL(raid6_call);
 
 const struct raid6_calls * const raid6_algos[] = {
 #if defined(__i386__) && !defined(__arch_um__)
-#ifdef CONFIG_AS_AVX512
 	&raid6_avx512x2,
 	&raid6_avx512x1,
-#endif
 	&raid6_avx2x2,
 	&raid6_avx2x1,
 	&raid6_sse2x2,
@@ -42,11 +40,9 @@ const struct raid6_calls * const raid6_algos[] = {
 	&raid6_mmxx1,
 #endif
 #if defined(__x86_64__) && !defined(__arch_um__)
-#ifdef CONFIG_AS_AVX512
 	&raid6_avx512x4,
 	&raid6_avx512x2,
 	&raid6_avx512x1,
-#endif
 	&raid6_avx2x4,
 	&raid6_avx2x2,
 	&raid6_avx2x1,
@@ -96,9 +92,7 @@ EXPORT_SYMBOL_GPL(raid6_datap_recov);
 
 const struct raid6_recov_calls *const raid6_recov_algos[] = {
 #ifdef CONFIG_X86
-#ifdef CONFIG_AS_AVX512
 	&raid6_recov_avx512,
-#endif
 	&raid6_recov_avx2,
 	&raid6_recov_ssse3,
 #endif
diff --git a/lib/raid6/avx512.c b/lib/raid6/avx512.c
index 9c3e822e1adf..009bd0adeebf 100644
--- a/lib/raid6/avx512.c
+++ b/lib/raid6/avx512.c
@@ -17,8 +17,6 @@
  *
  */
 
-#ifdef CONFIG_AS_AVX512
-
 #include <linux/raid/pq.h>
 #include "x86.h"
 
@@ -560,5 +558,3 @@ const struct raid6_calls raid6_avx512x4 = {
 	.priority = 2		/* Prefer AVX512 over priority 1 (SSE2 and others) */
 };
 #endif
-
-#endif /* CONFIG_AS_AVX512 */
diff --git a/lib/raid6/recov_avx512.c b/lib/raid6/recov_avx512.c
index fd9e15bf3f30..310c715db313 100644
--- a/lib/raid6/recov_avx512.c
+++ b/lib/raid6/recov_avx512.c
@@ -6,8 +6,6 @@
  * Author: Megha Dey <megha.dey@linux.intel.com>
  */
 
-#ifdef CONFIG_AS_AVX512
-
 #include <linux/raid/pq.h>
 #include "x86.h"
 
@@ -377,7 +375,3 @@ const struct raid6_recov_calls raid6_recov_avx512 = {
 #endif
 	.priority = 3,
 };
-
-#else
-#warning "your version of binutils lacks AVX512 support"
-#endif
diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index 2abe0076a636..8f2dd2210ba8 100644
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@ -54,9 +54,6 @@ endif
 ifeq ($(IS_X86),yes)
         OBJS   += mmx.o sse1.o sse2.o avx2.o recov_ssse3.o recov_avx2.o avx512.o recov_avx512.o
         CFLAGS += -DCONFIG_X86
-        CFLAGS += $(shell echo "vpmovm2b %k1, %zmm5" |          \
-                    gcc -c -x assembler - >/dev/null 2>&1 &&    \
-                    rm ./-.o && echo -DCONFIG_AS_AVX512=1)
 else ifeq ($(HAS_NEON),yes)
         OBJS   += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
         CFLAGS += -DCONFIG_KERNEL_MODE_NEON=1
-- 
2.42.0

