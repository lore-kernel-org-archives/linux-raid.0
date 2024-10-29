Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EA520494C;
	Tue, 29 Oct 2024 12:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730203960; cv=none; b=sT75b7ZlYHpJWwkjS3rpo0zByoLRNBt9D69umLd23iSL7YQQOEOyauMNYhrjbC9fFaJRbvUPkSiqI10ZzYhud0hUFlXRUGbg+1GYp7H2m5tg9o18VRHPiWNQZaYBodrd2o8ezHmVTCJeOtYjw+HV+Jik0zCvAwRpRCKCmCfJCi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730203960; c=relaxed/simple;
	bh=OG1fmlyRblrftQ3dSBwGkncNsxqTtjdK+M2PQG7pfSQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CMLNMRDN2zjud8Z9l6JvEFDQkyCKdoxksRY/AsQ6mvHCUlU4FlEPupQT++GX+npj8opeipm95grAQdjxV/XOl20EyiB15S3Axl6wXYzFhMOXRpleFNSEOE81vgzDRymHWRzlVNVaM+/WgtXoQryG1N1BeAI8C0Ut/ZsyMZvVJDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xd8JZ1Hk6z4f3nTc;
	Tue, 29 Oct 2024 20:12:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A38E01A0194;
	Tue, 29 Oct 2024 20:12:32 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHY4cv0SBn6R0bAQ--.54625S3;
	Tue, 29 Oct 2024 20:12:32 +0800 (CST)
Subject: Re: [PATCH v2 6/7] md/raid1: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
 Johannes.Thumshirn@wdc.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
 <20241028152730.3377030-7-john.g.garry@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c670a854-bee6-790b-7d1e-5ceaca8791a5@huaweicloud.com>
Date: Tue, 29 Oct 2024 20:12:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241028152730.3377030-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHY4cv0SBn6R0bAQ--.54625S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCF4UtrWxtF4xtw13Zw18Zrb_yoW5Aw45pw
	4jga1S9rW3JFWa9wsxtFZF9a4FvF4vqFW2krWxJwn7JFnIqFyDKF1UWFWYgry5uFy5ury7
	Aw1kCa1Dur42gFDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJb
	IYCTnIWIevJa73UjIFyTuYvjxU4NB_UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/10/28 23:27, John Garry Ð´µÀ:
> Add proper bio_split() error handling. For any error, call
> raid_end_bio_io() and return.
> 
> For the case of an in the write path, we need to undo the increment in
> the rdev panding count and NULLify the r1_bio->bios[] pointers.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/md/raid1.c | 32 ++++++++++++++++++++++++++++++--
>   1 file changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 6c9d24203f39..a10018282629 100644
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
> @@ -1410,6 +1415,12 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>   	read_bio->bi_private = r1_bio;
>   	mddev_trace_remap(mddev, read_bio, r1_bio->sector);
>   	submit_bio_noacct(read_bio);
> +	return;
> +
> +err_handle:
> +	bio->bi_status = errno_to_blk_status(error);
> +	set_bit(R1BIO_Uptodate, &r1_bio->state);
> +	raid_end_bio_io(r1_bio);

rdev_dec_pending() is missed here. :)

Thanks,
Kuai

>   }
>   
>   static void raid1_write_request(struct mddev *mddev, struct bio *bio,
> @@ -1417,7 +1428,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   {
>   	struct r1conf *conf = mddev->private;
>   	struct r1bio *r1_bio;
> -	int i, disks;
> +	int i, disks, k, error;
>   	unsigned long flags;
>   	struct md_rdev *blocked_rdev;
>   	int first_clone;
> @@ -1576,6 +1587,11 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
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
> @@ -1660,6 +1676,18 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
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

