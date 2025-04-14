Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEDE280CDC;
	Mon, 14 Apr 2025 11:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744630748; cv=none; b=noFpRon12a5fahCgCNk2ZFMZVfdHbpXuEMQWiophr2fx6o0mBbQKRrcij6MF61kiX2bscMolUCm++A0jZklbElXYK8FGVrL51AB5MXJFHh4U8qsuBoZ6b6m0Xs1q4XSWl6BAEQtXJEGOWNXD7MEilgTartKBD4stCZNjVBhhCsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744630748; c=relaxed/simple;
	bh=JPHN+jpWD9t+wJ6xtaBll58pm1u68FXkwIkn2RM7j84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NTyKsNss3ycflLqTAe3eqbJGmwkG74dm4ezis8hGdU+XG3UDlP11dIcAmnt43obYRNdz13zBsFg+wuGMpOMXyqZH/mCyw9jFAu4o3NWpI/0S6xps7nJPmShJ03IBdg76MwTzylUS/eU3nhxNdNNvUVXChsiUEXKYfMcnAbVT250=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f6GUFixh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f6GUFixh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8tXU7TjKACyyS9aliZITUswNNUYWl81wkuwfMZnjmYg=; b=f6GUFixhYRUezBgFjY82+UJqPU
	LjQPp31MU/rWulduLV3GFImPuHOY67DQT6zth90CNJFtrikdxQPxji4BhXNyqRNzG4KL88doiSFS9
	yEVeS9nrGeSz0Ii/RNyHLHWgpNqMq1Vq7kx6hAsYnOSX51xdNiSG+9pPaDb9h+pVZMYvD4mqzi4BJ
	8G1ypN2kMwRfjPnjlFsR4q/mVobtahFpQVO/k7qpNkS/cuGm5oKsCArlMavhbXSAzE8YdMC+YVEOy
	4MFTsuj7/c4vYm/fU+dPEXhzy6vUNs3K/RTdVjvjg5u+EylXMY8vXRmz5CGriZlcho4jRpiVqoIm6
	i7brOdTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4I9Z-00000001nOb-07yt;
	Mon, 14 Apr 2025 11:39:05 +0000
Date: Mon, 14 Apr 2025 04:39:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, song@kernel.org,
	xni@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 1/4] block: export part_in_flight()
Message-ID: <Z_zz2RY3zHVGScCK@infradead.org>
References: <20250412073202.3085138-1-yukuai1@huaweicloud.com>
 <20250412073202.3085138-2-yukuai1@huaweicloud.com>
 <Z_yr67xrbkuQwy0P@infradead.org>
 <12e79682-21a3-9389-9390-14702d6ca389@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12e79682-21a3-9389-9390-14702d6ca389@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 14, 2025 at 02:48:23PM +0800, Yu Kuai wrote:
> > If we export this it needs a kerneldoc comment, and probably also
> > a better name.
> 
> Sure about comment.

I think a name like bdev_count_inflight might also be helpful as there
is nothing partition-specific in the helper.

> There are two kinds of helpers:
> 
> 1) part_in_flight and part_in_flight_rw
> 2) blk_mq_in_flight and blk_mq_in_flight_rw
> 
> 1) is accounted at blk_account_io_start(), while 2) is
> blk_mq_start_request(), I think this is the essential difference.
> 
> part_in_flight_rw() and blk_mq_in_flight_rw() is also used in sysfs API
> inflight for bio/rq based device. And commit 7be835694dae ("block: fix
> that util can be greater than 100%") convert blk_mq_in_flight() to
> part_in_flight() from disk stats API. Now I just checked there is no use
> for blk_mq_in_flight() anymore and maybe it can be removed.

Yeah.  I'm still confused about having the different methods to count
the _rw vs non-_rw variants for blk-mq, but I guess that's not really
in scope for your series.
