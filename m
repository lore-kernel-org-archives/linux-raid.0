Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABAA33438F;
	Sun,  2 Aug 2026 19:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700295; cv=none; b=i/nbWjyb/6/I347yBMfD5191iqZsJzpGZRTzkDQHzrAs6YF3SF1QANfeV7RjFH2qO9gn2+GOg3nYs3bOISSxb/OPtmLHY44Vw2fTCrH5X+hYFFoIzh5K6aDz7DDEdTjczBTaPdJksk/hsVwO1mOJZdvcsn+bkb4et4meULoV0BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700295; c=relaxed/simple;
	bh=1fgKUBcxD4P8+lhYLHQSlrFUNbopgHPT3RBPVc1bQtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/8Diz3kBfFqTkdYQiHu/gK2PN9nWRWnDcDNkEAXH9IfM4o+RZq/K6GemWLyBZ4mS5cy6woj301ibK5Gh95n+BwVetRu+9HCQN2YhkxQUxCFYnUVQm205IX+cDT9zm2e4N97ENVKdkXEX7FYsXjHNB7dos2XrigoQhZM/SRPjG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B1DS+0Xh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B1DS+0Xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E5A1F00A3A;
	Sun,  2 Aug 2026 19:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700293;
	bh=PmCAlxRFFGz9k8RIIZAA8jwmjrvbF5WiJfnuAFxFCHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1DS+0Xha3xJwURwEzMbTfxSecJ191iXlDK+v3Ty4U7HRAx0UcKXnvC+tjYtNgamN
	 Q+gJDga/yeYTfoQmfL74Q7kzzl/8VO5iZ8waqBX7aEkq6jg/fki0Ikz6EITsI6xJpC
	 6rqDYY9IYfFDp+H/aNaZsYgh7ujxNhxWjagommyscHV47bNBi/IZeuJbXJLjpBbJgE
	 5u4Vx+TWa8dvnG1aCWXkf/AvVu43wG0SI73zF00l8qpHbR/Tq6z23TG7x0WQdJuK3V
	 Mla/flHudBhP/5YrQKYMO1oyLiBcjkB1KQrrUMsTUu4iZQaM9wp4UqnKj7SpVPmICC
	 b7h6Xj2Rv0dag==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 13/29] md/md-llbitmap: track bitmap sync_size explicitly
Date: Mon,  3 Aug 2026 03:50:22 +0800
Message-ID: <20260802195038.164272-14-yukuai@kernel.org>
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

Track llbitmap's own sync_size instead of always using
mddev->resync_max_sectors directly.

This is the minimal bookkeeping needed before llbitmap can track old
and new reshape geometry independently.

Reviewed-by: Su Yue <glass.su@suse.com>
Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 4583bbc37c2e..0813cebfbdeb 100644
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
@@ -919,6 +921,7 @@ static int llbitmap_init(struct llbitmap *llbitmap)
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
+	llbitmap->sync_size = blocks;
 	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
 
 	ret = llbitmap_cache_pages(llbitmap);
@@ -939,6 +942,7 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	unsigned long daemon_sleep;
 	unsigned long chunksize;
 	unsigned long events;
+	sector_t sync_size;
 	struct page *sb_page;
 	bitmap_super_t *sb;
 	int ret = -EINVAL;
@@ -988,6 +992,14 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 		goto out_put_page;
 	}
 
+	sync_size = le64_to_cpu(sb->sync_size);
+	if (!sync_size)
+		sync_size = mddev->resync_max_sectors;
+	if (sync_size > mddev->resync_max_sectors) {
+		pr_err("md/llbitmap: %s: sync_size %llu exceeds array sync size %llu",
+		       mdname(mddev), sync_size, mddev->resync_max_sectors);
+		goto out_put_page;
+	}
 	chunksize = le32_to_cpu(sb->chunksize);
 	if (!is_power_of_2(chunksize)) {
 		pr_err("md/llbitmap: %s: chunksize not a power of 2",
@@ -1023,8 +1035,9 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 
 	llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
 	llbitmap->chunksize = chunksize;
-	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors, chunksize);
+	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(sync_size, chunksize);
 	llbitmap->chunkshift = ffz(~chunksize);
+	llbitmap->sync_size = sync_size;
 	ret = llbitmap_cache_pages(llbitmap);
 
 out_put_page:
@@ -1161,6 +1174,7 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
+	llbitmap->sync_size = blocks;
 
 	return 0;
 }
@@ -1541,7 +1555,7 @@ static void llbitmap_update_sb(void *data)
 	sb->events = cpu_to_le64(mddev->events);
 	sb->state = cpu_to_le32(llbitmap->flags & ~BIT(BITMAP_SHUTDOWN));
 	sb->chunksize = cpu_to_le32(llbitmap->chunksize);
-	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
+	sb->sync_size = cpu_to_le64(llbitmap->sync_size);
 	sb->events_cleared = cpu_to_le64(llbitmap->events_cleared);
 	sb->sectors_reserved = cpu_to_le32(mddev->bitmap_info.space);
 	sb->daemon_sleep = cpu_to_le32(mddev->bitmap_info.daemon_sleep);
@@ -1559,6 +1573,7 @@ static int llbitmap_get_stats(void *data, struct md_bitmap_stats *stats)
 	stats->missing_pages = 0;
 	stats->pages = llbitmap->nr_pages;
 	stats->file_pages = llbitmap->nr_pages;
+	stats->sync_size = llbitmap->sync_size;
 
 	stats->behind_writes = atomic_read(&llbitmap->behind_writes);
 	stats->behind_wait = wq_has_sleeper(&llbitmap->behind_wait);
-- 
2.51.0

