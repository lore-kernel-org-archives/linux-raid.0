Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCFD282FB;
	Tue, 29 Oct 2024 03:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730173975; cv=none; b=jallc38tCnl43B7vCmVyVEmfKCSs19HMR1d9/Pquq1GxdXmpGK5TvflsL4trSO63WQfMbYfHocEhoXMITbOLm1uQ5hbuphh8eqNvVYSKiiLjcK8rayxDNioKJ2rGOvJor13wFviPnVCzh3dLiORxAbR+ivGqMX25CS7IGXsU9ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730173975; c=relaxed/simple;
	bh=CP4a7EW9tzUaQlOg3lKX5BOYWpst1gX8ekIZY17DvE8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mG7y/OZLkGKqqXF8gk38B/pcm3y3hNZp8qCs4qwjN5JrY2qiK8uj8DBSKh1HKKOOXuwArx9TLIEQtzolw3iu/MipyRaFPJDswex9Xf0FjStgSHnu8PIMeyyHedm7gjS32KrNVw60EING/MPGYTptLYMhwDLlPUeE+jL63mu0Uvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XcxCz1qqNz4f3l2C;
	Tue, 29 Oct 2024 11:52:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B3B671A0568;
	Tue, 29 Oct 2024 11:52:49 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHY4cQXCBnSp36AA--.41386S3;
	Tue, 29 Oct 2024 11:52:49 +0800 (CST)
Subject: Re: [PATCH v2 5/7] md/raid0: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
 Johannes.Thumshirn@wdc.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
 <20241028152730.3377030-6-john.g.garry@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9e6ad350-24df-7003-6837-9796e83f8fac@huaweicloud.com>
Date: Tue, 29 Oct 2024 11:52:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241028152730.3377030-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHY4cQXCBnSp36AA--.41386S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw13trWUGw15AF43Ww47XFb_yoW8Gr18pw
	4qg3W3ZrWjqFs2kw43Ja47Kas5AF1vqrWj9FZ2y34kZr9rZrn0kw45WF95Kry5C34UC343
	J3WkCanxC3W7trUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU92b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
	07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJV
	WUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x07UQ6p9UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/10/28 23:27, John Garry Ð´µÀ:
> Add proper bio_split() error handling. For any error, set bi_status, end
> the bio, and return.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/md/raid0.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 32d587524778..baaf5f8b80ae 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -466,6 +466,12 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
>   		struct bio *split = bio_split(bio,
>   			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
>   			&mddev->bio_set);
> +
> +		if (IS_ERR(split)) {
> +			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
> +			bio_endio(bio);
> +			return;
> +		}
>   		bio_chain(split, bio);
>   		submit_bio_noacct(bio);
>   		bio = split;
> @@ -608,6 +614,12 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
>   	if (sectors < bio_sectors(bio)) {
>   		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
>   					      &mddev->bio_set);
> +
> +		if (IS_ERR(split)) {
> +			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
> +			bio_endio(bio);
> +			return true;
> +		}
>   		bio_chain(split, bio);
>   		raid0_map_submit_bio(mddev, bio);
>   		bio = split;
> 

