Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFC23FF1;
	Thu, 28 May 2026 08:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779958489; cv=none; b=OUFSaAMelbqDPsqtrGcTRmTQcxK99QufHqxQI0IBE/WFVwMzH/22A5HhBhh+WeTBa8kT8OKKRK+AGEszkufmpLsNo0fKUjHTk0WW5G1q4J05hGZii4QJTlexJpu+iK73brO7h+6aV989MSUxswk2OO5cpJGb7XzwOfu2kFE4Eps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779958489; c=relaxed/simple;
	bh=8DOr4Go2Ejn2Yt30bH4xxoNKhJUl3XzaPDhfzqQjE+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Td2xbZKHs9iZ0msMuwh7MfNN+TtS5SZNJbF9zWxLQ7kjUpn37EWJ2O5yw+Al0RdHKax4854c1qgNxgcRkn6Sv8Q37uYNjSLUVzKCcPxPkEapt4YUVtwPWDEtI9FfN7hOk+jOBqm4rmCJMEhX+VWe3870eDN510aY0aAXKvsKUTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GnP0ejJk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GnP0ejJk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v/ylTjmkjCxHlPbas61DTDnAsi/DzIoB/quw6eoKXdo=; b=GnP0ejJkzqi3XLjR28txV1ykHx
	hiTPWnHDJoGIDNzQTwm5HXZQ++6dnaEXuDkUgPm9/aQdUG7rg67a5SIoiu5xj2vStad9ILifqQ8Aj
	+Oayho8mgYUkZLIp8P15Ab2Fz9eayVCJuMb4IhuDefV0ZJwY40BlTpgfT7z8/WkunlIyAp2ptvAmW
	2rykR0UVSBBKJOxqoVb/VUlM6/lnYvnpsrjxWMKHt9xngGDky2ApgtXPRF2IKgabJTMFv1R2fsmnH
	3jknzO0Soy3QHZlsjGv8uszkHChQ4hnwWBiWVkR0gCP3EFM+R8ytKtISNJfgZCbHPDMSK+mg/x1v8
	KwkPuMZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSWVo-00000005RTH-3Se8;
	Thu, 28 May 2026 08:54:44 +0000
Date: Thu, 28 May 2026 01:54:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	David Laight <david.laight.linux@gmail.com>,
	Li Nan <linan122@huawei.com>, Song Liu <song@kernel.org>,
	Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xor: use kmalloc() in calibrate_xor_blocks()
Message-ID: <ahgC1PDFtFrJrsKC@infradead.org>
References: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
 <20260528-lib-v3-1-feccddf1cb6d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528-lib-v3-1-feccddf1cb6d@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 28, 2026 at 10:27:55AM +0300, Mike Rapoport (Microsoft) wrote:
> -	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
> +	b1 = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
>  	if (!b1) {
>  		pr_warn("xor: Yikes!  No memory available.\n");
>  		return -ENOMEM;
> @@ -132,7 +133,7 @@ static int __init calibrate_xor_blocks(void)
>  	pr_info("xor: using function: %s (%d MB/sec)\n",
>  	       fastest->name, fastest->speed);
>  
> -	free_pages((unsigned long)b1, 2);
> +	kvfree(b1);

This should be kfree now.

