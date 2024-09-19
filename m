Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0BB1991BB;
	Thu, 19 Sep 2024 12:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726749561; cv=none; b=bkiOFWOke69uf4RMkfWMbfxvRD77/pkuxpzXKvykBMSjKdd6OsN5eGi7KYQ3HgDiQa3jJIXP5E6+IlEayXLrXkg/e/Xlky2jnzhIzTmkRo+8T4/pnMYbE21RuyRj7ivRWm7pBVK2ayZnVul6PlakKZXv7APNKbHKmZF1WlB9pSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726749561; c=relaxed/simple;
	bh=655Jd2qP7NJBqhT0RvcylSy/vCaPG/tFFyErumgKUX0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mHReN09yuaKAGpz6p5cqIsYdv+RYN78XpDISB5gFD1nk93v/kyIbXLY+9jg/pWwDEqJ+vu3ZZYCIwam+i+4DF8Z91NXWPD/j3q/FgAIa4i+UXCBJ9nNkAaNIglNI3CJoda0hkRCAEz6GEdQLDk60tTlUKAptPliE8TM0PHOrn18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4X8Znt07GQz4f3jMy;
	Thu, 19 Sep 2024 20:38:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DF70A1A0359;
	Thu, 19 Sep 2024 20:39:13 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgDHR8RwG+xmPCINBw--.8325S3;
	Thu, 19 Sep 2024 20:39:13 +0800 (CST)
Subject: Re: [PATCH] md: ensure child flush IO does not affect origin
 bio->bi_status
To: linan666@huaweicloud.com, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
 zhangxiaoxu5@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20240919063048.2887579-1-linan666@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <100549dd-d146-2bb0-a04d-ed3a0bb6ee9e@huaweicloud.com>
Date: Thu, 19 Sep 2024 20:39:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240919063048.2887579-1-linan666@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHR8RwG+xmPCINBw--.8325S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF1xur1fGF4rKw1UAFW7twb_yoW8Kw4kpa
	y8G3Z8ArZ8JF4xu3W3Aa9rGa4Sgws7KFWjyFy3C3y8ZFnxCF98Kr4Yg340qryDGrW3CrZF
	q3WDtw4DuayUJFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UQ6p
	9UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/09/19 14:30, linan666@huaweicloud.com Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> When a flush is issued to an RAID array, a child flush IO is created and
> issued for each member disk in the RAID array. Since commit b75197e86e6d
> ("md: Remove flush handling"), each child flush IO has been chained with
> the original bio. As a result, the failure of any child IO could modify
> the bi_status of the original bio, potentially impacting the upper-layer
> filesystem.
> 
> Fix the issue by preventing child flush IO from altering the original
> bio->bi_status as before. However, this design introduces a known
> issue: in the event of a power failure, if a flush IO on a member
> disk fails, the upper layers may not be informed. This issue is not easy
> to fix and will not be addressed for the time being in this issue.
> 
> Fixes: b75197e86e6d ("md: Remove flush handling")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.c | 24 +++++++++++++++++++++++-
>   1 file changed, 23 insertions(+), 1 deletion(-)

LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 179ee4afe937..67108c397c5a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -546,6 +546,26 @@ static int mddev_set_closing_and_sync_blockdev(struct mddev *mddev, int opener_n
>   	return 0;
>   }
>   
> +/*
> + * The only difference from bio_chain_endio() is that the current
> + * bi_status of bio does not affect the bi_status of parent.
> + */
> +static void md_end_flush(struct bio *bio)
> +{
> +	struct bio *parent = bio->bi_private;
> +
> +	/*
> +	 * If any flush io error before the power failure,
> +	 * disk data may be lost.
> +	 */

The only solution I can think of is treating flush IO the same
as meta IO, just call md_error() this rdev.

Thanks,
Kuai


> +	if (bio->bi_status)
> +		pr_err("md: %pg flush io error %d\n", bio->bi_bdev,
> +			blk_status_to_errno(bio->bi_status));
> +
> +	bio_put(bio);
> +	bio_endio(parent);
> +}
> +
>   bool md_flush_request(struct mddev *mddev, struct bio *bio)
>   {
>   	struct md_rdev *rdev;
> @@ -565,7 +585,9 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
>   		new = bio_alloc_bioset(rdev->bdev, 0,
>   				       REQ_OP_WRITE | REQ_PREFLUSH, GFP_NOIO,
>   				       &mddev->bio_set);
> -		bio_chain(new, bio);
> +		new->bi_private = bio;
> +		new->bi_end_io = md_end_flush;
> +		bio_inc_remaining(bio);
>   		submit_bio(new);
>   	}
>   
> 

