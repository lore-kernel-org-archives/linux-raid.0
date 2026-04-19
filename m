Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B2329E10F;
	Sun, 19 Apr 2026 03:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568202; cv=none; b=LCqTz+6AjlPixw4yqyj6NyxYzcBcoS14YcPldlmeHmlhuth1bY3OCGMZJXRc2BvUUhsT6mREq7hFJRY1t3xJzdug6Aga2H9vG3OSOW8w6I5tk3qBOUomgyx4Vd64wf7pERgaJauNKAVMecORQ9Ee/lIVtRBalV0c++rGzQ3RedM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568202; c=relaxed/simple;
	bh=dsevLQACM8eYda6YE0YBr+XY/DqudTaFEFlFPHzQyJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIcwb1d2DK3Rx/0PdIQi3AekJ1/Vht+EqX1V+NI5/JtVGWPLpcKI31tWVhwSgp8WvxdA52ojZhZRmdpJ4+1qZoCi6+74xWywKKxBlqa+ndQB8FeM7+5MxdefptapkmBR3EZczBeTZP8sNXvOGiY4keA3+JxjWpaiTJiy8Ss0T98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03493C2BCB0;
	Sun, 19 Apr 2026 03:10:00 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/md-llbitmap: allocate page controls independently
Date: Sun, 19 Apr 2026 11:09:27 +0800
Message-ID: <20260419030942.824195-5-yukuai@fnnas.com>
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

Allocate one llbitmap page-control object at a time and free each
object through the same model.

Let llbitmap_read_page() return a zeroed page without reading disk when
the page index is beyond the current bitmap size, so page-control
allocation no longer needs a separate read_existing flag.

This keeps the llbitmap page-control lifetime self-consistent and
prepares the page-cache code for later in-place growth.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 99 +++++++++++++++++++++++++---------------
 1 file changed, 62 insertions(+), 37 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 547b1317df43..a411041fd122 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -443,13 +443,19 @@ static void llbitmap_write(struct llbitmap *llbitmap, enum llbitmap_state state,
 		llbitmap_set_page_dirty(llbitmap, idx, bit);
 }
 
