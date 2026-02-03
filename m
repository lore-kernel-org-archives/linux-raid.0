Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E053E318131;
	Tue,  3 Feb 2026 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770136281; cv=none; b=bN039L3hddfVprVNwavqDAOA74rhNgJSVDdTxjdfbnNYsUg3JG388BnfrHfZUrzU1HoPGGUuXsYWEMtzrTLaXRxTJKREaoIF129yWoxJ8E+Q1aVXlXA3cKfJQVnhYi8C9SqDme7K/jZhDULn4zn1veBk/y52mAWsFyPWfSwq788=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770136281; c=relaxed/simple;
	bh=0jaVi7q4HMgqDO7BGbwZZfFAx889mdyp5O5HX10PNV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s3Qn2AWA+nYkVX8t0K1Qg7eVYfTiM9L16NMq1v/vLse7ylqRtfeaD7KgKk5rtS/MyOK96SOQOaB2PcegrFNk7//IypLfN1p3/SbgfF7KrXmvlgIKA6q9GwUDexhoGfj7FF1tB/zXTwdDCLSxtQ5IN/6/YnD9AoWGvp3qBZ0G2bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sA7YMsHi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sA7YMsHi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=x1R30az6gIeNLJ6WT+KTw44Uf8mUbTTOLTrGiRp2zcg=; b=sA7YMsHirXYrPFUmqdZ4NUUfw5
	BVTQDNhgYiT9UxCOdJnwHaHmkLFPp1kp9LlnbVkxz65SO+byPtIKQ1o4xBtQpNhp2iHhB2y+L4eSr
	RwhMvT9366RN24/S240NBrBctZGGZuqV5fToCgiUas51nS4kugo8M3NZxdj6P6s5lD9r3qXE+93Ij
	ylBv60rEu6aiJ3AKQ3/jQSW0sJZywpeXaSZg2pI9mqfJnMPi85tU0Um3alfBykNFgEXzXbO/bnDjF
	NGczUv/IckGXG+PnoaIn8AOdRRNwDgUOi50LwCHluafFoxKeGOMOLmLnIrX9wLkIThFXO94EGIKY8
	YPFtho1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vnJJ6-00000006xE0-3QVp;
	Tue, 03 Feb 2026 16:31:16 +0000
Date: Tue, 3 Feb 2026 08:31:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>, song@kernel.org,
	yukuai@fnnas.com, linan122@huawei.com, xni@redhat.com,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
	Zheng Qixing <zhengqixing@huawei.com>
Subject: Re: [RFC v2 0/5] md/raid1: introduce a new sync action to repair
 badblocks
Message-ID: <aYIi1JoZnDMq8rNe@infradead.org>
References: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
 <aYGkSwDZTLLbjm6p@infradead.org>
 <a1b70bef-27df-45d0-abbb-2d6b75ef5f4c@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1b70bef-27df-45d0-abbb-2d6b75ef5f4c@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 03, 2026 at 04:08:23PM +0800, Zheng Qixing wrote:
> Hi,
> 
> 在 2026/2/3 15:31, Christoph Hellwig 写道:
> > Just curious, but what kind of devices do you see that have
> > permanent bad blocks at a fixed location that are not fixed by
> > rewriting the sector?
> 
> The bad_blocks entries record sectors where I/O failed, which
> indicates that the device-internal remapping did not succeed
> at that time.
> 
> `rectify` does not assume a permanently bad or fixed LBA. Its
> purpose is to trigger an additional rewrite, giving the underlying
> device (e.g. FTL or firmware) another opportunity to perform its
> own remapping.

Well, what devices do you see where writes fail, but rewrites
fix them?

