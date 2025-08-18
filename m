Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5DE1B7F4;
	Mon, 18 Aug 2025 01:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755481113; cv=none; b=cGAKLW+AN4FBw1vVDQbVPPrTpyKz4Zm/Jy0BZy/f0xa1SElDXzI+KYWmGpc6xbZQqoUFgMiyCKYLWGRwswX8W4iCnMtF+GY6P9P+MVTPt/JjNWDJdIhfDpLdld/BG8xN9BrACT9iCrzY8TqJCOV1LwigI3y8i3oWEMO6hYz4t98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755481113; c=relaxed/simple;
	bh=FNZzYCyYlMZ3esTtoZfJ0+eMxLb0mliT55yhcqzO29M=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=jiPI+KOlQ29SP8DCtNj8oJXUnvl+pD/REjEhVQ1+YSJK0uwrkdMMWJthBe407ei11D2k39bF4XECuRkno/YXlMOhyLSGXomSVa/DDITts3jZcyv/U1a3OJWa+hvtvKeJ94e3vPXs+oITk2SybItUEypzj0DAkefTfbJYhLJc1ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c4wN43g0VzYQv4N;
	Mon, 18 Aug 2025 09:38:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1B65D1A0839;
	Mon, 18 Aug 2025 09:38:27 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHjxARhKJoP4A1EA--.37635S3;
	Mon, 18 Aug 2025 09:38:27 +0800 (CST)
Subject: Re: [PATCH 2/2] md: split bio by io_opt size in md_submit_bio()
To: colyli@kernel.org, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250817152645.7115-1-colyli@kernel.org>
 <20250817152645.7115-2-colyli@kernel.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3e2dd600-58e3-c4ff-af97-37dbb50193f1@huaweicloud.com>
Date: Mon, 18 Aug 2025 09:38:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250817152645.7115-2-colyli@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHjxARhKJoP4A1EA--.37635S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKF1rWryUWF4Utw1UtF4xJFb_yoW7WF13pr
	4UWryavrWkXFsFkwsxJ3W29FnYvrWFgrWjyry7C3y8Cr4qg3Z2kFWxGw1rZry3Gry8G34U
	twnYvF9xCa1qvrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/08/17 23:26, colyli@kernel.org Ð´µÀ:
