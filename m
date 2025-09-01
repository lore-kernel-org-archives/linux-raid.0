Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAAD8F7D;
	Mon,  1 Sep 2025 03:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756696954; cv=none; b=QzI/YHds1G3xJngwBpCRp9f88CgoPIOrsyJ62SC3KYD0XQjI76feCL1yW/RUAu1JP4mgLfYLAOuGYkAfjf/Rv42DUdpoI+XXlI64vINY4R9uw2CRPh724pjmb3T7cv7FeZl3tiAGJ4duJg5a7Eq4nDfjGWPSvkozkVMONxzAu3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756696954; c=relaxed/simple;
	bh=gr9gfXPmnbo4CWYR1pNywpNUKF5EWpwcGr3AGmhvYhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KSDSoyeqlLquwY8JysIfq54pcyGKAbjYoJ1FSd7Ccd/9qrUE0lnS0HFqhINw/k74/zQSBD1wQKPm336xbdJw6jcxwKiQBZWtmwKLCqPEFrKuqI+BuC/RIp/h2FjgZjDjgAZ5HOIAv9QUvfxv6afRULEiqTyrMX72rwlu/zMZ+Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cFZ1f5X66zYQv6d;
	Mon,  1 Sep 2025 11:22:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 47D911A0AD3;
	Mon,  1 Sep 2025 11:22:29 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgDXIY5zEbVoo+3zAw--.55855S3;
	Mon, 01 Sep 2025 11:22:29 +0800 (CST)
Message-ID: <6edb5e2c-3f36-dc2c-3b41-9bf0e8ebb263@huaweicloud.com>
Date: Mon, 1 Sep 2025 11:22:27 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 1/3] md/raid1,raid10: Do not set MD_BROKEN on failfast
 io failure
To: Kenta Akagi <k@mgml.me>, Li Nan <linan666@huaweicloud.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Mariusz Tkaczyk <mtkaczyk@kernel.org>, Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250828163216.4225-1-k@mgml.me>
 <20250828163216.4225-2-k@mgml.me>
 <dcb72e23-d0ea-c8b3-24db-5dd515f619a8@huaweicloud.com>
 <6b3119f1-486e-4361-b04d-5e3c67a52a91@mgml.me>
 <3ea67e48-ce8a-9d70-a128-edf5eddf15f0@huaweicloud.com>
 <29e337bc-9eee-4794-ae1e-184ef91b9d24@mgml.me>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <29e337bc-9eee-4794-ae1e-184ef91b9d24@mgml.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXIY5zEbVoo+3zAw--.55855S3
X-Coremail-Antispam: 1UD129KBjvJXoW3ZryxKF1DKw1rZFW7Gr47CFg_yoWDtFWfpr
	1kJFyDJrW5Ar18Jr1Utr1UXFyUtr1UJ3WUXr1UJFy8Jrs8tr1Ygr4UXryjgr1UJr4rJw1U
	Jr1UJr47ZF1UJFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvg4fUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/8/31 2:10, Kenta Akagi 写道:
