Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE05A407569
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 10:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783678584; cv=none; b=p8VgOy1Y/IbWTT2d3bpJqZ6c/Kdw8S/7lXJgEqNGz1FrDy7c2SXrbaFnGfbxAffmv/jS8l4zIeKixnakbDZmjezxX2hMHwo9AHlHfoIRGRawu/eM+cSebyLw4utz1Hz0ZQX9RZLAb3u434h+nVzW0l+T4vfNRnikB0gQw+5yafU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783678584; c=relaxed/simple;
	bh=G+0gt2lhZ/mJikbyerKKDgjQ1BeFViDpaZ9RXk+5+PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMCi/9I3um/bLSxwSOzIEUGGovsbGyCEwbJ77pvZ0ByDdk7hXaDDRGxp64bScAXUtfi8Q81XDQ2hdLvEoJ9e754h/sxbgrEJBrz9NzlHYsqtS+7cvUsOxYUGcR6BX4FSQbonCEy6xfXGvpFNFWeRADYQ0jHMrPFTFRb7ZEVIYwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sBWp7BPo; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sBWp7BPo"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493b966dd74so2673665e9.3
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 03:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783678577; x=1784283377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LBwHL7lIBb2cw/DWoNSHlaQyMeoLrvz1sqiTNmxmOWc=;
        b=sBWp7BPoCIiP2R7S33INgL03FXItwZSNTt93GB+CdDT0FJ8jluSnZYRBgWGPgXN8Zo
         yiEhYq/BlVDzU7SkG2m2xNsi5H62CTObIhuOZL+pGerHryjovgblXt/vgU68nrGlOCnH
         GuQfVbSZAq8vsUxwBk+VKYcUIo71Ul3OxvwmtnA9gexHLTgXsieXfzaD5yuZnnEwKhhV
         sySJY9hVm9DMzWM/TkH7hUvEhsUhUJH7fAqh1mTgGcPUQQ2HyUhGVweQqsA+v/ShFdnQ
         tLpEehLD3wWmT1InMdSh+GdmHIpEK/NX5NFKQy0wnhAKQ7Kon9xlUU8guvDRilrhvM1D
         dRXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783678577; x=1784283377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LBwHL7lIBb2cw/DWoNSHlaQyMeoLrvz1sqiTNmxmOWc=;
        b=f3QLFFp1TXauN8aHo3Gy2/BK53fi3SJuqhl53UBJpJNWkJQ1MZdCg7zMI0uN+q/tDv
         OzRE0dSll+33UFsTBk3lqagHWEuG2krRXhF/LlTkLXhSw9h8dpSMRNmKtG+AdFI/S6dC
         CM6UPjaUMwPBJRCIPI6V7vSZlSwuRS869K83yPRWpIs53ie78INNnRLo4H/0bCdtLA2q
         cH3suyoRjpixkalMMAPyBcvuWjTOKguKft/X0UtN3fLniwXU/TISf8kDTHIpB5qNc0WZ
         0SfRLUqDj/b2hoKvGBGVTyobALgKWJB7YRD01D4bSLz4ScF+zwr6qb2GTTjCvcdiFvYQ
         VpJQ==
X-Gm-Message-State: AOJu0Yy59PVokhG2ZFPkXYtFnbETgQGNiw9DCAVPtu7vgcjNnH1d3jC9
	0aaJv7sv/czQ4KocJ0y7uhwrtgoukjsHQI1rfvSpKqTi7q2StUK2aNQp
X-Gm-Gg: AfdE7cnDKu/JoYZAICHcDG+byXRATvw8GHEYTHrJev5fcCJd0QbNwNg3G+j1jb2dqfq
	zaueFPVPftr1y1re7VlmBHyyTg1nbz3ui2i+MX/MgHBHv3ClzFOknGsZczUR7AKiwA+VdrxyVOH
	8JviM7pGULAxNa1BRMjSId/OY++YSMfqTwRGjZJvuxWLPr36Ajmr6cp/8V7IW9NXgN+i5D8jEd8
	dZqyGJ5Vb62eedFICmMHK1kn5fMpnX0Qp8J+pNBdnMKVqNc2zOdydaQN4YY+SkuPu6JhyVZYu8P
	1/NZXW+tKG4ToJzOer6ScJO4t6G2c6hzieK4e8yYPfaxxWw9yrLuygXAUd0Ka2uP6mUiFC2Xdtk
	VHyPIppxU4lhd7nuIAHQtfYZsCsy/tu9UAGlj+5b+OuQfoI6cyrlR+8UqIcMQxWhNCjhhQ4Vneb
	fVEkyBLkSmr7hIyjNn6gRHEeH/MDQe83uWMq0XY2Jja5jw0x88oHR/R629dgTz1eLN
X-Received: by 2002:a05:600c:4453:b0:492:3da4:81ef with SMTP id 5b1f17b1804b1-493e685ff4cmr105091945e9.18.1783678576988;
        Fri, 10 Jul 2026 03:16:16 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-199-185.176.7.pool.telefonica.de. [176.7.199.185])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm123554875e9.0.2026.07.10.03.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 03:16:16 -0700 (PDT)
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
Subject: [PATCH v4 6/7] md/raid10: simplify write request error handling
Date: Fri, 10 Jul 2026 10:15:20 +0000
Message-ID: <20260710101521.1714-7-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710101521.1714-1-abd.masalkhi@gmail.com>
References: <20260710101521.1714-1-abd.masalkhi@gmail.com>
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
Changes in v4:
 - No changes.
 - Link to v3: https://lore.kernel.org/linux-raid/20260708101341.473750-7-abd.masalkhi@gmail.com/

Changes in v3:
 - No changes.
 - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.1051027-7-abd.masalkhi@gmail.com/

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

