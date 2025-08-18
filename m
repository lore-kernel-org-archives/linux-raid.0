Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB842264B3;
	Mon, 18 Aug 2025 08:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755504100; cv=none; b=UoPhtbQ7gAzaljT2XzDzYxRrdAXROMZIqV71sPUTtjb4RGC15fHBOPj17gdx5wRNLTvdrrK4OeanIAYQ47YE7iEbEAUeLMdEdGS4LlUIHgqlD7W31nUB3gMDPeLBPfGQ2AuPJURy/9iy13FZN06eFYDwna7r/4Nu9C3XC/5xHBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755504100; c=relaxed/simple;
	bh=JaYLlJXD3rutiADwBrmXNGusFoNI4lU0diAbKgDj5UE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gLBP0WLU2UzCZrRl9pqH5wcpr4Xd3SvkB2P6yB7KNfVIqV/W9RX5ctUZTGo9JIv901BIIIrhT/BWSbNysetC3BVrIfWRU1karzYtQ1ebhl5ENx5LxassEzPhitu47z4JoAIwMWOVbtwrHb6vNXkTmIl/au8cA5v5SSSc6bKJaGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nosSQ3rL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nosSQ3rL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lT2jWJmPx9XjQJf7+cXdcsmcCrimT3sSXzizczetfeE=; b=nosSQ3rLv5f6GN6+K6ttFKqXS5
	Djc7s/46x8uQUXrDexqQLHQ3zm3796Hd799nma0RIB8qYrCEvi3HVBHGXZRqPQU1QezqO6hUnAbPU
	gqvIHyZttNUx6Zu9XwN/rc3f+erjpIFalHBlWQnhEZ/l3EvPD4/f6B6q+oOrcZGQIhYLX8LlaSUOt
	lN6mIBj/XSNo9JvNZQwLVZ/Aw7NsrsSt88bgKkoRnvGiYcO6Lmqx/YTvHl1FMWWwZAehoqmkaOYy4
	Lw18kQBfsJTdxNIuGtEYsMreReOAQ2XuDTlFhxH4Ew3M6IXMrsAyqB1hzVXZ9rWK5XlWyOgre08yy
	6qt8/gbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unuoD-00000006td4-0XPn;
	Mon, 18 Aug 2025 08:01:37 +0000
Date: Mon, 18 Aug 2025 01:01:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: colyli@kernel.org
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	yukuai3@huawei.com
Subject: Re: [PATCH 2/2] md: split bio by io_opt size in md_submit_bio()
Message-ID: <aKLd4bj6QSzzXqSh@infradead.org>
References: <20250817152645.7115-1-colyli@kernel.org>
 <20250817152645.7115-2-colyli@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250817152645.7115-2-colyli@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Aug 17, 2025 at 11:26:45PM +0800, colyli@kernel.org wrote:
> This patch introduces bio_split_by_io_opt() to solve the above issue,
> 1, If the incoming bio is not limits.io_opt aligned, split the non-
>   aligned head part. Then the next one will be aligned.
> 2, If the imcoming bio is limits.io_opt aligned, and split is necessary,
>   then try to split a by multiple of limits.io_opt but not exceed
>   limits.max_hw_sectors.
> 
> Then for large bio, the sligned split part will be full-stripes covered
> to all data disks, no extra read-in I/Os when rmw_level is 0. And for
> rmw_level > 0 condistions, the limits.io_opt aligned bios are welcomed
> for performace as well.
> 
> This patch only tests on 8 disks raid5 array with 64KiB chunk size.
> By this patch, 64KiB chunk size for a 8 disks raid5 array, sequential
> write performance increases from 900MiB/s to 1.1GiB/s by fio bs=10M.
> If fio bs=488K (exact limits.io_opt size) the peak sequential write
> throughput can reach 1.51GiB/s.

All this code duplication seems like a bad idea.  What is the problem
with setting max_hw_sectors to a stripe size aligned value and then
letting bio_split_by_io_opt do the work?

