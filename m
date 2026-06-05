Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAEF47B42E;
	Fri,  5 Jun 2026 07:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780644409; cv=none; b=dnLqdykoFUZp4Q1FJ5zxnSWC2XmfatgNIXNiNP+JRw/IrR3qNBns4mrngWWuw+fPGBKcjQtQres7+wlK5CoL5plQkowvbeabITt1LjNgqN94eymAf2qpKSVOrsqyvBwIQZBGfC9I7hpgTYleSd44nWMY9mEkKwoZyd14zeu6QTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780644409; c=relaxed/simple;
	bh=ZJr/oV9IjC7rsVS6EfJhpusBKrVUKqsqDwS2ICs751o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKaRqFRtu0MRgzDpQoTmKehMT/sG798eNR/zhQpb9sNAI+yY6D4jie8WIUi73IEo/feToceM7z8fILhhMjm+R0qMNPKjiAivjflxHD5+0JuH3L74jF64vUnQyMXR5mACEaFCRjW1EEXt/hZOlwN1W2K1DRrV/5I5EvYll65EwlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TUDur2ss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUDur2ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F57D1F00898;
	Fri,  5 Jun 2026 07:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780644408;
	bh=pfunqHtFp53R8SJbwTwyK3rCXBeL+8juoqAAzZooEFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TUDur2ssAs/s7YfNiStPIrwiDmT3Wuu7SF9unPo6sCLylIdBHNWZ0qrTFCFsykzBz
	 FXMVWIs5gHQt6ufcCXQmNvhnwkNYiudqbB9QQPPu2lqSwXcSRVYpmD+yU2EbuoLNS8
	 BMLmn317qG5GSMiMV3ypnMJIXMsKqKVAZlD68RyZJPpjjInlFLOeJQxcJc42mZ8U5c
	 Wxezjcs/NqHoLtnhTVx0kzGOPi0mKCSEu3KSJYg3010Somfmj1FXBM/GA0uXvo4u8Y
	 mJ2z6tNr8Wa1+HkdZRHaclOYmBKQ0HZLbwKT9M4VIB2OViUN0QSHfpFTw3kBxU8P+g
	 NDop1HaPWAhsQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] md/raid5: validate discard support at request time
Date: Fri,  5 Jun 2026 15:26:38 +0800
Message-ID: <20260605072639.2434847-3-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605072639.2434847-1-yukuai@kernel.org>
References: <20260605072639.2434847-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Raid5 used to disable discard limits when devices_handle_discard_safely
was not set or when stacked member limits could not support a full-stripe
discard. That hides discard from userspace before raid5 can decide whether
a request can be handled safely.

Follow other virtual drivers and advertise a UINT_MAX discard limit for the
md device. Cache lower discard support in r5conf when setting queue limits,
and reject unsupported discard bios before queuing stripe work.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 34 +++++++++++++++++++---------------
 drivers/md/raid5.h |  1 +
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index debf35342ae0..76e736ee48d3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1132,10 +1132,22 @@ static void defer_issue_bios(struct r5conf *conf, sector_t sector,
 	spin_unlock(&conf->pending_bios_lock);
 
 	dispatch_bio_list(&tmp);
 }
 
+static bool raid5_discard_limits(struct mddev *mddev, struct bio *bi)
+{
+	struct r5conf *conf = mddev->private;
+
+	if (!conf->raid5_discard_unsupported)
+		return true;
+
+	bi->bi_status = BLK_STS_NOTSUPP;
+	bio_endio(bi);
+	return false;
+}
+
 static void
 raid5_end_read_request(struct bio *bi);
 static void
 raid5_end_write_request(struct bio *bi);
 
@@ -5702,10 +5714,13 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 
 	if (mddev->reshape_position != MaxSector)
 		/* Skip discard while reshape is happening */
 		return;
 
+	if (!raid5_discard_limits(mddev, bi))
+		return;
+
 	stripe_sectors = conf->chunk_sectors *
 		(conf->raid_disks - conf->max_degraded);
 	first_stripe = DIV_ROUND_UP_SECTOR_T(bi->bi_iter.bi_sector,
 					     stripe_sectors);
 	last_stripe = bio_end_sector(bi);
@@ -7815,36 +7830,25 @@ static int raid5_set_limits(struct mddev *mddev)
 	mddev_stack_rdev_limits(mddev, &lim, 0);
 	rdev_for_each(rdev, mddev)
 		queue_limits_stack_bdev(&lim, rdev->bdev, rdev->new_data_offset,
 				mddev->gendisk->disk_name);
 
-	/*
-	 * Zeroing is required for discard, otherwise data could be lost.
-	 *
-	 * Consider a scenario: discard a stripe (the stripe could be
-	 * inconsistent if discard_zeroes_data is 0); write one disk of the
-	 * stripe (the stripe could be inconsistent again depending on which
-	 * disks are used to calculate parity); the disk is broken; The stripe
-	 * data of this disk is lost.
-	 *
-	 * We only allow DISCARD if the sysadmin has confirmed that only safe
-	 * devices are in use by setting a module parameter.  A better idea
-	 * might be to turn DISCARD into WRITE_ZEROES requests, as that is
-	 * required to be safe.
-	 */
 	if (!devices_handle_discard_safely ||
 	    lim.max_discard_sectors < (stripe >> 9) ||
 	    lim.discard_granularity < stripe)
-		lim.max_hw_discard_sectors = 0;
+		conf->raid5_discard_unsupported = true;
+	else
+		conf->raid5_discard_unsupported = false;
 
 	/*
 	 * Requests require having a bitmap for each stripe.
 	 * Limit the max sectors based on this.
 	 */
 	lim.max_hw_sectors = RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf);
 	if ((lim.max_hw_sectors << 9) < lim.io_opt)
 		lim.max_hw_sectors = lim.io_opt >> 9;
+	lim.max_hw_discard_sectors = UINT_MAX;
 
 	/* No restrictions on the number of segments in the request */
 	lim.max_segments = USHRT_MAX;
 
 	return queue_limits_set(mddev->gendisk->queue, &lim);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 1c7b710fc9c1..ba06cf88aa24 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -687,10 +687,11 @@ struct r5conf {
 	struct r5pending_data	*pending_data;
 	struct list_head	free_list;
 	struct list_head	pending_list;
 	int			pending_data_cnt;
 	struct r5pending_data	*next_pending_data;
+	bool			raid5_discard_unsupported;
 
 	mempool_t		*ctx_pool;
 	int			ctx_size;
 };
 
-- 
2.51.0

