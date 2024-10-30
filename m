Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640811EB9FC;
	Wed, 30 Oct 2024 13:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730296213; cv=none; b=dIiWELX2uZgckIZd/xJVhHYXEjp75cngQeuaLoIiCPNASsu1wCFeX+JSUEpklb6wTyMQsFdGDGmJdLUYeLyAF5BEmFMtv9mNOHPPE4vsFgkFdWzBD6Oi3VjrTOUzEwbldiFM6CpT1fVyPCHDwj5fnnmFctaTvpjTKQ+f4fJ+Mqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730296213; c=relaxed/simple;
	bh=FS8uQGAOnZXX1No08F4nSzJuKtAutHzKr+S9A27HBhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZJ50SYEuniaILH8+kLgKcvwLB+DgW1kQu7prVIGrCjHcXHSHeFYDP4g+ql7+jE2mgWBb4m7hlwcKyCl/oMRpY8+oUojAQgHPNHz1G9wCxtriFh5QZ8n3E5Z8v/dfs0UNNba+CvgKJmRcmLB8bm3XB+EDDGrvT56/+clWdey1/Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C420C227AAF; Wed, 30 Oct 2024 14:50:06 +0100 (CET)
Date: Wed, 30 Oct 2024 14:50:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v2 2/5] block: Support atomic writes limits for stacked
 devices
Message-ID: <20241030135006.GC27762@lst.de>
References: <20241030094912.3960234-1-john.g.garry@oracle.com> <20241030094912.3960234-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030094912.3960234-3-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 30, 2024 at 09:49:09AM +0000, John Garry wrote:
> Allow stacked devices to support atomic writes by aggregating the minimum
> capability of all bottom devices.
> 
> Flag BLK_FEAT_ATOMIC_WRITES_STACKED is set for stacked devices which
> have been enabled to support atomic writes.
> 
> Some things to note on the implementation:
> - For simplicity, all bottom devices must have same atomic write boundary
>   value (if any)
> - The atomic write boundary must be a power-of-2 already, but this
>   restriction could be relaxed. Furthermore, it is now required that the
>   chunk sectors for a top device must be aligned with this boundary.
> - If a bottom device atomic write unit min/max are not aligned with the
>   top device chunk sectors, the top device atomic write unit min/max are
>   reduced to a value which works for the chunk sectors.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  block/blk-settings.c   | 89 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blkdev.h |  4 ++
>  2 files changed, 93 insertions(+)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 1642e65a6521..6a900ef86e5a 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -496,6 +496,93 @@ static unsigned int blk_round_down_sectors(unsigned int sectors, unsigned int lb
>  	return sectors;
>  }
>  
> +static void blk_stack_atomic_writes_limits(struct queue_limits *t, struct queue_limits *b)

Avoid the overly long line here.

> +	if (t->atomic_write_hw_max) {

Maybe split this branch and the code for when it is not set into
separate helpers to keep the function to a size where it can be
easily understood?

> +	/* Check first bottom device limits */
> +	if (!b->atomic_write_hw_boundary)
> +		goto check_unit;
> +	/*
> +	 * Ensure atomic write boundary is aligned with chunk sectors. Stacked
> +	 * devices store chunk sectors in t->io_min.
> +	 */
> +	if (b->atomic_write_hw_boundary > t->io_min &&
> +	    b->atomic_write_hw_boundary % t->io_min)
> +		goto unsupported;
> +	else if (t->io_min > b->atomic_write_hw_boundary &&

No need for the else here.

> +		 t->io_min % b->atomic_write_hw_boundary)
> +		goto unsupported;
> +
> +	t->atomic_write_hw_boundary = b->atomic_write_hw_boundary;
> +
> +check_unit:

Maybe instead of the check_unit goto just move the checks between the
goto above and this into a branch?

Otherwise this looks conceptually fine to me.
