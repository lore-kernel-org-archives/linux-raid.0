Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF52417BFE;
	Tue, 28 Jul 2026 08:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228577; cv=none; b=j5DaJstTZOkpXVvVRi7C/Ex7YWB2n/b8ZDscdrmrobt5RlVbV9zT5zWUO9Wt3IAMMxMAGeUte6SrOS99Tj5wWjWJrUMgH/7+GxHsh2Y1KxACwaGSQN3j3kE+suTIa7wMeZUuCCjV2kf4AtDOB+lxyWpL/97InskQO4NvkpzuI+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228577; c=relaxed/simple;
	bh=CCv5449ekRcPxODjhdyeImGK/0OMSg0sOFrpBQSelW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYstsDlEg/D5GY0erUzSgKNojpNgAWRou8b15Q/Jr1bLmn9zfsBB/8KlzxO7Ai6ljqBfE2cklRaDz+e2o0PruQ+PNd5OtWVXNgAQFwvD7R4UFoltxHjVgaZNL5L/y0vH27F6AhyYpQemZSe6u4VptD6K2S5E9V1ntF4ybz1vUF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NcMhvzZQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NcMhvzZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6D71F00A3A;
	Tue, 28 Jul 2026 08:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228575;
	bh=vOYMabX/04XdlvZlr/kkpAwIA6tQ4vYOvw41eSNiiUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NcMhvzZQKJHcd1fXRjEs56YujUWNBvy/QWjMJnCXLp4dl+IPR+ijlS8qVUUu52ZVO
	 0vdWybuS3QzaI22TqPi5XpET5IxqEZKFaRCm1rIaqkwtzkbQXMHGWyPX9jyN8vRhF1
	 mtyOLJ1VMGAipypKc1M4D4o/zSqNamHtFuPtb7dRGg8olE3y4NqZwPH8G5+s4kPSZQ
	 mvd+Eey3X6LozApbPRdW7qOOPn413+prFyzn8x3ojvKt88V7F/soDcgC9f3zNnTE2T
	 hQiML1vbZ0OPx5Gs9EOpHOGrRyPhzl1uSntmWRY8EDZ7Y66Oas7vUl/UTF1kChAwce
	 cEhqJ/K2D4bMw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/21] md/raid5: round bitmap stripes with sector division
Date: Tue, 28 Jul 2026 16:49:01 +0800
Message-ID: <3d25eb6065f71c2ca81f3b03db549b38a8dc1f96.1785206690.git.yukuai@fygo.io>
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

raid5_bitmap_sector_map() aligns the array range to full RAID5 stripe
widths before converting it to component sectors. That width is
chunk_sectors multiplied by the number of data disks, and it is not
always a power of two.

Reproduce with a 4-disk RAID5, 1024-sector chunks, and three data disks.
The full-stripe width is 3072 sectors. For a one-sector write at array
sector 3072, correct rounding gives array range [3072, 6144), which maps
to component range [1024, 2048). The old round_down()/round_up() logic
instead gives [1024, 4096), which maps to [0, 1024).

Use sector_div() based arithmetic so the rounded range is aligned to the
actual RAID5 stripe width.

The deterministic mapper test now reports the fixed component range as
[1024, 2048), while the old mask-based range was [0, 1024).

Fixes: 9c89f604476c ("md/raid5: implement pers->bitmap_sector()")
Reported-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://lore.kernel.org/all/20260726185916.2223460-1-mykola@meshstor.io/
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0c5c9fb0606e..35910bc6683b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5956,8 +5956,11 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 
 	sectors_per_chunk = conf->chunk_sectors *
 		(conf->raid_disks - conf->max_degraded);
-	start = round_down(start, sectors_per_chunk);
-	end = round_up(end, sectors_per_chunk);
+	sector_div(start, sectors_per_chunk);
+	start *= sectors_per_chunk;
+	if (sector_div(end, sectors_per_chunk))
+		end++;
+	end *= sectors_per_chunk;
 
 	start = raid5_compute_sector(conf, start, 0, &dd_idx, NULL);
 	end = raid5_compute_sector(conf, end, 0, &dd_idx, NULL);
@@ -5975,8 +5978,10 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 
 	sectors_per_chunk = conf->prev_chunk_sectors *
 		(conf->previous_raid_disks - conf->max_degraded);
-	prev_start = round_down(prev_start, sectors_per_chunk);
-	prev_end = round_down(prev_end, sectors_per_chunk);
+	sector_div(prev_start, sectors_per_chunk);
+	prev_start *= sectors_per_chunk;
+	sector_div(prev_end, sectors_per_chunk);
+	prev_end *= sectors_per_chunk;
 
 	prev_start = raid5_compute_sector(conf, prev_start, 1, &dd_idx, NULL);
 	prev_end = raid5_compute_sector(conf, prev_end, 1, &dd_idx, NULL);
-- 
2.51.0

