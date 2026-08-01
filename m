Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6736F338595;
	Sat,  1 Aug 2026 17:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605157; cv=none; b=IbD4kbP+aqJb2NFTf0+JWBRycBGnvnLqGyFiT13bxTymEtS9mj0sLJjacv1DU6ihfIAPXZ2+hJbchXCE5HtxuTmI7ovLmQ5boYWcAZBohUnVCyrNPgKOBwhOx53POKm/cYxS+SR6p5HaVo5qlQWTDNIxzYrB6gvdF16P8yb70MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605157; c=relaxed/simple;
	bh=8sapfSQZEk0WSpT9xE+/HwrwGGMmFblimfx5Kp+dYRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLzE5HFXIFGToNuGak9ve0YdUwlGDhyETblufgMchzFxCPtx8U/mhzM1Af6QiRvVoHUwRB9Ty93zLEsHGMehyE6uYNg2YGx0s7JGiPck8z/vMEKrOniDZ14hgE7lv3fpekxyIZKO5xW+5DC52lneEvbEyxWtb5GEQ3lsekCvC7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ll48teNY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ll48teNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CD61F00ACA;
	Sat,  1 Aug 2026 17:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605156;
	bh=DqSYT7eX3wmhQdB5JdvHjPWVbrVbNJP45V+wA83Bgck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ll48teNYj/sVjtp122w4B/TBax+0aNWgumdKNy1/T1HG2kyJgMZIOR5L7DuyD+yzo
	 1sGUFzlL16dammo7t1uAaw4YFHJ0qLEPcKO400+Tdo5lGL3suo7Ft1u0Y48wsJFK3w
	 ip64ocR+bqaNnV8zD/rmvG9QbnyQT+4yAqG70QMYKMqEY3jghCFTLhdaOkJ04Eh6Kd
	 jTiQRhVGKR4da6EwCakSQHK3ggjYlgI8551M9rqErpynPhUtXaqoN691TUBrDO0Llg
	 /2mWAynVTnisVHMzbQ/LewunQiMZ1fz/EBP9R23BjuJRmc99qugjY9YdF93fPzZUT7
	 yNgRMJMLPxl9g==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 03/25] md/md-llbitmap: only end fully synced chunks
Date: Sun,  2 Aug 2026 01:24:57 +0800
Message-ID: <20260801172519.2982121-4-yukuai@kernel.org>
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

llbitmap_cond_end_sync() is called with the sync thread's current sector.
That value is an exclusive progress boundary: sectors below it have
completed, but the llbitmap chunk containing it can still be in progress.

The old code converted that sector directly to the last bit passed to
BitmapActionEndsync. If resync had only advanced part-way into a large
llbitmap chunk, the in-progress chunk was marked synced and flushed before
the rest of the chunk was repaired. A later bitmap-assisted RAID1 resync
could then skip the remainder of that chunk and leave stale mirror data
behind.

This can be reproduced without editing bitmap metadata by creating a large
RAID1 with a lockless bitmap so llbitmap naturally selects a 524288-sector
chunk (with the default 128 KiB bitmap area, an array just over 16 TiB is
enough), making one mirror stale through the normal degraded write/re-add
path, and throttling resync so the daemon checkpoint runs while resync is
still inside the first chunk. On the bad kernel, bit 0 is ended early and a
stale sector later in the same chunk is skipped. With this fix, bit 0
remains Syncing until resync reaches the next chunk boundary.

Round the exclusive progress sector down to the nearest llbitmap chunk
boundary and end only chunks strictly below that boundary. Also honor the
force argument so callers that need an immediate checkpoint are not
suppressed by daemon_sleep.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 6ab2188bba27..be580601d5b9 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1450,22 +1450,27 @@ static void llbitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
 				   bool force)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
+	sector_t complete;
 
 	if (sector == 0) {
 		llbitmap->last_end_sync = jiffies;
 		return;
 	}
 
-	if (time_before(jiffies, llbitmap->last_end_sync +
-				 HZ * mddev->bitmap_info.daemon_sleep))
+	if (!force && time_before(jiffies, llbitmap->last_end_sync +
+				  HZ * mddev->bitmap_info.daemon_sleep))
 		return;
 
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
 
 	mddev->curr_resync_completed = sector;
 	set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
-	llbitmap_state_machine(llbitmap, 0, sector >> llbitmap->chunkshift,
-			       BitmapActionEndsync);
+
+	complete = round_down(sector, llbitmap->chunksize);
+	if (complete)
+		llbitmap_state_machine(llbitmap, 0,
+				       (complete >> llbitmap->chunkshift) - 1,
+				       BitmapActionEndsync);
 	__llbitmap_flush(mddev);
 
 	llbitmap->last_end_sync = jiffies;
-- 
2.51.0

