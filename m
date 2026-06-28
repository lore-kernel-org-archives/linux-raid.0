Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24DF3AD514
	for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782656676; cv=none; b=U8NNIfJyNVwOUr5ogNoH6SyqvNKNpUJe8BvGYc/A9uXM5evoaiGda8fWjiCFtAO1fN1/CxkJz7L7wP1bemS6uaDxA4Itgl8M8535AHrgl/mSL7lUnd0u4lERynqKi25yWUQ4aL+MD6iAIoGDsjOVNpzJUXyzLEmQIHLOgORIAj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782656676; c=relaxed/simple;
	bh=YYu9H3eDjrKbo54QaqIHXHZepuQndsJ8ARouXQcOOno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dq0wz32yLcDdw9aYJnkKab1/codcdGJT9zCI1B8kMHCqErKBm65Q3Kk939hNlZwZJJzbkyfBMVGg2qJqFv4gp/51s7qfnsq8AEpp0SxGBWxB7mH/e+qwqBg02drUKUKHC4lIE9azlfkWE9wz/EyvWFxSutibHPy6Tb606U8xLvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eq+CRohs; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eq+CRohs"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493ad116e05so963885e9.3
        for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 07:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782656672; x=1783261472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2QUNpaCkVwKh0MPNXoCbkbU6stHOTVOVPISwfHeK/k=;
        b=Eq+CRohsyf3ZWw0C3rUfiSv3d2xpCnFt5o+Cjerb31cVyciSGhiZW9NyGVF/w+q3EJ
         IDDKI+6pK2ophciagxO8d5a/DU5mw4gTfcKAPix+Mt1n3GHi+jHgYBoAY39HheIXeEib
         9UHism3wFzEFayxxNquNCVn1DBJ9YZpMEJlwnr3nuw79xw6aSq1sjjJFCAzuSxrxXGAl
         Zb4UJhzmYoZGKnX+WRUEpkdd4W7XKO20V5CNeqvikLqey5N7fh8fAjJYah0XKosmCXa4
         808BZ38otYpuxKBGFZq/Lvjj1iuXv4raiyyr86QsTrgmXbbrOCXagtsV0bpkN/Ca9mTa
         B1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782656672; x=1783261472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N2QUNpaCkVwKh0MPNXoCbkbU6stHOTVOVPISwfHeK/k=;
        b=Qu69rMjYubNhfJpf4+xIdDkBFCKvuN0HfMVKLEjrA0b4v3yyrtoMBeWL/duF45O0Bj
         bozTAJlQZD3tQcmlRpVk5XxTRWh5uQIbrLyDo+jRzsP6PquGcQwRzbbDapgswwmtAmEH
         XGO74P0CCngFrGGyt7Jwx9NEGZnZZomAsxacRseYdPSz3XtifUsjzw98RIht5iqyLbzv
         7hn/sJ/KErBvAjh6caXLW4ozc4pF/r/Aos5kSOWJFi/q6ihCLU4bZMUB90kegCUzPnPi
         Q5skjQXw5KhQhCMxk4I87iCZ0B/nZfIrqGqSbTI2cQv3P+s4VRS4zdzAZRFxO0lBLCNK
         kA7w==
X-Gm-Message-State: AOJu0Yylti7RiclJR9laa46s+HZ2SM6XghgMGRIuDxr/Brmkz3DVrSOW
	+IOh4LE/4ilrvq6LNDMLd6LEfRcfTuIBEXdXTA1/FOCDARN6wqxSgNqy
X-Gm-Gg: AfdE7cm6kqu9MYCCCMytmBVhlUVQ3Cq5S+PyMB/Q8kFQbBmEpQG5nQxTXH2+ii//Ken
	XMvqddUDXM4m3l1h/m+5isJbpB+4UlvoVuKZn5Eryzu302hEW1LPfiVpo0qK4HuNDUS6kyK4YDI
	Bl4xqPeG25ihU0KDDAIiNDUKLV8aPcRZdwUvDaIL4DMOl8yfMRgs67rX3v6o+T8MPE5tiWRa1UW
	veHM0kvMAm9vaT1Zs/xoHIZz+XYA1KlbzUL8p9dpPpUOmbpXDo+/ErHgqiFCx/6hWSgQBO5Z7aZ
	GL+Esg2LQqRUwlEjQs2thnIk2ofE72t8hXz/wGiPHGbCjV0PzwgW4YTuRrzz5ZArQpsM/2UPJ6f
	jT6ijYc8i+xoSI4PpnaOjNtBzI2UN2V0FWWc/r+W9tm771qWX3+S4JD6wnp0cpD1ga0uw0WXw0h
	RoiUmndacDkbAyFTteSJ0MAqkwhVbCy/ee358+MAFmvgBGyQ9mzlUdN7ROdB1yJbXhdcWAE6xZ6
	c8y+ys=
