Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531DD3E6DE8;
	Fri,  5 Jun 2026 03:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780629736; cv=none; b=gBZglPZNQbzGC+OPTz17KyhsJJM3mFcsuUKqCgwGMKUWa0maPoOIhepTVFmOHGXsB/Ca5bPcwikqiyE1qTMnv3fQQop7ieASKOBqeDApQmpBZCS8uMdrnlQRx+FeAdxyen200FDBtmTZ89NZEStGCJEyIQPrVWZDFi+L7srtYn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780629736; c=relaxed/simple;
	bh=XhrYV5/VRpbogi3ErjzjGJBaGuSXKWPxU77FFLVcyc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BB73kqQK4n6Mtz59TfM1QSmq/QIS/FL+FYj8oipcecFIVjG3JEMGWmqwqqrxeBCgk9m44iW6PFU5NJ07H1OsyKFchalKvtlvJz4+lQ/xJ2MvoT4Q2hCJOGOvO8VSgXi2zf9ptWWGt8eKXsLLKzqdbckBWbqCdTP/joKpTVHoXv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FSPXAGgP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSPXAGgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F77F1F00898;
	Fri,  5 Jun 2026 03:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780629731;
	bh=Bedl9q/jJIqWgiyrFraApXDJ+ymOAhTjS9Jvc4JdEcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSPXAGgPGnH6q37jclAHueBBIJRIFO3pfVcNRn2eueVr2o2otEXrmpn1kbtVOmPDY
	 d/KnGUuzoaILqKz0OCRukpxLQZTwRqoFrsCistvUgpxtwfxOaOtJ9l2/MnYwJN5R93
	 a9fz9xG3Rrv72yuB2RGi+4NPn6hxZMXGxuKn5V/qN76Fpdrx5DRv17TPf+Y8lFDcox
	 shdilWp5omOYjztxVr3+In3WSbSkGNGUK6fd+uC5HJwHWUrerWX7wBCTtWFuViKhYc
	 EJ4kM9L1uIP3SJkO/cLn0U6AcYkJlFleQhaBBOqF4SSvj+jTsxtzljSsrl5fYlY1lI
	 5FFHPatU+ZUSg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid5: account discard IO
Date: Fri,  5 Jun 2026 11:22:04 +0800
Message-ID: <20260605032205.2376714-2-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605032205.2376714-1-yukuai@kernel.org>
References: <20260605032205.2376714-1-yukuai@kernel.org>
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

