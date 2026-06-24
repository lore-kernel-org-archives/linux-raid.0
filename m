Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FE43DB32A
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316484; cv=none; b=riOHD0lZ8Tv9a8VW2tO1Dvi/FnR6j+lA007uBUagNVmvGj5cCAcPeXSwjhtbAhRsXM9qa9PbwvGaOxJCUz6S+c21ut5swv8SkCbsP2OwCQiQB+qgdMjflXJx4HXQBb/2TXX/1DyvnLL5osyyVMmUXS/SPtXTcKWQYo2k+BQVtOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316484; c=relaxed/simple;
	bh=qYZyPIhq+9Hy6lmM4iHNLfjcftFWfzKwdvEcZpVC9Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAaLUTmg1JbBF7vH74wqEm99U5lthYNxMClT10fH3UZl/5v+hgMKDNRH9RhSKHGbygMi5YUU91AFq81/+6wOuwX5geTIA18kqfLkjk53qa7WuWGb+nivSqurJ1dYKj71Lk6kxOHAQ2ziftQ9g9hz6Wp7p6UhQgULoii4qaVuK8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AeuqzaCo; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AeuqzaCo"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-37d46e0d246so736553a91.2
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316483; x=1782921283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSmO/zu9FWdDGCiokhmFLH/RmYcFJJtFUzQoOtm7QhY=;
        b=AeuqzaCoYybja5fLKuutfHVFgQanbA2JxVp6sB+9EBkpcMaYDrEMjkM57herPyXWNX
         FHlQXVIcGhH+E1rm+rOtw8Qa95dHkNqobhkOzOB3CsW4K5ZJGcWcCwjdjhePt9Etgjbe
         WfiTuVeSALGWLMKhaQnRIykhL7qEg2r32hLPx5G+UBRlkNnDLuMSlnPD45ssV7SlLhwV
         oiDe91Q4v3L0nDOsprl7hJM8nmh/b0/tfHzKy+NJRck0qpnUg7MNk7UK+qAtGnxTRnk4
         CRXUfXE5Ow5fK5siFC2dt7hgbxeLm7fscsh3YpgcDDd5yucvLQisJjXRKcHgdufTRJm+
         hWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316483; x=1782921283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mSmO/zu9FWdDGCiokhmFLH/RmYcFJJtFUzQoOtm7QhY=;
        b=os2I3uM1ScMnKfQSm3R1gKQh+Y/IZC0XxKT5oOD11HMtgrbIKoU3G3BTsKectUoEaY
         Ukusv0y0r4C4sMqT4qLYa7XbtjES44SlhUixmx6beZM+zJeh8NCblMNSDepDAd5/gliF
         nqYW6irlRIeRmjJUJFbQ4t0VcTvszR/pihcZGCg5p8sPj0b4jYLFzbYvnNDdKRa7gaVN
         M2XUJsI4WOQXzkVVI5WttMa3ERGTbca2F/yFqiS3s37V8+c3dYPoUMCHsTXzLeObJZ5Z
         bWT+iAettelukERtVGgCq0hMHLiA9jNDC4iD5Bt6CYopTmQcAIASDZY9NshgDXTiK7nQ
         k+aQ==
X-Forwarded-Encrypted: i=1; AHgh+RrW4h/LXKacbg/RGHVgwBW2jhRckN0HzNJibYh+wPWy3SyDx2iFwx3eBTkIJFA93hEyYQdhR4L7KfOr@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1F5gFrc9NF+lxTMVsAy2BKp6jZGrF8F1oUEk3j0g/rSwD/B2y
	pXTnhNcnFiOz8ya3SZ+e7F+kizwDyazqjOn/+HSsEvtF0wjY028FBNwx
X-Gm-Gg: AfdE7cli0qJN12lOaVK42Bx58XWkp6QrObNB4VoEd7xUEEiUT19XnsrQsvY6d8DJDP9
	wxObaANajHaPJ3EH2RGy+gX13XWCZqKnm0hau8uw3C6abqiuDhdGQLcsslujZQK1j5toXhl1dJm
	T91GBH2hu+bfg3OFVzWuPl2MrU5cENa20VekmkvypmmtQyIeh1HizZ3UfYHCn6E6Jol9uPaFJgu
	kBhrM/JMA2gpsSzs5IsvUmcJYA0PCMB5dQB4BvaHkv0neHp+oVv2Un4dKMCRwQ+UjHWv58PlShs
	P00xqnbfhJpbszu2Ydum9ItcVlUdt8ye3fXtSCmeM439plqx5MPE6wVrvB9RK7bRgOyhBNENWpn
	HcHXuy2RevcJm1Qt4sw0YVEKvzYkvwUe1FtkgTjWcxKh6TCIz+z3ZXXzmAdOmohP68P0Yo/UyVx
	1btRTUJGLqlIjzpDo6Tmi9VJQj027RVwgNneiwyrSJ4C3Xe3+p/Txp+RSprkppkirR7uP9JC06K
	dpCXBniZyXpTRhz5w==
X-Received: by 2002:a17:90b:564f:b0:36b:7c2a:263e with SMTP id 98e67ed59e1d1-37dd0dd58d9mr8763565a91.20.1782316482649;
        Wed, 24 Jun 2026 08:54:42 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37df3af8563sm54939a91.5.2026.06.24.08.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:54:42 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 3/5] md: make is_mddev_idle() take a bool init flag
Date: Wed, 24 Jun 2026 08:54:19 -0700
Message-ID: <20260624155421.211626-4-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260624155421.211626-1-nishidafmly@gmail.com>
References: <20260624155421.211626-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

is_mddev_idle() took an int init flag but passes it straight through to
is_rdev_holder_idle(), which already takes a bool. Make the types
consistent and update the two callers to pass true/false.

No functional change.

Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/md.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..829b4a3f545b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9219,7 +9219,7 @@ static bool is_rdev_holder_idle(struct md_rdev *rdev, bool init)
  *
  * Noted this checking rely on IO accounting is enabled.
  */
-static bool is_mddev_idle(struct mddev *mddev, int init)
+static bool is_mddev_idle(struct mddev *mddev, bool init)
 {
 	unsigned long last_events = mddev->normal_io_events;
 	struct gendisk *disk;
@@ -9771,7 +9771,7 @@ void md_do_sync(struct md_thread *thread)
 	pr_debug("md: using maximum available idle IO bandwidth (but not more than %d KB/sec) for %s.\n",
 		 speed_max(mddev), desc);
 
-	is_mddev_idle(mddev, 1); /* this initializes IO event counters */
+	is_mddev_idle(mddev, true); /* this initializes IO event counters */
 
 	io_sectors = 0;
 	for (m = 0; m < SYNC_MARKS; m++) {
@@ -9920,7 +9920,7 @@ void md_do_sync(struct md_thread *thread)
 				goto repeat;
 			}
 			if (!sync_io_within_limit(mddev) &&
-			    !is_mddev_idle(mddev, 0)) {
+			    !is_mddev_idle(mddev, false)) {
 				/*
 				 * Give other IO more of a chance.
 				 * The faster the devices, the less we wait.
-- 
2.43.0

