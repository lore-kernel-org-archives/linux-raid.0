Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B392DAFAF
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 04:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789359527; cv=none; b=RhdXjSasAYpu4XgCthEmxLft0CpScLF3qv8PqND7hRW6GuLrZgnyIONIN0xxnT7A93reLxD/Op0yWqSQJkgEs0KeMlsKNB13XDcdykgIs3tTaKcQhBL28MyHSdAllmsw4QE6qcLio1wElISDT7nT5iEHW8G6h/J3XWBtBjlu3Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789359527; c=relaxed/simple;
	bh=aubhCq2qaCz1Wt3CTa+Xo5u2Snvnamxs/6eM6y5+/VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWJssFZ2ZNzIR+bG90cvwifsEKE+JGsWVcEViz7vEzkssdZ9/0g0XnROkpV386YEFsY5uHkiLJGJ2wV/TrMWGuTn3BreQ65O+YzMGAeA1hxunY0pWvGHS48mhlzbhpK4Gk7tLZNAcvPdSsKG1DxwvoMg3najRA0mbyCCBEJn/2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=v2bylMmI; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v2bylMmI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=HOiZiTTcnOGDiQNW6U8572Zud0tx8Q1ZcO5S5HNlCAo=; b=v2bylMmILt3EvBjj6MUA9IPF+K
	rDN/3MxBs4Akwii0ZCS5VDYTTgvAiu4KSvdAqErQoMAz+Cfz3+Sgpsn93up2dXEDkH61BOU9oOFZr
	6MdDqhsWD9VSXJ1vGG+UHCWROHwJdGmLsWW6+e2b1ccAtsVuHSXsyXfTYwyO3fbtTTaUDIjVm0YHE
	D7h3pjglRTpo998zzlJeY7W2/y2DT4osN0xzJOfzYerPjh4EhE8IgDeamAdjfvgtn2/fes1WmK5AK
	aYfg1Ms6SK2oQz54LcjDp7ZCYUh3q1uQlE6L/9aVEOgfl1WKlLt6EQe+AQNrNfReUGvd/NW08qcJp
	DltpjGkw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5y9K-00000008hGx-28L0;
	Mon, 14 Sep 2026 04:18:34 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-raid@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] md: Use folio APIs in free_page()
Date: Mon, 14 Sep 2026 05:18:09 +0100
Message-ID: <20260914041830.2072626-2-willy@infradead.org>
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

Convert the page to a folio.  This removes some of the last uses of a
few page APIs (detach_page_private(), page_buffers()).  Replaces two
calls to compound_head() with one.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/md/md-bitmap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 5f1637f974c1..7b42db87d536 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -533,19 +533,18 @@ static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 
 static void free_buffers(struct page *page)
 {
-	struct buffer_head *bh;
+	struct folio *folio = page_folio(page);
+	struct buffer_head *bh = folio_detach_private(folio);
 
-	if (!PagePrivate(page))
+	if (!bh)
 		return;
 
-	bh = page_buffers(page);
 	while (bh) {
 		struct buffer_head *next = bh->b_this_page;
 		free_buffer_head(bh);
 		bh = next;
 	}
-	detach_page_private(page);
-	put_page(page);
+	folio_put(folio);
 }
 
 /* read a page from a file.
-- 
2.47.3

