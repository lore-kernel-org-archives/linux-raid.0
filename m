Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0872641A540;
	Tue, 28 Jul 2026 08:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228655; cv=none; b=CePwiJQiQxUDWo74V+TdC1Aa1cEGjAQfpo7/XbMTPZEmddoPYlg3JLcOS6AWojTz6WvIfKRpm4ekDiPla0BmExEIkRs/cnvhDrysqsGWCwKVVBSnmtsVU5QwP2PcGs6/Tnya+9IoCuHjFFgxiWo9vmeuN+fpT07rGMmYRIOPTXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228655; c=relaxed/simple;
	bh=dBXxiRoSs/mjQAbMdVoPVaTUQ7ojyASZvMFa3KlEIHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAVhIQjYDDaDu9HhlwAOFH0kf4vGGjv/o0ZLb2D23aI/Ilzyt4bScGujEgyZZKAWql9AdzFhkSnNXhsNac7dwxsDeMfG4Qb+nn/kNbD/T71yq5CyUREAKr+37XwdebTX56JnhxIZtkYnAJSskjogL2Em5HGt5In8FsAMpOCMWB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PH4Wu1D/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PH4Wu1D/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512461F00A3A;
	Tue, 28 Jul 2026 08:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228653;
	bh=gG5W/yL3ZhE07Fh9FTIfaQp+vZb32+s3hm4gYdy3uXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PH4Wu1D/dT81+Zt9Dlf3xoUkWUUZJIRwuAhx1LW46G28XzDp8enWS3QncCLONpBkr
	 OysCwfHzBDJ8ddPCXgwv3BIILeOjNOybcg6/GSyMUze72hi2yuMGApEs7YsOdppBkm
	 qnYrthZxuWnDLzg85ZWo3D316qbHmVAbL3UJ63pcG7tgcMKP0m1FceYqaxo1q/Frmy
	 nFv4q6BP/l9EuFeL+WNNkXEZn3i6lbUHlgAQGCeY8tafO4rLqVoykFK+/QFZmdyNHy
	 Raq8FQBDo67PTloG7op307tWbzh8YhjMxmzn0xZrPWv6FtczQN0U/vpeCl/rJIavFS
	 XfgmzvI7qPT5w==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 18/21] md/raid5: add exact old and new llbitmap mapping helpers
Date: Tue, 28 Jul 2026 16:49:18 +0800
Message-ID: <ff64d014a1a12e231aef460dbf72f088bf835ee3.1785206690.git.yukuai@fygo.io>
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

Teach RAID5 to export exact old and new llbitmap mappings and the
corresponding sync and array sizes for reshape-aware bitmap users.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 72 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 35910bc6683b..8b28afa538e2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5942,28 +5942,46 @@ static enum reshape_loc get_reshape_loc(struct mddev *mddev,
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
 	sector_div(start, sectors_per_chunk);
 	start *= sectors_per_chunk;
 	if (sector_div(end, sectors_per_chunk))
 		end++;
 	end *= sectors_per_chunk;
 
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
@@ -5972,19 +5990,10 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 	loc = get_reshape_loc(mddev, conf, prev_start);
 	if (likely(loc != LOC_AHEAD_OF_RESHAPE)) {
 		*offset = start;
-		*sectors = end - start;
 		return;
 	}
 
-	sectors_per_chunk = conf->prev_chunk_sectors *
-		(conf->previous_raid_disks - conf->max_degraded);
-	sector_div(prev_start, sectors_per_chunk);
-	prev_start *= sectors_per_chunk;
-	sector_div(prev_end, sectors_per_chunk);
-	prev_end *= sectors_per_chunk;
-
-	prev_start = raid5_compute_sector(conf, prev_start, 1, &dd_idx, NULL);
-	prev_end = raid5_compute_sector(conf, prev_end, 1, &dd_idx, NULL);
+	raid5_bitmap_sector_map(mddev, &prev_start, &prev_sectors, true);
 
 	/*
 	 * for LOC_AHEAD_OF_RESHAPE, reshape can make progress before this IO
@@ -5992,7 +6001,7 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 	 * we set bits for both.
 	 */
 	*offset = min(start, prev_start);
-	*sectors = max(end, prev_end) - *offset;
+	*sectors = max(end, prev_start + prev_sectors) - *offset;
 }
 
 static enum stripe_result make_stripe_request(struct mddev *mddev,
@@ -9054,6 +9063,20 @@ static void raid5_prepare_suspend(struct mddev *mddev)
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
@@ -9083,6 +9106,9 @@ static struct md_personality raid6_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 static struct md_personality raid5_personality =
 {
@@ -9113,6 +9139,9 @@ static struct md_personality raid5_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 
 static struct md_personality raid4_personality =
@@ -9144,6 +9173,9 @@ static struct md_personality raid4_personality =
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

