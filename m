Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B9B3DBD48
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316511; cv=none; b=Bes2iwX+ayR50L6bWEKtwMNz7RSlEUtfD+rDOqf1aCwvGf5zF+tQwOTCEcC6XC+7zzXrdFAy4Lx8cN+7fYGEXYETscnVO4bqrZv0s/TEONoq2qMt0yhyumTsT1ritzpdMcXiyGQZ5u9xkU9ZWdjV+WgNO9b61TUEd2COy1elHug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316511; c=relaxed/simple;
	bh=7DBF930HRx1qSxfelYdxhK3lf243Ict4ISIZ0LYinF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0WJxkfpNPvJSBfO6Y80NxQtXcmRpEA6Tp30Q5EnPtsjmSNXlpSIS6KaNgR0RGdYalKCbsNWCIalrM9zJaP6H029WJNzcEpdiTzMBaBd3IWUTEEWUu2lOe3z1SDsZYZlL4r9Ujm0oiILK+u48h+UZx6Q3gryC7jo3SKYhcEFA2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i2zxco62; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i2zxco62"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8456005a6c4so850044b3a.2
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316510; x=1782921310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xdng90phw5EG5K9iaDiszT7p3OwaKYp7wdHDDtBp4Sw=;
        b=i2zxco62c4K3lgBM725qqF4UkXglg6iQ4ilg3ELWXR7TH1VOdB6N76oRatyN2Dsl6L
         2WUOxwceQkXBIEP9Xr+cNsKU4fU03KkkdqeNAIRJQfh2OGFDGZqUJD4enISqcZaiNalz
         8RjV/V1XNEpp009umOb+iFxGTT8cKy/xmCxIQW9qKt1pg3cz7GAhOnmiQgw+JoU1/Vyp
         dg+kWKYM8kQ6ac6k4pYN7SgaUDUaqf6v5h3ZAfasG2tVb1b+80uR8kHLcDack5cCWWd0
         AbjmZz0parDgwFiQX1gHyHJG+dWyNylYKm8l21yGFl1rgy9ogyXqlXCe3XXjlgxlJhVo
         R7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316510; x=1782921310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xdng90phw5EG5K9iaDiszT7p3OwaKYp7wdHDDtBp4Sw=;
        b=M7qR94yUYZ9ZEKP1KKQV1sCb/XXsWVR7bRESZBNz9mChT8eS6NfdeIJCvzw6Jdz2KR
         b5PnQdHMya7vpVCu/Ri0+LJBzCx5a2KG7CRdAGPLxKxMxP/+T1O9eqcF7KFW8NrJTJQj
         kySaXA1+4zvNxKTqXv7agwC9YLwxtnthgPvYgYsJUtAzWO1G4cDmgOmqkSjXRZEWxMNf
         bJajAKj1exWwOpQClXyu5KBkV4V2u+bOaflK8kSEOTofTynEsEBgrLwmLrglQQQYtOVn
         DK9eI0uNrsSm7hQPSziAeLkBe+w/kell0j2S99wcVU9ApPpVmr7hPqQvdFzH1aUhE04X
         qNAg==
X-Forwarded-Encrypted: i=1; AFNElJ+Uf8LipOCo1TJ31ezXm4eAg4Ylz3NLP64iGp8IZIZefbcZEuh1+Bs+x1TCekbTvzZlMqoW0pHrl/6R@vger.kernel.org
X-Gm-Message-State: AOJu0YzOaJlk0rNOboHdUhhY5nit6K3QgNp91OcUvS1HxOlLorXK/pRI
	7Dn7yQApM6C7tVpSH9IjWP8hii1gOK/35Co7WvK9d2BkfGJX6TC2gZvG
X-Gm-Gg: AfdE7ckVVF08fFeB0d1uAa69fz3RaO+Us7eSS6+6RQdJDfdnggJROhX3H8m0rYWcZ6n
	uRlRPvlWrqn2CU4ZiNYaTKBi1qSJdmjPmWIpH/3ul+8ititSxODEjT+Q60gLJsbvyaRtj3sDMaV
	tvZRpot1m7DA2MkUfPvZDlec1Bki3qivLahCmOHw1yim5v8yPqQPyKYZg+9QyZcLggSi2gGAfSP
	N5IVnKetH958lm5uGlbHunFs/moV//Iai9IBKlZT9lNtg9bNE9gTMGsWBOF+7F6N6xQWN9C14Bn
	7Kz8jmu4Bbksv1GvDtWB0xJaubSPBNw3tdnNCBN8MgPrRA5Sbd7Oxd8Tx7EC83HFWAenNk29DWL
	YqqluorK0xOgoSom1r4+AAl2SFnIQv6TbYycPHrWi6cR3o0SUHGIsHPAUXmkLVLrGjsLXbMwl+n
	hR72khcxE16HCVgHd45LGQq25sJbHPz0zNWVF5pJ9oOh+AO6jdY1ymR6DvsnHPswVHH6bWCRPBQ
	zngLoo7vqFYh0+oSw==
X-Received: by 2002:a05:6a00:928d:b0:82c:e9cc:f61d with SMTP id d2e1a72fcca58-845a2a76e3amr5089373b3a.9.1782316509562;
        Wed, 24 Jun 2026 08:55:09 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40f55cesm2658387b3a.44.2026.06.24.08.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:55:09 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 3/8] md: widen badblock sectors param from int to sector_t
Date: Wed, 24 Jun 2026 08:54:47 -0700
Message-ID: <20260624155452.211646-4-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260624155452.211646-1-nishidafmly@gmail.com>
References: <20260624155452.211646-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The badblocks core API -- badblocks_set(), badblocks_clear() and
badblocks_check() -- and the is_badblock() helper all take the range
length as sector_t.  The md wrappers rdev_set_badblocks(),
rdev_clear_badblocks() and rdev_has_badblock(), however, declared the
same length as int, narrowing sector_t to int and back again in the
middle of an otherwise 64-bit clean path.

Change the sectors parameter to sector_t in these three wrappers so it
matches the core API and is_badblock().  No functional change: current
callers pass per-I/O or per-resync-chunk lengths well within int range.
This just removes a gratuitous truncation point and keeps the type
consistent end to end.

Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/md.c | 4 ++--
 drivers/md/md.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..61f40fa41e78 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10553,7 +10553,7 @@ EXPORT_SYMBOL(md_finish_reshape);
 /* Bad block management */
 
 /* Returns true on success, false on failure */
-bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
+bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, sector_t sectors,
 			int is_new)
 {
 	struct mddev *mddev = rdev->mddev;
@@ -10593,7 +10593,7 @@ bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 }
 EXPORT_SYMBOL_GPL(rdev_set_badblocks);
 
-void rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
+void rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, sector_t sectors,
 			  int is_new)
 {
 	if (is_new)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b9ad26844799..95835a3286aa 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -311,7 +311,7 @@ static inline int is_badblock(struct md_rdev *rdev, sector_t s, sector_t sectors
 }
 
 static inline int rdev_has_badblock(struct md_rdev *rdev, sector_t s,
-				    int sectors)
+				    sector_t sectors)
 {
 	sector_t first_bad;
 	sector_t bad_sectors;
@@ -319,9 +319,9 @@ static inline int rdev_has_badblock(struct md_rdev *rdev, sector_t s,
 	return is_badblock(rdev, s, sectors, &first_bad, &bad_sectors);
 }
 
-extern bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
+extern bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, sector_t sectors,
 			       int is_new);
-extern void rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
+extern void rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, sector_t sectors,
 				 int is_new);
 struct md_cluster_info;
 struct md_cluster_operations;
-- 
2.43.0

