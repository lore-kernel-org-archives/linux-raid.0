Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F5D47A0B4;
	Fri,  5 Jun 2026 07:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780644407; cv=none; b=oXpyZVQ3/dr5LMKYTXh/enHO4y4dVfNbtP3DO6f1x98rPviBCGcf2L9huQg/do8IvUcn70BhFeP6IuIraf80ILLjhQdV6iiN+Jpy7jZA9rZ7ZRfYddLABu5idE6L2SZ17Lygf3BmoKg7RWjREaw91mRrN2vD/RoZNpTYke2hc70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780644407; c=relaxed/simple;
	bh=XhrYV5/VRpbogi3ErjzjGJBaGuSXKWPxU77FFLVcyc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O55M3+ONQgdxbIy1QVW246c0q50kheJhrLW7Ij12VgA0eSKcjMGXACQhp6ypwi4M//fe5ZU0OdpeebMcaWwj/R2vEzjPx0dqtaPyyu3JktRn21nsypjTIV7OYzL49W4CZYCxD+kOxC+0a3Q11UdG3zWbGho788zNt1FoxuDDG7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RchJSz5j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RchJSz5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4DC1F00893;
	Fri,  5 Jun 2026 07:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780644405;
	bh=Bedl9q/jJIqWgiyrFraApXDJ+ymOAhTjS9Jvc4JdEcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RchJSz5jPYnud8Plr6dMXVJ4EFWqjr0fmzgC9/31Yc4Hm3hgAys6JqcSVH+bbWysz
	 5kUolykptqdRq+rR2H7QXdPAJPpT4w4Gy4ptmdRhjutwCnXXD5l10XYpux7MLFLrCD
	 QSE1QGFfsjRqP9B8KoJG0c/BN/+8eomhYwFIgdnK8AysGwj7Pg/q5QP3ucmQBl2dBy
	 JAo0b/cbHJSbdgw4+e7xvYkpVSJVrnWASFE086vCKkQGlWzpBvT02clPgkFlMzk2c0
	 mUuKjVgSnQAfRi3gfmotpzwIsM5vyQz0lQcSphhTymoehsKrqosg4T7minID4hyK9F
	 ZNYVr/zyMIYpg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] md/raid5: account discard IO
Date: Fri,  5 Jun 2026 15:26:37 +0800
Message-ID: <20260605072639.2434847-2-yukuai@kernel.org>
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

Raid5 handles discard bios internally through make_discard_request() and
never passes them through md_account_bio(). As a result, discard IO is
missing the md-device iostat accounting that normal raid5 IO and discard
IO in other raid levels get from md_account_bio().

Before accounting the bio, trim the request to the full data stripes that
raid5 will actually discard. The first full stripe is the ceiling of the
bio start divided by data-stripe sectors, and the last full stripe is the
floor of the bio end divided by data-stripe sectors. Account that exact
MD logical full-stripe range, then restore the original iterator so bio
completion and iostat still cover the original request.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 65ae7d8930fc..debf35342ae0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5688,34 +5688,47 @@ static void release_stripe_plug(struct mddev *mddev,
 
 static void make_discard_request(struct mddev *mddev, struct bio *bi)
 {
 	struct r5conf *conf = mddev->private;
 	sector_t logical_sector, last_sector;
+	sector_t first_stripe, last_stripe;
 	struct stripe_head *sh;
+	struct bvec_iter bi_iter;
+	struct bio *orig_bi = bi;
 	int stripe_sectors;
 
 	/* We need to handle this when io_uring supports discard/trim */
 	if (WARN_ON_ONCE(bi->bi_opf & REQ_NOWAIT))
 		return;
 
 	if (mddev->reshape_position != MaxSector)
 		/* Skip discard while reshape is happening */
 		return;
 
-	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
-	last_sector = bio_end_sector(bi);
-
-	bi->bi_next = NULL;
-
 	stripe_sectors = conf->chunk_sectors *
 		(conf->raid_disks - conf->max_degraded);
-	logical_sector = DIV_ROUND_UP_SECTOR_T(logical_sector,
-					       stripe_sectors);
-	sector_div(last_sector, stripe_sectors);
+	first_stripe = DIV_ROUND_UP_SECTOR_T(bi->bi_iter.bi_sector,
+					     stripe_sectors);
+	last_stripe = bio_end_sector(bi);
+	sector_div(last_stripe, stripe_sectors);
+
+	if (first_stripe >= last_stripe) {
+		bio_endio(bi);
+		return;
+	}
+
+	bi_iter = bi->bi_iter;
+	bi->bi_iter.bi_sector = first_stripe * stripe_sectors;
+	bi->bi_iter.bi_size = ((last_stripe - first_stripe) *
+			       stripe_sectors) << 9;
+	md_account_bio(mddev, &bi);
+	orig_bi->bi_iter = bi_iter;
+	bi->bi_iter = bi_iter;
+	bi->bi_next = NULL;
 
-	logical_sector *= conf->chunk_sectors;
-	last_sector *= conf->chunk_sectors;
+	logical_sector = first_stripe * conf->chunk_sectors;
+	last_sector = last_stripe * conf->chunk_sectors;
 
 	for (; logical_sector < last_sector;
 	     logical_sector += RAID5_STRIPE_SECTORS(conf)) {
 		DEFINE_WAIT(w);
 		int d;
-- 
2.51.0

