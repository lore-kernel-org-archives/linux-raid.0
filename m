Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3F237B02A
	for <linux-raid@vger.kernel.org>; Thu, 23 Apr 2026 10:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776939206; cv=none; b=eVpbWMACVv8qMUIgPLGH4YLxQRRCs9IKmuy8Ve1v3GYeANfOsbdsLk2Ff74nbqa8xMNDgne/cuc9WOpfQRXu9yxMTsB0cDjJuaj9cI2J7gpI6q/yzTUzJDetRjiITRkmZJRWn+irMAT/1u+GcfoDvb/n9xdYk82O9mo8q1uDC2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776939206; c=relaxed/simple;
	bh=EZFMmfcPHnnPRRl1qIvsTma60zQYclkMF5a2PdQBHRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEI03KBolC3P0IK7NTz5xDkwnLqSqL3UL+SFamn9SqubInhcEpf6/0C1nwuzO3xN6tr+5UHr4YRL7p7fpL9B2owYXzCpjkY5fsQYGZPwkDZ3iojIieO4kjCBreS0wIOIHXoDleCsMfyszn5a+fAOb06xcieAIBFSyh7oKaWdX8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gGJFdFHJ; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gGJFdFHJ"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43fea39e066so5301645f8f.1
        for <linux-raid@vger.kernel.org>; Thu, 23 Apr 2026 03:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776939203; x=1777544003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NQFI/pBHIyp1CLRqL7clSduoa3aCGTrnoSWGD/QtaJY=;
        b=gGJFdFHJGTABVl82ALeMDHt5TxDouVE5CsmtRQflA1HEzSrUCq05/VmrZC1vJZyCGK
         yamPgjg6RDySzwN9qerkeaxO4jHc8Z51S9qFhMANYtT+XjmL9eNmu8EN5apyBMdCzydK
         xoD5tei3qrWMKOv0hQBtKLEdpzTULVSIoTON0xGJMkEnI1RqHGokLiM9vIfybHDbf10D
         v2meImDZCiAKTpdU2n3o4DBlhCNBrAR8UfnC/kKg+IKaBH50Xn5oxZ4lOSLy81SQRSYk
         eDabX4dBuvzGgSDKjtxy1F8pkrLJSVgQsnR2afUCpsJY0sPDeVP6U0Udhl75wCybblVz
         u8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776939203; x=1777544003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NQFI/pBHIyp1CLRqL7clSduoa3aCGTrnoSWGD/QtaJY=;
        b=kIw6PoyR8EuTflW7QJMD3sZopl2nIrw6LSomLIHBoH2djmS2VNkdEwR+FIvyZQaIoN
         L8gHr0rFBWNBEw19f/hmFo7gbIhwrhGgEPaDd6d0Uzv7lphn86vwyVto59uQUwOiAUve
         dVmzRgzmu1GpgW4ajmcphEgBe1KV2dW9xCC7d6RDCj0e5Uy/jispej98fkurQpiZChqm
         iPzg4CsuCw/U9k0KbgoUZB9crxswdKK71P5bwDOzJZO39UQaGilRUza9CN6XPlfscJxs
         mQqddUQ829gYfPIBVcJdST6yD/YKWr+8K4Udj8SXS7BadIPvYXXIQHV1KBmpzOUTkpeS
         9NXg==
X-Gm-Message-State: AOJu0YxLJaCQthtgniEJZ8GxT4jOCJ3jCYB1SGq4osfrPbE5Upq6a7r4
	NlX3bUEfxgsT5F531x+Iq8OugdV4eZiTkkSFpWuZetTImTWFDRsuoja6UsoPMQ==
X-Gm-Gg: AeBDiesmaPsgbytAZneIQJXqSZisvf5DqDivO4CBSeYegM04GRGKPxmDKEhwmgF2fNR
	AKQXQ60OH1kYeY+Bn8A7ve1Y+eWACBl2/nV++aq7OB9GBPJhZECVof6T+SUpj3CdOvYA/6NsKav
	SEbfKGBXPPT/ff+NCHQosx0GJ8JM1ev9Ftm1cavAx2Q+QS1TiWR4UGUVZsBJQ7jvJi7I2SMAn/O
	yPt5w4r8rzEfNOL8HMct+coL687QTuNZaY2sCATaenaBZnXsKfXWZmdAEhZ2lF6/2PynInI2+tN
	/Xe1mWbFfUdYzZeQDCDlAjmszGFsYw5mtdyJ0GCX1B7ZHRs3/z0pfaPO0sHFa1lWHoNthEHHY1b
	YYIVlI8YY6yRQ0is/CQr1Tumi4QtMgs5hsDyKZXON3zKfSa8j5gSSxqsZEUrTjRUyVrsZxNwo2Y
	M2wqqMx6++W/Wg257WkyHVespUWFiEAInK8GXHFnRoHNJw
X-Received: by 2002:a5d:5d88:0:b0:43d:73de:abd3 with SMTP id ffacd0b85a97d-43fe3e0bdd8mr40038135f8f.30.1776939203126;
        Thu, 23 Apr 2026 03:13:23 -0700 (PDT)
Received: from yocto.. ([2a02:3037:60e:ee7d:34af:34c4:890b:2c47])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4d525sm49741217f8f.31.2026.04.23.03.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 03:13:22 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 1/3] md/raid1: replace wait loop with wait_event_idle() in raid1_write_request()
Date: Thu, 23 Apr 2026 12:13:01 +0200
Message-ID: <20260423101303.48196-2-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260423101303.48196-1-abd.masalkhi@gmail.com>
References: <20260423101303.48196-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The wait loop is equivalent to wait_event_idle() and can be simplified
by usaing it for improving readability.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/raid1.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cc9914bd15c1..b549be9174bb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1488,21 +1488,14 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	    mddev->cluster_ops->area_resyncing(mddev, WRITE,
 		     bio->bi_iter.bi_sector, bio_end_sector(bio))) {
 
-		DEFINE_WAIT(w);
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
 			return;
 		}
-		for (;;) {
-			prepare_to_wait(&conf->wait_barrier,
-					&w, TASK_IDLE);
-			if (!mddev->cluster_ops->area_resyncing(mddev, WRITE,
-							bio->bi_iter.bi_sector,
-							bio_end_sector(bio)))
-				break;
-			schedule();
-		}
-		finish_wait(&conf->wait_barrier, &w);
+		wait_event_idle(conf->wait_barrier,
+				!mddev->cluster_ops->area_resyncing(mddev, WRITE,
+								    bio->bi_iter.bi_sector,
+								    bio_end_sector(bio)));
 	}
 
 	/*
-- 
2.43.0

