Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A65D47ACE2;
	Mon, 14 Sep 2026 16:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789402893; cv=none; b=mbWdyC5tTWPWPyX0N0pJiq+nFqsH+jE+fgpuxpY/OsrSlZUHpJVrUubwjBkso95YxFbc396uZYe7V4kByyml6oDiPAB/doofhcByCQJKNQXmh6ELsfb38pge9azDjhQvY7Oy0XsZTD2ZutO+Kw2uym19Sl+lIlVd1Poxm3fxZaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789402893; c=relaxed/simple;
	bh=5HATCBIkq9tQddLylvL+RK38aSRklsKIv+jfQtpA4i8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qzwyE8uzjjWvCIGUQtCwAdXUNsmbIsiwBqPJEcqvGXrOx5oort0QYChHwSOeIpTsP+gSD+Cg7GlewWZ8VJtfuNytWrZjHOpdweG29Ccvu+aCGSw2WBw5oE7E1ccWCisJMrXMndJUlyvjXJkQuA/l2dQEHuqHuR5cWCXyii/yxgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q+FoHqB5; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q+FoHqB5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=297+JVBEXI3c18C5qieX5osE5xEML3voRV5ucXXH6Bs=; b=q+FoHqB5IKg9Ayh3ygItLSuwtx
	NEiaehM4HOdu88o69y5LTlU4qriOwK98hKIm6pHDAcIWjQ748TOOAWbZ9krcXn2M0REmUrTOb975k
	/kUYjdjcJVHnJYfpXt6JbnrvYxXWwi737Zzag4Gby1wOwy35cjiP/3YMODS3Lj+O095lhiaEedwsT
	9fAMxoKARdG/vrvEyb8ui8nbtulWNLQWZdQemDu03gh+gvV7T5Qw15RMng3QQSmuBBoHIYdjn5+6c
	UMfEiWRPFBQvvZeFWFyIur1/b1jBqlOHiVHGQr8WOrTrFbmBAPRmyDFa2I2kKj97NNcvX/1+IV5fw
	Yt5vj0lQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x69Qp-0000000Bud4-37Df;
	Mon, 14 Sep 2026 16:21:23 +0000
Date: Mon, 14 Sep 2026 17:21:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: sashiko-reviews@lists.linux.dev
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] md: Use folio APIs in free_page()
Message-ID: <aqgfA0QFi98gXYG2@casper.infradead.org>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260914041830.2072626-2-willy@infradead.org>
 <20260914043129.C6F8D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260914043129.C6F8D1F000FF@smtp.kernel.org>

On Mon, Sep 14, 2026 at 04:31:29AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Memory leak of internal bitmap pages and uninitialized file bitmap pages during teardown or error handling due to an early return in free_buffers().
> --

Yes, I thought the early return looked weird.  I just believed that I
hadn't looked into the code enough to understand why it looked weird but
was right.  Since the AI says it's wrong, I'm happy to believe it's wrong.
It's probably not really a high seveirty problem because most RAIDs are
set up once and then never removed, so the leak doesn't matter.

The other thing that looks weird is that this code believes the b_this_page
list is NULL terminated.  Most loops over "all BHs attached to a folio"
have a circular list.  However, that is established by link_dev_buffers()
which is not called by md-bitmap.  So it's correct, even though weird.

The good news is this is an easy fix:

@@ -536,9 +536,6 @@ static void free_buffers(struct page *page)
        struct folio *folio = page_folio(page);
        struct buffer_head *bh = folio_detach_private(folio);

-       if (!bh)
-               return;
-
        while (bh) {
                struct buffer_head *next = bh->b_this_page;
                free_buffer_head(bh);

I can submit a new vrsion, or Zi can just pick this up.

> commit d68f524234e61e6567e52a27e09b9d2546ab54af
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> md: Use folio APIs in free_page()
> 
> This commit converts the page to a folio, removing some of the last uses of
> a few page APIs and replacing two calls to compound_head() with one.
> 
> > diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> > index 5f1637f974c15..7b42db87d536d 100644
> > --- a/drivers/md/md-bitmap.c
> > +++ b/drivers/md/md-bitmap.c
> > @@ -533,19 +533,18 @@ static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
> >  
> >  static void free_buffers(struct page *page)
> >  {
> > -	struct buffer_head *bh;
> > +	struct folio *folio = page_folio(page);
> > +	struct buffer_head *bh = folio_detach_private(folio);
> >  
> > -	if (!PagePrivate(page))
> > +	if (!bh)
> >  		return;
> 
> [Severity: High]
> This is a pre-existing issue, but this early return skips the folio_put()
> required to drop the base allocation reference for pages that do not have
> buffers attached.
> 
> For internal bitmaps, pages are allocated via alloc_page() with a refcount
> of 1 in md_bitmap_storage_alloc():
> 
> drivers/md/md-bitmap.c:md_bitmap_storage_alloc() {
> 	...
> 	store->filemap[pnum] = alloc_page(GFP_KERNEL|__GFP_ZERO);
> 	...
> }
> 
> During MD array teardown or failure, md_bitmap_file_unmap() calls
> free_buffers() on these pages:
> 
> drivers/md/md-bitmap.c:md_bitmap_file_unmap() {
> 	...
> 	free_buffers(map[pages]);
> 	...
> }
> 
> Because internal bitmap pages don't have buffers attached, (!bh) evaluates
> to true, triggering the early return and completely bypassing the folio_put()
> at the end of the function.
> 
> This permanently leaks the pages allocated for the internal bitmap's filemap
> and superblock.
> 
> Does this early return need to be updated so that folio_put() is still
> called for folios without buffers?
> 
> > -	bh = page_buffers(page);
> >  	while (bh) {
> >  		struct buffer_head *next = bh->b_this_page;
> >  		free_buffer_head(bh);
> >  		bh = next;
> >  	}
> > -	detach_page_private(page);
> > -	put_page(page);
> > +	folio_put(folio);
> >  }
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com?part=2
