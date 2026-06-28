Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53633ACA61
	for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 14:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782656680; cv=none; b=f76Mm5I1eFpwFMXuB7fmsQIvb3MMiwYGVXN+K/vr2dH/do08JD8Zs1fLFlZaP1alAeTa80VhrHjPvdBrPqNCwth99Zk5JaKeibbMilzKWcFLvzaG2DPA6/FDle/uemYRlXCDM4JUmFVytXWGT5iRYgi/YXx8nw7QSnn7Yw/36i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782656680; c=relaxed/simple;
	bh=sImj3XPQ2UAPTTTw20GiImsOL2sJJB74inGH054A92g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kk5EVLyaEW+oBRDb77Evf73LCI5NI0iiY8QjJhpoO0IUMoHLb+8XvJhSOZsEim2NyPta7QuFQZddYv+1qbSX5Z1fL07x8LAqniwAX5yxhcxlokTv6QxpRUbWvWi2L/uZUtpUHaeGAM4dWE4GjXEnO5+zN2mha0a49AVOaRMXoQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tdt2AvZr; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tdt2AvZr"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4926046fbc5so28245595e9.0
        for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 07:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782656676; x=1783261476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CSorEGOcaqcd2gE+IGfXa0PDT3LrWVZrTMMt67QqdjE=;
        b=Tdt2AvZrPzFTpoWNStXKdB2nykvJg7H1KxDCb0rryQhDQv8GS68Ux1oOdxXxCSG9ox
         PmPX968LM32TtE220enacc05VUdYNVn7vum3IP/wmVYjSz1sbI/9sR2ATDfAuVZkp10g
         u8x654Si91HRGgG/9UAs3e0itC7t2FKobOaGYwdN9kNdkjvKAOh2H8FGOl3ocXWcjoNh
         HeSLcei3WiECrhla7Ns+l3FTvDDLhfgHaOUWa5eI9YpxJLkxRh8dso2wLg/E/u578KqB
         ESz358YOZk9uWJ2TYN7qiOlxCefKLNZuOXdCg5Xsrm9lJ1R3Jo/aV0iCLM1PTEEdXt2l
         X8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782656676; x=1783261476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CSorEGOcaqcd2gE+IGfXa0PDT3LrWVZrTMMt67QqdjE=;
        b=q4jbKTeTDdUtwo1tE5KyBW3vlmO8XTwWxLsZn3yAhO6mOecsrhb6M4sSH/kRRNOqxE
         jNKg39lKxXcWNurLy7DNa2G2goNn1hYbMywOurbt7vz8kJjC9+rcfVIwKiw+PY+D5ZRD
         qPPvABTJJmmit9YENbYxzXeRwQ8PCMiHPWeksQJS9SfPw8rvXsueX+eSRrsLZuKJWIqn
         G3Z115N8bIcT0K/hSM5afFwNxpyim86BdK/1WFtDEa0QTKP8sVnsrEQEYLBwMa5BzfO3
         6PHmMaEB8Ty45oRzBFco3IrHMRCW2H7Mb8c8uqFrn15yywr2y4h6fyPTQizZoVR5tSn8
         K26w==
X-Gm-Message-State: AOJu0YwOnTY90rvBO2O4RTOuqz8Rt/01g/FiR44V1pAQLB8bRwc1CAH3
	TeQX1CajNXmNwj7GRzVkHDgbHFBOmIScg9UfiX/CcbfYrKgdyUGYFkms
X-Gm-Gg: AfdE7clHQ43qkIoN7pWBQ01kvkrH8mzQzvdk+otLCowuVNmZr/09E3j206LZ1ir2IaH
	eMizhBi1NNLXhc4jjAWsWdkfQ9TG7fTWRtx7yLmGNNLiJz5eE0N50DTAd5Fdv0ZZRa1EHUjLY/i
	LcUxk9lkdURxiOmSfXUlltq4m/emKHBA7p/+zcPm9cvKrsUy4/k90lZgMfJC55CCkOQbJuWzaoD
	crX49F2mKSTPNoTb71zhsZK2BXS9pDjOVYNu0uVrpZmKBkXTuYzBh/dAZ7nGa3wPPZJ/9AuLMf3
	+KXtzAIh5/Krhd6hIBraq8+28M+JZdaSsU9XLqoW2wzHiKoGkm1wxmzKW8tmmQV0E9zCBFptbj6
	ZjdP6feboGw46jGSeNh1hK60sSoFnBEwTtOKiJxwR5PHjkcyALUjIUxou5RN53ZWTOO0SGCEk6z
	Ow0OkswINeIxwx2khHC0G/O/ZkBRFHyUuvLgpV1rnJSFAYVkoVRTYH4sPCzDBmZqpw8q7uAGPRR
	kMeYWmc66Uw1IFGXQ==
X-Received: by 2002:a05:600c:c099:b0:48a:5f32:62c6 with SMTP id 5b1f17b1804b1-4925a0ea8b4mr302657155e9.11.1782656675769;
        Sun, 28 Jun 2026 07:24:35 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de (cb-8021x-nat-134-108.net.uni-frankfurt.de. [141.2.134.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4728072189asm7819927f8f.30.2026.06.28.07.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 07:24:33 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	vverma@digitalocean.com,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	abd.masalkhi@gmail.com,
	linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH v2 3/7] md/raid10: consistently fail atomic writes that require splitting
Date: Sun, 28 Jun 2026 14:24:16 +0000
Message-ID: <20260628142420.1051027-4-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
References: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RAID10 currently handles one badblock path explicitly by failing atomic
writes with EIO. However, another badblock path can also reduce the
writable range and force the bio through bio_submit_split_bioset(),
which implicitly completes the bio with EINVAL.

Fix this by handling atomic writes in the common split check. If RAID10
determines that an atomic write would require splitting, complete the
bio with EIO.

Fixes: a1d9b4fd42d9 ("md/raid10: Atomic write support")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v2:
 - Drop the early atomic write split check from raid10_write_request()
   and rely on queue limits instead.
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-4-abd.masalkhi@gmail.com/
---
 drivers/md/raid10.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index bd322eccdc3f..3480fc7907f0 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1356,6 +1356,7 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 	int i, k;
 	sector_t sectors;
 	int max_sectors;
+	bool atomic = bio->bi_opf & REQ_ATOMIC;
 
 	if ((mddev_is_clustered(mddev) &&
 	     mddev->cluster_ops->area_resyncing(mddev, WRITE,
@@ -1464,16 +1465,6 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 			if (is_bad) {
 				int good_sectors;
 
-				/*
-				 * We cannot atomically write this, so just
-				 * error in that case. It could be possible to
-				 * atomically write other mirrors, but the
-				 * complexity of supporting that is not worth
-				 * the benefit.
-				 */
-				if (bio->bi_opf & REQ_ATOMIC)
-					goto err_handle;
-
 				good_sectors = first_bad - dev_sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
@@ -1493,6 +1484,9 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		r10_bio->sectors = max_sectors;
 
 	if (r10_bio->sectors < bio_sectors(bio)) {
+		if (atomic)
+			goto err_handle;
+
 		allow_barrier(conf);
 		bio = bio_submit_split_bioset(bio, r10_bio->sectors,
 					      &conf->bio_split);
-- 
2.43.0

