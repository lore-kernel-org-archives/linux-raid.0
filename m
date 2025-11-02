Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57EF28E00
	for <linux-raid@vger.kernel.org>; Sun,  2 Nov 2025 15:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762097172; cv=none; b=VO5CQmG5hdODpJ6fN/Hgajaf3iD+2ADXtYjEuZwNxZErKWbEcnAK3U9oACJZks1Qb3FqkoM8ItqF2tX5qIFxiPiQ27Op6TPdrbjGgKU3gT1MFUJbGWK43RMSwExDadHYRGuJ0bFT4dLT1G7uWuyFCS+/hFgUDiLS0zrX1UJmYWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762097172; c=relaxed/simple;
	bh=TM5xg7bglH2dpuu5Ugsc9jR3ADV+9opvunL9JC+du+g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kS2jhE9qOfRsQndZYpPRHjKi4Lar4mug6vrAFCnryeWDPeVXJaMNaeNXu9eyvSyyhe0qSbPJWeBooQmDgsDZFSqL1fWl0k9ocBLAO71sFkxaHub5yUMeZVGj3mUgkxxNH4mPROivISgWeU5SYy5+6F1TCmA4r0pBtPzrJt5E4bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7a23208a0c2so2939275b3a.0
        for <linux-raid@vger.kernel.org>; Sun, 02 Nov 2025 07:26:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762097169; x=1762701969;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zC2EWIFmO/b6O/9kQYZkUFIE/EFo57R2sMcA7mhMUvc=;
        b=B5SGGtFcKVs6/WZhSIHGNVIS8Xeb4uqjKiir+42Lsrgc1bfr2gzzIHnUt/23qhCKrI
         sMHG2Y6AzHZFWJoDp8R2VaD8bMfWIMKcE8iGWuCPww2vXFUCWfsb+7H3jzorAsdSxeYo
         aDDjcQgyye+HypdYGpUNopcngnOkuolmFTVeQZgSLG+LVwYrMzh8pUyr60CZotYlYAHI
         ootVdovEhkV3+AaXVY3l/Oe/W/OVFVJ1HaKE/UFw4tBiJ5YHJX/0iwEsmgeRVXkWc15F
         k7gG/I9c+vxTd/2sTyuTnK8r/0WfmqV3JH6GPLRFAt1KQAm9EVypB/E75/AuRmg5G/7d
         w3zA==
X-Gm-Message-State: AOJu0YyDn/qN7rbPQnWB3NcWIBvpNWu8415JkEkp3INTK+hTIdmCyzHP
	ry0vgjkafYh5OgvCy3fXxVqyW9NRfeCXj2wkPD54SQuyfeDM/LaQLzIQ
X-Gm-Gg: ASbGncuSRh3h3fqd3z5mLy9ybiIA6a+KwIMl6KJ7J7ZNbapWTtYpCA6jwaUUlfoPi60
	/Hyrx0Z6OXRwnavJuPrqZ9Ks9l21jLmphO2Wd8r/PvX5Sm982BjRN87sLFV2kJd+2tpPBOrcmaO
	2okqml6rqTqrz33lDE7uQilVirLL51gpQgyfX/0D63eeGE4G5+BvFwetVUlMQol5j9gRISV5y7Q
	x9mlcO3xITIdQ0mPz3oW993zHulS8mQjEugeTHKVVCht5s9mYZdKap8FHIWI2NwEUBiJIBPkyNr
	oDw0ZiZ0PrQQx9PLZZZQm7e346BUmZNAiZVmVIuQuaJs7dMBbYbElYdVRpb4szeIt9DgZRh8865
	ZpAmTPwdHBZMttwBYsdkJI7xda7YJnbKz5oCg5QkCVZzhX8jz4fvKCcslyW8AzwHldKrTXQwLmG
	PneoE1bEBT89ezRlNg
X-Google-Smtp-Source: AGHT+IHeyFe96KVSJeEapIw7VWITGx5W78yGriGCxM/XFVTKizvTQExyDBiZPO1IvRrVzFVvf1CAag==
X-Received: by 2002:aa7:88c8:0:b0:781:1e80:f0c6 with SMTP id d2e1a72fcca58-7a7790db00dmr13031370b3a.17.1762097169054;
        Sun, 02 Nov 2025 07:26:09 -0800 (PST)
Received: from localhost.localdomain ([2408:8352:470:257e:e57c:a7ee:fe27:1bfa])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7aaab2718cbsm1609822b3a.28.2025.11.02.07.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 07:26:08 -0800 (PST)
From: Huiwen He <hehuiwen@kylinos.cn>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Huiwen He <hehuiwen@kylinos.cn>
Subject: [PATCH] md/raid5: remove redundant __GFP_NOWARN
Date: Sun,  2 Nov 2025 23:25:40 +0800
Message-Id: <20251102152540.871568-1-hehuiwen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The __GFP_NOWARN flag was included in GFP_NOWAIT since commit
16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT"). So
remove the redundant __GFP_NOWARN flag.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
---
 drivers/md/raid5-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index ba768ca7f422..e29e69335c69 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -3104,7 +3104,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 		goto out_mempool;
 
 	spin_lock_init(&log->tree_lock);
-	INIT_RADIX_TREE(&log->big_stripe_tree, GFP_NOWAIT | __GFP_NOWARN);
+	INIT_RADIX_TREE(&log->big_stripe_tree, GFP_NOWAIT);
 
 	thread = md_register_thread(r5l_reclaim_thread, log->rdev->mddev,
 				    "reclaim");
-- 
2.25.1

