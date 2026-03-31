Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5473CE48F
	for <linux-raid@vger.kernel.org>; Tue, 31 Mar 2026 07:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774943397; cv=none; b=Objm0BRm5Roms5trfFwOM00WdZ8x/vS8/GgCcIcGu0qFk3Bip3UM8zU4lq2XDCf7TvD3u3b0yQS/JoupUEfGiNrQEcrUzlPsc7K7I8xt3LR+/sBJaclpM9rmGGu1VMBy7YGIEjc7R/vX9vH40fYwvsquun4DwAx0QDj0NW9JhnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774943397; c=relaxed/simple;
	bh=AttPA09lHfEVsuIZfl9EGmNOKd1iegfRxlW4j6uM8aA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=REFvVHF+l4nVZtkUmVLSyz0HGt1x3r3Vbk0bWcCgS6lDCP+1oqMecTCeHzmq3xAWNdVd5ov6RDSX1q4vx616jPTCVFwXXhly3n0Ftw14xv3I7cfl/EdUrpH7WDGo+obhD9p4tJayjbjoNVwgLPEbfF/XJuh9Yg0xGPbJtjG/zx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ldnLnbTn; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ldnLnbTn"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4887d32788bso2115655e9.0
        for <linux-raid@vger.kernel.org>; Tue, 31 Mar 2026 00:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774943394; x=1775548194; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s29Xdjdtn9joPLQhVjn5m444FoNDrSpcw3rugwHh8kA=;
        b=ldnLnbTn6iJ4oeD3jmT1idVEEUNRqfGdG2UEGmTQLYauK/G91uwV9NJ8OSSIu5Gzz5
         EC4mmzJ9BD241ZIdkx5NHGswxhBc82u+G6FPxMMZ7WU0X07gg5zN/7q3xozoKmQJPNyV
         ayClU5+ev8ns2uiQ+uQFjP+FIW1n2htKbNhyXnDUcKv3DATqVZyAseg9b2i61hlAHOW7
         7wQakRvF1aOMLANLv0ujVkO2LiyEuiBMCvnZcF+/sY2dpcfF7KGsdPqxbW6jJnQGLf8e
         TggykqLdZ44T1V+yFEpen2/1bQ2XKegwdpKUA7LzDE5mgNhaxOXKaQAQa80+wg1xWw4f
         mYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774943394; x=1775548194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s29Xdjdtn9joPLQhVjn5m444FoNDrSpcw3rugwHh8kA=;
        b=CmZ0SHpxbxA72v/hGlNOcHst9J3F/TcwpvBtpRkBi41LIK7pOLQJQINiVriXMomg2s
         uJJYcpZlvItg5HC235mIYsuKPXwDKqEQcMiSwV+EMsuAv9b16Waqmk9wZkUzsEAvxF/D
         WCrBCMxXOnPd4qr24B5rPKtN5Y8k/HcpVB8d1gYFrjNeOXEdONdeV9qQmnCiNJHVayWX
         JORwGOJsgnLD+HmpSTWtLbHh/62/ytOpeJb6uRUGGszebAbm0vZ0OOQJj7ZYLnCCmVfR
         AngmEUniP8f72f990p4fKyQvOrxHwWc6VqUj+0foHXzzrBbRRMdrkk4/qUHc3vN+2jdV
         4zOQ==
X-Gm-Message-State: AOJu0Yyryv2YGJLXQUR5XtX/1b9RvZ/wnncob1yqIakqlJ4ehYQSDuxm
	AtrAD6+leuGJJVudsGyGNsVr4qgR8E3sR+gntRriFSffU/i0ZiZyvIlwLajC2Drq8T3TZWPYleK
	d3Y1Wv2sSegtkETTccQ6Z3uvYKFl5GDs1nBkDVXdiRcgdGDEd4khm758cxUDClfUEWYIf738ya4
	9NDK6GY+k6Cq809QmCcZG/NhgUMkrXyaM=
X-Received: from wmpc34.prod.google.com ([2002:a05:600c:4a22:b0:485:3482:21e3])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:64c8:b0:483:8062:b43
 with SMTP id 5b1f17b1804b1-48727eb7f4dmr252230715e9.19.1774943393579; Tue, 31
 Mar 2026 00:49:53 -0700 (PDT)
Date: Tue, 31 Mar 2026 09:49:42 +0200
In-Reply-To: <20260331074940.55502-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260331074940.55502-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=846; i=ardb@kernel.org;
 h=from:subject; bh=DspK9ILwbkU2K9P3QWlgKSmk7WPgvh8qrRYpz8jocUU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN0zfQk37L7t5l5LA+oVkvmHHrkYbvO8MtnGdONZ+wMT
 aamP1jWUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACYS0MHwv4LD4VTLCyU++Rb1
 Rw7S0xKuBHKv+mlk90dm4T6+LEXv/YwMu5/kWM+vuHx0R5APlzNvsKLTk9i5d6LNDtiV/DXw1n3 GDAA=
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260331074940.55502-9-ardb+git@google.com>
Subject: [PATCH v2 2/5] crypto: aegis128 - Use neon-intrinsics.h on ARM too
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-raid@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Use the asm/neon-intrinsics.h header on ARM as well as arm64, so that
the calling code does not have to know the difference.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/aegis128-neon-inner.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/crypto/aegis128-neon-inner.c b/crypto/aegis128-neon-inner.c
index b6a52a386b22..56b534eeb680 100644
--- a/crypto/aegis128-neon-inner.c
+++ b/crypto/aegis128-neon-inner.c
@@ -3,13 +3,11 @@
  * Copyright (C) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
  */
 
-#ifdef CONFIG_ARM64
 #include <asm/neon-intrinsics.h>
 
+#ifdef CONFIG_ARM64
 #define AES_ROUND	"aese %0.16b, %1.16b \n\t aesmc %0.16b, %0.16b"
 #else
-#include <arm_neon.h>
-
 #define AES_ROUND	"aese.8 %q0, %q1 \n\t aesmc.8 %q0, %q0"
 #endif
 
-- 
2.53.0.1018.g2bb0e51243-goog

