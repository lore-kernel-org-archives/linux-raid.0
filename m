Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5532220F32;
	Sun, 17 Aug 2025 15:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755444410; cv=none; b=sww74r3vsvX/s00Z/qRHTlcmPvzhVpyAdp+t0b9Z3bZUsiD66r1TGRSguqr0AJ7xYVMh6hdgnh0Lkt81ZZl79JI6dyUn96Mx1yT9dc0xw4wX+YkRWgwjAgBuR2MhWCihCWnUEbd5eYaQnYmLcDSKQ8u4xnghAAz4OiUBv7djYw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755444410; c=relaxed/simple;
	bh=5FojilEHVOyGFqyLozl5Yfp/KgFqqkGTgzbjJc21+Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yw2BV885rh4VxQ+HAaaIlw059WjeZPqndTkqtxqr3NgYeM4CqthK3Yd/yTHS5rbuGws0y02FGrdYeNr84IchcQjtE1kmeVdUlcjWFIYg8l2dp592JCIFGACcnc8U6kEhH+3gFZ7RWnX+Mt1OXupjAIEwS6iX35BHuXLFuOj5P50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CvM3yEW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CvM3yEW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B593C4CEEB;
	Sun, 17 Aug 2025 15:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755444410;
	bh=5FojilEHVOyGFqyLozl5Yfp/KgFqqkGTgzbjJc21+Ak=;
	h=From:To:Cc:Subject:Date:From;
	b=CvM3yEW/oGvQANsLJK8X54JoxEONAwmR55TpLoiJVZd+KDtIrQyUlMP2OHJ5zjEdp
	 ej4bUU5fDa6D9Ie4IYiBIm5K0tAixxSAKeKtICEm9HvFSSmqQt+L65YxiRIhgskhcF
	 XsGgLd46gWWN46B+4p36IqWdilo5ScRxIAfl3xD+DywHSjB00+JzyTDZeYJetzuh16
	 ghkXDEnkjd7GCPUGwZMTC3bVk0XpWANBf1rBdvmXi0QORmS0+Txgq1Wg93VzBv5GB9
	 Z3J7cNjgAiaLNs7FOqURhNBjE26RSXEKUOzmuB8CW0CQfnzVFh/kcAYDMEAUUArbBa
	 Wl8WI23YHdb3A==
From: colyli@kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	yukuai3@huawei.com,
	Coly Li <colyli@kernel.org>
Subject: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
Date: Sun, 17 Aug 2025 23:26:44 +0800
Message-ID: <20250817152645.7115-1-colyli@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@kernel.org>

This patch adds a new BLK_FLAG_STACK_IO_OPT for stack block device. If a
stack block device like md raid5 declares its io_opt when don't want
blk_stack_limits() to change it with io_opt of underlying non-stack
block devices, BLK_FLAG_STACK_IO_OPT can be set on limits.flags. Then in
blk_stack_limits(), lcm_not_zero(t->io_opt, b->io_opt) will be avoided.

For md raid5, it is necessary to keep a proper io_opt size for better
I/O thoughput.

Signed-off-by: Coly Li <colyli@kernel.org>
---
 block/blk-settings.c   | 6 +++++-
 drivers/md/raid5.c     | 1 +
 include/linux/blkdev.h | 3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 07874e9b609f..46ee538b2be9 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -782,6 +782,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		t->features &= ~BLK_FEAT_POLL;
 
 	t->flags |= (b->flags & BLK_FLAG_MISALIGNED);
+	t->flags |= (b->flags & BLK_FLAG_STACK_IO_OPT);
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_user_sectors = min_not_zero(t->max_user_sectors,
@@ -839,7 +840,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 				     b->physical_block_size);
 
 	t->io_min = max(t->io_min, b->io_min);
-	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
+	if (!t->io_opt || !(t->flags & BLK_FLAG_STACK_IO_OPT) ||
+	    (b->flags & BLK_FLAG_STACK_IO_OPT))
+		t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
+
 	t->dma_alignment = max(t->dma_alignment, b->dma_alignment);
 
 	/* Set non-power-of-2 compatible chunk_sectors boundary */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 023649fe2476..989acd8abd98 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7730,6 +7730,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
 	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
+	lim.flags |= BLK_FLAG_STACK_IO_OPT;
 	lim.discard_granularity = stripe;
 	lim.max_write_zeroes_sectors = 0;
 	mddev_stack_rdev_limits(mddev, &lim, 0);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 95886b404b16..a22c7cea9836 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -366,6 +366,9 @@ typedef unsigned int __bitwise blk_flags_t;
 /* passthrough command IO accounting */
 #define BLK_FLAG_IOSTATS_PASSTHROUGH	((__force blk_flags_t)(1u << 2))
 
+/* ignore underlying non-stack devices io_opt */
+#define BLK_FLAG_STACK_IO_OPT		((__force blk_flags_t)(1u << 3))
+
 struct queue_limits {
 	blk_features_t		features;
 	blk_flags_t		flags;
-- 
2.47.2

