Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A7A28469F;
	Sun, 19 Apr 2026 03:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568198; cv=none; b=um8IWJp52YxD9Zm9237ZoKmxC3CseccksYWl8DFZ3GJn6RY/GKEJAv1Lq3BzT9E7ejrs8XttVG1HXq72fUFv8QTr4RLNZUyPHXgW6BNhG+BrAICprTh+u1DSEXRIg9donY656iKNklXDnvNR1XhqOyfd02TRIinZzWTkfqcnlvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568198; c=relaxed/simple;
	bh=7j1gsBpFJ2opygpiuVHAnTd5YKq/Lp2KHGY7Kue0Nk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PY/mEytz/yDONo7jtBMdvkn40AHv0q13b2G2sC9p8c94u3YIJfnjk4gXU7erXhuHi5zqVdiXQ7aJ/2ab7MWR+1+WmKxGbn8i4GdX+IsklFbLCpEhoKOeGHLl1yNS/WP77Zk+A+AqvXhWdl+Xj+hillvz8USs4FQGRvl2l/Z8trw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6E4C4AF09;
	Sun, 19 Apr 2026 03:09:56 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md: add helper to split bios at reshape offset
Date: Sun, 19 Apr 2026 11:09:25 +0800
Message-ID: <20260419030942.824195-3-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260419030942.824195-1-yukuai@fnnas.com>
References: <20260419030942.824195-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add mddev_bio_split_at_reshape_offset() so personalities can share
reshape-offset bio splitting instead of open-coding the same helper in
multiple places.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.c | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  4 ++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5b001e3e4cec..d222e365141b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9301,6 +9301,45 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
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
+	boundary = mddev->reshape_position;
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
 static void md_bitmap_prepare_range(struct mddev *mddev, sector_t *offset,
 				    unsigned long *sectors)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 82a36bdaeaaa..7247eeca5aa4 100644
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
 void md_free_cloned_bio(struct bio *bio);
 
-- 
2.51.0

