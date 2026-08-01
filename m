Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F0D293B75;
	Sat,  1 Aug 2026 17:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605194; cv=none; b=SRkOJwxCeJcJZm09MQzg4MOcnQKaKvbBObVHtSK6ehgEMYrjqD7qc+FapsRSLejqUTfgNQalKnOk3FEMuwOjVv91XI+zqPyzBuM0e3/dblOoBKflVMhWiUJX7L1PcAtpEcqVwDQOH5CveF/5VJ7Na1sm4B9Dgt4XqC626702NiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605194; c=relaxed/simple;
	bh=sxztiZsntBGoopWMfkVZWBEcUGCCYqcfpusnDJ0LYVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvLIRJCZcfoON64Fwraw5ed1Pk/30r+HqQTH+PeziCqaeyL6zJyAbmGSFWO5mKj11Wbm1oj1OfoQ7ifM9j8jQlIWsiQBJuFOQ2lNFNcDiMTQ/ET64E28U4cJq+xfTJEwvM/LxNOQSo6LM8ykM5QH6HB1nlghQBPsYAXQt8F5dsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApRAM8Qw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApRAM8Qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CDB1F00ACA;
	Sat,  1 Aug 2026 17:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605192;
	bh=8T7z6zE1DRCHlXBTFApun4GqHVSJvWoRYVkPWeEGdCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApRAM8QwsSNvmrZXzLR6DKlvezQiHkfTXuibYke/kCTA4a+Db7QZFUhxyjMabCqr5
	 eRgkPSklGFAW7OEbenwpZZUYE5s95dHmzPzhnU5W7WsW+3yZr3BO2M/gnOaIn3DyaC
	 LOnA3v8sJNRN+dyJ2s8xa0YEtWGR7RkkXP1HUs30PqvksFzEoaka0JMnz1k+UnKwhU
	 +EsscKFqOl90YOD413fs32VYkHzSDTPMukoZqZ1Sh9fWLBbTBxgE6U6rwrUXw747++
	 6xy4XR+f4CSqZRHps0J+ehDJ/ycQErt98qREnDK38PVwThmZpjGLG4gNAqZVqSa3CX
	 vOlDHWDIDzWnQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 09/25] md/md-llbitmap: track bitmap sync_size explicitly
Date: Sun,  2 Aug 2026 01:25:03 +0800
Message-ID: <20260801172519.2982121-10-yukuai@kernel.org>
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

Track llbitmap's own sync_size instead of always using
mddev->resync_max_sectors directly.

This is the minimal bookkeeping needed before llbitmap can track old
and new reshape geometry independently.

Reviewed-by: Su Yue <glass.su@suse.com>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 1fa2adf0ada1..3417da288e99 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -287,6 +287,8 @@ struct llbitmap {
 	unsigned long chunksize;
 	/* total number of chunks */
 	unsigned long chunks;
+	/* total number of sectors tracked by current bitmap geometry */
+	sector_t sync_size;
 	unsigned long last_end_sync;
 	/*
 	 * time in seconds that dirty bits will be cleared if the page is not
@@ -918,6 +920,7 @@ static int llbitmap_init(struct llbitmap *llbitmap)
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
+	llbitmap->sync_size = blocks;
 	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
 
 	ret = llbitmap_cache_pages(llbitmap);
@@ -938,6 +941,7 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	unsigned long daemon_sleep;
 	unsigned long chunksize;
 	unsigned long events;
+	sector_t sync_size;
 	struct page *sb_page;
 	bitmap_super_t *sb;
 	int ret = -EINVAL;
@@ -987,6 +991,9 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 		goto out_put_page;
 	}
 
+	sync_size = le64_to_cpu(sb->sync_size);
+	if (!sync_size)
+		sync_size = mddev->resync_max_sectors;
 	chunksize = le32_to_cpu(sb->chunksize);
 	if (!is_power_of_2(chunksize)) {
 		pr_err("md/llbitmap: %s: chunksize not a power of 2",
@@ -1022,8 +1029,9 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 
 	llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
 	llbitmap->chunksize = chunksize;
-	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors, chunksize);
+	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(sync_size, chunksize);
 	llbitmap->chunkshift = ffz(~chunksize);
+	llbitmap->sync_size = sync_size;
 	ret = llbitmap_cache_pages(llbitmap);
 
 out_put_page:
@@ -1153,6 +1161,7 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
+	llbitmap->sync_size = blocks;
 
 	return 0;
 }
@@ -1531,7 +1540,7 @@ static void llbitmap_update_sb(void *data)
 	sb->events = cpu_to_le64(mddev->events);
 	sb->state = cpu_to_le32(llbitmap->flags);
 	sb->chunksize = cpu_to_le32(llbitmap->chunksize);
-	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
+	sb->sync_size = cpu_to_le64(llbitmap->sync_size);
 	sb->events_cleared = cpu_to_le64(llbitmap->events_cleared);
 	sb->sectors_reserved = cpu_to_le32(mddev->bitmap_info.space);
 	sb->daemon_sleep = cpu_to_le32(mddev->bitmap_info.daemon_sleep);
@@ -1549,6 +1558,7 @@ static int llbitmap_get_stats(void *data, struct md_bitmap_stats *stats)
 	stats->missing_pages = 0;
 	stats->pages = llbitmap->nr_pages;
 	stats->file_pages = llbitmap->nr_pages;
+	stats->sync_size = llbitmap->sync_size;
 
 	stats->behind_writes = atomic_read(&llbitmap->behind_writes);
 	stats->behind_wait = wq_has_sleeper(&llbitmap->behind_wait);
-- 
2.51.0

