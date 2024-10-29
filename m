Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AF0205AD9;
	Tue, 29 Oct 2024 11:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730202957; cv=none; b=tzFNyFAzwRQ2H5Ox07K1X2hlTHlCHaCf+hToXMjX2YXl3paKwkGOiJgGrhPWPcMXgP/X3yutlWs+aNQt0yraEGln01CgiJL5WRVOrQpGvzOEoM/uOj7MFv1e/zR2JBY/nnHKtSA9YhgSk8kRBEe1Ey8NYIyZxlc6hT7LxW807wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730202957; c=relaxed/simple;
	bh=rZsjMciENEV62jXsM76VErNU1uGLDGuef1gv72HLLSo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=k32Y5ySfqPYqOnxVVAuf/FWBBkbO2gcpQ0ksQ7FkoW/Am4sBdGi7+V7VXaNTlkkYm96PCEMalVdDzyNERZZh6PTrDrfCyV2TkgKkeCh1Je8SkV0u2Mv1tunW5MHzlfRDdL3wymq4t5LiCcnXh+SqVAWVlFocIRung8ZFMJnHqE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xd7xH3gqKz4f3nby;
	Tue, 29 Oct 2024 19:55:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 024121A0568;
	Tue, 29 Oct 2024 19:55:50 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHY4dEzSBnfhYaAQ--.54352S3;
	Tue, 29 Oct 2024 19:55:49 +0800 (CST)
Subject: Re: [PATCH v2 7/7] md/raid10: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
 Johannes.Thumshirn@wdc.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
 <20241028152730.3377030-8-john.g.garry@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <eeb9ca32-6862-6a07-bc51-7bd05430f018@huaweicloud.com>
Date: Tue, 29 Oct 2024 19:55:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241028152730.3377030-8-john.g.garry@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHY4dEzSBnfhYaAQ--.54352S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCF4UtryDAr4kuFWDtr43Jrb_yoWrKF13pr
	Wqq3WfArW5JFZI9wnxtanFgasYvryvqFW2yrWxG347XwnIqr98KF1UWrWYgry5ury5u343
	X3Z5Wr4DCa9rtFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU92b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
	07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJV
	WUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x07UAwIDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/10/28 23:27, John Garry Ð´µÀ:
> Add proper bio_split() error handling. For any error, call
> raid_end_bio_io() and return. Except for discard, where we end the bio
> directly.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/md/raid10.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index f3bf1116794a..9c56b27b754a 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1159,6 +1159,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>   	int slot = r10_bio->read_slot;
>   	struct md_rdev *err_rdev = NULL;
>   	gfp_t gfp = GFP_NOIO;
> +	int error;
>   
>   	if (slot >= 0 && r10_bio->devs[slot].rdev) {
>   		/*
> @@ -1206,6 +1207,10 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>   	if (max_sectors < bio_sectors(bio)) {
>   		struct bio *split = bio_split(bio, max_sectors,
>   					      gfp, &conf->bio_split);
> +		if (IS_ERR(split)) {
> +			error = PTR_ERR(split);
> +			goto err_handle;
> +		}
>   		bio_chain(split, bio);
>   		allow_barrier(conf);
>   		submit_bio_noacct(bio);
> @@ -1236,6 +1241,12 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>   	mddev_trace_remap(mddev, read_bio, r10_bio->sector);
>   	submit_bio_noacct(read_bio);
>   	return;
> +err_handle:
> +	atomic_dec(&rdev->nr_pending);

I just realized that for the raid1 patch, this is missed. read_balance()
from raid1 will increase nr_pending as well. :(

> +
> +	bio->bi_status = errno_to_blk_status(error);
> +	set_bit(R10BIO_Uptodate, &r10_bio->state);
> +	raid_end_bio_io(r10_bio);
>   }
>   
>   static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
> @@ -1347,9 +1358,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>   				 struct r10bio *r10_bio)
>   {
>   	struct r10conf *conf = mddev->private;
> -	int i;
> +	int i, k;
>   	sector_t sectors;
>   	int max_sectors;
> +	int error;
>   
>   	if ((mddev_is_clustered(mddev) &&
>   	     md_cluster_ops->area_resyncing(mddev, WRITE,
> @@ -1482,6 +1494,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>   	if (r10_bio->sectors < bio_sectors(bio)) {
>   		struct bio *split = bio_split(bio, r10_bio->sectors,
>   					      GFP_NOIO, &conf->bio_split);
> +		if (IS_ERR(split)) {
> +			error = PTR_ERR(split);
> +			goto err_handle;
> +		}
>   		bio_chain(split, bio);
>   		allow_barrier(conf);
>   		submit_bio_noacct(bio);
> @@ -1503,6 +1519,25 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>   			raid10_write_one_disk(mddev, r10_bio, bio, true, i);
>   	}
>   	one_write_done(r10_bio);
> +	return;
> +err_handle:
> +	for (k = 0;  k < i; k++) {
> +		struct md_rdev *rdev, *rrdev;
> +
> +		rdev = conf->mirrors[k].rdev;
> +		rrdev = conf->mirrors[k].replacement;

This looks wrong, r10_bio->devs[k].devnum should be used to deference
rdev from mirrors.
> +
> +		if (rdev)
> +			rdev_dec_pending(conf->mirrors[k].rdev, mddev);
> +		if (rrdev)
> +			rdev_dec_pending(conf->mirrors[k].rdev, mddev);

This is not correct for now, for the case that rdev is all BB in the
write range, continue will be reached in the loop and rrdev is skipped(
This doesn't look correct to skip rrdev). However, I'll suggest to use:

int d = r10_bio->devs[k].devnum;
if (r10_bio->devs[k].bio == NULL)
	rdev_dec_pending(conf->mirrors[d].rdev);
if (r10_bio->devs[k].repl_bio == NULL)
	rdev_dec_pending(conf->mirrors[d].replacement);

Thanks,
Kuai

> +		r10_bio->devs[k].bio = NULL;
> +		r10_bio->devs[k].repl_bio = NULL;
> +	}
> +
> +	bio->bi_status = errno_to_blk_status(error);
> +	set_bit(R10BIO_Uptodate, &r10_bio->state);
> +	raid_end_bio_io(r10_bio);
>   }
>   
>   static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
> @@ -1644,6 +1679,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>   	if (remainder) {
>   		split_size = stripe_size - remainder;
>   		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
> +		if (IS_ERR(split)) {
> +			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
> +			bio_endio(bio);
> +			return 0;
> +		}
>   		bio_chain(split, bio);
>   		allow_barrier(conf);
>   		/* Resend the fist split part */
> @@ -1654,6 +1694,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>   	if (remainder) {
>   		split_size = bio_sectors(bio) - remainder;
>   		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
> +		if (IS_ERR(split)) {
> +			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
> +			bio_endio(bio);
> +			return 0;
> +		}
>   		bio_chain(split, bio);
>   		allow_barrier(conf);
>   		/* Resend the second split part */
> 

