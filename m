Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B41B4F30C3
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 13:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788787798; cv=none; b=YSQxI5fhTwunJFgtnBkWLckQG/4uImcdQ96OMe5ZVNEu5TnkbFUH2hOmF0m/DnfsRTWe7+OkWnuCYcqPLmT2inCFRII2yxvZ0zKK32S4hxfllrD2BCgoL62xbPYtqxsHNFq9qY6rjlTYvGPDx2trYWESgpjg7i+W2m7xUDXEcvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788787798; c=relaxed/simple;
	bh=DU09zw/q2QurpiDsBXe0WYUFmSbboztu/xbFyBYnU9s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iZkor5yj3H1D0ATp3SH8jEI4J6SbPOrSXOh3GxuBUIsCdlOgXh05LXOKJYe3NY0XOsaYBPbZrREwHz7j3jGGh5PwIpGgvIofcDOdJunfQgHAfvD96Ynq1IZn/SZSYNePmNnsUKAVEWdp7n6rok/60qoLT+TIWth4rcnQ7GfV4RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZcCp65oO; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZcCp65oO"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d9db539a54so27881165ad.0
        for <linux-raid@vger.kernel.org>; Mon, 07 Sep 2026 06:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788787792; x=1789392592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LTHmmouueQufOHOv0npHPHbHQCg0ThYyw+cVo5nAdfw=;
        b=ZcCp65oOo9ZAzDjcGPNgQ/lB1KBryJ9vcq28A4/PCoWg1fHm19Pkufpl0mPJuBud3j
         VnxcI8czd93e4ZWdsv29kzlzLjqm20Xe07HJKNRKZmkeyrFjAunhSAfzmQDNRqlM9R2u
         yzAZ8KdFpajBIXmVLUycknZg9GG4QkNGoEdeyWKKUr8UoaFM7zChZLO1g/a5BIsfRnnZ
         5paGBSv3ZC/xMbd7Rtq110s3epdrlAtj2rlQvQbWeqdSlpUBUOA2w4YS0o8svi7n3wNC
         QhJTfvVBtivku6ESJWzoi7EI6P8gVOqR/cIvF7PyZD01XSJZz/wcsd/FK63ehNynAqih
         33gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788787792; x=1789392592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LTHmmouueQufOHOv0npHPHbHQCg0ThYyw+cVo5nAdfw=;
        b=W4kIPOEfESsQT3ObnD2x46t7EV9dRNKyZTBghBKTXEdo0ZzAWTwVU3zmnPyQRikUvn
         B4DAKTJsdaTm4ImwvS6mOHRuD3l/6LO2mQIRJcgwEqnweXrRVaLHrKKNdU6k8DWSn7Xt
         RbtGgeBgUtxjL+GheUjNlaz4LI2ri+bPhzKDQx8o0FXOEEAQWoHTWA8N5y95FxP3KjdW
         eKxuptxie4FHwMIseVEz72eNh2POfgIr8HCRrgH9LCOhXcN8Epy8ipoD3v2bluHjWDk+
         W1Qox/HB277yIiypQJ+YTLW+og9+LL/gKJJcgcs2c/RukexZZKzkY5HxE2A/UgO7QE5n
         ng8w==
X-Forwarded-Encrypted: i=1; AKwUvBz5m4k1F4YVfspYRrHiVNj1Lr7UgzVlCn+QnOE3Se66sSmS6Zkf2TGHcDoo4FCzTVRiYKlFT4Os09xR@vger.kernel.org
X-Gm-Message-State: AFuF++nkrwzyBhKHcdbQaEG8q2EFskxkpqZn4+bE26K7npnlT/08rVrt
	4k2K0qbNGqQ1JgkX9rSj5JW8S2b5pvA7hBiLyx2+EQaXuwDXmbblQC0v4lZiYnF0
