Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8256A1F0E39;
	Thu, 12 Jun 2025 09:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749722110; cv=none; b=d3nBTcCIesvJsxKCT+n5og4oVXSvx+aKr6/3Rwgqy4MmAXEU4zi7ZeQHtvXej4aTeLkx3k0tOxfSl2EpcOtIGqQW1oFlJ5hQt7/RXf3ugllOx8ZaMbLVu+lQZznjmDu8dLqFFqWIX8j25ma7Da4av6SPKiuN0soMSrncsxJ4x4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749722110; c=relaxed/simple;
	bh=UBZIU7orokqIbTAlErkDSw8d3/28HqSG10nBK9bv3Gs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N/OyhAaLE5XINNn9Dvd1xmj/ffA3uOE/+SYPHWMvOAHRw2Ji7F24aeXBTPH8QwYy6E1Y+rp0mLcw53QhhnUQI6KZ4WptwsqB10oIqhYd6tRtMObMs9m4dXQGz7pItVF0KWxtBvOQ7ulL11WXjKamY1Nr3M9PFsf646lySof/g6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TRt9Yj8x; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TRt9Yj8x"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-234fcadde3eso9337595ad.0;
        Thu, 12 Jun 2025 02:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749722108; x=1750326908; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5v78VkZLXww0x+jfw1DMkbMZbuVvalpX2roWsau0taU=;
        b=TRt9Yj8xmwiCyKRyGkfLw1Ety4j3DiOEm8Sw+3+33GIFnir/oX/SWSDe2QktUBFvBI
         JWYU8WsrfpPlbrnC7bywRf99/yCru2QsTlHctgu+llj2eCwhMbNKrvy7UBpomscNt1nu
         7S13PoBHvhvxScLVBKh2ikPkkw4tYVtOuT6/XjQRXKge+QAnyLGD8qX2v/lnLzemrtY3
         hoRPviQDfD03ma8Yq+iXZVrC5l/jKSTCIh70wMTgiNs9OJ0e8CyMuC1VsoePaH0CBPFT
         /Jyav8vNeXMB7GhQtegc3+6jPDJKhOhtRTliR0P3KUoxX1qSSmuuGwFpt1Jt5Z3Yongi
         QQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749722108; x=1750326908;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5v78VkZLXww0x+jfw1DMkbMZbuVvalpX2roWsau0taU=;
        b=XLOjM3BT2Knk9ax4leR3v6FlqIf/LHNrN8nVX+cDOO/3cUOED44vY34Ks79qeYYTGZ
         gTDp9YLGISYDhACxMV2KKt8aaUKkxRTtI30I73ChDP1PXT0ubWyw9m9ShlQKcPKvv2yq
         vF/+jofo0ECEQ0bEXMcEBfdnTs+xbc2HJr9n82sxkaJG3EtjpBlezraDoppPV8zGnuti
         naX5fxQrJIicxBt/fTILTm1N78b2yqi3VPkYIW4OvYrGMpFlTg/Tc7dxsXlGvL0xW8Ay
         k+K0fmnJT/LxZS3lJ70KI5ZLMuVQIY80SUpfoPeUvN/RR2VrnqeHtesABZZXsHRLBBu+
         fsrA==
X-Forwarded-Encrypted: i=1; AJvYcCX8XXcgOVd3WI3A/B5NTcMJu+/4lnuepLaoTiozfilzvs46CpXuoEqfEALnwLCqNhoNnQiz7pJs7DSXT0E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzR7+b9ZpSxvxGQDwdPUVNU3MBTqEc04d9SUd745gFzKs1uBaHx
	f3uPWgr2gJxRq+ejFNXmhlL6IdYHHb1JxYRy8dOiJD4rGjWYpriYPY86XNGbZ7aWGiaq/Q==
