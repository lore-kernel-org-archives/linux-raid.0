Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FC83B19DB
	for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 14:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782656694; cv=none; b=PB2OrNN0Iky/8Z8IMhkAKrSOBaYIg9VHjP8E8sYNpb2j4j/ravDrFlQjCXkrAacUgm+ugw3ZK2lqr4OPW8r/yJdXEqSAv+Ml566twlZYQuX+SfylCHophdG/0XGfnE/mzqWxBigLUHd8kwgC40mmC8fpq44X2jLywIa+fMAvgcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782656694; c=relaxed/simple;
	bh=damgrUPrUlRYtzv13gMXouOUM/tJXRIvTxFLHtNzIvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mp0XxK1XWjx+VhhCupuIaw0XMjgVYU8ROrU6Vwf1FFmEJu67yFsEdZKndyDH1wmlnjY8EEar/NXfYoj7Kf5gQJWeQV6ayw6XquMhIKaxVB7afcEK43HHNBN/GY77Yx5IbhyFZ8GEcNxVq1DlQfBn2ydtoS2DKIka8yZfe7BQ4TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VBsIdRHj; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VBsIdRHj"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4704d652e9cso685193f8f.3
        for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 07:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782656689; x=1783261489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TSnV9s3ceRawdA5nebPHNQbSIgLlGYS2gfNCHNvt52U=;
        b=VBsIdRHjhEYJNaAzkSF3VXV0dEw2Tp/VF1PWR4YNLC5D0FPE6Sd+O91v5yN9ryNNoF
         PE7nReBwiVhwIKTElDs1b3gdfFqFBcTrfDMkGnbx7efWrBznIQyGizibalPzcJjYDnHY
         aJtZxFjDB0cirb8+fVT+xnyqlpvhEYIMWpsKYaU2JzKPbfAdWgSLMyqOGY9TbVY3WUti
         1BRSQG0dYvPqYLvz7N0ctUnykaqet04QhNyZAbtW4Q5h+14hRvlZRNGsHERK2OymWLJP
         kiy3HeK0/Hk1IFu1560JnZJhwOXIGMyRjBWVYqQC4y4KlJKZHYchi/29FAP3pfcBiTOp
         rkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782656689; x=1783261489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TSnV9s3ceRawdA5nebPHNQbSIgLlGYS2gfNCHNvt52U=;
        b=XCwmgo3lbHSpdxBf+LNLnRIeuc6VV8Q9fVN65WvX9fpsVHJeXCwYchDPK/lLxmcEvx
         hw8G/F1jwatXq4Essi5P5Z5PPoxZLwXVyT3UI2mMa9t3ATI7CkJa12P0VSokb0Lalrtb
         EdvDf8X01T7LUJ5I84yO5exmz/eeJJcos75qBHDqfyWTEYiSfR4hHmta1ksm8fP/osdx
         zdn4b+qNVA4aQ2bDiNxJrGcZN5E8D14ZzL6//ljLZQY3Bi+ZuNHdaTm5gnfXeoqt7L8K
         5+nehMtXwozG8LmhwlQnXgOp1+9/knCAg91oJDQi4WEcgsS7HS5zfjNkZIgnf9XP09H8
         xlXA==
X-Gm-Message-State: AOJu0YwjXRncWpuARJ9C1CIDKMkwvst39ffsnkqQVr+BZlH58B/xIOF/
	b6QOrB3vZSXt6CISk1SeOF0bUgcPcLMduCFYQG5K1u94cdrF2kUfho1F
X-Gm-Gg: AfdE7cn5xl27B9v2iCPgCLU9PZePjq/arcPKaTLVheYPN1xGycwFvjKZ7nJfZjXj19y
	o1C/ezDUG4pdsn5cS233L5K9TSMQYBZZVqshg45GnSToCCgTqBWhzKr2WwWFsWAPR4L2cJEWG2R
	dIzbM5UXhDnkqZ/26ftK2DJsW/tcURqoPn1OJ74AkKIevNqyVaMcaIodwdcpYeA+7zz23uk+FdD
	TAS9sJZWpuiFppErhnShFF4rIh4gLlpe8i7BqWMGaQEujtxln88Kv0wNWksBwFqybJERSrZUDvC
	aCPMV0AJ2Ues8sLO6GW7pmJGt4tjgpLCFYbe+8q2p37Oq3sC9zAlXpSZeerTPfWR96uTEzD2XXb
	h5UztmSe2/LWiLhjV5WqsD+YYI4ad0HWvjBNV5Yar0PAdl7C4SR48i/y8QuwBu9nF7NNAbf58C7
	3NJPymEXyYLpBdl7PqTQFrZMg79LA8EThbg927/o1AA7r1GEsmTv9wYA5cjBvSU4VdUfE/8a06m
	BcTpJE=
X-Received: by 2002:a5d:5d0d:0:b0:470:1505:7571 with SMTP id ffacd0b85a97d-4701505771bmr9450546f8f.12.1782656688806;
        Sun, 28 Jun 2026 07:24:48 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de (cb-8021x-nat-134-108.net.uni-frankfurt.de. [141.2.134.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4728072189asm7819927f8f.30.2026.06.28.07.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 07:24:47 -0700 (PDT)
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
Subject: [PATCH v2 7/7] md/raid10: simplify read request error handling
Date: Sun, 28 Jun 2026 14:24:20 +0000
Message-ID: <20260628142420.1051027-8-abd.masalkhi@gmail.com>
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
Changes in v2:
 - Fix a compilation error (bi -> bio).
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-8-abd.masalkhi@gmail.com/
---
 drivers/md/raid10.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d94c1f28a6f6..01162c483644 100644
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
@@ -1538,14 +1541,13 @@ static bool __make_request(struct mddev *mddev, struct bio *bio, int sectors)
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
@@ -1875,6 +1877,7 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 	sector_t chunk_mask = (conf->geo.chunk_mask & conf->prev.chunk_mask);
 	int chunk_sects = chunk_mask + 1;
 	int sectors = bio_sectors(bio);
+	bool write = bio_data_dir(bio) == WRITE;
 
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
 	    && md_flush_request(mddev, bio))
@@ -1898,7 +1901,7 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 		sectors = chunk_sects -
 			(bio->bi_iter.bi_sector &
 			 (chunk_sects - 1));
-	if (!__make_request(mddev, bio, sectors))
+	if (!__make_request(mddev, bio, sectors) && write)
 		md_write_end(mddev);
 
 	/* In case raid10d snuck in to freeze_array */
@@ -2866,7 +2869,9 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 
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

