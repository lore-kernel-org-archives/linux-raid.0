Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EED32EFD95
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 07:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768807625; cv=none; b=t8Iur3WGfNuhBcc9awVXRXqNoYifQFpN3yUU/8U0UtA2z6ExPWwaErj1iOHBmqk9vVo5qZ9yP1ONjQuWQczXS+NyMPlFPhCA1zbmrXyZoY4uAKxxtDUqthb2z6CAapReqXa9m7AJfXBlKtC8Hu1iri+U+rRxhgAENOEk2vcSEV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768807625; c=relaxed/simple;
	bh=QTEOuHoe9hve107xXTOJyTbyEOKlNELu8/RM5E7NtHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cHldI/xv7vTXegekIRCYWK78vHHI0psxlhxOn+c8jmi9/PGrsNk1uh4de1xHNu/oJvIpo/fWX3AgYrdkMfnXCPOmgXCCC8F06m4gzEO52I/E01f4x+ZD4TpKQvJpGZeEZbM2HTzUpo20erqKzBFxg5R8kPySukp/2k8CmUDNZLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=trFiHa2i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="trFiHa2i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=AXkrrRp1oRr46Y2GHuTWr5vYga6vqugCE7xACuabfgk=; b=trFiHa2ib+mb/F6KYF6Pher42j
	btyuUopZzp8N1LgQccphpzBprkp1hRcl0SC8k/NXnkOKXsq6i5XcnsBGkHEdvYLQBvPH6lD+j+1CB
	mjIcVmoH6PjAQvIeigZ3D3emlafCZ2eXlnsqwy/khbxfwYmllhdNzST7Jh7GWFDJ7tKNmOFF4G/bL
	TO/XRU8s49XOvQa0M2INtI1t56wKM/RY/8P3pOngZNItkgodPMPvWZFHmP6BruNYjD3FTXgNwgnzP
	m/qxBLdqaZPj6xSGuq3T2d4qS6uF1efkZ41dB7btSn9FhBjmYdqPtf8INQVGbOnAo04PyKrXT7g+K
	KlNK7N6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhjfD-00000001TWE-0Pw0;
	Mon, 19 Jan 2026 07:27:03 +0000
Date: Sun, 18 Jan 2026 23:27:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
	linan122@huawei.com, xni@redhat.com, dan.carpenter@linaro.org
Subject: Re: [PATCH v5 07/12] md: support to align bio to limits
Message-ID: <aW3cxxnbRmon9aYJ@infradead.org>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
 <20260114171241.3043364-8-yukuai@fnnas.com>
 <aWpUYD1D1n-HJR9u@infradead.org>
 <df394803-b5fe-484f-a12d-dd10645d7a04@fnnas.com>
 <aW3Tc66fqSwv319o@infradead.org>
 <f7ba27c9-fc7b-44d5-9ddd-2bfb370e29d3@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f7ba27c9-fc7b-44d5-9ddd-2bfb370e29d3@fnnas.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 19, 2026 at 03:21:14PM +0800, Yu Kuai wrote:
> Hi，
> 
> 在 2026/1/19 14:47, Christoph Hellwig 写道:
> > On Sun, Jan 18, 2026 at 07:40:23PM +0800, Yu Kuai wrote:
> >> No, the chunk_sectors and io_opt are different, and align io to io_opt
> >> is not a general idea, for now this is the only requirement in mdraid.
> > The chunk size was added for (hardware) devices that require I/O split at
> > a fixed granularity for performance reasons.  Which seems to e exactly
> > what you want here.
> >
> > This has nothing to do with max_sectors.
> 
> For example, 32 disks raid5 array with chunksize=64k, currently the queue
> limits are:
> 
> chunk_sectors = 64k
> io_min = 64k
> io_opt = 64 * 31k
> max_sectors = 1M
> 
> It's correct to split I/O at 64k boundary to avoid performance issues, however
> split at 64 *31k boundary is what we want to get best bandwidth.
> 
> So, if we simply changes chunk_sectors to 64 * 31k, it will be incorrect, because
> 64k boundary is still necessary for small IO.

What do you mean with "necessary for small IO"?

