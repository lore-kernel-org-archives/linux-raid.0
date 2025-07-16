Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DB97081C;
	Wed, 16 Jul 2025 01:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752630393; cv=none; b=B3W7NobagvlcVvVcUi9BSUev3ebAj8aCiRnQL1PZR4PFmNBLofDO/AHQhU9k6IqUct+7bE7n013Sp34IWQHsjXC+EfZBEFJa9xwci+pp+4sloXvTNe72DChLYI/2M1GiDdZn8QtkZDgJm8ZZSS6d/cSedV4/VnxtxpJswdkAxKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752630393; c=relaxed/simple;
	bh=qGd8+gEsDFope5HzZ3ovXvh7ry+tjdtlCSHxBm4MStM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=FKmcHRQh+at/eLj8JUUYlqHXkYipR6PcTi3//OpeN3s63WWz+aC/6reuh6aUZ/iE43WCy6kwGNa0/7RkIuHXTkBxePr/C6SkzZwS6gMlhqhAsUBL/6rOYAVqAubXUJqjrTQ1aLOkGgXKa0JpRY3aQ5pCF9EH8PeUisTk/DFNKuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bhf6Y07tzzKHN9G;
	Wed, 16 Jul 2025 09:46:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 962411A140C;
	Wed, 16 Jul 2025 09:46:27 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgC3MxRxBHdo3CKkAQ--.61462S3;
	Wed, 16 Jul 2025 09:46:27 +0800 (CST)
Subject: Re: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
To: colyli@kernel.org, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, Xiao Ni <xni@redhat.com>,
 Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250715180241.29731-1-colyli@kernel.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8d2e04f4-7748-6ac0-3a48-4ba37f532a50@huaweicloud.com>
Date: Wed, 16 Jul 2025 09:46:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250715180241.29731-1-colyli@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3MxRxBHdo3CKkAQ--.61462S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGrW8XFW5KrWrGFy5Aw4rAFb_yoW7JF1rpr
	WUWr9avrWkJFsF9wsxJ3W2kFnYv3yrXryYyrW7Z3yUCrsFgwnFkFWxGw1FvF13Crs5C34U
	JwsYvFyYk3WqkrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/07/16 2:02, colyli@kernel.org Ð´µÀ:
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
>     aligned head part. Then the next one will be aligned.
> 2, If the imcoming bio is limits.io_opt aligned, and split is necessary,
>     then try to split a by multiple of limits.io_opt but not exceed
>     limits.max_hw_sectors.
> 
> Then for large bio, the sligned split part will be full-stripes covered
> to all data disks, no extra read-in I/Os when rmw_level is 0. And for
> rmw_level > 0 condistions, the limits.io_opt aligned bios are welcomed
> for performace as well.
> 
> This RFC patch only tests on 8 disks raid5 array with 64KiB chunk size.
> By this patch, 64KiB chunk size for a 8 disks raid5 array, sequential
> write performance increases from 900MiB/s to 1.1GiB/s by fio bs=10M.
> If fio bs=488K (exact limits.io_opt size) the peak sequential write
> throughput can reach 1.51GiB/s.
> 
> (Resend to include Christoph and Keith in CC list.)
> 
> Signed-off-by: Coly Li <colyli@kernel.org>
> Cc: Yu Kuai <yukuai3@huawei.com>
> Cc: Xiao Ni <xni@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/md/md.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 62 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0f03b21e66e4..363cff633af3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -426,6 +426,67 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
>   }
>   EXPORT_SYMBOL(md_handle_request);
>   

The split should be due to:

lim.max_hw_sectors = RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf);

Which is introduced by commit:

7e55c60acfbb ("md/raid5: Pivot raid5_make_request()")

And take a quick a look at that, I'm still not sure yet why
max_hw_sectors is limited now, perhaps if chunksize > 256 * stripe_size,
and bio inside one chunk is greater than 256 stripes, such bio can stuck
forever because there are not enough stripes?

Thanks,
Kuai

> +static struct bio *bio_split_by_io_opt(struct bio *bio)
> +{
> +	sector_t io_opt_sectors, sectors, n;
> +	struct queue_limits lim;
> +	struct mddev *mddev;
> +	struct bio *split;
> +	int level;
> +
> +	mddev = bio->bi_bdev->bd_disk->private_data;
> +	level = mddev->level;
> +	if (level == 1 || level == 10 || level == 0 || level == LEVEL_LINEAR)
> +		return bio_split_to_limits(bio);
> +
> +	lim = mddev->gendisk->queue->limits;
> +	io_opt_sectors = min3(bio_sectors(bio), lim.io_opt >> SECTOR_SHIFT,
> +			      lim.max_hw_sectors);
> +
> +	/* No need to split */
> +	if (bio_sectors(bio) == io_opt_sectors)
> +		return bio;
> +
> +	n = bio->bi_iter.bi_sector;
> +	sectors = do_div(n, io_opt_sectors);
> +	/* Aligned to io_opt size and no need to split for radi456 */
> +	if (!sectors && (bio_sectors(bio) <=  lim.max_hw_sectors))
> +		return bio;
> +
> +	if (sectors) {
> +		/**
> +		 * Not aligned to io_opt, split
> +		 * non-aligned head part.
> +		 */
> +		sectors = io_opt_sectors - sectors;
> +	} else {
> +		/**
> +		 * Aligned to io_opt, split to the largest multiple
> +		 * of io_opt within max_hw_sectors, to make full
> +		 * stripe write/read for underlying raid456 levels.
> +		 */
> +		n = lim.max_hw_sectors;
> +		do_div(n, io_opt_sectors);
> +		sectors = n * io_opt_sectors;
> +	}
> +
> +	/* Almost won't happen */
> +	if (unlikely(sectors >= bio_sectors(bio))) {
> +		pr_warn("%s raid level %d: sectors %llu >= bio_sectors %u, not split\n",
> +			__func__, level, sectors, bio_sectors(bio));
> +		return bio;
> +	}
> +
> +	split = bio_split(bio, sectors, GFP_NOIO,
> +			  &bio->bi_bdev->bd_disk->bio_split);
> +	if (!split)
> +		return bio;
> +	split->bi_opf |= REQ_NOMERGE;
> +	bio_chain(split, bio);
> +	submit_bio_noacct(bio);
> +	return split;
> +}
> +
>   static void md_submit_bio(struct bio *bio)
>   {
>   	const int rw = bio_data_dir(bio);
> @@ -441,7 +502,7 @@ static void md_submit_bio(struct bio *bio)
>   		return;
>   	}
>   
> -	bio = bio_split_to_limits(bio);
> +	bio = bio_split_by_io_opt(bio);
>   	if (!bio)
>   		return;
>   
> 

