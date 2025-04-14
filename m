Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40212F32;
	Mon, 14 Apr 2025 06:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744612335; cv=none; b=dAbXh9ffATIMT8HAqNpggsE/daFA/LudtRiFiVmpDos1SzK9BrbmTR4KOl6Lz4wi1PPSWgz9H0saF1UC2v8udxfXYUYSkX2FXCrOcrn5Kk8LhRtnSJt4wGPt8yjWgYdKJvmquqPC6xZ9FwfjdyxlLzMvj6/7W2kt/9hW7z+T2vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744612335; c=relaxed/simple;
	bh=Z/+/n5jbaTPjHtfywykFMMUYgD+TwDgkhpHvKNrTH+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sUBkgHaVXzDWDPee33Keuo8BJuzs3ewDRGe/A+2dIb8te/MWUXHAIhy0FTV4A83wla7ymtIk4qPKfkrP5+tpEeypNlqb6Lh/5RA9Lo4jXH9/H+vpN+OngHnjRzRFO4jmIPNBnVF+e5biaPJpZmJpw+pzfg9KaTBtBcv21kyzZak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mX/TD+4O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mX/TD+4O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JxcSgy0PXBEd6hHA6a9RYFS2/AatfYZKyainF/Hr3As=; b=mX/TD+4OW+9kXx2g9n3M8h5aVc
	64da07fAiHEVzhphmUbXDcjKdGNOeclbubi9yQHem/fq+wW69qkgRCfA6bAwTocoTclZGk8j0tF+u
	HmYahxd5i7x//8GdgIqN682RzbLqk6QrJCS2eBBmgC+FXM8/hcGAx9AU/kG3JdyEIArdgB4OgqeIa
	7FdtltuJJZI/7rk6rk3FsWvKqwqH6IcruYXFRsywGKWw2Gc1VzYmTdgQD+bh8HFjsEMOz7aPWOFxy
	lr+McRWi1Ln/ceZvx4U+ElWqXNproMCEiTLvP2FLV3+W2fFc2rnnhiQazwNYlyd+hRo9Lk5pC13e3
	skbD2RHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4DMZ-00000000ntO-1tBf;
	Mon, 14 Apr 2025 06:32:11 +0000
Date: Sun, 13 Apr 2025 23:32:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, xni@redhat.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH 1/4] block: export part_in_flight()
Message-ID: <Z_yr67xrbkuQwy0P@infradead.org>
References: <20250412073202.3085138-1-yukuai1@huaweicloud.com>
 <20250412073202.3085138-2-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250412073202.3085138-2-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Apr 12, 2025 at 03:31:59PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> This helper will be used in mdraid in later patches, check if there
> are normal IO inflight while generating background sync IO, to fix a
> problem in mdraid that foreground IO can be starved by background sync
> IO.

If we export this it needs a kerneldoc comment, and probably also
a better name.

Looking at this I'm also a little confused about blk_mq_in_flight_rw vs
blk_mq_in_flight and why one needs blk-mq special casing and the other
not, maybe we need to dig into the history and try to understand that
as well while we're at it.

