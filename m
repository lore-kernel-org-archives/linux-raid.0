Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A131F63E8;
	Mon,  7 Apr 2025 14:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744037555; cv=none; b=UJqSDJ/Hdzi6IOz9U7jRf6y0AVzMpPx+d32I69v7dolw9Z3GmHMUFWw0gAj/KaMpqbekXaq9KcbMUwmhp9fcwYVZL0vobt1qjWIHGfNmg26HmYrQcwZAD/6UGR8HWUXt7PDwS42tWUI/Vc624F9f4ChYnKbwTNqxSOqiC+ybn9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744037555; c=relaxed/simple;
	bh=C9Lp+oxxK8YI81wgMjaGgrdX/gmILj7cv8HGtrIXUwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c57u9D/nIP+EyXZu8fn5kj4Fpd7LWCERfGdhl4hPSuqI7eEx6n7itfGV/xfzOa3+EWwXOlRd8beea+XtQs9sjwPioCTpfx4Qdj7qiB+4MyYKDxN1zz8I49lHmYK0PMfDYBu44mgW/xsrGIdgTriAKr0cnfZwoIzOSLZsv9c56Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hDdjxsvr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hDdjxsvr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Du9LrcnSmmpQfyk+A9bM7cXw8+S6BiGq/iA3VmlU+QY=; b=hDdjxsvrnDrjTcHeoWHXf/wJbM
	+LH1dO4eh/QQVhFNjbebh0t80sOJG9P9wy+qG88b8Jpf5MDdoiW0PKyODRl89vRbne8srmgsxqjze
	4bKMLDmoF79HZ7wjPOB/TZDUmeepupQVTtWxLKRRBYnSyxPl5yO8PGyPhZJd7/uqzztQmT/h2dtD7
	dqknCDv3S3Nljf8j/Th3loZDOfCsQvR2Nr3IxyrM9wm9VCyUVdnAe+eQFVO8/r59Qne6jv/VNOm7z
	ZW96QTSfHhErE0hfb5PcBrtCNZlGjPvktfT8mJ4C0PrO3GBdzk6nIRSCDyYeCQvdsz6f2akvZiNYo
	s78ZlglA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u1npt-00000000oqp-2zxf;
	Mon, 07 Apr 2025 14:52:29 +0000
Date: Mon, 7 Apr 2025 07:52:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linan666@huaweicloud.com
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hare@suse.de,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yangerkun@huawei.com, zhangxiaoxu5@huawei.com, wanghai38@huawei.com
Subject: Re: [PATCH 1/4] block: factor out a helper to set logical/physical
 block size
Message-ID: <Z_PmrUtXtCY6FCcw@infradead.org>
References: <20250304121918.3159388-1-linan666@huaweicloud.com>
 <20250304121918.3159388-2-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250304121918.3159388-2-linan666@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 04, 2025 at 08:19:15PM +0800, linan666@huaweicloud.com wrote:
> +extern int blk_set_block_size(struct queue_limits *t, unsigned int logical_block_size,

No need for the extern.

> +int blk_set_block_size(struct queue_limits *t, unsigned int logical_block_size,
> +		     unsigned int physical_block_size)


As Bart said this really needs documentation, both in the commit message
and the code.  It appears to be a subset of the queue limits stacking,
but I have no idea why that is needed, and the set_ name also confers
the wrong implications to me gіven the stacking logic.

> +{
> +	int ret = 0;

ret is always 0 or -1, so using a bool would be better.

> +	t->max_sectors = blk_round_down_sectors(t->max_sectors, t->logical_block_size);
> +	t->max_hw_sectors = blk_round_down_sectors(t->max_hw_sectors, t->logical_block_size);
> +	t->max_dev_sectors = blk_round_down_sectors(t->max_dev_sectors, t->logical_block_size);

Please avoid the overly long lines.

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(blk_set_block_size);

At best this should be a EXPORT_SYMBOL_GPL.

