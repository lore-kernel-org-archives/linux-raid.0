Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369C52C181
	for <linux-raid@vger.kernel.org>; Thu,  2 Jan 2025 04:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735792598; cv=none; b=V8cmvVYjoIGtZE4gr4BJSb0SxMVMuECQ3U50h/YyIfS26MGMIljByIpDW63JD54dn38Rj9KCO7w481r/bfvSxKx0793mE1c3F1F3vqLyN0KWfY8QvaBixqLbnJMIhlQfoOz0prK2cK0MZi84FAp/noY0YbGE66EQRZDgIAfe0EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735792598; c=relaxed/simple;
	bh=5op1OdD1K35j5ISOYwjf1KjMmkiaZrtDFTUeq18bPm0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZsdPYvwZ9OiRHpcLH43dAyHlJ0ZA90IsOkXWaBh6eoSiX8JXwtEAg3xBepayO4wtuadjuf9GY5LPnvDyIsvTcfbDWUA+46wwL4lcGbksrzpqF/D2tpWVao1gk1mfYdu3G8XyfIuyRnyb3Oce4Gi5iGcsxsogVgiK3aMqwKHpxAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MSdoqTiJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MSdoqTiJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735792595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wCEzT9yJR838GZ92Q8hprzMEhrKPj7bSPeDIRvXP69c=;
	b=MSdoqTiJFv/FS3QfSRSHxmD34wciO/ZDeVrxqOJiDgxOOQJB+g3X7kdj0ayEm+H3Z/+K8t
	TB5OOaR3pBO8R5DEg9Smj+4RrZrlDmFLTanK0bdcHBt9Vpg5eY1fH5ZrxRzv6X2s9rn4Ae
	ph/Wg/t+JP8IZ9TaGiS6LlJ7P/rHQgI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-osrbpI8lMjyDOslSZKufwg-1; Wed, 01 Jan 2025 23:36:31 -0500
X-MC-Unique: osrbpI8lMjyDOslSZKufwg-1
X-Mimecast-MFC-AGG-ID: osrbpI8lMjyDOslSZKufwg
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2161d185f04so110557845ad.3
        for <linux-raid@vger.kernel.org>; Wed, 01 Jan 2025 20:36:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735792590; x=1736397390;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wCEzT9yJR838GZ92Q8hprzMEhrKPj7bSPeDIRvXP69c=;
        b=e9v+RtIC5TnxDkaAHDSHejHWUqW7hSIXkqLV54KB/JgRm3tnBe3YUDrK8uixqnZCUk
         mF7CY3s43ivRXoVaGT45kadjG7QGDkUwH3xfm2EgO6enKIAC/4aHNVxMdIXTi29Aymm3
         SCcPnNEbSn7s18esIL1Bia3AtYDsg+Ny19ChZ2bpfdwSFnnZqBj6YOzgHdEYQZcltD5u
         zT5a1R6+VHP0PlTvc91Bct+lhXvoIAqFWJLZOl3QX6bJYMHzG6HgpcJ4ikhaxLsP3xhc
         sC82ug9racHAqHb/BU+V1ugatExm626gZFtzcslchrGZEIlw6bIocXzjddpAmXOKcBjc
         d59w==
X-Gm-Message-State: AOJu0YwU3zgQsXSBwkrvXVJ7IQigzK/cUj2qBxy+RNtlCJ6svZNB/Y51
	FZ3wN0gRxLslXW/jy4Oodxft7cmTC4e3PAB91tB54XJcIOky4LNx5Xb+xHqbpc4a5maja6ZRdFc
	NAw30B/F5bkFwsGeyMjoBT3vruHtJHml+OlfOyX30rDA9gBiqEMopNY7rgiE=
X-Gm-Gg: ASbGncvnHAnvlXZk38UPNJuS8bMGo7T48SCivlWtuuE6lnuagf5pyL/BjxCUL5jrZto
	5xOtiDwFBwMT5Ymby8HvqyYz9uOD+lTHz07K9pUeQm90Ab+n2Jrr3eLOJDhyBO4+03q91FFwAJn
	dtJ+LwH9VB8RPJhXk4spIMh6awwmtiCeLG+6kIzuaNn4bKJBkgKog7tJ5+eARCtFn4eD6Yo8vQ4
	bay1n9VVCKl0BrZ/yjAJ2pTt5fNeZBdnq9H0TelLzBSs4ZasKg7tYpEve3rgCdF
