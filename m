Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953331E51EB;
	Thu, 12 Jun 2025 07:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749714366; cv=none; b=AIryoSz4pb67116eB5VuT0GH/tUP+DGL94rrX2TO9flFdyn/QCW8v3lOMwlYXK2eydL9NcC9jyY63C213JDoTbAnqVugdGSUaWa/UGVQ7ANhVvC0JoRQYKIR2Eq0fexZyOpVOX33M8jKmexz3B7CKN2km9r/KyI4IZsqU/gbmpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749714366; c=relaxed/simple;
	bh=JxoHN1cqD3EU3/Ag5kU+xS0bmPg6uR+cY4LyyXCx0j4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DeZmJDKFR043DsuAD+no7yuymG8uI2O+772OETa76SMLyr0U4MZU464oap8tj1kqOL65yDK2bR0Xl/Wkpx6Tle8EP2hVfeSZ5Lugh6vj3aiz8z/qBmlogTDchl5zGpUmMpASZ37QD37TzIFcg5Yo5EqbGyZRUL60/RiJOyyNZ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CFJnqxPe; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CFJnqxPe"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3138b2f0249so601095a91.2;
        Thu, 12 Jun 2025 00:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749714364; x=1750319164; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XR1hLLgZbNoPUjH3b40Hb0TtWaE1qxdt20ZVSEhp23g=;
        b=CFJnqxPehGRITbTBIhdNp/4/S8nySKtiO2IYy7FtJPS6BmvOE6N1QEuGlWOKGuNsF5
         L9a/p6z8X27RxTW9G69lFQlSfDKKsHHhaoMm9aU3l7u9F5LKjMpGsQrQtD8ZeiiU4bPo
         xq7kBajGT/Nh0EwtExhVdZzHFOWDOcXNBDzxrMslKiGvLYSxG82lEZeS/+jhzRa/2RaQ
         kR1Yxz/fUhlw15ofv6JGu1PTPOvyEQ9357Tg85IXxQavoi2Sw/JS9KlmXwwCUYJiSRcu
         S/U/oHDjmGNFoqcixTUfJ3vwPCKNQM1UVd3qtMA859e5ixlWK8MRr4uL2OHsYDuqb44U
         LhGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749714364; x=1750319164;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XR1hLLgZbNoPUjH3b40Hb0TtWaE1qxdt20ZVSEhp23g=;
        b=H7sEJqBm1m4eHnc6SupIilOGsCs4Ir58dq+LAWrLAEkzREF6m7Z1hPfWJELrtP73Up
         5kJnzV+RCYygwvh8cQMR3SGIRJEk8aHSmYJk+fIstumwpRk4gKPjwjv1hVvQM/u7JgG5
         JfzRVqJllJWcsnEJp6RGXsQ/BFacusikq0TJl+Ix0s6NiK4ddZ1x8et0UEH9AlgXZ7/8
         qsgSt0Lad+c/imRaP4pHaSq6XNm4Vz78jVxONhHLzjsjPRiD745vtmcvf9QL27sAfBpo
         309JjE8+hVjO8WRioFroduACGFdK5x2vJpEQBN98K98j5N2dDwxMRnnHXij5kp2Z+p1P
         I54Q==
X-Forwarded-Encrypted: i=1; AJvYcCUJGKCMU+/cREhHfkLmQGjt4nWzfqdrnCzcz/w4JjHEH+FK7Kfp1SblGmvdoK65vXjqIkzTOpqGn3iJZxM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJeqFmf0rUBZlAqFsdwrUJJJ4SdhmywgAEf9NMbsoExuB1BsEg
	hWNvKO+c5Bmn/xRqI8WyoCqbCvbb876fIRGm8JPM3m8B8xe6cUD3tXgklsrXsf7Poer/+Q==
X-Gm-Gg: ASbGncumeO4bwJua1cMcy7ArAk9ERU7ZLATwqkP1kTNLFJHelgsdVA3dkJEMzihu8MP
	0Mbcs5ACbUkCGiDOunuGEgwtUZ3Tvfc2vJTufKIHhdmXkEGmVsl/I+XZM6U8/hhONr+OLPEdqgi
	Tpt6RXII/etteTpQmShyrMkoivJeViC9aVykGi6MElsKb15dW6h5LCovtQifXZDW5ddDLeaebbn
	RAPDP6OEV4lPFqBiiKu6YY85nQWFPeNlxb2Rzhs1sgKVHYJjVCXo8CZWxlfQI3jxBB6y91R7Quz
	RMuIe0soIlm60moHWJkH5DnIGTfoxpLBGIXKA1i96ApZ
X-Google-Smtp-Source: AGHT+IHaSXvB+nJVixBEGqiAmwKGpfI2Ua+//G15eQv/+dSv+zqKo94/Kc4E4dyEks+jdJQJJBS+Vw==
X-Received: by 2002:a17:90b:5826:b0:313:bdbf:36c0 with SMTP id 98e67ed59e1d1-313bdbf3715mr5785959a91.0.1749714363831;
        Thu, 12 Jun 2025 00:46:03 -0700 (PDT)
Received: from [127.0.0.1] ([2403:2c80:6::3058])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2364e7194e0sm7703545ad.222.2025.06.12.00.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 00:46:03 -0700 (PDT)
Message-ID: <06935480-a959-4e3f-8e41-286d7f54754a@gmail.com>
Date: Thu, 12 Jun 2025 15:45:59 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md/raid1: Fix stack memory use after return in
 raid1_reshape
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250611090203.271488-1-wangjinchao600@gmail.com>
 <5143c5c3-3a77-919f-0d38-8adb0e8923e9@huaweicloud.com>
