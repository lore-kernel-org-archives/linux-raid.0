Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AB63BB57
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 04:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789359530; cv=none; b=tkl4bfI07K8ly7/H87LchBP/LXZh7JWTvaXeEGfoNEXArQaO6fsVgD16GjPjcYw7vN/XkzoRWfPKfSafHIo9NeCvS6h+c5GOPQB/xN1ZRrYFVMAiub9gef+J9h5oPJ+9vpbFSOmB0cj19+ge+mKOhkq8pyUuktQXwWdfOMrzigw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789359530; c=relaxed/simple;
	bh=YNYtsuUBVVvcaqaTGe1H/D+zXhHoSkFBhoksc1HNsJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJWI1+aPO3NCjm8ERadWCLpmE808qgb2LeWBwhSdxzktaGwflMe/8EznqaRQJx5AVa+i/C5S3ekhQ7uWhUQimin1Sxm2j1105oSzz5XOJbGu9fgoStBKMscslmIgbq1ED8Xm/yp2JQ8zMyyCUsVlFkZvEANP3LQW3x0Xn4FTJEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lfJqfYVL; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lfJqfYVL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=w0QS+yRZerwS7r9ZIT395XGB5TnODXn+M6COboka6d4=; b=lfJqfYVLFkWoSh58tWNEgYZIqq
	8rxttqf5ZrcVCZ27NcR3Wxir1GQoSuAfmjin4m9PShwqeELFxRYmi6L5V60xShOfHLRy9X2DEgu7r
	JO7o1JB9b+1TlelvxXOOoE4Y6EqwTQ491IajOmpVc1ki42H96H0F2vt+YPtUZwLdPcL/fDQHOfCH/
	4+ggBPJrAdfQsklSfuAonJ3Qnge89yGsK9TKmVwi+hOfmMXSgXbkgc0qVNUtH+xG6JmxIdsuWhjSA
	l2If62jmvafz8G/IUhehE49wq8xdYmI/qyaLr8o5QbPhVTqm78WXkIEfKIYMS2LX9TIfxL99MkP8L
	JICnt6ug==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5y9K-00000008hGE-1YlF;
	Mon, 14 Sep 2026 04:18:34 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-raid@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] md: Use folio_alloc_buffers()
Date: Mon, 14 Sep 2026 05:18:08 +0100
Message-ID: <20260914041830.2072626-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the last user of alloc_page_buffers().  This isn't _great_,
but prevents new callers of alloc_page_buffers() existing.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/md/md-bitmap.c      | 5 +++--
 fs/buffer.c                 | 8 --------
 include/linux/buffer_head.h | 1 -
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b8325cb09a37..5f1637f974c1 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -560,6 +560,7 @@ static int read_file_page(struct file *file, unsigned long index,
 {
 	int ret = 0;
 	struct inode *inode = file_inode(file);
+	struct folio *folio = page_folio(page);
 	struct buffer_head *bh;
 	sector_t block, blk_cur;
 	unsigned long blocksize = i_blocksize(inode);
@@ -567,12 +568,12 @@ static int read_file_page(struct file *file, unsigned long index,
 	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
 		 (unsigned long long)index << PAGE_SHIFT);
 
-	bh = alloc_page_buffers(page, blocksize);
+	bh = folio_alloc_buffers(folio, blocksize, GFP_NOFS | __GFP_ACCOUNT);
 	if (!bh) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	attach_page_private(page, bh);
+	folio_attach_private(folio, bh);
 	blk_cur = index << (PAGE_SHIFT - inode->i_blkbits);
 	while (bh) {
 		block = blk_cur;
diff --git a/fs/buffer.c b/fs/buffer.c
index c9342aeb8cdf..367be053d07b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -781,14 +781,6 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 }
 EXPORT_SYMBOL_GPL(folio_alloc_buffers);
 
-struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size)
-{
-	gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT;
-
-	return folio_alloc_buffers(page_folio(page), size, gfp);
-}
-EXPORT_SYMBOL_GPL(alloc_page_buffers);
-
 static inline void link_dev_buffers(struct folio *folio,
 		struct buffer_head *head)
 {
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 1d55f7770cad..c9918176adaa 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -197,7 +197,6 @@ void folio_set_bh(struct buffer_head *bh, struct folio *folio,
 		  unsigned long offset);
 struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 					gfp_t gfp);
-struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size);
 struct buffer_head *create_empty_buffers(struct folio *folio,
 		unsigned long blocksize, unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
-- 
2.47.3

