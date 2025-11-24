Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512F82DECB1;
	Mon, 24 Nov 2025 06:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965938; cv=none; b=DI2cn9Iar6XhMqVt3ycd0WFN3XNs5P+K2ljm0rm73f0Op+6ekSYe6Hu9n9S/JTJHgwzqzhzFxmBU03A3qcUHlKHXrW8Icuv9FOj6KTqyhTsnlgWRCF12C3C1m0HsIqEotQ9xROcYYL1JxIVWK3Vmvn7dGlQPIiTUo09aFDegvz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965938; c=relaxed/simple;
	bh=jbhviUuKac27G7+Ew8grQNZm1HrGV6Hg6s+Gd+8qtOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQnMJXcLAbhLB9MtydX2epKCvWvSiAJAxLS3Zr0lZoPiLZfuiMsnG30YesbuJ0GB9l2VR/c8vjdRnHdyFC1aVX1XJie4U7FqzoTCg92rgcU+tjwgBM5IjqhmbePhtbc8xLExN4kqr6S8LdJ7PkxW6pRV//+fAacSqv73VaL8Ofo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB61C16AAE;
	Mon, 24 Nov 2025 06:32:16 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	filippo@debian.org,
	colyli@fnnas.com,
	yukuai@fnnas.com
Subject: [PATCH v2 05/11] md/raid5: make sure max_sectors is not less than io_opt
Date: Mon, 24 Nov 2025 14:31:57 +0800
Message-ID: <20251124063203.1692144-6-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124063203.1692144-1-yukuai@fnnas.com>
References: <20251124063203.1692144-1-yukuai@fnnas.com>
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
 drivers/md/raid5.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0080dec4a6ef..cd0eff2f69b4 100644
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
@@ -7739,6 +7739,24 @@ static int only_parity(int raid_disk, int algo, int raid_disks, int max_degraded
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
+	conf->ctx_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS,
+			struct_size(ctx, sectors_to_do, size));
+
+	return conf->ctx_pool ? 0 : -ENOMEM;
+}
+
 static int raid5_set_limits(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
@@ -7795,6 +7813,8 @@ static int raid5_set_limits(struct mddev *mddev)
 	 * Limit the max sectors based on this.
 	 */
 	lim.max_hw_sectors = RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf);
+	if ((lim.max_hw_sectors << 9) < lim.io_opt)
+		lim.max_hw_sectors = lim.io_opt >> 9;
 
 	/* No restrictions on the number of segments in the request */
 	lim.max_segments = USHRT_MAX;
@@ -8067,12 +8087,9 @@ static int raid5_run(struct mddev *mddev)
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
-- 
2.51.0

