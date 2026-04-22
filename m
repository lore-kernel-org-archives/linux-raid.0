Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8532D77F5
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 17:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776878240; cv=none; b=nmRRQ6J7G8j00havHYKT+ZeiFqbOidOjubB5OHetqFNFs856iqaUJhHEK3XyAGtF++3zIMjCyLuRgQrhdun+fmQWPQoP0+lhv9smH2eXJ7FN6767+94wsaOCU1uRl46Iv6450fy40GKRFji3Yt/EmGllxKKQy936lQXXtXH8R1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776878240; c=relaxed/simple;
	bh=o8PVH95IvjuSbIvZxY3MwjuAovqVH50soNfwlaNvAtE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jjRTaW3LDD8nYIvT2goNenh4Y+xok+4qVjp9JlG7g1mbKzgQMdpdIEs/8MoyKxd0+HYvSIH2GkiDDDKm+up8u7d7nir5M57RkrD7+M1szPIgdTtbU5MDn1pT2qYpTLUkHadaUxoAlxD6JpiEjTQKhpqOsS6CpZ+GdBAB6NwqR9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O/2yoMpH; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O/2yoMpH"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488d56f87e8so50086125e9.0
        for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 10:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776878237; x=1777483037; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kYxQRmgWL10tNyaOHfasdqrNIaBKejXOgZBLd6p7uKY=;
        b=O/2yoMpH9PhoJaA5gdME/voeSAkJ5DxkSy7xRVxIF6bDw1RTip27BuqJcLqZFo66yX
         G32BGC5GccxVNunUCrmY4BTYOeXMxFFlwCxqSrBT1G6yOWSBf6U3jbNigxpcEy8GhtpD
         T96Ewgt8t82lTCSXyqaVpBP/aHlq3hwDnrp0lFRk/BP5NATs25U/EoIFWBd6ED62Nz+b
         +N1x3KKrFpZ5X5sIhBVvnGhwCgYGlhVy8ZpoYVkSN+k6EWCq1raLDkpeXmK9AFLNMT0U
         mozuLoXEJ878DSDhMlPd9jwxwoOim1i7LNw9IelH3jIqG6HAFT/Cu27LsDRpgRScTFVZ
         hXaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776878237; x=1777483037;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kYxQRmgWL10tNyaOHfasdqrNIaBKejXOgZBLd6p7uKY=;
        b=fMmC3+iXvwn7Q7Umx9PdnFjjyqwz5tb343OYLK79MSTJWnjmOtWdiSoWpCXEEgvrNe
         1c5g/JlyjNZ9linB8CjQ3a1qA3MXVB3CMg/eklmNoKtDR+WjCd2fYAiBydLuriyG89IP
         gBKobgxgUtnwdZi/a27WjRq4dXeKBc2fyapqHCx1slyL582SvN4cQrm+VUfcZJbW1VhI
         ae4fC8wQi/obsGBLioHbGp7tGclQnE+Jrx+et2MuNwfglhTF7glDCiNDB8lpXyGdLxRG
         s/cOOfoJv3MM+m6PL0Wa4G3hmATGC+jusLl53uNG0GjbU8vNqzPfgtT+ALriGckxgT9I
         dotQ==
X-Forwarded-Encrypted: i=1; AFNElJ9PsRulOmrp5tSxrFWVwDDEd3xWzrB5atMQbeC9bfTOBlxHjfJRoyUorAndOvmt73iQ1BJzmwFJPvZo@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4zLxxgsrhcF9lLlfYlh+SnNUdWxg/iZaboQbeBWt72qchuPFK
	nP3PcPJ2s795sWZjt1nOZfFAluR+m5NYfGXX0I8lEhwbUbeM7vcGslpOjbdKTdSLbmJI/9Skyw=
	=
X-Received: from wmdd11.prod.google.com ([2002:a05:600c:a20b:b0:489:2707:4020])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a305:b0:48a:53cb:85f4
 with SMTP id 5b1f17b1804b1-48a53cb8734mr116179845e9.24.1776878236564; Wed, 22
 Apr 2026 10:17:16 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:16:56 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3867; i=ardb@kernel.org;
 h=from:subject; bh=Sh8pW1uPCO2h+APBzbOrM5AIp7/bTjvvCSSkfDl1xjQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfMlU8fyK1ONpNMPPHw/afZpC+8Sx9/tOTyz5fJn/fO1r
 Olg+ruso5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzk0TFGhvbaFvPk+T7BW3Qu
 ib7R8PyeI/gnJFTdWC3MNS5ROfR8LyPDer/a+MlfnKbOiXvsI/JIYtWUH+FfInoz4m88+JI+OyS QCQA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260422171655.3437334-10-ardb+git@google.com>