+static unsigned int llbitmap_used_pages(struct llbitmap *llbitmap,
+					unsigned long chunks)
+{
+	return DIV_ROUND_UP(chunks + BITMAP_DATA_OFFSET, PAGE_SIZE);
+}
+
 static struct page *llbitmap_read_page(struct llbitmap *llbitmap, int idx)
 {
 	struct mddev *mddev = llbitmap->mddev;
 	struct page *page = NULL;
 	struct md_rdev *rdev;
 
-	if (llbitmap->pctl && llbitmap->pctl[idx])
+	if (llbitmap->pctl && idx < llbitmap->nr_pages && llbitmap->pctl[idx])
 		page = llbitmap->pctl[idx]->page;
 	if (page)
 		return page;
@@ -457,6 +463,8 @@ static struct page *llbitmap_read_page(struct llbitmap *llbitmap, int idx)
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
+	if (idx >= llbitmap_used_pages(llbitmap, llbitmap->chunks))
+		return page;
 
 	rdev_for_each(rdev, mddev) {
 		sector_t sector;
@@ -527,61 +535,78 @@ static void llbitmap_free_pages(struct llbitmap *llbitmap)
 	for (i = 0; i < llbitmap->nr_pages; i++) {
 		struct llbitmap_page_ctl *pctl = llbitmap->pctl[i];
 
-		if (!pctl || !pctl->page)
-			break;
-
-		__free_page(pctl->page);
+		if (!pctl)
+			continue;
+		if (pctl->page)
+			__free_page(pctl->page);
 		percpu_ref_exit(&pctl->active);
+		kfree(pctl);
 	}
 
-	kfree(llbitmap->pctl[0]);
 	kfree(llbitmap->pctl);
 	llbitmap->pctl = NULL;
 }
 
-static int llbitmap_cache_pages(struct llbitmap *llbitmap)
+static struct llbitmap_page_ctl *
+llbitmap_alloc_page_ctl(struct llbitmap *llbitmap, int idx)
 {
 	struct llbitmap_page_ctl *pctl;
-	unsigned int nr_pages = DIV_ROUND_UP(llbitmap->chunks +
-					     BITMAP_DATA_OFFSET, PAGE_SIZE);
+	struct page *page;
 	unsigned int size = struct_size(pctl, dirty, BITS_TO_LONGS(
 						llbitmap->blocks_per_page));
-	int i;
-
-	llbitmap->pctl = kmalloc_array(nr_pages, sizeof(void *),
-				       GFP_KERNEL | __GFP_ZERO);
-	if (!llbitmap->pctl)
-		return -ENOMEM;
 
 	size = round_up(size, cache_line_size());
-	pctl = kmalloc_array(nr_pages, size, GFP_KERNEL | __GFP_ZERO);
-	if (!pctl) {
-		kfree(llbitmap->pctl);
-		return -ENOMEM;
+	pctl = kzalloc(size, GFP_KERNEL);
+	if (!pctl)
+		return ERR_PTR(-ENOMEM);
+
+	page = llbitmap_read_page(llbitmap, idx);
+
+	if (IS_ERR(page)) {
+		kfree(pctl);
+		return ERR_CAST(page);
 	}
 
-	llbitmap->nr_pages = nr_pages;
+	if (percpu_ref_init(&pctl->active, active_release,
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
+		__free_page(page);
+		kfree(pctl);
+		return ERR_PTR(-ENOMEM);
+	}
 
-	for (i = 0; i < nr_pages; i++, pctl = (void *)pctl + size) {
-		struct page *page = llbitmap_read_page(llbitmap, i);
+	pctl->page = page;
+	pctl->state = page_address(page);
+	init_waitqueue_head(&pctl->wait);
+	return pctl;
+}
 
-		llbitmap->pctl[i] = pctl;
+static unsigned int llbitmap_reserved_pages(struct llbitmap *llbitmap)
+{
+	return DIV_ROUND_UP(llbitmap->mddev->bitmap_info.space << SECTOR_SHIFT,
+			    PAGE_SIZE);
+}
 
-		if (IS_ERR(page)) {
-			llbitmap_free_pages(llbitmap);
-			return PTR_ERR(page);
-		}
+static int llbitmap_alloc_pages(struct llbitmap *llbitmap)
+{
+	unsigned int used_pages = llbitmap_used_pages(llbitmap, llbitmap->chunks);
+	unsigned int nr_pages = max(used_pages, llbitmap_reserved_pages(llbitmap));
+	int i;
+
+	llbitmap->pctl = kcalloc(nr_pages, sizeof(*llbitmap->pctl), GFP_KERNEL);
+	if (!llbitmap->pctl)
+		return -ENOMEM;
 
-		if (percpu_ref_init(&pctl->active, active_release,
-				    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
-			__free_page(page);
+	llbitmap->nr_pages = nr_pages;
+
+	for (i = 0; i < nr_pages; i++) {
+		llbitmap->pctl[i] = llbitmap_alloc_page_ctl(llbitmap, i);
+		if (IS_ERR(llbitmap->pctl[i])) {
+			int ret = PTR_ERR(llbitmap->pctl[i]);
+
+			llbitmap->pctl[i] = NULL;
 			llbitmap_free_pages(llbitmap);
-			return -ENOMEM;
+			return ret;
 		}
-
-		pctl->page = page;
-		pctl->state = page_address(page);
-		init_waitqueue_head(&pctl->wait);
 	}
 
 	return 0;
@@ -796,7 +821,7 @@ static int llbitmap_init(struct llbitmap *llbitmap)
 	llbitmap->sync_size = blocks;
 	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
 
-	ret = llbitmap_cache_pages(llbitmap);
+	ret = llbitmap_alloc_pages(llbitmap);
 	if (ret)
 		return ret;
 
@@ -905,7 +930,7 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(sync_size, chunksize);
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->sync_size = sync_size;
-	ret = llbitmap_cache_pages(llbitmap);
+	ret = llbitmap_alloc_pages(llbitmap);
 
 out_put_page:
 	__free_page(sb_page);
-- 
2.51.0

