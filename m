Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4988530DD24
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 04:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768192165; cv=none; b=DVL0HgPLOPwzTUJ9C/V9rrmdaiwaa7t/GsRElsK52Dru3gscjGAS0/LV76n68kaqPm0s2VuI//+KUHDujGXEqsulOtIeT+ogWNo5x/rnf+tJ1KeoLdfLNT7WSuve8l5JrtQtz25HeAqjji0NdXfxt3cqeML2Keuuvh4gicsVjXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768192165; c=relaxed/simple;
	bh=DjIPsJZiQbbsRWsaZu+wny5mcDxadNnOrNR3uOKhMrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkE2OI+bz9sGYHE8Gc1b+Oo5qmL1XqoJqENxG/58C2UOqDWkPNqRvHg1Ueu0tkXMMCGbl0a8lBgI0PkT9hJnGmq169xf3o5A9s9+qBDiAimjNdNK802ygLulU3cTMNxu9vArPPwoW/CXqAO2x+9kZlsJZMkusDnxoGczaBIYUsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3E3C19423;
	Mon, 12 Jan 2026 04:29:22 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org,
	linan122@huawei.com
Cc: yukuai@fnnas.com
Subject: [PATCH v4 05/11] md/raid5: make sure max_sectors is not less than io_opt
Date: Mon, 12 Jan 2026 12:28:51 +0800
Message-ID: <20260112042857.2334264-6-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112042857.2334264-1-yukuai@fnnas.com>
References: <20260112042857.2334264-1-yukuai@fnnas.com>
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

Link: https://lore.kernel.org/linux-raid/20260103154543.832844-6-yukuai@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid5.c | 38 ++++++++++++++++++++++++++++----------
 drivers/md/raid5.h |  1 +
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e92514c91305..af48ad2bc723 100644
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
 
 	if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
 		goto abort;
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

