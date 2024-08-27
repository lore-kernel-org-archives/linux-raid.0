Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0333D1C57AF
	for <linux-raid@vger.kernel.org>; Tue, 27 Aug 2024 15:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772948; cv=none; b=ugnlLvXv2p2CnYvLTAyP93Pa+Vc9XokMpQfHx0XbSPQcA3QFr/s/wmF/cnCqgnlw2lRi/AOGXIazo/qcK713c38zzFtHSxTvW/A7NI9RLoGlrs7wtRWl0d5G+PRoeLbsUDrkGFD++wRY6ZxP4n+4li9/11gXXrXevDp08lojhWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772948; c=relaxed/simple;
	bh=yD9k3I2uVZTIZt4jf56qQTEAACzIVpxxYO+VPLV9CdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6PtW/QdnW3QLkzEoD/1qWRWY9NxbqFzG3L7QnW9mM97YnQ/skPeVgQJAGellxY6yiiBlsaCV2dn66ojgFf86+qkxf+p2UUB6xpbxl+AmGzquCzBXfn6gZkepT9dg5iyBy17YrougTRQlRrqrBHNZ9SLBGjYpb99uJfTTvhSPeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kNCzb/mE; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kNCzb/mE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724772948; x=1756308948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yD9k3I2uVZTIZt4jf56qQTEAACzIVpxxYO+VPLV9CdA=;
  b=kNCzb/mExa0MpuiKy5dp5L9XhspRyV4GO4+1hKr+vDmjqDFEeENNyodL
   ilXJtpNQT9JvO5hYZk4WgI3H8jio3wUnjyG40GILUvzXr6VzbYYtcSHD1
   AD3aTRZdbjjlVDMUB57ak6tCHFG1QdXnNL8A99ckUvUk/Lhn4aeHgmKmb
   iC3j3SKHTgrpbYGCgDpIwgR5KjsU8XO8rhYNA+/khPg7l4t2w2oyCUHlg
   PbO15c9HVqiGiULuK3hWivPYe/jO4MLRQP7QIvoFFRqvBf5VIhGPV1Bm0
   50mR0kdi/AHwDUoTrNmpcEVTABv8QkLcEqQwtnkOdGqo5znN1NUZLKCzt
   A==;
X-CSE-ConnectionGUID: 9HxKi2qtSGuGG/ud9BlKdQ==
X-CSE-MsgGUID: IbK6INGtT3uhpf8TpvUipg==
X-IronPort-AV: E=McAfee;i="6700,10204,11177"; a="34634186"
X-IronPort-AV: E=Sophos;i="6.10,180,1719903600"; 
   d="scan'208";a="34634186"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 08:35:47 -0700
X-CSE-ConnectionGUID: R9bsxr8YTQK7FH1+SjbfVw==
X-CSE-MsgGUID: TZDwWMN1TCSERtmEMman+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,180,1719903600"; 
   d="scan'208";a="62628242"
Received: from apaszkie-mobl2.apaszkie-mobl2 (HELO apaszkie-mobl2.intel.com) ([10.245.244.19])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 08:35:46 -0700
From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	paul.e.luse@intel.com
Subject: [PATCH 2/3] md/raid5: only add to wq if reshape is in progress
Date: Tue, 27 Aug 2024 17:35:35 +0200
Message-ID: <20240827153536.6743-3-artur.paszkiewicz@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240827153536.6743-1-artur.paszkiewicz@intel.com>
References: <20240827153536.6743-1-artur.paszkiewicz@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that actual overlaps are not handled on the wait_for_overlap wq
anymore, the remaining cases when we wait on this wq are limited to
reshape. If reshape is not in progress, don't add to the wq in
raid5_make_request() because add_wait_queue() / remove_wait_queue()
operations take a spinlock and cause noticeable contention when multiple
threads are submitting requests to the mddev.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1e7dcb6235c7..8e74c455a87d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6071,6 +6071,7 @@ static sector_t raid5_bio_lowest_chunk_sector(struct r5conf *conf,
 static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	bool on_wq;
 	struct r5conf *conf = mddev->private;
 	sector_t logical_sector;
 	struct stripe_request_ctx ctx = {};
@@ -6144,11 +6145,15 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	 * sequential IO pattern. We don't bother with the optimization when
 	 * reshaping as the performance benefit is not worth the complexity.
 	 */
-	if (likely(conf->reshape_progress == MaxSector))
+	if (likely(conf->reshape_progress == MaxSector)) {
 		logical_sector = raid5_bio_lowest_chunk_sector(conf, bi);
+		on_wq = false;
+	} else {
+		add_wait_queue(&conf->wait_for_overlap, &wait);
+		on_wq = true;
+	}
 	s = (logical_sector - ctx.first_sector) >> RAID5_STRIPE_SHIFT(conf);
 
-	add_wait_queue(&conf->wait_for_overlap, &wait);
 	while (1) {
 		res = make_stripe_request(mddev, conf, &ctx, logical_sector,
 					  bi);
@@ -6159,6 +6164,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 			continue;
 
 		if (res == STRIPE_SCHEDULE_AND_RETRY) {
+			WARN_ON_ONCE(!on_wq);
 			/*
 			 * Must release the reference to batch_last before
 			 * scheduling and waiting for work to be done,
@@ -6183,7 +6189,8 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		logical_sector = ctx.first_sector +
 			(s << RAID5_STRIPE_SHIFT(conf));
 	}
-	remove_wait_queue(&conf->wait_for_overlap, &wait);
+	if (unlikely(on_wq))
+		remove_wait_queue(&conf->wait_for_overlap, &wait);
 
 	if (ctx.batch_last)
 		raid5_release_stripe(ctx.batch_last);
-- 
2.43.0

