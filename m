Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1D7397B12
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 10:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783505632; cv=none; b=UG4/IckPV5WPTmLSSYbnS13Pui114Em6tS0YsShBZqdUUzzn7H2ZZZwoiuNCyCpjoV66NT9tMYnlNjVsnYO973RP9wlk13qF2zrTEn5lZBPWgyMC2ziiF0YWf5dZ1yuKHUQAUKl498E68/qbQJXzBKke2+tihhHYPbVH1mi5DG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783505632; c=relaxed/simple;
	bh=4jsTZuqLfJLYxnxU/BWs6X9xcfDbCFZVPKoRhtChmzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CirdEhwtdqR1HbNfLWF0S/ZLV2JUbqpkzHDkUBeDvxDZMCx1W0mr8BP8n3O2evvgJElB6DNfgrnpF5sCqWhXaQO2L4L5oBcUdTrWf89qBqz8q+rOykKNxFpcBdiE/wd6+DC4Nk+zCV9W/g6ii6VJ6jg01LZX4EriTx9tFydqjfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pepa+lGT; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pepa+lGT"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493c00f74baso3199295e9.0
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 03:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783505629; x=1784110429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rivHAejIFpXozS71KjVLcx8MNt/JNFJYGZtaJWAOdyk=;
        b=pepa+lGTgQ3Desc3YXO0o8XcK+IjLRmOY/z3GSF1IsfhjGANpYgOOs+2qmEY76ETrV
         hPdrlcujceTZKoNr9NSb7FQU/DMkBMcWGW1peoBbsRI8sP+vD+qd4SjsehXyVja4GH1y
         hfz+7ojc+Omv+qyH9254qa+1P2QpS2FQtT68Nv5Y3FEEAm/RZEFrktnlf0SZJvkWTZQH
         Zl9Iz75GVNT7Anoq0X0+7VNCWMbNqeqXZfF00z//raQW9/f1+CuhsApHvITUqIbr11TA
         K3kIx74LprbBT4nRprBcuyB2tmCN9gWiS1li/ptk+BKV9xGUUx6Kfdn7gEXAEaGa3/0y
         3Mzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783505629; x=1784110429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rivHAejIFpXozS71KjVLcx8MNt/JNFJYGZtaJWAOdyk=;
        b=R520Mv006YeWGZ+lNfZPG+QunVVn3UGLTP9XgC/0mvlGeWF46BUTGuGLcXkpAR1HN6
         Y4hiCCE7N9B3BDRYyukL7N0erC9n+v8eDoZkar7d261VsspESh4szCAIhddRDDF76v9A
         PuNa0h3X0AY45HDwvcUzdoEEz+enrO+2Ctns3hIsjLShnzjJbea3ODAfYpRvX3czi4qV
         zVYi64iaglZF3MWd8sGeOPRhZf4q4dK5gTRvORnhgK5p1hquiwVfwCLn9xjwpSG3sAut
         Z/e0YIJeQmjkLjxaTfD9vOJ2vI1I4wv+AFr0tO0rJN7fRpYhoCv0IdEum8f/mgjIVLNC
         6b2A==
X-Gm-Message-State: AOJu0Yw7ZiqPtp2d4yyqEpkiayJM8kymLP4l84rw5Fu0YgfCSAl57End
	iV8WbhALdreeDJKoWanVR9+F0IQaXJyTY6TpANspzySi/P2pG+sFfR7F
