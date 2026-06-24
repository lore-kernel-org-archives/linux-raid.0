Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D20138910D;
	Wed, 24 Jun 2026 06:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283357; cv=none; b=JwLvniBYFcY79tnWoxLXwZkXMwZAu+eAEksITAUqSP0tJbR3zH/yi5ZCcuxeRqG56eK8IfF62+pPKwPG0qnRwzRtjY0D+reUWXmDvd301XikOyyQVgoYcs5rrGcTEi6sazSgChnmgimze6Kz5cnQEmXHvPDfuDHKvYImXOZT6C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283357; c=relaxed/simple;
	bh=p9rOiGodaNvb0epoVAkIUrMesG4kz3HRfxK4dVNMyuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slGYrlbNHvQvUpx2JsD/YCsYRnJc30qCG0/Rwx3mM18XojBILBpNVdz/m1LRfqrcu64nx7ID4tnzinKVg1zNN0jZUeq2vDq3jGOwwu0rdNv7yLHdD+AloBSCG7P5bdzdxGRxXXEAhfqRpHsV15ZkX82W1u7oUy8OH+PSNVsxrlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iek7zAzh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iek7zAzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66041F000E9;
	Wed, 24 Jun 2026 06:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283353;
	bh=xTbRkJZcloDe6TO9yUQRFhZHfP96MVbzpZcaiEh7Sx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iek7zAzhLq8CkgAtoEHOK4mBPITU5gtCwnjtRiGoLRhfAdO+HATmDic33/ZI8LfcO
	 JvZumMzPgeAOXIuYkCyJSsQ6CEn+qu4jnqd39ByfjE5ZHaP2YtMW18XAiW0oF2QvIG
	 U9xvZfp41fRxN/csxRO8XSNpPM53a7rIDF08FsyhfTyd99fELUxW8owC6b7+CQVd+W
	 HE0WqL29DR3uUfZrQSMhLZgkGaO+GNQ+1SKglCnn6Y2ndnLFAe3CYKNp7Okw3uP2Wa
	 hG215xgl+JnnZ3fHjY4+/1ZsiDwrGiAXscF+b/I+51dL4UKvahkkrZIem1hyGVDxNw
	 Pf09FsfNhDeMQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/20] md/md-llbitmap: track bitmap sync_size explicitly
Date: Wed, 24 Jun 2026 14:42:01 +0800
Message-ID: <2fd017b2cb7bbeb49f0a1b8e0d413c0822f80885.1782282042.git.yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org> <cover.1782282042.git.yukuai@kernel.org>
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
Reviewed-by: Su Yue <glass.su@suse.com>
---
 drivers/md/md-llbitmap.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index f0c20afa354e..e3500a1a52c0 100644
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
@@ -1526,7 +1535,7 @@ static void llbitmap_update_sb(void *data)
 	sb->events = cpu_to_le64(mddev->events);
 	sb->state = cpu_to_le32(llbitmap->flags);
 	sb->chunksize = cpu_to_le32(llbitmap->chunksize);
-	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
+	sb->sync_size = cpu_to_le64(llbitmap->sync_size);
 	sb->events_cleared = cpu_to_le64(llbitmap->events_cleared);
 	sb->sectors_reserved = cpu_to_le32(mddev->bitmap_info.space);
 	sb->daemon_sleep = cpu_to_le32(mddev->bitmap_info.daemon_sleep);
@@ -1544,6 +1553,7 @@ static int llbitmap_get_stats(void *data, struct md_bitmap_stats *stats)
 	stats->missing_pages = 0;
 	stats->pages = llbitmap->nr_pages;
 	stats->file_pages = llbitmap->nr_pages;
+	stats->sync_size = llbitmap->sync_size;
 
 	stats->behind_writes = atomic_read(&llbitmap->behind_writes);
 	stats->behind_wait = wq_has_sleeper(&llbitmap->behind_wait);
-- 
2.51.0

