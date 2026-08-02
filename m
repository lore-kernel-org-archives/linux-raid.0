Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DBD3002B9;
	Sun,  2 Aug 2026 19:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700265; cv=none; b=cu7cWP2+H8/PnmufchWm7EBg34ET1Zywyl9fE45OxlmmX0uky4HjjXEj7PuEBT9PRbG2CcH5Y0ozTVlFtPC2VUgnr4z+t7+rKY8dTqhHOEsQc5lt9dZkSqBIQMAseMuBwsv9LxHsVkpX3hL7hQQdelWqRTDwDCEyy6P5Cf7MrM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700265; c=relaxed/simple;
	bh=jdfEljajARyuhq8YCaqB22dJovLR3agb9y+AMN33aP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ui2FAUjdealDlYK6ZzEOShMBcg/GL2EpQR25FUonJbOPHBe/JnBWCkQ3FSpy8wMjY5T2WVeY+CipCCwfGyeS2Lc8SxUx41zfTVE72buZ8VXU1q9vWm3myk71Mf/ayMTL+Pw8xypAH6CAb3LUyi0QJGkwHt2cV2LqxJxsiCWP0Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLT/YXxD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLT/YXxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD081F000E9;
	Sun,  2 Aug 2026 19:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700263;
	bh=wuuaKZBEn/vQSwJHTa4GZ8Ic7lEKoex3pkscJSjGRSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mLT/YXxDI1Wx2QSZccmTiahM9cWu1lwFqe3RfCa8UQrzv7XDCv6nMJ2f51r4URRaR
	 ccTNW3f66BHDZlYiNrOhGR1I2rl+nnlYmVSAUAOjdn3A0QAMpb2Roxz15ws0N2YGCm
	 AIs5KXUA0nq99AdpUU7dqI3zLLazGTFbUSbhAcCdWvbblZLs3y1MfeB+T+8ynu+aaR
	 W8KUnn+vf5jnecIQHOqXZcmthAFYdQeXmzFRVi1PSbemyQe5ER1Y3AsBkJUZAKoTfP
	 7kT/Vh1FaBt5c4RABEanonLkjmSzK9CpXkz520LmfbUl++zURTcpX+5zt9CU3cQfeS
	 kerxIRZaaR02g==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 05/29] md/raid5: round bitmap stripes with sector division
Date: Mon,  3 Aug 2026 03:50:14 +0800
Message-ID: <20260802195038.164272-6-yukuai@kernel.org>
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
Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d128d238e1da..2cc2546a29ae 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6029,8 +6029,11 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 
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
@@ -6048,8 +6051,10 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 
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

