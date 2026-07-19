Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D3A39D6FC
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 14:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784472258; cv=none; b=G0XgHoph7yq/vtZ4AHg7CZJdSvplSq9WlKlaRsa+XpYbC/5TJwXZcfiqwXn6Ri4ctI8iC/oyutBV1L+T3UYpMseHu4NHp2bS0GMXndkF1ZXpKln28QoLVTGbG9sI6dJn+7iR5xKf2Hz9yFtOV0VzYKxEYDgohRP50Gr8o7h95zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784472258; c=relaxed/simple;
	bh=9op5tZbQu39Vzy3AVcyVGUrajiK8Qqr69bzJqzZwd+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSFRygDdmhsW+Grj268GKOS2WJn2L2cfkSMM1urnTlXj8LU96J/ZnwpRKZW1AxFSgNb2udlQsQY+Z1IlkmnOCRPyL8nrbbSEm7T1Mo2qntSS8dLXMZgbq9pqVvTyGci6OEGDYUZ2epWraFByq+8DPqBcxqG2egoyAkM9pr0orD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=dsVk2XDh; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="dsVk2XDh"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4955e639f5dso652505e9.0
        for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 07:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784472255; x=1785077055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GpBxTmqmOVWJ4/EBs68z2UAKN7QGorTHkreALpGZ8yY=;
        b=dsVk2XDhbzu+o/F/6GXJzn/DuVXxvO24bCV18uY2lRkIRmT2u2tT5EUNYdATXLM9UP
         y3weW3cY94TgI5Z0XL3ElRAcHWJWOGS4wFCfzUzKn1DMtuw5EuOdHWoo/KKL9JQY86y0
         MW5g6+XAdlN2U/o7Uh1c3OdrL8AHbspUdbojnNC1ilpPZUlIv9AvetFpmZGktJs4Rug/
         7BKmbl0Mb0U9MI0Hrl+xgW+dAS2wYgJfsUpkz0be2Air0D1OwmBXgeWSGraf2h66L1pD
         BP1Dqv/YQeGuHY0gHq4mVxOtEwWEy+nHOq5LY8MDkow5IL4rzqrSQMSSf2jFQnClwbmk
         i36Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784472255; x=1785077055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GpBxTmqmOVWJ4/EBs68z2UAKN7QGorTHkreALpGZ8yY=;
        b=LV4q1qh90duK0DxxSdV+7AvqlT+GGQ+vAI/qc8tmdp15kUPl0gMdn6RQGP2kToAQnC
         cpv9/7GRNL3CvnmJQlqAlvTbqglxs+txNRYWcYJx16elmrwI16eJ9q35oElP980wZ4Ix
         DuWz8i87kQ7j7L54px+M0qqvsgMHznjYXRVmvvtmlthYgEclWzzvE4NqjZ4nUXiygFHK
         JvzmrrqH2obxcjMPzrAEGpSyEdTilEWa5+TL8QEXV+MDHZVCHeXWPsW3xFGPA5ICN4Ds
         NawmCCxMF8Fvx8PBGRHjiNp+js2DaWyY16Eva6Al6FEJIwl5bRbUcWYkDXhklQJm6UVB
         kOIA==
X-Forwarded-Encrypted: i=1; AHgh+RoftwIY5PStHJV0SV9NU9FGUfTKirbNlPIwPnYlbHMnWEmDQQvOLOGi+M0plx1uTAkWEtMEoQO6QXuT@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/cawVmXTqW1PeyuVtuS9LdUVL1KU9K/JhLo8r9tjW9btS1MeF
	doFiky1hFrz07UdE2yEWTQ+vHJk/1XlmLRCQ2NHVTwdj/sW/nvPEL0VWVDFXzGJ3TQ==
