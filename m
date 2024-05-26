Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998D08F45;
	Sun, 26 May 2024 08:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716713655; cv=none; b=hPKoLLsOJwhNhcJuyrHfLpnRklGklk+sTUczor97uX9hxFuVEPcnPF8Ek7NBDaqO9NBmlJyeXI2oPogcMKThz209d0KHXvI3+NdVrm64fzmGJGLXOySSatPHvECOcBolHYcP4myGDCoiZfqTeT6kHSBdXFwa3+lBEehxeDOORtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716713655; c=relaxed/simple;
	bh=cA7Ws5kGbeYZ56/9CtGWIABcTIJ42WDh1D1JqOL20dU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VvjlFsBjefcBoNrCv92hdtsAw+Mw97NLX8FlmStuSkLcHJOW7PrBBtM+FCyWh62nrArGBGOkEW7Z9modRuZp4vJVIwWCQnuLR9ZvELdPu48l+4h/o/cUVioNRWwzi2KZ0P7IlK9jUYENbdpNfwGhfGcP+dUjLmT7IdVRp8Mdaj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VbkPyGvo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VbkPyGvo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n3yJ3+ce7q5V5qKFmntDCIjLm2bWmBUIJjuIPEeKk64=; b=VbkPyGvoZjMTYs4o4RGegZQ2j/
	VNtyf0yIl9DvapF6+IFJyTcQXwVgdTYK3yvxl2hsG/YIKM9FlnEQdq3Z6QvQbL7D5ZFevSvQNYxzr
	8QX3Id45Jwsnuw/uER3JAHscanNf0Fv6PraehjuKzXkBw2uBWOLnqLFmat9UlN5jVKym+lwTrHs8Q
	n9c/sfA9IF46fMvztgQ45DwHnu75qymSN+MjeY1dsFCEJ5as9Bf9m535fglF0iOy2dPkMkIAUW/iG
	ZpA8+4S/Lg4TYA8VUuP5CYj0FipQgz75OLOE8mGhtCC8rKwXgUYWboVEkq3DK9A3GtthJR32Xp7FJ
	atHyV/Aw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sB9dn-0000000CNlL-3Jtc;
	Sun, 26 May 2024 08:54:07 +0000
Date: Sun, 26 May 2024 01:54:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linan666@huaweicloud.com
Cc: song@kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, yukuai3@huawei.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] md: make md_flush_request() more readable
Message-ID: <ZlL4rxKqcV5ePLXu@infradead.org>
References: <20240525185622.3896616-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240525185622.3896616-1-linan666@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, May 26, 2024 at 02:56:22AM +0800, linan666@huaweicloud.com wrote:
> -		bio = NULL;
> -	}
> -	spin_unlock_irq(&mddev->lock);
> -
> -	if (!bio) {
> +		spin_unlock_irq(&mddev->lock);
>  		INIT_WORK(&mddev->flush_work, submit_flushes);
>  		queue_work(md_wq, &mddev->flush_work);
>  	} else {
>  		/* flush was performed for some other bio while we waited. */
> +		spin_unlock_irq(&mddev->lock);
>  		if (bio->bi_iter.bi_size == 0)
>  			/* an empty barrier - all done */

This stil looks like a somwwhat odd flow  Why not go all the way
and turn it into:


	...
		queue_work(md_wq, &mddev->flush_work);
		return true;
	}

	/* flush was performed for some other bio while we waited. */
	spin_unlock_irq(&mddev->lock);
	if (bio->bi_iter.bi_size == 0) {
		/* pure flush without data - all done */
		bio_endio(bio);
		return true;
	}
	bio->bi_opf &= ~REQ_PREFLUSH;
	return false;
}

