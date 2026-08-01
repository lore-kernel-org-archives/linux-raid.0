Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9699293B75;
	Sat,  1 Aug 2026 17:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605199; cv=none; b=Bip8tnk1X20YmbqJjRAobGJBqd+SjNr5+3A1cMyBhhLFnSeOlvCmona2l8N8VyU1daVwxPdGaUwTHx6m9wGChR3htYwaGEHxUpbRAFdMp4M1BR6aQkrKFljSbHkEJgXn4YddZYHf/1dxZeUGOZogvZJH4wyDi40/CpM0hwSkLCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605199; c=relaxed/simple;
	bh=yk7MBIPeUNxvxdvjxe9f9UroH6zmadqsEUO9nnfuDkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGR5uwD1+yntyINHl7emOz0he9kUJ0QrBb2EOx3t0RJxpzDSADxDThAxddGAwiYAx8qzl0jC+B8MZ24Ie6/BRp9MbTH/Njj5vAb2cLz/fW3aGJpt/NdYsfU+/CY69F7UgiT0nwlei8c54k3lSxb5zuh5jr6K89mmGOsQHgbzMq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PW7P4QCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PW7P4QCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7951F00AC4;
	Sat,  1 Aug 2026 17:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605198;
	bh=ODxctGXeIkLTt4O0gJZ8fAvQeDr5IJX0zPywdYsaZtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PW7P4QCqfGAC+xNMFwqflrGXUNSUBo2iWbUNCO/i1b//ehE6cmvP2X44xbsuejVYP
	 99rljFECbjm5sC3p7QGEuXvH83QsS/oJ8G0H+En/7gT1VlPk2SAroMMHsyP0rnBcdw
	 KIgmY1zQBF4+jCEo0v4VLd5hD0YDWqpBD9A952K7R3PLt9Rl2nMxCKPwBIaYRZfwxt
	 XddI6uXzTdm/tQRb8158N4YhkguZTzbblzkCDclF7Dq4E5Lb3iDb1mOGLkVwGwHJrP
	 gwRlDuyG+sUC0YS3gKdYrN4BqkiT928qJatRivw7K/kgKKHUxJGLVYjKCV/GnFmFkt
	 B4oSiF7Kpd1eg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/25] md/md-llbitmap: allocate page controls independently
Date: Sun,  2 Aug 2026 01:25:04 +0800
Message-ID: <20260801172519.2982121-11-yukuai@kernel.org>
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

Allocate one llbitmap page-control object at a time and free each
object through the same model.

Let llbitmap_read_page() return a zeroed page without reading disk when
the page index is beyond the current bitmap size, so page-control
allocation no longer needs a separate read_existing flag.

This keeps the llbitmap page-control lifetime self-consistent and
prepares the page-cache code for later in-place growth.

Reviewed-by: Su Yue <glass.su@suse.com>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 99 +++++++++++++++++++++++++---------------
 1 file changed, 62 insertions(+), 37 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 3417da288e99..d12b3dba6ae1 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -512,13 +512,19 @@ static void llbitmap_write(struct llbitmap *llbitmap, enum llbitmap_state state,
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
@@ -526,6 +532,8 @@ static struct page *llbitmap_read_page(struct llbitmap *llbitmap, int idx)
 	page = alloc_page(GFP_NOIO | __GFP_ZERO);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
+	if (idx >= llbitmap_used_pages(llbitmap, llbitmap->chunks))
+		return page;
 
 	rdev_for_each(rdev, mddev) {
 		sector_t sector;
@@ -596,61 +604,78 @@ static void llbitmap_free_pages(struct llbitmap *llbitmap)
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
-				       GFP_NOIO | __GFP_ZERO);
-	if (!llbitmap->pctl)
-		return -ENOMEM;
 
 	size = round_up(size, cache_line_size());
-	pctl = kmalloc_array(nr_pages, size, GFP_NOIO | __GFP_ZERO);
-	if (!pctl) {
-		kfree(llbitmap->pctl);
-		return -ENOMEM;
+	pctl = kzalloc(size, GFP_NOIO);
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
+			    PERCPU_REF_ALLOW_REINIT, GFP_NOIO)) {
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
+	llbitmap->pctl = kcalloc(nr_pages, sizeof(*llbitmap->pctl), GFP_NOIO);
+	if (!llbitmap->pctl)
+		return -ENOMEM;
 
-		if (percpu_ref_init(&pctl->active, active_release,
-				    PERCPU_REF_ALLOW_REINIT, GFP_NOIO)) {
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
@@ -923,7 +948,7 @@ static int llbitmap_init(struct llbitmap *llbitmap)
 	llbitmap->sync_size = blocks;
 	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
 
-	ret = llbitmap_cache_pages(llbitmap);
+	ret = llbitmap_alloc_pages(llbitmap);
 	if (ret)
 		return ret;
 
@@ -1032,7 +1057,7 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(sync_size, chunksize);
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->sync_size = sync_size;
-	ret = llbitmap_cache_pages(llbitmap);
+	ret = llbitmap_alloc_pages(llbitmap);
 
 out_put_page:
 	__free_page(sb_page);
-- 
2.51.0

