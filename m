Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135A01A285;
	Mon, 22 Sep 2025 02:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758506476; cv=none; b=WaoVk1LLLB77gaTeCxdG89Cg1Q8zf13YslsiI3EE0KyeUbvnSuO7YB2pmwewGRB/kH5r5kEyjBLCS4ReaeMzRkvkz/AqAJqzxtpp7EC0j8BQLn178n+9T4knjAkudF8kC/+hsPj/qggbGPTEGap10w2nwBZwWkBQGNQSzUvgj14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758506476; c=relaxed/simple;
	bh=D+Czq0gZvzYEtmk/aSmSdvbKLoqeewgul78UxHS99ik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tMY7G8tUN17oU/bkUF4KeP2CBEVOu4BaP91SR4KJbAy84tkejt3hMipkSNw1g0jOmHF1q44knp14RaPOdagFozJgP8Ow0mfWEx0vbRXtPTx6Xc1qWofI3PMoAQZXdBr01XRcEJFfZqY1bC2LPlaH4aev0SSAUnM7EG85LclXoJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cVRD15BVczYQv4K;
	Mon, 22 Sep 2025 10:01:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 44E721A1675;
	Mon, 22 Sep 2025 10:01:09 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgDHjGTfrdBo2dGXAQ--.16041S3;
	Mon, 22 Sep 2025 10:01:05 +0800 (CST)
Message-ID: <9e38a891-f5be-41ce-e00f-9ef8f905de10@huaweicloud.com>
Date: Mon, 22 Sep 2025 10:01:03 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/7] md: mark rdev Faulty when badblocks setting fails
To: linan666@huaweicloud.com, song@kernel.org, yukuai3@huawei.com,
 neil@brown.name, namhyung@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250917093508.456790-1-linan666@huaweicloud.com>
 <20250917093508.456790-3-linan666@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250917093508.456790-3-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHjGTfrdBo2dGXAQ--.16041S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Zw4fWFy7tr1UGry3tr4fXwb_yoWkXFWDp3
	yDGasayrZ8JryrX3WUAFWDWF9Y934ftFW2yr4xKw1xCwn5Kr93KF48XryYgFykAF9xuF47
	X3Z8WrWDZrWDKFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQVy7UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/17 17:35, linan666@huaweicloud.com 写道:
