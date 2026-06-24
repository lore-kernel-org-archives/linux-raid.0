Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BEF38CFE1;
	Wed, 24 Jun 2026 06:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283387; cv=none; b=NKYzwwHcVL7/Ls31FFTwCqvWvvSoeMl75mC2LMLDAB/Zxih5UULkhof5iew78fOBxZQcUNZBvWkU0ZM4DvjOmmF74DrZ2ttBtR5J7+R63UGHmc12PS0TZqzMUkL6LwFLcMQPDTQ1xutgcwossSJylH6POl4s0BWYKWEIe/e9dLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283387; c=relaxed/simple;
	bh=b2/yfu4z9xg7RRbc972xv7yHs3BdZF8er7YWqdlIOQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNTZZqUIAcwS/cSEbCmqFkV8lj8T3VHmrQZRetPsFM6G4nmDoX6VbCq7pmUisx55Baopgqo/gwjVrOezImgDekfxSDDegZigf48XCZGI0V3kGkeduvlryF5uzykZVM7l+lpuFRc+Ug8VdtYkKa8/dUHxfrJ/e1cJYOwUPzeKTNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8JKqado; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8JKqado"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3711F00A3A;
	Wed, 24 Jun 2026 06:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283386;
	bh=oVY5cU6dbWJXNbLWo/7CwaWDNuIqQbM+/Z6cXF/5vN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8JKqadojP6BkZAmEZbBgdV35S4VGOftdh5SeZbLoIVXFXd4+U3MFPtRaTnAiexjF
	 /JwF0vpYR3IVGkAhArjLM8wjFyYnGGvR+n5gyf25ir3nXiQOQ+G9ZuRAJVFUdyz6Rx
	 IU5aqtuwewjhVW7JPIxpTLVH9qUAm/WGTluco/6dK6AO8Ftgdp9LaASzO1yKakSdMY
	 iJs3g7ifyr52E+WgZrITmnU8vjCe3jJKYcPiHcZHieg9Xu49C14dcHeYgb1Pb3bCd8
	 Pka50quUpKtqCYAcU70PY6YAir8CEiTSkWk46JpSsvpCrMOUa4NBsl3qwCbFyRCPJh
	 L08edSjoE00SA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 17/20] md/raid5: add exact old and new llbitmap mapping helpers
Date: Wed, 24 Jun 2026 14:42:14 +0800
Message-ID: <7f4f61a0c06d01b38b0a175ce5df9afe6450d09e.1782282042.git.yukuai@kernel.org>
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

Teach RAID5 to export exact old and new llbitmap mappings and the
corresponding sync and array sizes for reshape-aware bitmap users.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 70 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0c5c9fb0606e..1613a42cc25d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5942,25 +5942,43 @@ static enum reshape_loc get_reshape_loc(struct mddev *mddev,
 	return LOC_BEHIND_RESHAPE;
 }
 
-static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
-				unsigned long *sectors)
+static void raid5_bitmap_sector_map(struct mddev *mddev, sector_t *offset,
+				    unsigned long *sectors,
+				    bool previous)
 {
 	struct r5conf *conf = mddev->private;
 	sector_t start = *offset;
 	sector_t end = start + *sectors;
-	sector_t prev_start = start;
-	sector_t prev_end = end;
 	int sectors_per_chunk;
-	enum reshape_loc loc;
 	int dd_idx;
 
-	sectors_per_chunk = conf->chunk_sectors *
-		(conf->raid_disks - conf->max_degraded);
+	if (previous)
+		sectors_per_chunk = conf->prev_chunk_sectors *
+			(conf->previous_raid_disks - conf->max_degraded);
+	else
+		sectors_per_chunk = conf->chunk_sectors *
+			(conf->raid_disks - conf->max_degraded);
 	start = round_down(start, sectors_per_chunk);
 	end = round_up(end, sectors_per_chunk);
 
-	start = raid5_compute_sector(conf, start, 0, &dd_idx, NULL);
-	end = raid5_compute_sector(conf, end, 0, &dd_idx, NULL);
+	start = raid5_compute_sector(conf, start, previous, &dd_idx, NULL);
+	end = raid5_compute_sector(conf, end, previous, &dd_idx, NULL);
+	*offset = start;
+	*sectors = end - start;
+}
+
+static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
+				unsigned long *sectors)
+{
+	struct r5conf *conf = mddev->private;
+	sector_t start = *offset;
+	sector_t end = start + *sectors;
+	sector_t prev_start = start;
+	unsigned long prev_sectors = end - start;
+	enum reshape_loc loc;
+
+	raid5_bitmap_sector_map(mddev, &start, sectors, false);
+	end = start + *sectors;
 
 	/*
 	 * For LOC_INSIDE_RESHAPE, this IO will wait for reshape to make
@@ -5969,17 +5987,10 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 	loc = get_reshape_loc(mddev, conf, prev_start);
 	if (likely(loc != LOC_AHEAD_OF_RESHAPE)) {
 		*offset = start;
-		*sectors = end - start;
 		return;
 	}
 
-	sectors_per_chunk = conf->prev_chunk_sectors *
-		(conf->previous_raid_disks - conf->max_degraded);
-	prev_start = round_down(prev_start, sectors_per_chunk);
-	prev_end = round_down(prev_end, sectors_per_chunk);
-
-	prev_start = raid5_compute_sector(conf, prev_start, 1, &dd_idx, NULL);
-	prev_end = raid5_compute_sector(conf, prev_end, 1, &dd_idx, NULL);
+	raid5_bitmap_sector_map(mddev, &prev_start, &prev_sectors, true);
 
 	/*
 	 * for LOC_AHEAD_OF_RESHAPE, reshape can make progress before this IO
@@ -5987,7 +5998,7 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 	 * we set bits for both.
 	 */
 	*offset = min(start, prev_start);
-	*sectors = max(end, prev_end) - *offset;
+	*sectors = max(end, prev_start + prev_sectors) - *offset;
 }
 
 static enum stripe_result make_stripe_request(struct mddev *mddev,
@@ -9049,6 +9060,20 @@ static void raid5_prepare_suspend(struct mddev *mddev)
 	wake_up(&conf->wait_for_reshape);
 }
 
+static sector_t raid5_bitmap_sync_size(struct mddev *mddev, bool previous)
+{
+	return mddev->dev_sectors;
+}
+
+static sector_t raid5_bitmap_array_sectors(struct mddev *mddev, bool previous)
+{
+	struct r5conf *conf = mddev->private;
+
+	if (previous)
+		return raid5_size(mddev, 0, 0);
+	return raid5_size(mddev, mddev->dev_sectors, conf->raid_disks);
+}
+
 static struct md_personality raid6_personality =
 {
 	.head = {
@@ -9078,6 +9103,9 @@ static struct md_personality raid6_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 static struct md_personality raid5_personality =
 {
@@ -9108,6 +9136,9 @@ static struct md_personality raid5_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 
 static struct md_personality raid4_personality =
@@ -9139,6 +9170,9 @@ static struct md_personality raid4_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 
 static int __init raid5_init(void)
-- 
2.51.0

