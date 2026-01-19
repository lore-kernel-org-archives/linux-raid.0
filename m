Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A0C2494F0
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 06:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768805310; cv=none; b=XWQJKLdcmqyo/3+fRyuZMm7Js8zfBQSFJEiEDAFm4MZB+UOPhTQJ3aQ4HQtsUCKrNtyOWXgd7t6TEBzBfl3GNrEfhKphmuyVPZc3XQSROdCufAD2ieVGAP6cpmmUEvOJ6vACEKAwTB/2Ot1EaDrCaLUaDnf6inER+Zl9qowDez4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768805310; c=relaxed/simple;
	bh=vVsccUN8N6trm6tqB2dsnfWcIgQvmsLUEHBWtvZb2GU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FjZvyznOm2Y/BPnaeVN5+HGwEXTEnLqjsMU2mVbMet373+P/9n5yU5X92PJ/8UfYX+KHTGm4TpYedxwtjxiJON3EimeNypDzztit3MaRPzE+jm/ev3ZQibjef5ovP22Lo8ppRcIewiMc/y98XCDVWpZ7P4IqFPfisxNNyuwqpVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dgjeiJwl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dgjeiJwl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=1rSbJRp5oGKRz5siR24Dv9FwJAPV0kthIkaROK7pT0A=; b=dgjeiJwlDts6rHxRQWVPyCdoaT
	rgOUSf1l3LXrD2nkN3ukx96JdtQ/PDSzMr2r7xDuo0ajpJQpTeuVNP749Z6/r4/LFCuF+V2OmUk8W
	6bNdCOWf08MTf9Z2cjS/aSDL7qxq6OzhCo6P9c9tNyfTkiWSgBP5/bVv2Jyhe3HsUq2IxT8vla/eH
	8Zm89VHFwP1FukdlHKw8ZRbW+O3vOhLCMIYI+mQmTHbntDSq9i7gaO2ixtX01E3WMzAjdHQqWq8z+
	tiVWy8KbFwj2+cOuMSH50Y44JGQZv5qAcgBggrj8Kl/1khF21wGRzcdFJIwNJyH1NeTaxqWr3x01g
	3x/es3Rw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhj3q-00000001QnR-3hZP;
	Mon, 19 Jan 2026 06:48:26 +0000
Date: Sun, 18 Jan 2026 22:48:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Coly Li <colyli@fnnas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai@fnnas.com>,
	linux-raid@vger.kernel.org, linan122@huawei.com, xni@redhat.com,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v5 12/12] md: fix abnormal io_opt from member disks
Message-ID: <aW3TuktsyQ0ADte7@infradead.org>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
 <20260114171241.3043364-13-yukuai@fnnas.com>
 <aWpUgGsZ7yvnnkgo@infradead.org>
 <BDF73A40-1E2F-425F-8D79-4C6ADCB7566D@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BDF73A40-1E2F-425F-8D79-4C6ADCB7566D@fnnas.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Jan 17, 2026 at 11:28:49AM +0800, Coly Li wrote:
> > 2026年1月16日 23:08，Christoph Hellwig <hch@infradead.org> 写道：
> > 
> > On Thu, Jan 15, 2026 at 01:12:40AM +0800, Yu Kuai wrote:
> >> It's reported that mtp3sas can report abnormal io_opt, for consequence,
> >> md array will end up with abnormal io_opt as well, due to the
> > 
> > How do you define "abnormal”?
> 
> E.g. a spinning hard drive connect to this HBA card reports its max_sectors as 32767 sectors.
> This is around 16MB and too large for normal hard drive.

Which is larger than what we'd expect for the HDD itself, where it
should be around 1MB.  But HBAs do weird stuff, so it might actually
be correct here.  Have you talked to the mpt3sas maintainers?

