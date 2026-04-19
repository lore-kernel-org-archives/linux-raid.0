Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D4F28469F;
	Sun, 19 Apr 2026 03:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568200; cv=none; b=QKweJLaZCmM0fK0vM9Sa7u1b/TcTFy8cvMKtdxBeMw28P0IZ3AxEgLzGCBxtpVxsTm5zole6CcAX7wZVkS/K7Nj4BLgUgVCGbQ3VexgtvBe+0rMgQGVU2kFRPvmIr9XsKjIhU+lFJvaz/XXHeW+ff2pm6WmGesFZ2576jnI83+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568200; c=relaxed/simple;
	bh=n1bk0g18fPyZF8doFUceYxwQaccP+IPL63TYbKi0mFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpTy+GRby62+Cl4x4aibbCT/xDpd0pFt+eBERLi6+4EDcZYcFYfMk81YrcWsQeULgQ0LWXP1QjF8cNtZZWg9XuCfcPdygKKB088B5jA7zpXbZBDfCg9xN9m2E+iijUNrk2kJVwIvnhLKKgPUcyTFK3JEts8gHi5+Ux3nB8FrJcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C244AC2BCB0;
	Sun, 19 Apr 2026 03:09:58 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/md-llbitmap: track bitmap sync_size explicitly
Date: Sun, 19 Apr 2026 11:09:26 +0800
Message-ID: <20260419030942.824195-4-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260419030942.824195-1-yukuai@fnnas.com>
References: <20260419030942.824195-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Track llbitmap's own sync_size instead of always using
mddev->resync_max_sectors directly.

This is the minimal bookkeeping needed before llbitmap can track old
and new reshape geometry independently.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 62b8f3efa9f5..547b1317df43 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -267,6 +267,8 @@ struct llbitmap {
 	unsigned long chunksize;
 	/* total number of chunks */
 	unsigned long chunks;
+	/* total number of sectors tracked by current bitmap geometry */
+	sector_t sync_size;
 	unsigned long last_end_sync;
 	/*
 	 * time in seconds that dirty bits will be cleared if the page is not
@@ -791,6 +793,7 @@ static int llbitmap_init(struct llbitmap *llbitmap)
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
+	llbitmap->sync_size = blocks;
 	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
 
 	ret = llbitmap_cache_pages(llbitmap);
@@ -811,6 +814,7 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	unsigned long daemon_sleep;
 	unsigned long chunksize;
 	unsigned long events;
+	sector_t sync_size;
 	struct page *sb_page;
 	bitmap_super_t *sb;
 	int ret = -EINVAL;
@@ -860,6 +864,9 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 		goto out_put_page;
 	}
 
+	sync_size = le64_to_cpu(sb->sync_size);
+	if (!sync_size)
+		sync_size = mddev->resync_max_sectors;
 	chunksize = le32_to_cpu(sb->chunksize);
 	if (!is_power_of_2(chunksize)) {
 		pr_err("md/llbitmap: %s: chunksize not a power of 2",
@@ -895,8 +902,9 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 
 	llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
 	llbitmap->chunksize = chunksize;
-	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors, chunksize);
+	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(sync_size, chunksize);
 	llbitmap->chunkshift = ffz(~chunksize);
+	llbitmap->sync_size = sync_size;
 	ret = llbitmap_cache_pages(llbitmap);
 
 out_put_page:
@@ -1026,6 +1034,7 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
+	llbitmap->sync_size = blocks;
 
 	return 0;
 }
@@ -1384,7 +1393,7 @@ static void llbitmap_update_sb(void *data)
 	sb->events = cpu_to_le64(mddev->events);
 	sb->state = cpu_to_le32(llbitmap->flags);
 	sb->chunksize = cpu_to_le32(llbitmap->chunksize);
-	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
+	sb->sync_size = cpu_to_le64(llbitmap->sync_size);
 	sb->events_cleared = cpu_to_le64(llbitmap->events_cleared);
 	sb->sectors_reserved = cpu_to_le32(mddev->bitmap_info.space);
 	sb->daemon_sleep = cpu_to_le32(mddev->bitmap_info.daemon_sleep);
@@ -1402,6 +1411,7 @@ static int llbitmap_get_stats(void *data, struct md_bitmap_stats *stats)
 	stats->missing_pages = 0;
 	stats->pages = llbitmap->nr_pages;
 	stats->file_pages = llbitmap->nr_pages;
+	stats->sync_size = llbitmap->sync_size;
 
 	stats->behind_writes = atomic_read(&llbitmap->behind_writes);
 	stats->behind_wait = wq_has_sleeper(&llbitmap->behind_wait);
-- 
2.51.0

