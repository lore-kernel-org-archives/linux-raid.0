Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB5E284B33;
	Thu, 21 Aug 2025 09:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755766961; cv=none; b=mNU5FqoQZYKpJcQMb6PtIUzoLFHjl4A+7aH2MhlnrGrnAofdO7DakZDqSN7r6YKzslKye6SNPJnnO/BtiEv6LShyv1JNElC7QojnH+XRHZ2w+aWkUpaEAjFmPwg4+5150yzoTMhXR4PiYDpuPSvq2xtTkPYN4pGG9KTDrv4OPBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755766961; c=relaxed/simple;
	bh=y3rZ+MxgrAq6IzsTuLGlFIoC9Mk5WbFEYXkYLX3a/xM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eV8tT9JLXnlU2Ml3fG/3/0MDdriUUgfQ6D27iTX3EOrNWeBFoNzdGZS2DocOTYTP8HEH+JbFDhsmuDH15DsROtcV3buGlEdOEH3XLAn03wnBsgArTljQ9zNferq+1sw9aaWAPLNaWuZisKtnpfb8K3H6GSSyAAPF6JzLws+MHl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nnKop95Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nnKop95Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=y3rZ+MxgrAq6IzsTuLGlFIoC9Mk5WbFEYXkYLX3a/xM=; b=nnKop95ZsFbBNKMyxqWEtYCQoq
	sYGMzXKWf7oOEIqjFHplOSxJLIAttSasw626nx+c9HWyj8fb2n3MWgPkUwTpQWrIkhRMQCzF5oQIa
	AEYphoq0MvMTydcNPQmOvItO0kWAvNPouPNPSgLfxNXuMU/AzitvxcEYaLb7sMBBpLat8deZ0Bl0a
	GOlrM/MWZMdTAYlxDHXkDilzaFRGy+ehqU4IVnJx28PqX+BVHtyX9yr8jQi4sV8e9ay/gHcE1FynQ
	0rRHXbFWBSegHGp5boyLzsS+pniFuIx2asi4x+CX9TVio8BHFtk3eU+rcGxTpA7G12p6rh3WyAb/F
	fGpdPNDw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1up1Bq-0000000GKvs-3Kta;
	Thu, 21 Aug 2025 09:02:34 +0000
Date: Thu, 21 Aug 2025 02:02:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, neil@brown.name,
	akpm@linux-foundation.org, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	colyli@kernel.org, xni@redhat.com, yi.zhang@huawei.com,
	yangerkun@huawei.com, johnny.chenyi@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] block: fix disordered IO in the case recursive split
Message-ID: <aKbgqoF0UN4_FbXO@infradead.org>
References: <20250821074707.2604640-1-yukuai1@huaweicloud.com>
 <aKbcM1XDEGeay6An@infradead.org>
 <54fc027f-f4dc-0412-0d6d-b44a3e644c39@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54fc027f-f4dc-0412-0d6d-b44a3e644c39@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 21, 2025 at 04:56:33PM +0800, Yu Kuai wrote:
> Can you give some examples as how to chain the right way?

fs/xfs/xfs_bio_io.c: xfs_rw_bdev
fs/xfs/xfs_buf.c: xfs_buf_submit_bio
fs/xfs/xfs_log.c: xlog_write_iclog

> BTW, for all
> the io split case, should this order be fixed? I feel we should, this
> disorder can happen on any stack case, where top max_sector is greater
> than stacked disk.

Yes, I've been trying get Bart to fix this for a while instead of
putting in a workaround very similar to the one proposed here,
but so far nothing happened.

