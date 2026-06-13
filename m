Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05BA33C1B7
	for <linux-raid@vger.kernel.org>; Sat, 13 Jun 2026 18:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781375300; cv=none; b=lCrInF++SBjGYiQr9J/LFL+LKdLfhAwgUmRfhieneKkcPyQ/CqKg7PpEU0tWfUeBq/FE1qMh2LbG3/6xLJhxyTBonfiCb2aex0WZAABdz2QCAaKWTdPqbJ/PLw2jwYwInuhNGGNHk5mJ+cTNf2yjroBoHJIjh+/k04mH8SvCt6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781375300; c=relaxed/simple;
	bh=Iry98KyDyC8KtxJqUhaic9B099C5zsdRjaP3QxGmGC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVprsJwfIKfTvxaKUK8M7/ujbhZXs0oRBkNFidvl+7+JX7D1eqwCetcMtALXewFU95kn9soLKYLphuyGeY/CHP8Whoi5QTSQJiPc0Swx8Y69AfkPHyskfRkT777+EYhak5QXZLJTZo77+k0Ip6UoQlMiuTbi9/K4BsFK3kf54dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VeAZ1Npu; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VeAZ1Npu"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so20319295e9.1
        for <linux-raid@vger.kernel.org>; Sat, 13 Jun 2026 11:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781375297; x=1781980097; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3eBIbA+kbrkR9TVIp2/xUakR3mx0QWB9AgGhOooTieo=;
        b=VeAZ1Npuh/slxhn3t4sej69qucprBg3Ola+/ABaGkfQ0njYGMze+0UNLeJUyz/qlcU
         4G94TM3QbCCnC9YM+WoBk67Zj/zJXq9HJOgZRBIliFWh/vHsK3T8wCBrNqChZnlY+YFS
         QaB/chqgB7QEkzm6gRLRyZfC4dL63hKJ91yn1wWPSh4Qp/7KCXpzDLvPf6aMzYtiD9yw
         G89ZbZTkyxfBkjTyrio+4399kxOMuVqTnymP8VwKCf4Ri5su6/1nXfAPr3D6dIP/IuDz
         GxzVHK1yP7+o2VyEV1HA67yTe/bahw8Uk1otVxga/spnrQ6i1tIwLS3sY0oy2GKmehoG
         DI3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781375297; x=1781980097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3eBIbA+kbrkR9TVIp2/xUakR3mx0QWB9AgGhOooTieo=;
        b=S/T6/vmwa85b/zYLkI6NAXuvkJ4H97MlULmd8mXZ84MS3E1PjWrD3yoV6A4Dym/JUa
         vN0dynRcyAUqXf4KLGFzewDkyt+kCXXGWaI9nFdjrH9QVpmzs+1m3rx/Luo2vLMmTGrz
         AmxZf7g8dHjXQR8zG4F7BGolpR18P1iP8MxhSpccAyp4RXT6riRRt25rMyIcuQnqDabT
         FMXALTwS1LTkMwlx/0Vv8f1LJvYC7pK63xlKTyQ+qTd5sEjGtAuCuLIKKlq2uqrl4gBu
         SkrdbTEMaEcIyKZoFzMbewsjZY+HRP4buuuPnZE+JvT8xk6AyfzrsHu+7JrMOd0BQBuZ
         CDUw==
X-Gm-Message-State: AOJu0YwbVV4FolXY9Ee67dBdNqm5cA/B93om+RBOG0s4ExDPKlGXPUvg
	sZTcbSTNxw4U/YyroVZyC7ScEOySCe/1lBhSS3PTV8Wnwggl9MtgDFdV
X-Gm-Gg: Acq92OHQJAmOp4NcngZ6o/4Ox753GkgAnLw+WC6YihYid7hni9NXN9kWiCInNc2xHOY
	2eWS4KiwUMX/EcBIAGh9N8S5K5Dq71SQdkvIrita3WOETQVMyvbN43j2r8RAXEdngxOGdCugScH
	2W/h5ulXJYWsITs1veIppucxCWdvdKHoDsbE9YbzacHjD777fFtpY9wAGe5nWrXzibebCoJFGk7
	AbjgATWo6xW7mc8bo/mPkOWegyVkBAPa3FxxeZke80Ar++WDjVF6k4ed0u5rj/J1TbMmULl0chu
	ZVbAVm7Sj6uEihnuzTWgOh1Tu/cTk46fU9lycI7EDPxzIIsmFctmi/bLkpB2oavKcXCx5mCXwT1
	xqC6n2QiUbNdUC2x9qlci4J2VYpwipo2c3xtEU8F+lu17tP9KByv2tDU0xIYgBUgi6rtRGJx3uW
	Qbs/cpTPAlmThlrwhja/MUfDDaETN7p9nRT8jmrmEGl6D6pMeCIaiqW/a1glShTFkp1nOIeoZ2F
	Rw=