> 
> 
> On 2025/08/30 17:48, Li Nan wrote:
>>
>>
>> 在 2025/8/29 20:21, Kenta Akagi 写道:
>>>
>>>
>>> On 2025/08/29 11:54, Li Nan wrote:
>>>>
>>>> 在 2025/8/29 0:32, Kenta Akagi 写道:
>>>>> This commit ensures that an MD_FAILFAST IO failure does not put
>>>>> the array into a broken state.
>>>>>
>>>>> When failfast is enabled on rdev in RAID1 or RAID10,
>>>>> the array may be flagged MD_BROKEN in the following cases.
>>>>> - If MD_FAILFAST IOs to multiple rdevs fail simultaneously
>>>>> - If an MD_FAILFAST metadata write to the 'last' rdev fails
>>>>
>>>> [...]
>>>>
>>>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>>>> index 408c26398321..8a61fd93b3ff 100644
>>>>> --- a/drivers/md/raid1.c
>>>>> +++ b/drivers/md/raid1.c
>>>>> @@ -470,6 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
>>>>>                 (bio->bi_opf & MD_FAILFAST) &&
>>>>>                 /* We never try FailFast to WriteMostly devices */
>>>>>                 !test_bit(WriteMostly, &rdev->flags)) {
>>>>> +            set_bit(FailfastIOFailure, &rdev->flags);
>>>>>                 md_error(r1_bio->mddev, rdev);
>>>>>             }
>>>>>     @@ -1746,8 +1747,12 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>>>>>      *    - recovery is interrupted.
>>>>>      *    - &mddev->degraded is bumped.
>>>>>      *
>>>>> - * @rdev is marked as &Faulty excluding case when array is failed and
>>>>> - * &mddev->fail_last_dev is off.
>>>>> + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
>>>>> + * then @mddev and @rdev will not be marked as failed.
>>>>> + *
>>>>> + * @rdev is marked as &Faulty excluding any cases:
>>>>> + *    - when @mddev is failed and &mddev->fail_last_dev is off
>>>>> + *    - when @rdev is last device and &FailfastIOFailure flag is set
>>>>>      */
>>>>>     static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>>>>     {
>>>>> @@ -1758,6 +1763,13 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>>>>           if (test_bit(In_sync, &rdev->flags) &&
>>>>>             (conf->raid_disks - mddev->degraded) == 1) {
>>>>> +        if (test_and_clear_bit(FailfastIOFailure, &rdev->flags)) {
>>>>> +            spin_unlock_irqrestore(&conf->device_lock, flags);
>>>>> +            pr_warn_ratelimited("md/raid1:%s: Failfast IO failure on %pg, "
>>>>> +                "last device but ignoring it\n",
>>>>> +                mdname(mddev), rdev->bdev);
>>>>> +            return;
>>>>> +        }
>>>>>             set_bit(MD_BROKEN, &mddev->flags);
>>>>>               if (!mddev->fail_last_dev) {
>>>>> @@ -2148,6 +2160,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>>>>>         if (test_bit(FailFast, &rdev->flags)) {
>>>>>             /* Don't try recovering from here - just fail it
>>>>>              * ... unless it is the last working device of course */
>>>>> +        set_bit(FailfastIOFailure, &rdev->flags);
>>>>>             md_error(mddev, rdev);
>>>>>             if (test_bit(Faulty, &rdev->flags))
>>>>>                 /* Don't try to read from here, but make sure
>>>>> @@ -2652,6 +2665,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>>>>>             fix_read_error(conf, r1_bio);
>>>>>             unfreeze_array(conf);
>>>>>         } else if (mddev->ro == 0 && test_bit(FailFast, &rdev->flags)) {
>>>>> +        set_bit(FailfastIOFailure, &rdev->flags);
>>>>>             md_error(mddev, rdev);
>>>>>         } else {
>>>>>             r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
>>>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>>>> index b60c30bfb6c7..530ad6503189 100644
>>>>> --- a/drivers/md/raid10.c
>>>>> +++ b/drivers/md/raid10.c
>>>>> @@ -488,6 +488,7 @@ static void raid10_end_write_request(struct bio *bio)
>>>>>                 dec_rdev = 0;
>>>>>                 if (test_bit(FailFast, &rdev->flags) &&
>>>>>                     (bio->bi_opf & MD_FAILFAST)) {
>>>>> +                set_bit(FailfastIOFailure, &rdev->flags);
>>>>>                     md_error(rdev->mddev, rdev);
>>>>>                 }
>>>>>     
>>>>
>>>> Thank you for the patch. There may be an issue with 'test_and_clear'.
>>>>
>>>> If two write IO go to the same rdev, MD_BROKEN may be set as below:
>>>
>>>> IO1                    IO2
>>>> set FailfastIOFailure
>>>>                       set FailfastIOFailure
>>>>    md_error
>>>>     raid1_error
>>>>      test_and_clear FailfastIOFailur
>>>>                          md_error
>>>>                         raid1_error
>>>>                          //FailfastIOFailur is cleared
>>>>                          set MD_BROKEN
>>>>
>>>> Maybe we should check whether FailfastIOFailure is already set before
>>>> setting it. It also needs to be considered in metadata writes.
>>> Thank you for reviewing.
>>>
>>> I agree, this seems to be as you described.
>>> So, should it be implemented as follows?
>>>
>>> bool old=false;
>>> do{
>>>    spin_lock_irqsave(&conf->device_lock, flags);
>>>    old = test_and_set_bit(FailfastIOFailure, &rdev->flags);
>>>    spin_unlock_irqrestore(&conf->device_lock, flags);
>>> }while(old);
>>>
>>> However, since I am concerned about potential deadlocks,
>>> so I am considering two alternative approaches:
>>>
>>> * Add an atomic_t counter to md_rdev to track failfast IO failures.
>>>
>>> This may set MD_BROKEN at a slightly incorrect timing, but mixing
>>> error handling of Failfast and non-Failfast IOs appears to be rare.
>>> In any case, the final outcome would be the same, i.e. the array
>>> ends up with MD_BROKEN. Therefore, I think this should not cause
>>> issues. I think the same applies to test_and_set_bit.
>>>
>>> IO1                    IO2                    IO3
>>> FailfastIOFailure      Normal IOFailure       FailfastIOFailure
>>> atomic_inc
>>>                                                   md_error                                     atomic_inc
>>>     raid1_error
>>>      atomic_dec //2to1
>>>                          md_error
>>>                           raid1_error           md_error
>>>                            atomic_dec //1to0     raid1_error
>>>                                                   atomic_dec //0
>>>                                                     set MD_BROKEN
>>>
>>> * Alternatively, create a separate error handler,
>>>     e.g. md_error_failfast(), that clearly does not fail the array.
>>>
>>> This approach would require somewhat larger changes and may not
>>> be very elegant, but it seems to be a reliable way to ensure
>>> MD_BROKEN is never set at the wrong timing.
>>>
>>> Which of these three approaches would you consider preferable?
>>> I would appreciate your feedback.
>>>
>>>
>>> For metadata writes, I plan to clear_bit MD_FAILFAST_SUPPORTED
>>> when the array is degraded.
>>>
>>> Thanks,
>>> Akagi
>>>
>>
>> I took a closer look at the FailFast code and found a few issues, using
>> RAID1 as an example:
>>
>> For normal read/write IO, FailFast is only triggered when there is another
>> disk is available, as seen in read_balance() and raid1_write_request().
>> In raid1_error(), MD_BROKEN is set only when no other disks are available.
> 
> Hi,
> Agree, I think so too.
> 
>> So, the FailFast for normal read/write is not triggered in the scenario you
>> described in cover-letter.
> 
> This corresponds to the case described in the commit message of PATCH v3 1/3.
> "Normally, MD_FAILFAST IOs are not issued to the 'last' rdev, so this is
> an edge case; however, it can occur if rdevs in a non-degraded
> array share the same path and that path is lost, or if a metadata
> write is triggered in a degraded array and fails due to failfast."
> 
> To describe it in more detail, the flow is as follows:
> 
> Prerequisites:
> 
> - Both rdevs are in-sync
> - Both rdevs have in-flight MD_FAILFAST bios
> - Both rdevs depend on the same lower-level path
>    (e.g., nvme-tcp over a single Ethernet interface)
> 
> Sequence:
> 
> - A bios with REQ_FAILFAST_DEV fails (e.g., due to a temporary network outage),
>    in the case of nvme-tcp:
>     - The Ethernet connection is lost on the node where md is running over 5 seconds
>     - Then the connection is restored. Idk the details of nvme-tcp implementation,
>       but it seems that failfast IOs finish only after the connection is back.
> - All failfast bios fail, raid1_end_write_request is called.
> - md_error() marks one rdev Faulty; the other rdev becomes the 'last' rdev.
> - md_error() on the last rdev sets MD_BROKEN on the array - fail_last_dev=1 is unlikely.
> - The write is retried via handle_write_finished -> narrow_write_error, usually succeeding.
> - MD_BROKEN remains set, leaving the array in a state where no further writes can occur.
> 

Thanks for your patient explanation. I understand. Maybe we need a separate
error-handling path for failfast. How about adding an extra parameter to 
md_error()?

Kuai, do you have any suggestions?

>> Normal writes may call md_error() in narrow_write_error. Normal reads do
>> not execute md_error() on the last disk.
>>
>> Perhaps you should get more information to confirm how MD_BROKEN is set in
>> normal read/write IO.
> 
> Should I add the above sequence of events to the cover letter, or commit message?
> 

I think we should mention this in the commit message.

> Thanks,
> Akagi
> 
>> -- 
>> Thanks,
>> Nan
>>
>>
> 
> 
> .

-- 
Thanks,
Nan

