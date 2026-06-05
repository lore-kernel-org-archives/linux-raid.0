Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817A44C9573;
	Fri,  5 Jun 2026 09:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650943; cv=none; b=b8ItnYVpHe7qfw0lL2KIRJdNpwtnQFaT4e5W4mwGhmrMFHXnsK2/Xj3j/+VwLstBhGYJ8i+5DAUbgIi1w4j7e8UpIR6J/ZDhQtsJ5egfPBBe8Klb+HvtH2yzvLw5Xdiydq339avmbszAnOjVDSzPU1eyTBa203kL5080VodBZmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650943; c=relaxed/simple;
	bh=opS+4NAvVHPxRiJP3pjgVFWoOH8K/WXqo3vgRAQgipI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0KdoqgNUq78cnizmnslnBnxgQeMVpZiMtmDK5ZPzKJ8Vu1Mva+mxwrSH+LFXtwSkQWDxtOISzGD0A0nDZl/J93EtPV6hbEF2Pyo/eIIp53TX+zMix7Jc8xi0wg0FparEhd2i0cljAkn7EKw+A11LsqQjST9U+yg4/nY+HXqhhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AhwN3wdi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AhwN3wdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B441F00893;
	Fri,  5 Jun 2026 09:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650940;
	bh=DaWWrvrCptvfsVbav+YaNZ1RUTMIi0HGZOOLTccBp2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhwN3wdiAP42K6f3asDRAm+/49y7HoUxHJqO2U/WOi3KRwkfOgCTsuFtoGJ/Xh1OS
	 SLsahZsFdta4bv6ojg6l37HwJe77l6U2cIebZQk5xiAVd2ADeVjA9t2ZFW10PiHIG8
	 YKhzzCCVZqCjs4Vg0jpsVxFKupQIhOZMFcyMvdnU0xTT4DMVD55HtHIza7WYuf4SXu
	 E/v94CElHS9sdw8TZeHTF5SWa0RO/K9mBPfdNQWV+BdHWty2EiNMgR3yULhVLSWZ+N
	 zrcTITpvMZhBTWUWUQPpu7bEe7tR20n344TkQuKE8T/IoSnmiRUNeyygc+jY+IxD7/
	 cyCe27Bmgz/MQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/md-llbitmap: track bitmap sync_size explicitly
Date: Fri,  5 Jun 2026 17:15:11 +0800
Message-ID: <20260605091527.2463539-5-yukuai@kernel.org>
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

Track llbitmap's own sync_size instead of always using
mddev->resync_max_sectors directly.

This is the minimal bookkeeping needed before llbitmap can track old
and new reshape geometry independently.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index bcf34f0c9af6..ecf3ed712315 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -285,10 +285,12 @@ struct llbitmap {
 	unsigned long chunkshift;
 	/* size of one chunk in sector */
 	unsigned long chunksize;
 	/* total number of chunks */
 	unsigned long chunks;
+	/* total number of sectors tracked by current bitmap geometry */
+	sector_t sync_size;
 	unsigned long last_end_sync;
 	/*
 	 * time in seconds that dirty bits will be cleared if the page is not
 	 * accessed.
 	 */
@@ -916,10 +918,11 @@ static int llbitmap_init(struct llbitmap *llbitmap)
 
 	llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
+	llbitmap->sync_size = blocks;
 	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
 
 	ret = llbitmap_cache_pages(llbitmap);
 	if (ret)
 		return ret;
@@ -936,10 +939,11 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 {
 	struct mddev *mddev = llbitmap->mddev;
 	unsigned long daemon_sleep;
 	unsigned long chunksize;
 	unsigned long events;
+	sector_t sync_size;
 	struct page *sb_page;
 	bitmap_super_t *sb;
 	int ret = -EINVAL;
 
 	if (!mddev->bitmap_info.offset) {
@@ -985,10 +989,13 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	if (test_and_clear_bit(BITMAP_FIRST_USE, &llbitmap->flags)) {
 		ret = llbitmap_init(llbitmap);
 		goto out_put_page;
 	}
 
+	sync_size = le64_to_cpu(sb->sync_size);
+	if (!sync_size)
+		sync_size = mddev->resync_max_sectors;
 	chunksize = le32_to_cpu(sb->chunksize);
 	if (!is_power_of_2(chunksize)) {
 		pr_err("md/llbitmap: %s: chunksize not a power of 2",
 		       mdname(mddev));
 		goto out_put_page;
@@ -1020,12 +1027,13 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	mddev->bitmap_info.chunksize = chunksize;
 	mddev->bitmap_info.daemon_sleep = daemon_sleep;
 
 	llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
 	llbitmap->chunksize = chunksize;
-	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors, chunksize);
+	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(sync_size, chunksize);
 	llbitmap->chunkshift = ffz(~chunksize);
+	llbitmap->sync_size = sync_size;
 	ret = llbitmap_cache_pages(llbitmap);
 
 out_put_page:
 	__free_page(sb_page);
 	kunmap_local(sb);
@@ -1151,10 +1159,11 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 	}
 
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
+	llbitmap->sync_size = blocks;
 
 	return 0;
 }
 
 static int llbitmap_load(struct mddev *mddev)
@@ -1524,11 +1533,11 @@ static void llbitmap_update_sb(void *data)
 
 	sb = kmap_local_page(sb_page);
 	sb->events = cpu_to_le64(mddev->events);
 	sb->state = cpu_to_le32(llbitmap->flags);
 	sb->chunksize = cpu_to_le32(llbitmap->chunksize);
-	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
+	sb->sync_size = cpu_to_le64(llbitmap->sync_size);
 	sb->events_cleared = cpu_to_le64(llbitmap->events_cleared);
 	sb->sectors_reserved = cpu_to_le32(mddev->bitmap_info.space);
 	sb->daemon_sleep = cpu_to_le32(mddev->bitmap_info.daemon_sleep);
 
 	kunmap_local(sb);
@@ -1542,10 +1551,11 @@ static int llbitmap_get_stats(void *data, struct md_bitmap_stats *stats)
 	memset(stats, 0, sizeof(*stats));
 
 	stats->missing_pages = 0;
 	stats->pages = llbitmap->nr_pages;
 	stats->file_pages = llbitmap->nr_pages;
+	stats->sync_size = llbitmap->sync_size;
 
 	stats->behind_writes = atomic_read(&llbitmap->behind_writes);
 	stats->behind_wait = wq_has_sleeper(&llbitmap->behind_wait);
 	stats->events_cleared = llbitmap->events_cleared;
 
-- 
2.51.0

