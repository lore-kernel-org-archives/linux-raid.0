Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A74C001DE
	for <linux-raid@archiver.kernel.org>; Mon,  7 Aug 2023 02:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjHGCqM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Aug 2023 22:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjHGCqM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Aug 2023 22:46:12 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B80E6A
        for <linux-raid@vger.kernel.org>; Sun,  6 Aug 2023 19:46:09 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RK10Y1cPpz4f3m7t
        for <linux-raid@vger.kernel.org>; Mon,  7 Aug 2023 10:46:05 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgA3xqjqWtBkiKp4AA--.11608S3;
        Mon, 07 Aug 2023 10:46:04 +0800 (CST)
Subject: Re: NULL pointer dereference with MD write-back journal, where
 journal device is RAID-1
To:     Yu Kuai <yukuai1@huaweicloud.com>,
        Corey Hickey <bugfood-ml@fatooh.org>,
        'Linux RAID' <linux-raid@vger.kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <7c57f3a8-36e9-4805-b1ea-a4fd3406f7bb@fatooh.org>
 <f8b858cc-8762-6b53-43ec-7f509a971f16@huaweicloud.com>
 <428ed674-6e8c-471b-93d7-0532549fb218@fatooh.org>
 <d7cf0981-2d7c-5285-ce63-a66caf97e1db@huaweicloud.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Cc:     "yangerkun@huawei.com" <yangerkun@huawei.com>
Message-ID: <91d3a3b8-572e-b674-9dc2-c2a7af3b9806@huaweicloud.com>
Date:   Mon, 7 Aug 2023 10:46:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d7cf0981-2d7c-5285-ce63-a66caf97e1db@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgA3xqjqWtBkiKp4AA--.11608S3
X-Coremail-Antispam: 1UD129KBjvJXoW3ArWfJw4kGFWDurWUZw4rGrg_yoW7uFWrpF
        93W3Z3GF48W3sYyw4qkw1jyr9xJw1xCw1xXa9Fgw1rZr4jvr1xJwsxWayrW3sFq3y8KFyj
        qwn8ZrWDtF1jyw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUywZ
        7UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/08/07 10:15, Yu Kuai 写道:
