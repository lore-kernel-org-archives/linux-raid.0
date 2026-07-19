Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA2339D6FF
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 14:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784472265; cv=none; b=s3wP/XbvKIOP3n7gPf+RWjtJ7JiG08ops7g4v4d8al28Mjq7pCMi35lCyhWRdv56V1cAAGpn4XmbXbKFeWEJBQmmOlFaVCS4cS0XofUi3rX+lxJpzCN/e82uuAEBDTL+t3HPiP8ZnX33TKLwmMIsaIxX0YTiLWIVHyF3fDjeFtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784472265; c=relaxed/simple;
	bh=/Ak65HGCfNx10gucoukiCwZEowYeqQLnSJnZyR9dXnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAHOGF2zoD3unvYq8ayKf8WG/iLvFjLUuNr/0sMTcVC7WidpQp9hlry4Cm+6Una2dn92rxJMIOKIcwrkvEn8YK7cfDR+Hi//AJE85bS3O8Kh3o2YYgBHgOh9IZWmKmbNZiM/7YGf8gL/2MFMbEObYlM5v4Ru4FrASAa8YqOSRZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=ovvjhX+i; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="ovvjhX+i"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so35433575e9.2
        for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 07:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784472260; x=1785077060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s8d/kYE6gB7nFrCDCulivUxizVrEcWfSYSHuPECy3cA=;
        b=ovvjhX+iohpBMV0P3HzIabSipbFz/ls7YJd0gG2R5JsLuEVLHe4Wbo64ygWgwrrYnw
         WIVC89G4s12ac7LMOGBHsT1R5nhNSSr+wKnQI14DqrIpkARmZUWTKYr/R5hUg05SEsVr
         hfF0kgDWiQLmK1fcImOiSDGzP2GR2sXn8vA0szruRA2y59VGJsxW91wl1oSN4jtL/X5C
         GR0VE03gOik1xbfGsJOEtJy01oWXbVRBxkj++2e19DLfcrsPjeGZ4IRuy+R7vcFMP1MF
         hIc7t439ZMwZDik0wrDRN7dTxUIwMFpy2+7DvNVzWKacD58Cr7f/bb257M236ylD33Gb
         rLVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784472260; x=1785077060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s8d/kYE6gB7nFrCDCulivUxizVrEcWfSYSHuPECy3cA=;
        b=LQBZzptKzk3JG2ryWIyO/laXIsJNQckJVhPHn4Z4DlnJoaU2om0h8wyhPtgThnzGC8
         oenPgc7Og8lrf1woHzpxbMVuxP2o/Tn21jM4Op5ClN9UCbmAYyhvhKnBOrlFsQYKlN2p
         gs+9lUq5wQZkeUmBz/pg4C6fy3kxEGtu985DiZqR3Mga3Y79ETOkUHRAFHxBh3QCAmKB
         Yg0oGKlmHC9tUXQ0f9Dg51768MxFNSooCUuy/iNrnWSdAPFcV8xMi8rSO3XNnDRCZ/d5
         cr4D7+qR3+LhhDWVNCsSllP1TggRVq3Z0DUA0Qcb4tDgMfaRr3DI2oclA8bm9ypBwC9T
         QB3w==
X-Forwarded-Encrypted: i=1; AHgh+Rp9lUML9tiaONrNhCaB83VhqVkwCATZjtLbYLN0TKEihdLTzNLUUG3JQGSzPndJLl83IiZXnvJgKs9C@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1lJG2Twz9HcFBMrTwmFaTZFIvqWOAZ0e3c9PpSnCdaq4oq1VL
	w+/efW9npaTpc0E/lhzfLRrwZ1RW8UubjJnPlvpzhW5tj099X5fznxyWv78lCbLllA==
X-Gm-Gg: AfdE7cmL9FcNNouEvZ7KeqBtHoX3XDE7ICENMbKT1b3AQzUKhtEwLHw/bkERntYtNrE
	M+4Jgt0ZzLAgfeG7zRfRXCSC988kJY8RC00L6QAuIabdz+ADMurXG7WMmQKMwPH18WOzUq+trsl
	s/Ab4I4rRGMkzfRb16SCyz7pP/2xXN+GK6sPEjFHH1R7s5Au9J+u3IscNfxu06YOjFETQdqVZk5
	tp038ZM5DiCmt7VYJAHRGwAzDj9p/IM7Zob3nzy2LZFJ9E0h1pP9acTgpj+Xzs/nZwLeTNsQjQG
	ruKwPli4mBSRy451PmD8g7ph5hXeIDPKNBS0hjwJ9pk7i94GzJzq1m+6C+KpHj2BEOPm6Fv0lDG
	E/R65C+1u/C26NlMqJFm8mKQtLmtObvGcW7RedknrDwagzFzsGAKUFQ4O0IpheQ==
X-Received: by 2002:a05:600c:1554:b0:493:a570:df7d with SMTP id 5b1f17b1804b1-4954a402f91mr123020225e9.20.1784472259634;
        Sun, 19 Jul 2026 07:44:19 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49549c9c940sm190238905e9.13.2026.07.19.07.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 07:44:19 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] md: include events counters when kicking non-fresh device
Date: Sun, 19 Jul 2026 14:44:09 +0000
Message-ID: <20260719144409.940492-5-mykola@meshstor.io>
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

When analyze_sbs() kicks a member with a stale events counter, the
warning names the device but not the divergence that caused the
kick, so judging whether the kicked member is salvageable means
running mdadm --examine on every member.  Print the member's on-disk
events counter and the freshest events counter in the warning
itself.

rdev->sb_events cannot be used here: it is only assigned when a
superblock is written and still reads 0 during assemble.  Read the
counter from the superblock page instead -- md_event() for 0.90
metadata, the little-endian events field for 1.x.

The legacy substring "kicking non-fresh %pg from array!" is
unchanged, so existing log parsers continue to match.

Assisted-by: Claude-Code:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/md.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d60ea7aaca3a..9ec87375a717 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3934,8 +3934,29 @@ static int analyze_sbs(struct mddev *mddev)
 		if (rdev != freshest) {
 			if (super_types[mddev->major_version].
 			    validate_super(mddev, freshest, rdev)) {
-				pr_warn("md: kicking non-fresh %pg from array!\n",
-					rdev->bdev);
+				u64 rdev_events = 0;
+
+				/*
+				 * rdev->sb_events is only assigned when
+				 * writing a superblock and reads 0 during
+				 * assemble; read events from the on-disk
+				 * superblock instead.
+				 */
+				if (rdev->sb_page) {
+					if (mddev->major_version == 1) {
+						struct mdp_superblock_1 *sb =
+							page_address(rdev->sb_page);
+						rdev_events = le64_to_cpu(sb->events);
+					} else if (mddev->major_version == 0) {
+						mdp_super_t *sb =
+							page_address(rdev->sb_page);
+						rdev_events = md_event(sb);
+					}
+				}
+				pr_warn("md: kicking non-fresh %pg from array! (events=%llu, freshest=%llu)\n",
+					rdev->bdev,
+					(unsigned long long)rdev_events,
+					(unsigned long long)mddev->events);
 				md_kick_rdev_from_array(rdev);
 				continue;
 			}
-- 
2.43.0

