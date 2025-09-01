Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2A41DEFDD
	for <linux-raid@vger.kernel.org>; Mon,  1 Sep 2025 04:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756700609; cv=none; b=Q0n2NxC7QLlE5w9wpvmVIqperv2Ij+sz2jGdS4FcTxL/82c/iCKbsvEUXTghKPYS28jhlzHAKDNNCi2qrflwYcDNU2mpK+Kf06E8tffYTKjnwfjqOAAg1WhJFdN4V7aBoyrFgO1Eld4j+WqWdCK6o2zhHY31iEqSIe+NYMevS0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756700609; c=relaxed/simple;
	bh=ZF8XrkERlK6k6G+ZcHFn5gwuUK3mqlrkRJO8upg0oqY=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NpbGRvH3qaYXs3D4sPH5uUjKGJCkZM9LCTt1EwLePG1h+TqDhXKRl+mjnLaSorki+nZU07G/4ataoKQDDARbQduehCkrnoXSI658glpdz7AQsVnEysAjjsnCjIK1shJfChp5g0FIfiPU0EnV3WoJzemu2Q6SZZ/0hjBRqI79SLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=oaBSYFm7; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="oaBSYFm7"
Received: from NEET (p4246180-ipxg00p01tokaisakaetozai.aichi.ocn.ne.jp [118.15.79.180])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 5814MfFD050581
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 1 Sep 2025 13:22:41 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=D0vXyYDp4P+WBuZAVssT7SZjaNm4rEG6WhmOFW17gQA=;
        c=relaxed/relaxed; d=mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250315; t=1756700561; v=1;
        b=oaBSYFm7f2HPXZwJH/2O7im0kshLqFQ9/g8zn4aS9gch5cKx6iUUe43HhFzOSQQo
         9GvQZTOTWge8CtnXRX9N8t+Nt/msPKxYOmIt0oD8y7kdn7/mxdLPuYaKE/XLZ783
         C6ONGjZNJGG3i4dR9T4euQQSpfh4WbyKZ1AgTH8nXI9ZYLn4aRkFZKzaxmi0Tl8U
         UYdwBPuz3pzNcJiDlapcfGkBHmTRNwxxMTjBNJWWwAWZ67farv5JJ98trtoUgRLh
         bMB/IvcWuqyaXbMtzGMkLb3OBHjkjZEGGx4JZ3FJTZu16JgxYh1Q/RrE3O162XOW
         ofXVcLZ/VtBsWJz+SkP1gQ==
Message-ID: <7e268dff-4f29-4155-8644-45be74d4c465@mgml.me>
Date: Mon, 1 Sep 2025 13:22:40 +0900
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
 <29e337bc-9eee-4794-ae1e-184ef91b9d24@mgml.me>
 <6edb5e2c-3f36-dc2c-3b41-9bf0e8ebb263@huaweicloud.com>
