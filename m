Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFEE173;
	Mon, 18 Aug 2025 01:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755479659; cv=none; b=SDHArnLZH3izG87edr6ocNW6n1vP6nODPSOcETNikgK21XKoCXmHnKMVNQmsMYDiDT1J0fzHsqKd9fEJ1Nq4LzSIO325fXSU7C4x3AboYbRh94LDmVAQhFnLRzR5g3Ccq/R1f3v0BJ/IX0nPGf6jUFiix0z2D7qlPIYHlVt3dyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755479659; c=relaxed/simple;
	bh=eb5PlIfT6g+w4fS62MOSzlP07RKj3EbNoIAA+QzNpI4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Rhxvo9TpVmTEOSoOwH/unFYBXqz4+PAkjx/V9Cn5iQxhn/w1/BjRh57T2D3vTtyCfgHRaRmTw6RHFmBfCqDM5wkfTYputiZkT9aEiddafiIZFmjmbCoL2cr1SE3HSqeJMkpUByngVywk1wqvdlh7iOWd/Yy4ulvgc++Zd+3hlKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c4vr42NG7zKHMXr;
	Mon, 18 Aug 2025 09:14:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B52AF1A0E9A;
	Mon, 18 Aug 2025 09:14:11 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBn4hJhfqJoBpQzEA--.39932S3;
	Mon, 18 Aug 2025 09:14:11 +0800 (CST)
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
To: colyli@kernel.org, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250817152645.7115-1-colyli@kernel.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a3a98a81-16e9-2f3c-b6e5-c83a0055c784@huaweicloud.com>
Date: Mon, 18 Aug 2025 09:14:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250817152645.7115-1-colyli@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBn4hJhfqJoBpQzEA--.39932S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFW3JFWkuF13Zr47tF15twb_yoW5ur4kpF
	1kuF9ruayjqF10vayDZ3W3CF9Yvws0kryxCr13uw48CrWq9r12grWIqFy5Xrn7tws8u3y3
	t3WIkF98uayUurDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrNtxDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/08/17 23:26, colyli@kernel.org Ð´µÀ:
> From: Coly Li <colyli@kernel.org>
> 
> This patch adds a new BLK_FLAG_STACK_IO_OPT for stack block device. If a
> stack block device like md raid5 declares its io_opt when don't want
> blk_stack_limits() to change it with io_opt of underlying non-stack
> block devices, BLK_FLAG_STACK_IO_OPT can be set on limits.flags. Then in
> blk_stack_limits(), lcm_not_zero(t->io_opt, b->io_opt) will be avoided.
> 
It's better refering to the thread:

https://lore.kernel.org/all/ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5/

That scsi and mdraid have different definition of io_opt.

> For md raid5, it is necessary to keep a proper io_opt size for better
> I/O thoughput.
> 
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

And I think raid0/raid1/raid10 should all set this flag as well.

Thanks,
Kuai

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
> 

