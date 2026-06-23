Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1A03CA499
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 07:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782199516; cv=none; b=f7q37I/DQFPH1WepTGpZRPdTfzrj8HmuuXAbHWeWopg73Wity6HUK29d+PZc5CEyxmIk27TuNXxXpKa1T6m05GwA/5D4Z2kQA5L1SafpZSffk95xXqKFcldAdBAOTy4LnQPOmrNFmgXz1kjsRA2bYZN+02iDqQ8+pfvqwPy4kbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782199516; c=relaxed/simple;
	bh=tQyV0nrj3s8+j1BnPIyPEtLCv9fCaRy1wgLr38xxx/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRuSpkp3v7NHC+1ebQQAd6YHqxfw88j/pYdos24001fmuTWKaZVk1brnroyOR1N/OkC+TOoCco0z97S2PqI6+0uiLY9FTkSHHUvdbapr0aKcPTLrX4AMrpGWAaZh6FYO0HdwOB+i6BaG0dgKDKQ9AZKRlIFmUAA3N9JSt6NFDUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EzTd8lAV; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EzTd8lAV"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49241a577d8so26608195e9.3
        for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 00:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782199513; x=1782804313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kwsLBPYBbmr2b6788dvgEiEi69VnVKAbLBVc15PvZxg=;
        b=EzTd8lAVWW67GM7siVBVGJbMr6fbeEhNgUuzeNVonJGLhXeLyw8M4UZnZzHjXeail8
         DWHA9dugJGF9sCvh4c1UvOU6KrYZ2PJ0TLDZ2if1kbP9lL3fcWAEHhTKVlDenaCUHDuD
         QZy9wROCpBcv0sWnxzPZEKCPXLP51mk8fmteopsaT+rtkutljw/YFJcdh0MwOaZaKbQ6
         jSSJoJbYvp1T3HIwxHyXRXaaXyFX4UUifKVbOD4CmTFpKwhC4Xk6haJBJCKqzDAIWeN5
         QSxTmgX7ZvNET6x+ZHLzwW8rDu7Vm84kmCXS7h9QWB4dkDsqdelZjhz9Kda0MMUycTTZ
         3N0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782199513; x=1782804313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kwsLBPYBbmr2b6788dvgEiEi69VnVKAbLBVc15PvZxg=;
        b=R1kh3V8OnRZ6WEZYiPGNv3AH856huoMtsgqzI0u6DIWdW6lfdKgctTNism61AkIT8S
         ezFrCgcpCNLH+pjAXoyPSMEX56oIPmULujgC7JVaQCw0nfrx7YSJaOqN5qSmjaewIEwW
         xYruZHtDafPwFZoWRuvT6iVhGtU96+nKafeCfoLUGsbJZpyAcCbWDWgRM5e9mf5VTgI4
         SR5x+ty80mJQjkSG+QDCWB3DNLfiJYKR9hTglQ+qRNaxiTEYodUxTBhTs/OpAAtU9cjL
         IvpfDo72CA7V1SbXZCPRzV7vWmtZ6MmvaRvLcRvPieQE0Q1VKyxxvlsWJWxlIJi76Wg5
         APXg==
X-Gm-Message-State: AOJu0YzeOfnLKWqyDkH5yKOtIsQKJGWXwSNUa4Gsces8L6xgQvukRY7I
	0JZ2kZfPqjtbpbfeH1TIMG1P0jhXnCQxmbQPP7qbGzTd6zHpNEKMT9ng
X-Gm-Gg: AfdE7cmfFOsDC2iBhR1vLXbmOB2L1MLYrHscdESbmRhbd19ZwVxBKfcHmMR6zGXlViG
	5cA6hO/mXY2gL8gfNzpAqOjv+lgOWAcHcNpau03lU92YD2s+3RhwSKONllV/LIuv+9hxDqRnbdw
	++5gMWrXP4EifxqHa2u7ZZAmYOXhJ6AiiVZLB6tj9hZkVtRpVpwzGY3izxamwB+nU0xLf5HFXgi
	7VAqOsCvH05KrEgq46lmYQnX7PeCFSqunW0BNo2+jLoUuH/+Mikk1uKMEhWDT913ycbmcGdMNCr
	//G8OGM5doXOEKwMWfTy89H/qR3mtWO+gnH0lkADaNC2GtTX6FBO88OEbWCR/KSMSlzztG0eIhC
	RJ3lVkbf2ebjHmbM8U57blPdxN+VYoUMdOz+XmTPn7gepOxgvefsNMF4lQSmf9j/iunHpncULIM
	rKPDta/zdE8i2rVhJnE9SbfnVjnKjSOyGKMZNuOHKg0zQ=
