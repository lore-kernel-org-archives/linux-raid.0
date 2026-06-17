Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A8B395AEC
	for <linux-raid@vger.kernel.org>; Wed, 17 Jun 2026 13:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781704520; cv=none; b=HXJjVFqeE/UDUgFL7aD1cn/cp/6AT8r+pmabagKvXo3jfd8FWzy0rUkxeJBAR2keLqAPrAri9Pxmu1ZJ7Q3sTFbJ5vlFrX4xLHCm2nWWlQ6L4KSnrc44rJFQTEWq5ubtsSQOet4IeI5gJaN/RJ16MPWLYQu4YWBP8LCThmPghXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781704520; c=relaxed/simple;
	bh=FIhRAjU2S7amaNpwygREz87N0ws2BZ8z2tbsthDbX34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LWZdHQCjVnjwEBDEg+f82fns7Uq3KDVPenELnXWzWjWjLAoesA6mc1loMoF1O7BsgPC81inGWEpQ5Sp2ge6xxjqc5M4lKMZzsYBdZEJwtMuTXfm91hJ8KGok+4MChjKy01RVHN82tFudkFbNG1usVo6pb9BT10SWMVWKEXWKqIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l9+k/oHY; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l9+k/oHY"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bec43ee8ff0so160321266b.1
        for <linux-raid@vger.kernel.org>; Wed, 17 Jun 2026 06:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781704518; x=1782309318; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yo+39z+7jWnN4BY8JaCf4Xasm1WdIUT2UiMvAy1Trps=;
        b=l9+k/oHYpFPc3dHjOC80rWzVlgkyZBDQPgrYKFOryzyCiiMKHpOG+rWU5+ego16Gvs
         ez2/S1y902jZU31epzXuK6uG8rIk3WPkFCLAkRX6fZXbEY/dBWQpYfw6AcBU6YqyU97V
         aWq0ih9463G5IUHi2h9u5XnuOPsDAC6YP7LcmrH3AObcfoxvxBhR2PvEtTiXgY7VNYko
         O6mG9ZU+4wdb3AsOjEulq849eoP5FTL3PtyKfdMVlplwrhVOtVfQR/tejTP68r34eDQ7
         YtHQGzm4STjmHZvY9h3dAT5IAU7ZvVJx6sKkMbcKu43h5YAaCgTtBB0rJFtVmX2Q80zL
         Vy2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781704518; x=1782309318;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yo+39z+7jWnN4BY8JaCf4Xasm1WdIUT2UiMvAy1Trps=;
        b=q4p8U0Nm4K9LVCXyetrt54yOLoMUIdsEjyxtcUTFYvT6ygtyyyHAc1yi1GRKwIiVqU
         xWs5l2/ITqY4gdFa2w+BJTwY/gf/6fdIgjJAkjpJPeemIPhIkUYrJQVOUXNyHqXUz1SH
         T9aaWjNnSeLhS7YSlno0eCPskgGT4H/mH/mwIMSUQSq2XJSpU55Presyo2Zu/mK0FI7+
         hM/mDP26W6pqPJvkTKqRnNVAadxjJNU6fktfCxcK49uKRZ/yfGBdGmIgEknlUAcPMGZq
         AhTkEZuOl+wSYaerI2ErDazTOjcmMjv7PSCoj35fuEqVDKtk4Q7Eh2beB5FyTUqv7D0O
         a7EQ==
X-Forwarded-Encrypted: i=1; AFNElJ+P+x/QN60NuS6nRITPkY8yb/pdBtszPaHqQ0KpCZE+yfadTq27Fbt41TtKKNsR3g3JP71l+UAlJoX/@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0qs2eliQhPLwMtPDwpdW3zUW11ZGSZbu4HVEqHap3llsh9PZ5
	9D+Mnl8NBC1Ysvdh9pdLoZTsXZqFkKCPrdLpyZYdZxGE8MB3vyqs+klVuWlIBw==
X-Gm-Gg: AfdE7cl+TEO1ZF5Ty8n8/MXx1xhEh8XRaAk17Wx/0qkqpP4LnDIBN0jLC9L1kdsct4d
	NhOuHDdrFr8kORB9Owqh1tYdPi42uz50TmmW+0/Xd65QCJJeFc4zbipUqCIHUZ5Q5agw4HMxU1J
	Znt5dQpciHgeP2J3wLzuEtacZrrMvvvrSZ/gSy4RWR+PrpTVXhkizDnRVOMNO0r0zoMaS5tHAZL
	j2jji2tv9EvVWf77ptJzJJ4PJVBylReF3O5cv0U6o+rrJkvSNScnIbWXzo2RJCltKgZL+wYoWJx
	flKzBbDPWrIngil9fpjpa6WjRyXS4asBxQ+SumNslDNjTeFvZe+A+jLWNbjp4z0ntPFdkIeXrZs
	NA6aLv8lRtsaS5cmJlLZGY7y5lQP1mjDhd5Ovmxyg6/DDR92YvWep+1oCOZUe8IuqwsUujHU/Zh
	Qbv5FNedOmiCO6kmTCv0G350XQF89ECr8DB/WhiSDJQXyw+r8=
