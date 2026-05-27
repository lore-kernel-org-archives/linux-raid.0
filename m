Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D36D3E0098;
	Wed, 27 May 2026 11:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779881315; cv=none; b=meDCJ/P6MxcbYGcAXECByV+2IW2JZyuAxv4P+GJmoKyqgkj5rnXA0FKRjgnrLpUR/VBOlsz0+pOje0R51FPD2HTOUlw/jtRBKwpCWLpGgxtcVWu4Tu3EvHlnUfqUniphZFsz4xOVJt2cjLdVBFzgMb7pB4/2nwfwqIppNapEhZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779881315; c=relaxed/simple;
	bh=D5DNR+5FIFdp8oykBTEbSRQVoFLVPNeC33WOGmxmckU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bv8J2Tc6DzopY4hFuF3fPo5VSCLxVUwZCIPDWFLc8rnb2bMoyWaMYlsmX5VAEa5VahlBaM3ECNLflX+u2ukAHtEpqf9aBY7HVU7+iigVslut9v5+TiX7yZiUJm+g9Y8ae+0GpA4awvLWUDzuwXE5aOXxItGGNOkGI75v6BgQLTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MeV9Y1G0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MeV9Y1G0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DDF1F000E9;
	Wed, 27 May 2026 11:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779881313;
	bh=qkbLuAJPJrT06BBu89RuXsT41mMoQgDPpRgE2ayU82E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MeV9Y1G0LN5n4Jz8wW3a4vKTtvObpLFQ0aHJZNV1TRbD9wUQhBbTKEIxuiW/8wRyo
	 i6VbKz1/SUzUlEkll7Q9rxIYRW21rAdLHe+Xot+Z8eSkzaMxP7890+hTiatGkpLJmY
	 3wEtWvsKqO6yUS2LoQ3mzGZdROpbdHze2OiV7QTWfALAZhyDUsVRoxinUCnI5PmcuX
	 1g1wc1BPDYqnGu6W9hSOkrttkc4v0CtWpPwQK2WFxAYk8o0k3GFGxXqJEpCSQnLDEq
	 60HNzLTeki4QAdzxp2hrtncKUfrjk89ez53g5LK6eLG6gO0lhN7yxE4CJomYYfP6gH
	 P/XLXzUWLq+wA==
Date: Wed, 27 May 2026 14:28:26 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 2/2] lib/raid6: use kvmalloc() in raid6_select_algo()
Message-ID: <ahbVWp9L7ASV6zOL@kernel.org>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
 <20260526-lib-v2-2-ca3f0fc24b14@kernel.org>
 <20260526103424.0d884374dee8cbc4f9f17c3a@linux-foundation.org>
 <20260527063814.GA17042@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527063814.GA17042@lst.de>

On Wed, May 27, 2026 at 08:38:14AM +0200, Christoph Hellwig wrote:
> On Tue, May 26, 2026 at 10:34:24AM -0700, Andrew Morton wrote:
> >  	/* prepare the buffer and fill it circularly with gfmul table */
> > -	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
> > +	disk_ptr = kvmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
> 
> This changes to vmalloc for no good reason.  It also doesn't use

TBH, I didn't look around and just presumed that order-3 allocation is a
good candidate for vmalloc(). 
But given this runs early on boot, there's no real reason for vmalloc().

> the _array version for overflow-safe multiplying (not that it matters
> much here..)
 
Can do _array if you'd like, no strong feelings here.

-- 
Sincerely yours,
Mike.
