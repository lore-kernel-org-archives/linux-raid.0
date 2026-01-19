Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A088D33890B
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 08:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768811222; cv=none; b=cw1JFyAGo+c+er7dD/ARgTIczCftPq6J8q7lZXr87TzUjL1bPPCTxm9Xs8tcCpUJb6F/IH0KxAFc/7f/iO8Yp6SvTw1dQSwrge2hY8vilpHuI2BOYY4zsOieHzvlFucuE44yaH8yAWM0YujAjA7X59P2LdRoJCUo0DhW/5aM/0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768811222; c=relaxed/simple;
	bh=z6WWUiC5qW9nmeu5skpgSVssjBqSbgTmuFeHXkOhR2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PJOdM0+Vb16B7XnaBIhHRUhFMhmkikAp/bP8qQEk4NfDzSSxbOn3oBBIJWDhVIt6vzX0hQr4ark4yaE0/10Xc4r+KL0W0TBZrUN3e5APmBfmiMNfu/k11Pcp5kX7SpeggpcGFmk80ZxHN+zPxGVYP0q2wMqZ8EdnzBjZJSAa5Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O8c9kHhP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O8c9kHhP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OxNQNgyGorXIsoE12TGVUCSUeqT1Oby19lXz/Aw8vTw=; b=O8c9kHhP3dogv/Lzd3DAldOKVU
	kO4hYILsmC0taOgWRcmyPPqstpbns4cjXCUUtRkjMq3nq3MkPNbzhdoXhT47CHLzV6SgC3AmFHbJ4
	ugtdYBS9n4dmB63Y7zFqNqQCpM3OZcaaBTmcqgyLZHgbqkjiv3g5GU6IEZp035/YjNDAt2kkreL11
	stAsOzQ1+FObiC5oDbxyuzlYzi150F55nF4PgZRpyDU1aCRLBwLIbHfbeoWwlzGEPB7YY+7PBXXH5
	a0Q8cDsMT643MDBd0J0JAr3xup1/GRezPVDP3+zCxDr4tWUNu87oIpQoOfESsCAhmfUA4N7kGP55r
	nHk49rnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhkbF-00000001Yuz-0OoH;
	Mon, 19 Jan 2026 08:27:01 +0000
Date: Mon, 19 Jan 2026 00:27:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
	linan122@huawei.com, xni@redhat.com, dan.carpenter@linaro.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 07/12] md: support to align bio to limits
Message-ID: <aW3q1SnU4gN9Ahba@infradead.org>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
 <20260114171241.3043364-8-yukuai@fnnas.com>
 <aWpUYD1D1n-HJR9u@infradead.org>
 <df394803-b5fe-484f-a12d-dd10645d7a04@fnnas.com>
 <aW3Tc66fqSwv319o@infradead.org>
 <f7ba27c9-fc7b-44d5-9ddd-2bfb370e29d3@fnnas.com>
 <aW3cxxnbRmon9aYJ@infradead.org>
 <8b44bd64-efc8-428a-ad2f-9a9fcda786a1@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b44bd64-efc8-428a-ad2f-9a9fcda786a1@fnnas.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 19, 2026 at 03:43:34PM +0800, Yu Kuai wrote:
> >> 64k boundary is still necessary for small IO.
> > What do you mean with "necessary for small IO"?
> 
> io_min and io_opt is quite similar in mdraid, IO aligned with io_opt
> can get the best bandwidth, and IO aligned with io_min can get the
> best iops. Currently chunk_sectors is the same as io_min, and
> bio_split_rw() will try to align IO to io_min. I don't think we want
> to remove this behavior.

I'm still confused.  Let's go back to your example:

32 disks raid5 array with chunksize=64k.

Let's look at writes first:

Each I/O that is full aligned to 31 * 64k can be handled without a
read-modify-write cycle, so splitting I/O at that boundary makes perfect
sense.  Below that there really should not me much difference, i.e.
splitting anything at the 64k boundary is not useful.  So you want the
chunk_sectors to apply at the 31 * 64k boundary, and the io_opt as well.
And probably io_min too. (all just looking at writes).

For non-degradead reads, not much should matter.   All reads should be
reasonably efficient, splitting 64k boundaries is going to make the
implementation trivial, but will make your rely heavily on plugging
below, and also means you use quite a lot of lower bios.

For degraded reads, each I/O will always read 31 * 64k.  Splitting at
31 * 64k makes the implementation much easier.

I guess you want different boundaries for reads and writes?

Note that io_opt and io_min really just are values for the caller and
not affect splitting decisions themselves.  Of course the underlying
factors should be related.
