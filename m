Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B467C15B0EB;
	Wed, 29 May 2024 05:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716961449; cv=none; b=F8Ow45tZ6PRVrK2Rwj+XcnlZvseZXEkq+hjMhxctYYNGA21uw6ZTX/pxsL2LnB0wHDvtbR7uLS66mBwpigCGxXwnnWm07gVkz6356R2Gjq76qUdVrBeCHKCByZ7KTfOr1j1LV4b3DR7/LgL5tLlg/25bxs2H2d4Yjbpd4qsB+UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716961449; c=relaxed/simple;
	bh=61bBAOGhuZ3r3CS7FR3rN5XM5g9Zeya/IIrNIcErpAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dXToOlxqN0TaTrvvqqZP8kUIqQxfn+Xj2I0W5Hwk6gw5H7ewEcZfZ9doS0jvlKmqtYgybiydxWLjBzv6EGk4+RBMoBPf9aj2T/Y5F3HR7SUtGXMfB3N10VL/G5lQVIzbLtBRf+xncYWFPvOfHytvyWhaz7I5Rd0PzHZ/L3UNoss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jLtctoLY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jLtctoLY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=XKugIXq2VCXINiWMPwdj+KJMB15h1t1nSqX785LINho=; b=jLtctoLYiSPJ3mejHLiy2yVfye
	+/inEfkytMkXlaKCizOVCxJ4Bh8VPuOkcAf193FC3nAy0E6bI1AJWikBy3wRg5Dy884iNGvoOwsKP
	qj1kubWaMWmUVvbrHPP71CmetZtvnTPffgNtMNUNXIqGmRD89BgeNudYAIOjG/CuKhjIiS8L6gBVi
	FdlEG5VyHA2WlbO4rc6U+dZN6KDrc+FB51vaeQmb85HCebke7O7HTxMmCiN3VB/luJKsi6WnjH9jM
	46SjVgw7p7bzl4YIJUWW52aLDlHbkuBeZMHv7ZxFUO8WvMcIo61IzDSEafhUonCDoFWhd061Rt9hJ
	frcBEQGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCC6W-00000002vBs-02an;
	Wed, 29 May 2024 05:44:04 +0000
Date: Tue, 28 May 2024 22:44:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Li Nan <linan666@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>, song@kernel.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	yukuai3@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH v2] md: make md_flush_request() more readable
Message-ID: <ZlbAo1XgsPAxQ2Qe@infradead.org>
References: <20240528203149.2383260-1-linan666@huaweicloud.com>
 <ZlXa5mFl9x4Lk4KQ@infradead.org>
 <bc582a25-2124-2aa8-f26b-94fd5a50f900@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc582a25-2124-2aa8-f26b-94fd5a50f900@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 28, 2024 at 09:49:44PM +0800, Li Nan wrote:
> 
> 
> 在 2024/5/28 21:23, Christoph Hellwig 写道:
> > Looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > .
> As suggested by Kuai, I will use bio_sectors instead of bi_size in v3.
> 
> -       if (bio->bi_iter.bi_size == 0) {
> +       if (!bio_sectors(bio)) {

That looks weird.   bio_sectors literally just shifts
bio->bi_iter.bi_size to be in units of sectors, which doesn't
matter for comparing with 0.

