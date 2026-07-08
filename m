Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3F33B27CD
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 10:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783505644; cv=none; b=mO6mryo2cCW49WNIMngItD8P7x701PKO6BLjvnuz0XRedq8lvYU/iPO6ewsy2IWkrR79BFTg+bkU7tDvWzs5AxLP/n4SmoRsTwiTJQsOMFwMgkdohGeQRflbKJ5EhrYAefKqb9ZTXFIkyOUcPvvyc6xw36uEGe3DjPCC3el3lQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783505644; c=relaxed/simple;
	bh=nJLpXD4Nt4IqEs7oa6d4S0K9tsfAYfHRos8vgVCZG60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3fYJpnsYIDbzPTBEVtvbYa7RHdqE0KjWXC6+pUAdNKb6ULrAL2zb6pxqgZ35Yo+C8TG1QlPkXtrRXc8ALeyLdzP831YwgBiOf8k7ApwvJ9SHYCR3s05d5Nch7SecQmN6ePLQsG9DXO97Rtoaixk6keTvFxYwbq7ZW4723SYgrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QS4Bfidn; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QS4Bfidn"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493c19bad03so4394945e9.2
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 03:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783505642; x=1784110442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+x6q3lDxsVu4a9ifMkDzEwHQ+oWg2ZZuOQpqa6vqjQM=;
        b=QS4Bfidnzr4UewoP8gXjAdOV3bRg9OfZfZMaV/wwOqDc3uNjEq/EnIh7R8b+7UJies
         5qGHVXHDA+cvnyCTMSXZuAi1qYjjoFMURZ0W8eOnMjgeq9JeGlbeWt10WrvwjbF1udDw
         AeKBtlhCWaKTnFIhNTehJFJnIM3Wa2zfV3jfc0psluHFLaEgspV5kv6BAfVU/g+g6gC2
         CRuAIiZ/JHK+ZXuxCjvdeFqJSbcTf2tQ84oc2J56mWa3YvTrHvGxx7xRNHf2zmjDmndj
         pd9bcd/ce1ixQoUW1rZkWokm8GC94quZfqMrZ8Ji6sNp/KbLuzqq6aS0itr2RC4JRWeZ
         h2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783505642; x=1784110442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+x6q3lDxsVu4a9ifMkDzEwHQ+oWg2ZZuOQpqa6vqjQM=;
        b=s8KIN5pHKfkRCq0HGVAyATdfjPbkl9qlj3j3iVrwtNrcYcXekp19lfG7+2f3fBKwhA
         FK62BtFLgIzpblLHtWNeaMO0Fj0I/2OIeI4+0c9gDFsdidUGxdzeOtiPVyV5Lm+MrW9v
         /oIy0pVj46eXZfsjsheIGTlunFj6/U5oGDBqBnUMuqjB2hEiARhJIgW/gol4+MsL69/p
         ZCf6Ky81ji7BsUhPJ3Yvqa/wBgaW6Xt8Az19bwHnHfmleOC1zbBjUUUKz4Solfkx/Dvh
         EAe9dQOKn/4pq3Ru2N5lRL9k+HagmNnt92TBE5lqGy+fvjZnEttLNkcbSbRKbjJnB+S2
         SPLg==
X-Gm-Message-State: AOJu0Yw/v8seiS97UZTxS7KSIbl6tZ/VhTKcMDWN3OQCqBbemVglx/a0
	CzAcy/HftTXFittTWExTABtIsPUR7GEcWJiHdfmmUZTIcAif2RKOVNU2
X-Gm-Gg: AfdE7cm88DutYOR0rvQiPCXmfgbQu52h3yjBIsACy4A1UPsqPFYu2pdKQN5/x6mqVe3
	4utKLESZp6UfH6z/VFaaflHTAGUjAXzx2a+l/C+npIvqyQne3HQ9k4h6PElM3hcZfw45l6ZCeu9
	evUlkmrUOocXhBu4D0ml4QXDPHpchk6PAaQRzhE5INt6DDbbrBpNSZ3rcgyNEk5AvtLYmE7/F/l
	fqjydrt36FeBS0gFEatYH0XIq+aEBrI34mrLCfk+jDhvfbOag3mEFT/4SYkCjeW1chSMXYm9Tt9
	GbSG9E+NkFsylut5EvN+S0WeEXgpz9tGJRqmKCGLon41Zffg1mq2NlRdLRcf1HOiwgr8DHkp5MN
	6tuEqd6PPUJbbbpU5rggeFcirI+NiIoHKL7lTvfcTdQ1UHgoAXO3PEq2LMSfriPJexoDOBHIB1E
	39RhJudVnp
X-Received: by 2002:a05:600c:8b8a:b0:492:e5a5:5a46 with SMTP id 5b1f17b1804b1-493e6875f48mr18618465e9.35.1783505641499;
        Wed, 08 Jul 2026 03:14:01 -0700 (PDT)
Received: from yocto.. ([195.72.110.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0faee30sm108987515e9.10.2026.07.08.03.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 03:14:01 -0700 (PDT)
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
Subject: [PATCH v3 6/7] md/raid10: simplify write request error handling
Date: Wed,  8 Jul 2026 10:13:40 +0000
Message-ID: <20260708101341.473750-7-abd.masalkhi@gmail.com>
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

