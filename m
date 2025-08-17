Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144D1220F32;
	Sun, 17 Aug 2025 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755444412; cv=none; b=NjW9GYjIQgg44eu8dZVQSpDFiJTVnNToT9vQ0hZd2jEdJn2XqFjyeG5BDzX3UVHyYwMdH+a637dSGdD8NmjUMvZJ2GaTwQMsd6mYpky8ycoIx4tHZ1VCuXi1gkGCk1kbH8aKycSeh8Ty3xiIk/cYErRcF07KklQqDTAMgc5YtI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755444412; c=relaxed/simple;
	bh=SQeX92yVhw/9yM+up9fO+7MKjsKogrLYB8mAAiysl7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHSvFXP2h2zUhyKjX4TRfeQp02XOAB8QFWTPmRQuZk0kcrPpuKXnNH3NmE/u+SUSTt+2d5KYzfIyOnFZ/As2MvpPhFfh0A1A+b6jFO0Iw3Z6HSMMsqWZ2dsa52eTl1cIz95sSuzCybAWYR8WpsPG8Ko5wAP8qwPhAmgaGaT/oX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DRbSYJFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DRbSYJFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C288CC4CEF1;
	Sun, 17 Aug 2025 15:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755444411;
	bh=SQeX92yVhw/9yM+up9fO+7MKjsKogrLYB8mAAiysl7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRbSYJFaO7ioOLcyjWPxa6O+Yg5D3kvkizbvdpHhMdnFFRJ4L3pS+bkU4ZV6l/wM1
	 xDq47fiaW3DolaKVFUzFW7bIWKE+1W/TRa0KA8spUBsFMUKR22HN4th/oxLqVq2qUv
	 u0aS3HJxgS0Buu8Sq+EblELTiWP+xKrt7DKoiUwPDpNG44nGRJhtj6De3SUGMZIAhH
	 w1ezm9NlyFqPlGR7n2KSKiasOmr6Myt8RyhAj8Cr1TMnDOrYdmkhFA1mO+cDjDrmHZ
	 IjkFrPkUNFcru/HDJYblvyeV+Ms4VUbqpLqSEvl1AJDrZ2YqOxWa5GkE+E5Q3xBxvw
	 aGWpJsi5Ah5VA==
From: colyli@kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	yukuai3@huawei.com,
	Coly Li <colyli@kernel.org>
Subject: [PATCH 2/2] md: split bio by io_opt size in md_submit_bio()
Date: Sun, 17 Aug 2025 23:26:45 +0800
Message-ID: <20250817152645.7115-2-colyli@kernel.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250817152645.7115-1-colyli@kernel.org>
References: <20250817152645.7115-1-colyli@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@kernel.org>

Currently in md_submit_bio() the incoming request bio is split by
bio_split_to_limits() which makes sure the bio won't exceed
max_hw_sectors of a specific raid level before senting into its
.make_request method.

For raid level 4/5/6 such split method might be problematic and hurt
large read/write perforamnce. Because limits.max_hw_sectors are not
always aligned to limits.io_opt size, the split bio won't be full
stripes covered on all data disks, and will introduce extra read-in I/O.
Even the bio's bi_sector is aligned to limits.io_opt size and large
enough, the resulted split bio is not size-friendly to corresponding
raid456 level.

This patch introduces bio_split_by_io_opt() to solve the above issue,
1, If the incoming bio is not limits.io_opt aligned, split the non-
  aligned head part. Then the next one will be aligned.
2, If the imcoming bio is limits.io_opt aligned, and split is necessary,
  then try to split a by multiple of limits.io_opt but not exceed
  limits.max_hw_sectors.

Then for large bio, the sligned split part will be full-stripes covered
to all data disks, no extra read-in I/Os when rmw_level is 0. And for
rmw_level > 0 condistions, the limits.io_opt aligned bios are welcomed
for performace as well.

This patch only tests on 8 disks raid5 array with 64KiB chunk size.
By this patch, 64KiB chunk size for a 8 disks raid5 array, sequential
write performance increases from 900MiB/s to 1.1GiB/s by fio bs=10M.
If fio bs=488K (exact limits.io_opt size) the peak sequential write
throughput can reach 1.51GiB/s.

Signed-off-by: Coly Li <colyli@kernel.org>
---
 drivers/md/md.c    | 51 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid5.c |  6 +++++-
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac85ec73a409..d0d4d05150fe 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -426,6 +426,55 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_handle_request);
 
+/**
+ * For raid456 read/write request, if bio LBA isn't aligned tot io_opt,
+ * split the non io_opt aligned header, to make the second part's LBA be
+ * aligned to io_opt. Otherwise still call bio_split_to_limits() to
+ * handle bio split with queue limits.
+ */
+static struct bio *bio_split_by_io_opt(struct bio *bio)
+{
+	sector_t io_opt_sectors, start, offset;
+	struct queue_limits lim;
+	struct mddev *mddev;
+	struct bio *split;
+	int level;
+
+	mddev = bio->bi_bdev->bd_disk->private_data;
+	level = mddev->level;
+
+	/* Only handle read456 read/write requests */
+	if (level == 1 || level == 10 || level == 0 || level == LEVEL_LINEAR ||
+	    (bio_op(bio) != REQ_OP_READ && bio_op(bio) != REQ_OP_WRITE))
+		return bio_split_to_limits(bio);
+
+	/* In case raid456 chunk size is too large */
+	lim = mddev->gendisk->queue->limits;
+	io_opt_sectors = lim.io_opt >> SECTOR_SHIFT;
+	if (unlikely(io_opt_sectors > lim.max_hw_sectors))
+		return bio_split_to_limits(bio);
+
+	/* Small request, no need to split */
+	if (bio_sectors(bio) <= io_opt_sectors)
+		return bio;
+
+	/* Only split the non-io-opt aligned header part */
+	start = bio->bi_iter.bi_sector;
+	offset = sector_div(start, io_opt_sectors);
+	if (offset == 0)
+		return bio_split_to_limits(bio);
+
+	split = bio_split(bio, (io_opt_sectors - offset), GFP_NOIO,
+			  &bio->bi_bdev->bd_disk->bio_split);
+	if (!split)
+		return bio_split_to_limits(bio);
+
+	split->bi_opf |= REQ_NOMERGE;
+	bio_chain(split, bio);
+	submit_bio_noacct(bio);
+	return split;
+}
+
 static void md_submit_bio(struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
@@ -441,7 +490,7 @@ static void md_submit_bio(struct bio *bio)
 		return;
 	}
 
-	bio = bio_split_to_limits(bio);
+	bio = bio_split_by_io_opt(bio);
 	if (!bio)
 		return;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 989acd8abd98..985fabeeead5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7759,9 +7759,13 @@ static int raid5_set_limits(struct mddev *mddev)
 
 	/*
 	 * Requests require having a bitmap for each stripe.
-	 * Limit the max sectors based on this.
+	 * Limit the max sectors based on this. And being
+	 * aligned to lim.io_opt for better I/O performance.
 	 */
 	lim.max_hw_sectors = RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf);
+	if (lim.max_hw_sectors > lim.io_opt >> SECTOR_SHIFT)
+		lim.max_hw_sectors = rounddown(lim.max_hw_sectors,
+			  lim.io_opt >> SECTOR_SHIFT);
 
 	/* No restrictions on the number of segments in the request */
 	lim.max_segments = USHRT_MAX;
-- 
2.47.2