X-Gm-Gg: AYBFou0TH2r5vP62tcl0XFpaIE0uG6i4KW7z8IIohZGqe5Ud8fgJIDSWWkZHsdSUw6b
	8CfhRX8/02aAYhM4sl28CuB8r2DfCl9VBpLOyC88UV/VC7+tACIX8qT+LnHH1rG+TCNkZLot3op
	n7gnv/N1XKzw+kX+voEyl9xL3wdj4fEusjsG2k0vNkzNHwVVB+bVZOGYcCK47LPovG1VqcaMyC4
	g80EebPjDdhKlQHjKMk2n3ptNoXQniBBlwexVl7O5HMmwQEycJCihYHmEPzsqaR+BBuHIlTkxtV
	kcek2vXYY/tdCO0nhYdez491N22dMocbOwqUpQuAaNLeOgoaALEvXM9ESxWv0LiX2DV9IXWhWqh
	mQtLrma/po02Ul8N3bwJpUbhcNNOCuriATJyi6vXIuR3dJz3fPGz+/yBH4yLLbsEmJrust77YCX
	7WOgq1txpnGpYw7hf0z+0LmBA28a99d69nL3cVUDpgcZ6z2PStssb2JcX7wb3UZMIa4WwJzl4=
X-Received: by 2002:a17:903:3810:b0:2d6:3c22:99bf with SMTP id d9443c01a7336-2db124afcefmr356207555ad.9.1788787791874;
        Mon, 07 Sep 2026 06:29:51 -0700 (PDT)
Received: from TheRealOne ([2409:40e1:48a:6453:40cf:4035:e63:363a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1499df27sm45871125ad.50.2026.09.07.06.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 06:29:51 -0700 (PDT)
From: Chandradhar Kumar <chandradhar.2003@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com,
	Chandradhar Kumar <chandradhar.2003@gmail.com>
Subject: [PATCH v3] md/raid0: validate device count before allocating devlist
Date: Mon,  7 Sep 2026 18:59:36 +0530
Message-ID: <20260907132936.6677-1-chandradhar.2003@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

create_strip_zones() allocates conf->devlist based on mddev->raid_disks
before verifying that number of devices matches raid_disks. Move the
existing device count validation before allocation to reject invalid
configurations before attempting a potentially excessive allocation.

Fixes: 078d1d8e688d ("md/raid0: use kvzalloc/kvfree for strip_zone and devlist allocations")
Reported-by: syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=a32ff75e417c0f49a8e9
Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>
---
v2 -> v3:
- Move the existing device count validation before the allocation
- Add the requested fixes tag

v1: https://lore.kernel.org/all/20260906143928.105165-1-chandradhar.2003@gmail.com/
v2: https://lore.kernel.org/all/20260906184406.2141-1-chandradhar.2003@gmail.com/

 drivers/md/raid0.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 35e103f0c2c3..453e8abda22b 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -79,7 +79,10 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	*private_conf = ERR_PTR(-ENOMEM);
 	if (!conf)
 		return -ENOMEM;
+
+	cnt = 0;
 	rdev_for_each(rdev1, mddev) {
+		cnt++;
 		pr_debug("md/raid0:%s: looking at %pg\n",
 			 mdname(mddev),
 			 rdev1->bdev);
@@ -144,6 +147,14 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	}
 
 	err = -ENOMEM;
+
+	if (cnt != mddev->raid_disks) {
+		pr_warn("md/raid0:%s: too few disks (%d of %d) - aborting!\n",
+			mdname(mddev), cnt, mddev->raid_disks);
+		err = -EINVAL;
+		goto abort;
+	}
+
 	conf->strip_zone = kvzalloc_objs(struct strip_zone, conf->nr_strip_zones);
 	if (!conf->strip_zone)
 		goto abort;
@@ -200,11 +211,6 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 			smallest = rdev1;
 		cnt++;
 	}
-	if (cnt != mddev->raid_disks) {
-		pr_warn("md/raid0:%s: too few disks (%d of %d) - aborting!\n",
-			mdname(mddev), cnt, mddev->raid_disks);
-		goto abort;
-	}
 	zone->nb_dev = cnt;
 	zone->zone_end = smallest->sectors * cnt;
 
-- 
2.55.0