X-Gm-Gg: ASbGncsqpyB2PgjeNKCITx2+ycQbS6fQiIPTHwul4XR7xlOI1K51G6VOR2cVO6cMIFP
	Z6jacCx2dhfixguGuUt+hitCONbT+no7CJhRLG4BM6iMULchiAPxg1YGkQxnhuzYzz8moIefl1m
	z22MshkKQT+3kR35ltFfOO+B1lvGLI1ledvxB0JZxIT9g5mchRhuILfGFvMl3XyVIZ6jQ2oNm8D
	+CI7KdjED3WqN1NEB/JyF5UWrUXiFpqCEIvnqwlwAA1d8AcHP1DNF7Ll4efjibrv8iOGAOPpth+
	7QGOQnKlkgpmoBN21C/OHbWu5B/ysRIqQVuZ0ztSXOOQ
X-Google-Smtp-Source: AGHT+IHcPRdBhRsbBc2A/yJonIlJWAqzhv+uX32iEL9BThoZ0ABPWrwcj9p4KmGO7Q8AiVyqVDImxQ==
X-Received: by 2002:a17:902:d58f:b0:234:8f5d:e3bd with SMTP id d9443c01a7336-2364d8cc7aamr37633475ad.39.1749722107779;
        Thu, 12 Jun 2025 02:55:07 -0700 (PDT)
Received: from [127.0.0.1] ([2403:2c80:6::3058])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2364e6d9c3asm10027285ad.123.2025.06.12.02.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 02:55:07 -0700 (PDT)
Message-ID: <938b0969-cace-4998-8e4a-88d445c220b1@gmail.com>
Date: Thu, 12 Jun 2025 17:55:04 +0800
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
 <06935480-a959-4e3f-8e41-286d7f54754a@gmail.com>
 <9c7d5e66-4f5f-b984-c291-f19c3d568b85@huaweicloud.com>
