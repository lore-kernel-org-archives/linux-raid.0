Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCA32E282B
	for <linux-raid@vger.kernel.org>; Sat, 25 Apr 2026 08:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777107531; cv=none; b=top4NAdHUYqtsUW5qYJqSqf1PZbnHZE4pPbrT2+Zb+epxTnf2btXXRurgqhXxe1bkNyeYkVlHh0cK3BruoZE+yIm5/dybzVCf0r3icv+FqfQO7UUcKapdR2Z4nzgwbUqXLCetptq2ghwor0jCmA+ErUU7kz9CR3vMKmD4fkgtco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777107531; c=relaxed/simple;
	bh=LzL75gFudJSPWi3FbVERpvmTGQyuI5o6kaORXGPetEI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aTdWZ/v24d6JI0KbwWkUNHWF74aNpyuOWnQSjBSfjm2QumTgb3+9MnKs3yFEeOcgA2RDLAweIEntzSgr9XAVCHtrUXR6zaBPxa2ckNAC+RIIob+wl+VKcBpQwRM3kT4DqrSAqfW71xN4dJwMQfcRT1inWRmJMOYn78US9FnPKoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KQGs5Yn0; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KQGs5Yn0"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso67745815e9.2
        for <linux-raid@vger.kernel.org>; Sat, 25 Apr 2026 01:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777107528; x=1777712328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UaLrvDon/RLFQBkolNYXT9SBool/0OkIj4oLI1l6UsE=;
        b=KQGs5Yn0C8VEvOVknsbsnjVCrMfoYGpRPitB/DpOHj+kqsMwCeiCxwkdTl5RFhcbNC
         /+ZazyiTLelW1jLcj8QZ9HjaBMhuwpkGmdjxVJTvNf6b5hBtsEzeixQXj+DTjYyj0zCe
         ZfQh0ebuyZtCAT0BRlMki1UsGmhOdeaHKNvh7r6s+zFdN6id5IoGAjFkDdzOjwhsnWDW
         YH1If8lyxWgLgo4buNxkG4z5INCN+gUchOWOnfp8SI9SNlhtF+T6nAPdetb7VaaIX03h
         wpj3Biv3vTLXMpyVTZiFgy92nSokl3mFsbLpVX8VA24THbkn/LhBjAcf31QTAotBf5KP
         7c2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777107528; x=1777712328;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UaLrvDon/RLFQBkolNYXT9SBool/0OkIj4oLI1l6UsE=;
        b=ZxUYJP3qRktzWQaIHghpEJRyBcD2lZhEASl0wd9VGal3f5qto8nj3/mcY1meSBkt5t
         9A6EwXZEQNf87bVzRR7hICkAP6xn4LJT4BzmHihL7/cHff76GVCUrgmBhDmfcwkbArg2
         FyHHaRWZUYz3FS37dDYfkqLfXXSpCJSBxqcJMx6BRUVlh99DARSQZ0oOsGit3zuxxMc5
         7ZxbZ+I6k5yL8EqERu+iF7/Z4g8iZ0OOAZ24F4+LMea5320dysBVz1dgtrzM9sCbJyD0
         APO/mG4xkrdtNR6Nv79Ayemih23rMFCOadfnrBS6jlUjJ6FRIYcS8f5SXqQdLiVfl8Yq
         Ni0g==
X-Gm-Message-State: AOJu0YwWVL2iIMEuLeSeQfeWcCgOaKY6zuLRMxxeuSAaFJhf/ImbdRaO
	6RkIDPcA7oO9ikQ12KyuVjfOfGIQ67SLszXYXyFIkQU4yYlrjcCJm2kA
X-Gm-Gg: AeBDieu5EA7xDJF4jlUG4AIcUzdJlyfwlozZwPFZCat37bW0mRbQ8qh3JmV0ZZwqO9s
	ElQqF+l9LfYbATOrDsibixekb1MobqjmwMast5+TnAl+9tRvvGBT6GuzCXWZmTlIc77RRJyOn1c
	NxSflvYzyCEeuGVyoeap/b/Rjtp76DRWNuNhr9evIyPJfJM1+G/5QckQfKa09SDZafdaNPHH8vy
	wOm2HX75JhN4dqBvaxj8GADhOIZkdC3Fy8oA5y/shVHsN2/Q3NdtXJK9aHPmdr30qXkL0+yBcSZ
	nTwF2eWAXFofUq8vVvc99KXDTVuP/URea1to2qjv/D/w26TNWNJK19wXMJNrlg6Ouh9WppsNUIi
	+JYeuIM0pfxs/47/sngZCRPvxbp9uIBth+03rLvhJS7e3xRQmbAExyyKqUkXa6QbPjfDwaBQy1K
	Yw8PeOBfgWQemDFEcHx/vj8IXQmRmuWAitEQ==
X-Received: by 2002:a05:600c:5254:b0:488:8bdd:cfcc with SMTP id 5b1f17b1804b1-488fb6e62a8mr535804645e9.0.1777107528340;
        Sat, 25 Apr 2026 01:58:48 -0700 (PDT)
Received: from yocto.. ([2a02:3037:66c:7629:ce5b:4236:52ab:dfe8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a525a0b1asm173524195e9.2.2026.04.25.01.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 01:58:46 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH] md: skip redundant raid_disks update when value is unchanged
Date: Sat, 25 Apr 2026 10:58:43 +0200
Message-ID: <20260425085843.3725-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calling update_raid_disks() with the same value as the current one
can trigger unnecessary work. For example, RAID1 will reallocate
resources such as the mempool for r1bio.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
It returns -EINVAL for the same value. If silent success is preferred
instead, please let me know so I adjust its behavior.
---
 drivers/md/md.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0e55639211f2..cb66c4ebbafa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4409,9 +4409,12 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
-	if (mddev->pers)
-		err = update_raid_disks(mddev, n);
-	else if (mddev->reshape_position != MaxSector) {
+	if (mddev->pers) {
+		if (n != mddev->raid_disks)
+			err = update_raid_disks(mddev, n);
+		else
+			err = -EINVAL;
+	} else if (mddev->reshape_position != MaxSector) {
 		struct md_rdev *rdev;
 		int olddisks = mddev->raid_disks - mddev->delta_disks;
 
-- 
2.43.0

