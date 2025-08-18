Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DBF21D59B;
	Mon, 18 Aug 2025 02:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755485642; cv=none; b=Nu2l1LDzInNvvkOjV6zAMjO9Hd8Baxqewsqd6QLLw6kZENeTqRx9qzAqE9LKY3L0qBwNjp7sP+t459Arcv+QBOvN0aP8MOJVwF1Z7U9Q4Ly1xhuBS7Yb9hqQ4rGFdoUbJeoMBPSo+ht/JM086k4XFIR1Is028g9fP4YyCKGYnHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755485642; c=relaxed/simple;
	bh=iMlwDVWDVFRRg1CfG0xKFI556QlJOlIuxe2C1TkLHWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZvP3twgKGj1tr/cFXa6rgzNpPqL4Vff1DMra8cFNqQ4IbGswi4cSTlAdKKIUzt8ZgEMwDl6J9DmIC2CGl4mx8C9mSz+YqWCxadK/a24yGVHCKWSlYV/n4DyvsOjDFfb0DvFkBG3AA3T+emXH/sQ31sQu6X4LogjTq0zZgSCZRyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fl1/yK0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fl1/yK0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFA2C4CEEB;
	Mon, 18 Aug 2025 02:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755485642;
	bh=iMlwDVWDVFRRg1CfG0xKFI556QlJOlIuxe2C1TkLHWw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fl1/yK0kgiW1iDh3Yotvx060bf/qoM9zIQAlBtPIhnI7m0lBxFdD5ma/hB+XwOiTl
	 Ak+GNdC5EDWfNqIQKcsFBaW9uWA2KaEF2zyMe5UwdIFSFD08s1WXzqJh+q+8BwwYyb
	 50FTiTp75ndoe9SdbymszofPePfWU1cq+REG+w7rv4t84QODmGoAMRpDj0VzuyrrFx
	 Pf2UAsDElv0s0LsYVxWaJZCb7ODcgSrINTyXO6NAg2/bXmMSicojI9kB16sFDsQ+Oo
	 UJEfb6Vi2CPfPv6CeFz4+JligbqGs+6gnYfFuzi5633PVAuVT7QB3yjoZE5H8xI4ea
	 szi9RFbrBSeyg==
Message-ID: <756b587d-2a5c-4749-a03b-cfc786740684@kernel.org>
Date: Mon, 18 Aug 2025 11:51:15 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
To: colyli@kernel.org, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, yukuai3@huawei.com
References: <20250817152645.7115-1-colyli@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250817152645.7115-1-colyli@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/18/25 12:26 AM, colyli@kernel.org wrote:
> From: Coly Li <colyli@kernel.org>
> 
> This patch adds a new BLK_FLAG_STACK_IO_OPT for stack block device. If a
> stack block device like md raid5 declares its io_opt when don't want
> blk_stack_limits() to change it with io_opt of underlying non-stack
> block devices, BLK_FLAG_STACK_IO_OPT can be set on limits.flags. Then in
> blk_stack_limits(), lcm_not_zero(t->io_opt, b->io_opt) will be avoided.
> 
> For md raid5, it is necessary to keep a proper io_opt size for better
> I/O thoughput.
> 
> Signed-off-by: Coly Li <colyli@kernel.org>
> ---
>  block/blk-settings.c   | 6 +++++-
>  drivers/md/raid5.c     | 1 +
>  include/linux/blkdev.h | 3 +++
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 07874e9b609f..46ee538b2be9 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -782,6 +782,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  		t->features &= ~BLK_FEAT_POLL;
>  
>  	t->flags |= (b->flags & BLK_FLAG_MISALIGNED);
> +	t->flags |= (b->flags & BLK_FLAG_STACK_IO_OPT);
>  
>  	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
>  	t->max_user_sectors = min_not_zero(t->max_user_sectors,
> @@ -839,7 +840,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  				     b->physical_block_size);
>  
>  	t->io_min = max(t->io_min, b->io_min);
> -	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
> +	if (!t->io_opt || !(t->flags & BLK_FLAG_STACK_IO_OPT) ||
> +	    (b->flags & BLK_FLAG_STACK_IO_OPT))
> +		t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
> +
>  	t->dma_alignment = max(t->dma_alignment, b->dma_alignment);
>  
>  	/* Set non-power-of-2 compatible chunk_sectors boundary */
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 023649fe2476..989acd8abd98 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7730,6 +7730,7 @@ static int raid5_set_limits(struct mddev *mddev)
>  	lim.io_min = mddev->chunk_sectors << 9;
>  	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);

It seems to me that moving this *after* the call to mddev_stack_rdev_limits()
would simply overwrite the io_opt limit coming from stacking and get you the
same result as your patch, but without adding the new limit flags.

I do not think that the use of such flag is good as we definitely do not want
to have more of these. That would make the limit stacking far too complicated
with too many corner cases. Instead, drivers should simply change whatever
limit they do not like. DM has the .io_hint method for that. md should have
something similar.

>  	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
> +	lim.flags |= BLK_FLAG_STACK_IO_OPT;
>  	lim.discard_granularity = stripe;
>  	lim.max_write_zeroes_sectors = 0;
>  	mddev_stack_rdev_limits(mddev, &lim, 0);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 95886b404b16..a22c7cea9836 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -366,6 +366,9 @@ typedef unsigned int __bitwise blk_flags_t;
>  /* passthrough command IO accounting */
>  #define BLK_FLAG_IOSTATS_PASSTHROUGH	((__force blk_flags_t)(1u << 2))
>  
> +/* ignore underlying non-stack devices io_opt */
> +#define BLK_FLAG_STACK_IO_OPT		((__force blk_flags_t)(1u << 3))
> +
>  struct queue_limits {
>  	blk_features_t		features;
>  	blk_flags_t		flags;


-- 
Damien Le Moal
Western Digital Research
