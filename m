Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340C117BD3;
	Thu, 19 Jun 2025 02:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750298500; cv=none; b=VmKe5m578hkjDR3+ew9CahmlbpzJr9sUUj16sZf65xlfp9/fJq+FeudV3uM3R1K/9mKH1f2AnQgnFPfnCa+TEqdS4K3K8wQpeiYw9jFBmopMDz4tSMImEeoawJM63drljUyzqE0dnLXeIMdr11CBTC61pqnYmC5TeIYgPa8qLsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750298500; c=relaxed/simple;
	bh=dxxd+y5f9OtPJqcXr9yBk44XaWwHqbrqfE9XNY404yU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D7fS1y+QhG5Km1eTrJ3mq0HnzoAl4KoJ73MoSH3q+MqCFl35txYK4vrZe/0mk8EKslcGWf2SjpmE4Bg/sGJ+e+dLkPjIby20YX8S47QN7RNUvM17y4bfMIfHpqKidUhvrtXhN5RWJ//zZWXxJ8goZi/y7/voG+AhWR7Br0OIjcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mlfJdP0Y; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mlfJdP0Y"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-748435ce7cdso228376b3a.1;
        Wed, 18 Jun 2025 19:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750298497; x=1750903297; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gPcyYUkM/5rr+vgpty+l0iQbSOtK0A7s4YhGkDL0AHM=;
        b=mlfJdP0Y0SrxoxZYT+sbbLfOctIJZ1SgOnxeynJlNDhntiLiwfdI2XPtS3xIx2C3R/
         o+25MxWbLMQQknGft2vqzS0bXZ82MKywZjO+SEiStSj0u/1pSQy9DXi/1umQHhn6X5/q
         x7E9Ulp+gBOlHh61ibwH6JyqTPwW+ZXgSeYtppId+syzLqmpcCW6ff5Y3G1uUlF94DX7
         IzzYGFVrkZ5v0UfHn0BXPs+zY622eancuA/pneo+T4MTJZ8/35EByuCtZlGHxtkRJo79
         IcOBB72d0iwK1f6E1lkLjLuP4xYr+YXRiXQmlX5kMG6CrGh/srONwyV3MeuYeTwfnJFO
         IlgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750298497; x=1750903297;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gPcyYUkM/5rr+vgpty+l0iQbSOtK0A7s4YhGkDL0AHM=;
        b=L2QrDk3JDQaLcdBGQm1o4ViWQuv2MZIc6U2oKX5RhH/8KYWIqAjHBcrUAXCv5qbNvN
         Gz5mBH9kYkLIdED26y99FSfXUBWuns3vIKbVUKDz8REBsVkCcL69o7+e/dZ4okBDtPvf
         bP5HVE2WNwB6FCl4FEEQlyHwqPgZiTYw3pG8UD1nF97SJh+E25NOI00Lqtuy/rQpbqox
         HoA22KSDuPl0t/z0EBHHMOApq/A4pkqFCjb1otRemMI0C/l+g1JsOaUI9fTJJoAH6UKG
         l4VCQ/OnIeWiGlcbRm+ZQ+M2/yXer48xZQhe9uHn/j5uDUKDOlOVp2Dp5cnE3GUgEgZi
         uopQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoN+eSrDYFVOTFo5BFQZb2qsxz/8kAyxmHCKLHyZ0sbrCDD2j/qUJVg8PdSSSm1cFqIK6/lt/GkVv6IQ==@vger.kernel.org, AJvYcCWC0UNuZ+o1uOp0ZeLvd/plZ7U5Nm4bDcn5msvD0wsVBHIDMDhvoBuf3nkq4O2M66QNJMGTNrOMkjqnkjo=@vger.kernel.org
X-Gm-Message-State: AOJu0YworaUov6ZBs0sQStb1jYVdhPmLQ8YlqxRAONZDcrT+2QBoPkol
	bVmioSKeSI67Gs52oPKOaqQmbjMpMfrnsCI4kMhTRl5uehU/nqpZnhCs
