Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1DD4C77A1;
	Fri,  5 Jun 2026 09:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650945; cv=none; b=Ca+L2PsnWvpCWCr4rCF1YWIdyU3Ns+Wjd33gwHJU98D8J5WkCayQ4NHxH6vtDJRc+34LsWcOnlRvT424jM7CeS48yiJI03Qei4rAGbwDPs7Of0l/rf7daZ3KxvVT/DvycZtjBzXLKrtsJpJLng1bP4ONDdLV6tlD36+Qfk3d7C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650945; c=relaxed/simple;
	bh=g9QzSIb3cgMbpC82UPUod+TSxjOXoqWQLjKugm/6axM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvB3zgRPZ2Rjq6wkcKm729vaq7gHgg/IO3/NjzQPdP6i5tfTOJwGePzyTKDnCJrYHR5CMSc8K5k4STJiMQyHXDl7uJKByV3eAn12C9Lii+/LdBO1fFBZIS8WHVpvq8IJnZibzNc9TYw0c0yvaT2DjQMVKF8JYTZATIFMnTZJ6jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uk0ipZ9c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uk0ipZ9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC75F1F00898;
	Fri,  5 Jun 2026 09:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650942;
	bh=tAZnvxIn3mokvPTnfCz9RN0Q6N8p/RBJ5qwLvrjJicw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uk0ipZ9chmnm0o9mJQ+ON7YEV1WQVzRDM+6H8bfIFVyyLdWUFNT5+6gNUT5aOcvgV
	 DMxO+4yl4vKqC6h/wafTfTbiGPzKRfJDNS+R0QoHGRNjvlylKx5O/ea1dgtqtY/q6i
	 sXe8sEVZWU/XKLiY4ktITIrMSayrlLuZawRFf3O7aSFVVtrq2/RxrIsi5mnfPW1H2U
	 w7+V0J/S1QkSB91YUYd5w/pL2D5OeMDS2x+yY7ywhNS9wfxLxLxhMs4ZM2OicQzaY7
	 6KRXYMVcKNuO5dIkn7kAxdP8QQDR54sKoLigZuHa2KW51XwwB4CNYCiYLWPe4fgjG5
	 wLrrhntxsPOmQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/md-llbitmap: allocate page controls independently
Date: Fri,  5 Jun 2026 17:15:12 +0800
Message-ID: <20260605091527.2463539-6-yukuai@kernel.org>
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

Allocate one llbitmap page-control object at a time and free each
object through the same model.

Let llbitmap_read_page() return a zeroed page without reading disk when
the page index is beyond the current bitmap size, so page-control
allocation no longer needs a separate read_existing flag.

This keeps the llbitmap page-control lifetime self-consistent and
prepares the page-cache code for later in-place growth.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 99 +++++++++++++++++++++++++---------------
 1 file changed, 62 insertions(+), 37 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index ecf3ed712315..2f2896fe4d6f 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -510,24 +510,32 @@ static void llbitmap_write(struct llbitmap *llbitmap, enum llbitmap_state state,
 		llbitmap_set_page_dirty(llbitmap, idx, bit, true);
 	else if (state == BitNeedSyncUnwritten)
 		llbitmap_set_page_dirty(llbitmap, idx, bit, false);
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
 
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
+	if (idx >= llbitmap_used_pages(llbitmap, llbitmap->chunks))
+		return page;
 
 	rdev_for_each(rdev, mddev) {
 		sector_t sector;
 
 		if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags) ||
@@ -594,65 +602,82 @@ static void llbitmap_free_pages(struct llbitmap *llbitmap)
 		return;
 
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
 }
 
@@ -921,11 +946,11 @@ static int llbitmap_init(struct llbitmap *llbitmap)
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
 	llbitmap->sync_size = blocks;
 	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
 
-	ret = llbitmap_cache_pages(llbitmap);
+	ret = llbitmap_alloc_pages(llbitmap);
 	if (ret)
 		return ret;
 
 	llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1,
 			       BitmapActionInit);
@@ -1030,11 +1055,11 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(sync_size, chunksize);
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->sync_size = sync_size;
-	ret = llbitmap_cache_pages(llbitmap);
+	ret = llbitmap_alloc_pages(llbitmap);
 
 out_put_page:
 	__free_page(sb_page);
 	kunmap_local(sb);
 	return ret;
-- 
2.51.0

