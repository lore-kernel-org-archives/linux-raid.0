Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EA72206B3
	for <linux-raid@vger.kernel.org>; Wed, 16 Apr 2025 06:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744784853; cv=none; b=myozM4iSIVvp2RRddC2lnGdNOickRITH2+94Xf6PSnRC2TppuOJROyDJp+ZLNxIsXQVf/HBW+aLiM26eqDccXFWYZSY0D6zN8ZcKOyuTuhH+C3fSYEx1t66f6POUhINVyqIZTvGA/EO41bgz7Ckd+uehwKzV6Iv3cUidOM2DK1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744784853; c=relaxed/simple;
	bh=KjFq3ynfOWjZNsyInKkKjA/dyH3wqhE4YtixTLTY+4I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s12GtMbLyJOXIdP9OEbHZcQLdjl5CwULHKrbWgqM0zOaH4t5b2JOr436Ss05L68YBjCzAsybJqLYp7iH2dNuq6joYYJw3ePzP52w6+pSabC2WSxYKZ3lsnT4hmKZvJ6gLmgNwP3hTebpi3vCPgn/relOzDB1keDOP/1kkJp9czg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FF3+zQT8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FF3+zQT8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744784849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LTqsEaqfQoRzUYlJ/wtXYrZAFHrCEWxlQ9NWGQ3mbUg=;
	b=FF3+zQT8+l1EohlsfaAEOTn/YOsu2LljgRC/KrKt97NBGSLsS8UsRN+FJlVe2B5y5npUEU
	MCEpNYjm3eRTxMx9oCjHnO5TjNv1yyRncv8w7wYL6M3fW43q4S3jYmwEExN3hSbpokFZBv
	7RbeBD9uuXaTUfq8W0LaFYetnCcSwy0=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-SqHVP8SIMT-8QyP7oSQrIQ-1; Wed, 16 Apr 2025 02:27:28 -0400
X-MC-Unique: SqHVP8SIMT-8QyP7oSQrIQ-1
X-Mimecast-MFC-AGG-ID: SqHVP8SIMT-8QyP7oSQrIQ_1744784847
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-afd1e7f52f7so3805815a12.1
        for <linux-raid@vger.kernel.org>; Tue, 15 Apr 2025 23:27:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744784847; x=1745389647;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LTqsEaqfQoRzUYlJ/wtXYrZAFHrCEWxlQ9NWGQ3mbUg=;
        b=G0lWVQ/4f8C2Q44CQ3TM2ocx5DCo9j3EZ8V0U57srjue4z0dD7xk4EdtHncrqtox1m
         q/uC8J1DDTbaupS1ZnXmqnr5NDsOUFcQ1/PQ8PNIKwm50QOw7TAFP9+m+/fbLy1rh6dq
         jO1P8ga+p9pKVkFSLSwqcEn6/pvN2XtKUI6ylK65vXz4ehHFBgq9IOTIxg2np7gFJ8bQ
         IVQ3Fw0+ZReBKEDRqwGOmXXhX9bzigF3pkWtI2PgRtw9qJLj14WSprA3OBd98D73QEIZ
         eyN1l9tA2Qo+A3bgwMeiz9LWsj5Br0SG9nsgBRj06xV9GSBtAe8r4r0bxVLnuDk3haib
         qDBA==
X-Forwarded-Encrypted: i=1; AJvYcCWoqVs8oa9Tx0DI7j09QxnyCCT388BvaIXLNc75jROtjk927L3hBfEihwNTl6XNqkTAhgXDzMtIubRA@vger.kernel.org
X-Gm-Message-State: AOJu0YwQO/99vh1HKEWv8JNzFUv2q+AtAAdhkFff4EoNR6srRLgiy6or
	XtUFGuvXDTikr8ZEt/hnzxYD90CmuMukC9NxYVyi6x7l5Rusq8i8KxvfhwI2jSwkcEJgoGCDPSo
	T+LTlCRZw7eDck+vd2YiT6BSxLEtHfukSF7CURh2MIUYP/lIYrDRzVz16bqA=
