Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646503A3822;
	Tue, 14 Apr 2026 08:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776155259; cv=none; b=N/oPZYFAqm+dn2N6ZtnbbykTs+w0hc8yrfRu9X1yUVR3GIPOG96+iUqEDLlwrVC1ULEGsMr1YIvlkRfDjksPtzcXyfdC0BbhF77bNKA4yOd1u5GJYBoh1ruDhKJ745zu5zbRHAUm+5HWD1oMUH54IU19LZiGI2/jDCl03iWGWF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776155259; c=relaxed/simple;
	bh=I23fUu2dDPlPrEKIF3gjXnL5qLOAiSBKW4ZlNTa61og=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IGdirnzQnQrJAKDmZEY1LU2iyeEm/Bo8AhO4Ub8IagGFvJHG/1/ulDZXDMFxUQWWvRGlntyqqKb7C6yLE1zWNqeYRXSMxHaLHf5SrItnByYNg7XCzoPqU5a0QMR/eBZp5UjcTn9m7N+zfSGkjfh7Z++L3TEH1NKeHyN4FMQSnLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=bsJ6hdUM; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="bsJ6hdUM"
Received: from [10.17.40.225] (unknown [10.17.40.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4fvy7k72nHzHwm62R;
	Tue, 14 Apr 2026 16:27:30 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1776155251; bh=I23fUu2dDPlPrEKIF3gjXnL5qLOAiSBKW4ZlNTa61og=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bsJ6hdUMKbMNA/qAHCxh1kv5wd4ZXHmFn2R7zonV4MSvIkkJJskEVEO81AEH0n/24
	 1HA0bVGsEtx1YHmWXyFezKT0V8jsAP7d/d7NHr2idZBVExz6JaXkmKuqlbTkuD+pYo
	 awsC93SSv5qDPUaGlmbXGd8Yhli+QuYMZz6f4tvY=
Message-ID: <d35f1303-70bc-4a2b-bdc2-9ea8040175c1@synology.com>
Date: Tue, 14 Apr 2026 16:27:03 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid5: fix race between reshape and chunk-aligned read
To: Li Nan <linan666@huaweicloud.com>, song@kernel.org, yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <20260409051722.2865321-1-dannyshih@synology.com>
 <f032ef85-8cd3-1615-3c42-e434011b0056@huaweicloud.com>
Content-Language: en-US
From: FengWei Shih <dannyshih@synology.com>
In-Reply-To: <f032ef85-8cd3-1615-3c42-e434011b0056@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no

Hi Nan,

Li Nan 於 2026/4/13 下午 03:19 寫道:
>
>
> 在 2026/4/9 13:17, FengWei Shih 写道:
>> raid5_make_request() checks mddev->reshape_position to decide whether
>> to allow chunk-aligned reads. However in raid5_start_reshape(), the
>> layout configuration (raid_disks, algorithm, etc.) is updated before
>> mddev->reshape_position is set:
>>
>>    reshape (raid5_start_reshape)        read (raid5_make_request)
>>    ============================== ===========================
>>    write_seqcount_begin
>>    update raid_disks, algorithm...
>>    set conf->reshape_progress
>>    write_seqcount_end
>>                                          check mddev->reshape_position
>>                                            * still MaxSector, allow
>>                                          raid5_read_one_chunk()
>>                                            * use new layout
>>    raid5_quiesce()
>>    set mddev->reshape_position
>>
>> Since reshape_position is not yet updated, raid5_make_request()
>> considers no reshape is in progress and proceeds with the
>> chunk-aligned path, but the layout has already changed, causing
>> raid5_compute_sector() to return an incorrect physical address.
>>
>> Fix this by reading conf->reshape_progress under gen_lock in
>> raid5_read_one_chunk() and falling back to the stripe path if a
>> reshape is in progress.
>>
>> Signed-off-by: FengWei Shih <dannyshih@synology.com>
>> ---
>>   drivers/md/raid5.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index a8e8d431071b..bded2b86f0ef 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -5421,6 +5421,11 @@ static int raid5_read_one_chunk(struct mddev 
>> *mddev, struct bio *raid_bio)
>>       sector_t sector, end_sector;
>>       int dd_idx;
>>       bool did_inc;
>> +    int seq;
>> +
>> +    seq = read_seqcount_begin(&conf->gen_lock);
>> +    if (unlikely(conf->reshape_progress != MaxSector))
>> +        return 0;
>>         if (!in_chunk_boundary(mddev, raid_bio)) {
>>           pr_debug("%s: non aligned\n", __func__);
>> @@ -5431,6 +5436,9 @@ static int raid5_read_one_chunk(struct mddev 
>> *mddev, struct bio *raid_bio)
>>                         &dd_idx, NULL);
>>       end_sector = sector + bio_sectors(raid_bio);
>>   +    if (read_seqcount_retry(&conf->gen_lock, seq))
>> +        return 0;
>> +
>>       if (r5c_big_stripe_cached(conf, sector))
>>           return 0;
>
> It seems that there might be race issues wherever raid5_compute_sector is
> used? This fix only addresses one of the problems.
>
Thanks for the review. You are right that this race pattern affects
more than just raid5_read_one_chunk(). I checked the callers of
raid5_compute_*() and some lockless reshape_progress / reshape_position
checks:

Already safe:

- make_stripe_request(): already uses gen_lock seqcount properly.

- init_stripe() / stripe_set_idx(): init_stripe() is under gen_lock;
   stripe_set_idx() is only used for the dst stripe in handle_stripe().

- handle_stripe_expansion() / reshape_request(): reshape-internal,
   intentional new layout.

- raid5-cache.c / raid5-ppl.c: journal/PPL are not allowed with
   reshape, so no race.

- raid5_bio_lowest_chunk_sector(): no lock protection, but the return
   value is bounded within the bio's stripe range, so the worst case
   is suboptimal I/O ordering — no data corruption or lost I/O.

Needs fix:

- raid5_read_one_chunk(): fixed by this patch.

- retry_aligned_read(): has a similar issue. I will fix it with
   gen_lock seqcount in the next version of this patch.

- raid5_bitmap_sector(): if the check sees LOC_NO_RESHAPE but reshape
   starts and passes this region before the stripe is processed, the
   bitmap position will not match the layout used for the write.

- make_discard_request(): checks mddev->reshape_position and computes
   logical sectors from the layout fields, all without any lock.

- raid5_make_request(): the lockless reshape_progress check that decides
   on_wq can race with reshape start.

I think there are two possible solutions:

1. All callers should check reshape within proper locking
    (conf->device_lock or conf->gen_lock).

2. Suspend I/O during start_reshape via mddev_suspend() /
    mddev_resume(), so readers do not need to worry about seeing an
    inconsistent state.

I am going with direction 1 for now since gen_lock seems to be
designed for exactly this kind of race.

Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
