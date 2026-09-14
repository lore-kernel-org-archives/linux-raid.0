Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E12B33D6F0
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 04:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789359528; cv=none; b=XqCyIk39MuUE0FbOtvZgTQ1Vm5sK+elDWsjbjeU4DYuzcsF8/fkBHOACbgPqLTyo2AR8fC7HY6J/8u5rFNL2w6CiyDOcDDiTsKkjHN0bPbl/KmBsjRz60SckUTRXrsQB3yW4cMPLG6ZWzK9JUxZa3xlQUvLyLOTiPkHzu7HI8Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789359528; c=relaxed/simple;
	bh=ya3YiTgxkSJ4A0nB/XiozuMid8tCgtBkGcYLatqTFts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmTBi2Cz7+/h3vJgd8iLqU0RGDQvCjd2twfmuAhobjIOETdeWeF5dwRcQgXO04L/DtKcTYBiY8TQoPwdrtFAKK0t2lQKhZWswBmw6ufmJxg+rMj+UGVeKBzlH24HFRAoPI3kO92SN6s8x9bh24tfpp4pbPLGI2J/WQjkkPKTdqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kc2A+7jd; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kc2A+7jd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=4chEaOjoN9yQ/BXFRXOnQ16jio7Vi+Ozuc940HohS+k=; b=kc2A+7jdgBYQ1W/+6/flgqBCoD
	boPvxRb0PO3nwGj1LTv032o0ViM9luEtc1kJbI2szQPu3UHFobumKtWfo7nSt7fnNhbQT+aMkPLDN
	wQMaqIFmNc62vR2HeEkkBBZBwQus7uGr9gpiym8Jj6nqMzf0GVwxvAMsAmf/0+Dgrv+WoG0OpvDeS
	ZqgQvg+9Jf+sB2b+oMOB9qulEediMAl7UTq/xljTLDDr7GEOdwXSQnAmVqwPNPdE1l8VTxj4to28/
	ccKWIFfzd4i24/8cDsyG3DYFb4ABERugHlaHC8cDIIY4IJWDD8np+A1zptgMNAFep1qwKcIX5iOac
	z/cGNcUg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5y9K-00000008hHX-2bM1;
	Mon, 14 Sep 2026 04:18:34 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-raid@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] md: Remove the last use of page_buffers()
Date: Mon, 14 Sep 2026 05:18:10 +0100
Message-ID: <20260914041830.2072626-3-willy@infradead.org>
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

Convert the page to a folio and use folio_buffers() instead.  This
does introduce one extra call to compound_head(), but will simplify a
later conversion of md-bitmap to use folios instead of pages.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/md/md-bitmap.c      | 3 ++-
 include/linux/buffer_head.h | 7 +------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 7b42db87d536..c2528220c406 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -516,7 +516,8 @@ static void end_bitmap_write(struct bio *bio)
 
 static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 {
-	struct buffer_head *bh = page_buffers(page);
+	struct folio *folio = page_folio(page);
+	struct buffer_head *bh = folio_buffers(folio);
 
 	while (bh && bh->b_blocknr) {
 		atomic_inc(&bitmap->pending_writes);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index c9918176adaa..1d5eb6ba4576 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -175,12 +175,7 @@ static inline unsigned long bh_offset(const struct buffer_head *bh)
 	return (unsigned long)(bh)->b_data & (page_size(bh->b_page) - 1);
 }
 
-/* If we *know* page->private refers to buffer_heads */
-#define page_buffers(page)					\
-	({							\
-		BUG_ON(!PagePrivate(page));			\
-		((struct buffer_head *)page_private(page));	\
-	})
+/* If we *know* folio->private refers to buffer_heads */
 #define folio_buffers(folio)		folio_get_private(folio)
 
 void buffer_check_dirty_writeback(struct folio *folio,
-- 
2.47.3

