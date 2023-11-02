Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EB4C4332F
	for <linux-raid@archiver.kernel.org>; Thu,  2 Nov 2023 07:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbjKBHQj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Nov 2023 03:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjKBHQi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Nov 2023 03:16:38 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE50812A
        for <linux-raid@vger.kernel.org>; Thu,  2 Nov 2023 00:16:33 -0700 (PDT)
Received: from mail.maildlp.com (unknown [172.19.93.142])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4SLZtJ0PMNz4f3kF6
        for <linux-raid@vger.kernel.org>; Thu,  2 Nov 2023 15:16:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
        by mail.maildlp.com (Postfix) with ESMTP id 449DD1A0171
        for <linux-raid@vger.kernel.org>; Thu,  2 Nov 2023 15:16:30 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgB3Dt7MTENl2LN1Eg--.33088S3;
        Thu, 02 Nov 2023 15:16:30 +0800 (CST)
Subject: Re: [RFC] md/raid5: fix hung by MD_SB_CHANGE_PENDING
To:     junxiao.bi@oracle.com, Yu Kuai <yukuai1@huaweicloud.com>,
        linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231101230214.57190-1-junxiao.bi@oracle.com>
 <6183bbd0-09c2-3629-ed93-a7485c13e6bb@huaweicloud.com>
 <434b8632-0ec3-4b73-8146-94371a3563bb@oracle.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <50024c2c-c807-3471-191d-40e0cad9db89@huaweicloud.com>
Date:   Thu, 2 Nov 2023 15:16:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <434b8632-0ec3-4b73-8146-94371a3563bb@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgB3Dt7MTENl2LN1Eg--.33088S3
X-Coremail-Antispam: 1UD129KBjvJXoW3WFyUZw4UZw4xGF47KFW7urg_yoWxZFW7p3
        ykJFWYqFyUuryvqr10yr1rXrWFvr1UJ3WDXryUJF1xJan7KrySqFyUXryjgr1DZr48Ar43
        Jwn8J39rur1UtrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/11/02 12:32, junxiao.bi@oracle.com 写道:
> On 11/1/23 6:24 PM, Yu Kuai wrote:
> 
>> Hi,
>>
>> 在 2023/11/02 7:02, Junxiao Bi 写道:
>>> Looks like there is a race between md_write_start() and raid5d() which
>>
>> Is this a real issue or just based on code review?
> 
> It's a real issue, we see this hung in a production system, it's with 
> v5.4, but i didn't see these function has much difference.
> 
> crash> bt 2683
> PID: 2683     TASK: ffff9d3b3e651f00  CPU: 65   COMMAND: "md0_raid5"
>   #0 [ffffbd7a0252bd08] __schedule at ffffffffa8e68931
>   #1 [ffffbd7a0252bd88] schedule at ffffffffa8e68c6f
>   #2 [ffffbd7a0252bda8] raid5d at ffffffffc0b4df16 [raid456]
>   #3 [ffffbd7a0252bea0] md_thread at ffffffffa8bc20b8
>   #4 [ffffbd7a0252bf08] kthread at ffffffffa84dac05
>   #5 [ffffbd7a0252bf50] ret_from_fork at ffffffffa9000364
> crash> ps -m 2683
> [ 0 00:11:08.244] [UN]  PID: 2683     TASK: ffff9d3b3e651f00  CPU: 65 
> COMMAND: "md0_raid5"
> crash>
> crash> bt 96352
> PID: 96352    TASK: ffff9cc587c95d00  CPU: 64   COMMAND: "kworker/64:0"
>   #0 [ffffbd7a07533be0] __schedule at ffffffffa8e68931
>   #1 [ffffbd7a07533c60] schedule at ffffffffa8e68c6f
>   #2 [ffffbd7a07533c80] md_write_start at ffffffffa8bc47c5
>   #3 [ffffbd7a07533ce0] raid5_make_request at ffffffffc0b4a4c9 [raid456]
>   #4 [ffffbd7a07533dc8] md_handle_request at ffffffffa8bbfa54
>   #5 [ffffbd7a07533e38] md_submit_flush_data at ffffffffa8bc04c1
>   #6 [ffffbd7a07533e60] process_one_work at ffffffffa84d4289
>   #7 [ffffbd7a07533ea8] worker_thread at ffffffffa84d50cf
>   #8 [ffffbd7a07533f08] kthread at ffffffffa84dac05
>   #9 [ffffbd7a07533f50] ret_from_fork at ffffffffa9000364
> crash> ps -m 96352
> [ 0 00:11:08.244] [UN]  PID: 96352    TASK: ffff9cc587c95d00  CPU: 64 
> COMMAND: "kworker/64:0"
> crash>
> crash> bt 25542
> PID: 25542    TASK: ffff9cb4cb528000  CPU: 32   COMMAND: "md0_resync"
>   #0 [ffffbd7a09387c80] __schedule at ffffffffa8e68931
>   #1 [ffffbd7a09387d00] schedule at ffffffffa8e68c6f
>   #2 [ffffbd7a09387d20] md_do_sync at ffffffffa8bc613e
>   #3 [ffffbd7a09387ea0] md_thread at ffffffffa8bc20b8
>   #4 [ffffbd7a09387f08] kthread at ffffffffa84dac05
>   #5 [ffffbd7a09387f50] ret_from_fork at ffffffffa9000364
> crash>
> crash> ps -m 25542
> [ 0 00:11:18.370] [UN]  PID: 25542    TASK: ffff9cb4cb528000  CPU: 32 
> COMMAND: "md0_resync"
> 
> 
>>> can cause deadlock. Run into this issue while raid_check is running.
>>>
>>> md_write_start: raid5d:
>>>   if (mddev->safemode == 1)
>>>       mddev->safemode = 0;
>>>   /* sync_checkers is always 0 when writes_pending is in per-cpu mode */
>>>   if (mddev->in_sync || mddev->sync_checkers) {
>>>       spin_lock(&mddev->lock);
>>>       if (mddev->in_sync) {
>>>           mddev->in_sync = 0;
>>>           set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
>>>           set_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
>>> >>> running before md_write_start wake up it
>>> if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
>>> spin_unlock_irq(&conf->device_lock);
>>> md_check_recovery(mddev);
>>> spin_lock_irq(&conf->device_lock);
>>>
>>> /*
>>> * Waiting on MD_SB_CHANGE_PENDING below may deadlock
>>> * seeing md_check_recovery() is needed to clear
>>> * the flag when using mdmon.
>>> */
>>> continue;
>>> }
>>>
>>> wait_event_lock_irq(mddev->sb_wait, >>>>>>>>>>> hung
>>> !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
>>> conf->device_lock);
>>>           md_wakeup_thread(mddev->thread);
>>>           did_change = 1;
>>>       }
>>>       spin_unlock(&mddev->lock);
>>>   }
>>>
>>>   ...
>>>
>>>   wait_event(mddev->sb_wait, >>>>>>>>>> hung
>>>      !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
>>>      mddev->suspended);
>>>
>>
>> This is not correct, if daemon thread is running, md_wakeup_thread()
>> will make sure that daemon thread will run again, see details how
>> THREAD_WAKEUP worked in md_thread().
> 
> The daemon thread was waiting MD_SB_CHANGE_PENDING to be cleared, even 
> wake up it, it will hung again as that flag is still not cleared?

