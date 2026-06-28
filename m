Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1383B19AB
	for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 14:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782656691; cv=none; b=eFNO+jPszQ0vGrookjfTERR0ZMfz9TdZsnh+MhbdlZ3ElA0OHPO1MQIzyS72zF0DHzqSydMm7qSehYignoBzBBFDFYBvjOFgLauFCAXihwNG+rk3butB/v3JTPrMjAIxFpCNIxAb04WOC4wmuBpHk5I2UuwMjLJeq5EQWzF8aLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782656691; c=relaxed/simple;
	bh=b6aDgrCX8pmoz9TRvvc4ugYEL73Xjef/63YqctUUKAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6LwjnZ3MFF4kryvlQ495hsJrlbRfuOpWeerTjVkY1p+84ddCa+m0r9guSMiLbnNPlblkDmjDvbhtl/aaJLvzkvRmoCYV/TFgCGxEmoU0BSrxppH0cuwZEIIldsWk/eUcq/GQX1qP7GZqXSzHAbkVause7XACzHXDSOTt//FOhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bJmI1m9U; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bJmI1m9U"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-472493849a3so600066f8f.2
        for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 07:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782656686; x=1783261486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uGhkSi3JQ10+juhFvjuubJMGs96+Wl/gRahz0AqiODM=;
        b=bJmI1m9UonbJGCcIUbRmdhFyuSeEUJWmsS8IViS6Y8h2tqlS2RiIKsy6+D4WAV7RHB
         6f1praCXVm6vqSMEiN+eZd4V3YJ7Bv+UDHpsKb2WNf0No+03XXnWRajydCqRybUBepC3
         fkttYveJzyRjdhf3WiiZxic6K3JlO0Scau9x7kRohRmcXPRKv2QOYLjKvZvsF1J7VTjr
         y3sdFBmqjn3seh4yJI8sdOJB08tAGYR8PGtLIiVxMe2QOFJWcc+crT8lllvDwlKB/up0
         EiXeUwe7Uh/+bc3oemuKM08yhqKdlm8Erib5FwQkidRKWRhn5mJnhEoHo5i10KgCNRjv
         XJQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782656686; x=1783261486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uGhkSi3JQ10+juhFvjuubJMGs96+Wl/gRahz0AqiODM=;
        b=A0nAVvghzvBfpkQPA/lDN/d9RVSwEjuDyj+F1cIA5fsRmNgNmwAWhC74D3EizwsrnU
         PnKlDQwRFYUlqoAikY5GYrycrFrQMMG1psbInEScJs/Jn6EtrNoakuPeiOEq6ZYSp8qy
         pWIiLTnpz4+aPNU+fwXSzD9qiaxhC0WcgejbDPOFf9GzjhxvclL3fvjMSj7iXvFQwL7s
         aKzHepUle5kZ15au+VggP5kDqizehVtB/H7Kam9+BOey05972liJyCbE+cIb90BFvcsc
         CUzD3KdT2MQ+SNgzZGQ0acLU2oJxZ5xALwEGMxi3nNa8w3QNFhsfq2tcPUOIlGZkZEol
         w7FA==
X-Gm-Message-State: AOJu0YxeVAwcyzTmW+UReiRLspxbQtYdNVlKLWPtGynfPMkovG4wheON
	DD0AiPAQM2qvz1R3/fbyNKNU35Vry5SPDwlF8dnuSuGl5oNxxPrZ1nRd
X-Gm-Gg: AfdE7cmQIiJ8b5OuNQE8Al9mBPuhTCmwJ045Xc/OycPnTBOfbm1f22GayyB4e/yfJGd
	/nyI5RboOGMrHWhYpc3SgW7pfYcWYpL5fr0gMbPVmmEsMqgDzLNyICSBqw942VrNb6OLCZXiGeG
	0oxljZm+BWdPS1v/zWjIdM55BZd579+bqtGjtZbIjFmIdc34f5MD7xmKIcftJUkzYTOhhZg24EN
	60x+ukfPWjuLUFGr0AsOqJOVkKRMWNk6N0FtWPETPIqgUQ0VvGN9eE0zlYblYpJHocUGoy30dDO
	hCBF+wfHAhEKPH8AmJY7KqllDGN8oONBfW8l3IdEFRgyVOSMp7niE+KKLSowrQwkfL9URHQPrFZ
	K1lsUqPIW0Me5jgEAUlJy/urQi0T38JcvW9/e+nrH7L47qhYqcqlJcUuKyGf32Cx5n8dI0Wa1W/
	sKlO6Spy2+5Fe290BO+3xf6DiX2i4hqiSBXvILzld+GHh61CgPuXpzBJAimHmmydMqgkfcbPLcF
	q9FqME=
X-Received: by 2002:a5d:5f4e:0:b0:45e:f439:9def with SMTP id ffacd0b85a97d-46dbf6db396mr21988026f8f.15.1782656686379;
        Sun, 28 Jun 2026 07:24:46 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de (cb-8021x-nat-134-108.net.uni-frankfurt.de. [141.2.134.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4728072189asm7819927f8f.30.2026.06.28.07.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 07:24:45 -0700 (PDT)
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
Subject: [PATCH v2 6/7] md/raid10: simplify write request error handling
Date: Sun, 28 Jun 2026 14:24:19 +0000
Message-ID: <20260628142420.1051027-7-abd.masalkhi@gmail.com>
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

raid10_write_request() currently handles bio completion, barrier
handling, and r10_bio lifetime management in several different error
paths. This results in duplicated cleanup logic and increases the risk
of introducing bugs in future modifications.

Move bio_wouldblock_error() handling to the callers of
regular_request_wait(), consolidate the write error paths, and free
r10_bio from a single location in __make_request() when
raid10_write_request() fails.

It remove redundant local copies of r10_bio->sectors and use a single
max_sectors variable throughout the function.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v2:
 - No changes.
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-7-abd.masalkhi@gmail.com/
---
 drivers/md/raid10.c | 58 ++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 57813f249578..d94c1f28a6f6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1123,18 +1123,16 @@ static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 				 struct bio *bio, sector_t sectors)
 {
 	/* Bail out if REQ_NOWAIT is set for the bio */
-	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
-		bio_wouldblock_error(bio);
+	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT))
 		return false;