X-Gm-Gg: AfdE7ck8YqMPwDAwRl6xestdyboBJ69unR14W/aixaAjVAHIxCFqha3k05GL9mGn5gK
	wNUMObIRygNl4Zs/MQBW+ifqJyrIk1kBl19qp+YaLIhAJ8uxShhiRNXNoA3dCESoXCyrcxg5Ckl
	g4MTux6TIZjhvj2UdGLjNcnmoWFVFPzlhZA4vxPSdRHH8NP5WLM8fik3CPrO3/3DKv068RDypJ2
	7fjdK0BbJ9NIiCPz0LaU3gi8tWh/MwsYXpJ4QIvvEUBEFQweY54YileVV1ixzg5IZakXaSRO36M
	xC6iqY6V01CMGTCGUFWao5sLIz/UC82D3hW9F8GdrVMURJk/nI+2Qzpj6xFw3sAZRmdZWNPa6sQ
	yFHjL5xC7P/3npeXum7OeWZQ6ufLlKGOloO92/hpzOikeIhHhGk02LSKG0d4r4bZeO+vn2110ea
	y41Ijtpiy3
X-Received: by 2002:a05:600c:6206:b0:493:d078:796 with SMTP id 5b1f17b1804b1-493e6a4a8a4mr16718985e9.17.1783505629225;
        Wed, 08 Jul 2026 03:13:49 -0700 (PDT)
Received: from yocto.. ([195.72.110.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0faee30sm108987515e9.10.2026.07.08.03.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 03:13:48 -0700 (PDT)
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
Subject: [PATCH v3 2/7] md/raid1: advertise atomic write limits and handle runtime constraints
Date: Wed,  8 Jul 2026 10:13:36 +0000
Message-ID: <20260708101341.473750-3-abd.masalkhi@gmail.com>
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

Atomic writes in RAID1 must fit within a single barrier unit. Set
chunk_sectors to BARRIER_UNIT_SECTOR_SIZE so that bios which would cross
a barrier-unit boundary are rejected by the block layer before reaching
MD.

A bio that passes block-layer validation may still become unserviceable
within RAID1 due to bad blocks or write-behind constraints. In the former
case, complete the bio with EIO. In the latter case, disable
write-behind rather than failing the bio with EIO.

Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error handling")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v3:
 - Set chunk_sectors to BARRIER_UNIT_SECTOR_SIZE instead of setting
   atomic_write_hw_unit_max.
 - Avoid enabling write-behind when the atomic write exceeds the
   write-behind limit.
 - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.1051027-3-abd.masalkhi@gmail.com/

Changes in v2:
 - Drop the early atomic write split check from raid1_write_request().
 - Advertise the atomic write size limit via queue limits.
 - Disable write-behind instead of failing atomic writes when the
   BIO_MAX_VECS limit is encountered.
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-3-abd.masalkhi@gmail.com/
---
 drivers/md/raid1.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index afe2ca96ad8c..6c8beca995e6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1522,6 +1522,7 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	int first_clone;
 	bool write_behind = false;
 	bool nowait = bio->bi_opf & REQ_NOWAIT;
+	bool atomic = bio->bi_opf & REQ_ATOMIC;
 	bool is_discard = op_is_discard(bio->bi_opf);
 	sector_t sector = bio->bi_iter.bi_sector;
 
@@ -1577,7 +1578,8 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 		 * write-mostly, which means we could allocate write behind
 		 * bio later.
 		 */
-		if (!is_discard && rdev && test_bit(WriteMostly, &rdev->flags))
+		if (!is_discard && rdev && test_bit(WriteMostly, &rdev->flags) &&
+		    (!atomic || max_sectors <= BIO_MAX_VECS * (PAGE_SIZE >> 9)))
 			write_behind = true;
 
 		r1_bio->bios[i] = NULL;
@@ -1603,20 +1605,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
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
@@ -1636,7 +1624,13 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (write_behind && mddev->bitmap)
 		max_sectors = min_t(int, max_sectors,
 				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
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
@@ -3228,6 +3222,7 @@ static int raid1_set_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.max_hw_wzeroes_unmap_sectors = 0;
+	lim.chunk_sectors = BARRIER_UNIT_SECTOR_SIZE;
 	lim.logical_block_size = mddev->logical_block_size;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	lim.features |= BLK_FEAT_PCI_P2PDMA;
-- 
2.43.0