I aggree that daemon thread should not use wait_event(), however, take a
look at 5e2cf333b7bd, I think this is a common issue for all
personalities, and the better fix is that let bio submitted from
md_write_super() bypass wbt, this is reasonable because wbt is used to
throttle backgroup writeback io, and writing superblock should not be
throttled by wbt.

Thanks,
Kuai

> 
> Thanks,
> 
> Junxiao.
> 
>>
>> Thanks,
>> Kuai
>>
>>> commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in 
>>> raid5d")
>>> introduced this issue, since it want to a reschedule for flushing 
>>> blk_plug,
>>> let do it explicitly to address that issue.
>>>
>>> Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in 
>>> raid5d")
>>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>>> ---
>>>   block/blk-core.c   | 1 +
>>>   drivers/md/raid5.c | 9 +++++----
>>>   2 files changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index 9d51e9894ece..bc8757a78477 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -1149,6 +1149,7 @@ void __blk_flush_plug(struct blk_plug *plug, 
>>> bool from_schedule)
>>>       if (unlikely(!rq_list_empty(plug->cached_rq)))
>>>           blk_mq_free_plug_rqs(plug);
>>>   }
>>> +EXPORT_SYMBOL(__blk_flush_plug);
>>>     /**
>>>    * blk_finish_plug - mark the end of a batch of submitted I/O
>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>> index 284cd71bcc68..25ec82f2813f 100644
>>> --- a/drivers/md/raid5.c
>>> +++ b/drivers/md/raid5.c
>>> @@ -6850,11 +6850,12 @@ static void raid5d(struct md_thread *thread)
>>>                * the flag when using mdmon.
>>>                */
>>>               continue;
>>> +        } else {
>>> +            spin_unlock_irq(&conf->device_lock);
>>> +            blk_flush_plug(current);
>>> +            cond_resched();
>>> +            spin_lock_irq(&conf->device_lock);
>>>           }
>>> -
>>> -        wait_event_lock_irq(mddev->sb_wait,
>>> -            !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
>>> -            conf->device_lock);
>>>       }
>>>       pr_debug("%d stripes handled\n", handled);
>>>
>>
> .
> 

