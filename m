Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792A32DA756;
	Sun,  2 Aug 2026 19:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700287; cv=none; b=IPqqwk84LpHUWUiIyeo9+no8+vcNso9PwFfIQu/zAtaYGwpRP7b4kvCW8yNL+DytrJ7qZfxd/sjMK6D15QBDRuOQFxhfU8jrwAWzuhL3701SEtf4/nio4UFN9y8YneUKXp6iZQzajEuKZ9yz8luHV8qc2+P0PWMRNVtzCSs7rmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700287; c=relaxed/simple;
	bh=29Ip17HN0CEdcOr3hVd1G1H1+LsOmFwnkXLsbJdK4Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqzWYfcldqErFf+zLRaUhM0lUks32QRb08579hM0D+x2SjX0wnsGDqA/zwlXlsDKHFOtUNG4FpR4Q5+dWtL9EHZqjiDAhza0JT/NNpAPG9NG7Ulrk0PgDjHJ86WtYNJ3LH6304sBMP5W9w86mKzbTntPo0Yf1/eBEhZe8iQD6a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nA1VLz34; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nA1VLz34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0B51F000E9;
	Sun,  2 Aug 2026 19:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700286;
	bh=vKVPXf+g/byhY7EZrFpGCyHm1NZyHDDuQiKiy08ni8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nA1VLz34tITq2ZUFqkxM9M2XfazZAYpVGo/4z17QXtgQd0U7XUfcdKdCfSwlU8LEk
	 LLWSjKqKzdo65EDoYInAkTI3JPvFyfHbizuj7hJfB4qo9ePacZ/H/y/cyOQpDZ4dmf
	 hY3mMXs6KpcFCQbTfDvedP1MkYu3ojmcOTTYBB1izyLZ2zhW3RXv4h8LiyH04ismwx
	 GOVhSBAClqm+f9aH91aYDij3tNY5Ra+8sEH9Q8MsCEfcSnByMjEYF96fU+fuLRC9R1
	 h3zEacQWSYYN8qprlt3bb5Aca5ASIsAmwxUk+bpNGeqTp985ALKJVXvlGUrWY4xdqy
	 iGtG5vWByk6kQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 11/29] md: add helper to split bios at reshape offset
Date: Mon,  3 Aug 2026 03:50:20 +0800
Message-ID: <20260802195038.164272-12-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802195038.164272-1-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Add mddev_bio_split_at_reshape_offset() so personalities can share
reshape-offset bio splitting instead of open-coding the same boundary
handling in multiple places.

The helper first applies the optional max_sectors limit. If reshape is
running and the bio crosses reshape_position, it further limits the front
bio to the current reshape boundary so callers can account and submit one
side of the reshape at a time.

Snapshot reshape_position with READ_ONCE(). RAID5 and RAID10 update this
field as reshape progresses, while the I/O path only needs one consistent
decision point for the current bio. Using an explicit single load avoids a
plain lockless access and prevents the compiler from refetching a different
boundary while deciding whether and where to split.

When a split is needed, bio_submit_split_bioset() submits the remainder and
returns the front bio. Callers must therefore continue processing the
returned bio, not the original pointer.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md.c | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  4 ++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f88952371b9b..f0eecdfff1cc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9388,6 +9388,45 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 }
 EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 
+struct bio *mddev_bio_split_at_reshape_offset(struct mddev *mddev,
+					      struct bio *bio,
+					      unsigned int *max_sectors,
+					      struct bio_set *bs)
+{
+	sector_t boundary;
+	sector_t start;
+	sector_t end;
+	unsigned int split_sectors;
+
+	split_sectors = bio_sectors(bio);
+	if (max_sectors && *max_sectors && *max_sectors < split_sectors)
+		split_sectors = *max_sectors;
+
+	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
+		goto split;
+
+	boundary = READ_ONCE(mddev->reshape_position);
+	start = bio->bi_iter.bi_sector;
+	end = bio_end_sector(bio);
+	if (start >= boundary || end <= boundary)
+		goto split;
+
+	if (boundary - start < split_sectors)
+		split_sectors = boundary - start;
+
+split:
+	if (max_sectors)
+		*max_sectors = split_sectors;
+	if (split_sectors < bio_sectors(bio)) {
+		bio = bio_submit_split_bioset(bio, split_sectors, bs);
+		if (bio)
+			bio->bi_opf |= REQ_NOMERGE;
+	}
+
+	return bio;
+}
+EXPORT_SYMBOL_GPL(mddev_bio_split_at_reshape_offset);
+
 static void md_bitmap_start(struct mddev *mddev,
 			    struct md_io_clone *md_io_clone)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index bb2eb5f39914..8146a6f50a7d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -920,6 +920,10 @@ extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 			struct bio *bio, sector_t start, sector_t size);
+struct bio *mddev_bio_split_at_reshape_offset(struct mddev *mddev,
+					      struct bio *bio,
+					      unsigned int *max_sectors,
+					      struct bio_set *bs);
 void md_account_bio(struct mddev *mddev, struct bio **bio);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
-- 
2.51.0