Content-Language: en-US
From: Kenta Akagi <k@mgml.me>
In-Reply-To: <6edb5e2c-3f36-dc2c-3b41-9bf0e8ebb263@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/09/01 12:22, Li Nan wrote:
> 
> 
> 在 2025/8/31 2:10, Kenta Akagi 写道:
>>
>>
>> On 2025/08/30 17:48, Li Nan wrote:
>>>
>>>
>>> 在 2025/8/29 20:21, Kenta Akagi 写道:
>>>>
>>>>
>>>> On 2025/08/29 11:54, Li Nan wrote:
>>>>>
>>>>> 在 2025/8/29 0:32, Kenta Akagi 写道:
>>>>>> This commit ensures that an MD_FAILFAST IO failure does not put
>>>>>> the array into a broken state.
>>>>>>
>>>>>> When failfast is enabled on rdev in RAID1 or RAID10,
>>>>>> the array may be flagged MD_BROKEN in the following cases.
>>>>>> - If MD_FAILFAST IOs to multiple rdevs fail simultaneously
>>>>>> - If an MD_FAILFAST metadata write to the 'last' rdev fails
>>>>>
>>>>> [...]
>>>>>
>>>>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>>>>> index 408c26398321..8a61fd93b3ff 100644
>>>>>> --- a/drivers/md/raid1.c
>>>>>> +++ b/drivers/md/raid1.c
>>>>>> @@ -470,6 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
>>>>>>                 (bio->bi_opf & MD_FAILFAST) &&
>>>>>>                 /* We never try FailFast to WriteMostly devices */
>>>>>>                 !test_bit(WriteMostly, &rdev->flags)) {
>>>>>> +            set_bit(FailfastIOFailure, &rdev->flags);
>>>>>>                 md_error(r1_bio->mddev, rdev);
>>>>>>             }
>>>>>>     @@ -1746,8 +1747,12 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>>>>>>      *    - recovery is interrupted.
>>>>>>      *    - &mddev->degraded is bumped.
>>>>>>      *
>>>>>> - * @rdev is marked as &Faulty excluding case when array is failed and
>>>>>> - * &mddev->fail_last_dev is off.
>>>>>> + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
>>>>>> + * then @mddev and @rdev will not be marked as failed.
>>>>>> + *
>>>>>> + * @rdev is marked as &Faulty excluding any cases:
>>>>>> + *    - when @mddev is failed and &mddev->fail_last_dev is off
>>>>>> + *    - when @rdev is last device and &FailfastIOFailure flag is set
>>>>>>      */
>>>>>>     static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>>>>>     {
>>>>>> @@ -1758,6 +1763,13 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>>>>>           if (test_bit(In_sync, &rdev->flags) &&
>>>>>>             (conf->raid_disks - mddev->degraded) == 1) {
>>>>>> +        if (test_and_clear_bit(FailfastIOFailure, &rdev->flags)) {
>>>>>> +            spin_unlock_irqrestore(&conf->device_lock, flags);
>>>>>> +            pr_warn_ratelimited("md/raid1:%s: Failfast IO failure on %pg, "
>>>>>> +                "last device but ignoring it\n",
>>>>>> +                mdname(mddev), rdev->bdev);
>>>>>> +            return;
>>>>>> +        }
>>>>>>             set_bit(MD_BROKEN, &mddev->flags);
>>>>>>               if (!mddev->fail_last_dev) {
>>>>>> @@ -2148,6 +2160,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>>>>>>         if (test_bit(FailFast, &rdev->flags)) {
>>>>>>             /* Don't try recovering from here - just fail it
>>>>>>              * ... unless it is the last working device of course */
>>>>>> +        set_bit(FailfastIOFailure, &rdev->flags);
>>>>>>             md_error(mddev, rdev);
>>>>>>             if (test_bit(Faulty, &rdev->flags))
>>>>>>                 /* Don't try to read from here, but make sure
>>>>>> @@ -2652,6 +2665,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>>>>>>             fix_read_error(conf, r1_bio);
>>>>>>             unfreeze_array(conf);
>>>>>>         } else if (mddev->ro == 0 && test_bit(FailFast, &rdev->flags)) {
>>>>>> +        set_bit(FailfastIOFailure, &rdev->flags);
>>>>>>             md_error(mddev, rdev);
>>>>>>         } else {
>>>>>>             r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
>>>>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>>>>> index b60c30bfb6c7..530ad6503189 100644
>>>>>> --- a/drivers/md/raid10.c
>>>>>> +++ b/drivers/md/raid10.c
>>>>>> @@ -488,6 +488,7 @@ static void raid10_end_write_request(struct bio *bio)
>>>>>>                 dec_rdev = 0;
>>>>>>                 if (test_bit(FailFast, &rdev->flags) &&
>>>>>>                     (bio->bi_opf & MD_FAILFAST)) {
>>>>>> +                set_bit(FailfastIOFailure, &rdev->flags);
>>>>>>                     md_error(rdev->mddev, rdev);
>>>>>>                 }
>>>>>>     
>>>>>
>>>>> Thank you for the patch. There may be an issue with 'test_and_clear'.
>>>>>
>>>>> If two write IO go to the same rdev, MD_BROKEN may be set as below:
>>>>
>>>>> IO1                    IO2
>>>>> set FailfastIOFailure
>>>>>                       set FailfastIOFailure
>>>>>    md_error
>>>>>     raid1_error
>>>>>      test_and_clear FailfastIOFailur
>>>>>                          md_error
>>>>>                         raid1_error
>>>>>                          //FailfastIOFailur is cleared
>>>>>                          set MD_BROKEN
>>>>>
>>>>> Maybe we should check whether FailfastIOFailure is already set before
>>>>> setting it. It also needs to be considered in metadata writes.
>>>> Thank you for reviewing.
>>>>
>>>> I agree, this seems to be as you described.
>>>> So, should it be implemented as follows?
>>>>
>>>> bool old=false;
>>>> do{
>>>>    spin_lock_irqsave(&conf->device_lock, flags);
>>>>    old = test_and_set_bit(FailfastIOFailure, &rdev->flags);
>>>>    spin_unlock_irqrestore(&conf->device_lock, flags);
>>>> }while(old);
>>>>
>>>> However, since I am concerned about potential deadlocks,
>>>> so I am considering two alternative approaches:
>>>>
>>>> * Add an atomic_t counter to md_rdev to track failfast IO failures.
>>>>
>>>> This may set MD_BROKEN at a slightly incorrect timing, but mixing
>>>> error handling of Failfast and non-Failfast IOs appears to be rare.
>>>> In any case, the final outcome would be the same, i.e. the array
>>>> ends up with MD_BROKEN. Therefore, I think this should not cause
>>>> issues. I think the same applies to test_and_set_bit.
>>>>
>>>> IO1                    IO2                    IO3
>>>> FailfastIOFailure      Normal IOFailure       FailfastIOFailure
>>>> atomic_inc
>>>>                                                   md_error                                     atomic_inc
>>>>     raid1_error
>>>>      atomic_dec //2to1
>>>>                          md_error
>>>>                           raid1_error           md_error
>>>>                            atomic_dec //1to0     raid1_error
>>>>                                                   atomic_dec //0
>>>>                                                     set MD_BROKEN
>>>>
>>>> * Alternatively, create a separate error handler,
>>>>     e.g. md_error_failfast(), that clearly does not fail the array.
>>>>
>>>> This approach would require somewhat larger changes and may not
>>>> be very elegant, but it seems to be a reliable way to ensure
>>>> MD_BROKEN is never set at the wrong timing.
>>>>
>>>> Which of these three approaches would you consider preferable?
>>>> I would appreciate your feedback.
>>>>
>>>>
>>>> For metadata writes, I plan to clear_bit MD_FAILFAST_SUPPORTED
>>>> when the array is degraded.
>>>>
>>>> Thanks,
>>>> Akagi
>>>>
>>>
>>> I took a closer look at the FailFast code and found a few issues, using
>>> RAID1 as an example:
>>>
>>> For normal read/write IO, FailFast is only triggered when there is another
>>> disk is available, as seen in read_balance() and raid1_write_request().
>>> In raid1_error(), MD_BROKEN is set only when no other disks are available.
>>
>> Hi,
>> Agree, I think so too.
>>
>>> So, the FailFast for normal read/write is not triggered in the scenario you
>>> described in cover-letter.
>>
>> This corresponds to the case described in the commit message of PATCH v3 1/3.
>> "Normally, MD_FAILFAST IOs are not issued to the 'last' rdev, so this is
>> an edge case; however, it can occur if rdevs in a non-degraded
>> array share the same path and that path is lost, or if a metadata
>> write is triggered in a degraded array and fails due to failfast."
>>
>> To describe it in more detail, the flow is as follows:
>>
>> Prerequisites:
>>
>> - Both rdevs are in-sync
>> - Both rdevs have in-flight MD_FAILFAST bios
>> - Both rdevs depend on the same lower-level path
>>    (e.g., nvme-tcp over a single Ethernet interface)
>>
>> Sequence:
>>
>> - A bios with REQ_FAILFAST_DEV fails (e.g., due to a temporary network outage),
>>    in the case of nvme-tcp:
>>     - The Ethernet connection is lost on the node where md is running over 5 seconds
>>     - Then the connection is restored. Idk the details of nvme-tcp implementation,
>>       but it seems that failfast IOs finish only after the connection is back.
>> - All failfast bios fail, raid1_end_write_request is called.
>> - md_error() marks one rdev Faulty; the other rdev becomes the 'last' rdev.
>> - md_error() on the last rdev sets MD_BROKEN on the array - fail_last_dev=1 is unlikely.
>> - The write is retried via handle_write_finished -> narrow_write_error, usually succeeding.
>> - MD_BROKEN remains set, leaving the array in a state where no further writes can occur.
>>
> 
> Thanks for your patient explanation. I understand. Maybe we need a separate
> error-handling path for failfast. How about adding an extra parameter to md_error()?

Thank you for reviewing.

I am thinking of proceeding like as follows.
md_error is EXPORT_SYMBOL. I think that it is undesirable to change the ABI of this function.

...
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac85ec73a409..855cddeb0c09 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8197,3 +8197,3 @@ EXPORT_SYMBOL(md_unregister_thread);

-void md_error(struct mddev *mddev, struct md_rdev *rdev)
+void _md_error(struct mddev *mddev, struct md_rdev *rdev, bool nofail)
 {
@@ -8204,3 +8204,3 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
                return;
-       mddev->pers->error_handler(mddev, rdev);
+       mddev->pers->error_handler(mddev, rdev, nofail);

@@ -8222,4 +8222,26 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 }
+
+void md_error(struct mddev *mddev, struct md_rdev *rdev)
+{
+       return _md_error(mddev, rdev, false);
+}
 EXPORT_SYMBOL(md_error);

+void md_error_failfast(struct mddev *mddev, struct md_rdev *rdev)
+{
+       WARN_ON(mddev->pers->head.id != ID_RAID1 &&
+               mddev->pers->head.id != ID_RAID10);
+       return _md_error(mddev, rdev, true);
+}
+EXPORT_SYMBOL(md_error_failfast);
+
 /* seq_file implementation /proc/mdstat */
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 51af29a03079..6ca1aea630ce 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -758,3 +758,3 @@ struct md_personality
         */
-       void (*error_handler)(struct mddev *mddev, struct md_rdev *rdev);
+       void (*error_handler)(struct mddev *mddev, struct md_rdev *rdev, bool nofail);
        int (*hot_add_disk) (struct mddev *mddev, struct md_rdev *rdev);
@@ -903,3 +903,5 @@ extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
+void _md_error(struct mddev *mddev, struct md_rdev *rdev, bool nofail);
 extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
+extern void md_error_failfast(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_finish_reshape(struct mddev *mddev);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f1d8811a542a..8aea51227a96 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -637,3 +637,4 @@ static void raid0_status(struct seq_file *seq, struct mddev *mddev)

-static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
+static void raid0_error(struct mddev *mddev, struct md_rdev *rdev,
+       bool nofail __maybe_unused)
 {
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 408c26398321..d93275899e9e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1739,2 +1739,3 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
  * @rdev: member device to fail.
+ * @nofail: @mdev and @rdev must not fail even if @rdev is the last when @nofail set
  *
@@ -1748,6 +1749,8 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
  *
- * @rdev is marked as &Faulty excluding case when array is failed and
- * &mddev->fail_last_dev is off.
+ * @rdev is marked as &Faulty excluding any cases:
+ *     - when @mddev is failed and &mddev->fail_last_dev is off
+ *     - when @rdev is last device and @nofail is true
  */
-static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
+static void raid1_error(struct mddev *mddev, struct md_rdev *rdev,
+       bool nofail)
 {
@@ -1760,2 +1763,9 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
            (conf->raid_disks - mddev->degraded) == 1) {
+               if (nofail) {
+                       spin_unlock_irqrestore(&conf->device_lock, flags);
+                       pr_warn_ratelimited("md/raid1:%s: IO failure on %pg, "
+                               "last device but ignoring it\n",
+                               mdname(mddev), rdev->bdev);
+                       return;
+               }
                set_bit(MD_BROKEN, &mddev->flags);
...

> Kuai, do you have any suggestions?
> 
>>> Normal writes may call md_error() in narrow_write_error. Normal reads do
>>> not execute md_error() on the last disk.
>>>
>>> Perhaps you should get more information to confirm how MD_BROKEN is set in
>>> normal read/write IO.
>>
>> Should I add the above sequence of events to the cover letter, or commit message?
>>
> 
> I think we should mention this in the commit message.

Understood. I will explicitly describe this in the commit message in v4.

Thanks,
Akagi

>> Thanks,
>> Akagi
>>
>>> -- 
>>> Thanks,
>>> Nan
>>>
>>>
>>
>>
>> .
> 
> -- 
> Thanks,
> Nan
> 
> 

