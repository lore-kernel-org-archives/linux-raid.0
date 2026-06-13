Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A7D30D414
	for <linux-raid@vger.kernel.org>; Sat, 13 Jun 2026 18:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781375303; cv=none; b=hKAhNUZSV+AxcTaBehN3wMp8UvTizP3bmqSPI4JGy/8bo6DUhOunKgXNQDqK1yi0zQBRiGvsf/KC6lEP15Bg3nCWMB+1e+Mze/mfznwKrxJ08iGp4Y9HEjPar1bdMBb33X2qWCMqAIq7p4ZeEdhH7BUynSdAFiGyg7rQTyzBp9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781375303; c=relaxed/simple;
	bh=SkBF8YMNSuWV2lPKUoYHaA1suoI7RtOuAdp2YZ4iv/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SO1VTK+I4NFu4VKuTiQ/kvP02EuSdpV3wnSdTqHh9gK7KYWFb+9u9Pvd+AAMoJqzOh41YUjoHdeAzhbxz/HRP6gZ58QB7hGfV9BaCSNhdELznKjv2g0eDnBb17QTbwehmeGT08wPslYAczeRXkgRarLv1g+eSGO9oCxOLwyrW40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LlFpfjoX; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LlFpfjoX"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45ef41adbc1so1507403f8f.0
        for <linux-raid@vger.kernel.org>; Sat, 13 Jun 2026 11:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781375301; x=1781980101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h5Gnibv/1ZOPx5OXJ9JNWc4fAopb5F9Aknkg5S0qDho=;
        b=LlFpfjoXkoccEqOE4cg40U2Nfxacm37nZwMiAibrz/n8SRTxxhEaGiNlXag/fyXtMU
         2BWI7BiNR4LUTdVNCDll+KyTjMaP6t5FsWfxWLZCBxhAlfwZlKgw2vw25y7tQ6jsdYFK
         JJ6fKWah4SpEEUKeVxrm276VsSZpyx+z9nmk6Sfpk4AiMHViwEWA/FV9tm4hO4Ey4Ds0
         KjWO2WiXJkDkaCykITWKVpjOp40Cmxj9OLlIs9YPU0reqQQmvTOdDJcrWlUnAEyKx5Z6
         Z/XfGxiQZSaVEr2+Y7ygTOEqV5egt9exa8Py/3OD8N2H0osSqEzlygM+B71f8WRAsR9Z
         vL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781375301; x=1781980101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h5Gnibv/1ZOPx5OXJ9JNWc4fAopb5F9Aknkg5S0qDho=;
        b=TTL1tp60kk5K4+Uwyi/hze/1ykHG3uFW0ohqW0z14RdKP79vYrFC279Kh4KpsLdeV+
         fr3S/u63rzTvcQTEPkO/jRM0iKVrJdv3BM9V5HKnojuJ48wSsGsKrfbpUvmwdhS+mQTL
         RhqVpFDh1lmDDmld9J2wGo1mr0IXhVa2xfJaUdbOP8n5Z8uCrpP568H9dnXUzxSZINQg
         E1pOEZBflTvsuo7j3JVW3xA/erLRphJTRHiY5M1mSyyZpp7xepPg63SMX8SO8geCkNph
         vtRQOYT3JC3/Qx6aNIYMa8x6cOcEZjESupMtQT8v3o8BOn6Yul9/A5v3fV/tvruBCRgu
         8rVg==
X-Gm-Message-State: AOJu0YyZE1x71NZ9Wzq82QupjpKppSOJXJnCJGYSamSsbJscEJ0TxH5L
	nZQvXWLlEQxsp8/EUfDpL8vfRmu4SEe+Jw7Kk5JNAjgZxt60utk4tnJ2
