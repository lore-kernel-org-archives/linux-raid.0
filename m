Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231013955C6
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 10:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783505634; cv=none; b=rio7VQX1XfnwKgQvnn8MoV1xRpJKEHyu/vYBotd2bT3X22icPekC4jg+Pf16uKTg1MOe+7YZBqNjx7IGPVzHwGPNeDypN9nUJhqaVNEHWSyIXI0FOwRAe/r42FUZWYm7bKzyK61SopHKzP/LNKH8sGrY1YpKqoLLO4ZTgyK/l+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783505634; c=relaxed/simple;
	bh=mhSf1diO787IHvy/KgOdwRidnshdDQzhxOrYmB6YdGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrP3qUG4eJPCog/VcdlDdS9NEJfMa9CxyL+MSqRa+N8dzB6S/p6OF0rpPr2ECKBHkjjpPMFUVc4WfiAgfjnOJOHs+x2Yjma916ciIfXO7EyP3Ckb50MyWu89UgORmQNoxn1i0R0OSA/mI3C9PKlgCM+SCFibZrZvU6EotO7Z/8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DpNsOR73; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DpNsOR73"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493b779003fso2143935e9.3
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 03:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783505631; x=1784110431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GkymPx5dWsv7zXA1LsUKxw6gSalWwxADmMb2zMEOuyU=;
        b=DpNsOR73xva2gz0UFbAKZjwRmtT40Fkfp0hj09FSJ/+HeKb+LcN0Q/zyMkjRzy12JT
         DXnGeQL3kYR+FGAcq444iqYEqXgfujMzs3iUztFF593ZAjjW821fqfogzhCTHoF9qcEg
         eXWIs3/i/lRtwkTRf+QqFhJoRyiZoNXmaPJni426jywqJ9ryfQ4e8wF1XT/V0pe4SYd6
         w875FMxsLB42Qcgqbu55TVWeWTe0zvJW+aVgCk1wzIr0gvfheOk4tgW6MEw0YUcvTW2h
         4K73qPNEkGbi/zAW6oIsAtDjOCwrxFUQSOCdlf5U73zLeVdOGLjXLBs3Co8sluG+vbZt
         ADjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783505631; x=1784110431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GkymPx5dWsv7zXA1LsUKxw6gSalWwxADmMb2zMEOuyU=;
        b=fale+44ZYVBAyVMp0AChgoMoDYS/w5iOoJoGtNTg3e/D9mvcvnOQANZkRHxy3+65Dw
         uuQ8aaBO7ijsPl5cDuStZHnxsRu1Nh90iMYNQDCw+PizjjAKEhmjFBBLdcFi9Ev8+kKz
         +aYMnTUnriXCb+/WpsdST1mhg59o/TlTjlRNjHL2sUd2fvuMYXH3tiaHkuJ609mfp7CT
         7yEyWcqPu4Ou5J4wwu7/CefgTTKefnjGh7a/Mc+Sg959alVb1lEJfPWQ4UhVCUyKzk3S
         zHvdP7psgnrlkHyHQ4g/ug/yVR4yBNe9dX1NtTtexXamFQ/SQAocOJkdK3ucEqYdle/M
         KKLA==
X-Gm-Message-State: AOJu0Yz1o0WdrfMV79pjuJN6X6uKcvwx5BMV7c/LhyetBAUkwaI5uVqs
	YNJFEpAW5GEUt0HaZayTov5tVOQZnL4+SRbPDX09LwM/Zbms/oIDG9ol
X-Gm-Gg: AfdE7clkWsenvk7ecmyc1drMYOMWfjfLWMq3OaZPi126Afof3ZKLoZHbAaJa1PG8tGQ
	8PpS9pgAlB5te2jACzYA0UobIKh/4OiV8i11MBuxyo5+5L8Xu+4sMlmVWy/0xhAdSS+ZUASRDk+
	lgcNQa94UVj9Q/0edOOWM9ncUT9BavenPM6DOQ+2r2ccmdrgh6g5DQXv8KrhrN5cQit129rMNYb
	AaQPhKGhE5j9S+RSSdM6yRbbeY/c6dV/z19wZe0Q9t+ciijk6xdN3NLZFOrS1a7LdaIvQgD8ghD
	JSMuA0gl2GTzUrSeyMRteyPWijpwwgyEYGMt5tQX2VFXpfex5bzADGWU7ISK2hT2M9xD3UyYysK
	VSnfEd5L1fiR6EmNPQjngqNo4frVaK89Uzia4Xa9BEfpDjMpYswut1pSlMo8KZPygod8MOSp3DI
	Firh4T5kvX
X-Received: by 2002:a05:600c:828a:b0:493:bc4a:fb51 with SMTP id 5b1f17b1804b1-493e68fe2b5mr17422695e9.39.1783505631397;
        Wed, 08 Jul 2026 03:13:51 -0700 (PDT)
Received: from yocto.. ([195.72.110.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0faee30sm108987515e9.10.2026.07.08.03.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 03:13:50 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	vverma@digitalocean.com,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	abd.masalkhi@gatech.edu,
	linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v3 3/7] md/raid10: consistently fail atomic writes that require splitting
Date: Wed,  8 Jul 2026 10:13:37 +0000
Message-ID: <20260708101341.473750-4-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260708101341.473750-1-abd.masalkhi@gmail.com>
References: <20260708101341.473750-1-abd.masalkhi@gmail.com>
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
Changes in v3:
 - No changes.
 - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.1051027-4-abd.masalkhi@gmail.com/

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