X-Gm-Gg: ASbGncvjSjLhPXUbtN5N6pUKflSzzo5xeyzbELQe2r3alqqeiRNl5DrfrIkTGWC65FX
	pHs/9vhHZSGmEGISsTqkxS5CJdqqUd72+kSjVCbtqgeprZpliKr5+NWMmiMGdhgdVnsG+T72djU
	LbIKms+612Mb+zrOHW7hQ+0uZEASzOd8W4fUwJ17DGnMIoVbMDvw0oSel8irO5YegX720FiF4lZ
	tEfE7yToJcbFvGk6SRamiGp5Wpo+c28BUgNMyhJ5/bRuknubCcOB6URpUuGa6FFhcvK1Nz2YdUe
	gvfPOgqd1q+FkxC/aNyOXXvIyoH6S1cfWI+582j2mMqbj4KX5tUuMwn4Xtp354K2Nuo=
X-Google-Smtp-Source: AGHT+IFKPFbqqQ868ysZLuEeysMOn1Ie429vlkUQ4W2NEUV3fgPB9ucieJq4GQMQchGrkSuFkxhhiA==
X-Received: by 2002:a05:6a21:998e:b0:216:1ea0:a51a with SMTP id adf61e73a8af0-21fbd7b5593mr29688997637.38.1750298497133;
        Wed, 18 Jun 2025 19:01:37 -0700 (PDT)
Received: from [127.0.0.1] ([103.56.52.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe1639eb8sm10018561a12.10.2025.06.18.19.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 19:01:36 -0700 (PDT)
Message-ID: <ec472853-fe4f-4b3b-887c-c1e8f562dbd5@gmail.com>
Date: Thu, 19 Jun 2025 10:01:34 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1: change r1conf->r1bio_pool to a pointer type
Content-Language: en-US
To: Su Yue <l@damenly.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250618114120.130584-1-wangjinchao600@gmail.com>
 <ldpoy2fo.fsf@damenly.org>
From: Wang Jinchao <wangjinchao600@gmail.com>
In-Reply-To: <ldpoy2fo.fsf@damenly.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/19/25 08:56, Su Yue wrote:
> On Wed 18 Jun 2025 at 19:41, Wang Jinchao <wangjinchao600@gmail.com> wrote:
> 
>> In raid1_reshape(), newpool is a stack variable.
>> mempool_init() initializes newpool->wait with the stack address.
>> After assigning newpool to conf->r1bio_pool, the wait queue
>> need to be reinitialized, which is not ideal.
>>
>> Change raid1_conf->r1bio_pool to a pointer type and
>> replace mempool_init() with mempool_create() to
>> avoid referencing a stack-based wait queue.
>>
>> Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
>> ---
>>  drivers/md/raid1.c | 31 +++++++++++++------------------
>>  drivers/md/raid1.h |  2 +-
>>  2 files changed, 14 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index fd4ce2a4136f..4d4833915b5f 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -255,7 +255,7 @@ static void free_r1bio(struct r1bio *r1_bio)
>>      struct r1conf *conf = r1_bio->mddev->private;
>>
>>      put_all_bios(conf, r1_bio);
>> -    mempool_free(r1_bio, &conf->r1bio_pool);
>> +    mempool_free(r1_bio, conf->r1bio_pool);
>>  }
>>
>>  static void put_buf(struct r1bio *r1_bio)
>> @@ -1305,7 +1305,7 @@ alloc_r1bio(struct mddev *mddev, struct bio *bio)
>>      struct r1conf *conf = mddev->private;
>>      struct r1bio *r1_bio;
>>
>> -    r1_bio = mempool_alloc(&conf->r1bio_pool, GFP_NOIO);
>> +    r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
>>      /* Ensure no bio records IO_BLOCKED */
>>      memset(r1_bio->bios, 0, conf->raid_disks *  sizeof(r1_bio- 
>> >bios[0]));
>>      init_r1bio(r1_bio, mddev, bio);
>> @@ -3124,9 +3124,9 @@ static struct r1conf *setup_conf(struct mddev 
>> *mddev)
>>      if (!conf->poolinfo)
>>          goto abort;
>>      conf->poolinfo->raid_disks = mddev->raid_disks * 2;
>> -    err = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, 
>> r1bio_pool_alloc,
>> -               rbio_pool_free, conf->poolinfo);
>> -    if (err)
>> +    conf->r1bio_pool = mempool_create(NR_RAID_BIOS, r1bio_pool_alloc,
>> +                      rbio_pool_free, conf->poolinfo);
>> +    if (!conf->r1bio_pool)
>>
> err should be set to -ENOMEM.
> 
At the beginning of the function, err is initialized to -ENOMEM.