X-Gm-Gg: ASbGnct+IwL6mDgwAcLUGxkLeL/pH4QtkdfuqwflkcVkFf3aR45B4mJC70JRjiphWhE
	srxRmj1cfQY0avnqDgu16S7MwrHUF2K7zdz/StuKBRf5GYTxDVaWflcWmgoXZqjtBmmijuZZ8A4
	n//oga6Y+RjJ+aT0s/DKqHd8DDvO49+glrOJYxXXhvUBu7DyO/XrdU5Pnbia8QIF7y+YtgWXmc3
	468evDGu4kbv8Emyay5pTCA00NkGlREuD1g87W8Y8trCXKGFHP11JUoNgH2HKQIa+ikKtUfY6Ee
	YyCb1lx64yqD1GaYdQ==
X-Received: by 2002:a17:902:ce88:b0:21f:4b01:b978 with SMTP id d9443c01a7336-22c3597436cmr11166235ad.36.1744784847371;
        Tue, 15 Apr 2025 23:27:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH65SPAk/t8wIySGFu6g6N8vPfjCaLNMJi9CRSCpVVdQZvYfu4SCB2iJn99ol3s5Ctog3UPcQ==
X-Received: by 2002:a17:902:ce88:b0:21f:4b01:b978 with SMTP id d9443c01a7336-22c3597436cmr11166055ad.36.1744784847063;
        Tue, 15 Apr 2025 23:27:27 -0700 (PDT)
Received: from [10.72.120.8] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c33feb339sm6113475ad.257.2025.04.15.23.27.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 23:27:26 -0700 (PDT)
Message-ID: <a2444c8a-7c76-44de-a8e8-4023dbdaeb4b@redhat.com>
Date: Wed, 16 Apr 2025 14:27:21 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] md: cleanup accounting for issued sync IO
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, song@kernel.org,
 yukuai3@huawei.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20250412073202.3085138-1-yukuai1@huaweicloud.com>
 <20250412073202.3085138-5-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20250412073202.3085138-5-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/4/12 下午3:32, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
