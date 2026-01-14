Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838C02DF152
	for <linux-raid@vger.kernel.org>; Wed, 14 Jan 2026 17:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410787; cv=none; b=ET+F1OaROKPbgBabRv4dUsbFIPR6SlKUZcEsPWrGFKNswItF6LYxeenCBtZtKhJC16I8CCYM5fbcA0ZMv6xu+HkAF11JI47qebIL5iVuav1wp1CyuOluWwLPPGI7oR0FLfcRPbbhw2jrD/pG2mEK3ccc2GT+hIVffjOc8ubGXCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410787; c=relaxed/simple;
	bh=Co0OfDgTUnqRyGUN5fdnNAQRmeJGYZ3vu9Tm2j2jE7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRaQF1c39rHqGSgJMCyLbTZhwC6TVE9RbxPLVdvzSNL+ZBdDxgwKJU2O+UBSI+tNkazjBanla+w0VPizoBkqSIg00wCYuvEW56+qixKT/cImrcF+P1O78te/df+wStWm0OIXbq9pcY7zD1dwQsN7UGduS4fCmH5N5yCngaKa4nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C8AC4CEF7;
	Wed, 14 Jan 2026 17:13:05 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com,
	dan.carpenter@linaro.org
Subject: [PATCH v5 06/12] md/raid5: make sure max_sectors is not less than io_opt
Date: Thu, 15 Jan 2026 01:12:34 +0800
Message-ID: <20260114171241.3043364-7-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260114171241.3043364-1-yukuai@fnnas.com>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise, even if user issue IO by io_opt, such IO will be split
by max_sectors before they are submitted to raid5. For consequence,
full stripe IO is impossible.

BTW, dm-raid5 is not affected and still have such problem.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid5.c | 38 ++++++++++++++++++++++++++++----------
 drivers/md/raid5.h |  1 +
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b250c6c9e72b..8a7fed91d46b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -777,14 +777,14 @@ struct stripe_request_ctx {
 	/* last sector in the request */
 	sector_t last_sector;
 
+	/* the request had REQ_PREFLUSH, cleared after the first stripe_head */
+	bool do_flush;
+
 	/*
 	 * bitmap to track stripe sectors that have been added to stripes
 	 * add one to account for unaligned requests
 	 */
-	DECLARE_BITMAP(sectors_to_do, RAID5_MAX_REQ_STRIPES + 1);
-
-	/* the request had REQ_PREFLUSH, cleared after the first stripe_head */
-	bool do_flush;
+	unsigned long sectors_to_do[];
 };
 
 /*
@@ -6127,7 +6127,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	bi->bi_next = NULL;
 
 	ctx = mempool_alloc(conf->ctx_pool, GFP_NOIO);
-	memset(ctx, 0, sizeof(*ctx));
+	memset(ctx, 0, conf->ctx_size);
 	ctx->first_sector = logical_sector;
 	ctx->last_sector = bio_end_sector(bi);
 	/*
@@ -7741,6 +7741,25 @@ static int only_parity(int raid_disk, int algo, int raid_disks, int max_degraded
 	return 0;
 }
 
+static int raid5_create_ctx_pool(struct r5conf *conf)
+{
+	struct stripe_request_ctx *ctx;
+	int size;
+
+	if (mddev_is_dm(conf->mddev))
+		size = BITS_TO_LONGS(RAID5_MAX_REQ_STRIPES);
+	else
+		size = BITS_TO_LONGS(
+			queue_max_hw_sectors(conf->mddev->gendisk->queue) >>
+			RAID5_STRIPE_SHIFT(conf));
+
+	conf->ctx_size = struct_size(ctx, sectors_to_do, size);
+	conf->ctx_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS,
+						     conf->ctx_size);
+
+	return conf->ctx_pool ? 0 : -ENOMEM;
+}
+
 static int raid5_set_limits(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
@@ -7797,6 +7816,8 @@ static int raid5_set_limits(struct mddev *mddev)
 	 * Limit the max sectors based on this.
 	 */
 	lim.max_hw_sectors = RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf);
+	if ((lim.max_hw_sectors << 9) < lim.io_opt)
+		lim.max_hw_sectors = lim.io_opt >> 9;
 
 	/* No restrictions on the number of segments in the request */
 	lim.max_segments = USHRT_MAX;
@@ -8069,12 +8090,9 @@ static int raid5_run(struct mddev *mddev)
 			goto abort;
 	}
 
-	conf->ctx_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS,
-					sizeof(struct stripe_request_ctx));
-	if (!conf->ctx_pool) {
-		ret = -ENOMEM;
+	ret = raid5_create_ctx_pool(conf);
+	if (ret)
 		goto abort;
-	}
 
 	ret = log_init(conf, journal_dev, raid5_has_ppl(conf));
 	if (ret)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 6e3f07119fa4..ddfe65237888 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -692,6 +692,7 @@ struct r5conf {
 	struct r5pending_data	*next_pending_data;
 
 	mempool_t		*ctx_pool;
+	int			ctx_size;
 };
 
 #if PAGE_SIZE == DEFAULT_STRIPE_SIZE
-- 
2.51.0

