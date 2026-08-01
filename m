Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D19C31E833;
	Sat,  1 Aug 2026 17:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605207; cv=none; b=nGwcD1hZSYzE9lflKgxA/5q2xLDHdxeIlcT+N3AZ7XQqisj8Ux71IZGQbIN6+2JkTg3ZuVVo5cfS4cmksgeCsMEBAseAi8sVXY8ec4CknxlFLwj8gshFUIO+xtDhWKAB1uj3bwadTqSRo++AT3eg4fA7tWSIRvJ+qM/KL3GQ9Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605207; c=relaxed/simple;
	bh=HM5aRR6qgXhPD7Vh7gOlklIO1h7bdktPmZBWN0iUMl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAlqGywvfsVBj9KX02qZo+/fLYzEQEZYTBmuICEfFb9AgHUQCU8+/sXscKvz/wPmnuX/sMX+oSR81T/MopvvJqjHgEoHvtf+EYB4nd33EdI8rnK/TdDIvFPXO5PhlKYgOsVQMeheiWxIgOXc0EUWQVVhX8stqierDBYG1onnbKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nRe8+rPD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nRe8+rPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E13A1F00ACA;
	Sat,  1 Aug 2026 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605205;
	bh=cDc+twW8d9Ff9NvWS9YNuO8D+X2RxBbbPYInTgumbME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nRe8+rPD1BcHqgcIj9qA06nXevJoibnmmQTEVXFFwEZGTmqLGsUzUV0b3Z1CvWgnA
	 7f78dVPXhdCSDlBmCtgeADjcKc0MJHysJjBV+rgvQin33AbR/E+lTUs2MD0RQ42Pnq
	 l+qrXkQze+W/DIlzzOIvHP+kcsy0XKoFtjwZ8OWZ7Ox8173EZkzqoV4Ko3OZZo395G
	 nhvt40XQylQW2Mud4doqFqw6X5BHoVZWMxg21QzIuT7sOCKw9jKb/S2boI0j6bNAkh
	 5PH2bDrdcze5c2VraaR2IrVI0Br3aMKWK41NvDi2hZYjw5TcX83oQPw2lEKkhUR/mw
	 2rL6roiWfyAfA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 11/25] md/md-llbitmap: grow the page cache in place for reshape
Date: Sun,  2 Aug 2026 01:25:05 +0800
Message-ID: <20260801172519.2982121-12-yukuai@kernel.org>
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

Use the page-control helpers to grow llbitmap's cached pages in place
for resize and later reshape preparation, instead of rebuilding the
whole cache.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 145 +++++++++++++++++++++++++++++++++++----
 1 file changed, 133 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index d12b3dba6ae1..cf522fae78f8 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -416,6 +416,19 @@ static char state_machine[BitStateCount][BitmapActionCount] = {
 };
 
 static void __llbitmap_flush(struct mddev *mddev);
+static void llbitmap_flush(struct mddev *mddev);
+static void llbitmap_update_sb(void *data);
+
+static void llbitmap_calculate_chunks(struct mddev *mddev, sector_t blocks,
+				      unsigned long *chunksize,
+				      unsigned long *chunks)
+{
+	*chunks = DIV_ROUND_UP_SECTOR_T(blocks, *chunksize);
+	while (*chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {
+		*chunksize = *chunksize << 1;
+		*chunks = DIV_ROUND_UP_SECTOR_T(blocks, *chunksize);
+	}
+}
 
 static enum llbitmap_state llbitmap_read(struct llbitmap *llbitmap, loff_t pos)
 {
@@ -655,6 +668,48 @@ static unsigned int llbitmap_reserved_pages(struct llbitmap *llbitmap)
 			    PAGE_SIZE);
 }
 
+static int llbitmap_expand_pages(struct llbitmap *llbitmap,
+				 unsigned long chunks)
+{
+	struct llbitmap_page_ctl **pctl;
+	unsigned int old_nr_pages = llbitmap->nr_pages;
+	unsigned int nr_pages = llbitmap_used_pages(llbitmap, chunks);
+	unsigned int i;
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
+	while (i-- > old_nr_pages) {
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
@@ -730,6 +785,34 @@ static bool llbitmap_zero_all_disks(struct llbitmap *llbitmap)
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
@@ -1026,10 +1109,10 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
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
@@ -1171,24 +1254,62 @@ static int llbitmap_create(struct mddev *mddev)
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
+	bool quiesced = false;
 
 	if (chunksize == 0)
 		chunksize = llbitmap->chunksize;
 
-	/* If there is enough space, leave the chunksize unchanged. */
-	chunks = DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
-	while (chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {
-		chunksize = chunksize << 1;
-		chunks = DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
-	}
+	bitmap_chunksize = chunksize;
+	llbitmap_calculate_chunks(mddev, blocks, &bitmap_chunksize, &chunks);
 
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
 
+	if (mddev->pers->quiesce) {
+		mddev->pers->quiesce(mddev, 1);
+		quiesced = true;
+	}
+
+	mutex_lock(&mddev->bitmap_info.mutex);
+	cache_chunks = reshape ? max(old_chunks, chunks) : chunks;
+	ret = llbitmap_prepare_resize(llbitmap, old_chunks, chunks, cache_chunks);
+	if (ret)
+		goto out;
+
+	if (reshape) {
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
+	if (quiesced)
+		mddev->pers->quiesce(mddev, 0);
 	return 0;
+
+out:
+	mutex_unlock(&mddev->bitmap_info.mutex);
+	if (quiesced)
+		mddev->pers->quiesce(mddev, 0);
+	return ret;
 }
 
 static int llbitmap_load(struct mddev *mddev)
-- 
2.51.0