X-Received: by 2002:a05:6a20:6a25:b0:1d9:6c9c:75ea with SMTP id adf61e73a8af0-1e5e0448930mr69171566637.5.1735792590107;
        Wed, 01 Jan 2025 20:36:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFeWiYh7EO4B1RM+qEBM79pKOOrIgP+s/OBMV8sGYLELNtu841JlufeN8Q1Bklj+CetLo7b/w==
X-Received: by 2002:a05:6a20:6a25:b0:1d9:6c9c:75ea with SMTP id adf61e73a8af0-1e5e0448930mr69171540637.5.1735792589706;
        Wed, 01 Jan 2025 20:36:29 -0800 (PST)
Received: from [10.72.120.21] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad90c173sm23286541b3a.192.2025.01.01.20.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jan 2025 20:36:29 -0800 (PST)
Message-ID: <44060086-d3b0-482c-ad9a-cdf7ef01a05c@redhat.com>
Date: Thu, 2 Jan 2025 12:36:23 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 md-6.14 5/5] md/md-bitmap: move bitmap_{start,
 end}write to md upper layer
To: yukuai@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@hauwei.com, yangerkun@huawei.com
References: <20241218121745.2459-1-yukuai@kernel.org>
 <20241218121745.2459-6-yukuai@kernel.org>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20241218121745.2459-6-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2024/12/18 下午8:17, yukuai@kernel.org 写道:
> From: Yu Kuai <yukuai3@huawei.com>
>
> There are two BUG reports that raid5 will hang at
> bitmap_startwrite([1],[2]), root cause is that bitmap start write and end
> write is unbalanced. For example, handle_stripe_clean_event() doesn't
> check if stripe->dev[].towrite is NULL after tag 'returnbi', and extra
> bitmap_endwrite() will be called.


Hi Kuai

bitmap startwrite is called if dev[].to_write is added a bio when 
to_write is NULL. And it needs a full write when a stripe is added to 
batch list. So in handle_stripe_clean_event, the dev[].written must have 
value when it goto returnbi. The unbalanced case you mentioned doesn't 
exist? So it should not be the root cause of the two reported problems 
mentioned below.

