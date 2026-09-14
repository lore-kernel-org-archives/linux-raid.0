Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6917446E019
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 13:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789391880; cv=none; b=lgr0ru6rjxx1fAgrn+xHegz8LVHFqVUuPBjPbmMbTA1orNMWJ0ahFKZd90QccfvIAw+p99KSQa8JWfe5+7JFbS0mOmKY4lm5RL7APHPZROpsL8mihKoVqP3UyQZlmr6O1uJ1cMCgRQHLbc8K6FEEwpApRpjzpEF6NWVaxgfyLso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789391880; c=relaxed/simple;
	bh=u35mctvdeihthz9gRQ8a3WnybD4r+GUeuvQiTjWO1tA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=klw4I/uOq3aFesQaDNtOu6n6LlgnttyMUAhXRbD2F+JD86Hlv+0EvH5N/Utx7UmyZ3yJnY84w6H/y33VzOFC2bzRZyVo3c7IHZzLatdrRKwoKS0x8dyG40oXgjSY9UGQY/Fha/enSJ+qxSk5hmL+5nGeDhW6UmKfDxrN7WFaqhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kGLG3Uvc; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kGLG3Uvc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ryZp+b5lHOOaK71b8cOGv9AYhxPgaCA4kh5MhWC7qHk=; b=kGLG3UvcpYO8+lGCRivjKcmegB
	BhmxwnHmmBjpUolfMaDyfdXhr4eGG8HSIERA5Izpd0gzF7vwO0KgNvFhrD9YkjLbm8khQQ6ZoQ5Zt
	92KY/U5PY7MVR5pEAKEze83DpWxm4Gb5MAz/DE2U0OXMBkjrGJ9brJkzjxgYh+RiclECcB8nkJMMI
	/fKqfp2Y8wWoJg5DCDi+bcflnE8GtalfmjeEgTZXqeW6wLSYwgjFeZv1ArHvwZKkr4FrKHI7N0LZ4
	TfjeJ3iEpF5NuT5P0tDZ+T1Gdv3yAj/ElD3YLuvuWQUAe8xdZWG15J8RmjLzGxAVs2QHbFwP3Tylq
	FtwXOsJQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x66ZH-0000000B6lP-2eHt;
	Mon, 14 Sep 2026 13:17:55 +0000
Date: Mon, 14 Sep 2026 14:17:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, linux-raid@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] md: Use folio_alloc_buffers()
Message-ID: <aqf0A22W4MHXD9wG@casper.infradead.org>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260914041830.2072626-1-willy@infradead.org>
 <7efaff54-3f19-4c0c-a8c9-fcbacb1aa4e2@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7efaff54-3f19-4c0c-a8c9-fcbacb1aa4e2@kernel.org>

On Mon, Sep 14, 2026 at 03:12:31PM +0200, David Hildenbrand (Arm) wrote:
> On 9/14/26 06:18, Matthew Wilcox (Oracle) wrote:
> > Remove the last user of alloc_page_buffers().  This isn't _great_,
> 
> You should tell us "why" this isn't great.
> 
> Because we're allocating folios although these things are not actually folios? I
> can only speculate :)

Well, we actually aren't allocating folios in md-bitmap:

        for ( ; pnum < num_pages; pnum++) {
                store->filemap[pnum] = alloc_page(GFP_KERNEL|__GFP_ZERO);

and it's not clear to me that we should be allocating folios; they're
internal memory to the md-bitmap code that are never mapped to userspace,
nor enter the page cache.  But they do have buffer heads attached to them.

The md-bitmap code probably needs to be rewritten to not use buffer heads
at all, but then I hear from some people that it's scheduled for deletion,
so don't spend any time on it.  But I can't find anything official about
that anywhere.

> Code itself looks good.

Thanks!
