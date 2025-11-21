Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7196D2F9DAF;
	Fri, 21 Nov 2025 05:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763702060; cv=none; b=pQnpmjCfJWPI+S7mEoOBcH7ZPBdFna8exfyJY4XqzwgPQMtTbhluF6rsdYL+HiEfOZHXueMMnl+4xsVwJblPazECCHEviYoTrErC0hwjH06x5NCw5qw4CZkP2sYYP44g5eV4KQdCJNXgqTRZem/85CvSXmA54HcypllwliKtvaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763702060; c=relaxed/simple;
	bh=nwstt5FK8cOHQbLFXzZIEC3THAzxt9W6UVxROLDNAco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8ecrLp+3tBdrAmm8q4ZKcogvuZqImpsSyVKi4rrgimo31Aof4id9cMAgvywmAyDSMgRPf2AS21yTlwY0YcPKkuq9Cb1PqPJfO+3C5D3cHRX5MLTjVCnGbb5NiY5l7c056zQRALdiXq1PZ8+LRBKgMuaNCiXROKj1krRbKrv8jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07BFC4CEFB;
	Fri, 21 Nov 2025 05:14:18 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan122@huawei.com,
	xni@redhat.com
Subject: [PATCH 5/7] md/raid5: align bio to io_opt
Date: Fri, 21 Nov 2025 13:14:04 +0800
Message-ID: <20251121051406.1316884-7-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251121051406.1316884-1-yukuai@fnnas.com>
References: <20251121051406.1316884-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid5 internal implementaion indicates that if write bio is aligned to
io_opt, then full stripe write will be used, which will be best for
bandwidth because there is no need to read extra data to build new
xor data.

Simple test in my VM, 32 disks raid5 with 64kb chunksize:
dd if=/dev/zero of=/dev/md0 bs=100M oflag=direct

Before this patch:  782 MB/s
With this patch:    1.1 GB/s

BTW, there are still other bottleneck related to stripe handler, and
require further optimization.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid5.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dc7bdbdb04b7..2db4e4fe913a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7806,8 +7806,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	 * Limit the max sectors based on this.
 	 */
 	lim.max_hw_sectors = RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf);
-	if ((lim.max_hw_sectors << 9) < lim.io_opt)
-		lim.max_hw_sectors = lim.io_opt >> 9;
+	md_config_align_limits(mddev, &lim);
 
 	/* No restrictions on the number of segments in the request */
 	lim.max_segments = USHRT_MAX;
-- 
2.51.0