X-Received: by 2002:a05:600c:2282:b0:490:c2a2:e91d with SMTP id 5b1f17b1804b1-490ec522d94mr68217925e9.35.1781375297142;
        Sat, 13 Jun 2026 11:28:17 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-197-181.176.7.pool.telefonica.de. [176.7.197.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c3782sm15353944f8f.25.2026.06.13.11.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 11:28:16 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	hare@suse.de,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	vverma@digitalocean.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH v2 1/4] md/raid1: fix writes_pending and barrier reference leaks on write failures
Date: Sat, 13 Jun 2026 18:28:07 +0000
Message-ID: <20260613182810.1317258-2-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260613182810.1317258-1-abd.masalkhi@gmail.com>
References: <20260613182810.1317258-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid1_make_request() acquires a writes_pending reference with
md_write_start() before calling raid1_write_request(). Several failure
paths in raid1_write_request() complete the bio and return without
reaching the normal write completion path, causing the corresponding
md_write_end() to be skipped.

Make raid1_write_request() return a status indicating whether the write
request was successfully queued. This allows raid1_make_request() to
call md_write_end() when raid1_write_request() fails.

Additionally, if wait_blocked_rdev() fails after wait_barrier()
succeeds, the associated barrier reference is not released.

Call allow_barrier() before returning from that path to keep the barrier
accounting balanced.

Fixes: b1a7ad8b5c4f ("md/raid1: Handle bio_split() errors")
Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
Fixes: 5aa705039c4f ("md: raid1 add nowait support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260611083514.754922-1-abd.masalkhi@gmail.com?part=1
Closes: https://sashiko.dev/#/patchset/20260611132500.763528-1-abd.masalkhi@gmail.com?part=1
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v2:
 - fix writes_pending leaks in addition to the barrier reference leak.
 - make raid1_write_request() return whether the write was successfully
   queued so raid1_make_request() can release writes_pending references
   on failure paths.
 - Link v1: https://lore.kernel.org/linux-raid/20260611132500.763528-1-abd.masalkhi@gmail.com/
---
 drivers/md/raid1.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b1ed4cc6ade4..f0e1c7125972 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1501,7 +1501,7 @@ static void raid1_start_write_behind(struct mddev *mddev, struct r1bio *r1_bio,
 
 }
 
-static void raid1_write_request(struct mddev *mddev, struct bio *bio,
+static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 				int max_write_sectors)
 {
 	struct r1conf *conf = mddev->private;
@@ -1512,6 +1512,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	int max_sectors;
 	bool write_behind = false;
 	bool is_discard = (bio_op(bio) == REQ_OP_DISCARD);
+	sector_t sector = bio->bi_iter.bi_sector;
 
 	if (mddev_is_clustered(mddev) &&
 	    mddev->cluster_ops->area_resyncing(mddev, WRITE,
@@ -1519,7 +1520,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		wait_event_idle(conf->wait_barrier,
 				!mddev->cluster_ops->area_resyncing(mddev, WRITE,
@@ -1535,12 +1536,13 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (!wait_barrier(conf, bio->bi_iter.bi_sector,
 				bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
-		return;
+		return false;
 	}
 
 	if (!wait_blocked_rdev(mddev, bio)) {
 		bio_wouldblock_error(bio);
-		return;
+		allow_barrier(conf, sector);
+		return false;
 	}
 
 	r1_bio = alloc_r1bio(mddev, bio);
@@ -1699,7 +1701,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	/* In case raid1d snuck in to freeze_array */
 	wake_up_barrier(conf);
-	return;
+	return true;
+
 err_handle:
 	for (k = 0; k < i; k++) {
 		if (r1_bio->bios[k]) {
@@ -1709,6 +1712,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	raid_end_bio_io(r1_bio);
+	return false;
 }
 
 static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
@@ -1732,8 +1736,9 @@ static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
 	if (bio_data_dir(bio) == READ)
 		raid1_read_request(mddev, bio, sectors, NULL);
 	else {
-		md_write_start(mddev,bio);
-		raid1_write_request(mddev, bio, sectors);
+		md_write_start(mddev, bio);
+		if (!raid1_write_request(mddev, bio, sectors))
+			md_write_end(mddev);
 	}
 	return true;
 }
-- 
2.43.0