> From: Coly Li <colyli@kernel.org>
> 
> Currently in md_submit_bio() the incoming request bio is split by
> bio_split_to_limits() which makes sure the bio won't exceed
> max_hw_sectors of a specific raid level before senting into its
> .make_request method.
> 
> For raid level 4/5/6 such split method might be problematic and hurt
> large read/write perforamnce. Because limits.max_hw_sectors are not
> always aligned to limits.io_opt size, the split bio won't be full
> stripes covered on all data disks, and will introduce extra read-in I/O.
> Even the bio's bi_sector is aligned to limits.io_opt size and large
> enough, the resulted split bio is not size-friendly to corresponding
> raid456 level.
> 
> This patch introduces bio_split_by_io_opt() to solve the above issue,
> 1, If the incoming bio is not limits.io_opt aligned, split the non-
>    aligned head part. Then the next one will be aligned.
> 2, If the imcoming bio is limits.io_opt aligned, and split is necessary,
>    then try to split a by multiple of limits.io_opt but not exceed
>    limits.max_hw_sectors.
> 
> Then for large bio, the sligned split part will be full-stripes covered
> to all data disks, no extra read-in I/Os when rmw_level is 0. And for
> rmw_level > 0 condistions, the limits.io_opt aligned bios are welcomed
> for performace as well.
> 
> This patch only tests on 8 disks raid5 array with 64KiB chunk size.
> By this patch, 64KiB chunk size for a 8 disks raid5 array, sequential
> write performance increases from 900MiB/s to 1.1GiB/s by fio bs=10M.
> If fio bs=488K (exact limits.io_opt size) the peak sequential write
> throughput can reach 1.51GiB/s.
> 
> Signed-off-by: Coly Li <colyli@kernel.org>
> ---
>   drivers/md/md.c    | 51 +++++++++++++++++++++++++++++++++++++++++++++-
>   drivers/md/raid5.c |  6 +++++-
>   2 files changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac85ec73a409..d0d4d05150fe 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -426,6 +426,55 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
>   }
>   EXPORT_SYMBOL(md_handle_request);
>   
> +/**
> + * For raid456 read/write request, if bio LBA isn't aligned tot io_opt,
> + * split the non io_opt aligned header, to make the second part's LBA be
> + * aligned to io_opt. Otherwise still call bio_split_to_limits() to
> + * handle bio split with queue limits.
> + */
> +static struct bio *bio_split_by_io_opt(struct bio *bio)
> +{
> +	sector_t io_opt_sectors, start, offset;
> +	struct queue_limits lim;
> +	struct mddev *mddev;
> +	struct bio *split;
> +	int level;
> +
> +	mddev = bio->bi_bdev->bd_disk->private_data;
> +	level = mddev->level;
> +
> +	/* Only handle read456 read/write requests */
> +	if (level == 1 || level == 10 || level == 0 || level == LEVEL_LINEAR ||
> +	    (bio_op(bio) != REQ_OP_READ && bio_op(bio) != REQ_OP_WRITE))
For raid0/1/10, I feel this change may also beneficial for IO bandwith,
not 100% percent sure.
> +		return bio_split_to_limits(bio);
> +
> +	/* In case raid456 chunk size is too large */
> +	lim = mddev->gendisk->queue->limits;
> +	io_opt_sectors = lim.io_opt >> SECTOR_SHIFT;
> +	if (unlikely(io_opt_sectors > lim.max_hw_sectors))
> +		return bio_split_to_limits(bio);
> +
> +	/* Small request, no need to split */
> +	if (bio_sectors(bio) <= io_opt_sectors)
> +		return bio;
> +
> +	/* Only split the non-io-opt aligned header part */
> +	start = bio->bi_iter.bi_sector;
> +	offset = sector_div(start, io_opt_sectors);
> +	if (offset == 0)
> +		return bio_split_to_limits(bio);
> +
> +	split = bio_split(bio, (io_opt_sectors - offset), GFP_NOIO,
> +			  &bio->bi_bdev->bd_disk->bio_split);
> +	if (!split)

bio_split return ERR_PTR now.
> +		return bio_split_to_limits(bio);
> +
> +	split->bi_opf |= REQ_NOMERGE;
> +	bio_chain(split, bio);
> +	submit_bio_noacct(bio);
> +	return split;
> +}
> +
>   static void md_submit_bio(struct bio *bio)
>   {
>   	const int rw = bio_data_dir(bio);
> @@ -441,7 +490,7 @@ static void md_submit_bio(struct bio *bio)
>   		return;
>   	}
>   
> -	bio = bio_split_to_limits(bio);
> +	bio = bio_split_by_io_opt(bio);
>   	if (!bio)
>   		return;
>   
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 989acd8abd98..985fabeeead5 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7759,9 +7759,13 @@ static int raid5_set_limits(struct mddev *mddev)
>   
>   	/*
>   	 * Requests require having a bitmap for each stripe.
> -	 * Limit the max sectors based on this.
> +	 * Limit the max sectors based on this. And being
> +	 * aligned to lim.io_opt for better I/O performance.
>   	 */
>   	lim.max_hw_sectors = RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf);
> +	if (lim.max_hw_sectors > lim.io_opt >> SECTOR_SHIFT)
> +		lim.max_hw_sectors = rounddown(lim.max_hw_sectors,
> +			  lim.io_opt >> SECTOR_SHIFT);

For huge chunksize, I think it'll also make sense to simpliy things in
mdraid by setting max_hw_sectors to at least io_opt after patch 1. Then
we only need to consider alignment in split case.

BTW, consider this more common in mddev_stack_rdev_limits()?

Thanks,
Kuai

>   
>   	/* No restrictions on the number of segments in the request */
>   	lim.max_segments = USHRT_MAX;
> 

