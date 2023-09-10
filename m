Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A80EEB57D
	for <linux-raid@archiver.kernel.org>; Sun, 10 Sep 2023 06:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346007AbjIJGLG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 10 Sep 2023 02:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjIJGLF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 10 Sep 2023 02:11:05 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75901B5;
        Sat,  9 Sep 2023 23:10:59 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RjzxB6QRyz4f3lDn;
        Sun, 10 Sep 2023 14:10:54 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBn+djuXf1kxHxjAA--.36463S3;
        Sun, 10 Sep 2023 14:10:56 +0800 (CST)
Subject: Re: Reshape Failure
To:     Jason Moss <phate408@gmail.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org,
        "yangerkun@huawei.com" <yangerkun@huawei.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CA+w1tCeQw5STTQAEoTHTcpT4s_nT0zdgGSce6n-CT24BbNmukA@mail.gmail.com>
 <afb56bef-4547-d7f1-d3c2-730b7d7658f2@huaweicloud.com>
 <CA+w1tCeZmqreX_HRrsGRqq9-MmjNyo6VAt6sDEQgpS2R4=DxoA@mail.gmail.com>
 <0ef44108-2a81-89df-c839-0c16d9499c29@huaweicloud.com>
 <CA+w1tCeUZET9KCcBWb89FXNjuvA-M25yCrkF5OqcdZXLQsAhxw@mail.gmail.com>
 <34e3f81e-4f7e-4a45-3690-f1a012df6d00@huaweicloud.com>
 <CA+w1tCcBBLWLLLWSywRzk2d+vF6OFkeeHoyM49v4oxHC4u--jA@mail.gmail.com>
 <79aa3cf3-78d4-cfc6-8d3b-eb8704ffaba1@huaweicloud.com>
 <CA+w1tCf0RriSXMGGKCK0J9wYhbwctEkDAAMVYtRGQ6fmJpUbXA@mail.gmail.com>
 <ee4d0dfe-a42c-1a84-73b1-2f5a8a78b428@huaweicloud.com>
 <CA+w1tCdtDF0PsMZxJ2=AeSaM2r6oQEujkKPSjMyNufefd5W82w@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e0a99704-98a1-a03d-b2b1-356bfd19f576@huaweicloud.com>
Date:   Sun, 10 Sep 2023 14:10:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+w1tCdtDF0PsMZxJ2=AeSaM2r6oQEujkKPSjMyNufefd5W82w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBn+djuXf1kxHxjAA--.36463S3
X-Coremail-Antispam: 1UD129KBjvJXoW3tr1rAw4fXr48uryrtrykuFg_yoWktw1kp3
        4UGFsrKwsrtF98AayIy34kua42q3WDJw1xWa4DZa4rKryvvr1fZw1DWFW5Ww4jqr45KayU
        Ww4rtrySqF4kJ3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
        r21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUU
        UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

