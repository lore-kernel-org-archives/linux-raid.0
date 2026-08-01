Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F348F330644;
	Sat,  1 Aug 2026 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605171; cv=none; b=E3AuEnGny0rlh8HYxFkQOk5XO31p7gxau1GIQFaQLJqM3CesY+MzzUXB9WdNE90L2dQboEBL24nOu1wScCsSvffQPmqKDRQA1FVXTZI/Va5FZHeq9WjK/K889ioMKqLHa+Vm4bsNC0kG4MDM1dPxGh7ru0Dduu/l56cHdyKzz3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605171; c=relaxed/simple;
	bh=VsLNapY/L7K4NelFNagu3Sw+fpWyGhIcurKPIwwyPLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3/05XPMvPcxS+BMpVVxcYNpU6lFkHKTljNgNiJV+fMgQ1j0rc2l1VoKxfmVGBA22vo0UhHmLw9qpNE6zKCNgzSX+8tmWxC22K9fJbb5fGuAUr1wS+z1XRQoXNNXfCF5t4TQ0e+iQOaF1V+VJUzSNyz1WnOiDME98kc2TtmaFUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gc5GtjEu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gc5GtjEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2475A1F00ACA;
	Sat,  1 Aug 2026 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605169;
	bh=dCFUedP1skGYzgnqpTqOIQ2im+r3VlOni4SnWA+zMSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gc5GtjEuxtYaQY8ELZbalxopUFVfavGJmOVpuqRaj7V7S7Jh57YF409oLzfWcObUo
	 Uu8K+pbx1ZI4Doq/lKPLttIej/tCpysOeZfKOUNebW7CnddQJ2699eefI6TShKJG5k
	 dvTUjURiTycq9dyuyObm2AVMvClqmybbmEtaKoAvHiaQxd6L0pQrZfYyf+a1L2HxVP
	 QVdS60A8QVNiI3Y4Wr2Bd5ng7Emh+LrN7oSPLZP6cHxXeIv5l4pqxnj1dYc1Dm2u/r
	 qRYlEJjPZcbPGWD7u3RGoPJ53zEkEfhIRNonurdlcTbh+6sDBGyKyry8Wkc9cWqYDg
	 4+UfqD6TQCMuQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 05/25] md/raid5: round bitmap stripes with sector division
Date: Sun,  2 Aug 2026 01:24:59 +0800
Message-ID: <20260801172519.2982121-6-yukuai@kernel.org>
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
index 4276b125f94c..8b3483674398 100644
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

