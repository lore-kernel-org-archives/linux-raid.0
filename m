Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2693D2DECB1;
	Mon, 24 Nov 2025 06:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965940; cv=none; b=PWPy81apM652PVDpxg3aEAR3OGZDbfSfsVUcmwhgmIaVBD6AoD8iA11k4ohGlOMcBDmtjj6xUqnNqZ/TqDLs9eh4Hbjb6Yav61CuBrYwXSbjZmWafdpNL1vs8OKlbLBrRFfvNBOM38b3B7vYzEluDtxYx1I4++PM12clyC/lU8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965940; c=relaxed/simple;
	bh=fY0BzEVm9sfZcUQikujZgp1iImD0UEOOT90ro6ySvr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDQf08t72h/CahCgq0NZdfH4IlsbOXPpXYC8ne2ptgA9ybpEcmihvG0hRFHUOIDokkkEWIIWYudHjc3ZVCOWxE61z2ZecX1VAYs/7+aodMzWjXuI2GQumJfbiq9IiS25eKvC+5vKwr/K2ya3qHpN5eY1s1QF04W9aGdKfUvQ2zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70755C116C6;
	Mon, 24 Nov 2025 06:32:18 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	filippo@debian.org,
	colyli@fnnas.com,
	yukuai@fnnas.com
Subject: [PATCH v2 06/11] md: support to align bio to limits
Date: Mon, 24 Nov 2025 14:31:58 +0800
Message-ID: <20251124063203.1692144-7-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124063203.1692144-1-yukuai@fnnas.com>
References: <20251124063203.1692144-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For personalities that report optimal IO size, it's indicate that users
can get the best IO bandwidth if they issue IO with this size. However
there is also an implicit condition that IO should also be aligned to the
optimal IO size.

Currently, bio will only be split by limits, if bio offset is not aligned
to limits, then all split bio will not be aligned. This patch add a new
feature to align bio to limits first, and following patches will support
this for each personality if necessary.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  2 ++
 2 files changed, 48 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5833cbff4acf..db2d950a1449 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -428,6 +428,48 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_handle_request);
 
+static struct bio *__md_bio_align_to_limits(struct mddev *mddev,
+                                           struct bio *bio)
+{
+	unsigned int max_sectors = mddev->gendisk->queue->limits.max_sectors;
+	sector_t start = bio->bi_iter.bi_sector;
+	sector_t align_start = roundup(start, max_sectors);
+	sector_t end;
+	sector_t align_end;
+
+	/* already aligned */
+	if (align_start == start)
+		return bio;
+
+	end = start + bio_sectors(bio);
+	align_end = rounddown(end, max_sectors);
+
+	/* bio is too small to split */
+	if (align_end <= align_start)
+		return bio;
+
+	return bio_submit_split_bioset(bio, align_start - start,
+				       &mddev->gendisk->bio_split);
+}
+
+static struct bio *md_bio_align_to_limits(struct mddev *mddev, struct bio *bio)
+{
+	if (!test_bit(MD_BIO_ALIGN, &mddev->flags))
+		return bio;
+
+	/* atomic write can't split */
+	if (bio->bi_opf & REQ_ATOMIC)
+		return bio;
+
+	switch (bio_op(bio)) {
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
+		return __md_bio_align_to_limits(mddev, bio);
+	default:
+		return bio;
+	}
+}
+
 static void md_submit_bio(struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
@@ -443,6 +485,10 @@ static void md_submit_bio(struct bio *bio)
 		return;
 	}
 
+	bio = md_bio_align_to_limits(mddev, bio);
+	if (!bio)
+		return;
+
 	bio = bio_split_to_limits(bio);
 	if (!bio)
 		return;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b8c5dec12b62..e7aba83b708b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -347,6 +347,7 @@ struct md_cluster_operations;
  * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
  * @MD_FAILLAST_DEV: Allow last rdev to be removed.
  * @MD_SERIALIZE_POLICY: Enforce write IO is not reordered, just used by raid1.
+ * @MD_BIO_ALIGN: Bio issued to the array will align to io_opt before split.
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -366,6 +367,7 @@ enum mddev_flags {
 	MD_HAS_SUPERBLOCK,
 	MD_FAILLAST_DEV,
 	MD_SERIALIZE_POLICY,
+	MD_BIO_ALIGN,
 };
 
 enum mddev_sb_flags {
-- 
2.51.0

