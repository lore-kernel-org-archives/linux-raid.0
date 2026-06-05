Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C116740B393;
	Fri,  5 Jun 2026 09:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650971; cv=none; b=eRuQ7IUlQrC01kecoW0LUTTRsW50tCds2c9F3Nznn0fmUEelG7V7IN4MQt92FN/a/FePU4VR+wxvSJ1zerscqiGsIE5u5KvlLuQiYAJifGGu3T7LH4G219S65UCB66gUdM13hudIPlkyh3dqUPHmbh4DgrPCZfGS+kfJEGP1Ink=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650971; c=relaxed/simple;
	bh=qyjOkinAGKKGAK5d/74eGLxcbQEoFuZDAXEnwfwrk+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YonnryzuHog9GHZU2c1ATmrjdCKlt5cjcpfR31XKGFN5fEaUJHZMEFUHwj5efTvAdgXDDTSGZtR5dJ2AC2XSKENq3e7WbZx8Vu0tT/gbIx4weH9a5hXO/is79V1GAuuFiJTVHqxmShB5JYJlcqTn2QQFgyn3R4k0aNyE/S09erI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nn8OA35r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nn8OA35r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5128D1F00893;
	Fri,  5 Jun 2026 09:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650970;
	bh=zlggyNfiG8PWiqWNgXq70fl3ERHQM1moLlFFCxYRhPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nn8OA35raL+6LG37+KudK2PpCvgOXIFljP/uAf7Eivh30KqWyOaGCpu3TNcLtUbh2
	 Q6bsogz509NFP/EinrUeClAuAtAFDpTP/MjGrzzEhLtzlZawKkteEfrLunZFvtkHHu
	 tCrOa1rnPtG0OBO8Q8SgtYlHZ33Gv+5CFyRxkn/t+GDfFJNkFjUlbYxn8lnYEYZMTd
	 C7iyJnQpbMWrZ3YIM4Ccil6Ss4HS7/kpwsdpdwdJunt+/GqBiZkbiqILIcskydP/Be
	 fIhOCPuw0hTikCddKd117nRrFR2ZngdsPHJHwoeLRzoX3qVlho/I1Dj7Po+KMzKGnE
	 7LfXb5XbbQvuQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid5: add exact old and new llbitmap mapping helpers
Date: Fri,  5 Jun 2026 17:15:24 +0800
Message-ID: <20260605091527.2463539-18-yukuai@kernel.org>
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

Teach RAID5 to export exact old and new llbitmap mappings and the
corresponding sync and array sizes for reshape-aware bitmap users.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 70 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 180ff0660b6a..ff4da82f78fe 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5933,56 +5933,67 @@ static enum reshape_loc get_reshape_loc(struct mddev *mddev,
 	if (ahead_of_reshape(mddev, logical_sector, reshape_safe))
 		return LOC_INSIDE_RESHAPE;
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
 	 * progress, hence it's the same as LOC_BEHIND_RESHAPE.
 	 */
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
 	 * is handled in make_stripe_request(), we can't know this here hence
 	 * we set bits for both.
 	 */
 	*offset = min(start, prev_start);
-	*sectors = max(end, prev_end) - *offset;
+	*sectors = max(end, prev_start + prev_sectors) - *offset;
 }
 
 static enum stripe_result make_stripe_request(struct mddev *mddev,
 		struct r5conf *conf, struct stripe_request_ctx *ctx,
 		sector_t logical_sector, struct bio *bi)
@@ -9040,10 +9051,24 @@ static void raid5_prepare_suspend(struct mddev *mddev)
 	struct r5conf *conf = mddev->private;
 
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
 		.type	= MD_PERSONALITY,
 		.id	= ID_RAID6,
@@ -9069,10 +9094,13 @@ static struct md_personality raid6_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid6_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 static struct md_personality raid5_personality =
 {
 	.head = {
 		.type	= MD_PERSONALITY,
@@ -9099,10 +9127,13 @@ static struct md_personality raid5_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid5_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 
 static struct md_personality raid4_personality =
 {
 	.head = {
@@ -9130,10 +9161,13 @@ static struct md_personality raid4_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid4_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 
 static int __init raid5_init(void)
 {
 	int ret;
-- 
2.51.0

