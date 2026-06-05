Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398294DA539;
	Fri,  5 Jun 2026 09:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650947; cv=none; b=cshXbXc9RTqO3WvfSw7royxA9jj9w6285s4KEXbdefXYosAHUSq2EeU9OKCUNhQwlEHXIMb+qxE6ZArjKMxqbxIMk8bJpkiMIeykadwHgynw6bCyyJWaKvvS5L9aexcpPDDVHWoGlEgh3nH1E+3do+IxnbdU+qGkfBySJdMoZxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650947; c=relaxed/simple;
	bh=xruc5OmNokWSJ8LTxVsy93uHYlm3isCLYZp1wOWtoLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLA2tXEr5wTkgp3aG+PRcQsN9zj6h3pW/cBaMWkfrGDo7n7iVz+Udu+RTh8M7pjwEogQ4OxHWSrzvdFZIziCx4VgX09bNNqD2fnEq8290uU3jQ2yZhAxdYoJQ8GXoTZADA0i9qHxDHAZsAAZCeHzI8nT2VeizOjWg5nJL82ahNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fREJPASd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fREJPASd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9091F00899;
	Fri,  5 Jun 2026 09:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650944;
	bh=0vkGs6FQV9ITlahTXOVy8IxmtxhdPcsGm5p/oSYXumU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fREJPASd7p02nkM9nXquVOwiw4jqwBnAgbqFitZBPDRIZPBEtN0JZOKkY1XWoz0yr
	 LzY8eS1EHVDblP7V1Pn/773OKle87EwEQfd6NtgTafDJJcsa+ViHaKUNBBYNai1GoN
	 xEZ1xdU/yut8Tyrsy4NVRPqFMFVTMpHMv/2PeLR55HTniMuLqbTZ7CRSOH0KwZm5QI
	 8aXVakQHi/w5DfK9yATW+/cyQMeKYtxWh+pwFNQCIjqUhCOrDJbkv/PPLgpGQj33g0
	 rP2VM6m27hRmAun3O6E1iuTr6GfVu5p4mWN5Xo7TXH4DvgbzHbui6K/7fZ/SpIycp3
	 L2S+6qBEjLYoA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/md-llbitmap: grow the page cache in place for reshape
Date: Fri,  5 Jun 2026 17:15:13 +0800
Message-ID: <20260605091527.2463539-7-yukuai@kernel.org>
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

Use the page-control helpers to grow llbitmap's cached pages in place
for resize and later reshape preparation, instead of rebuilding the
whole cache.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 139 +++++++++++++++++++++++++++++++++++----
 1 file changed, 127 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 2f2896fe4d6f..91d3dec43d48 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -414,10 +414,23 @@ static char state_machine[BitStateCount][BitmapActionCount] = {
 		[BitmapActionClearUnwritten]	= BitUnwritten,
 	},
 };
 
 static void __llbitmap_flush(struct mddev *mddev);
