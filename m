Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BDE413227
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689817; cv=none; b=IpKP2GYUR5flm4yqH6jyf8Flc5+bcdfA5RQZsKl2SSeYyyXEJMwWnfZxXIGqApPpYwxd1wpBk0IYsgPnrBAuKJfNnv3ateZ82k/i3l+ZUyC5b98T7rskgRaDpczc1h+ckT0CrXTeBvpCQyzO8QkTs7FgoI1O0VA9VZuHdobPHko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689817; c=relaxed/simple;
	bh=603ECp3LsRCTDwA6d+NX49J1gLDpwbWoDttxJ4nU6RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFCoZl0fh/e1f4g9v7QTqjwIUGP1VIOUNP6A5Km5h1Dgi3dAfEB/MbnyOp/ZEwZIO4jy0P2X2t5v+Dw27GaQ5UC3Ft+kMxKc0Pjdqn697tVSk/o0St1r6tA0tCJX7XgdEuFkiqtbheyn27mT2pymzc4tPvC10NiI6jntUmHx8cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LppQ2MqK; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LppQ2MqK"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cc97653887so9496415ad.1
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783689815; x=1784294615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QvEKuPBz9jm6FdJaMqMjB0PQvymjFhmvflquqj7Yf9U=;
        b=LppQ2MqKKEH024ztyxnXXV+793/RJf+8T88wXyBXheDuDCBJ2lrxI1kYTTDyJd3/LP
         TO0VBI6pi0LemHhd5RMowv0I5HaKjJATWGIf2iAKq0PkWBKHKh5PBe5JJ+VvQvHmL6T5
         gjfFqKL1YogzePb8xE/hl8NUo4djcTKFyn2ASe087zR1nFNomP4YsDc8xsYf/kAljgGQ
         4ca8vXU9lv1B3/ctxDkzLQs1X+smEn5mgscZPMZeKP10CZxw04p20OvxFX97vD6ueV9g
         ED6ncSIz4d+zAQVghqW7h9Qb/NJYfRkAD7e820ACHJFRCMUJ7RcBmWrfQPEnClyMcF/4
         MTjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689815; x=1784294615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QvEKuPBz9jm6FdJaMqMjB0PQvymjFhmvflquqj7Yf9U=;
        b=fERhnUO3bFafSnwJbv7jisFE+PVr1gg86qyzecH9Dcj4B4KlmNjADcH8dqW0NiDFqk
         ttf5wL5NwO5jFKcyxDkl3Nx3k8uh7GJrk0U1oex9W4g68k3R48hgFaJhFSTGCOEFFBnY
         LLL/DgHpYuLyTyWI0zRNVeg+W04wT/G9wEhYVR7lFRzM77nRbEeOwojP3omjzGiEzV/m
         XCJ5Ic8Ab9dE65CUa1Ga7SPhiHNS1MYxly1IwQC1k1k6FyxNgQP1ViNb2CZ167+NvHOW
         X+23pvezBdCf+741yLDXQwKnXNjSjhOJIlO3LnQZoR6jbKe2ZO2V4q17AiEK3FqqF85b
         Jjxw==
X-Forwarded-Encrypted: i=1; AHgh+RpO7WYDz9q442NYYwJQWlKvmSULEo9T9QTDu9jwSPn7UuxmeXgErg4F7r938rKrnFdayi25we+JKPuy@vger.kernel.org
X-Gm-Message-State: AOJu0Ywow2UFRe0WB3cedqR3HYkcs/Fnduvjs0Y+UHsmdgLD26AbgQo/
	QFNyGeHiiLdkqpqgZjFgrl/PDlZWMjxZhZRTVQlmykBkqsigpRnGEblK
X-Gm-Gg: AfdE7cl0YpEbi3jdr0/HT2hHLLGfpTJnmyG78yiqtfZ2Mmba/GbCpykzcjYprlEXI8r
	YSL9DO+9l9IXByG3n8/gV9gfOH50JEITappBGUh48hi9MVr5MAWBiGZWQj2PnLJPzQ6d7vGduyZ
	0C3Y3vuVcfBHPVkMs5MRsMIiYbOoNs+GodK32FTC6XV7eGhYFBdnJS1KcceC+s/hAH2nWDbfJSx
	x99iRZa/jE0Ed0MJCXUa/jdShO+e8CTChal+BM4wB8MCtbjoGJ4F2Bwid3uX9rqgpg5m9gw84Cm
	CoUoby1kVI591Ku/cGiZmUPEjpkSflffgncM/4DSOTNRR9HKo3ds4vNBSkhWWmRQYPq6bT9eIe0
	brosTbLcWxaybkw2MnTnnkVohvbiTI9VnJ5G+3u/DrrhcDb/d1JQOOm59GkuFxL4zOr9oAVmAdi
	8rTa3PzFTclnoajFZ6/Z4frXbNWASrhQgyib3ljPK9LavYh13CZGZdCRLSGIR7Qsp7uTfY0f7R8
	ADlpII=
X-Received: by 2002:a17:90b:57c3:b0:381:9028:5945 with SMTP id 98e67ed59e1d1-389415eeb1amr11393207a91.14.1783689815065;
        Fri, 10 Jul 2026 06:23:35 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a55b413e6sm2710798a91.8.2026.07.10.06.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:23:34 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 2/2] md: widen badblock sectors param from int to sector_t
Date: Fri, 10 Jul 2026 06:23:29 -0700
Message-ID: <20260710132329.7273-3-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710132329.7273-1-nishidafmly@gmail.com>
References: <20260710132329.7273-1-nishidafmly@gmail.com>
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