>
> It's no longer used and can be removed, also remove the field
> 'gendisk->sync_io'.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.h        | 11 -----------
>   drivers/md/raid1.c     |  3 ---
>   drivers/md/raid10.c    |  9 ---------
>   drivers/md/raid5.c     |  8 --------
>   include/linux/blkdev.h |  1 -
>   5 files changed, 32 deletions(-)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 95cf11c4abc6..6233ec9f10a3 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -716,17 +716,6 @@ static inline int mddev_trylock(struct mddev *mddev)
>   }
>   extern void mddev_unlock(struct mddev *mddev);
>   
> -static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
> -{
> -	if (blk_queue_io_stat(bdev->bd_disk->queue))
> -		atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
> -}
> -
> -static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
> -{
> -	md_sync_acct(bio->bi_bdev, nr_sectors);
> -}
> -
>   struct md_personality
>   {
>   	struct md_submodule_head head;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index de9bccbe7337..657d481525be 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2382,7 +2382,6 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
>   
>   		wbio->bi_end_io = end_sync_write;
>   		atomic_inc(&r1_bio->remaining);
> -		md_sync_acct(conf->mirrors[i].rdev->bdev, bio_sectors(wbio));
>   
>   		submit_bio_noacct(wbio);
>   	}
> @@ -3055,7 +3054,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
>   			bio = r1_bio->bios[i];
>   			if (bio->bi_end_io == end_sync_read) {
>   				read_targets--;
> -				md_sync_acct_bio(bio, nr_sectors);
>   				if (read_targets == 1)
>   					bio->bi_opf &= ~MD_FAILFAST;
>   				submit_bio_noacct(bio);
> @@ -3064,7 +3062,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
>   	} else {
>   		atomic_set(&r1_bio->remaining, 1);
>   		bio = r1_bio->bios[r1_bio->read_disk];
> -		md_sync_acct_bio(bio, nr_sectors);
>   		if (read_targets == 1)
>   			bio->bi_opf &= ~MD_FAILFAST;
>   		submit_bio_noacct(bio);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index ba32bac975b8..dce06bf65016 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2426,7 +2426,6 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>   
>   		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
>   		atomic_inc(&r10_bio->remaining);
> -		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(tbio));
>   
>   		if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
>   			tbio->bi_opf |= MD_FAILFAST;
> @@ -2448,8 +2447,6 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>   			bio_copy_data(tbio, fbio);
>   		d = r10_bio->devs[i].devnum;
>   		atomic_inc(&r10_bio->remaining);
> -		md_sync_acct(conf->mirrors[d].replacement->bdev,
> -			     bio_sectors(tbio));
>   		submit_bio_noacct(tbio);
>   	}
>   
> @@ -2583,13 +2580,10 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>   	d = r10_bio->devs[1].devnum;
>   	if (wbio->bi_end_io) {
>   		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
> -		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
>   		submit_bio_noacct(wbio);
>   	}
>   	if (wbio2) {
>   		atomic_inc(&conf->mirrors[d].replacement->nr_pending);
> -		md_sync_acct(conf->mirrors[d].replacement->bdev,
> -			     bio_sectors(wbio2));
>   		submit_bio_noacct(wbio2);
>   	}
>   }
> @@ -3757,7 +3751,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
>   		r10_bio->sectors = nr_sectors;
>   
>   		if (bio->bi_end_io == end_sync_read) {
> -			md_sync_acct_bio(bio, nr_sectors);
>   			bio->bi_status = 0;
>   			submit_bio_noacct(bio);
>   		}
> @@ -4880,7 +4873,6 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
>   	r10_bio->sectors = nr_sectors;
>   
>   	/* Now submit the read */
> -	md_sync_acct_bio(read_bio, r10_bio->sectors);
>   	atomic_inc(&r10_bio->remaining);
>   	read_bio->bi_next = NULL;
>   	submit_bio_noacct(read_bio);
> @@ -4940,7 +4932,6 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>   			continue;
>   
>   		atomic_inc(&rdev->nr_pending);
> -		md_sync_acct_bio(b, r10_bio->sectors);
>   		atomic_inc(&r10_bio->remaining);
>   		b->bi_next = NULL;
>   		submit_bio_noacct(b);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 6389383166c0..ca5b0e8ba707 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1240,10 +1240,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>   		}
>   
>   		if (rdev) {
> -			if (s->syncing || s->expanding || s->expanded
> -			    || s->replacing)
> -				md_sync_acct(rdev->bdev, RAID5_STRIPE_SECTORS(conf));
> -
>   			set_bit(STRIPE_IO_STARTED, &sh->state);
>   
>   			bio_init(bi, rdev->bdev, &dev->vec, 1, op | op_flags);
> @@ -1300,10 +1296,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>   				submit_bio_noacct(bi);
>   		}
>   		if (rrdev) {
> -			if (s->syncing || s->expanding || s->expanded
> -			    || s->replacing)
> -				md_sync_acct(rrdev->bdev, RAID5_STRIPE_SECTORS(conf));
> -
>   			set_bit(STRIPE_IO_STARTED, &sh->state);
>   
>   			bio_init(rbi, rrdev->bdev, &dev->rvec, 1, op | op_flags);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index e39c45bc0a97..f3a625b00734 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -182,7 +182,6 @@ struct gendisk {
>   	struct list_head slave_bdevs;
>   #endif
>   	struct timer_rand_state *random;
> -	atomic_t sync_io;		/* RAID */
>   	struct disk_events *ev;
>   
>   #ifdef CONFIG_BLK_DEV_ZONED


Looks good to me.

Acked-by: Xiao Ni <xni@redhat.com>

