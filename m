Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8009A29BDBB;
	Sun, 19 Apr 2026 03:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568204; cv=none; b=KnuO+RpL0SU/ds2GOldbr9riMf99aJn2SLzbd7pF1sc71O0B/L1W8+WrlJnpjQ6W9ySvhP4QnuLE+dIlcp/B+uEVGDkuXmdrBGTLlFqC3rtb/EzBLQrf51yliLKYavEEqcAublhb36Dg+p6PJ1ErYpftbT3u9XEjp5BLf8XrPkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568204; c=relaxed/simple;
	bh=b5SBEGwIq8pElQYKKOydPgpgFkTte+DkmJYIsP61dcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7U0ci8M/wd3TCHe15zcbFJd+2V/1mM9lnhYim+GZDv5JA3xtYxPogvWEOmO793s05sKZ0OPPC3pZst8eVCDkD3bl6+d/bDmXUGjD8jW817i0fPzknW+STMiLiiwjB1ySITfUrCelHZWxPirO6KSr/E2pXy2g0IaD2ool7Q40Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF411C2BCB0;
	Sun, 19 Apr 2026 03:10:02 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/md-llbitmap: grow the page cache in place for reshape
Date: Sun, 19 Apr 2026 11:09:28 +0800
Message-ID: <20260419030942.824195-6-yukuai@fnnas.com>
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

Use the page-control helpers to grow llbitmap's cached pages in place
for resize and later reshape preparation, instead of rebuilding the
whole cache.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 139 +++++++++++++++++++++++++++++++++++----
 1 file changed, 127 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index a411041fd122..841b64f0b4e6 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -350,6 +350,19 @@ static char state_machine[BitStateCount][BitmapActionCount] = {
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
@@ -586,6 +599,48 @@ static unsigned int llbitmap_reserved_pages(struct llbitmap *llbitmap)
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
@@ -612,6 +667,34 @@ static int llbitmap_alloc_pages(struct llbitmap *llbitmap)
 	return 0;
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
 	enum llbitmap_state state = BitUnwritten;
@@ -899,10 +982,10 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
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
@@ -1044,24 +1127,56 @@ static int llbitmap_create(struct mddev *mddev)
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
-- 
2.51.0

