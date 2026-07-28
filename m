Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587963E0C67;
	Tue, 28 Jul 2026 08:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228594; cv=none; b=NsI8V3toHYisbGH+z3HtSFUs9eUr87KwTyOXHrD9HFV3eK1U1hJj5TXB16BwXGqxPGVMmz7XqP5jhqLKX7K8jn7hE1LhYPL1tfMXOPOwuHbKrw1Kjp6uEN+1Ogklt07k7bZI+vO5dhnz6znQM1VAXvE7WfdfyrY2Sb6uSZrA15s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228594; c=relaxed/simple;
	bh=4WXJ7A85J2XVuqFAw7qrHw7WdCExoedrSVahRn4FKG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VI07zP505JS3nobFstWVCF4fJu6MHAeMMX53n0PUbOFuCatOht/2DtKsQeQ7mEn7NHMLAOrxtulMMLw7mYH+M7Hfy3B6D4DOBe3sKFVMiB5XgzqsaFndAyWYOHpAOvU3/BAVC+i7z9YAKisSY5udDMXgVTBn42DyzXGj9CvmFp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Moi+Hybz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Moi+Hybz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DAA1F000E9;
	Tue, 28 Jul 2026 08:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228592;
	bh=VKGscNHx4sfyVarw7rBFoxGPx9jfEpX/oWEpTwqcabk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Moi+Hybzhqm/N1uScubDjWEwxJ7gq6Cq88NgtHgQRQTVeUpa8dJ7VxJTJCvfRcVuc
	 gtiDaLeBNQAjHJFphtOYXrNDc0y+HR742ROeVqkDEEyAtI1O9hkVcdQ6O16w5bWqSn
	 tf5fMUHY447EvuKHXAr9Oe/do07d5tk5S0lj1Wwpo/xdPSJ3x2sqYGPH8xB7Ba5F+b
	 Z6+zlctITQAVIXImOCPBgt9BX7KNJwam+J8stMKD9bpVbX3bVrUsp1PRP604lZCiZz
	 0ZQ2u1zyPlluZ/gFyIG9gBezp0FB1oj6evRANXHeMnRbwoA61TgbdKttOUfUAQco4T
	 /iEdK1GD8yHmw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 05/21] md/md-llbitmap: track bitmap sync_size explicitly
Date: Tue, 28 Jul 2026 16:49:05 +0800
Message-ID: <c7c477a0e0203fd6ce98e49cd0cc1382b1786f4d.1785206690.git.yukuai@fygo.io>
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