X-Gm-Gg: AfdE7cnSvIWmnIAPSFv+C1qEitRivu58nQhIXyhyrivBNeWPYTAnxvGusCPbT57SWub
	1DcyGblpPOLUnlzG1QYKbEBMEEECjBd65iYHVZMzk/VmLLrvtPwgBDOeYx7p44+FQBRiH/G12f2
	kGyk0paGr1WjU83w+wdbcNTy0TEo/QuWIR2bStJmXJJUS8yuyEzJHgiEn/0F4KWzuF9I3NyCGBZ
	qMyWKC29WSAzsg8qxDpcPoLFMdxh2OaZYzGAnSj2xY11HDOP00MpU4jZI56Xyv+IeWdNUcOlmIQ
	TC0NdO4wd8WhYRLXI2YgK9eTTkMPV3prNN94oEZvvtR6w9Z+2yj7VuZ/tw9ibKoPGww2pvPIh/w
	u2+xq0gnLQDJ4+aeQFtI/jfxRfmTV3beejXBp3DxSXKm9ufyezeXpEa7CnCbkwQ==
X-Received: by 2002:a05:600c:b85:b0:495:5365:c0d1 with SMTP id 5b1f17b1804b1-49553d85ea0mr60761645e9.14.1784472254747;
        Sun, 19 Jul 2026 07:44:14 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49549c9c940sm190238905e9.13.2026.07.19.07.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 07:44:14 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] md/md-bitmap: mask sb->state on load to drop runtime-only bits
Date: Sun, 19 Jul 2026 14:44:06 +0000
Message-ID: <20260719144409.940492-2-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719144409.940492-1-mykola@meshstor.io>
References: <20260719144409.940492-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

md_bitmap_read_sb() does `bitmap->flags |= le32_to_cpu(sb->state)`
with no mask, so any bit set in the on-disk state field becomes a
runtime flag.  With BITMAP_WRITE_ERROR (bit 2) set on disk,
md_bitmap_create() fails with -EIO and the array refuses to assemble
until the bitmap superblock is rewritten externally.

That bit can genuinely be on disk: kernels before v4.15 wrote
sb->state unmasked -- commit 97f0eb9f0fec ("md/bitmap: clear
BITMAP_WRITE_ERROR bit before writing it to sb") added the
write-side clear -- so an array that hit a transient bitmap write
error under an older kernel carries the bit forever.  On-disk
corruption or an external write plants it today.

The write side has masked WRITE_ERROR out since v4.15; the load side
is the missing half.  Mask the loaded state to BITMAP_STALE, the
only bit this loader consumes: WRITE_ERROR and DAEMON_BUSY are
kernel-runtime signals, FIRST_USE and CLEAN are used only by the
llbitmap loader (a superblock this loader accepts cannot carry
them, since versions above BITMAP_MAJOR_CLUSTERED are rejected),
and HOSTENDIAN is derived from sb->version, not sb->state.

Reproducer: write 0x04 into byte offset 48 (the state field) of the
bitmap superblock on every member (a single forged member can be
masked by another member's clean copy), then assemble: RUN_ARRAY
fails with -EIO.  With this fix the array starts and sb->events
advances normally.

Fixes: 32a7627cf3a3 ("[PATCH] md: optimised resync using Bitmap based intent logging")
Cc: stable@vger.kernel.org
Assisted-by: Claude-Code:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/md-bitmap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 0f02e2956398..4dd3fc2a9e15 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -931,8 +931,13 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 		}
 	}
 
-	/* assign fields using values from superblock */
-	bitmap->flags |= le32_to_cpu(sb->state);
+	/*
+	 * Only BITMAP_STALE is meaningful to this loader from sb->state:
+	 * WRITE_ERROR and DAEMON_BUSY are kernel-runtime signals (kernels
+	 * before v4.15 persisted WRITE_ERROR), FIRST_USE/CLEAN are
+	 * llbitmap-only, and HOSTENDIAN is derived from sb->version below.
+	 */
+	bitmap->flags |= le32_to_cpu(sb->state) & BIT(BITMAP_STALE);
 	if (le32_to_cpu(sb->version) == BITMAP_MAJOR_HOSTENDIAN)
 		set_bit(BITMAP_HOSTENDIAN, &bitmap->flags);
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
-- 
2.43.0

