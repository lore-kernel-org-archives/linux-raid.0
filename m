Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3170F38AC72
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 18:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776881619; cv=none; b=fGPbQ1D90b0LxyscynFTzb2UBU7rWUibiCybgoGi4CitQdcPhrPQ9tBuzn1yzUnVaxB7+yCFsCd1pfnFt5IrU4qn2mak9EY+8ljRNvfCfm1oNbyCy7cs/9n3atYW2E0/VXLTd+fJ27I0ftxxYO9Ceu9uJgwukeCg4sRKML7wQUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776881619; c=relaxed/simple;
	bh=1G/9+VSes2KLldChLxUMctmdqTZCq5yUcorejOpjA4M=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=i118Mc3kbIKgkIjd4LSu0soFTewO2SnYOL3nM3jsXMoSlpnks5nmNuc+zb9Fs9eOsyCqDBIUK6wCsxFscK7kxNUwoPCPVSu+59Uw7nViaL8PKhsycbFfGnDkazKWuGgXJrDzH2/XWyvUoI+4Yt0yBX7fWJiN5sqyfGCAIVejz0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ktUaomzd; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ktUaomzd"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48896199cbaso57866355e9.1
        for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 11:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776881617; x=1777486417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uyz6tSF+oy1MloiWLm1wGiTPmiCDVtWICeLWrJM81rU=;
        b=ktUaomzdkHnA2fnsEnEGxS/H8qGbj19vBDgSIoPtHrLL3UKuRK2PrDZ0aiP+kc5Coc
         FyqKkZ6k70TfBUjuDii/ii4QwP9E7di39iJv0VZSTKtpeBKkxlJrFIXSFaj71C/dEUzA
         oLzU46UWqw9BmGindu+8QOGu8kV2rh+wyigI/JCvIv1SptRjwoQbfnuRDnDoqyGN0UUd
         WrkyavNmtufs1hV3zSeHe1JcgCS2aFFHECzUnM+aCypju2sxRz+igY1JQ5QTvYgHw+mY
         f9vpdIMONDxbCaCWUXAlnoAYEL23cBYHmYIOdUyzqevC4DrD5Vx49zLYR78aUveJeMcx
         4xLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776881617; x=1777486417;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uyz6tSF+oy1MloiWLm1wGiTPmiCDVtWICeLWrJM81rU=;
        b=s6VgtJEggb5BaFd4iGTl+5U7LlE4mHD/f84KqcLVvydj1g7alfgEMCGAlkC5MC4eSY
         4kZem6qr98cs5Fxw8zbGCSf41EfFklL10/wy1TBfIyyoBPv2ftz+jxXVTi03mOTtzIWR
         xBcxYDheuKJ4lv0TUhG7Vd4qXPZNsieXdaVN1CBAvTpdXKWz70Cu1ZWMwE/9ZcJmvt1o
         8aK0LBcYsAXG/vgCXF3lSunF0J22gwguJiXB5lHBSs3cOQ9CRo3OuQp3Sh7KWNfpaq4E
         dNkFmWTPS7qf+7vN0kty7NEIP6xS3im3mPPJVmNdEVATKZRJZZxmJLLTMULTGafBS0WO
         LQxQ==
X-Forwarded-Encrypted: i=1; AFNElJ+7YXToJV1Fg5PPM9W62d4QjHAEEI2298RzSWpVgd05HqkASYTDu+g4zV9QqGtWOGY4xXPqb1wT17Dz@vger.kernel.org
X-Gm-Message-State: AOJu0Yyko+Vtf+2Yvs4bZ7riFGDbx/+C/1R/VOKNCxNhMXLMtlT7B/q7
	z1UQSun8C5lrn9lhcqHt7WEBNPcP6Ux9dJp9ZezrANJJhxZP9dq1CgU3
X-Gm-Gg: AeBDiesS/1/3T19TIZVLgmNyeCik9C4a5u72QW7U7Cgou3eePnIuaEBfFEYu0+BJZxa
	keO5RfZduht49K1AooXaEmBTf1ezG3KxGiLcqzEVMVq5G2NwVzGRbo+DeMtMw8iCkNUtR6LGlOf
	MY9+PWel13boY94Mox/zI97Faq5++9hKinw7/7kUKbQUYLv09CyodzwPeMgfBGafXB+0rskSSN7
	+C3dul8SW7yGo2+uiNySq8mKRB/2J0O4AJMvXQ1xqjJPgPwneDOffr0ZnuvAhsMvcgxx7LkEhBb
	3JR2fS1hIlOQAUOzaIkzYPGFnX7SH0UJt307fuoKtYNk/7MZOammjrDmWu5FFhBsD6GT5TGSJqw
	mnbYpOoCBn02h8XDwXpvcNLDgJcF6Vi217r7tducBxPx4VljZsOB9GcvS0WxVY+sCe3oIf9IYNV
	HDnLMekQ3akPRwcs1SojncOugsQ3esI/f5xiYT
X-Received: by 2002:a05:600c:8115:b0:488:8577:d9cc with SMTP id 5b1f17b1804b1-488fb77faacmr295680905e9.20.1776881616583;
        Wed, 22 Apr 2026 11:13:36 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb72d365sm232234915e9.1.2026.04.22.11.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 11:13:36 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:13:36 +0100
From: Josh Law <joshlaw48@gmail.com>
To: ardb+git@google.com
CC: ardb@kernel.org, arnd@arndb.de, ebiggers@kernel.org, hch@lst.de,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-raid@vger.kernel.org, linux@armlinux.org.uk
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_4/8=5D_lib/crc=3A_Turn_NEON_intrin?=
 =?US-ASCII?Q?sics_crc64_implementation_into_common_code?=
In-Reply-To: <20260422171655.3437334-14-ardb+git@google.com>
Message-ID: <E9489A63-1EFA-4AA0-BD66-6E4066F01C6B@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

Hi ard.


diff --git a/lib/crc/arm64/crc64-neon.h b/lib/crc/arm64/crc64-neon.h
new file mode 100644
index 000000000000..fcd5b1e6f812
--- /dev/null
+++ b/lib/crc/arm64/crc64-neon.h
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+static inline uint64x2_t pmull64(uint64x2_t a, uint64x2_t b)
+{
return vreinterpretq_u64_p128(vmull_p64(vgetq_lane_u64(a, 0),
vgetq_lane_u64(b, 0)));
+}
+static inline uint64x2_t pmull64_high(uint64x2_t a, uint64x2_t b)
+{
poly64x2_t l = vreinterpretq_p64_u64(a);
poly64x2_t m = vreinterpretq_p64_u64(b);
return vreinterpretq_u64_p128(vmull_high_p64(l, m));
+}

Makes sense.

Moving these polynomial multiplication wrappers into their own header is
good. 

Reviewed-by: Josh Law <joshlaw48@gmail.com>


Thanks!
