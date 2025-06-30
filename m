Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1886CA59;
	Mon, 30 Jun 2025 03:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751255387; cv=none; b=VLWspbcODDbKrfJXnV7VNfXykhKbsL9YbWmYS6yMTykr5mdX69CqXgtufuyvM3gVSTQvqYO26KGWsG72xeb7eIHZ9IFTK0V6r9M0VpeHsSLtGe3ZHzcXpxNAvH2JrcX0unXxo7u9e3nrjLTnLjioieQYgX4Xb9J1pDIuWVRqDQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751255387; c=relaxed/simple;
	bh=+Ujca9U2dDl6g1aUQGeZAydMwTT2H/1L0zEMmlLiU3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PTJXrPOfaFVrCTs7VRwPo1BNbLeY0ptO2gxI/xLxQtt/NILbp3Vo0x1li0QFkR6PDaPTSTJg6E7s++dNySB6LYFV1HttCanZT0OG9Uibq5XrtRihZ8nvCGdgKAKBWcmAhkTHg0Vh5ttrvn7LxJWbQc4O9+mDPqI970vRESEM32c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IkemYhP/; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IkemYhP/"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-748f54dfa5fso3492430b3a.2;
        Sun, 29 Jun 2025 20:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751255385; x=1751860185; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=flaNv69T7uwkRN5AE2lccd3i+diISSx1hSZ+qNGXsdc=;
        b=IkemYhP/fXsHlituqFpYiePJAepJBagrYN4tHLMydBjMF6r6JUQZdXO0isT5BCr0I7
         vvOP+YJWd9Hjf8rSVnJqnS1Up6vLpWdykHHaGbFOWgHGiwdoDnCEUB1wGxFSdcRVxX+i
         RJg3xw20QJuhmlO9j26PmnwCvnKH6gGWjEuDJzmuqiZ3F0dDcMvgziwXn1yxerwZYv1J
         qUlME3eCu0gKT10ghYNORwJoi7bnqxi5UshI8b4zDzEfnfGxX/etnREm2Ys2vFpHmBtR
         eEDyjsnP5qzom3pdutEe9Ncnx1Nlv+jwLmFo1KfWmvb6emvhC7dQq4M/4nV3HUr/Xqj/
         3m8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751255385; x=1751860185;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=flaNv69T7uwkRN5AE2lccd3i+diISSx1hSZ+qNGXsdc=;
        b=ajjeyQ9ELDI47HPHQq5CvdK4CMbsKmw3ZjI6iXvMCESuShr1RgvsdTKaoKxc4+whyH
         Lde0Uv/pPG1rMYdBaByOKuOykIZ0OCYUFCftkBZoRz8brDkjuNh7t6Q/smWC+BAI4mme
         HmkF78n4FNJ+5fqeWV8c5plQbAP+lnIbSZ+UexW540SXOA3BiCiiPBFCdayRAINjolYV
         J40GkAciCBdzj9rVOdhxYkM7IOdQvm8TNM2HheAlpbEBxPNkSud2oiZeZSLT/3DBSwrw
         oP0JrVd8aLhnNg9h3r7NHUpCEXj5M5muR4TgFA0J1X8G/yyQ501h1dURAOo/bKaNDjuy
         PC2w==
X-Forwarded-Encrypted: i=1; AJvYcCUHscprhwI7dXM4BlU+CpqvLDWcKbY8HN9RvJQBAdEEn2TqpUHd2EyaH52zrKGo43pnr/3WF1ldoSPK3+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrLhSsVYkyespK24RSUhbt9U+fHn5R11XmgpAC0M2bl4syXYmz
	Zz9Gi9nBYiqBxR3Z4Ut2DN3Eg5GugLgEY5JEeYxLh7U1EfZm9RkcqZ4f
X-Gm-Gg: ASbGncvI/tWYm+mW6UcriJupg2SI15YHj78B+OmTJ+3Xo5EIaE4mZtxmtaMW5lXkZtr
	WdD1sck0fHpECNzrBw2WyptYCpZIP0kxj7Ksr01ZcW0FiDNd/H4z2V5MLkam9pXDBQvjrP4F8pD
	OkiuembKpyG1mxNadpCwY+zMrk4hgqSC8GM2sbUXBxzQlzFi6mKOgkc3dq7ba0chHlOdFss1EdN
	mI5h+vC41i1yhzJ6wTZjq33hEoHM11ie8Wd2dNZwQJd3majy/JTtxJVzIiA9lCx8jXdyiIN2+IU
	vKyfGPj5m63OTiGqr7ZQ8gheokepaIdIicihg1YskqoF