Content-Language: en-US
From: Wang Jinchao <wangjinchao600@gmail.com>
In-Reply-To: <9c7d5e66-4f5f-b984-c291-f19c3d568b85@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/6/12 17:17, Yu Kuai wrote:
> Hi,
> 
> 在 2025/06/12 15:45, Wang Jinchao 写道:
>> 在 2025/6/12 15:31, Yu Kuai 写道:
>>> Hi,
>>>
>>> 在 2025/06/11 16:55, Wang Jinchao 写道:
>>>> In the raid1_reshape function, newpool is
>>>> allocated on the stack and assigned to conf->r1bio_pool.
>>>> This results in conf->r1bio_pool.wait.head pointing
>>>> to a stack address.
>>>> Accessing this address later can lead to a kernel panic.
>>>>
>>>> Example access path:
>>>>
>>>> raid1_reshape()
>>>> {
>>>>     // newpool is on the stack
>>>>     mempool_t newpool, oldpool;
>>>>     // initialize newpool.wait.head to stack address
>>>>     mempool_init(&newpool, ...);
>>>>     conf->r1bio_pool = newpool;
>>>> }
>>>>
>>>> raid1_read_request() or raid1_write_request()
>>>> {
>>>>     alloc_r1bio()
>>>>     {
>>>>         mempool_alloc()
>>>>         {
>>>>             // if pool->alloc fails
>>>>             remove_element()
>>>>             {
>>>>                 --pool->curr_nr;
>>>>             }
>>>>         }
>>>>     }
>>>> }
>>>>
>>>> mempool_free()
>>>> {
>>>>     if (pool->curr_nr < pool->min_nr) {
>>>>         // pool->wait.head is a stack address
>>>>         // wake_up() will try to access this invalid address
>>>>         // which leads to a kernel panic
>>>>         return;
>>>>         wake_up(&pool->wait);
>>>>     }
>>>> }
>>>>
>>>> Fix:
>>>> The solution is to avoid using a stack-based newpool.
>>>> Instead, directly initialize conf->r1bio_pool.
>>>>
>>>> Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
>>>> ---
>>>> v1 -> v2:
>>>> - change subject
>>>> - use mempool_init(&conf->r1bio_pool) instead of reinitializing the 
>>>> list on stack
>>>> ---
>>>>   drivers/md/raid1.c | 34 +++++++++++++++++++---------------
>>>>   1 file changed, 19 insertions(+), 15 deletions(-)
>>>>
>>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>>> index 19c5a0ce5a40..f2436262092a 100644
>>>> --- a/drivers/md/raid1.c
>>>> +++ b/drivers/md/raid1.c
>>>> @@ -3366,7 +3366,7 @@ static int raid1_reshape(struct mddev *mddev)
>>>>        * At the same time, we "pack" the devices so that all the 
>>>> missing
>>>>        * devices have the higher raid_disk numbers.
>>>>        */
>>>> -    mempool_t newpool, oldpool;
>>>> +    mempool_t oldpool;
>>>>       struct pool_info *newpoolinfo;
>>>>       struct raid1_info *newmirrors;
>>>>       struct r1conf *conf = mddev->private;
>>>> @@ -3375,9 +3375,6 @@ static int raid1_reshape(struct mddev *mddev)
>>>>       int d, d2;
>>>>       int ret;
>>>> -    memset(&newpool, 0, sizeof(newpool));
>>>> -    memset(&oldpool, 0, sizeof(oldpool));
>>>> -
>>>>       /* Cannot change chunk_size, layout, or level */
>>>>       if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
>>>>           mddev->layout != mddev->new_layout ||
>>>> @@ -3408,26 +3405,33 @@ static int raid1_reshape(struct mddev *mddev)
>>>>       newpoolinfo->mddev = mddev;
>>>>       newpoolinfo->raid_disks = raid_disks * 2;
>>>> -    ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
>>>> -               rbio_pool_free, newpoolinfo);
>>>> -    if (ret) {
>>>> -        kfree(newpoolinfo);
>>>> -        return ret;
>>>> -    }
>>>>       newmirrors = kzalloc(array3_size(sizeof(struct raid1_info),
>>>> -                     raid_disks, 2),
>>>> -                 GFP_KERNEL);
>>>> +    raid_disks, 2),
>>>> +    GFP_KERNEL);
>>>>       if (!newmirrors) {
>>>>           kfree(newpoolinfo);
>>>> -        mempool_exit(&newpool);
>>>>           return -ENOMEM;
>>>>       }
>>>> +    /* stop everything before switching the pool */
>>>>       freeze_array(conf, 0);
>>>> -    /* ok, everything is stopped */
>>>> +    /* backup old pool in case restore is needed */
>>>>       oldpool = conf->r1bio_pool;
>>>> -    conf->r1bio_pool = newpool;
>>>> +
>>>> +    ret = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, 
>>>> r1bio_pool_alloc,
>>>> +               rbio_pool_free, newpoolinfo);
>>>> +    if (ret) {
>>>> +        kfree(newpoolinfo);
>>>> +        kfree(newmirrors);
>>>> +        mempool_exit(&conf->r1bio_pool);
>>>> +        /* restore the old pool */
>>>> +        conf->r1bio_pool = oldpool;
>>>> +        unfreeze_array(conf);
>>>> +        pr_err("md/raid1:%s: cannot allocate r1bio_pool for 
>>>> reshape\n",
>>>> +            mdname(mddev));
>>>> +        return ret;
>>>> +    }
>>>>       for (d = d2 = 0; d < conf->raid_disks; d++) {
>>>>           struct md_rdev *rdev = conf->mirrors[d].rdev;
>>>>
>>>
>>> Any specific reason not to use mempool_resize() and krealloc() here?
>>> In the case if new raid_disks is greater than the old one.
>> The element size is different between the old pool and the new pool.
>> mempool_resize only resizes the pool size (i.e., the number of 
>> elements in pool->elements), but does not handle changes in element 
>> size, which occurs in raid1_reshape.
>>
>> Another reason may be to avoid modifying the old pool directly — in 
>> case initializing the new pool fails, the old one remains usable.
>>
>> If we modify the old pool directly and the operation fails, not only 
>> will the reshaped RAID be unusable, but the original RAID may also be 
>> corrupted.
> 
> Yes, you're right, thanks for the explanation.
> 
> I feel like raid1_reshape() need better coding, anyway, your fix looks
> good.
> 
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>

Now that we have the same information, I prefer patch-v1 before 
refactoring raid1_reshape,
because it’s really simple (only one line) and clearer to show the 
backup and restore logic.
Another reason is that v2 freezes the RAID longer than v1.
Would you like me to provide a v3 patch combining the v2 explanation 
with the v1 diff?
Thanks for your reviewing.
> 
>>>
>>> Thanks,
>>> Kuai
>>>
>>
>> .
>>
> 

