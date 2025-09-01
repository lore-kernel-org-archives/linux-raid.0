Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66C93064A7
	for <linux-raid@vger.kernel.org>; Mon,  1 Sep 2025 16:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756745373; cv=none; b=DKy4x6ACtnD5w6M0vT1M+EKRdoJcii1Bl4z8qVLDX8pJ8BMwk+CoKLi/EsyHfwtxei8zh16MYgs5ntzpVT70vWB2oUM28GTiSlJAVfQhlmrKcD9mRVycazIw8QQqa/IQpWFySxl17CKIAcEXOQr4JGg6WTVAjS1ljRDk3UMrjEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756745373; c=relaxed/simple;
	bh=RurAxDJ5pm/l1uObYmfuuusFS/vmLr1t4r4vNmf3ZOs=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WDVE/Uzi0Uue8lZ/SG3x4Is0fiaZ8TmA33+SfkgCHdMacgRV7LAoAKTh+7/ZgPftBuaQxok0eogpZuIHA8HvAj8KEQt56dTj0KsY/NHuePCfH4eDbSxHfsk6K/WPib5I1pv/w9ZdI71GHWZa6q5/rsfAMRNKkMWYeDhHY0DjsTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=H3KpyNJC; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="H3KpyNJC"
Received: from NEET (p3835079-ipxg00j01tokaisakaetozai.aichi.ocn.ne.jp [118.0.180.79])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 581GmitT064793
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 2 Sep 2025 01:48:44 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=AWUGbSV+pwyEwjfs8fZezaBwSTB4lNlcVQUY6xQJf3o=;
        c=relaxed/relaxed; d=mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250315; t=1756745324; v=1;
        b=H3KpyNJCPL0BIwfh7KoF8WFfrLTpo3hqEr0mucA4Rua/cUvaZwc1LvFTK+LdW4XW
         ugKeAnDzN96Gt7iLU+lfHTty+Jv1pJiNRTv4t3Q2kNslsBbGlW8wXnWCpq2FAIHl
         XURoSzl3FSB4zSUrBXmUaCInG+cJZNwoStVNvJph6hnn4rSPgO3ldqwxTEC2bHU6
         ZTA/2cA8OOfc6mmKf8u4u2A8gFhPd3yqzhy4shNzX64W8eUUEHKCXDBZt/OF2LS2
         HAdaxx/gkI0iRNtzTU50oliUzxK4IuGChUFLfeDibxdO9TwsbaptD6V2/GirIL3i
         M0OzMAMrLK5SVz2w83BktA==
Message-ID: <34ebcc5b-db67-49e0-a304-4882fa82e830@mgml.me>
Date: Tue, 2 Sep 2025 01:48:44 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>, Kenta Akagi <k@mgml.me>
Subject: Re: [PATCH v3 1/3] md/raid1,raid10: Do not set MD_BROKEN on failfast
 io failure
To: Yu Kuai <yukuai1@huaweicloud.com>, Li Nan <linan666@huaweicloud.com>,
        Song Liu <song@kernel.org>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
References: <20250828163216.4225-1-k@mgml.me>
 <20250828163216.4225-2-k@mgml.me>
 <dcb72e23-d0ea-c8b3-24db-5dd515f619a8@huaweicloud.com>
 <6b3119f1-486e-4361-b04d-5e3c67a52a91@mgml.me>
 <3ea67e48-ce8a-9d70-a128-edf5eddf15f0@huaweicloud.com>
 <29e337bc-9eee-4794-ae1e-184ef91b9d24@mgml.me>
 <6edb5e2c-3f36-dc2c-3b41-9bf0e8ebb263@huaweicloud.com>
 <7e268dff-4f29-4155-8644-45be74d4c465@mgml.me>
 <48902d38-c2a1-b74d-d5fb-3d1cdc0b05dc@huaweicloud.com>
