Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75E5304969;
	Sun, 17 Aug 2025 18:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755455902; cv=none; b=egOP9RSxWvrMEJqhSys3frkb2qTIsjwyp50pmX82RlAK9Pwq77JEDo+J+/eRHTUgGbJOD5pYw19AkIJ9OYO/YBuODzHN+dKvEc7ZWFn2gDGhQgl5dY6BglhNRrplB2GVvCCx2HLlRTYs2xfpi0de4r5oRE5GuM89KJZ1MgHtNMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755455902; c=relaxed/simple;
	bh=CQIEt+kc8zkHcTX+x0T3XWeAnJn2m+yVzHehaaPk3FA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SAqeQ4O3LnMtq1UlnCvHp0ArYyu20DJL1xB0wRkEuoPJfEGhVVybqhdN9gbaedG0JdKJaNvX2wRk+G8HkJ6f2XxWi7Xa33HsWTiTonz7EBdJ9cK+UEeq4YM5vEv2P7+PFqPOvtlWXQcurjRa6DRIiwIsHrNcTFqirA64VZGHDiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [10.0.54.22] (unknown [62.214.191.67])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 741B261E647BB;
	Sun, 17 Aug 2025 20:37:55 +0200 (CEST)
Message-ID: <2c4755bf-6f64-45cd-b49e-37b37676ea40@molgen.mpg.de>
Date: Sun, 17 Aug 2025 20:37:50 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
To: Coly Li <colyli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 yukuai3@huawei.com
References: <20250817152645.7115-1-colyli@kernel.org>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250817152645.7115-1-colyli@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Coly,


Thank you for your patch.

Am 17.08.25 um 17:26 schrieb colyli@kernel.org:
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

th*r*oughput

For performance claims, it’d be great if you added the benchmark and the 
test system details and test results.

> Signed-off-by: Coly Li <colyli@kernel.org>
> ---
>   block/blk-settings.c   | 6 +++++-
>   drivers/md/raid5.c     | 1 +
>   include/linux/blkdev.h | 3 +++
>   3 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 07874e9b609f..46ee538b2be9 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -782,6 +782,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>   		t->features &= ~BLK_FEAT_POLL;
>   
>   	t->flags |= (b->flags & BLK_FLAG_MISALIGNED);
> +	t->flags |= (b->flags & BLK_FLAG_STACK_IO_OPT);
>   
>   	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
>   	t->max_user_sectors = min_not_zero(t->max_user_sectors,
> @@ -839,7 +840,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>   				     b->physical_block_size);
>   
>   	t->io_min = max(t->io_min, b->io_min);
> -	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
> +	if (!t->io_opt || !(t->flags & BLK_FLAG_STACK_IO_OPT) ||
> +	    (b->flags & BLK_FLAG_STACK_IO_OPT))
> +		t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
> +
>   	t->dma_alignment = max(t->dma_alignment, b->dma_alignment);
>   
>   	/* Set non-power-of-2 compatible chunk_sectors boundary */
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 023649fe2476..989acd8abd98 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7730,6 +7730,7 @@ static int raid5_set_limits(struct mddev *mddev)
>   	lim.io_min = mddev->chunk_sectors << 9;
>   	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
>   	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
> +	lim.flags |= BLK_FLAG_STACK_IO_OPT;
>   	lim.discard_granularity = stripe;
>   	lim.max_write_zeroes_sectors = 0;
>   	mddev_stack_rdev_limits(mddev, &lim, 0);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 95886b404b16..a22c7cea9836 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -366,6 +366,9 @@ typedef unsigned int __bitwise blk_flags_t;
>   /* passthrough command IO accounting */
>   #define BLK_FLAG_IOSTATS_PASSTHROUGH	((__force blk_flags_t)(1u << 2))
>   
> +/* ignore underlying non-stack devices io_opt */
> +#define BLK_FLAG_STACK_IO_OPT		((__force blk_flags_t)(1u << 3))
> +
>   struct queue_limits {
>   	blk_features_t		features;
>   	blk_flags_t		flags;


Kind regards,

Paul
