Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E391018DB26
	for <linux-raid@vger.kernel.org>; Sat, 30 Aug 2025 18:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756577788; cv=none; b=eC28jcFs067x9h7vAnOeoQyXOSRcwGVpw138H7v/2CJVYm3QAWyVQ3gFowqrBB7qN7rgatSi+SO4ckClrZlkujKQD6AFosxLfimYKiGUJWowuf6DwAt0P8MPiVpMGVcQYOsq9WTNZYyH08crl19g/joh+GzN+xjYWys06jonSP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756577788; c=relaxed/simple;
	bh=GVIPNrQD4vs9jayLesFT/CivZe+HUks9mAopUJTRO1s=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RDd+v1nnCn/Pcjp+WudtJD7rGiNwrk+JVLdVYlJ4YY46rnpGwvj6+LoxvGDNgAHfJeXSnv1kAp1Z5QY9uWw2TiUzif0our3Ff1TQiQdRl67nUtqlDQGhqJ73uMv4lF2eYCbKZiwV41r9/OTbuFJD2WqFxifX6hyWNtzwHNEpSL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=h8RwEX9V; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="h8RwEX9V"
Received: from NEET (p4224056-ipxg00p01tokaisakaetozai.aichi.ocn.ne.jp [118.15.57.56])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57UIAe1Q072448
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 31 Aug 2025 03:10:41 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=AEgDn3tnx67TZsTjPIBBJXhC3OkvNC/YDZWZnX4cMwM=;
        c=relaxed/relaxed; d=mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250315; t=1756577441; v=1;
        b=h8RwEX9Vk2LzHENs4aikhcHEvr3/UEyeLCJ2cb6seMt0RbeSDg+yd/hMOcfBjNk2
         VjX+fUCQtvR/6BLjrCY0FfCEBDGGSTgQfmz1NxDO/b6BA5nxgLPXmfhH8rpOYHXE
         XH3XA7LNlrZanZDvZgGPpz0imJva7k5sx6hwcDc5TujxgY3u2oe2qjSTXGfWzhQV
         vEHGbPYhz/OMagwReWjAE/FKP1T9CWR2Z6UHorkuLTiIsWEn++X7Rpr1ZmDdF+0t
         G/BZEZQOZFR4XX0i3j7G5vgjNzXzDgQmM0l0KL7X9nSwAr4JAAxdsZg12RiIela+
         Lg/PDgKfHGRJo2ABkXImYw==
Message-ID: <29e337bc-9eee-4794-ae1e-184ef91b9d24@mgml.me>
Date: Sun, 31 Aug 2025 03:10:40 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: Re: [PATCH v3 1/3] md/raid1,raid10: Do not set MD_BROKEN on failfast
 io failure
To: Li Nan <linan666@huaweicloud.com>, Song Liu <song@kernel.org>,
        Yu Kuai <yukuai3@huawei.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
References: <20250828163216.4225-1-k@mgml.me>
 <20250828163216.4225-2-k@mgml.me>
 <dcb72e23-d0ea-c8b3-24db-5dd515f619a8@huaweicloud.com>
 <6b3119f1-486e-4361-b04d-5e3c67a52a91@mgml.me>
 <3ea67e48-ce8a-9d70-a128-edf5eddf15f0@huaweicloud.com>
