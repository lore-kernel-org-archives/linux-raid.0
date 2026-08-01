Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7803ACA65;
	Sat,  1 Aug 2026 17:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605264; cv=none; b=Mrc/VstvpE9r1ohSTKZsjvqXN61IwkzEs7JGzcMQAsTFwldCXI49ScwSBxxEiMKt4KNW6angczmOeLA1TGgIKgpfKTgvV3cNTmmGivULhj+vs2lq8SNyFixGukp88ln4H/3V1dJhp5Lwd30pJtLnCUKVUUk5ZgeYU14KsYI3fwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605264; c=relaxed/simple;
	bh=UOdCJnz3XTTPYDn0pGXqNCXAj3POqv6rmXOZ1gRctXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kug3Sdayyn/ul6mRHh1yDc392P3UpOFeadEp07EYj/IByDcdvBo+RnSPiAc2kJeQU7ciKB3ACnm+h6e35elSHA5ez5Y1zYvk8KhXw7L/2ocxjwSPe9pP1bRMMd34ycp6YmQJdBJTdT2hGLnyvpuqtzvVhOvYrkNe493X+Fp5IS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sxay5rh9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sxay5rh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B661F00ACA;
	Sat,  1 Aug 2026 17:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605262;
	bh=kZcgrDKhiEDQJB/H5CCjU6tq0doXsg+SETN1gxdb3Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sxay5rh9JKkvQYTYRwQ1E8V3HE+bgiZiMIEgdJ42gTjOJ6H/lkQozmhTxd9974chz
	 /L60CIljZXOLDyfHe4Kl0ReZKk4LiQOfmoZh5Kfy+3TnlUgilq2eGHU2aURlufe7Yd
	 OOpGuwp5Qcud+bbNWrAUfCLu0YHn93wo9SE3IGJiVDM0bJo6f5a9eEeCX0Bx43G74Q
	 gd92OivwFjc8ITfCDgzSAwVAS8L1qBt+Xlm7Wk7dKmpSLweTsXSbuh6eYDycvrb0TG
	 kBdwp220u5oH2029w5z7rEWbS2f1444aAt2MX52ZQYPKZPcH53lJPzxAATceIgF4L6
	 xbWGKc0xPuZrA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 22/25] md/raid5: add exact old and new llbitmap mapping helpers
Date: Sun,  2 Aug 2026 01:25:16 +0800
Message-ID: <20260801172519.2982121-23-yukuai@kernel.org>
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

Teach RAID5 to export exact old and new llbitmap mappings and the
corresponding sync and array sizes for reshape-aware bitmap users.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 72 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8b3483674398..af7775278af6 100644
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
@@ -9059,6 +9068,20 @@ static void raid5_prepare_suspend(struct mddev *mddev)
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
@@ -9088,6 +9111,9 @@ static struct md_personality raid6_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 static struct md_personality raid5_personality =
 {
@@ -9118,6 +9144,9 @@ static struct md_personality raid5_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.bitmap_sector_map = raid5_bitmap_sector_map,
+	.bitmap_sync_size = raid5_bitmap_sync_size,
+	.bitmap_array_sectors = raid5_bitmap_array_sectors,
 };
 
 static struct md_personality raid4_personality =
@@ -9149,6 +9178,9 @@ static struct md_personality raid4_personality =
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

