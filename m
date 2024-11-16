Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3665624;
	Sat, 16 Nov 2024 03:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731729111; cv=none; b=ZjR4EbF8jgwp2i2rwCeAsWdY9p7IKYhwEfFIQ40XVixW3OPSfW9MZ6h+Ty5ZTTarlNAWb727SaaDJMWbAOoMKV5Wc38vwKkW4NSOvAf2VCU4KY3TgefSqNqRHFmXntoU7MOSHmrPjE0V9eGbPVs4p4P8WWMvrVM8ZCBQS+WOCX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731729111; c=relaxed/simple;
	bh=p7f2S8jusaL15pNY9wHipfRRF786sx+ZFLyGyZZ4BDw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CCTJPPXPeeLLhsK3eTr3BC0qk7oQZAO9Wc1cRCB/6mnrdjq93+kB3SDFwCxA4SFYA8HOMmW1Eq4v8yspVkHaNyzXZxZSdHastY82tptZCvA6PDGN1K0XkZxogFUTjhZMNG/kUR+4nkGJzYWcpiDng/yFgxL9vshfTcMMY2lMWeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xr0LQ1NdTz4f3kvl;
	Sat, 16 Nov 2024 11:51:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6B7F51A018D;
	Sat, 16 Nov 2024 11:51:45 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB3U4fQFjhnzzSrBw--.43302S3;
	Sat, 16 Nov 2024 11:51:45 +0800 (CST)
Subject: Re: [PATCH v4 4/5] md/raid1: Atomic write support
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241112124256.4106435-1-john.g.garry@oracle.com>
 <20241112124256.4106435-5-john.g.garry@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <91aaf05c-3fb8-93ac-1e91-c4c84d56a4ec@huaweicloud.com>
Date: Sat, 16 Nov 2024 11:51:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241112124256.4106435-5-john.g.garry@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3U4fQFjhnzzSrBw--.43302S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww48GFy7tF1xAF18Xw4UXFb_yoW8Zw1xp3
	y7JFyFkryUtFy8u3srZFyUuayFkFs5KrZ2kFyfJw4Fqr1agrn8Ga1rXFyDWF1DuF93u34U
	t3ZYkrWDCa13ZrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
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

ÔÚ 2024/11/12 20:42, John Garry Ð´µÀ:
> Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes.
> 
> For an attempt to atomic write to a region which has bad blocks, error
> the write as we just cannot do this. It is unlikely to find devices which
> support atomic writes and bad blocks.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/md/raid1.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 

I review the patch 5 first, it's the same, so.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a5adf08ee174..cd44b4bebf49 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1571,7 +1571,15 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   				continue;
>   			}
>   			if (is_bad) {
> -				int good_sectors = first_bad - r1_bio->sector;
> +				int good_sectors;
> +
> +				if (bio->bi_opf & REQ_ATOMIC) {
> +					/* We just cannot atomically write this ... */
> +					error = -EFAULT;
> +					goto err_handle;
> +				}
> +
> +				good_sectors = first_bad - r1_bio->sector;
>   				if (good_sectors < max_sectors)
>   					max_sectors = good_sectors;
>   			}
> @@ -1657,7 +1665,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   
>   		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
>   		mbio->bi_end_io	= raid1_end_write_request;
> -		mbio->bi_opf = bio_op(bio) | (bio->bi_opf & (REQ_SYNC | REQ_FUA));
> +		mbio->bi_opf = bio_op(bio) |
> +			(bio->bi_opf & (REQ_SYNC | REQ_FUA | REQ_ATOMIC));
>   		if (test_bit(FailFast, &rdev->flags) &&
>   		    !test_bit(WriteMostly, &rdev->flags) &&
>   		    conf->raid_disks - mddev->degraded > 1)
> @@ -3224,6 +3233,7 @@ static int raid1_set_limits(struct mddev *mddev)
>   
>   	md_init_stacking_limits(&lim);
>   	lim.max_write_zeroes_sectors = 0;
> +	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>   	if (err) {
>   		queue_limits_cancel_update(mddev->gendisk->queue);
> 

