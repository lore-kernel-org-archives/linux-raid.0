Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A3633DEF1
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 08:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768811766; cv=none; b=ch/RI4s/HlebprjDp8tDew+CqCyWCOv1La+EZoEfec01W+XJmfsrXTNI03FxRRLE+Pp3WHwaP836U2dKuw4juP/U8mtMh7m13of5bZXe1xK/0ASDwFswnMgBcogN1U7akRmewomUoWvWYNa/i3E4/aUFirWhK9/QAlVhas31zhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768811766; c=relaxed/simple;
	bh=CR16nmvrHvXnijYtLCaDdeVS9llXR/kQGcIHzZr9xxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e6API/YmQ3L+4Knk4iYkRDjg1UkPJ59QDY6NA1BAztbaSb9Ar79Q/c2hGA9KiR2hJsg5xHioAdi8dakYbYVj+umWd0rsbWzERpjvHrM2TW5ShjsPcO4+ix5SmjFM/lKYbWNrgGI7JKsq2aLRKLUyh1gTr02xBNbrGbdvd/T2lbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qnm6OOld; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qnm6OOld"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=obReNP6/t7MTLmsvhGXhvSPnBBc18Rk1iIYh2jEVHZ4=; b=qnm6OOldX4fs5u4/iX5UrwXlh3
	JWiF9+yd559iYd9NqKfbFHsQK/8jiX0PRThkhB9XWzObLXBOVKV1W3FGMARBcDGrYE03ntfRfAly1
	yxThwzfUIVxnoqBAfdMhjPx39E6BDw6fZHPkTy3xkAOZznh6huZeagCZLcl3dH+5qI+ttZ3WdPr3+
	fYn+cozYUd7qtOxRkK1X/AexITVNOltkdh+jFwz5qu7LbTXlUKIMAjfO9yk0niBNIwIFMPbgz3IFS
	0LtVxzaWzFSNvRChrPExbkMDayAg7qK2HSzb4UjB/ZkIlcZaCL2LydDPMXSLsqeR3UVL4JWnohW5j
	nDcYp/9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhkjx-00000001ZE4-1FSo;
	Mon, 19 Jan 2026 08:36:01 +0000
Date: Mon, 19 Jan 2026 00:36:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Coly Li <colyli@fnnas.com>,
	linux-raid@vger.kernel.org, linan122@huawei.com, xni@redhat.com,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v5 12/12] md: fix abnormal io_opt from member disks
Message-ID: <aW3s8cDfbFQrm6gD@infradead.org>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
 <20260114171241.3043364-13-yukuai@fnnas.com>
 <aWpUgGsZ7yvnnkgo@infradead.org>
 <BDF73A40-1E2F-425F-8D79-4C6ADCB7566D@fnnas.com>
 <aW3TuktsyQ0ADte7@infradead.org>
 <9642ed5f-1e60-47dd-a333-abc5cb26ebe1@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9642ed5f-1e60-47dd-a333-abc5cb26ebe1@fnnas.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 19, 2026 at 03:24:19PM +0800, Yu Kuai wrote:
> >> E.g. a spinning hard drive connect to this HBA card reports its max_sectors as 32767 sectors.
> >> This is around 16MB and too large for normal hard drive.
> > Which is larger than what we'd expect for the HDD itself, where it
> > should be around 1MB.  But HBAs do weird stuff, so it might actually
> > be correct here.  Have you talked to the mpt3sas maintainers?
> 
> We CC them in several previous threads, however, they're not responding. :(

In that case we'll have to assume the value is intended.  Especially
if the HBA is running in RAID mode, which would be only sensible path
to modify this value anyway.