[cc linux-block]
在 2023/09/10 12:58, Jason Moss 写道:
> Hi,
> 
> On Sat, Sep 9, 2023 at 7:45 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2023/09/07 14:19, Jason Moss 写道:
>>> Hi,
>>>
>>> On Wed, Sep 6, 2023 at 11:13 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>> 在 2023/09/07 13:44, Jason Moss 写道:
>>>>> Hi,
>>>>>
>>>>> On Wed, Sep 6, 2023 at 6:38 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> 在 2023/09/06 22:05, Jason Moss 写道:
>>>>>>> Hi Kuai,
>>>>>>>
>>>>>>> I ended up using gdb rather than addr2line, as that output didn't give
>>>>>>> me the global offset. Maybe there's a better way, but this seems to be
>>>>>>> similar to what I expected.
>>>>>>
>>>>>> It's ok.
>>>>>>>
>>>>>>> (gdb) list *(reshape_request+0x416)
>>>>>>> 0x11566 is in reshape_request (drivers/md/raid5.c:6396).
>>>>>>> 6391            if ((mddev->reshape_backwards
>>>>>>> 6392                 ? (safepos > writepos && readpos < writepos)
>>>>>>> 6393                 : (safepos < writepos && readpos > writepos)) ||
>>>>>>> 6394                time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
>>>>>>> 6395                    /* Cannot proceed until we've updated the
>>>>>>> superblock... */
>>>>>>> 6396                    wait_event(conf->wait_for_overlap,
>>>>>>> 6397                               atomic_read(&conf->reshape_stripes)==0
>>>>>>> 6398                               || test_bit(MD_RECOVERY_INTR,
>>>>>>
>>>>>> If reshape is stuck here, which means:
>>>>>>
>>>>>> 1) Either reshape io is stuck somewhere and never complete;
>>>>>> 2) Or the counter reshape_stripes is broken;
>>>>>>
>>>>>> Can you read following debugfs files to verify if io is stuck in
>>>>>> underlying disk?
>>>>>>
>>>>>> /sys/kernel/debug/block/[disk]/hctx*/{sched_tags,tags,busy,dispatch}
>>>>>>
>>>>>
>>>>> I'll attach this below.
>>>>>
>>>>>> Furthermore, echo frozen should break above wait_event() because
>>>>>> 'MD_RECOVERY_INTR' will be set, however, based on your description,
>>>>>> the problem still exist. Can you collect stack and addr2line result
>>>>>> of stuck thread after echo frozen?
>>>>>>
>>>>>
>>>>> I echo'd frozen to /sys/block/md0/md/sync_action, however the echo
>>>>> call has been sitting for about 30 minutes, maybe longer, and has not
>>>>> returned. Here's the current state:
>>>>>
>>>>> root         454  0.0  0.0      0     0 ?        I<   Sep05   0:00 [raid5wq]
>>>>> root         455  0.0  0.0  34680  5988 ?        D    Sep05   0:00 (udev-worker)
>>>>
>>>> Can you also show the stack of udev-worker? And any other thread with
>>>> 'D' state, I think above "echo frozen" is probably also stuck in D
>>>> state.
>>>>
>>>
>>> As requested:
>>>
>>> ps aux | grep D
>>> USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
>>> root         455  0.0  0.0  34680  5988 ?        D    Sep05   0:00 (udev-worker)
>>> root         457  0.0  0.0      0     0 ?        D    Sep05   0:00 [md0_reshape]
>>> root       45507  0.0  0.0   8272  4736 pts/1    Ds+  Sep05   0:00 -bash
>>> jason     279169  0.0  0.0   6976  2560 pts/0    S+   23:16   0:00
>>> grep --color=auto D
>>>
>>> [jason@arch md]$ sudo cat /proc/455/stack
>>> [<0>] wait_woken+0x54/0x60
>>> [<0>] raid5_make_request+0x5fe/0x12f0 [raid456]
>>> [<0>] md_handle_request+0x135/0x220 [md_mod]
>>> [<0>] __submit_bio+0xb3/0x170
>>> [<0>] submit_bio_noacct_nocheck+0x159/0x370
>>> [<0>] block_read_full_folio+0x21c/0x340
>>> [<0>] filemap_read_folio+0x40/0xd0
>>> [<0>] filemap_get_pages+0x475/0x630
>>> [<0>] filemap_read+0xd9/0x350
>>> [<0>] blkdev_read_iter+0x6b/0x1b0
>>> [<0>] vfs_read+0x201/0x350
>>> [<0>] ksys_read+0x6f/0xf0
>>> [<0>] do_syscall_64+0x60/0x90
>>> [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>>>
>>>
>>> [jason@arch md]$ sudo cat /proc/45507/stack
>>> [<0>] kthread_stop+0x6a/0x180
>>> [<0>] md_unregister_thread+0x29/0x60 [md_mod]
>>> [<0>] action_store+0x168/0x320 [md_mod]
>>> [<0>] md_attr_store+0x86/0xf0 [md_mod]
>>> [<0>] kernfs_fop_write_iter+0x136/0x1d0
>>> [<0>] vfs_write+0x23e/0x420
>>> [<0>] ksys_write+0x6f/0xf0
>>> [<0>] do_syscall_64+0x60/0x90
>>> [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>>>
>>> Please let me know if you'd like me to identify the lines for any of those.
>>>
>>
>> That's enough.
>>> Thanks,
>>> Jason
>>>
>>>
>>>>> root         456 99.9  0.0      0     0 ?        R    Sep05 1543:40 [md0_raid6]
>>>>> root         457  0.0  0.0      0     0 ?        D    Sep05   0:00 [md0_reshape]
>>>>>
>>>>> [jason@arch md]$ sudo cat /proc/457/stack
>>>>> [<0>] md_do_sync+0xef2/0x11d0 [md_mod]
>>>>> [<0>] md_thread+0xae/0x190 [md_mod]
>>>>> [<0>] kthread+0xe8/0x120
>>>>> [<0>] ret_from_fork+0x34/0x50
>>>>> [<0>] ret_from_fork_asm+0x1b/0x30
>>>>>
>>>>> Reading symbols from md-mod.ko...
>>>>> (gdb) list *(md_do_sync+0xef2)
>>>>> 0xb3a2 is in md_do_sync (drivers/md/md.c:9035).
>>>>> 9030                    ? "interrupted" : "done");
>>>>> 9031            /*
>>>>> 9032             * this also signals 'finished resyncing' to md_stop
>>>>> 9033             */
>>>>> 9034            blk_finish_plug(&plug);
>>>>> 9035            wait_event(mddev->recovery_wait,
>>>>> !atomic_read(&mddev->recovery_active));
>>>>
>>>> That's also wait for reshape io to be done from common layer.
>>>>
>>>>> 9036
>>>>> 9037            if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>>>>> 9038                !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>>>>> 9039                mddev->curr_resync >= MD_RESYNC_ACTIVE) {
>>>>>
>>>>>
>>>>> The debugfs info:
>>>>>
>>>>> [root@arch ~]# cat
>>>>> /sys/kernel/debug/block/sda/hctx*/{sched_tags,tags,busy,dispatch}
>>>>
>>>> Only sched_tags is read, sorry that I didn't mean to use this exact cmd.
>>>>
>>>> Perhaps you can using following cmd:
>>>>
>>>> find /sys/kernel/debug/block/sda/ -type f | xargs grep .
>>>>
>>>>> nr_tags=64
>>>>> nr_reserved_tags=0
>>>>> active_queues=0
>>>>>
>>>>> bitmap_tags:
>>>>> depth=64
>>>>> busy=1
>>>>
>>>> This means there is one IO in sda, however, I need more information to
>>>> make sure where is this IO. And please make sure don't run any other
>>>> thread that can read/write from sda. You can use "iostat -dmx 1" and
>>>> observe for a while to confirm that there is no new io.
>>
>> And can you help for this? Confirm no new io and collect debugfs.
> 
> As instructed, I confirmed there is no active IO to sda1 via iostat. I
> then ran the provided command
> 
> [root@arch ~]# find /sys/kernel/debug/block/sda/ -type f | xargs grep .
> /sys/kernel/debug/block/sda/rqos/wbt/wb_background:6
> /sys/kernel/debug/block/sda/rqos/wbt/wb_normal:12
> /sys/kernel/debug/block/sda/rqos/wbt/unknown_cnt:4
> /sys/kernel/debug/block/sda/rqos/wbt/min_lat_nsec:75000000
> /sys/kernel/debug/block/sda/rqos/wbt/inflight:0: inflight 1
> /sys/kernel/debug/block/sda/rqos/wbt/inflight:1: inflight 0
> /sys/kernel/debug/block/sda/rqos/wbt/inflight:2: inflight 0
> /sys/kernel/debug/block/sda/rqos/wbt/id:0
> /sys/kernel/debug/block/sda/rqos/wbt/enabled:1
> /sys/kernel/debug/block/sda/rqos/wbt/curr_win_nsec:100000000
> /sys/kernel/debug/block/sda/hctx0/type:default
> /sys/kernel/debug/block/sda/hctx0/dispatch_busy:0
> /sys/kernel/debug/block/sda/hctx0/active:0
> /sys/kernel/debug/block/sda/hctx0/run:2583
> /sys/kernel/debug/block/sda/hctx0/sched_tags_bitmap:00000000: 0000
> 0000 8000 0000
> /sys/kernel/debug/block/sda/hctx0/sched_tags:nr_tags=64
> /sys/kernel/debug/block/sda/hctx0/sched_tags:nr_reserved_tags=0
> /sys/kernel/debug/block/sda/hctx0/sched_tags:active_queues=0
> /sys/kernel/debug/block/sda/hctx0/sched_tags:bitmap_tags:
> /sys/kernel/debug/block/sda/hctx0/sched_tags:depth=64
> /sys/kernel/debug/block/sda/hctx0/sched_tags:busy=1
sched_tags:busy is 1 indicate this io made to the elevator. Which means
this problem is not related to raid,io issued to sda never return.

> /sys/kernel/debug/block/sda/hctx0/sched_tags:cleared=57
> /sys/kernel/debug/block/sda/hctx0/sched_tags:bits_per_word=16
> /sys/kernel/debug/block/sda/hctx0/sched_tags:map_nr=4
> /sys/kernel/debug/block/sda/hctx0/sched_tags:alloc_hint={40, 20, 48, 0}
> /sys/kernel/debug/block/sda/hctx0/sched_tags:wake_batch=8
> /sys/kernel/debug/block/sda/hctx0/sched_tags:wake_index=0
> /sys/kernel/debug/block/sda/hctx0/sched_tags:ws_active=0
> /sys/kernel/debug/block/sda/hctx0/sched_tags:ws={
> /sys/kernel/debug/block/sda/hctx0/sched_tags:   {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/sched_tags:   {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/sched_tags:   {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/sched_tags:   {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/sched_tags:   {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/sched_tags:   {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/sched_tags:   {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/sched_tags:   {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/sched_tags:}
> /sys/kernel/debug/block/sda/hctx0/sched_tags:round_robin=1
> /sys/kernel/debug/block/sda/hctx0/sched_tags:min_shallow_depth=48
> /sys/kernel/debug/block/sda/hctx0/tags_bitmap:00000000: 0000 0000
> /sys/kernel/debug/block/sda/hctx0/tags:nr_tags=32
> /sys/kernel/debug/block/sda/hctx0/tags:nr_reserved_tags=0
> /sys/kernel/debug/block/sda/hctx0/tags:active_queues=0
> /sys/kernel/debug/block/sda/hctx0/tags:bitmap_tags:
> /sys/kernel/debug/block/sda/hctx0/tags:depth=32
> /sys/kernel/debug/block/sda/hctx0/tags:busy=0
sched_tags:busy is 0 indicate this io didn't make to the driver. So io
is still in block layer, likely still in elevator.

Which elevator you are using? You can confirm by:

cat /sys/block/sda/queue/scheduler

It's likely mq-deadline, anyway, can you switch to other elevator before
assemble the array and retry to test if you can still reporduce the
problem?

Thanks,
Kuai

> /sys/kernel/debug/block/sda/hctx0/tags:cleared=21
> /sys/kernel/debug/block/sda/hctx0/tags:bits_per_word=8
> /sys/kernel/debug/block/sda/hctx0/tags:map_nr=4
> /sys/kernel/debug/block/sda/hctx0/tags:alloc_hint={19, 26, 7, 21}
> /sys/kernel/debug/block/sda/hctx0/tags:wake_batch=4
> /sys/kernel/debug/block/sda/hctx0/tags:wake_index=0
> /sys/kernel/debug/block/sda/hctx0/tags:ws_active=0
> /sys/kernel/debug/block/sda/hctx0/tags:ws={
> /sys/kernel/debug/block/sda/hctx0/tags: {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/tags: {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/tags: {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/tags: {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/tags: {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/tags: {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/tags: {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/tags: {.wait=inactive},
> /sys/kernel/debug/block/sda/hctx0/tags:}
> /sys/kernel/debug/block/sda/hctx0/tags:round_robin=1
> /sys/kernel/debug/block/sda/hctx0/tags:min_shallow_depth=4294967295
> /sys/kernel/debug/block/sda/hctx0/ctx_map:00000000: 00
> /sys/kernel/debug/block/sda/hctx0/flags:alloc_policy=RR SHOULD_MERGE
> /sys/kernel/debug/block/sda/sched/queued:0 0 0
> /sys/kernel/debug/block/sda/sched/owned_by_driver:0 0 0
> /sys/kernel/debug/block/sda/sched/async_depth:48
> /sys/kernel/debug/block/sda/sched/starved:0
> /sys/kernel/debug/block/sda/sched/batching:2
> /sys/kernel/debug/block/sda/state:SAME_COMP|IO_STAT|ADD_RANDOM|INIT_DONE|WC|STATS|REGISTERED|NOWAIT|SQ_SCHED
> /sys/kernel/debug/block/sda/pm_only:0
> 
> Let me know if there's anything further I can provide to assist in
> troubleshooting.