X-Google-Smtp-Source: AGHT+IEbXc45TH+TFlG4WN+3gNVUbtEG736k8j6WT01n+AzMf6eZYydUbuWI3vaz9nK3WUHF1Smhrg==
X-Received: by 2002:a05:6a00:8c3:b0:748:31ed:ba8a with SMTP id d2e1a72fcca58-74af6f57835mr13702239b3a.15.1751255385176;
        Sun, 29 Jun 2025 20:49:45 -0700 (PDT)
Received: from [127.0.0.1] ([2403:2c80:6::3058])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af557b3bcsm7913842b3a.101.2025.06.29.20.49.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jun 2025 20:49:44 -0700 (PDT)
Message-ID: <1f4b9b25-799c-4145-82a3-3cdbac8eccf6@gmail.com>
Date: Mon, 30 Jun 2025 11:49:40 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] md/raid1: change r1conf->r1bio_pool to a pointer
 type
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250624015604.70309-1-wangjinchao600@gmail.com>
 <20250624015604.70309-2-wangjinchao600@gmail.com>
 <c5c4e3e2-930d-f4c1-4d30-f17984079e6e@huaweicloud.com>
From: Wang Jinchao <wangjinchao600@gmail.com>
In-Reply-To: <c5c4e3e2-930d-f4c1-4d30-f17984079e6e@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/28/25 11:17, Yu Kuai wrote:
> Hi,
> 
> 在 2025/06/24 9:55, Wang Jinchao 写道:
>> In raid1_reshape(), newpool is a stack variable.
>> mempool_init() initializes newpool->wait with the stack address.
>> After assigning newpool to conf->r1bio_pool, the wait queue
>> need to be reinitialized, which is not ideal.
>>
>> Change raid1_conf->r1bio_pool to a pointer type and
>> replace mempool_init() with mempool_create_kmalloc_pool() to
>> avoid referencing a stack-based wait queue.
>>
>> Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
>> ---
>>   drivers/md/raid1.c | 39 ++++++++++++++++++---------------------
>>   drivers/md/raid1.h |  2 +-
>>   2 files changed, 19 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index fd4ce2a4136f..8249cbb89fec 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -255,7 +255,7 @@ static void free_r1bio(struct r1bio *r1_bio)
>>       struct r1conf *conf = r1_bio->mddev->private;
>>       put_all_bios(conf, r1_bio);
>> -    mempool_free(r1_bio, &conf->r1bio_pool);
>> +    mempool_free(r1_bio, conf->r1bio_pool);
>>   }
>>   static void put_buf(struct r1bio *r1_bio)
>> @@ -1305,9 +1305,8 @@ alloc_r1bio(struct mddev *mddev, struct bio *bio)
>>       struct r1conf *conf = mddev->private;
>>       struct r1bio *r1_bio;
>> -    r1_bio = mempool_alloc(&conf->r1bio_pool, GFP_NOIO);
>> -    /* Ensure no bio records IO_BLOCKED */
>> -    memset(r1_bio->bios, 0, conf->raid_disks * sizeof(r1_bio->bios[0]));
>> +    r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
>> +    memset(r1_bio, 0, offsetof(struct r1bio, bios[conf->raid_disks * 
>> 2]));
>>       init_r1bio(r1_bio, mddev, bio);
>>       return r1_bio;
>>   }
>> @@ -3084,6 +3083,7 @@ static struct r1conf *setup_conf(struct mddev 
>> *mddev)
>>       int i;
>>       struct raid1_info *disk;
>>       struct md_rdev *rdev;
>> +    size_t r1bio_size;
>>       int err = -ENOMEM;
>>       conf = kzalloc(sizeof(struct r1conf), GFP_KERNEL);
>> @@ -3124,9 +3124,10 @@ static struct r1conf *setup_conf(struct mddev 
>> *mddev)
>>       if (!conf->poolinfo)
>>           goto abort;
>>       conf->poolinfo->raid_disks = mddev->raid_disks * 2;
>> -    err = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, 
>> r1bio_pool_alloc,
>> -               rbio_pool_free, conf->poolinfo);
>> -    if (err)
>> +
>> +    r1bio_size = offsetof(struct r1bio, bios[mddev->raid_disks * 2]);
> 
> The local variable doesn't look necessary, it's just used once anyway.
>> +    conf->r1bio_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS, 
>> r1bio_size);
>> +    if (!conf->r1bio_pool)
>>           goto abort;
>>       err = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
>> @@ -3197,7 +3198,7 @@ static struct r1conf *setup_conf(struct mddev 
>> *mddev)
>>    abort:
>>       if (conf) {
>> -        mempool_exit(&conf->r1bio_pool);
>> +        mempool_destroy(conf->r1bio_pool);
>>           kfree(conf->mirrors);
>>           safe_put_page(conf->tmppage);
>>           kfree(conf->poolinfo);
>> @@ -3310,7 +3311,7 @@ static void raid1_free(struct mddev *mddev, void 
>> *priv)
>>   {
>>       struct r1conf *conf = priv;
>> -    mempool_exit(&conf->r1bio_pool);
>> +    mempool_destroy(conf->r1bio_pool);
>>       kfree(conf->mirrors);
>>       safe_put_page(conf->tmppage);
>>       kfree(conf->poolinfo);
>> @@ -3366,17 +3367,14 @@ static int raid1_reshape(struct mddev *mddev)
>>        * At the same time, we "pack" the devices so that all the missing
>>        * devices have the higher raid_disk numbers.
>>        */
>> -    mempool_t newpool, oldpool;
>> +    mempool_t *newpool, *oldpool;
>>       struct pool_info *newpoolinfo;
>> +    size_t new_r1bio_size;
>>       struct raid1_info *newmirrors;
>>       struct r1conf *conf = mddev->private;
>>       int cnt, raid_disks;
>>       unsigned long flags;
>>       int d, d2;
>> -    int ret;
>> -
>> -    memset(&newpool, 0, sizeof(newpool));
>> -    memset(&oldpool, 0, sizeof(oldpool));
>>       /* Cannot change chunk_size, layout, or level */
>>       if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
>> @@ -3408,18 +3406,18 @@ static int raid1_reshape(struct mddev *mddev)
>>       newpoolinfo->mddev = mddev;
>>       newpoolinfo->raid_disks = raid_disks * 2;
>> -    ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
>> -               rbio_pool_free, newpoolinfo);
>> -    if (ret) {
>> +    new_r1bio_size = offsetof(struct r1bio, bios[raid_disks * 2]);
> same here. Otherwise looks good to me.
> 
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
>> +    newpool = mempool_create_kmalloc_pool(NR_RAID_BIOS, new_r1bio_size);
>> +    if (!newpool) {
>>           kfree(newpoolinfo);
>> -        return ret;
>> +        return -ENOMEM;
>>       }
>>       newmirrors = kzalloc(array3_size(sizeof(struct raid1_info),
>>                        raid_disks, 2),
>>                    GFP_KERNEL);
>>       if (!newmirrors) {
>>           kfree(newpoolinfo);
>> -        mempool_exit(&newpool);
>> +        mempool_destroy(newpool);
>>           return -ENOMEM;
>>       }
>> @@ -3428,7 +3426,6 @@ static int raid1_reshape(struct mddev *mddev)
>>       /* ok, everything is stopped */
>>       oldpool = conf->r1bio_pool;
>>       conf->r1bio_pool = newpool;
>> -    init_waitqueue_head(&conf->r1bio_pool.wait);
>>       for (d = d2 = 0; d < conf->raid_disks; d++) {
>>           struct md_rdev *rdev = conf->mirrors[d].rdev;
>> @@ -3460,7 +3457,7 @@ static int raid1_reshape(struct mddev *mddev)
>>       set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>       md_wakeup_thread(mddev->thread);
>> -    mempool_exit(&oldpool);
>> +    mempool_destroy(oldpool);
>>       return 0;
>>   }
>> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
>> index 33f318fcc268..652c347b1a70 100644
>> --- a/drivers/md/raid1.h
>> +++ b/drivers/md/raid1.h
>> @@ -118,7 +118,7 @@ struct r1conf {
>>        * mempools - it changes when the array grows or shrinks
>>        */
>>       struct pool_info    *poolinfo;
>> -    mempool_t        r1bio_pool;
>> +    mempool_t        *r1bio_pool;
>>       mempool_t        r1buf_pool;
>>       struct bio_set        bio_split;
>>
> 
Thanks for pointing that out.

I originally introduced the local variable to avoid these checkpatch.pl 
messages:
     CHECK: Alignment should match open parenthesis
     WARNING: line length of xxx exceeds 100 columns
But I agree that using a temporary variable in this case adds 
unnecessary noise, since the value is only used once.

Based on your review and a re-read of the kernel documentation, I guess 
that CHECK:-level warnings are not strictly require fixing—especially 
when fixing them would harm clarity. Please let me know if I’ve 
misunderstood it.

I'll drop the local variable and update the patch accordingly in the 
next version.

Thanks again for the feedback.

-- 
Best regards,
Jinchao