X-Received: by 2002:a17:907:6d21:b0:beb:d461:7b09 with SMTP id a640c23a62f3a-c05d6e83296mr183033066b.11.1781704517307;
        Wed, 17 Jun 2026 06:55:17 -0700 (PDT)
Received: from [192.168.8.62] ([154.83.91.239])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb4420823sm807905566b.4.2026.06.17.06.55.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 06:55:16 -0700 (PDT)
Message-ID: <9ba07c52-bf14-4e42-8fea-4e90281c3226@gmail.com>
Date: Wed, 17 Jun 2026 21:55:12 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid5: protect bitmap batch counters aka
 seq_flush/seq_write
To: sashiko-reviews@lists.linux.dev, Chen Cheng <chencheng@fnnas.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
References: <20260616131310.3790554-1-chencheng@fnnas.com>
 <20260616133034.015501F000E9@smtp.kernel.org>
From: Chen Cheng <chenchneg33@gmail.com>
In-Reply-To: <20260616133034.015501F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/6/16 21:30, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>
> Pre-existing issues:
> - [Critical] Missing full memory barriers between the bitmap update/scan and `seq_flush` access allows torn writes.
> --
>
> commit 45ef15a300eccd14518bc90e254146a73a49bf51
> Author: Chen Cheng <chencheng@fnnas.com>
>
> md/raid5: protect bitmap batch counters aka seq_flush/seq_write
>
> This commit attempts to fix a KCSAN data-race report on conf->seq_flush
> in the raid5 code by introducing READ_ONCE() and WRITE_ONCE().
>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index d0d7f96fd7cd9..ffc89ebbc4857 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -3538,7 +3538,7 @@ static void __add_stripe_bio(struct stripe_head *sh, struct bio *bi,
>>   		 sh->dev[dd_idx].sector);
>>   
>>   	if (conf->mddev->bitmap && firstwrite && !sh->batch_head) {
>> -		sh->bm_seq = conf->seq_flush+1;
>> +		sh->bm_seq = READ_ONCE(conf->seq_flush) + 1;
> [Severity: Critical]
> This is a pre-existing issue, but does this lockless synchronization require
> a full memory barrier (smp_mb()) before reading seq_flush?
>
> The producer sequence updates the in-memory bitmap (which drops a lock,
> providing only a Store-Release barrier) and then reads seq_flush. Because
> there is no full memory barrier between the store to the bitmap and the load
> of seq_flush, weakly-ordered CPUs (and even x86, which allows Store-Load
> reordering) can reorder the read of seq_flush before the store to the
> bitmap becomes globally visible.
>
> Could this lead to silent data corruption on a crash if the consumer sees
> the old bitmap state but the producer assigns the stripe to the current
> batch?


barrier provide a tool to promise "the things before this statement all 
done", and

I don't think I need such strong promise.


What I need is, "all cpu cache coherence for accesses variable 
seq_flush", so

READ_ONCE/WRITE_ONCE is suitable for this scenario.


>>   		set_bit(STRIPE_BIT_DELAY, &sh->state);
>>   	}
>>   }
> [ ... ]
>
>> @@ -5755,7 +5755,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
>>   		}
>>   		spin_unlock_irq(&sh->stripe_lock);
>>   		if (conf->mddev->bitmap) {
>> -			sh->bm_seq = conf->seq_flush + 1;
>> +			sh->bm_seq = READ_ONCE(conf->seq_flush) + 1;
> [Severity: Critical]
> This is a pre-existing issue, but the same missing full memory barrier
> pattern appears here in the discard path as well.
>
>>   			set_bit(STRIPE_BIT_DELAY, &sh->state);
>>   		}
>>   
> [ ... ]
>
>> @@ -6805,12 +6805,13 @@ static void raid5d(struct md_thread *thread)
>>   		if (
>>   		    !list_empty(&conf->bitmap_list)) {
>>   			/* Now is a good time to flush some bitmap updates */
>> -			conf->seq_flush++;
>> +			int seq = READ_ONCE(conf->seq_flush) + 1;
>> +			WRITE_ONCE(conf->seq_flush, seq);
> [Severity: Critical]
> This isn't a bug introduced by this patch, but does the consumer side
> also rely dangerously on implicit barriers?
>
> The consumer (raid5d) writes seq_flush and relies on an implicit full
> barrier deep inside unplug() (via test_and_clear_bit) to order the
> subsequent bitmap scan.
>
> If the producer's missing barrier allows the read of seq_flush to be
> reordered, the consumer might flush the old batch and advance seq_write,
> unblocking the producer's stripe to be written to disk without its
> write-intent bitmap bit being flushed.
>
>>   			spin_unlock_irq(&conf->device_lock);
>>   			if (md_bitmap_enabled(mddev, true))
>>   				mddev->bitmap_ops->unplug(mddev, true);
>>   			spin_lock_irq(&conf->device_lock);
>> -			conf->seq_write = conf->seq_flush;
>> +			WRITE_ONCE(conf->seq_write, seq);
>>   			activate_bit_delay(conf, conf->temp_inactive_list);
>>   		}
>>   		raid5_activate_delayed(conf);