>
> While reviewing raid5 code, it's found that bitmap operations can be
> optimized. For example, for a 4 disks raid5, with chunksize=8k, if user
> issue a IO (0 + 48k) to the array:
>
> ┌────────────────────────────────────────────────────────────┐
> │chunk 0                                                     │
> │      ┌────────────┬─────────────┬─────────────┬────────────┼
> │  sh0 │A0: 0 + 4k  │A1: 8k + 4k  │A2: 16k + 4k │A3: P       │
> │      ┼────────────┼─────────────┼─────────────┼────────────┼
> │  sh1 │B0: 4k + 4k │B1: 12k + 4k │B2: 20k + 4k │B3: P       │
> ┼──────┴────────────┴─────────────┴─────────────┴────────────┼
> │chunk 1                                                     │
> │      ┌────────────┬─────────────┬─────────────┬────────────┤
> │  sh2 │C0: 24k + 4k│C1: 32k + 4k │C2: P        │C3: 40k + 4k│
> │      ┼────────────┼─────────────┼─────────────┼────────────┼
> │  sh3 │D0: 28k + 4k│D1: 36k + 4k │D2: P        │D3: 44k + 4k│
> └──────┴────────────┴─────────────┴─────────────┴────────────┘
>
> Before this patch, 4 stripe head will be used, and each sh will attach
> bio for 3 disks, and each attached bio will trigger
> bitmap_startwrite() once, which means total 12 times.
>   - 3 times (0 + 4k), for (A0, A1 and A2)
>   - 3 times (4 + 4k), for (B0, B1 and B2)
>   - 3 times (8 + 4k), for (C0, C1 and C3)
>   - 3 times (12 + 4k), for (D0, D1 and D3)
>
> After this patch, md upper layer will calculate that IO range (0 + 48k)
> is corresponding to the bitmap (0 + 16k), and call bitmap_startwrite()
> just once.
>
> Noted that this patch will align bitmap ranges to the chunks, for example,
> if user issue a IO (0 + 4k) to array:
>
> - Before this patch, 1 time (0 + 4k), for A0;
> - After this patch, 1 time (0 + 8k) for chunk 0;
>
> Usually, one bitmap bit will represent more than one disk chunk, and this
> doesn't have any difference. And even if user really created a array
> that one chunk contain multiple bits, the overhead is that more data
> will be recovered after power failure.
>
> [1] https://lore.kernel.org/all/CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com/
> [2] https://lore.kernel.org/all/ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io/
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Yu Kuai <yukuai@kernel.org>
> ---
>   drivers/md/md.c          | 29 +++++++++++++++++++++++++++++
>   drivers/md/md.h          |  2 ++
>   drivers/md/raid1.c       |  4 ----
>   drivers/md/raid10.c      |  3 ---
>   drivers/md/raid5-cache.c |  2 --
>   drivers/md/raid5.c       | 24 +-----------------------
>   6 files changed, 32 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aebe12b0ee27..c60ae2c70102 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8745,12 +8745,32 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>   }
>   EXPORT_SYMBOL_GPL(md_submit_discard_bio);
>   
> +static void md_bitmap_start(struct mddev *mddev,
> +			    struct md_io_clone *md_io_clone)
> +{
> +	if (mddev->pers->bitmap_sector)
> +		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
> +					   &md_io_clone->sectors);
> +
> +	mddev->bitmap_ops->startwrite(mddev, md_io_clone->offset,
> +				      md_io_clone->sectors);
> +}
> +
> +static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
> +{
> +	mddev->bitmap_ops->endwrite(mddev, md_io_clone->offset,
> +				    md_io_clone->sectors);
> +}
> +
>   static void md_end_clone_io(struct bio *bio)
>   {
>   	struct md_io_clone *md_io_clone = bio->bi_private;
>   	struct bio *orig_bio = md_io_clone->orig_bio;
>   	struct mddev *mddev = md_io_clone->mddev;
>   
> +	if (bio_data_dir(orig_bio) == WRITE && mddev->bitmap)
> +		md_bitmap_end(mddev, md_io_clone);
> +
>   	if (bio->bi_status && !orig_bio->bi_status)
>   		orig_bio->bi_status = bio->bi_status;
>   
> @@ -8775,6 +8795,12 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
>   	if (blk_queue_io_stat(bdev->bd_disk->queue))
>   		md_io_clone->start_time = bio_start_io_acct(*bio);
>   
> +	if (bio_data_dir(*bio) == WRITE && mddev->bitmap) {
> +		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
> +		md_io_clone->sectors = bio_sectors(*bio);
> +		md_bitmap_start(mddev, md_io_clone);
> +	}
> +
>   	clone->bi_end_io = md_end_clone_io;
>   	clone->bi_private = md_io_clone;
>   	*bio = clone;
> @@ -8793,6 +8819,9 @@ void md_free_cloned_bio(struct bio *bio)
>   	struct bio *orig_bio = md_io_clone->orig_bio;
>   	struct mddev *mddev = md_io_clone->mddev;
>   
> +	if (bio_data_dir(orig_bio) == WRITE && mddev->bitmap)
> +		md_bitmap_end(mddev, md_io_clone);
> +
>   	if (bio->bi_status && !orig_bio->bi_status)
>   		orig_bio->bi_status = bio->bi_status;
>   
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index de6dadb9a40b..def808064ad8 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -831,6 +831,8 @@ struct md_io_clone {
>   	struct mddev	*mddev;
>   	struct bio	*orig_bio;
>   	unsigned long	start_time;
> +	sector_t	offset;
> +	unsigned long	sectors;
>   	struct bio	bio_clone;
>   };
>   
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 81dff2cea0db..b5a5766cccf7 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -422,8 +422,6 @@ static void close_write(struct r1bio *r1_bio)
>   
>   	if (test_bit(R1BIO_BehindIO, &r1_bio->state))
>   		mddev->bitmap_ops->end_behind_write(mddev);
> -	/* clear the bitmap if all writes complete successfully */
> -	mddev->bitmap_ops->endwrite(mddev, r1_bio->sector, r1_bio->sectors);
>   	md_write_end(mddev);
>   }
>   
> @@ -1647,8 +1645,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   
>   			if (test_bit(R1BIO_BehindIO, &r1_bio->state))
>   				mddev->bitmap_ops->start_behind_write(mddev);
> -			mddev->bitmap_ops->startwrite(mddev, r1_bio->sector,
> -						      r1_bio->sectors);
>   			first_clone = 0;
>   		}
>   
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 3dc0170125b2..2fe8e6f96057 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -428,8 +428,6 @@ static void close_write(struct r10bio *r10_bio)
>   {
>   	struct mddev *mddev = r10_bio->mddev;
>   
> -	/* clear the bitmap if all writes complete successfully */
> -	mddev->bitmap_ops->endwrite(mddev, r10_bio->sector, r10_bio->sectors);
>   	md_write_end(mddev);
>   }
>   
> @@ -1517,7 +1515,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>   	md_account_bio(mddev, &bio);
>   	r10_bio->master_bio = bio;
>   	atomic_set(&r10_bio->remaining, 1);
> -	mddev->bitmap_ops->startwrite(mddev, r10_bio->sector, r10_bio->sectors);
>   
>   	for (i = 0; i < conf->copies; i++) {
>   		if (r10_bio->devs[i].bio)
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index ba4f9577c737..011246e16a99 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -313,8 +313,6 @@ void r5c_handle_cached_data_endio(struct r5conf *conf,
>   		if (sh->dev[i].written) {
>   			set_bit(R5_UPTODATE, &sh->dev[i].flags);
>   			r5c_return_dev_pending_writes(conf, &sh->dev[i]);
> -			conf->mddev->bitmap_ops->endwrite(conf->mddev,
> -					sh->sector, RAID5_STRIPE_SECTORS(conf));
>   		}
>   	}
>   }
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b2fe201b599d..017439e2af03 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3578,12 +3578,6 @@ static void __add_stripe_bio(struct stripe_head *sh, struct bio *bi,
>   		 * is added to a batch, STRIPE_BIT_DELAY cannot be changed
>   		 * any more.
>   		 */
> -		set_bit(STRIPE_BITMAP_PENDING, &sh->state);
> -		spin_unlock_irq(&sh->stripe_lock);
> -		conf->mddev->bitmap_ops->startwrite(conf->mddev, sh->sector,
> -					RAID5_STRIPE_SECTORS(conf));
> -		spin_lock_irq(&sh->stripe_lock);
> -		clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
>   		if (!sh->batch_head) {
>   			sh->bm_seq = conf->seq_flush+1;
>   			set_bit(STRIPE_BIT_DELAY, &sh->state);
> @@ -3638,7 +3632,6 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   	BUG_ON(sh->batch_head);
>   	for (i = disks; i--; ) {
>   		struct bio *bi;
> -		int bitmap_end = 0;
>   
>   		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
>   			struct md_rdev *rdev = conf->disks[i].rdev;
> @@ -3663,8 +3656,6 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   		sh->dev[i].towrite = NULL;
>   		sh->overwrite_disks = 0;
>   		spin_unlock_irq(&sh->stripe_lock);
> -		if (bi)
> -			bitmap_end = 1;
>   
>   		log_stripe_write_finished(sh);
>   
> @@ -3679,10 +3670,6 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   			bio_io_error(bi);
>   			bi = nextbi;
>   		}
> -		if (bitmap_end)
> -			conf->mddev->bitmap_ops->endwrite(conf->mddev,
> -					sh->sector, RAID5_STRIPE_SECTORS(conf));
> -		bitmap_end = 0;
>   		/* and fail all 'written' */
>   		bi = sh->dev[i].written;
>   		sh->dev[i].written = NULL;
> @@ -3691,7 +3678,6 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   			sh->dev[i].page = sh->dev[i].orig_page;
>   		}
>   
> -		if (bi) bitmap_end = 1;
>   		while (bi && bi->bi_iter.bi_sector <
>   		       sh->dev[i].sector + RAID5_STRIPE_SECTORS(conf)) {
>   			struct bio *bi2 = r5_next_bio(conf, bi, sh->dev[i].sector);
> @@ -3725,9 +3711,6 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   				bi = nextbi;
>   			}
>   		}
> -		if (bitmap_end)
> -			conf->mddev->bitmap_ops->endwrite(conf->mddev,
> -					sh->sector, RAID5_STRIPE_SECTORS(conf));
>   		/* If we were in the middle of a write the parity block might
>   		 * still be locked - so just clear all R5_LOCKED flags
>   		 */
> @@ -4076,8 +4059,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
>   					bio_endio(wbi);
>   					wbi = wbi2;
>   				}
> -				conf->mddev->bitmap_ops->endwrite(conf->mddev,
> -					sh->sector, RAID5_STRIPE_SECTORS(conf));
> +
>   				if (head_sh->batch_head) {
>   					sh = list_first_entry(&sh->batch_list,
>   							      struct stripe_head,
> @@ -5797,10 +5779,6 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
>   		}
>   		spin_unlock_irq(&sh->stripe_lock);
>   		if (conf->mddev->bitmap) {
> -			for (d = 0; d < conf->raid_disks - conf->max_degraded;
> -			     d++)
> -				mddev->bitmap_ops->startwrite(mddev, sh->sector,
> -					RAID5_STRIPE_SECTORS(conf));
>   			sh->bm_seq = conf->seq_flush + 1;
>   			set_bit(STRIPE_BIT_DELAY, &sh->state);
>   		}


For the patch itself, I'm good. I did a sequetial write performance 
test, it indeed improve the performance about 20% with nvme devices.

Reviewed-by: Xiao Ni <xni@redhat.com>

