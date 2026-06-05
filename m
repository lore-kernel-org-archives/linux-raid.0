Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845834C8FF4;
	Fri,  5 Jun 2026 09:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650939; cv=none; b=jRONjEbxK/EJCgjK6T/fbTmys3a1YdxknTBvNF/LWFlNFyHNO6kFQJ1WLvxn7j1YgWQv7M3wBTYB0z2tpgstZqlav2Sw3ysW/+ewfrls0sr+MCiAwm4NuC5jQRWPop0fcJ3XAtLmlY7Pr3kff9a55+e/mSp62/EGPz8QiRxTDAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650939; c=relaxed/simple;
	bh=H/YLx7PHu6y5NVTN8GtypqwctsztozZMmIX56coQu0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFyPvMBUZo4hNRPKUU6xFjmEH8X7eZluYUnz9zQLBIL4Gt4db7y5bX85IUobMO1PT1W+9sqv3ghHcaS3be9t0sAOIyGyTMY1H3zaw7fvuiIvIlK7aODFe76Avr8nhNdRQSMtYfxpxisH3HC0FUhDWivwif9awjcWjP/p41mYViw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ytz/yut0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ytz/yut0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9390B1F00898;
	Fri,  5 Jun 2026 09:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650938;
	bh=p4GUMKOh4UGR2mZ5bB/PqTNFE+i8KYfzhMk7jCgOsp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ytz/yut090ml+ibvuRxPrFgyMSkR9Ara3Vn98BvcXX5+jdrKLlEEtVpIhLXVZdr6q
	 EpkPkDLAvlvuy3M2XdHtsGitellPwXEceQK1Df8GUEUle+ACmtMmLHqfCMvyHUjJvh
	 moGUnVaCAXw6kVlrUYHSkNl2PnstNFTwlbIeoHHCeBqt08tejfvGpgFAPN+6YfCMgA
	 DRz7fSYGCQklqqkmpmHzXvelByZT9XOgiIfeJiG5OYr3diz0JorrEMYai1cY9rKrTR
	 LHgLswhzCLbFqMlaZcdN7Dx/8MJweOIwPiogaZbehsZmHN7t77w5vavB655FRExwr0
	 3G9jLZjEohJzw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md: add helper to split bios at reshape offset
Date: Fri,  5 Jun 2026 17:15:10 +0800
Message-ID: <20260605091527.2463539-4-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605091527.2463539-1-yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Add mddev_bio_split_at_reshape_offset() so personalities can share
reshape-offset bio splitting instead of open-coding the same helper in
multiple places.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md.c | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  4 ++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ccc4180d2c1d..6685e4c53fd9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9359,10 +9359,49 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 	mddev_trace_remap(mddev, discard_bio, bio->bi_iter.bi_sector);
 	submit_bio_noacct(discard_bio);
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
 	mddev->bitmap_ops->prepare_range(mddev, offset, sectors);
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 110cf0f8b107..ebfc6da83161 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -923,10 +923,14 @@ extern void md_done_sync(struct mddev *mddev, int blocks);
 extern void md_sync_error(struct mddev *mddev);
 extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 			struct bio *bio, sector_t start, sector_t size);
+struct bio *mddev_bio_split_at_reshape_offset(struct mddev *mddev,
+					      struct bio *bio,
+					      unsigned int *max_sectors,
+					      struct bio_set *bs);
 void md_account_bio(struct mddev *mddev, struct bio **bio);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
 void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
 		       sector_t sector, int size, struct page *page,
-- 
2.51.0

