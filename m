Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AC03B38AB
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 07:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782199515; cv=none; b=D+DtZTq8+zv1tVtth7ibTnn/Z1TI9hTTcsXgq3hes6dwgqq4FXX28ssyklL/H6YVpgcbFLM1PuW3VLwc7WEVCM9KNUiCOmhpM12smI8e82yhQVtuQF8npyvyB40CrwHFSEERt3k9ts+aff9WWTXpnTLv1x+MhF7ivZJrqVhmA/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782199515; c=relaxed/simple;
	bh=cMD7CwRha9EWpu+yeaQeXy5dcnDS7C53iJyxbBPga7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAeMFLT1bp+is7ciocy/mOoO07kp4E0xUeNWinZj5Fa3TRAm5NIrObgXYmZK93qNram21PraZMWlS1WXm45IRgeeDUw525Pu7hIukU2IIies0EP608L+IpVp2NDFzU9GQHl8gydbrpIK2uuwdRKPzez5X/asiUdgkEx3+2DdyJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f9xPl+js; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f9xPl+js"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45eea68dd6fso2611205f8f.2
        for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 00:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782199513; x=1782804313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DO/jEgLZdnSSPkkW25s+Gwjm6CLT8gH4ka2vJ4o76lw=;
        b=f9xPl+js+TWziRGjyXzXKqwDo5PWk0PItcIx2JWtrCM3zBxfjHsBhoxadM6WJWkHDK
         e9+/d9G1t9bPsUZnWgjp1Pkq2AVBh4GQiDBoZ+pA7w8gv1fW7gfhBEmhuQjcQ20iM45n
         jBRzJByi/1f6S8U/XNN7CFtlFBwtxgGcc8QwM9hZQ7x8oBYrm7UYTWD4g9BSYt5HF6Cd
         mbHq0xqUl2zglLojCuxcvgT8pfkMBm6ZTdVNDleUZbIQoyLf9fjsn5CT3XkhYEzhIBl3
         Etkhe4453Tsy6SMQtPxV+CTdADgwom8JxbiVD9vHZPizeuVa5hwxGzrcRJbqzJ9C7vlm
         kjog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782199513; x=1782804313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DO/jEgLZdnSSPkkW25s+Gwjm6CLT8gH4ka2vJ4o76lw=;
        b=U5TJEfIVCGFfDCawiyV4YOn9LN1chz8TOMDId25hYcNl8NKqTYCPw0pdQCDxnvp8sQ
         WKRrA/u1CW3KSFfjFbEaT9FrxdflhXH0IX8ZqC1CHi8z4Bk+ZPLrW4gHPnauPh/dLYk7
         fDhhiEsPrpKs6YBdnYPunNmk2/cRK0VJjIaYDDC5p0Q+cXUavuW/3KgteOniP9EQ8t5w
         +Unmrm/6V8NUL3lK0Mz9whSzBqlpHnaMHPPV+H5NKoZLEgt1iLxMAm+s+D137rmnildf
         TPmzPOYrciCqia8MFtnsn2RkXE8EtoR0wbutPyLrlYOqQD3tPOySLMM5jdFJHDZfQt7+
         na8w==
X-Gm-Message-State: AOJu0Ywzv2OMa1SBrP5Mwgt7hhpJuoWRv8R9DBdvZgPgWRQgriFPxXXb
	uBKFTEUJstxQ98Z5gbXUqaXL/sjVYwT+pJuHDzu37boJvnOibacJjGhuPRtbPQ==
X-Gm-Gg: AfdE7ckETZ4ADYnwhV9wI/CuDayRGCYyebv/9QgeGL9819cWxAl7jhq/OWSgWEJN1ic
	S5NYyou16pQDJGCTuWTgQN4/Y5OMpdRAKwN+BLyR83mHPJ96b+rHt+I5zg2h2gNQZzY5ipwj0ya
	1D35eqjbzTnkBhLRq2QiRZTAgrpnuJYVI8PNpiSR2TpgSRCXRI0WBFE5aPdxnRDiaZoH4GF/nUO
	v9vM+3CEa2IexF4vr5TMYJXnGr+y6NEDCOyEJHFZpFRMocz6xh4ArQAgaiNb8fSDj6ieyQY4CEz
	Yqo4tQIBPyp09r+BCz2qS4EQBMovWhKUkWH95etEmJJQk5b8mXJRwZI+/v1cNIZRIYzwbF44Wzi
	cUmOeSOF6rkEYYAGKSmHyF+ZsdRLIAaH2HaH/c9oxOk97tc7BjV+OOWuG4C2xVZ/kORKWIZpV5F
	xilN1eSP5KDHZwMQL64Bw6kRh4SLr+lc4lUCk6cR69T2w=
X-Received: by 2002:a05:6000:1848:b0:461:a169:f757 with SMTP id ffacd0b85a97d-46ad95c1b47mr2149487f8f.16.1782199511710;
        Tue, 23 Jun 2026 00:25:11 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de ([141.2.113.173])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666c57afasm34278743f8f.29.2026.06.23.00.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 00:25:11 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	abd.masalkhi@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] md/raid10: simplify write request error handling
Date: Tue, 23 Jun 2026 07:24:55 +0000
Message-ID: <20260623072456.333437-7-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623072456.333437-1-abd.masalkhi@gmail.com>
References: <20260623072456.333437-1-abd.masalkhi@gmail.com>
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
 drivers/md/raid10.c | 61 +++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7085fd97b98a..2de898733337 100644
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
@@ -1354,13 +1353,12 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 {
 	struct r10conf *conf = mddev->private;
 	int i, k;
-	sector_t sectors;
-	int max_sectors;
+	int max_sectors = r10_bio->sectors;
+	bool nowait = bio->bi_opf & REQ_NOWAIT;
 	bool atomic = bio->bi_opf & REQ_ATOMIC;
 
-	if (atomic && r10_bio->sectors != bio_sectors(bio)) {
+	if (atomic && max_sectors != bio_sectors(bio)) {
 		bio_endio_status(bio, BLK_STS_INVAL);
-		free_r10bio(r10_bio);
 		return false;
 	}
 
@@ -1369,9 +1367,8 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 						bio->bi_iter.bi_sector,
 						bio_end_sector(bio)))) {
 		/* Bail out if REQ_NOWAIT is set for the bio */
-		if (bio->bi_opf & REQ_NOWAIT) {
+		if (nowait) {
 			bio_wouldblock_error(bio);
-			free_r10bio(r10_bio);
 			return false;
 		}
 
@@ -1381,28 +1378,25 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
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
@@ -1427,8 +1421,6 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 	wait_blocked_dev(mddev, r10_bio);
 
-	max_sectors = r10_bio->sectors;
-
 	for (i = 0;  i < conf->copies; i++) {
 		int d = r10_bio->devs[i].devnum;
 		struct md_rdev *rdev, *rrdev;
@@ -1485,15 +1477,15 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
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
@@ -1511,7 +1503,7 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 	one_write_done(r10_bio);
 	return true;
 
-err_handle:
+err_dec_pending:
 	for (k = 0;  k < i; k++) {
 		int d = r10_bio->devs[k].devnum;
 		struct md_rdev *rdev = conf->mirrors[d].rdev;
@@ -1527,7 +1519,9 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		}
 	}
 
-	raid_end_bio_io(r10_bio);
+err_allow_barrier:
+	allow_barrier(conf);
+
 	return false;
 }
 
@@ -1552,8 +1546,11 @@ static bool __make_request(struct mddev *mddev, struct bio *bio, int sectors)
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

