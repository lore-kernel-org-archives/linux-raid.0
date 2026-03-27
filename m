Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0111534DCF9
	for <linux-raid@vger.kernel.org>; Fri, 27 Mar 2026 11:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611077; cv=none; b=gAPlby0xijL/PK91Az+e4dqrZXkpcQJANhDEjElAQwOYI4upM/ZO5DrZKbnmMiLiRbxNWTYKN1hlitBCO1rqCRDDtY8ZcAKGgrT3cLf3h8BjnIUQbBTLjQZoI0xnRFo3XqKp3rc1PPY76CTl27nTY9772evtfw3YalOkAkAUfM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611077; c=relaxed/simple;
	bh=UmL46xDerX8cYINsA2i+1E9wjT2HoBExSADUSLKiakQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HyZ+JY46d0xIUllIF3nEJHyxMryEq+S1wZrNDnGFXERpn5qszQBWpXpEoORMLF81idVxWW7R5IJ/4rgNfus1auTr4ME1HupAlwERgQvwYjkft5wpJZpHUUiwDtHBN9a3qMdTwNXNDjeyINSQgFZ1qQmdUOGnS6GUnm9F+3YZhVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TW6EA4XN; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TW6EA4XN"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43b8c472f3eso1399293f8f.0
        for <linux-raid@vger.kernel.org>; Fri, 27 Mar 2026 04:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774611072; x=1775215872; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cWi4tsU07W8zdjWvbAUHzl7MmNBwNpbFy2DN6BpKSUQ=;
        b=TW6EA4XND+VGeLxQNDlAEIKGtAAfbnwKEHlZgLanovhp48LjOUYmC8ECGW3rNDi7+C
         P87RPAujvLF7FUza3JhE67cEVLnD+r5PBCb2RrPI/5y1KgOfOhR1pdLZBdecPXW5xmpG
         aMN/UV70DF/9KRK5szeNwazeIdl/k7N+tkek4dgPoGr2WerY2nsijHUa4m3n70JVbbkG
         9jd0Az6/44QNhK/jNuxlhi0r6ymiy+EMFZdEfkZsdmdiufrssg7YXUptbWpyR2dECx+u
         L0RdpQ7M/ug+N8bWC0RwUDsWz0x83mVeXTPrkv3bvke8NXXIjoqc9H1kyGCTbB7whYoO
         E7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774611072; x=1775215872;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cWi4tsU07W8zdjWvbAUHzl7MmNBwNpbFy2DN6BpKSUQ=;
        b=WpLZZzf61kwojQcwj3fsintagTLcWfWByLblc8gw+tBs/UbYPlyr1ZcW8xtup9j63m
         C5coYZGFxxGu5Cnz/Yz4FZyBX2OK3KE90nAr5zOQhSyIDDFjh7+SFC5UdE+6q6SuVC6C
         caHQNURJEGjH6FihYi1BkSx/Axyu6XWYHvW5TalprY1iQwaO5gJ/qAqOEVgWpOKpTwpB
         BPFS/VJY0Hh8C0I2QJQEad1D/atQ1oATL+2XYGceEbWBXvJW2tXXUXsy6u0+Z+wG/R64
         QiMXWp40iAKd2RlMxdxNtW2Ddmm21yAVYeV8WspelXYhFZjUuV5ZwQ2phuincl6lg/GY
         euQQ==
X-Gm-Message-State: AOJu0YyQOxKRe5ws5X21P9Y+oiYX1RiIJbI0IrPuISKnwgjAyFN/W4lX
	h5GvMJ9oXqheSsGEBss+Z5SaEq6JgZu4r7yDFigmYBQkt4ANITkLD2wijkcHtbIgBZYSnoP/ZM2
	ea/tcYC80TSxxyGPJTLvA2ULwWgDujQnUBQ8gzc736Vw7xORgXN8UveoPj9TwPG444R5ITl/A6Q
	lNDoRaUJpSnEUP2uuLGpXSU7FRMMFAimQ=
X-Received: from wrvx13.prod.google.com ([2002:a5d:54cd:0:b0:43a:5b:6a87])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2313:b0:43b:905d:f89f
 with SMTP id ffacd0b85a97d-43b9ea66dccmr3373359f8f.39.1774611071907; Fri, 27
 Mar 2026 04:31:11 -0700 (PDT)
Date: Fri, 27 Mar 2026 12:30:48 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2230; i=ardb@kernel.org;
 h=from:subject; bh=XeSSbbJ4zYZ7OrRBfI89bxz2saKmw5oGCVUlBedEe7Y=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfNYVkbKiv4duu7JN5Z7mAaYh728pH0o9uj5Rd9/Wp7Zu
 lmx1e1ARykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIlDUMfzjtU/pt9PJXccrv
 3PtJ8cWzTxc+3Nh6/m/g+4h2pk/PDigz/C9S+Wp2et9q3njmjbrXbv1at7hGbpbORrWS2Glfd+x S0eAEAA==
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260327113047.4043492-7-ardb+git@google.com>
Subject: [PATCH 0/5] xor/arm: Replace vectorized version with intrinsics
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-raid@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Replace the compiler vectorized XOR implementation for ARM with the
existing NEON intrinsics implementation used by arm64. This is slightly
faster, and allows some minor cleanups of the type hacks in the headers
now that intrinsics are the only C code permitted to use FP/SIMD
instructions.

Performance (QEMU mach-virt VM running on Synquacer [Cortex-A53 @ 1 GHz]

Before:

[    3.519687] xor: measuring software checksum speed
[    3.521725]    neon            :  1660 MB/sec
[    3.524733]    32regs          :  1105 MB/sec
[    3.527751]    8regs           :  1098 MB/sec
[    3.529911]    arm4regs        :  1540 MB/sec

After:

[    3.517654] xor: measuring software checksum speed
[    3.519454]    neon            :  1896 MB/sec
[    3.522499]    32regs          :  1090 MB/sec
[    3.525560]    8regs           :  1083 MB/sec
[    3.527700]    arm4regs        :  1556 MB/sec

This applies onto Christoph's XOR cleanup series.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>

Ard Biesheuvel (5):
  ARM: Add a neon-intrinsics.h header like on arm64
  crypto: aegis128 - Use neon-intrinsics.h on ARM too
  xor/arm: Replace vectorized implementation with arm64's intrinsics
  xor/arm64: Use shared NEON intrinsics implementation from 32-bit ARM
  ARM: Remove hacked-up asm/types.h header

 arch/arm/include/asm/neon-intrinsics.h |  64 +++++++
 arch/arm/include/uapi/asm/types.h      |  41 -----
 crypto/aegis128-neon-inner.c           |   4 +-
 lib/raid/xor/arm/xor-neon.c            | 183 ++++++++++++++++++--
 lib/raid/xor/arm/xor-neon.h            |   7 +
 lib/raid/xor/arm/xor_arch.h            |   7 +-
 lib/raid/xor/arm64/xor-neon.c          | 170 +-----------------
 lib/raid/xor/arm64/xor-neon.h          |   3 +
 lib/raid/xor/arm64/xor_arch.h          |   4 +-
 lib/raid/xor/xor-8regs.c               |   2 -
 10 files changed, 244 insertions(+), 241 deletions(-)
 create mode 100644 arch/arm/include/asm/neon-intrinsics.h
 delete mode 100644 arch/arm/include/uapi/asm/types.h
 create mode 100644 lib/raid/xor/arm/xor-neon.h

-- 
2.53.0.1018.g2bb0e51243-goog

