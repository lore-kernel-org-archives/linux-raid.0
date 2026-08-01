Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D03935C1A0;
	Sat,  1 Aug 2026 17:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605187; cv=none; b=tfuRlAH9gfl+eXpMIgscfk1GMlKbz1m0pan+sMVqWYzKvL+DpokTyIKoaPaMF4kE+2U6umDMkf9aw1U+TloAuNuKMVtxz6fl95CGXhssDNRSZ5F9Arvqf5q3sHHF1vUjFIjqTjKYoG+p+LlfvTYL3iz/Ru+1M6tXtokHL35Rg+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605187; c=relaxed/simple;
	bh=orpEeGe/wroRtp1hdmup2wDbmAHVib1uqJnCOTmb1iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phg/EblZDEIVN1Oxzb7HLWb61YmlPu6k119mioT/coL96Bd1ZSZo6WqMOC1oFwE7BB5lgSx6OoF6Dez+WDUi2KOheMYdhj0ycJSLdeNniAGibE0oe05ipdZA9HwM5/vzMk/GuYWMJfo1oZUv8kqIX6SVIKxFAwiPw6dFOiASzFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJRsM7lD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJRsM7lD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B47B1F00AC4;
	Sat,  1 Aug 2026 17:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605186;
	bh=ngkMyeX+MbZI9WJOsCeLN4qLsT/mnA9+2qua4Y8Gnz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJRsM7lDJZHoipLGNGZKg29053y4U5y5cqKTas5JjcyaKs0QUEbID1lkFvhLm9LQe
	 his3eEyap+G5oy5EDgKVERv4Ja4EIgmVRtTscpOdXJY7VMGXrKtQegnd3Lt/diDOFo
	 AhWABOTzirIl2UGKQJYv3Xjw4VsUI5rVJk/i8UqbPPJsNcSdHyTnxv+q88uSQOgSCC
	 rLpTjwVDURzlRhQUgr3Al78odL3Ro7y4FbPVQaT/vAS3UyQi5nQElZ8Y7jGALJmwX2
	 SPyN2nDzvACtVStfagAQov8Gd+CYFWW06Hpxx9IJPcqf+o9ALl7q5PRHH0DRyUgNPA
	 uIFbYxHp/irNQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/25] md: add helper to split bios at reshape offset
Date: Sun,  2 Aug 2026 01:25:02 +0800
Message-ID: <20260801172519.2982121-9-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260801172519.2982121-1-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
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

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md.c | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  4 ++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0b59c676f7c0..34e95ef9f2d4 100644
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

