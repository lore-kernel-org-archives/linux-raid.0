Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7831F388893;
	Wed, 24 Jun 2026 06:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283352; cv=none; b=KBtSLSLzJMshrcfkKWZiqiU8G2vvsG/KIanmY8x+3vO8owlM/nUshRuccqdcfeVKOWp7cuGY7I4TB/E39vJoB6J/T2OcH/Qy9wCN3eshmmflTKp004DNacN+poEkTFum/Xw0jHRxSmdLuo+7WBg380bxwGqOdQZxoMI80aEYxok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283352; c=relaxed/simple;
	bh=duBhFsYzXeSG9/zoc9k9CpZaCQZLZU3Cc7uUPpEqc7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcLvgL4qaea5gIw7MH0h3krxK8hT50V5DXfXjroAc/qV9XbEBYVAn0aF6mbZKhJ7QtwdXOmWS3qrSBEfOvw5j00WvITa1/TbAITzgp41ivAzeAH4aGbjLsYh+tzHgG5/IJjaMW8P5g1/sJzn75p3DTlMnbfZouOAkut1zC4QL8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljVjBma6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljVjBma6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495C31F00A3A;
	Wed, 24 Jun 2026 06:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283351;
	bh=GK7Ky+/FO+gaUoFDpRMV2NIlz8ZZP3rIDk7tW8Fqhek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljVjBma6PYIS6Nm95487jXU9olJ0w77Dq6ApfTAgsLDxo1SZifnadANARcc8UV6DY
	 qf5iA8LP9KExGOaIY7FcI/VrQcJkPza2bnmz9wURImWBljcCCgapMQdpChT00PTPiK
	 vS5O0afpnXHIOc0irU1DBhMtvMgyColgBeuYekLx4g0dQA4tUFvoQdcsRX9YuBxJKu
	 JsBxTeeBeqDCwREucqCXITY9z4Sc7sCmx7ek6QC7hPqYiyZLiVZ3OcgYL5hKXomRlI
	 AQu5I0EB2jbJFwwfRGQeoWUMMkx0Wj95DfhnXYd0/UT1NNyNCC4H/Ra2R0/R4ol7pf
	 FzSkmnWTRpq7Q==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/20] md: add helper to split bios at reshape offset
Date: Wed, 24 Jun 2026 14:42:00 +0800
Message-ID: <20e701b8355e1efd0d7cff3265189abf2424400b.1782282042.git.yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org> <cover.1782282042.git.yukuai@kernel.org>
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
index 0b59c676f7c0..c18a7f3c27e6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9361,6 +9361,45 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
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
index 110cf0f8b107..ebfc6da83161 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -925,6 +925,10 @@ extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
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