Subject: [PATCH 0/8] ARM crc64 and XOR using NEON intrinsics
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

This is a follow-up to both [0] and [1], both of which included patch #1
of this series, which introduces the asm/neon-intrinsics.h header on
32-bit ARM. The remaining changes rely on this.

The purpose of this series is to streamline / clean up the use of NEON
intrinsics on 32-bit ARM, by sharing more code, clean up Make rules and
finally, getting rid of the hacked up types.h header, which does some
nasty things that are only needed when building NEON intrinsics code.

Patches #2 and #3 replace the ARM autovectorized XOR implementation with
the NEON intrinsics version used by arm64.

Patches #4 and #5 enable the arm64 NEON intrinsics implementation of
crc64 on 32-bit ARM.

Patches #6 and #7 drop the direct includes of <arm_neon.h> and perform
some additional cleanup to reduce the delta between ARM and arm64 code
and Make rules.

It would probably be easiest to take all these changes through a single
tree, and the CRC tree seems like a suitable candidate, if Eric agrees.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>

[0] https://lore.kernel.org/all/20260331074940.55502-7-ardb+git@google.com/
[1] https://lore.kernel.org/all/20260330144630.33026-7-ardb@kernel.org/

Ard Biesheuvel (8):
  ARM: Add a neon-intrinsics.h header like on arm64
  xor/arm: Replace vectorized implementation with arm64's intrinsics
  xor/arm64: Use shared NEON intrinsics implementation from 32-bit ARM
  lib/crc: Turn NEON intrinsics crc64 implementation into common code
  lib/crc: arm: Enable arm64's NEON intrinsics implementation of crc64
  crypto: aegis128 - Use neon-intrinsics.h on ARM too
  lib/raid6: Include asm/neon-intrinsics.h rather than arm_neon.h
  ARM: Remove hacked-up asm/types.h header

 Documentation/arch/arm/kernel_mode_neon.rst        |   4 +-
 arch/arm/include/asm/neon-intrinsics.h             |  60 ++++++++
 arch/arm/include/uapi/asm/types.h                  |  41 ------
 crypto/Makefile                                    |  10 +-
 crypto/aegis128-neon-inner.c                       |   4 +-
 lib/crc/Kconfig                                    |   1 +
 lib/crc/Makefile                                   |   9 +-
 lib/crc/arm/crc64-neon.h                           |  34 +++++
 lib/crc/arm/crc64.h                                |  36 +++++
 lib/crc/arm64/crc64-neon.h                         |  21 +++
 lib/crc/arm64/crc64.h                              |   4 +-
 lib/crc/{arm64/crc64-neon-inner.c => crc64-neon.c} |  26 +---
 lib/raid/xor/Makefile                              |  13 +-
 lib/raid/xor/arm/xor-neon.c                        |  26 ----
 lib/raid/xor/arm/xor-neon.h                        |   7 +
 lib/raid/xor/arm/xor_arch.h                        |   7 +-
 lib/raid/xor/arm64/xor-eor3.c                      | 146 ++++++++++++++++++++
 lib/raid/xor/xor-8regs.c                           |   2 -
 lib/raid/xor/{arm64 => }/xor-neon.c                | 143 +------------------
 lib/raid6/neon.uc                                  |   2 +-
 lib/raid6/recov_neon_inner.c                       |   2 +-
 21 files changed, 340 insertions(+), 258 deletions(-)
 create mode 100644 arch/arm/include/asm/neon-intrinsics.h
 delete mode 100644 arch/arm/include/uapi/asm/types.h
 create mode 100644 lib/crc/arm/crc64-neon.h
 create mode 100644 lib/crc/arm/crc64.h
 create mode 100644 lib/crc/arm64/crc64-neon.h
 rename lib/crc/{arm64/crc64-neon-inner.c => crc64-neon.c} (62%)
 delete mode 100644 lib/raid/xor/arm/xor-neon.c
 create mode 100644 lib/raid/xor/arm/xor-neon.h
 create mode 100644 lib/raid/xor/arm64/xor-eor3.c
 rename lib/raid/xor/{arm64 => }/xor-neon.c (56%)


base-commit: 6596a02b207886e9e00bb0161c7fd59fea53c081
-- 
2.54.0.rc1.555.g9c883467ad-goog

