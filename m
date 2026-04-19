Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C8A2C21C5;
	Sun, 19 Apr 2026 03:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568225; cv=none; b=iqYXW9Nm51tjgxcnSqCKDRo2kRl+LzAAWkNm9dqKXE3olpn3zWH9FA4PUqQihg4wrMCe1ujcvMP/e+el4t7ynRLagughUh0UUQlGh/3Dj13f6Rl/W4es9NOB9KFsrpb25apATi2NY9SZGm74FVw2DQmFIvVtSe6Y7A9KZsScX2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568225; c=relaxed/simple;
	bh=6q1TubjfN4xCCNBpN5ETCKBCMVavOt3aAJ4UfTTUzzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWs3SHtwMNWdtUAKy67WZoUL8t8TCvHSntaKxjXMsi10xAhMyy2uPFNX2L96u+TEN96/qOwKGEZAFJWTKXeQKOWSQdznAtsAc+mcoWBk0pqOUVEFPNHk6sZCA61u0Ztt9K/+2VuyGjYS/r70OFFvD6Oc+BzooJPthGO80nnt5AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC8DC2BCB0;
	Sun, 19 Apr 2026 03:10:24 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/raid5: add exact old and new llbitmap mapping helpers
Date: Sun, 19 Apr 2026 11:09:39 +0800
Message-ID: <20260419030942.824195-17-yukuai@fnnas.com>
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

Teach RAID5 to export exact old and new llbitmap mappings and the
corresponding sync and array sizes for reshape-aware bitmap users.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid5.c | 70 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1f8360d4cdb7..0c58c175bad9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5898,25 +5898,43 @@ static enum reshape_loc get_reshape_loc(struct mddev *mddev,
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
@@ -5925,17 +5943,10 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
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
@@ -5943,7 +5954,7 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 	 * we set bits for both.
 	 */
 	*offset = min(start, prev_start);
-	*sectors = max(end, prev_end) - *offset;
+	*sectors = max(end, prev_start + prev_sectors) - *offset;
 }
 
 static enum stripe_result make_stripe_request(struct mddev *mddev,
@@ -9002,6 +9013,20 @@ static void raid5_prepare_suspend(struct mddev *mddev)
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
@@ -9031,6 +9056,9 @@ static struct md_personality raid6_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 static struct md_personality raid5_personality =
 {
@@ -9061,6 +9089,9 @@ static struct md_personality raid5_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 
 static struct md_personality raid4_personality =
@@ -9092,6 +9123,9 @@ static struct md_personality raid4_personality =
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

