Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CA719C542;
	Mon, 23 Feb 2026 03:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771819119; cv=none; b=tod7H1v/11Jo/qYb1kOq/wBuDH9XfAsi+HO58f9G+pNxLdxwmMIc8KjViqgo4DBYdqzcxwEk7VR/nK5Vro5eRA5si3Uwc1Utywsxi4ZJjaRer7wyqnIeLmsABDWAr8R1ohBwszt2JIF3UCHxwfivn51mpEsqizDct6FE/kfnxDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771819119; c=relaxed/simple;
	bh=d1S3276YsLU0Ihw25rhDI17hDip+mbVDAhLFoYeYPrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dcnO0iHIGW+0Kw4ioRpe0tnOLX0tZUZJDLMaUNGHtsp+2Xs7dN5zH2v/escQfjfTyTx8hYATUGqBfrUo4enMOJiP2dV618q7EMurKw59jFh04M+y0ZNmBsZB1GwjHaCtXyiUJGYGWhkFgBPrjW7pEwnR04kMM3SbcvUz8HUovxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAED7C116C6;
	Mon, 23 Feb 2026 03:58:36 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: hch@infradead.org,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com
Subject: [PATCH] md/raid5: set chunk_sectors to enable full stripe I/O splitting
Date: Mon, 23 Feb 2026 11:58:34 +0800
Message-ID: <20260223035834.3132498-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set chunk_sectors to the full stripe width (io_opt) so that the block
layer splits I/O at full stripe boundaries. This ensures that large
writes are aligned to full stripes, avoiding the read-modify-write
overhead that occurs with partial stripe writes in RAID-5/6.

When chunk_sectors is set, the block layer's bio splitting logic in
get_max_io_size() uses blk_boundary_sectors_left() to limit I/O size
to the boundary. This naturally aligns split bios to full stripe
boundaries, enabling more efficient full stripe writes.

Test results with 24-disk RAID5 (chunk_size=64k):
  dd if=/dev/zero of=/dev/md0 bs=10M oflag=direct
  Before: 461 MB/s
  After:  520 MB/s  (+12.8%)

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8854e024f311..810d936560d1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7783,6 +7783,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	lim.logical_block_size = mddev->logical_block_size;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
+	lim.chunk_sectors = lim.io_opt >> 9;
 	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
 	lim.discard_granularity = stripe;
 	lim.max_write_zeroes_sectors = 0;
-- 
2.51.0