> -- 
> Su
> 
>>          goto abort;
>>
>>      err = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
>> @@ -3197,7 +3197,7 @@ static struct r1conf *setup_conf(struct mddev 
>> *mddev)
>>
>>   abort:
>>      if (conf) {
>> -        mempool_exit(&conf->r1bio_pool);
>> +        mempool_destroy(conf->r1bio_pool);
>>          kfree(conf->mirrors);
>>          safe_put_page(conf->tmppage);
>>          kfree(conf->poolinfo);
>> @@ -3310,7 +3310,7 @@ static void raid1_free(struct mddev *mddev, void 
>> *priv)
>>  {
>>      struct r1conf *conf = priv;
>>
>> -    mempool_exit(&conf->r1bio_pool);
>> +    mempool_destroy(conf->r1bio_pool);
>>      kfree(conf->mirrors);
>>      safe_put_page(conf->tmppage);
>>      kfree(conf->poolinfo);
>> @@ -3366,17 +3366,13 @@ static int raid1_reshape(struct mddev *mddev)
>>       * At the same time, we "pack" the devices so that all the  missing
>>       * devices have the higher raid_disk numbers.
>>       */
>> -    mempool_t newpool, oldpool;
>> +    mempool_t *newpool, *oldpool;
>>      struct pool_info *newpoolinfo;
>>      struct raid1_info *newmirrors;
>>      struct r1conf *conf = mddev->private;
>>      int cnt, raid_disks;
>>      unsigned long flags;
>>      int d, d2;
>> -    int ret;
>> -
>> -    memset(&newpool, 0, sizeof(newpool));
>> -    memset(&oldpool, 0, sizeof(oldpool));
>>
>>      /* Cannot change chunk_size, layout, or level */
>>      if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
>> @@ -3408,18 +3404,18 @@ static int raid1_reshape(struct mddev *mddev)
>>      newpoolinfo->mddev = mddev;
>>      newpoolinfo->raid_disks = raid_disks * 2;
>>
>> -    ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
>> +    newpool = mempool_create(NR_RAID_BIOS, r1bio_pool_alloc,
>>                 rbio_pool_free, newpoolinfo);
>> -    if (ret) {
>> +    if (!newpool) {
>>          kfree(newpoolinfo);
>> -        return ret;
>> +        return -ENOMEM;
>>      }
>>      newmirrors = kzalloc(array3_size(sizeof(struct raid1_info),
>>                       raid_disks, 2),
>>                   GFP_KERNEL);
>>      if (!newmirrors) {
>>          kfree(newpoolinfo);
>> -        mempool_exit(&newpool);
>> +        mempool_destroy(newpool);
>>          return -ENOMEM;
>>      }
>>
>> @@ -3428,7 +3424,6 @@ static int raid1_reshape(struct mddev *mddev)
>>      /* ok, everything is stopped */
>>      oldpool = conf->r1bio_pool;
>>      conf->r1bio_pool = newpool;
>> -    init_waitqueue_head(&conf->r1bio_pool.wait);
>>
>>      for (d = d2 = 0; d < conf->raid_disks; d++) {
>>          struct md_rdev *rdev = conf->mirrors[d].rdev;
>> @@ -3460,7 +3455,7 @@ static int raid1_reshape(struct mddev *mddev)
>>      set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>      md_wakeup_thread(mddev->thread);
>>
>> -    mempool_exit(&oldpool);
>> +    mempool_destroy(oldpool);
>>      return 0;
>>  }
>>
>> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
>> index 33f318fcc268..652c347b1a70 100644
>> --- a/drivers/md/raid1.h
>> +++ b/drivers/md/raid1.h
>> @@ -118,7 +118,7 @@ struct r1conf {
>>       * mempools - it changes when the array grows or shrinks
>>       */
>>      struct pool_info    *poolinfo;
>> -    mempool_t        r1bio_pool;
>> +    mempool_t        *r1bio_pool;
>>      mempool_t        r1buf_pool;
>>
>>      struct bio_set        bio_split;

