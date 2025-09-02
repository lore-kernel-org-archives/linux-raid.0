Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509802EBDFA
	for <linux-raid@vger.kernel.org>; Tue,  2 Sep 2025 09:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756806098; cv=none; b=Sx349c8sJI7VXJOEom5s44cwrx+25A0opDY4M5JLRWneZUnQcTXJeUGAXiwRmZgmxRZ4F5FU1aylEP70xYTVwtfTAhVvSq42mqwfCuX5E/ktehifxocq3xRLScPuki2/AJ0bcVt4m4SWhzyh8UItQ6yuyo5USSrBZW+YEdwLFK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756806098; c=relaxed/simple;
	bh=dLG5w4VpVLvquy1P3BMQuNkEcxoZcQiptAJg9EIi3Ak=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=TLmRJ5bQxvSEsFWhie/8kmLUshu3rAA+nKPh6UfX89Sz56EKfm3ZaHN/Hmc3cJtEkYez/ANXUB7gU5yAgEjCYgOWH3eyfIYF8mfHB6cBnm5fDPERAQ8OOdTStONR/wkyNgfPM5mgjpM/WRfPloLAksuUm8RqTMN7/XN/2lgZF24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwMMAmJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwMMAmJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AECC4CEED;
	Tue,  2 Sep 2025 09:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756806097;
	bh=dLG5w4VpVLvquy1P3BMQuNkEcxoZcQiptAJg9EIi3Ak=;
	h=From:To:Subject:Date:From;
	b=AwMMAmJi5Bd8ZVymuZAO183FI2RtbehCJxm7mCaqkajrsTjFTQvnwn3YcnFc9/crS
	 f9dvGU7206XG/dKFYV7z8EU0JC1rBG7fOmBbawQVm0MpDBuF1NGrrSV0YN18WhuOSW
	 aunbYl1DiNBkEcQlwhsClIq4ArGY8fg7fpWls8pmLRtuvIPDdSMsDOnpptkafudsW8
	 MPdQ9QfQS+4hh0UZCESJdIDSJyAR1xAXyxpV4oAd+p7+wDh9MkTCYViCEwDmMA08Mj
	 LqPqwQZuo3SUgYFyckOy+12dyfaTD78Ne1D8JLqyxUQFvxmvG1jnYumR/zOpojqi+H
	 ORiA40avNTHJg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org
Subject: [PATCH] md: Correctly disable write zeroes for raid 1, 10 and 5
Date: Tue,  2 Sep 2025 18:38:43 +0900
Message-ID: <20250902093843.187767-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid1_set_limits(), raid10_set_queue_limits() and raid5_set_limits()
set max_write_zeroes_sectors to 0 to disable write zeroes support.

However, blk_validate_limits() checks that if
max_hw_wzeroes_unmap_sectors is not zero, it must be equal to
max_write_zeroes_sectors. When creating a RAID1, RAID10 or RAID5 array
of block devices that have a non-zero max_hw_wzeroes_unmap_sectors
limit, blk_validate_limits() returns an error resulting in a failure
to start the array.

Fix this by setting max_hw_wzeroes_unmap_sectors to 0 as well in
raid1_set_limits(), raid10_set_queue_limits() and raid5_set_limits().

Fixes: 0c40d7cb5ef3 ("block: introduce max_{hw|user}_wzeroes_unmap_sectors to queue limits")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/raid1.c  | 2 ++
 drivers/md/raid10.c | 1 +
 drivers/md/raid5.c  | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 408c26398321..b366438f3c00 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3211,6 +3211,8 @@ static int raid1_set_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
+	lim.max_hw_wzeroes_unmap_sectors = 0;
+
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b60c30bfb6c7..fe3390948326 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4008,6 +4008,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
+	lim.max_hw_wzeroes_unmap_sectors = 0
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 023649fe2476..5f65dd80e2ef 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7732,6 +7732,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
 	lim.discard_granularity = stripe;
 	lim.max_write_zeroes_sectors = 0;
+	lim.max_hw_wzeroes_unmap_sectors = 0
 	mddev_stack_rdev_limits(mddev, &lim, 0);
 	rdev_for_each(rdev, mddev)
 		queue_limits_stack_bdev(&lim, rdev->bdev, rdev->new_data_offset,
-- 
2.51.0