X-Received: by 2002:a05:600c:d4:b0:488:ac01:72de with SMTP id 5b1f17b1804b1-49240e20de0mr226862685e9.5.1782199513390;
        Tue, 23 Jun 2026 00:25:13 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de ([141.2.113.173])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666c57afasm34278743f8f.29.2026.06.23.00.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 00:25:12 -0700 (PDT)
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
Subject: [PATCH 7/7] md/raid10: simplify read request error handling
Date: Tue, 23 Jun 2026 07:24:56 +0000
Message-ID: <20260623072456.333437-8-abd.masalkhi@gmail.com>
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

raid10_read_request() currently handles bio completion, barrier
handling, and r10_bio lifetime management in several different error
paths. This results in duplicated cleanup logic and increases the risk
of introducing bugs in future modifications.

Make raid10_read_request() return a status to its callers, consolidate
the read error paths, and free r10_bio from a single location in the
callers. Since the callers allocate r10_bio, they should also be
responsible for freeing it when the request fails.

This makes the read path follow the same ownership model as the write
path and simplifies the error handling flow.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/raid10.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2de898733337..830c0fe30b96 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1143,7 +1143,7 @@ static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 	return true;
 }
 
-static void raid10_read_request(struct mddev *mddev, struct bio *bio,
+static bool raid10_read_request(struct mddev *mddev, struct bio *bio,
 				struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
@@ -1191,8 +1191,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 
 	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
 		bio_wouldblock_error(bio);
-		free_r10bio(r10_bio);
-		return;
+		return false;
 	}
 
 	rdev = read_balance(conf, r10_bio, &max_sectors);
@@ -1202,8 +1201,8 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 					    mdname(mddev), b,
 					    (unsigned long long)r10_bio->sector);
 		}
-		raid_end_bio_io(r10_bio);
-		return;
+		bio_io_error(bio);
+		goto err_allow_barrier;
 	}
 	if (err_rdev)
 		pr_err_ratelimited("md/raid10:%s: %pg: redirecting sector %llu to another mirror\n",
@@ -1215,10 +1214,8 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		bio = bio_submit_split_bioset(bio, max_sectors,
 					      &conf->bio_split);
 		wait_barrier(conf, false);
-		if (!bio) {
-			set_bit(R10BIO_Returned, &r10_bio->state);
-			goto err_handle;
-		}
+		if (!bio)
+			goto err_dec_pending;
 
 		r10_bio->master_bio = bio;
 		r10_bio->sectors = max_sectors;
@@ -1244,10 +1241,16 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_private = r10_bio;
 	mddev_trace_remap(mddev, read_bio, r10_bio->sector);
 	submit_bio_noacct(read_bio);
-	return;
-err_handle:
+
+	return true;
+
+err_dec_pending:
 	atomic_dec(&rdev->nr_pending);
-	raid_end_bio_io(r10_bio);
+
+err_allow_barrier:
+	allow_barrier(conf);
+
+	return false;
 }
 
 static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
@@ -1543,14 +1546,13 @@ static bool __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
 			conf->geo.raid_disks);
 
-	ret = true;
 	if (bio_data_dir(bio) == READ)
-		raid10_read_request(mddev, bio, r10_bio);
-	else {
+		ret = raid10_read_request(mddev, bio, r10_bio);
+	else
 		ret = raid10_write_request(mddev, bio, r10_bio);
-		if (!ret)
-			free_r10bio(r10_bio);
-	}
+
+	if (!ret)
+		free_r10bio(r10_bio);
 
 	return ret;
 }
@@ -1880,6 +1882,7 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 	sector_t chunk_mask = (conf->geo.chunk_mask & conf->prev.chunk_mask);
 	int chunk_sects = chunk_mask + 1;
 	int sectors = bio_sectors(bio);
+	bool write = bio_data_dir(bi) == WRITE;
 
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
 	    && md_flush_request(mddev, bio))
@@ -1903,7 +1906,7 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 		sectors = chunk_sects -
 			(bio->bi_iter.bi_sector &
 			 (chunk_sects - 1));
-	if (!__make_request(mddev, bio, sectors))
+	if (!__make_request(mddev, bio, sectors) && write)
 		md_write_end(mddev);
 
 	/* In case raid10d snuck in to freeze_array */
@@ -2871,7 +2874,9 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 
 	rdev_dec_pending(rdev, mddev);
 	r10_bio->state = 0;
-	raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
+	if (!raid10_read_request(mddev, r10_bio->master_bio, r10_bio))
+		free_r10bio(r10_bio);
+
 	/*
 	 * allow_barrier after re-submit to ensure no sync io
 	 * can be issued while regular io pending.
-- 
2.43.0

