Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324AB30DD07
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 04:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768192171; cv=none; b=EKAFIRT6S3FXm1hc0NK1R9PzUsGaHNGgyZUGbR4WtyKfS2tlmBPi7wLeZXh5e1nsT5/xRqkMr92DBG1qmW4ZS69P4JIa0Lim2fdVBslwDumzn6Oye3GX533rB9Pzy2/kiX/a/thcE+M3PaTByYBapsQcrI7c/op0Ku9DrPJ9/ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768192171; c=relaxed/simple;
	bh=0Bqwpcg08upVNbrVYRxcnfHFOrrVPLmdISf+pANy2Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpreByhDZ3mn+l7Z7UgtFp2eAeEbd+1VSVAqtAxCxV01VXu1dkLcc4U74NPPQqMLHi5xmMqk0yKfQAIpUSr5/n3i24C8kJWyA5FIK0mb7JE11siVe2qE4DfiOsT3UEAzZtO8GxRutnnjo0Che+0OyFioSHMaGx4TQ0AAbelP7QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C61C116D0;
	Mon, 12 Jan 2026 04:29:24 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org,
	linan122@huawei.com
Cc: yukuai@fnnas.com
Subject: [PATCH v4 06/11] md: support to align bio to limits
Date: Mon, 12 Jan 2026 12:28:52 +0800
Message-ID: <20260112042857.2334264-7-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112042857.2334264-1-yukuai@fnnas.com>
References: <20260112042857.2334264-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For personalities that report optimal IO size, it indicates that users
can get the best IO bandwidth if they issue IO with this size. However
there is also an implicit condition that IO should also be aligned to the
optimal IO size.

Currently, bio will only be split by limits, if bio offset is not aligned
to limits, then all split bio will not be aligned. This patch add a new
feature to align bio to limits first, and following patches will support
this for each personality if necessary.

Link: https://lore.kernel.org/linux-raid/20260103154543.832844-7-yukuai@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  2 ++
 2 files changed, 56 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 21b0bc3088d2..731ec800f5cb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -428,6 +428,56 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_handle_request);
 
+static struct bio *__md_bio_align_to_limits(struct mddev *mddev,
+					     struct bio *bio)
+{
+	unsigned int max_sectors = mddev->gendisk->queue->limits.max_sectors;
+	sector_t start = bio->bi_iter.bi_sector;
+	sector_t end = start + bio_sectors(bio);
+	sector_t align_start;
+	sector_t align_end;
+	u32 rem;
+
+	/* calculate align_start = roundup(start, max_sectors) */
+	align_start = start;
+	rem = sector_div(align_start, max_sectors);
+	/* already aligned */
+	if (!rem)
+		return bio;
+
+	align_start = start + max_sectors - rem;
+
+	/* calculate align_end = rounddown(end, max_sectors) */
+	align_end = end;
+	rem = sector_div(align_end, max_sectors);
+	align_end = end - rem;
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
@@ -443,6 +493,10 @@ static void md_submit_bio(struct bio *bio)
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