+static void llbitmap_flush(struct mddev *mddev);
+static void llbitmap_update_sb(void *data);
+
+static void llbitmap_resize_chunks(struct mddev *mddev, sector_t blocks,
+				   unsigned long *chunksize,
+				   unsigned long *chunks)
+{
+	*chunks = DIV_ROUND_UP_SECTOR_T(blocks, *chunksize);
+	while (*chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {
+		*chunksize = *chunksize << 1;
+		*chunks = DIV_ROUND_UP_SECTOR_T(blocks, *chunksize);
+	}
+}
 
 static enum llbitmap_state llbitmap_read(struct llbitmap *llbitmap, loff_t pos)
 {
 	unsigned int idx;
 	unsigned int offset;
@@ -653,10 +666,52 @@ static unsigned int llbitmap_reserved_pages(struct llbitmap *llbitmap)
 {
 	return DIV_ROUND_UP(llbitmap->mddev->bitmap_info.space << SECTOR_SHIFT,
 			    PAGE_SIZE);
 }
 
+static int llbitmap_expand_pages(struct llbitmap *llbitmap,
+				 unsigned long chunks)
+{
+	struct llbitmap_page_ctl **pctl;
+	unsigned int old_nr_pages = llbitmap->nr_pages;
+	unsigned int nr_pages = llbitmap_used_pages(llbitmap, chunks);
+	int i;
+	int ret;
+
+	if (nr_pages <= old_nr_pages)
+		return 0;
+
+	pctl = kcalloc(nr_pages, sizeof(*pctl), GFP_KERNEL);
+	if (!pctl)
+		return -ENOMEM;
+
+	if (llbitmap->pctl)
+		memcpy(pctl, llbitmap->pctl,
+		       array_size(old_nr_pages, sizeof(*pctl)));
+
+	for (i = old_nr_pages; i < nr_pages; i++) {
+		pctl[i] = llbitmap_alloc_page_ctl(llbitmap, i);
+		if (IS_ERR(pctl[i]))
+			goto err_alloc_ptr;
+	}
+
+	kfree(llbitmap->pctl);
+	llbitmap->pctl = pctl;
+	llbitmap->nr_pages = nr_pages;
+	return 0;
+
+err_alloc_ptr:
+	ret = PTR_ERR(pctl[i]);
+	for (i--; i >= (int)old_nr_pages; i--) {
+		__free_page(pctl[i]->page);
+		percpu_ref_exit(&pctl[i]->active);
+		kfree(pctl[i]);
+	}
+	kfree(pctl);
+	return ret;
+}
+
 static int llbitmap_alloc_pages(struct llbitmap *llbitmap)
 {
 	unsigned int used_pages = llbitmap_used_pages(llbitmap, llbitmap->chunks);
 	unsigned int nr_pages = max(used_pages, llbitmap_reserved_pages(llbitmap));
 	int i;
@@ -728,10 +783,38 @@ static bool llbitmap_zero_all_disks(struct llbitmap *llbitmap)
 	}
 
 	return true;
 }
 
+static void llbitmap_mark_range(struct llbitmap *llbitmap,
+				unsigned long start,
+				unsigned long end,
+				enum llbitmap_state state)
+{
+	while (start <= end) {
+		llbitmap_write(llbitmap, state, start);
+		start++;
+	}
+}
+
+static int llbitmap_prepare_resize(struct llbitmap *llbitmap,
+				   unsigned long old_chunks,
+				   unsigned long new_chunks,
+				   unsigned long cache_chunks)
+{
+	int ret;
+
+	llbitmap_flush(llbitmap->mddev);
+	ret = llbitmap_expand_pages(llbitmap, cache_chunks);
+	if (ret)
+		return ret;
+	if (new_chunks > old_chunks)
+		llbitmap_mark_range(llbitmap, old_chunks, new_chunks - 1,
+				    BitUnwritten);
+	return 0;
+}
+
 static void llbitmap_init_state(struct llbitmap *llbitmap)
 {
 	struct mddev *mddev = llbitmap->mddev;
 	enum llbitmap_state state = BitUnwritten;
 	unsigned long i;
@@ -1024,14 +1107,14 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 		pr_err("md/llbitmap: %s: chunksize not a power of 2",
 		       mdname(mddev));
 		goto out_put_page;
 	}
 
-	if (chunksize < DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors,
+	if (chunksize < DIV_ROUND_UP_SECTOR_T(sync_size,
 					      mddev->bitmap_info.space << SECTOR_SHIFT)) {
 		pr_err("md/llbitmap: %s: chunksize too small %lu < %llu / %lu",
-		       mdname(mddev), chunksize, mddev->resync_max_sectors,
+		       mdname(mddev), chunksize, sync_size,
 		       mddev->bitmap_info.space);
 		goto out_put_page;
 	}
 
 	daemon_sleep = le32_to_cpu(sb->daemon_sleep);
@@ -1169,28 +1252,60 @@ static int llbitmap_create(struct mddev *mddev)
 }
 
 static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
+	sector_t old_blocks = llbitmap->sync_size;
+	unsigned long old_chunks = llbitmap->chunks;
 	unsigned long chunks;
+	unsigned long cache_chunks;
+	int ret = 0;
+	unsigned long bitmap_chunksize;
+	bool reshape;
 
 	if (chunksize == 0)
 		chunksize = llbitmap->chunksize;
 
-	/* If there is enough space, leave the chunksize unchanged. */
-	chunks = DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
-	while (chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {
-		chunksize = chunksize << 1;
-		chunks = DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
-	}
+	bitmap_chunksize = chunksize;
+	llbitmap_resize_chunks(mddev, blocks, &bitmap_chunksize, &chunks);
 
-	llbitmap->chunkshift = ffz(~chunksize);
-	llbitmap->chunksize = chunksize;
-	llbitmap->chunks = chunks;
-	llbitmap->sync_size = blocks;
+	reshape = mddev->delta_disks || mddev->new_level != mddev->level ||
+		mddev->new_layout != mddev->layout ||
+		mddev->new_chunk_sectors != mddev->chunk_sectors;
+	if (!reshape && bitmap_chunksize != llbitmap->chunksize)
+		return -EOPNOTSUPP;
+	if (blocks == old_blocks && chunks == llbitmap->chunks)
+		return 0;
+
+	mutex_lock(&mddev->bitmap_info.mutex);
 
+	cache_chunks = reshape ? max(old_chunks, chunks) : chunks;
+	ret = llbitmap_prepare_resize(llbitmap, old_chunks, chunks, cache_chunks);
+	if (ret)
+		goto out;
+
+	if (reshape) {
+		llbitmap->reshape_sync_size = blocks;
+		llbitmap->reshape_chunksize = bitmap_chunksize;
+		llbitmap->reshape_chunks = chunks;
+		llbitmap->chunks = max(old_chunks, chunks);
+	} else {
+		if (blocks < old_blocks && chunks < old_chunks)
+			llbitmap_mark_range(llbitmap, chunks, old_chunks - 1,
+					    BitUnwritten);
+		mddev->bitmap_info.chunksize = bitmap_chunksize;
+		llbitmap->chunks = chunks;
+		llbitmap->sync_size = blocks;
+		llbitmap_update_sb(llbitmap);
+	}
+	__llbitmap_flush(mddev);
+	mutex_unlock(&mddev->bitmap_info.mutex);
 	return 0;
+
+out:
+	mutex_unlock(&mddev->bitmap_info.mutex);
+	return ret;
 }
 
 static int llbitmap_load(struct mddev *mddev)
 {
 	enum llbitmap_action action = BitmapActionReload;
-- 
2.51.0

