Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DDE418A37;
	Tue, 28 Jul 2026 08:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228589; cv=none; b=Aui3EZjzDGFEZAYjJOJ5kVLh+JtPjLTtnWxNGFLrCGx0r29nYk7EJEq3jg1SzmH4TaLb4S8uUG5M13wReL9/bWkHi3ANw0yDc9kTj3iDfNan0M3yD4asdp6cGEz5xdrCn1s9AvP8pXIrT6k4iEpmtI9tt4JRATV5drnLmTXam1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228589; c=relaxed/simple;
	bh=duBhFsYzXeSG9/zoc9k9CpZaCQZLZU3Cc7uUPpEqc7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owqpi9Njl2PN1slA0HoCOI3/v37hroeo4DwI2GYwqBk4d+S8luXFaVj/RSXzJa4ecxInXAo0K96oitpBqJBFj4n+O1+VIkwlZqG84cngGlWum5tfo3ZEo+tghXHDBZthwwYg2JAsKCUjgtEUXZZDPZ6KniQObodVZ+InhBt7yZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hT3PP4jQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hT3PP4jQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7211F1F00A3D;
	Tue, 28 Jul 2026 08:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228588;
	bh=GK7Ky+/FO+gaUoFDpRMV2NIlz8ZZP3rIDk7tW8Fqhek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hT3PP4jQbs9oi6OrYguvyzTEpd1n00pIL8OLpcyB+QscEMU1ekQcgc0zWlT//x9oc
	 cRENHDVQW+JmVbXdSskrtL4N3wUawZxpF0jmSPHYdtEwKellNaMvcE7SWcxg2Ar/fA
	 JU+A0e7+/ItCn6rUKPGnQo/bEBbVN89Ykxy/TR5DAz8RkSE49YBYkEcomLdIYQM5Ye
	 HSS9sFFARxRDh2nX7CrIj5tGxrhzSvYXTAUrQq+gYjSowRc8e5/EubJvsto5hZ1liT
	 wxRY1r3oYCjGT0HmO+TGXSNQGThSuQrVBLaa5CEvBH44YrZKUO85T2cjK0J7LDuEc2
	 IQgdkfujl/Ugw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/21] md: add helper to split bios at reshape offset
Date: Tue, 28 Jul 2026 16:49:04 +0800
Message-ID: <94dbcd6afed02f9838d2b9aabea69d041e83aa8b.1785206690.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
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

