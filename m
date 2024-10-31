Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34975199FC6;
	Thu, 31 Oct 2024 11:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730372862; cv=none; b=WA9wmZ9ixqOQGhnPme8ox+kqZiFlBV92s/NkDnub6gqTIPR5FQvlaqiYC+Z1DZ1DFTGil/JkfeuxM7x56iJITpvd9GT6Qe07f+baT0cOOKM40EDefksyC5HWq7euEWCX0Asg1hkw35zxCAHGsFVvMmFEn/vOPcGSuadN/Sv/Ia0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730372862; c=relaxed/simple;
	bh=0Bkyi8LyOxVMJKPva3Yc0QzscGVgkrh5AAmWRvQhFos=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rOi3Z7wAMlXhd9ZVsiOF5XKqdB1qD0NJrYbrC0VScm5MDzt8SgY0pg+g0NEnmxV/XVCncFGXrre4MSdcRu5YnQJJKfkDMouFhT2ghArSYk+CVO18SRNdBeBvAERxpRTmdwoEFFKI0dL8G8DZZ3xE7HDPoRfjkUGVR+cLLTVUxDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XfLmh5gXwz4f3n6Y;
	Thu, 31 Oct 2024 19:07:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 583F41A07B6;
	Thu, 31 Oct 2024 19:07:35 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBHI4f1ZCNnDO7SAQ--.77S3;
	Thu, 31 Oct 2024 19:07:35 +0800 (CST)
Subject: Re: [PATCH v3 5/6] md/raid1: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
 Johannes.Thumshirn@wdc.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241031095918.99964-1-john.g.garry@oracle.com>
 <20241031095918.99964-6-john.g.garry@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4f6aac00-929c-ded3-aefe-47b477147b60@huaweicloud.com>
Date: Thu, 31 Oct 2024 19:07:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241031095918.99964-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHI4f1ZCNnDO7SAQ--.77S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZrWxKr4UtrWrKrW5XrWkWFg_yoW5ZryUpw
	4jga1S9rW3JFWa9wsxta9F9a4rZF4vqFW2krWxJw1xJFnIqr98KF1UWFWYgry5ua45ury7
	Aw1kCw4Duw42gFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
	07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJV
	WUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJb
	IYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/10/31 17:59, John Garry Ð´µÀ:
> Add proper bio_split() error handling. For any error, call
> raid_end_bio_io() and return.
> 
> For the case of an in the write path, we need to undo the increment in
> the rdev pending count and NULLify the r1_bio->bios[] pointers.
> 
> For read path failure, we need to undo rdev pending count increment from
> the earlier read_balance() call.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/md/raid1.c | 33 +++++++++++++++++++++++++++++++--
>   1 file changed, 31 insertions(+), 2 deletions(-)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 6c9d24203f39..7e023e9303c8 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1322,7 +1322,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>   	const enum req_op op = bio_op(bio);
>   	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
>   	int max_sectors;
> -	int rdisk;
> +	int rdisk, error;
>   	bool r1bio_existed = !!r1_bio;
>   
>   	/*
> @@ -1383,6 +1383,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>   	if (max_sectors < bio_sectors(bio)) {
>   		struct bio *split = bio_split(bio, max_sectors,
>   					      gfp, &conf->bio_split);
> +
> +		if (IS_ERR(split)) {
> +			error = PTR_ERR(split);
> +			goto err_handle;
> +		}
>   		bio_chain(split, bio);
>   		submit_bio_noacct(bio);
>   		bio = split;
> @@ -1410,6 +1415,13 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>   	read_bio->bi_private = r1_bio;
>   	mddev_trace_remap(mddev, read_bio, r1_bio->sector);
>   	submit_bio_noacct(read_bio);
> +	return;
> +
> +err_handle:
> +	atomic_dec(&mirror->rdev->nr_pending);
> +	bio->bi_status = errno_to_blk_status(error);
> +	set_bit(R1BIO_Uptodate, &r1_bio->state);
> +	raid_end_bio_io(r1_bio);
>   }
>   
>   static void raid1_write_request(struct mddev *mddev, struct bio *bio,
> @@ -1417,7 +1429,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   {
>   	struct r1conf *conf = mddev->private;
>   	struct r1bio *r1_bio;
> -	int i, disks;
> +	int i, disks, k, error;
>   	unsigned long flags;
>   	struct md_rdev *blocked_rdev;
>   	int first_clone;
> @@ -1576,6 +1588,11 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   	if (max_sectors < bio_sectors(bio)) {
>   		struct bio *split = bio_split(bio, max_sectors,
>   					      GFP_NOIO, &conf->bio_split);
> +
> +		if (IS_ERR(split)) {
> +			error = PTR_ERR(split);
> +			goto err_handle;
> +		}
>   		bio_chain(split, bio);
>   		submit_bio_noacct(bio);
>   		bio = split;
> @@ -1660,6 +1677,18 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   
>   	/* In case raid1d snuck in to freeze_array */
>   	wake_up_barrier(conf);
> +	return;
> +err_handle:
> +	for (k = 0; k < i; k++) {
> +		if (r1_bio->bios[k]) {
> +			rdev_dec_pending(conf->mirrors[k].rdev, mddev);
> +			r1_bio->bios[k] = NULL;
> +		}
> +	}
> +
> +	bio->bi_status = errno_to_blk_status(error);
> +	set_bit(R1BIO_Uptodate, &r1_bio->state);
> +	raid_end_bio_io(r1_bio);
>   }
>   
>   static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
> 

