Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5603A3B42D0
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 10:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783678572; cv=none; b=T6SfJiuRC/lqrSjsSts7Vb46GzvnvIK7pnQVXmzFfgJmzq1prp9+y2WXAKnLw89MpEFG1ckJzdLwoOs3Daam/q8s1yss+n2yeOW8tSws41VzMpOmGnyhBNrad4vsyoNDFFxYADCanBljhGqITW7HZfiET9aCYBqw7J8hOkgigQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783678572; c=relaxed/simple;
	bh=Bfe3xB0thmKW8/yG8nKExHeAvMXcWVoeWwJ8pXNNBD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ps9PfI0ywHLL37bIe6AAoHMApSTbHmkTGVRTvdbOeRYiTFaDtUy2Kbgar0+tiAosF879hacimBdhk/zfSA3fr+rFt1FSPbqpKziwO6Fmk5otl851m1Rx3e1QMgyN4YtrOwqRShzeSoUtTaqI3CZRfKNR1RaDA4vLogKuHofHFC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kt9ORlkN; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kt9ORlkN"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4938d5f86f3so5093135e9.1
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 03:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783678568; x=1784283368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t1JCSAO04+tj+XFeggFKh3PqCgoc7uDvt/WquxeaeBY=;
        b=kt9ORlkNc1j3uUzZUJ4BE3XENOH+1ZQJiFbzkvutp/Cs1QS+a5DL60TgRBxDrRiWUw
         /SUvU9hbHctUo3m6h53BGf6DyB/BUd1q7xgBdwWIijXaiOZc1y/Z0r01iOTvGptuIvL6
         Cad3bw3CeTMNpc2qfQN3eTSU1zEPUsqXDbj7gsoYvgfo0wq7k+DhN3QK2yIPLWLJKb6g
         pxmNB4JUApE0t9NS10nXXvcp3fkwdqJG8XvEgdk45uo66WP/RbugCGtGbGY8R8ruGd+F
         /RfMy8BNyiVw6XmWAeGLYui4o1AcHvZLUVfiD1rYVkbo6I6eS2U8WbxLNFDG37huDufq
         6LWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783678568; x=1784283368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t1JCSAO04+tj+XFeggFKh3PqCgoc7uDvt/WquxeaeBY=;
        b=TJrxfaOE6RpgtAzGY4hej7RLRpx9jWK0qsagCE68on7QcEAtg2rBzI+i1xQzdrrYW2
         My3SlRvvNbX0v9xTtRtt6oklx2VyDGtknmFoKkKSac6Ve7Q4TEjf/oprJZJQrnB64iHl
         cUnzkjM0um057PZBl9DKHdKhNnTw0Xyi3OKDBt54bSiu+RwtxBu1FEYpmnHyE7msf1j4
         QEDBXIU8Myko0FP0aFvPyQ1gmhIMNLlVzxrMEydI2nABffyVSooZyhOcChR4c1GSl5eq
         T2gajpfpWA6NwEeHIVl3+l4m4MbTwSnFfIhkm+1Z9tbyG7/jkVzoZBUrANsl+AHuRVqw
         /d8w==
X-Gm-Message-State: AOJu0YyoUJhDqBIzsiLcUNLQeZjOmCG+hWQz+vQlVAHAS+xz+tN2hDZH
	92fbmCmFi+QcTceUbV7u88wlgF2pojr3ca/AvxgU+1tsbzZ7JC5onhs3
X-Gm-Gg: AfdE7clsKASyxeDcw0gTLY5aXQfVgG0BJvwMUrWF+yNVxPs/u7+aTvEX6iqTYS/RxcB
	syWEWwTOOolKdzSiPVnGaKZSqttWCFQidblkHhsgjpxcSItwZVwfwfgOXXSWnNyeZ26YkVqlsiQ
	rewmBhppZIjlZvVpZrpZQ6OlBbNfjXMlx8LNEvupi87VlvDQvJaBAYk8JpnQy6yVIPGQxme1vMs
	TevxBTfvVKYIP9xo80qnvdsgwg2PJaEIheWPzzG7JOzO6gmNjUzN5OWlF3R9CqqoCklrJ3H1tPs
	IZVlGwMTJKrqOjJOvBMupPrU40dpMhfWkSCxEbfvbSlAJuFsW0BLrndxapROA2t3mGc0LW2tLzk
	u7k6jK0+r3oypA6H/m4aqs2eJSsu24WX6ddN2eZ4wrowEUAGX9TpIVfkhyY7Wv4X4DjAVfv7Ti8
	jGWiVBlih+F44SdPjs8m7vNyTX57BvMRHshlJfpZvUR1UK4H1YpHTLw8/8NWS1vsQ8
X-Received: by 2002:a05:600c:56d3:b0:493:e2c3:af25 with SMTP id 5b1f17b1804b1-493f2b37187mr15757895e9.12.1783678566847;
        Fri, 10 Jul 2026 03:16:06 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-199-185.176.7.pool.telefonica.de. [176.7.199.185])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm123554875e9.0.2026.07.10.03.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 03:16:06 -0700 (PDT)
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
Subject: [PATCH v4 2/7] md/raid1: restrict atomic write limits and handle runtime constraints
Date: Fri, 10 Jul 2026 10:15:16 +0000
Message-ID: <20260710101521.1714-3-abd.masalkhi@gmail.com>
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

Restrict the RAID1 atomic write limits by setting chunk_sectors to
BARRIER_UNIT_SECTOR_SIZE so that atomic writes never straddle a barrier
unit.

A bio that passes block-layer validation may still become unserviceable
within RAID1 due to bad blocks or write-behind constraints. In the former
case, complete the bio with EIO. In the latter case, disable
write-behind rather than failing the bio with EIO.

Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error handling")
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v4:
 - Improve the commit message.
 - Add Reviewed-by tag from John Garry.
 - Link to v3: https://lore.kernel.org/linux-raid/20260708101341.473750-3-abd.masalkhi@gmail.com/

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