> From: Li Nan <linan122@huawei.com>
> 
> Currently when sync read fails and badblocks set fails (exceeding
> 512 limit), rdev isn't immediately marked Faulty. Instead
> 'recovery_disabled' is set and non-In_sync rdevs are removed later.
> This preserves array availability if bad regions aren't read, but bad
> sectors might be read by users before rdev removal. This occurs due
> to incorrect resync/recovery_offset updates that include these bad
> sectors.
> 
> When badblocks exceed 512, keeping the disk provides little benefit
> while adding complexity. Prompt disk replacement is more important.
> Therefore when badblocks set fails, directly call md_error to mark rdev
> Faulty immediately, preventing potential data access issues.
> 
> After this change, cleanup of offset update logic and 'recovery_disabled'
> handling will follow.
> 
> Fixes: 5e5702898e93 ("md/raid10: Handle read errors during recovery better.")
> Fixes: 3a9f28a5117e ("md/raid1: improve handling of read failure during recovery.")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.c     |  8 ++++++-
>   drivers/md/raid1.c  | 41 +++++++++++++++--------------------
>   drivers/md/raid10.c | 53 ++++++++++++++++++++-------------------------
>   drivers/md/raid5.c  | 22 ++++++++-----------
>   4 files changed, 57 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1795f725f7fb..05b6b3145648 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -10245,8 +10245,14 @@ bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>   	else
>   		s += rdev->data_offset;
>   
> -	if (!badblocks_set(&rdev->badblocks, s, sectors, 0))
> +	if (!badblocks_set(&rdev->badblocks, s, sectors, 0)) {
> +		/*
> +		 * Mark the disk as Faulty when setting badblocks fails,
> +		 * otherwise, bad sectors may be read.
> +		 */
> +		md_error(mddev, rdev);
>   		return false;
> +	}
>   
>   	/* Make sure they get written out promptly */
>   	if (test_bit(ExternalBbl, &rdev->flags))
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 397b3a2eaee4..f7238e9f35e5 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2127,8 +2127,7 @@ static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
>   				rdev->mddev->recovery);
>   	}
>   	/* need to record an error - either for the block or the device */
> -	if (!rdev_set_badblocks(rdev, sector, sectors, 0))
> -		md_error(rdev->mddev, rdev);
> +	rdev_set_badblocks(rdev, sector, sectors, 0);
>   	return 0;
>   }
>   
> @@ -2453,8 +2452,7 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>   		if (!success) {
>   			/* Cannot read from anywhere - mark it bad */
>   			struct md_rdev *rdev = conf->mirrors[read_disk].rdev;
> -			if (!rdev_set_badblocks(rdev, sect, s, 0))
> -				md_error(mddev, rdev);
> +			rdev_set_badblocks(rdev, sect, s, 0);
>   			break;
>   		}
>   		/* write it back and re-read */
> @@ -2498,7 +2496,7 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>   	}
>   }
>   
> -static bool narrow_write_error(struct r1bio *r1_bio, int i)
> +static void narrow_write_error(struct r1bio *r1_bio, int i)
>   {
>   	struct mddev *mddev = r1_bio->mddev;
>   	struct r1conf *conf = mddev->private;
> @@ -2519,10 +2517,9 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
>   	sector_t sector;
>   	int sectors;
>   	int sect_to_write = r1_bio->sectors;
> -	bool ok = true;
>   
>   	if (rdev->badblocks.shift < 0)
> -		return false;
> +		return;
>   
>   	block_sectors = roundup(1 << rdev->badblocks.shift,
>   				bdev_logical_block_size(rdev->bdev) >> 9);
> @@ -2553,18 +2550,21 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
>   		bio_trim(wbio, sector - r1_bio->sector, sectors);
>   		wbio->bi_iter.bi_sector += rdev->data_offset;
>   
> -		if (submit_bio_wait(wbio) < 0)
> -			/* failure! */
> -			ok = rdev_set_badblocks(rdev, sector,
> -						sectors, 0)
> -				&& ok;
> +		if (submit_bio_wait(wbio) < 0 &&
> +		    !rdev_set_badblocks(rdev, sector, sectors, 0)) {
> +			/*
> +			 * Badblocks set failed, disk marked Faulty.
> +			 * No further operations needed.
> +			 */
> +			bio_put(wbio);
> +			break;
> +		}
>   
>   		bio_put(wbio);
>   		sect_to_write -= sectors;
>   		sector += sectors;
>   		sectors = block_sectors;
>   	}
> -	return ok;
>   }
>   
>   static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
> @@ -2577,14 +2577,11 @@ static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio
>   		if (bio->bi_end_io == NULL)
>   			continue;
>   		if (!bio->bi_status &&
> -		    test_bit(R1BIO_MadeGood, &r1_bio->state)) {
> +		    test_bit(R1BIO_MadeGood, &r1_bio->state))
>   			rdev_clear_badblocks(rdev, r1_bio->sector, s, 0);
> -		}
>   		if (bio->bi_status &&
> -		    test_bit(R1BIO_WriteError, &r1_bio->state)) {
> -			if (!rdev_set_badblocks(rdev, r1_bio->sector, s, 0))
> -				md_error(conf->mddev, rdev);
> -		}
> +		    test_bit(R1BIO_WriteError, &r1_bio->state))
> +			rdev_set_badblocks(rdev, r1_bio->sector, s, 0);
>   	}
>   	put_buf(r1_bio);
>   	md_done_sync(conf->mddev, s);
> @@ -2608,10 +2605,8 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>   			 * errors.
>   			 */
>   			fail = true;
> -			if (!narrow_write_error(r1_bio, m))
> -				md_error(conf->mddev,
> -					 conf->mirrors[m].rdev);
> -				/* an I/O failed, we can't clear the bitmap */
> +			narrow_write_error(r1_bio, m);
> +			/* an I/O failed, we can't clear the bitmap */
>   			rdev_dec_pending(conf->mirrors[m].rdev,
>   					 conf->mddev);
>   		}
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 2899fd1ecc57..4c58c32f7c27 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2610,8 +2610,7 @@ static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
>   				&rdev->mddev->recovery);
>   	}
>   	/* need to record an error - either for the block or the device */
> -	if (!rdev_set_badblocks(rdev, sector, sectors, 0))
> -		md_error(rdev->mddev, rdev);
> +	rdev_set_badblocks(rdev, sector, sectors, 0);
>   	return 0;
>   }
>   
> @@ -2692,7 +2691,6 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
>   				    r10_bio->devs[slot].addr
>   				    + sect,
>   				    s, 0)) {
> -				md_error(mddev, rdev);
>   				r10_bio->devs[slot].bio
>   					= IO_BLOCKED;
>   			}
> @@ -2779,7 +2777,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
>   	}
>   }
>   
> -static bool narrow_write_error(struct r10bio *r10_bio, int i)
> +static void narrow_write_error(struct r10bio *r10_bio, int i)
>   {
>   	struct bio *bio = r10_bio->master_bio;
>   	struct mddev *mddev = r10_bio->mddev;
> @@ -2800,10 +2798,9 @@ static bool narrow_write_error(struct r10bio *r10_bio, int i)
>   	sector_t sector;
>   	int sectors;
>   	int sect_to_write = r10_bio->sectors;
> -	bool ok = true;
>   
>   	if (rdev->badblocks.shift < 0)
> -		return false;
> +		return;
>   

A direct return here is incorrect. This change ought to be removed after
Kenta's cleanup. I will fix it after that cleanup merged.

https://lore.kernel.org/all/cbce67bc-74c6-0c99-fdba-48cd8aa27dda@huaweicloud.com/

>   	block_sectors = roundup(1 << rdev->badblocks.shift,
>   				bdev_logical_block_size(rdev->bdev) >> 9);
> @@ -2826,18 +2823,21 @@ static bool narrow_write_error(struct r10bio *r10_bio, int i)
>   				   choose_data_offset(r10_bio, rdev);
>   		wbio->bi_opf = REQ_OP_WRITE;
>   
> -		if (submit_bio_wait(wbio) < 0)
> -			/* Failure! */
> -			ok = rdev_set_badblocks(rdev, wsector,
> -						sectors, 0)
> -				&& ok;
> +		if (submit_bio_wait(wbio) < 0 &&
> +		    rdev_set_badblocks(rdev, wsector, sectors, 0)) {
> +			/*
> +			 * Badblocks set failed, disk marked Faulty.
> +			 * No further operations needed.
> +			 */
> +			bio_put(wbio);
> +			break;
> +		}
>   
>   		bio_put(wbio);
>   		sect_to_write -= sectors;
>   		sector += sectors;
>   		sectors = block_sectors;
>   	}
> -	return ok;
>   }
>   
>   static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
> @@ -2897,35 +2897,29 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
>   			if (r10_bio->devs[m].bio == NULL ||
>   				r10_bio->devs[m].bio->bi_end_io == NULL)
>   				continue;
> -			if (!r10_bio->devs[m].bio->bi_status) {
> +			if (!r10_bio->devs[m].bio->bi_status)
>   				rdev_clear_badblocks(
>   					rdev,
>   					r10_bio->devs[m].addr,
>   					r10_bio->sectors, 0);
> -			} else {
> -				if (!rdev_set_badblocks(
> -					    rdev,
> -					    r10_bio->devs[m].addr,
> -					    r10_bio->sectors, 0))
> -					md_error(conf->mddev, rdev);
> -			}
> +			else
> +				rdev_set_badblocks(rdev,
> +						   r10_bio->devs[m].addr,
> +						   r10_bio->sectors, 0);
>   			rdev = conf->mirrors[dev].replacement;
>   			if (r10_bio->devs[m].repl_bio == NULL ||
>   				r10_bio->devs[m].repl_bio->bi_end_io == NULL)
>   				continue;
>   
> -			if (!r10_bio->devs[m].repl_bio->bi_status) {
> +			if (!r10_bio->devs[m].repl_bio->bi_status)
>   				rdev_clear_badblocks(
>   					rdev,
>   					r10_bio->devs[m].addr,
>   					r10_bio->sectors, 0);
> -			} else {
> -				if (!rdev_set_badblocks(
> -					    rdev,
> -					    r10_bio->devs[m].addr,
> -					    r10_bio->sectors, 0))
> -					md_error(conf->mddev, rdev);
> -			}
> +			else
> +				rdev_set_badblocks(rdev,
> +						   r10_bio->devs[m].addr,
> +						   r10_bio->sectors, 0);
>   		}
>   		put_buf(r10_bio);
>   	} else {
> @@ -2942,8 +2936,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
>   				rdev_dec_pending(rdev, conf->mddev);
>   			} else if (bio != NULL && bio->bi_status) {
>   				fail = true;
> -				if (!narrow_write_error(r10_bio, m))
> -					md_error(conf->mddev, rdev);
> +				narrow_write_error(r10_bio, m);
>   				rdev_dec_pending(rdev, conf->mddev);
>   			}
>   			bio = r10_bio->devs[m].repl_bio;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b09265fb872a..70106abf2110 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2817,11 +2817,9 @@ static void raid5_end_read_request(struct bio * bi)
>   		else {
>   			clear_bit(R5_ReadError, &sh->dev[i].flags);
>   			clear_bit(R5_ReWrite, &sh->dev[i].flags);
> -			if (!(set_bad
> -			      && test_bit(In_sync, &rdev->flags)
> -			      && rdev_set_badblocks(
> -				      rdev, sh->sector, RAID5_STRIPE_SECTORS(conf), 0)))
> -				md_error(conf->mddev, rdev);
> +			if (!(set_bad && test_bit(In_sync, &rdev->flags)))
> +				rdev_set_badblocks(rdev, sh->sector,
> +						   RAID5_STRIPE_SECTORS(conf), 0);
>   		}
>   	}
>   	rdev_dec_pending(rdev, conf->mddev);
> @@ -3599,11 +3597,10 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   			else
>   				rdev = NULL;
>   			if (rdev) {
> -				if (!rdev_set_badblocks(
> -					    rdev,
> -					    sh->sector,
> -					    RAID5_STRIPE_SECTORS(conf), 0))
> -					md_error(conf->mddev, rdev);
> +				rdev_set_badblocks(rdev,
> +						   sh->sector,
> +						   RAID5_STRIPE_SECTORS(conf),
> +						   0);
>   				rdev_dec_pending(rdev, conf->mddev);
>   			}
>   		}
> @@ -5254,9 +5251,8 @@ static void handle_stripe(struct stripe_head *sh)
>   			if (test_and_clear_bit(R5_WriteError, &dev->flags)) {
>   				/* We own a safe reference to the rdev */
>   				rdev = conf->disks[i].rdev;
> -				if (!rdev_set_badblocks(rdev, sh->sector,
> -							RAID5_STRIPE_SECTORS(conf), 0))
> -					md_error(conf->mddev, rdev);
> +				rdev_set_badblocks(rdev, sh->sector,
> +						   RAID5_STRIPE_SECTORS(conf), 0);
>   				rdev_dec_pending(rdev, conf->mddev);
>   			}
>   			if (test_and_clear_bit(R5_MadeGood, &dev->flags)) {

-- 
Thanks,
Nan