Content-Language: en-US
From: Wang Jinchao <wangjinchao600@gmail.com>
In-Reply-To: <5143c5c3-3a77-919f-0d38-8adb0e8923e9@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2025/6/12 15:31, Yu Kuai 写道:
> Hi,
> 
> 在 2025/06/11 16:55, Wang Jinchao 写道:
>> In the raid1_reshape function, newpool is
>> allocated on the stack and assigned to conf->r1bio_pool.
>> This results in conf->r1bio_pool.wait.head pointing
>> to a stack address.
>> Accessing this address later can lead to a kernel panic.
>>
>> Example access path:
>>
>> raid1_reshape()
>> {
>>     // newpool is on the stack
>>     mempool_t newpool, oldpool;
>>     // initialize newpool.wait.head to stack address
>>     mempool_init(&newpool, ...);
>>     conf->r1bio_pool = newpool;
>> }
>>
>> raid1_read_request() or raid1_write_request()
>> {
>>     alloc_r1bio()
>>     {
>>         mempool_alloc()
>>         {
>>             // if pool->alloc fails
>>             remove_element()
>>             {
>>                 --pool->curr_nr;
>>             }
>>         }
>>     }
>> }
>>
>> mempool_free()
>> {
>>     if (pool->curr_nr < pool->min_nr) {
>>         // pool->wait.head is a stack address
>>         // wake_up() will try to access this invalid address
>>         // which leads to a kernel panic
>>         return;
>>         wake_up(&pool->wait);
>>     }
>> }
>>
>> Fix:
>> The solution is to avoid using a stack-based newpool.
>> Instead, directly initialize conf->r1bio_pool.
>>
>> Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
>> ---
>> v1 -> v2:
>> - change subject
>> - use mempool_init(&conf->r1bio_pool) instead of reinitializing the 
>> list on stack
>> ---
>>   drivers/md/raid1.c | 34 +++++++++++++++++++---------------
>>   1 file changed, 19 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 19c5a0ce5a40..f2436262092a 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -3366,7 +3366,7 @@ static int raid1_reshape(struct mddev *mddev)
>>        * At the same time, we "pack" the devices so that all the missing
>>        * devices have the higher raid_disk numbers.
>>        */
>> -    mempool_t newpool, oldpool;
>> +    mempool_t oldpool;
>>       struct pool_info *newpoolinfo;
>>       struct raid1_info *newmirrors;
>>       struct r1conf *conf = mddev->private;
>> @@ -3375,9 +3375,6 @@ static int raid1_reshape(struct mddev *mddev)
>>       int d, d2;
>>       int ret;
>> -    memset(&newpool, 0, sizeof(newpool));
>> -    memset(&oldpool, 0, sizeof(oldpool));
>> -
>>       /* Cannot change chunk_size, layout, or level */
>>       if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
>>           mddev->layout != mddev->new_layout ||
>> @@ -3408,26 +3405,33 @@ static int raid1_reshape(struct mddev *mddev)
>>       newpoolinfo->mddev = mddev;
>>       newpoolinfo->raid_disks = raid_disks * 2;
>> -    ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
>> -               rbio_pool_free, newpoolinfo);
>> -    if (ret) {
>> -        kfree(newpoolinfo);
>> -        return ret;
>> -    }
>>       newmirrors = kzalloc(array3_size(sizeof(struct raid1_info),
>> -                     raid_disks, 2),
>> -                 GFP_KERNEL);
>> +    raid_disks, 2),
>> +    GFP_KERNEL);
>>       if (!newmirrors) {
>>           kfree(newpoolinfo);
>> -        mempool_exit(&newpool);
>>           return -ENOMEM;
>>       }
>> +    /* stop everything before switching the pool */
>>       freeze_array(conf, 0);
>> -    /* ok, everything is stopped */
>> +    /* backup old pool in case restore is needed */
>>       oldpool = conf->r1bio_pool;
>> -    conf->r1bio_pool = newpool;
>> +
>> +    ret = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, 
>> r1bio_pool_alloc,
>> +               rbio_pool_free, newpoolinfo);
>> +    if (ret) {
>> +        kfree(newpoolinfo);
>> +        kfree(newmirrors);
>> +        mempool_exit(&conf->r1bio_pool);
>> +        /* restore the old pool */
>> +        conf->r1bio_pool = oldpool;
>> +        unfreeze_array(conf);
>> +        pr_err("md/raid1:%s: cannot allocate r1bio_pool for reshape\n",
>> +            mdname(mddev));
>> +        return ret;
>> +    }
>>       for (d = d2 = 0; d < conf->raid_disks; d++) {
>>           struct md_rdev *rdev = conf->mirrors[d].rdev;
>>
> 
> Any specific reason not to use mempool_resize() and krealloc() here?
> In the case if new raid_disks is greater than the old one.
The element size is different between the old pool and the new pool.
mempool_resize only resizes the pool size (i.e., the number of elements 
in pool->elements), but does not handle changes in element size, which 
occurs in raid1_reshape.

Another reason may be to avoid modifying the old pool directly — in case 
initializing the new pool fails, the old one remains usable.

If we modify the old pool directly and the operation fails, not only 
will the reshaped RAID be unusable, but the original RAID may also be 
corrupted.
> 
> Thanks,
> Kuai
> 