X-Received: by 2002:a05:600c:3b24:b0:490:bd66:db49 with SMTP id 5b1f17b1804b1-49266850100mr215938485e9.12.1782656671994;
        Sun, 28 Jun 2026 07:24:31 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de (cb-8021x-nat-134-108.net.uni-frankfurt.de. [141.2.134.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4728072189asm7819927f8f.30.2026.06.28.07.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 07:24:30 -0700 (PDT)
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
Subject: [PATCH v2 2/7] md/raid1: advertise atomic write limits and handle runtime constraints
Date: Sun, 28 Jun 2026 14:24:15 +0000
Message-ID: <20260628142420.1051027-3-abd.masalkhi@gmail.com>
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

Atomic writes in RAID1 must fit within a single barrier unit. Advertise
this restriction through the queue limits by setting
atomic_write_hw_unit_max to BARRIER_UNIT_SECTOR_SIZE so that bios which
would cross a barrier-unit boundary are rejected by the block layer
before reaching MD.

A bio that passes block-layer validation may still become unserviceable
within RAID1 due to bad blocks or write-behind constraints. In the former
case, complete the bio with EIO. In the latter case, disable
write-behind rather than failing the bio with EIO.

Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error handling")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v2:
 - Drop the early atomic write split check from raid1_write_request().
 - Advertise the atomic write size limit via queue limits.
 - Disable write-behind instead of failing atomic writes when the
   BIO_MAX_VECS limit is encountered.
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-3-abd.masalkhi@gmail.com/
---
 drivers/md/raid1.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index afe2ca96ad8c..f322048ab3c2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1522,6 +1522,7 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	int first_clone;
 	bool write_behind = false;
 	bool nowait = bio->bi_opf & REQ_NOWAIT;
+	bool atomic = bio->bi_opf & REQ_ATOMIC;
 	bool is_discard = op_is_discard(bio->bi_opf);
 	sector_t sector = bio->bi_iter.bi_sector;
 
@@ -1603,20 +1604,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 			}
 			if (is_bad) {
 				int good_sectors;
-
-				/*
-				 * We cannot atomically write this, so just
-				 * error in that case. It could be possible to
-				 * atomically write other mirrors, but the
-				 * complexity of supporting that is not worth
-				 * the benefit.
-				 */
-				if (bio->bi_opf & REQ_ATOMIC) {
-					bio->bi_status = BLK_STS_NOTSUPP;
-					bio_endio(bio);
-					goto err_dec_pending;
-				}
-
 				good_sectors = first_bad - sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
@@ -1633,10 +1620,24 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 * at a time and thus needs a new bio that can fit the whole payload
 	 * this bio in page sized chunks.
 	 */
-	if (write_behind && mddev->bitmap)
-		max_sectors = min_t(int, max_sectors,
-				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
+	if (write_behind && mddev->bitmap) {
+		if (atomic && max_sectors > BIO_MAX_VECS * (PAGE_SIZE >> 9))
+			/*
+			 * Atomic writes cannot be split, so disable
+			 * write-behind.
+			 */
+			write_behind = false;
+		else
+			max_sectors = min_t(int, max_sectors,
+					    BIO_MAX_VECS * (PAGE_SIZE >> 9));
+	}
+
 	if (max_sectors < bio_sectors(bio)) {
+		if (atomic) {
+			bio_io_error(bio);
+			goto err_dec_pending;
+		}
+
 		bio = bio_submit_split_bioset(bio, max_sectors,
 					      &conf->bio_split);
 		if (!bio)
@@ -3229,6 +3230,7 @@ static int raid1_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = 0;
 	lim.max_hw_wzeroes_unmap_sectors = 0;
 	lim.logical_block_size = mddev->logical_block_size;
+	lim.atomic_write_hw_unit_max = BARRIER_UNIT_SECTOR_SIZE;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	lim.features |= BLK_FEAT_PCI_P2PDMA;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-- 
2.43.0