> Hi,
> 
> 在 2023/08/07 10:09, Corey Hickey 写道:
>> On 2023-08-06 18:02, Yu Kuai wrote:
>>>> Here are the errors reported by the kernel:
>>>> --------------------------------------------------------------------
>>>> [ 2566.222104] BUG: kernel NULL pointer dereference, address:
>>>> 0000000000000157
>>>> [ 2566.222111] #PF: supervisor read access in kernel mode
>>>> [ 2566.222114] #PF: error_code(0x0000) - not-present page
>>>> [ 2566.222117] PGD 0 P4D 0
>>>> [ 2566.222121] Oops: 0000 [#1] PREEMPT SMP NOPTI
>>>> [ 2566.222125] CPU: 1 PID: 5415 Comm: md10_raid5 Not tainted 6.4.8 #3
>>>> [ 2566.222129] Hardware name: ASUS System Product Name/ROG CROSSHAIR 
>>>> VII
>>>> HERO (WI-FI), BIOS 4603 09/13/2021
>>>> [ 2566.222132] RIP: 0010:submit_bio_noacct+0x182/0x5c0
>>>
>>> Can you provide addr2line result? This will be helpful to locate the
>>> problem.
>>
>> I have not done this before; I struggled a bit until I found this:
>> https://lwn.net/Articles/592724/
>>
>> These are run within the kernel source tree, which I have not
>> modified since the original compilation.
>>
>>
>> $ scripts/decode_stacktrace.sh vmlinux < /tmp/trace1
>> [ 2566.222171] ? __die (arch/x86/kernel/dumpstack.c:421 
>> arch/x86/kernel/dumpstack.c:434)
>> [ 2566.222176] ? page_fault_oops (arch/x86/mm/fault.c:707)
>> [ 2566.222180] ? update_load_avg (kernel/sched/fair.c:3920 
>> kernel/sched/fair.c:4255)
>> [ 2566.222185] ? exc_page_fault (./arch/x86/include/asm/paravirt.h:695 
>> arch/x86/mm/fault.c:1494 arch/x86/mm/fault.c:1542)
>> [ 2566.222190] ? asm_exc_page_fault 
>> (./arch/x86/include/asm/idtentry.h:570)
>> [ 2566.222196] ? submit_bio_noacct (block/blk-throttle.h:198 
>> block/blk-throttle.h:210 block/blk-core.c:800)
>> [ 2566.222201] handle_active_stripes.isra.0 (drivers/md/raid5.c:6709 
>> (discriminator 1)) raid456

I'm not sure yet where is this io come from, however, based on your
test, I think this is from

raid5d
  handle_active_stripes
   r5l_flush_stripe_to_raid
    submit_bio

And I found a problem after a quick look here:

t1: submit flush io
raid5d
  handle_active_stripes
   r5l_flush_stripe_to_raid
    bio_init
    submit_bio
    // io1

t2: io1 is done
r5l_log_flush_endio
  list_splice_tail_init
  // new flush io can be dispatched

			t3: submit new flush io
			...
			r5l_flush_stripe_to_raid
			 bio_init
  bio_uninit
  // clear bio->bi_blkg
			 submit_bio
			 // null-ptr-deref

This is definitly a problem, however, I'm not sure if this is your case,
can you test the following patch?

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 51a68fbc241c..a85ea19fcf14 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1266,9 +1266,8 @@ static void r5l_log_flush_endio(struct bio *bio)
         list_for_each_entry(io, &log->flushing_ios, log_sibling)
                 r5l_io_run_stripes(io);
         list_splice_tail_init(&log->flushing_ios, &log->finished_ios);
-       spin_unlock_irqrestore(&log->io_list_lock, flags);
-
         bio_uninit(bio);
+       spin_unlock_irqrestore(&log->io_list_lock, flags);
  }

  /*

Thanks,
Kuai
>> [ 2566.222220] raid5d (drivers/md/raid5.c:6821) raid456
>> [ 2566.222234] ? __schedule (kernel/sched/core.c:6677)
>> [ 2566.222240] ? _raw_spin_lock_irqsave 
>> (./arch/x86/include/asm/atomic.h:202 (discriminator 4) 
>> ./include/linux/atomic/atomic-instrumented.h:543 (discriminator 4) 
>> ./include/asm-generic/qspinlock.h:111 (discriminator 4) 
>> ./include/linux/spinlock.h:186 (discriminator 4) 
>> ./include/linux/spinlock_api_smp.h:111 (discriminator 4) 
>> kernel/locking/spinlock.c:162 (discriminator 4))
>> [ 2566.222245] ? preempt_count_add (./include/linux/ftrace.h:976 
>> kernel/sched/core.c:5793 kernel/sched/core.c:5790 
>> kernel/sched/core.c:5818)
>> [ 2566.222248] ? _raw_spin_lock_irqsave 
>> (./arch/x86/include/asm/atomic.h:202 (discriminator 4) 
>> ./include/linux/atomic/atomic-instrumented.h:543 (discriminator 4) 
>> ./include/asm-generic/qspinlock.h:111 (discriminator 4) 
>> ./include/linux/spinlock.h:186 (discriminator 4) 
>> ./include/linux/spinlock_api_smp.h:111 (discriminator 4) 
>> kernel/locking/spinlock.c:162 (discriminator 4))
>> [ 2566.222254] ? __pfx_md_thread (drivers/md/md.c:7862) md_mod
>> [ 2566.222273] md_thread (drivers/md/md.c:7898) md_mod
>> [ 2566.222293] ? __pfx_autoremove_wake_function (kernel/sched/wait.c:418)
>> [ 2566.222299] kthread (kernel/kthread.c:379)
>> [ 2566.222304] ? __pfx_kthread (kernel/kthread.c:332)
>> [ 2566.222309] ret_from_fork (arch/x86/entry/entry_64.S:314)
>>
>>
>>
>> $ scripts/decode_stacktrace.sh vmlinux < /tmp/trace2
>> [ 2566.436288] ? do_exit (kernel/exit.c:818 (discriminator 1))
>> [ 2566.436292] ? __warn (kernel/panic.c:673)
>> [ 2566.436298] ? do_exit (kernel/exit.c:818 (discriminator 1))
>> [ 2566.436301] ? report_bug (lib/bug.c:180 lib/bug.c:219)
>> [ 2566.436308] ? handle_bug (arch/x86/kernel/traps.c:303)
>> [ 2566.436312] ? exc_invalid_op (arch/x86/kernel/traps.c:345 
>> (discriminator 1))
>> [ 2566.436316] ? asm_exc_invalid_op 
>> (./arch/x86/include/asm/idtentry.h:568)
>> [ 2566.436321] ? do_exit (kernel/exit.c:818 (discriminator 1))
>> [ 2566.436325] ? do_exit (kernel/exit.c:818 (discriminator 1))
>> [ 2566.436329] make_task_dead (kernel/exit.c:972)
>> [ 2566.436333] rewind_stack_and_make_dead (??:?)
>>
>>
>>
>> Is that what you are looking for?
> 
> Yes, and can you provide witch commit are you testing?
> 
> Thanks,
> Kuai
>>
>> Thanks,
>> Corey
>> .
>>
> 
> .
> 

