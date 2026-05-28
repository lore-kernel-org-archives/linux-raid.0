Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2804938F24D;
	Thu, 28 May 2026 08:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779958511; cv=none; b=XSuk+PiwkmmKluZVIHBd2MKuYso9fahzNGFB/P/3fKGr3ZLXzcnLrGfazRaO2EhxUOZOSr63dMbwPAmtkaqNTBe7pI9rkvifxmFGpFTIE603oN7+bMzV/U5lY9dpq59gFyKQDfTF1pPvoifQUHTTDBCznCxwTL9hwyKSBX82hGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779958511; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PnQ1pe/IGyllasNyTuGqoNGgZJz62I32gXN2QaKwCMmHSvVa2wLWxsN4Lryxf09aKplkX8xXI8ucyyAihmHXN4QjYIm38moWhmvcfu213eSznFhylwA2EAo8ypbyTeWxX2Ioeotwf4wHdnb2UjH+VpFv7ax8XKdr9GhP2MBJPvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CUkNRqba; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CUkNRqba"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CUkNRqbaq26L+L91UTI3tIw3Xo
	U4ub1Z5qIyn8iP9fXOF1eEev/A+5iX5mG+qbzT3sB+rlefG6x4M1t2WFA81fOxddGq81a0llbWPGF
	zejxCgXEZBj696DSyIhCALDtPm7XQNMiOfTglc1OB2j+Y2Gq/7H680myWVi6mxiNL/c0RwCNb6fNt
	ifMSZtaYfblNtXUxQs+QRlDkkQRCslbMoCKCi+K14sD9S6Cl9XhSWtUh1r+mnAm9M5G8YrZz2kFzn
	dD6ZLtaF3dsbbGfAiVOUDo6ZyurPPkISSpklWQfxGu7Xx3UGxU8PwQaCTfmAtluC2Ss1lo87g9wji
	9f1DZKzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSWWC-00000005RWW-2G1U;
	Thu, 28 May 2026 08:55:08 +0000
Date: Thu, 28 May 2026 01:55:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	David Laight <david.laight.linux@gmail.com>,
	Li Nan <linan122@huawei.com>, Song Liu <song@kernel.org>,
	Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v3 2/2] raid6: use kmalloc() in raid6_select_algo()
Message-ID: <ahgC7GmRVRPuUf46@infradead.org>
References: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
 <20260528-lib-v3-2-feccddf1cb6d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528-lib-v3-2-feccddf1cb6d@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