Content-Language: en-US
From: Kenta Akagi <k@mgml.me>
In-Reply-To: <48902d38-c2a1-b74d-d5fb-3d1cdc0b05dc@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/09/01 16:48, Yu Kuai wrote:
> Hi,
> 
> 在 2025/09/01 12:22, Kenta Akagi 写道:
>>
>>
>> On 2025/09/01 12:22, Li Nan wrote:
>>>
>>>
>>> 在 2025/8/31 2:10, Kenta Akagi 写道:
>>>>
>>>>
>>>> On 2025/08/30 17:48, Li Nan wrote:
>>>>>
>>>>>
>>>>> 在 2025/8/29 20:21, Kenta Akagi 写道:
>>>>>>
>>>>>>
>>>>>> On 2025/08/29 11:54, Li Nan wrote:
>>>>>>>
>>>>>>> 在 2025/8/29 0:32, Kenta Akagi 写道:
>>>>>>>> This commit ensures that an MD_FAILFAST IO failure does not put
>>>>>>>> the array into a broken state.
>>>>>>>>
>>>>>>>> When failfast is enabled on rdev in RAID1 or RAID10,
>>>>>>>> the array may be flagged MD_BROKEN in the following cases.
>>>>>>>> - If MD_FAILFAST IOs to multiple rdevs fail simultaneously
>>>>>>>> - If an MD_FAILFAST metadata write to the 'last' rdev fails
>>>>>>>
>>>>>>> [...]
>>>>>>>
>>>>>>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>>>>>>> index 408c26398321..8a61fd93b3ff 100644
>>>>>>>> --- a/drivers/md/raid1.c
>>>>>>>> +++ b/drivers/md/raid1.c
>>>>>>>> @@ -470,6 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
>>>>>>>>                  (bio->bi_opf & MD_FAILFAST) &&
>>>>>>>>                  /* We never try FailFast to WriteMostly devices */
>>>>>>>>                  !test_bit(WriteMostly, &rdev->flags)) {
>>>>>>>> +            set_bit(FailfastIOFailure, &rdev->flags);
>>>>>>>>                  md_error(r1_bio->mddev, rdev);
>>>>>>>>              }
>>>>>>>>      @@ -1746,8 +1747,12 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>>>>>>>>       *    - recovery is interrupted.
>>>>>>>>       *    - &mddev->degraded is bumped.
>>>>>>>>       *
>>>>>>>> - * @rdev is marked as &Faulty excluding case when array is failed and
>>>>>>>> - * &mddev->fail_last_dev is off.
>>>>>>>> + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
>>>>>>>> + * then @mddev and @rdev will not be marked as failed.
>>>>>>>> + *
>>>>>>>> + * @rdev is marked as &Faulty excluding any cases:
>>>>>>>> + *    - when @mddev is failed and &mddev->fail_last_dev is off
>>>>>>>> + *    - when @rdev is last device and &FailfastIOFailure flag is set
>>>>>>>>       */
>>>>>>>>      static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>>>>>>>      {
>>>>>>>> @@ -1758,6 +1763,13 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>>>>>>>            if (test_bit(In_sync, &rdev->flags) &&
>>>>>>>>              (conf->raid_disks - mddev->degraded) == 1) {
>>>>>>>> +        if (test_and_clear_bit(FailfastIOFailure, &rdev->flags)) {
>>>>>>>> +            spin_unlock_irqrestore(&conf->device_lock, flags);
>>>>>>>> +            pr_warn_ratelimited("md/raid1:%s: Failfast IO failure on %pg, "
>>>>>>>> +                "last device but ignoring it\n",
>>>>>>>> +                mdname(mddev), rdev->bdev);
>>>>>>>> +            return;
>>>>>>>> +        }
>>>>>>>>              set_bit(MD_BROKEN, &mddev->flags);
>>>>>>>>                if (!mddev->fail_last_dev) {
>>>>>>>> @@ -2148,6 +2160,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>>>>>>>>          if (test_bit(FailFast, &rdev->flags)) {
>>>>>>>>              /* Don't try recovering from here - just fail it
>>>>>>>>               * ... unless it is the last working device of course */
>>>>>>>> +        set_bit(FailfastIOFailure, &rdev->flags);
>>>>>>>>              md_error(mddev, rdev);
>>>>>>>>              if (test_bit(Faulty, &rdev->flags))
>>>>>>>>                  /* Don't try to read from here, but make sure
>>>>>>>> @@ -2652,6 +2665,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>>>>>>>>              fix_read_error(conf, r1_bio);
>>>>>>>>              unfreeze_array(conf);
>>>>>>>>          } else if (mddev->ro == 0 && test_bit(FailFast, &rdev->flags)) {
>>>>>>>> +        set_bit(FailfastIOFailure, &rdev->flags);
>>>>>>>>              md_error(mddev, rdev);
>>>>>>>>          } else {
>>>>>>>>              r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
>>>>>>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>>>>>>> index b60c30bfb6c7..530ad6503189 100644
>>>>>>>> --- a/drivers/md/raid10.c
>>>>>>>> +++ b/drivers/md/raid10.c
>>>>>>>> @@ -488,6 +488,7 @@ static void raid10_end_write_request(struct bio *bio)
>>>>>>>>                  dec_rdev = 0;
>>>>>>>>                  if (test_bit(FailFast, &rdev->flags) &&
>>>>>>>>                      (bio->bi_opf & MD_FAILFAST)) {
>>>>>>>> +                set_bit(FailfastIOFailure, &rdev->flags);
>>>>>>>>                      md_error(rdev->mddev, rdev);
>>>>>>>>                  }
>>>>>>>>      
>>>>>>>
>>>>>>> Thank you for the patch. There may be an issue with 'test_and_clear'.
>>>>>>>
>>>>>>> If two write IO go to the same rdev, MD_BROKEN may be set as below:
>>>>>>
>>>>>>> IO1                    IO2
>>>>>>> set FailfastIOFailure
>>>>>>>                        set FailfastIOFailure
>>>>>>>     md_error
>>>>>>>      raid1_error
>>>>>>>       test_and_clear FailfastIOFailur
>>>>>>>                           md_error
>>>>>>>                          raid1_error
>>>>>>>                           //FailfastIOFailur is cleared
>>>>>>>                           set MD_BROKEN
>>>>>>>
>>>>>>> Maybe we should check whether FailfastIOFailure is already set before
>>>>>>> setting it. It also needs to be considered in metadata writes.
>>>>>> Thank you for reviewing.
>>>>>>
>>>>>> I agree, this seems to be as you described.
>>>>>> So, should it be implemented as follows?
>>>>>>
>>>>>> bool old=false;
>>>>>> do{
>>>>>>     spin_lock_irqsave(&conf->device_lock, flags);
>>>>>>     old = test_and_set_bit(FailfastIOFailure, &rdev->flags);
>>>>>>     spin_unlock_irqrestore(&conf->device_lock, flags);
>>>>>> }while(old);
>>>>>>
>>>>>> However, since I am concerned about potential deadlocks,
>>>>>> so I am considering two alternative approaches:
>>>>>>
>>>>>> * Add an atomic_t counter to md_rdev to track failfast IO failures.
>>>>>>
>>>>>> This may set MD_BROKEN at a slightly incorrect timing, but mixing
>>>>>> error handling of Failfast and non-Failfast IOs appears to be rare.
>>>>>> In any case, the final outcome would be the same, i.e. the array
>>>>>> ends up with MD_BROKEN. Therefore, I think this should not cause
>>>>>> issues. I think the same applies to test_and_set_bit.
>>>>>>
>>>>>> IO1                    IO2                    IO3
>>>>>> FailfastIOFailure      Normal IOFailure       FailfastIOFailure
>>>>>> atomic_inc
>>>>>>                                                    md_error                                     atomic_inc
>>>>>>      raid1_error
>>>>>>       atomic_dec //2to1
>>>>>>                           md_error
>>>>>>                            raid1_error           md_error
>>>>>>                             atomic_dec //1to0     raid1_error
>>>>>>                                                    atomic_dec //0
>>>>>>                                                      set MD_BROKEN
>>>>>>
>>>>>> * Alternatively, create a separate error handler,
>>>>>>      e.g. md_error_failfast(), that clearly does not fail the array.
>>>>>>
>>>>>> This approach would require somewhat larger changes and may not
>>>>>> be very elegant, but it seems to be a reliable way to ensure
>>>>>> MD_BROKEN is never set at the wrong timing.
>>>>>>
>>>>>> Which of these three approaches would you consider preferable?
>>>>>> I would appreciate your feedback.
>>>>>>
>>>>>>
>>>>>> For metadata writes, I plan to clear_bit MD_FAILFAST_SUPPORTED
>>>>>> when the array is degraded.
>>>>>>
>>>>>> Thanks,
>>>>>> Akagi
>>>>>>
>>>>>
>>>>> I took a closer look at the FailFast code and found a few issues, using
>>>>> RAID1 as an example:
>>>>>
>>>>> For normal read/write IO, FailFast is only triggered when there is another
>>>>> disk is available, as seen in read_balance() and raid1_write_request().
>>>>> In raid1_error(), MD_BROKEN is set only when no other disks are available.
>>>>
>>>> Hi,
>>>> Agree, I think so too.
>>>>
>>>>> So, the FailFast for normal read/write is not triggered in the scenario you
>>>>> described in cover-letter.
>>>>
>>>> This corresponds to the case described in the commit message of PATCH v3 1/3.
>>>> "Normally, MD_FAILFAST IOs are not issued to the 'last' rdev, so this is
>>>> an edge case; however, it can occur if rdevs in a non-degraded
>>>> array share the same path and that path is lost, or if a metadata
>>>> write is triggered in a degraded array and fails due to failfast."
>>>>
>>>> To describe it in more detail, the flow is as follows:
>>>>
>>>> Prerequisites:
>>>>
>>>> - Both rdevs are in-sync
>>>> - Both rdevs have in-flight MD_FAILFAST bios
>>>> - Both rdevs depend on the same lower-level path
>>>>     (e.g., nvme-tcp over a single Ethernet interface)
>>>>
>>>> Sequence:
>>>>
>>>> - A bios with REQ_FAILFAST_DEV fails (e.g., due to a temporary network outage),
>>>>     in the case of nvme-tcp:
>>>>      - The Ethernet connection is lost on the node where md is running over 5 seconds
>>>>      - Then the connection is restored. Idk the details of nvme-tcp implementation,
>>>>        but it seems that failfast IOs finish only after the connection is back.
>>>> - All failfast bios fail, raid1_end_write_request is called.
>>>> - md_error() marks one rdev Faulty; the other rdev becomes the 'last' rdev.
>>>> - md_error() on the last rdev sets MD_BROKEN on the array - fail_last_dev=1 is unlikely.
>>>> - The write is retried via handle_write_finished -> narrow_write_error, usually succeeding.
>>>> - MD_BROKEN remains set, leaving the array in a state where no further writes can occur.
>>>>
>>>
>>> Thanks for your patient explanation. I understand. Maybe we need a separate
>>> error-handling path for failfast. How about adding an extra parameter to md_error()?
>>
>> Thank you for reviewing.
>>
>> I am thinking of proceeding like as follows.
>> md_error is EXPORT_SYMBOL. I think that it is undesirable to change the ABI of this function.
>>
> 
> It doesn't matter if it's a exported symbol, we should just keep code as
> simple as possible.
>> ...
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index ac85ec73a409..855cddeb0c09 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -8197,3 +8197,3 @@ EXPORT_SYMBOL(md_unregister_thread);
>>
>> -void md_error(struct mddev *mddev, struct md_rdev *rdev)
>> +void _md_error(struct mddev *mddev, struct md_rdev *rdev, bool nofail)
>>   {
>> @@ -8204,3 +8204,3 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>>                  return;
>> -       mddev->pers->error_handler(mddev, rdev);
>> +       mddev->pers->error_handler(mddev, rdev, nofail);
>>
>> @@ -8222,4 +8222,26 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>>   }
>> +
>> +void md_error(struct mddev *mddev, struct md_rdev *rdev)
>> +{
>> +       return _md_error(mddev, rdev, false);
>> +}
>>   EXPORT_SYMBOL(md_error);
>>
>> +void md_error_failfast(struct mddev *mddev, struct md_rdev *rdev)
>> +{
>> +       WARN_ON(mddev->pers->head.id != ID_RAID1 &&
>> +               mddev->pers->head.id != ID_RAID10);
>> +       return _md_error(mddev, rdev, true);
>> +}
>> +EXPORT_SYMBOL(md_error_failfast);
>> +
> 
> I will prefer we add a common procedures to fix this problme.
> 
> How about the first patch to serialize all the md_error(), and then
> and a new helper md_bio_failue_error(mddev, rdev, bio), called when
> bio is failed, in this helper:
> 
> 1) if bio is not failfast, call md_error() and return true; otherwise:
> 2) if rdev contain the last data copy, return false directly, caller
> should check return value and retry, otherwise:
> 3) call md_error() and return true;

Hi,
I think this approach has some issues. There are cases where md_error is
called only when MD_FAILFAST is set.

One example is the processing below in raid1_end_write_request.

> Then, for raid1, the callers will look like:
> 
> iff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1baaf52c603c..c6d150e9f1a7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1003,9 +1003,7 @@ static void super_written(struct bio *bio)
>         if (bio->bi_status) {
>                 pr_err("md: %s gets error=%d\n", __func__,
>                        blk_status_to_errno(bio->bi_status));
> -               md_error(mddev, rdev);
> -               if (!test_bit(Faulty, &rdev->flags)
> -                   && (bio->bi_opf & MD_FAILFAST)) {
> +               if (!md_bio_failure_error(mddev, rdev, bio)) {
>                         set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>                         set_bit(LastDev, &rdev->flags);
>                 }
> 
> @@ -466,20 +472,11 @@ static void raid1_end_write_request(struct bio *bio)
>                         set_bit(MD_RECOVERY_NEEDED, &
>                                 conf->mddev->recovery);
> 
> -               if (test_bit(FailFast, &rdev->flags) &&
> -                   (bio->bi_opf & MD_FAILFAST) &&
>                     /* We never try FailFast to WriteMostly devices */
> -                   !test_bit(WriteMostly, &rdev->flags)) {
> -                       md_error(r1_bio->mddev, rdev);
> -               }
> -
> -               /*
> -                * When the device is faulty, it is not necessary to
> -                * handle write error.
> -                */
> -               if (!test_bit(Faulty, &rdev->flags))
> +               if(!test_bit(WriteMostly, &rdev->flags) &&
> +                  !md_bio_failure_error(mddev, rdev, bio)) {
>                         set_bit(R1BIO_WriteError, &r1_bio->state);
> -               else {
> +               } else {
>                         /* Finished with this branch */
>                         r1_bio->bios[mirror] = NULL;
>                         to_put = bio;

In the current raid1_end_write_request implementation, 
- md_error is called only in the Failfast case.
- Afterwards, if the rdev is not Faulty (that is, not Failfast, 
  or Failfast but the last rdev — which originally was not expected 
  MD_BROKEN in RAID1), R1BIO_WriteError is set.
In the suggested implementation, it seems that a non-Failfast write 
failure will immediately mark the rdev as Faulty, without retries.

This could be avoided by testing MD_FAILFAST before call the 
new helper md_bio_failure_error, but I believe duplicating the 
same check in both caller/callee would be undesirable.

Should we try to avoid modifying pers->error_handler?
One possible alternative approach is as follows.

- serialize calls to md_error regardless of whether Failfast or not
- raid{1,10}_error is:
  - The remaining copy (rdev) is marked with the LastDev flag
  - clear MD_FAILFAST_SUPPORTED for prohibit super_write using Failfast
- super_written will simply put MD_SB_NEED_REWRITE without calling 
  md_error when MD_FAILFAST bio and LastDev rdev.

After the changes, I believe it is rare for super_written to be called with error on
multiple rdevs due to failfast. super_write is caused by errors from normal failfast 
IO and invoked via MD_SB_CHANGE_DEVS through the serialized raid1_error. Since
MD_FAILFAST_SUPPORTED is cleared, metadata writes occur without failfast.

It's not exactly a common procedure, but as it doesn't add functions to md.c, 
I think this approach is preferable to adding md_error_failfast().

...
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1baaf52c603c..ba524fa96091 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1003,14 +1003,15 @@ static void super_written(struct bio *bio)
        if (bio->bi_status) {
                pr_err("md: %s gets error=%d\n", __func__,
                       blk_status_to_errno(bio->bi_status));
-               md_error(mddev, rdev);
-               if (!test_bit(Faulty, &rdev->flags)
+               if (test_bit(LastDev, &rdev->flags)
                    && (bio->bi_opf & MD_FAILFAST)) {
+                       pr_warn("md: %s: Metadata write will be repeated to %pg\n",
+                               mdname(mddev), rdev->bdev);
                        set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
-                       set_bit(LastDev, &rdev->flags);
+               } else {
+                       md_error(mddev, rdev);
                }
-       } else
-               clear_bit(LastDev, &rdev->flags);
+       }

        bio_put(bio);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 408c26398321..a52c5277add7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -470,7 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
                    (bio->bi_opf & MD_FAILFAST) &&
                    /* We never try FailFast to WriteMostly devices */
                    !test_bit(WriteMostly, &rdev->flags)) {
-                       md_error(r1_bio->mddev, rdev);
+                       raid1_md_error_failfast(r1_bio->mddev, rdev);
                }

                /*
@@ -1733,6 +1733,27 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
        seq_printf(seq, "]");
 }

+static void _raid1_md_error(struct mddev *mddev, struct md_rdev *rdev, bool failfast){
+       struct r1conf *conf = mddev->private;
+       unsigned long flags;
+
+       spin_lock_irqsave(&conf->new_lock_for_md_error, flags);
+       if (failfast)
+               set_bit(FailfastIOFailure, &rdev->flags);
+       md_error(mddev, rdev);
+       if (failfast)
+               WARN_ON(!test_and_clear_bit(FailfastIOFailure, &rdev->flags));
+       spin_unlock_irqrestore(&conf->new_lock_for_md_error, flags);
+}
+
+static void raid1_md_error(struct mddev *mddev, struct md_rdev *rdev){
+       return _raid1_md_error(mddev, rdev, false);
+}
+
+static void raid1_md_error_failfast(struct mddev *mddev, struct md_rdev *rdev){
+       return _raid1_md_error(mddev, rdev, true);
+}
+
 /**
  * raid1_error() - RAID1 error handler.
  * @mddev: affected md device.
@@ -1758,6 +1783,13 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)

        if (test_bit(In_sync, &rdev->flags) &&
            (conf->raid_disks - mddev->degraded) == 1) {
+               if (test_bit(FailfastIOFailure, &rdev->flags)) {
+                       spin_unlock_irqrestore(&conf->device_lock, flags);
+                       pr_warn_ratelimited("md/raid1:%s: Failfast IO failure on %pg, "
+                               "last device but ignoring it\n",
+                               mdname(mddev), rdev->bdev);
+                       return;
+               }
                set_bit(MD_BROKEN, &mddev->flags);

                if (!mddev->fail_last_dev) {
@@ -1767,8 +1799,16 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
                }
        }
        set_bit(Blocked, &rdev->flags);
-       if (test_and_clear_bit(In_sync, &rdev->flags))
+       if (test_and_clear_bit(In_sync, &rdev->flags)) {
                mddev->degraded++;
+               clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
+               for (i = 0; i < conf->raid_disks; i++) {
+                       struct md_rdev *rdev2 = conf->mirrors[i].rdev;
+                       if (rdev2 && rdev != rdev2 &&
+                           test_bit(In_sync, &rdev2->flags))
+                               set_bit(LastDev, &rdev2->flags);
+               }
+       }
        set_bit(Faulty, &rdev->flags);
        spin_unlock_irqrestore(&conf->device_lock, flags);
        /*
@@ -2118,7 +2158,7 @@ static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
        }
        /* need to record an error - either for the block or the device */
        if (!rdev_set_badblocks(rdev, sector, sectors, 0))
-               md_error(rdev->mddev, rdev);
+               raid1_md_error(rdev->mddev, rdev);
        return 0;
 }
...


Thanks,
Akagi

> @@ -2630,7 +2627,6 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>          */
> 
>         bio = r1_bio->bios[r1_bio->read_disk];
> -       bio_put(bio);
>         r1_bio->bios[r1_bio->read_disk] = NULL;
> 
>         rdev = conf->mirrors[r1_bio->read_disk].rdev;
> @@ -2639,19 +2635,18 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>                 freeze_array(conf, 1);
>                 fix_read_error(conf, r1_bio);
>                 unfreeze_array(conf);
> -       } else if (mddev->ro == 0 && test_bit(FailFast, &rdev->flags)) {
> -               md_error(mddev, rdev);
> -       } else {
> +       } else if (mddev->ro == 0 &&
> +                  !md_bio_failure_error(mddev, rdev, bio)) {
>                 r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
>         }
> 
> +       bio_put(bio);
>         rdev_dec_pending(rdev, conf->mddev);
>         sector = r1_bio->sector;
> -       bio = r1_bio->master_bio;
> 
>         /* Reuse the old r1_bio so that the IO_BLOCKED settings are preserved */
>         r1_bio->state = 0;
> -       raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
> +       raid1_read_request(mddev, r1_bio->maxter_bio, r1_bio->sectors, r1_bio);
>         allow_barrier(conf, sector);
>  }
> 
> 
>>   /* seq_file implementation /proc/mdstat */
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 51af29a03079..6ca1aea630ce 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -758,3 +758,3 @@ struct md_personality
>>           */
>> -       void (*error_handler)(struct mddev *mddev, struct md_rdev *rdev);
>> +       void (*error_handler)(struct mddev *mddev, struct md_rdev *rdev, bool nofail);
>>          int (*hot_add_disk) (struct mddev *mddev, struct md_rdev *rdev);
>> @@ -903,3 +903,5 @@ extern void md_write_end(struct mddev *mddev);
>>   extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
>> +void _md_error(struct mddev *mddev, struct md_rdev *rdev, bool nofail);
>>   extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
>> +extern void md_error_failfast(struct mddev *mddev, struct md_rdev *rdev);
>>   extern void md_finish_reshape(struct mddev *mddev);
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index f1d8811a542a..8aea51227a96 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -637,3 +637,4 @@ static void raid0_status(struct seq_file *seq, struct mddev *mddev)
>>
>> -static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
>> +static void raid0_error(struct mddev *mddev, struct md_rdev *rdev,
>> +       bool nofail __maybe_unused)
>>   {
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 408c26398321..d93275899e9e 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1739,2 +1739,3 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>>    * @rdev: member device to fail.
>> + * @nofail: @mdev and @rdev must not fail even if @rdev is the last when @nofail set
>>    *
>> @@ -1748,6 +1749,8 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>>    *
>> - * @rdev is marked as &Faulty excluding case when array is failed and
>> - * &mddev->fail_last_dev is off.
>> + * @rdev is marked as &Faulty excluding any cases:
>> + *     - when @mddev is failed and &mddev->fail_last_dev is off
>> + *     - when @rdev is last device and @nofail is true
>>    */
>> -static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>> +static void raid1_error(struct mddev *mddev, struct md_rdev *rdev,
>> +       bool nofail)
>>   {
>> @@ -1760,2 +1763,9 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>              (conf->raid_disks - mddev->degraded) == 1) {
>> +               if (nofail) {
>> +                       spin_unlock_irqrestore(&conf->device_lock, flags);
>> +                       pr_warn_ratelimited("md/raid1:%s: IO failure on %pg, "
>> +                               "last device but ignoring it\n",
>> +                               mdname(mddev), rdev->bdev);
>> +                       return;
>> +               }
>>                  set_bit(MD_BROKEN, &mddev->flags);
>> ...
>>
>>> Kuai, do you have any suggestions?
>>>
>>>>> Normal writes may call md_error() in narrow_write_error. Normal reads do
>>>>> not execute md_error() on the last disk.
>>>>>
>>>>> Perhaps you should get more information to confirm how MD_BROKEN is set in
>>>>> normal read/write IO.
>>>>
>>>> Should I add the above sequence of events to the cover letter, or commit message?
>>>>
>>>
>>> I think we should mention this in the commit message.
>>
>> Understood. I will explicitly describe this in the commit message in v4.
>>
>> Thanks,
>> Akagi
>>
>>>> Thanks,
>>>> Akagi
>>>>
>>>>> -- 
>>>>> Thanks,
>>>>> Nan
>>>>>
>>>>>
>>>>
>>>>
>>>> .
>>>
>>> -- 
>>> Thanks,
>>> Nan
>>>
>>>
>>
>> .
>>
> 
> 