X-Gm-Gg: Acq92OE9lIs+Z2uwdvvnuMq1m+fI5F0jctD/xjrdnZ/avFkbDJ0V1MNkJ0ZX20qPWD9
	s1z8eKYJVtcdU79+IakQPWeKz6AYfgN6i6FZ8kwwKGi2n2uLSBjikgwDWsJlC9cVZHGDqHFIiH8
	tPP6UlmSsDSKwpzhNcrhu7/u29DuxMYGe74/Oyg/5Jjto6vryd4Tiyk7PAYscC6HlJk3Ok9jqZU
	jznWS0qj8VzAPf3goL5idooH8jAWGSQZms93bB8m9RB+LiYW/GxX17Rw1beshZZw2EhU9ExcPcr
	NO7BtSl7heF5vC/Mj3Dg87MY8W4vaSv9hK/1+yPI0MMIB2cYX/HMVROKHRrpclO+2k4ZiOjJWXm
	gEptiDTAARGCPwdb3CdJ8EPbEAPLfHNxEMSiPTghnfac56OvqTJamMCGYLNI+rUm/QzlXuC1muR
	KGSjqOAaGIDznHIMXVKMi4frkKvNwOugjZkiEdTsGR9t+cWlKHV2ihNnYUd6JXgWV2L5hBmTQUT
	KQ=
X-Received: by 2002:a05:6000:420e:b0:43c:f66e:f24 with SMTP id ffacd0b85a97d-4607ebf8195mr4968631f8f.35.1781375300659;
        Sat, 13 Jun 2026 11:28:20 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-197-181.176.7.pool.telefonica.de. [176.7.197.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c3782sm15353944f8f.25.2026.06.13.11.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 11:28:20 -0700 (PDT)
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
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v2 2/4] md/raid10: fix writes_pending leak on write request failures
Date: Sat, 13 Jun 2026 18:28:08 +0000
Message-ID: <20260613182810.1317258-3-abd.masalkhi@gmail.com>
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

raid10_make_request() acquires a writes_pending reference with
md_write_start() before dispatching write requests. Several failure
paths in raid10_write_request() complete the bio and return without
reaching the normal write completion path, causing the corresponding
md_write_end() to be skipped.

Make raid10_write_request() return a status indicating whether the write
request was successfully queued. This allows raid10_make_request() to
release the writes_pending reference with md_write_end() when a write
request fails.

Fixes: 4cf58d952909 ("md/raid10: Handle bio_split() errors")
Fixes: c9aa889b035f ("md: raid10 add nowait support")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v2:
 - new patch.
---
 drivers/md/raid10.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5bd7698e0a1b..5ad1b0c6207a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1349,7 +1349,7 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 	}
 }
 
-static void raid10_write_request(struct mddev *mddev, struct bio *bio,
+static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 				 struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
@@ -1365,7 +1365,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		/* Bail out if REQ_NOWAIT is set for the bio */
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		for (;;) {
 			prepare_to_wait(&conf->wait_barrier,
@@ -1381,7 +1381,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	sectors = r10_bio->sectors;
 	if (!regular_request_wait(mddev, conf, bio, sectors)) {
 		free_r10bio(r10_bio);
-		return;
+		return false;
 	}
 
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
@@ -1398,7 +1398,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		if (bio->bi_opf & REQ_NOWAIT) {
 			allow_barrier(conf);
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		mddev_add_trace_msg(conf->mddev,
 			"raid10 wait reshape metadata");
@@ -1514,7 +1514,8 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			raid10_write_one_disk(mddev, r10_bio, bio, true, i);
 	}
 	one_write_done(r10_bio);
-	return;
+	return true;
+
 err_handle:
 	for (k = 0;  k < i; k++) {
 		int d = r10_bio->devs[k].devnum;
@@ -1532,10 +1533,12 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	raid_end_bio_io(r10_bio);
+	return false;
 }
 
-static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
+static bool __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 {
+	bool ret;
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
 
@@ -1551,10 +1554,13 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
 			conf->geo.raid_disks);
 
+	ret = true;
 	if (bio_data_dir(bio) == READ)
 		raid10_read_request(mddev, bio, r10_bio);
 	else
-		raid10_write_request(mddev, bio, r10_bio);
+		ret = raid10_write_request(mddev, bio, r10_bio);
+
+	return ret;
 }
 
 static void raid_end_discard_bio(struct r10bio *r10bio)
@@ -1900,7 +1906,8 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 		sectors = chunk_sects -
 			(bio->bi_iter.bi_sector &
 			 (chunk_sects - 1));
-	__make_request(mddev, bio, sectors);
+	if (!__make_request(mddev, bio, sectors))
+		md_write_end(mddev);
 
 	/* In case raid10d snuck in to freeze_array */
 	wake_up_barrier(conf);
-- 
2.43.0

