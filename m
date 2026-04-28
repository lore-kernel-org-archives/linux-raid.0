Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F503AEF4C
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 13:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777381534; cv=none; b=iDglCwFkHGotB+l27X2d2lHEZrBwa5/L6hoLxEPmN3jR/wn5SPCDXTphYLpcwHdHdAklVdbihkuR9BjfY3mIJ+bXfLz8wvjQwvo6BrbHghFYi/owb14D9B+L48rdvk12e0F2nbnaHtCR7Ul/3X1600S3W0BP1fVq/NrZ7A0zKgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777381534; c=relaxed/simple;
	bh=i38oEy/34KtFn6KM1kDImIRBAo0SP3gwiXhYFfsczWY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=asTOexqnF1diiZROdVGZSNbMgsW8em6xVqPxo/b2/4WJs5O4577UVIu8Xv6vd/xXYkWkJf/IDdMdeh+3z50baUtY3FDn4GCav5O5gGUMUVP3R75oKFPB3qoPgbMk7qwGWZgMHXKqwQ+FWM96Ef196lXYPPZi0saXRt94r1ECS9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VZfIweER; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZfIweER"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4891f625344so103444405e9.0
        for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 06:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777381532; x=1777986332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HhmXLpB2T3lygbBp1nmhNFuDYHFAB43CNPCB5Duufx0=;
        b=VZfIweERfObs+6CIllo4q/80gfhmSVpQCXe8GZnYYZyV7VUbN3lSfa4zLVS2CH/1a3
         FVwKAnUY9NE4UqAenMn0i9o0QVUJmguOsUcYsq9PYxPugaDxCchsr1/A+HvS3EWF3W12
         ++8cfEFJlzDHiq8x/rlZ0OVeELV7GE0HBIih61THPyY+VPiaH+w2DRSRgp7hGl9T0Y6D
         uZSOrEwVUUH95NR+iaTytpf9kTPM76Exqh/y6Hb+GjWLvDz0Y4rrP/pKwmRQEm7agEzH
         1+MhWsE3j2hpqCOJa/ZGGY5XwQNrjR0GJL8oitQ9u/s9wNJM8F7Yju/oWVJxDPxnbZzA
         Adyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777381532; x=1777986332;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhmXLpB2T3lygbBp1nmhNFuDYHFAB43CNPCB5Duufx0=;
        b=KOOwXt0IUE6lw/WRm2uyK9Q895pdzxw77ZWFk3gUQOhQVORPdex5wFfAVxPhstI2/E
         qs8Zij+DxcctkbMx1ZoOtE6oidte/TILOLLrc0d+KRqJeFKKny8auKFaEF+MJVzNFTbX
         LR4oLJ7CYOIOYEiNCMWSNIRh4onkcaV07NLOL9mGkfE5SMz+zEZXqkbOC1S/9USaqkrR
         5NSB+6S44wFDbpcpBDcz7kXXhejJE/Zm3wVSzIfxjca8wWK5d1UZv9QPzXcC6l8o2wU4
         EA39Qdb4OVjPwsuNn2eI7wtH2Tdgj85DCT4ojAFB43GUSaHrpVlagW9qdv+WZasKD37W
         kG9Q==
X-Gm-Message-State: AOJu0YwKVMB7e1SCxWfSmwF1Y9K0nhqaOTM1qcbArtGOjuhJHirfd4ZB
	cqu6wZvTKbNXVLYyyCj02YF0d53dEZPBcWk4NlUXkiYCjzIrNJr+31Jn
X-Gm-Gg: AeBDiethYazNd/X6TFS1N8H6DQy05sQW9hnWXy6pINQohPvUOer81ITwrkbWmoNrg8W
	kzFAW1F/rxk7yqnGp8o2sEDGT2PU7VhwJbsVukSJkPufQbbZIuKpLQJxuy2B7FSzUtC8iKdoyMC
	FMHHQ5SBnJ6o08vbc7OCYK0R5X3AmvQJtOvf5+Nnqe9MZK7n+mWnodlLm+p2jteTf1/dBxyQSlL
	Z2wjD+7lIT1hEmGesGDxXfjMCD8sz2hkc+eA7JhTI5l4YeKhI2H2i+hAjBLLiyUZPDh0zl3ljmO
	JKfoNTEPzg+LcL+nh8LLbT8tUtgnJ0hPETS9rS1E6+NosmzbzD3FlVu3Q8EQ7bxi0vh60HARrrQ
	aE0StbhMmx1ZWDLV5s6iDrAhhZuG+sZX7vXjnLiekD9ikFacIHliy/hEExVPmW6xjzRfmWJPWVh
	bZ8uzED5JkZBdRbrtX55bcm6emYk2Z4d2nqw==
X-Received: by 2002:a05:600c:4510:b0:489:32b:ac0b with SMTP id 5b1f17b1804b1-48a78ad9b56mr32604385e9.6.1777381531410;
        Tue, 28 Apr 2026 06:05:31 -0700 (PDT)
Received: from yocto.. ([2a02:3037:629:fd15:33bf:191b:faa5:2818])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a774a4031sm33051185e9.2.2026.04.28.06.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 06:05:30 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v2] md: skip redundant raid_disks update when value is unchanged
Date: Tue, 28 Apr 2026 15:05:24 +0200
Message-ID: <20260428130524.448063-1-abd.masalkhi@gmail.com>
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
 drivers/md/md.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac71640ff3a8..21b8ad17685f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4409,9 +4409,10 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
-	if (mddev->pers)
-		err = update_raid_disks(mddev, n);
-	else if (mddev->reshape_position != MaxSector) {
+	if (mddev->pers) {
+		if (n != mddev->raid_disks)
+			err = update_raid_disks(mddev, n);
+	} else if (mddev->reshape_position != MaxSector) {
 		struct md_rdev *rdev;
 		int olddisks = mddev->raid_disks - mddev->delta_disks;
 
-- 
2.43.0

