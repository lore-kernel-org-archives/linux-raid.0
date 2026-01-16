Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA075338921
	for <linux-raid@vger.kernel.org>; Fri, 16 Jan 2026 15:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768576103; cv=none; b=MWIaiJAboQkAzu32z31uflCODyoYQlUAm2Jj3OmHldI4/Xe6WWCA3HYMufCUvmCML3gS6jAiDr7c1pUqq2tOz+S4FNwlsfzuDKSPp3aYgAlHsRPmtI/NvcN7P5ZCbZ3iJuW7qNRiU985sOj7YwTSZPlBmzDMdRvv4Yl+49QSTK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768576103; c=relaxed/simple;
	bh=xTg1uOLby3JLKCol4utfPV3lk3s0HjqyHasHgUTL9kY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8RrEjPeGd9V+lLgX7Bw/na5kk/kcQuvZVzf18VStByObImsEoCqKIRZ3iLGJyOYl7WVnYwm9ESz5evCzG2VCweV9kZaQnkhzcA8g2unT5eE4qQHuIm+KtygR7Kf+Mtlw4BFN/5PoSAVJC9VKTq815FriC8cRsg6E7bRKg9mXk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jQCO6OYR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jQCO6OYR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x0RH3XLXWd+g6ckZsR6nZVIl0uxWDjNo1SqkqnXW8RE=; b=jQCO6OYR5/kTnCR7Qg82pHiIME
	ZECtyVWEFj1g9tBw+iMbURZRKxswu94FCltKhEt6ILuqauvu5uuo0ARqFdr4Hv9pPvrzUpG7SpcP8
	lapgUAk5728O+4vp41LR3B/XxrcyAjmlkst7dsEhYPOsYgOV+b5d3MKrDrpopYX/PVuLOrwg9rduq
	zLcseyhkB88F+CCldW5mZE6KRRhpD4BKRq4RCGIbnxP47CRXTgdrho2VR5t5p/MCpejJI/x+HyqD8
	lvK9LO39tZRhVhph9wxMVt4KktcB9bG90keYx50V72IquHrrjw/RmCrBXfdnoFQ03AZMZMfPFSV1p
	w26qT/sg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vglQu-0000000EJmQ-26gs;
	Fri, 16 Jan 2026 15:08:16 +0000
Date: Fri, 16 Jan 2026 07:08:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: linux-raid@vger.kernel.org, linan122@huawei.com, xni@redhat.com,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v5 07/12] md: support to align bio to limits
Message-ID: <aWpUYD1D1n-HJR9u@infradead.org>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
 <20260114171241.3043364-8-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114171241.3043364-8-yukuai@fnnas.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 15, 2026 at 01:12:35AM +0800, Yu Kuai wrote:
> For personalities that report optimal IO size, it indicates that users
> can get the best IO bandwidth if they issue IO with this size. However
> there is also an implicit condition that IO should also be aligned to the
> optimal IO size.
> 
> Currently, bio will only be split by limits, if bio offset is not aligned
> to limits, then all split bio will not be aligned. This patch add a new
> feature to align bio to limits first, and following patches will support
> this for each personality if necessary.

This feels a bit odd and mixes up different things as right now
nothing in the block layer splits to the opt_io size.  If you want
a boundary that is split on, the chunk_size limit seems to be what
you want, and the existing code would do the work based on that.

