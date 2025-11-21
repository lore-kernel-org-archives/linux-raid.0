Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185F32F5A28;
	Fri, 21 Nov 2025 05:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763702057; cv=none; b=sV69MgorrteTfnO/NTTyp7AAizR5NjU9FX5i/NLvgzt+p21u8xFxGk5df5F0DTinshiXgMmOxdU6nfJTspgzb45wss/sD/nsKy3jDSbXI+p66AIoD/tiahDxLGWpYxxDea0Ayo+qU0LcmekWK9PS0uz/HLO4gyPl3fJ9sac2Llo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763702057; c=relaxed/simple;
	bh=4KDj2pNSq+lxsIMg4XH14s5KHKgds2odyGUls6jJW2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAo7f3z7FN9YSeAsBM9s2LOxnARtegU19RECTmKowGoLMQqLacelTIKwaJOJ/+W8DKyg0nSeCE48PyuQbmW3Tet9Jc2hbyyWTbs6DJ97fcD0FF8g4964Al6bmWEEaIAOdC43Cm80wlIjZdvni4d7aQ7TzcL+GW2BPwM53fT5qSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408DDC16AAE;
	Fri, 21 Nov 2025 05:14:15 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan122@huawei.com,
	xni@redhat.com
Subject: [PATCH 3/7] md: support to align bio to limits
Date: Fri, 21 Nov 2025 13:14:02 +0800
Message-ID: <20251121051406.1316884-5-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251121051406.1316884-1-yukuai@fnnas.com>
References: <20251121051406.1316884-1-yukuai@fnnas.com>
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
 drivers/md/md.h |  1 +
 2 files changed, 47 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7b5c5967568f..b09f87b27807 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -427,6 +427,48 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_handle_request);
 
+static struct bio *__md_bio_align_to_limits(struct mddev *mddev,
+					    struct bio *bio)
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
+	if (!mddev->bio_align_to_limits)
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
@@ -442,6 +484,10 @@ static void md_submit_bio(struct bio *bio)
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
index 75fd8c873b6f..1ed90fd85ac4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -630,6 +630,7 @@ struct mddev {
 	bool	has_superblocks:1;
 	bool	fail_last_dev:1;
 	bool	serialize_policy:1;
+	bool	bio_align_to_limits:1;
 };
 
 enum recovery_flags {
-- 
2.51.0

