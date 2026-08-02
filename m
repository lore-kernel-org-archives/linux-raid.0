Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FBC2DA756;
	Sun,  2 Aug 2026 19:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700344; cv=none; b=YjEgbGRdjNy2DPbuZR8xBkgT1kxDhP3DLT2eW4nhFyDCbUwMkJcfffmAom+AiZWld/b27OmuR+7HFFuQdDMG3NDM+tUM05AM9nUWYNIzXSX2RmzHLN0993yZiGBw2BFtYIgkwymvasZVbgn6JK95FcRWbLX2DZZW8xZaoRlKKxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700344; c=relaxed/simple;
	bh=zuBUKN/0By9bwTDiXX3dIKJ0U17ZZbdQqzAgTaYWYCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJ1e2ZipyK6T2MqmERKX/FrnZ4a98DuZf4eBiM2FGAxK9vU2+/TfZJrJiEZICFJWa/CCC54oOrwKEERzMta1NvKm5ISUNUt6S/tt1danACxR5dd/bAaBsC9uQzqZuCI0no+WwyQKJGv1B/xpuqkA0P1Ui3luTiXtlBwtKMEQ6eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aq7aNS2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aq7aNS2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651F11F00A3A;
	Sun,  2 Aug 2026 19:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700343;
	bh=noao0UvL+Onfed2Lrp0Whb9V04ME13xSoFCoKYK5utY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aq7aNS2RFGfzHNKMd2yZ/p1tDjP9Dwb98WFh7UgT0uEX82zLl9N/yMfno+WNdzquv
	 3pt1Yn5OoZ62y56iANmw0L3l602jcFYFWBwk4YhpcintRA97Cl8kGVn42i8PFfxt2E
	 +CV8Se5OBNV/TYJHM8crxoDkhTX9SnIJmLDVgpJb4VChjIKNayA4SwZTpYLZnS+eeb
	 s/L5FYUiT38lk/RW/eIMbd9m1G8NDk2Y9SPPMGEPu5nPj/+tpJ21cewhjLI2eAVlWW
	 no3nFZU0l44LKoZHxjV6lFxrs8unFv1XhW1vb1cOUse7l6aeEcRKP85CIehtu779s3
	 tvlr5unwZcriA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 26/29] md/raid5: add exact old and new llbitmap mapping helpers
Date: Mon,  3 Aug 2026 03:50:35 +0800
Message-ID: <20260802195038.164272-27-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802195038.164272-1-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
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

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 73 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2cc2546a29ae..88bf5a9ce573 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6015,28 +6015,46 @@ static enum reshape_loc get_reshape_loc(struct mddev *mddev,
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
@@ -6045,19 +6063,10 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
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
@@ -6065,7 +6074,7 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 	 * we set bits for both.
 	 */
 	*offset = min(start, prev_start);
-	*sectors = max(end, prev_end) - *offset;
+	*sectors = max(end, prev_start + prev_sectors) - *offset;
 }
 
 static enum stripe_result make_stripe_request(struct mddev *mddev,
@@ -9131,6 +9140,21 @@ static void raid5_prepare_suspend(struct mddev *mddev)
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
+		return raid5_size(mddev, mddev->dev_sectors,
+				  conf->previous_raid_disks);
+	return raid5_size(mddev, mddev->dev_sectors, conf->raid_disks);
+}
+
 static struct md_personality raid6_personality =
 {
 	.head = {
@@ -9160,6 +9184,9 @@ static struct md_personality raid6_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 static struct md_personality raid5_personality =
 {
@@ -9190,6 +9217,9 @@ static struct md_personality raid5_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 
 static struct md_personality raid4_personality =
@@ -9221,6 +9251,9 @@ static struct md_personality raid4_personality =
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

