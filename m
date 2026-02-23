Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FDF274B5C;
	Mon, 23 Feb 2026 14:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771855504; cv=none; b=Sw5RfxxOJiK1uO34FFjOL2GJ1Jd7CPQxzYOxzHMPKLS0xLGXjSm2nB7U3oqZtp0xtv6Wpk7SHTS8ZjKqSjPiCk40Pr1K7C+FvqjsWbWvhdzSGqdDqLHIGcDmqH//8QpM09jzpt0xLFnX612Ox0P25Dfh2lmXDnjoe7id7ZwlhjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771855504; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/fZ5MxJn46Luzzd8QR+MiJ3aJlAZnL5/qk6A5mFXF1TJhWeTJiNAab+m8tLuWlk3kpjQXU9fAPB6OltXTI/yToVIkJUsfgv2Ih8mrIYytZZYFT/hlsTEMDyZ57lV3fSppyYCvmVk4wuv5wsXdYtuDcPXAC5+X8R8MfExFBkHgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lBi9HDUw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lBi9HDUw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lBi9HDUwXhKKABQBHSrA2rlisc
	5qzI+Qv2JsZNW1+ddQG10N0h0ckvDDaHALhMhhLj1Cf+6jkN9KZ4IR2wMMMoiuliPpJGTD2O+CCvD
	/Fux7JaH3488gJErGPEYbw4yAuOmzMikvA4sfOHz3zcRXt9Q2spDnbj54KoV85fCMC+ZFv7bCavH7
	tyLas2EZLBqU7cAVwUa5RDA2/ULpUDgc7lNP4Zg/APjsdLbbmdBE2sOViD5CQrDho1WZOOUgWFf3r
	ut/VBDLu2PonyDmj+QdCVzQnGNfxIu/UkfCTCjTjcsWM55VPHO2JXC0bOAdEA/2uzcUTRGUK/8153
	kKnnzLaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuWYZ-00000000RPE-1W1N;
	Mon, 23 Feb 2026 14:05:03 +0000
Date: Mon, 23 Feb 2026 06:05:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: hch@infradead.org, song@kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, linan122@huawei.com
Subject: Re: [PATCH] md/raid5: set chunk_sectors to enable full stripe I/O
 splitting
Message-ID: <aZxej9jaig4z0kWq@infradead.org>
References: <20260223035834.3132498-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223035834.3132498-1-yukuai@fnnas.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

