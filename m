Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC658F4A
	for <linux-raid@vger.kernel.org>; Fri, 16 Jan 2026 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768575919; cv=none; b=YHqZfbd6xQoQqHzi9hIXu/pFy/IxZBgkFFeLfgfNjgm0UOF4OZWCDPU4eyRbW5uwQXJqNSbh2qK0ewYz0HWx6az5noBx9fENylj9h34ZrMmk/tutc53ECBGkyVRdIA9p9ZXfASTjpYYpL4NtKZobqEWdxJe1drOsHFqXWMiglGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768575919; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nuAMSZK/M7pGpvau9Fb4wYr3llhZSW4uVl3q0WpXck5g+mnewN4eAx/CcDifs8GXPo8rAa34PhWurzOiaChBn/tFaenR/jYZG8bR10pWeQINpS+6JpmHao8qgtD98ydw0dynXMNBaeEc5dXeP2fs5l20B5Ba1Sw5e78/ntBg/YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BPpPLgzN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BPpPLgzN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BPpPLgzNh74uVhAvQ5dxOdpzrG
	/dqReNObpyIi9XhQmYPClFKbUFRPY6euelCLUj2kqpSX4QIPUTRpeirF46j0HJkquXTTHYyyQUABk
	r0HyZDJ2j7xEGTCd8/pCl3i1TGn/zsPYOhrcfq0A3zucpEntUDFIFEG0bgCtTX6plKKvqW4fmMm2B
	k/B7nTuWTA/iWMbnVTspYnYszG6nsAL9aOmLhzxnFq1CMW0rOtQLsw13uRKgxrd86gJ+k8b/aKa8Q
	nfxgXIcFQuzh2e20ZgbEDMQLK2GHcS7riELICpjlmX0XLvr33nFI0y9SXzFddGsLeQOX2cCqT2m3S
	wjVbB3ww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vglNt-0000000EJVv-0m9a;
	Fri, 16 Jan 2026 15:05:09 +0000
Date: Fri, 16 Jan 2026 07:05:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: linux-raid@vger.kernel.org, linan122@huawei.com, xni@redhat.com,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v5 01/12] md/raid5: fix raid5_run() to return error when
 log_init() fails
Message-ID: <aWpTpSPzduVntfbN@infradead.org>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
 <20260114171241.3043364-2-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114171241.3043364-2-yukuai@fnnas.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

