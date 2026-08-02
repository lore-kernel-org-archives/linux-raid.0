Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEB42F532F;
	Sun,  2 Aug 2026 19:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700258; cv=none; b=COnwvlh8EmaNZqzjF0IpDMMd7wTI9znsE8UikDYEbBViRvKS++GWcVdnMs6vdZ6d4PoI2Ex989+r2sdflmwaWIrMa6WPYQPSkowx/Zj7s6duj8N2JluQmG5VWPdMgyo6W0pBhiqeOqKH0DgBgVvQoOwoJmUB4KHaH5Rg16rv83Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700258; c=relaxed/simple;
	bh=zlnyAV+EC9LbxYPZuEb2Cdh64EM8UHC3LuKd9rH5S5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGWNiCMxQowMuhCESoIt3rOVaZO9lxduVGfPj8CgsFjkTsmaQjSSPuQDl9yM2z4Uf3PyMkUcYvV2nG9VWgspxwtBp0dT14QtwQhr4v0XD6mfKWPNuaVQB3ms4U2qCj7QrtyJoZEuvZhiwmc3qGZN1tjwySFGIdB/o5vQ6D7Tdmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBb+39g3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBb+39g3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E05B1F000E9;
	Sun,  2 Aug 2026 19:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700256;
	bh=hB1LtmiyPLD6jOR2+Q4BxyiLCBViTo8Wy4k3Jlf8ABw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBb+39g3+hQJ3WNofr3tOfehoNH3SwiHwSpqkO1iifbrGw9bQ8kkBcoq/86qeGUNh
	 hKI0VlwowfAjgrB3C2Rfbr0nqm7HdUSrd3mJj64l1GTLTURdTIsOQAm+HiOBfvj7y8
	 z+i/3luG3bs3FxMrR5FKES2OQl9lJAEKgHsiU52yLAlUolDnTz5dANVx/G+ks8VHrY
	 duvoFzFxMdVPVFM3+MkFXcbgRf7h6spv4QD4DkwTDCRa8FD+CGW9eqFalW+i/aw231
	 VfU2qxxZPfAyNmoNEUTWkLQ0+l8IQS4B6bSYOUXLoMFaj0kjv+i05PQgGyZ0dreMN3
	 nBszwZC/75HsA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 03/29] md/md-llbitmap: only end fully synced chunks
Date: Mon,  3 Aug 2026 03:50:12 +0800
Message-ID: <20260802195038.164272-4-yukuai@kernel.org>
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

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 3cd8373bc9b2..948bf64c5ad2 100644
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