Content-Language: en-US
From: Kenta Akagi <k@mgml.me>
In-Reply-To: <3ea67e48-ce8a-9d70-a128-edf5eddf15f0@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/08/30 17:48, Li Nan wrote:
> 
> 
> 在 2025/8/29 20:21, Kenta Akagi 写道:
>>
>>
>> On 2025/08/29 11:54, Li Nan wrote:
>>>
>>> 在 2025/8/29 0:32, Kenta Akagi 写道:
>>>> This commit ensures that an MD_FAILFAST IO failure does not put
>>>> the array into a broken state.
>>>>
>>>> When failfast is enabled on rdev in RAID1 or RAID10,
>>>> the array may be flagged MD_BROKEN in the following cases.
>>>> - If MD_FAILFAST IOs to multiple rdevs fail simultaneously
>>>> - If an MD_FAILFAST metadata write to the 'last' rdev fails
>>>
>>> [...]
>>>
>>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>>> index 408c26398321..8a61fd93b3ff 100644
>>>> --- a/drivers/md/raid1.c
>>>> +++ b/drivers/md/raid1.c
>>>> @@ -470,6 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
>>>>                (bio->bi_opf & MD_FAILFAST) &&
>>>>                /* We never try FailFast to WriteMostly devices */
>>>>                !test_bit(WriteMostly, &rdev->flags)) {
>>>> +            set_bit(FailfastIOFailure, &rdev->flags);
>>>>                md_error(r1_bio->mddev, rdev);
>>>>            }
>>>>    @@ -1746,8 +1747,12 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>>>>     *    - recovery is interrupted.
>>>>     *    - &mddev->degraded is bumped.
>>>>     *
>>>> - * @rdev is marked as &Faulty excluding case when array is failed and
>>>> - * &mddev->fail_last_dev is off.
>>>> + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
>>>> + * then @mddev and @rdev will not be marked as failed.
>>>> + *
>>>> + * @rdev is marked as &Faulty excluding any cases:
>>>> + *    - when @mddev is failed and &mddev->fail_last_dev is off
>>>> + *    - when @rdev is last device and &FailfastIOFailure flag is set
>>>>     */
>>>>    static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>>>    {
>>>> @@ -1758,6 +1763,13 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>>>          if (test_bit(In_sync, &rdev->flags) &&
>>>>            (conf->raid_disks - mddev->degraded) == 1) {
>>>> +        if (test_and_clear_bit(FailfastIOFailure, &rdev->flags)) {
>>>> +            spin_unlock_irqrestore(&conf->device_lock, flags);
>>>> +            pr_warn_ratelimited("md/raid1:%s: Failfast IO failure on %pg, "
>>>> +                "last device but ignoring it\n",
>>>> +                mdname(mddev), rdev->bdev);
>>>> +            return;
>>>> +        }
>>>>            set_bit(MD_BROKEN, &mddev->flags);
>>>>              if (!mddev->fail_last_dev) {
>>>> @@ -2148,6 +2160,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>>>>        if (test_bit(FailFast, &rdev->flags)) {
>>>>            /* Don't try recovering from here - just fail it
>>>>             * ... unless it is the last working device of course */
>>>> +        set_bit(FailfastIOFailure, &rdev->flags);
>>>>            md_error(mddev, rdev);
>>>>            if (test_bit(Faulty, &rdev->flags))
>>>>                /* Don't try to read from here, but make sure
>>>> @@ -2652,6 +2665,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>>>>            fix_read_error(conf, r1_bio);
>>>>            unfreeze_array(conf);
>>>>        } else if (mddev->ro == 0 && test_bit(FailFast, &rdev->flags)) {
>>>> +        set_bit(FailfastIOFailure, &rdev->flags);
>>>>            md_error(mddev, rdev);
>>>>        } else {
>>>>            r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
>>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>>> index b60c30bfb6c7..530ad6503189 100644
>>>> --- a/drivers/md/raid10.c
>>>> +++ b/drivers/md/raid10.c
>>>> @@ -488,6 +488,7 @@ static void raid10_end_write_request(struct bio *bio)
>>>>                dec_rdev = 0;
>>>>                if (test_bit(FailFast, &rdev->flags) &&
>>>>                    (bio->bi_opf & MD_FAILFAST)) {
>>>> +                set_bit(FailfastIOFailure, &rdev->flags);
>>>>                    md_error(rdev->mddev, rdev);
>>>>                }
>>>>    
>>>
>>> Thank you for the patch. There may be an issue with 'test_and_clear'.
>>>
>>> If two write IO go to the same rdev, MD_BROKEN may be set as below:
>>
>>> IO1                    IO2
>>> set FailfastIOFailure
>>>                      set FailfastIOFailure
>>>   md_error
>>>    raid1_error
>>>     test_and_clear FailfastIOFailur
>>>                         md_error
>>>                        raid1_error
>>>                         //FailfastIOFailur is cleared
>>>                         set MD_BROKEN
>>>
>>> Maybe we should check whether FailfastIOFailure is already set before
>>> setting it. It also needs to be considered in metadata writes.
>> Thank you for reviewing.
>>
>> I agree, this seems to be as you described.
>> So, should it be implemented as follows?
>>
>> bool old=false;
>> do{
>>   spin_lock_irqsave(&conf->device_lock, flags);
>>   old = test_and_set_bit(FailfastIOFailure, &rdev->flags);
>>   spin_unlock_irqrestore(&conf->device_lock, flags);
>> }while(old);
>>
>> However, since I am concerned about potential deadlocks,
>> so I am considering two alternative approaches:
>>
>> * Add an atomic_t counter to md_rdev to track failfast IO failures.
>>
>> This may set MD_BROKEN at a slightly incorrect timing, but mixing
>> error handling of Failfast and non-Failfast IOs appears to be rare.
>> In any case, the final outcome would be the same, i.e. the array
>> ends up with MD_BROKEN. Therefore, I think this should not cause
>> issues. I think the same applies to test_and_set_bit.
>>
>> IO1                    IO2                    IO3
>> FailfastIOFailure      Normal IOFailure       FailfastIOFailure
>> atomic_inc
>>                                                  md_error                                     atomic_inc
>>    raid1_error
>>     atomic_dec //2to1
>>                         md_error
>>                          raid1_error           md_error
>>                           atomic_dec //1to0     raid1_error
>>                                                  atomic_dec //0
>>                                                    set MD_BROKEN
>>
>> * Alternatively, create a separate error handler,
>>    e.g. md_error_failfast(), that clearly does not fail the array.
>>
>> This approach would require somewhat larger changes and may not
>> be very elegant, but it seems to be a reliable way to ensure
>> MD_BROKEN is never set at the wrong timing.
>>
>> Which of these three approaches would you consider preferable?
>> I would appreciate your feedback.
>>
>>
>> For metadata writes, I plan to clear_bit MD_FAILFAST_SUPPORTED
>> when the array is degraded.
>>
>> Thanks,
>> Akagi
>>
> 
> I took a closer look at the FailFast code and found a few issues, using
> RAID1 as an example:
> 
> For normal read/write IO, FailFast is only triggered when there is another
> disk is available, as seen in read_balance() and raid1_write_request().
> In raid1_error(), MD_BROKEN is set only when no other disks are available.

Hi,
Agree, I think so too.

> So, the FailFast for normal read/write is not triggered in the scenario you
> described in cover-letter.

This corresponds to the case described in the commit message of PATCH v3 1/3.
"Normally, MD_FAILFAST IOs are not issued to the 'last' rdev, so this is
an edge case; however, it can occur if rdevs in a non-degraded
array share the same path and that path is lost, or if a metadata
write is triggered in a degraded array and fails due to failfast."

To describe it in more detail, the flow is as follows:

Prerequisites:

- Both rdevs are in-sync
- Both rdevs have in-flight MD_FAILFAST bios
- Both rdevs depend on the same lower-level path
  (e.g., nvme-tcp over a single Ethernet interface)

Sequence:

- A bios with REQ_FAILFAST_DEV fails (e.g., due to a temporary network outage),
  in the case of nvme-tcp:
   - The Ethernet connection is lost on the node where md is running over 5 seconds
   - Then the connection is restored. Idk the details of nvme-tcp implementation, 
     but it seems that failfast IOs finish only after the connection is back.
- All failfast bios fail, raid1_end_write_request is called.
- md_error() marks one rdev Faulty; the other rdev becomes the 'last' rdev.
- md_error() on the last rdev sets MD_BROKEN on the array - fail_last_dev=1 is unlikely.
- The write is retried via handle_write_finished -> narrow_write_error, usually succeeding.
- MD_BROKEN remains set, leaving the array in a state where no further writes can occur.

> Normal writes may call md_error() in narrow_write_error. Normal reads do
> not execute md_error() on the last disk.
> 
> Perhaps you should get more information to confirm how MD_BROKEN is set in
> normal read/write IO.

Should I add the above sequence of events to the cover letter, or commit message?

Thanks,
Akagi

> -- 
> Thanks,
> Nan
> 
> 