-	}
+
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    bio->bi_iter.bi_sector < conf->reshape_progress &&
 	    bio->bi_iter.bi_sector + sectors > conf->reshape_progress) {
 		allow_barrier(conf);
-		if (bio->bi_opf & REQ_NOWAIT) {
-			bio_wouldblock_error(bio);
+		if (bio->bi_opf & REQ_NOWAIT)
 			return false;
-		}
+
 		mddev_add_trace_msg(conf->mddev, "raid10 wait reshape");
 		wait_event(conf->wait_barrier,
 			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
@@ -1192,6 +1190,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
+		bio_wouldblock_error(bio);
 		free_r10bio(r10_bio);
 		return;
 	}
@@ -1354,8 +1353,8 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 {
 	struct r10conf *conf = mddev->private;
 	int i, k;
-	sector_t sectors;
-	int max_sectors;
+	int max_sectors = r10_bio->sectors;
+	bool nowait = bio->bi_opf & REQ_NOWAIT;
 	bool atomic = bio->bi_opf & REQ_ATOMIC;
 
 	if ((mddev_is_clustered(mddev) &&
@@ -1363,9 +1362,8 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 						bio->bi_iter.bi_sector,
 						bio_end_sector(bio)))) {
 		/* Bail out if REQ_NOWAIT is set for the bio */
-		if (bio->bi_opf & REQ_NOWAIT) {
+		if (nowait) {
 			bio_wouldblock_error(bio);
-			free_r10bio(r10_bio);
 			return false;
 		}
 
@@ -1375,28 +1373,25 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 								    bio_end_sector(bio)));
 	}
 
-	sectors = r10_bio->sectors;
-	if (!regular_request_wait(mddev, conf, bio, sectors)) {
-		free_r10bio(r10_bio);
+	if (!regular_request_wait(mddev, conf, bio, max_sectors)) {
+		bio_wouldblock_error(bio);
 		return false;
 	}
 
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    (mddev->reshape_backwards
 	     ? (bio->bi_iter.bi_sector < conf->reshape_safe &&
-		bio->bi_iter.bi_sector + sectors > conf->reshape_progress)
-	     : (bio->bi_iter.bi_sector + sectors > conf->reshape_safe &&
+		bio->bi_iter.bi_sector + max_sectors > conf->reshape_progress)
+	     : (bio->bi_iter.bi_sector + max_sectors > conf->reshape_safe &&
 		bio->bi_iter.bi_sector < conf->reshape_progress))) {
 		/* Need to update reshape_position in metadata */
 		mddev->reshape_position = conf->reshape_progress;
 		set_mask_bits(&mddev->sb_flags, 0,
 			      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 		md_wakeup_thread(mddev->thread);
-		if (bio->bi_opf & REQ_NOWAIT) {
-			allow_barrier(conf);
+		if (nowait) {
 			bio_wouldblock_error(bio);
-			free_r10bio(r10_bio);
-			return false;
+			goto err_allow_barrier;
 		}
 		mddev_add_trace_msg(conf->mddev,
 			"raid10 wait reshape metadata");
@@ -1421,8 +1416,6 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 	wait_blocked_dev(mddev, r10_bio);
 
-	max_sectors = r10_bio->sectors;
-
 	for (i = 0;  i < conf->copies; i++) {
 		int d = r10_bio->devs[i].devnum;
 		struct md_rdev *rdev, *rrdev;
@@ -1479,15 +1472,15 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		r10_bio->sectors = max_sectors;
 
 	if (r10_bio->sectors < bio_sectors(bio)) {
-		if (atomic)
-			goto err_handle;
+		if (atomic) {
+			bio_io_error(bio);
+			goto err_dec_pending;
+		}
 
 		bio = bio_submit_split_bioset(bio, r10_bio->sectors,
 					      &conf->bio_split);
-		if (!bio) {
-			set_bit(R10BIO_Returned, &r10_bio->state);
-			goto err_handle;
-		}
+		if (!bio)
+			goto err_dec_pending;
 
 		r10_bio->master_bio = bio;
 	}
@@ -1505,7 +1498,7 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 	one_write_done(r10_bio);
 	return true;
 
-err_handle:
+err_dec_pending:
 	for (k = 0;  k < i; k++) {
 		int d = r10_bio->devs[k].devnum;
 		struct md_rdev *rdev = conf->mirrors[d].rdev;
@@ -1521,7 +1514,9 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		}
 	}
 
-	raid_end_bio_io(r10_bio);
+err_allow_barrier:
+	allow_barrier(conf);
+
 	return false;
 }
 
@@ -1546,8 +1541,11 @@ static bool __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	ret = true;
 	if (bio_data_dir(bio) == READ)
 		raid10_read_request(mddev, bio, r10_bio);
-	else
+	else {
 		ret = raid10_write_request(mddev, bio, r10_bio);
+		if (!ret)
+			free_r10bio(r10_bio);
+	}
 
 	return ret;
 }
-- 
2.43.0

