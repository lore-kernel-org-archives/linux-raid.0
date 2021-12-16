Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721A6C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 16 Dec 2021 20:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240993AbhLPUiA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Dec 2021 15:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbhLPUh7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Dec 2021 15:37:59 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106DBC061574
        for <linux-raid@vger.kernel.org>; Thu, 16 Dec 2021 12:37:59 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id l10so114325pgm.7
        for <linux-raid@vger.kernel.org>; Thu, 16 Dec 2021 12:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=mfofeL6XdhDte/pyT2UWgkEC4UXcbdLL+Q9tO27z4T8=;
        b=D3o8GY1vrAKsZ0PXlH1B+9TZn27BQ/Mqhjjash2dKTa6I0+6oEKnKLAobZ9UPkqubK
         fZnhIf/KbtywZUISnv6ylqGe80PwzObWAb7ss/XuM323RugeiOl52gwoHZMjcZiNtAnM
         bJfe9d7n3g0YqCpEcpyyG1xeple26tP0nPW1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mfofeL6XdhDte/pyT2UWgkEC4UXcbdLL+Q9tO27z4T8=;
        b=yTHvZDDTxmTM0k44AUqQGRs+JpVJXDZNGg5B/vnl5+NACUm5aSWfjas1/mJ7KfS/hZ
         kVSgv5TRF8B6PRIqNZfVOF/wB6sgOfmPN9kuOBvt3LIv57a+CePcr3cdTlCrRVx5HhpJ
         3AMdbiFaEiIJ2lsmTuYt4fn2oY7Of6s5bMzSwCjwUULLt2WrgNrqKWaggwBDitrrvu3F
         INMCdVjnb16oKfxmXVply4391/3GLq0o5cWEDPB0v1DdfLWf6lzdjcj+ScvMCcYsSSDo
         CSdjMzjRhm26NRzG3ptS7pJtgzAGly29GX70NlXtYuhj8hG0S/IgSJHyQ19dxK8729PE
         Bf/w==
X-Gm-Message-State: AOAM531Rct416/YgqgUGRXlMJ4meyGECfzvDXsQcW3erOO23Ffj4r6V5
        VY3YrOIHZVjQfw1835aIi6z6WA==
X-Google-Smtp-Source: ABdhPJyg8buU0fA91YcczOKUvaW70cHbCOySoCUSqO/bXlV1PvUlEGlGCmJQwZcE+mGg/f6NnI/PTA==
X-Received: by 2002:a63:8149:: with SMTP id t70mr9545400pgd.71.1639687078228;
        Thu, 16 Dec 2021 12:37:58 -0800 (PST)
Received: from [192.168.1.5] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id c81sm6732240pfb.166.2021.12.16.12.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 12:37:57 -0800 (PST)
Message-ID: <50e23aee-af38-4da2-0f2f-da16af4fc477@digitalocean.com>
Date:   Thu, 16 Dec 2021 13:37:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v5 3/4] md: raid10 add nowait support
To:     Song Liu <song@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de
References: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
 <20211215060906.3230-1-vverma@digitalocean.com>
 <20211215060906.3230-3-vverma@digitalocean.com>
 <CAPhsuW5=GLRW9g2QxgBfcx_OKq08x5GqGO4iC86x6YzDHRz8fA@mail.gmail.com>
 <9a85af03-a551-6650-3807-c177659cd17b@digitalocean.com>
 <7592d323-a07f-e333-220c-e9a7321a16f3@digitalocean.com>
 <4d246589-2184-91ec-613c-a3e8926a2b92@kernel.dk>
 <d93019e5-1669-0eb6-1e8e-73768aa6f917@digitalocean.com>
 <051b25ce-3b6b-b156-f6fa-2da36bbd9144@kernel.dk>
 <dbd77650-7a27-1a7b-935c-aba1057d385b@digitalocean.com>
 <CAPhsuW44Y-Lw01yEzVJH4J=JvBLbcKBOyva-75ivT2mdfsS2fg@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW44Y-Lw01yEzVJH4J=JvBLbcKBOyva-75ivT2mdfsS2fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/16/21 1:18 PM, Song Liu wrote:
> On Thu, Dec 16, 2021 at 11:40 AM Vishal Verma <vverma@digitalocean.com> wrote:
>>
>> On 12/16/21 11:49 AM, Jens Axboe wrote:
>>> On 12/16/21 9:45 AM, Vishal Verma wrote:
>>>> On 12/16/21 9:42 AM, Jens Axboe wrote:
>>>>> On 12/15/21 5:30 PM, Vishal Verma wrote:
>>>>>> On 12/15/21 3:20 PM, Vishal Verma wrote:
>>>>>>> On 12/15/21 1:42 PM, Song Liu wrote:
>>>>>>>> On Tue, Dec 14, 2021 at 10:09 PM Vishal Verma
>>>>>>>> <vverma@digitalocean.com> wrote:
>>>>>>>>> This adds nowait support to the RAID10 driver. Very similar to
>>>>>>>>> raid1 driver changes. It makes RAID10 driver return with EAGAIN
>>>>>>>>> for situations where it could wait for eg:
>>>>>>>>>
>>>>>>>>> - Waiting for the barrier,
>>>>>>>>> - Too many pending I/Os to be queued,
>>>>>>>>> - Reshape operation,
>>>>>>>>> - Discard operation.
>>>>>>>>>
>>>>>>>>> wait_barrier() fn is modified to return bool to support error for
>>>>>>>>> wait barriers. It returns true in case of wait or if wait is not
>>>>>>>>> required and returns false if wait was required but not performed
>>>>>>>>> to support nowait.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
>>>>>>>>> ---
>>>>>>>>>      drivers/md/raid10.c | 57
>>>>>>>>> +++++++++++++++++++++++++++++++++++----------
>>>>>>>>>      1 file changed, 45 insertions(+), 12 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>>>>>>>> index dde98f65bd04..f6c73987e9ac 100644
>>>>>>>>> --- a/drivers/md/raid10.c
>>>>>>>>> +++ b/drivers/md/raid10.c
>>>>>>>>> @@ -952,11 +952,18 @@ static void lower_barrier(struct r10conf *conf)
>>>>>>>>>             wake_up(&conf->wait_barrier);
>>>>>>>>>      }
>>>>>>>>>
>>>>>>>>> -static void wait_barrier(struct r10conf *conf)
>>>>>>>>> +static bool wait_barrier(struct r10conf *conf, bool nowait)
>>>>>>>>>      {
>>>>>>>>>             spin_lock_irq(&conf->resync_lock);
>>>>>>>>>             if (conf->barrier) {
>>>>>>>>>                     struct bio_list *bio_list = current->bio_list;
>>>>>>>>> +
>>>>>>>>> +               /* Return false when nowait flag is set */
>>>>>>>>> +               if (nowait) {
>>>>>>>>> + spin_unlock_irq(&conf->resync_lock);
>>>>>>>>> +                       return false;
>>>>>>>>> +               }
>>>>>>>>> +
>>>>>>>>>                     conf->nr_waiting++;
>>>>>>>>>                     /* Wait for the barrier to drop.
>>>>>>>>>                      * However if there are already pending
>>>>>>>>> @@ -988,6 +995,7 @@ static void wait_barrier(struct r10conf *conf)
>>>>>>>>>             }
>>>>>>>>>             atomic_inc(&conf->nr_pending);
>>>>>>>>>             spin_unlock_irq(&conf->resync_lock);
>>>>>>>>> +       return true;
>>>>>>>>>      }
>>>>>>>>>
>>>>>>>>>      static void allow_barrier(struct r10conf *conf)
>>>>>>>>> @@ -1101,17 +1109,25 @@ static void raid10_unplug(struct blk_plug_cb
>>>>>>>>> *cb, bool from_schedule)
>>>>>>>>>      static void regular_request_wait(struct mddev *mddev, struct
>>>>>>>>> r10conf *conf,
>>>>>>>>>                                      struct bio *bio, sector_t sectors)
>>>>>>>>>      {
>>>>>>>>> -       wait_barrier(conf);
>>>>>>>>> +       /* Bail out if REQ_NOWAIT is set for the bio */
>>>>>>>>> +       if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
>>>>>>>>> +               bio_wouldblock_error(bio);
>>>>>>>>> +               return;
>>>>>>>>> +       }
>>>>>>>> I think we also need regular_request_wait to return bool and handle
>>>>>>>> it properly.
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Song
>>>>>>>>
>>>>>>> Ack, will fix it. Thanks!
>>>>>> Ran into this while running with io_uring. With the current v5 (raid10
>>>>>> patch) on top of md-next branch.
>>>>>> ./t/io_uring -a 0 -d 256 </dev/raid10>
>>>>>>
>>>>>> It didn't trigger with aio (-a 1)
>>>>>>
>>>>>> [  248.128661] BUG: kernel NULL pointer dereference, address:
>>>>>> 00000000000000b8
>>>>>> [  248.135628] #PF: supervisor read access in kernel mode
>>>>>> [  248.140762] #PF: error_code(0x0000) - not-present page
>>>>>> [  248.145903] PGD 0 P4D 0
>>>>>> [  248.148443] Oops: 0000 [#1] PREEMPT SMP NOPTI
>>>>>> [  248.152800] CPU: 49 PID: 9461 Comm: io_uring Kdump: loaded Not
>>>>>> tainted 5.16.0-rc3+ #2
>>>>>> [  248.160629] Hardware name: Dell Inc. PowerEdge R650xs/0PPTY2, BIOS
>>>>>> 1.3.8 08/31/2021
>>>>>> [  248.168279] RIP: 0010:raid10_end_read_request+0x74/0x140 [raid10]
>>>>>> [  248.174373] Code: 48 60 48 8b 58 58 48 c1 e2 05 49 03 55 08 48 89 4a
>>>>>> 10 40 84 f6 75 48 f0 41 80 4c 24 18 01 4c 89 e7 e8 e0 b8 ff ff 49 8b 4d
>>>>>> 00 <48> 8b 83 b8 00 00 00 f0 ff 8b f0 00 00 00 0f 94 c2 a8 01 74 04 84
>>>>>> [  248.193120] RSP: 0018:ffffb1c38d598ce8 EFLAGS: 00010086
>>>>>> [  248.198344] RAX: ffff8e5da2a1a100 RBX: 0000000000000000 RCX:
>>>>>> ffff8e5d89747000
>>>>>> [  248.205479] RDX: 000000008040003a RSI: 0000000080400039 RDI:
>>>>>> ffff8e1e00044900
>>>>>> [  248.212611] RBP: ffffb1c38d598d30 R08: 0000000000000000 R09:
>>>>>> 0000000000000001
>>>>>> [  248.219744] R10: ffff8e5da2a1ae00 R11: 000000411bab9000 R12:
>>>>>> ffff8e5da2a1ae00
>>>>>> [  248.226877] R13: ffff8e5d8973fc00 R14: 0000000000000000 R15:
>>>>>> 0000000000001000
>>>>>> [  248.234009] FS:  00007fc26b07d700(0000) GS:ffff8e9c6e600000(0000)
>>>>>> knlGS:0000000000000000
>>>>>> [  248.242096] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>> [  248.247843] CR2: 00000000000000b8 CR3: 00000040b25d4005 CR4:
>>>>>> 0000000000770ee0
>>>>>> [  248.254973] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>>>>> 0000000000000000
>>>>>> [  248.262107] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>>>>>> 0000000000000400
>>>>>> [  248.269240] PKRU: 55555554
>>>>>> [  248.271953] Call Trace:
>>>>>> [  248.274406]  <IRQ>
>>>>>> [  248.276425]  bio_endio+0xf6/0x170
>>>>>> [  248.279743]  blk_update_request+0x12d/0x470
>>>>>> [  248.283931]  ? sbitmap_queue_clear_batch+0xc7/0x110
>>>>>> [  248.288809]  blk_mq_end_request_batch+0x76/0x490
>>>>>> [  248.293429]  ? dma_direct_unmap_sg+0xdd/0x1a0
>>>>>> [  248.297786]  ? smp_call_function_single_async+0x46/0x70
>>>>>> [  248.303015]  ? mempool_kfree+0xe/0x10
>>>>>> [  248.306680]  ? mempool_kfree+0xe/0x10
>>>>>> [  248.310345]  nvme_pci_complete_batch+0x26/0xb0
>>>>>> [  248.314792]  nvme_irq+0x298/0x2f0
>>>>>> [  248.318110]  ? nvme_unmap_data+0xf0/0xf0
>>>>>> [  248.322038]  __handle_irq_event_percpu+0x3f/0x190
>>>>>> [  248.326744]  handle_irq_event_percpu+0x33/0x80
>>>>>> [  248.331190]  handle_irq_event+0x39/0x60
>>>>>> [  248.335028]  handle_edge_irq+0xbe/0x1e0
>>>>>> [  248.338869]  __common_interrupt+0x6b/0x110
>>>>>> [  248.342967]  common_interrupt+0xbd/0xe0
>>>>>> [  248.346808]  </IRQ>
>>>>>> [  248.348912]  <TASK>
>>>>>> [  248.351018]  asm_common_interrupt+0x1e/0x40
>>>>>> [  248.355206] RIP: 0010:_raw_spin_unlock_irqrestore+0x1e/0x37
>>>>>> [  248.360780] Code: 02 5d c3 0f 1f 44 00 00 5d c3 66 90 0f 1f 44 00 00
>>>>>> 55 48 89 e5 c6 07 00 0f 1f 40 00 f7 c6 00 02 00 00 74 01 fb bf 01 00 00
>>>>>> 00 <e8> ed 8e 5b ff 65 8b 05 66 7e 52 78 85 c0 74 02 5d c3 0f 1f 44 00
>>>>>>
>>>>>> [  248.379525] RSP: 0018:ffffb1c3a429b958 EFLAGS: 00000206
>>>>>> [  248.384749] RAX: 0000000000000001 RBX: ffff8e5d8973fd08 RCX:
>>>>>> ffff8e5d8973fd10
>>>>>> [  248.391884] RDX: 0000000000000001 RSI: 0000000000000246 RDI:
>>>>>> 0000000000000001
>>>>>> [  248.399017] RBP: ffffb1c3a429b958 R08: 0000000000000000 R09:
>>>>>> ffffb1c3a429b970
>>>>>> [  248.406148] R10: 0000000000000c00 R11: 0000000000000001 R12:
>>>>>> 0000000000000001
>>>>>> [  248.413280] R13: 0000000000000246 R14: 0000000000000000 R15:
>>>>>> 0000000000000003
>>>>>> [  248.420415]  __wake_up_common_lock+0x8a/0xc0
>>>>>> [  248.424686]  __wake_up+0x13/0x20
>>>>>> [  248.427919]  raid10_make_request+0x101/0x170 [raid10]
>>>>>> [  248.432971]  md_handle_request+0x179/0x1e0
>>>>>> [  248.437071]  ? submit_bio_checks+0x1f6/0x5a0
>>>>>> [  248.441345]  md_submit_bio+0x6d/0xa0
>>>>>> [  248.444924]  __submit_bio+0x94/0x140
>>>>>> [  248.448504]  submit_bio_noacct+0xe1/0x2a0
>>>>>> [  248.452515]  submit_bio+0x48/0x120
>>>>>> [  248.455923]  blkdev_direct_IO+0x220/0x540
>>>>>> [  248.459935]  ? __fsnotify_parent+0xff/0x330
>>>>>> [  248.464121]  ? __fsnotify_parent+0x10f/0x330
>>>>>> [  248.468393]  ? common_interrupt+0x73/0xe0
>>>>>> [  248.472408]  generic_file_read_iter+0xa5/0x160
>>>>>> [  248.476852]  blkdev_read_iter+0x38/0x70
>>>>>> [  248.480693]  io_read+0x119/0x420
>>>>>> [  248.483923]  ? sbitmap_queue_clear_batch+0xc7/0x110
>>>>>> [  248.488805]  ? blk_mq_end_request_batch+0x378/0x490
>>>>>> [  248.493684]  io_issue_sqe+0x7ec/0x19c0
>>>>>> [  248.497436]  ? io_req_prep+0x6a9/0xe60
>>>>>> [  248.501190]  io_submit_sqes+0x2a0/0x9f0
>>>>>> [  248.505030]  ? __fget_files+0x6a/0x90
>>>>>> [  248.508693]  __x64_sys_io_uring_enter+0x1da/0x8c0
>>>>>> [  248.513401]  do_syscall_64+0x38/0x90
>>>>>> [  248.516979]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>>> [  248.522033] RIP: 0033:0x7fc26b19b89d
>>>>>> [  248.525611] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa
>>>>>> 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f
>>>>>> 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 f5 0c 00 f7 d8 64 89 01 48
>>>>>> [  248.544360] RSP: 002b:00007fc26b07ce98 EFLAGS: 00000246 ORIG_RAX:
>>>>>> 00000000000001aa
>>>>>> [  248.551925] RAX: ffffffffffffffda RBX: 00007fc26b3f2fc0 RCX:
>>>>>> 00007fc26b19b89d
>>>>>> [  248.559058] RDX: 0000000000000020 RSI: 0000000000000020 RDI:
>>>>>> 0000000000000004
>>>>>> [  248.566189] RBP: 0000000000000020 R08: 0000000000000000 R09:
>>>>>> 0000000000000000
>>>>>> [  248.573322] R10: 0000000000000001 R11: 0000000000000246 R12:
>>>>>> 00005623a4b7a2a0
>>>>>> [  248.580456] R13: 0000000000000020 R14: 0000000000000020 R15:
>>>>>> 0000000000000020
>>>>>> [  248.587591]  </TASK>
>>>>> Do you have:
>>>>>
>>>>> commit 75feae73a28020e492fbad2323245455ef69d687
>>>>> Author: Pavel Begunkov <asml.silence@gmail.com>
>>>>> Date:   Tue Dec 7 20:16:36 2021 +0000
>>>>>
>>>>>        block: fix single bio async DIO error handling
>>>>>
>>>>> in your tree?
>>>>>
>>>> Nope. I will get it in and test. Thanks!
>>> Might be worth re-running with KASAN enabled in your config to see if
>>> that triggers anything.
>>>
>> Got this:
>> [  739.336669] CPU: 63 PID: 10373 Comm: io_uring Kdump: loaded Not
>> tainted 5.16.0-rc3+ #8
>> [  739.344583] Hardware name: Dell Inc. PowerEdge R650xs/0PPTY2, BIOS
>> 1.3.8 08/31/2021
>> [  739.352236] Call Trace:
>> [  739.354687]  <IRQ>
>> [  739.356705]  dump_stack_lvl+0x38/0x49
>> [  739.360381]  print_address_description.constprop.0+0x28/0x150
>> [  739.366136]  ? 0xffffffffc046f3df
>> [  739.369455]  kasan_report.cold+0x82/0xdb
>> [  739.373383]  ? 0xffffffffc046f3df
>> [  739.376700]  __asan_load8+0x69/0x90
>> [  739.380194]  0xffffffffc046f3df
>> [  739.383339]  ? 0xffffffffc046f340
>> [  739.386659]  ? blkcg_iolatency_done_bio+0x26/0x390
>> [  739.391461]  ? __rcu_read_unlock+0x5b/0x270
>> [  739.395655]  ? kmem_cache_alloc+0x143/0x460
>> [  739.399841]  ? mempool_alloc_slab+0x17/0x20
>> [  739.404027]  ? bio_uninit+0x6c/0xf0
>> [  739.407522]  bio_endio+0x27f/0x2a0
>> [  739.410926]  blk_update_request+0x1e8/0x750
>> [  739.415112]  blk_mq_end_request_batch+0x10b/0x9b0
>> [  739.419818]  ? blk_mq_end_request+0x460/0x460
>> [  739.424179]  ? kfree+0xa0/0x400
>> [  739.427322]  ? mempool_kfree+0xe/0x10
>> [  739.430989]  ? generic_file_write_iter+0xf0/0xf0
>> [  739.435609]  ? dma_unmap_page_attrs+0x15f/0x2c0
>> [  739.440144]  nvme_pci_complete_batch+0x34/0x160
>> [  739.444684]  ? blk_mq_complete_request_remote+0x1ca/0x2d0
>> [  739.450084]  nvme_irq+0x5fa/0x630
>> [  739.453404]  ? nvme_timeout+0x370/0x370
>> [  739.457242]  ? nvme_unmap_data+0x1e0/0x1e0
>> [  739.461340]  ? __kasan_check_write+0x14/0x20
>> [  739.465614]  ? credit_entropy_bits.constprop.0+0x76/0x190
>> [  739.471015]  ? nvme_timeout+0x370/0x370
>> [  739.474853]  __handle_irq_event_percpu+0x69/0x260
>> [  739.479568]  handle_irq_event_percpu+0x70/0xf0
>> [  739.484015]  ? __handle_irq_event_percpu+0x260/0x260
>> [  739.488981]  ? __kasan_check_write+0x14/0x20
>> [  739.493261]  ? _raw_spin_lock+0x88/0xe0
>> [  739.497109]  ? _raw_spin_lock_irqsave+0xf0/0xf0
>> [  739.501643]  handle_irq_event+0x5a/0x90
>> [  739.505480]  handle_edge_irq+0x148/0x320
>> [  739.509407]  __common_interrupt+0x75/0x130
>> [  739.513514]  common_interrupt+0xae/0xd0
>> [  739.517354]  </IRQ>
>> [  739.519460]  <TASK>
>> [  739.521567]  asm_common_interrupt+0x1e/0x40
>> [  739.525753] RIP: 0010:__asan_store8+0x37/0x90
>> [  739.530111] Code: 4f 48 b8 ff ff ff ff ff 7f ff ff 48 39 c7 76 40 48
>> 8d 47 07 48 89 c2 83 e2 07 48 83 fa 07 75 18 48 ba 00 00 00 00 00 fc ff
>> df <48> c1 e8 03 0f b6 04 10 84 c0 75 2b 5d c3 48 be 00 00 00 00 00 fc
>> [  739.548865] RSP: 0018:ffffc900307c7100 EFLAGS: 00000246
>> [  739.554092] RAX: ffffc900307c7237 RBX: ffffc900307c7780 RCX:
>> ffffffff82c9b461
>> [  739.561227] RDX: dffffc0000000000 RSI: ffffc900307c7790 RDI:
>> ffffc900307c7230
>> [  739.568358] RBP: ffffc900307c7100 R08: ffffffff82c9b202 R09:
>> ffff8882d96c0000
>> [  739.575490] R10: ffffc900307c7257 R11: fffff520060f8e4a R12:
>> 0000000082c9b201
>> [  739.582624] R13: 0000000000000000 R14: ffffc900307c7238 R15:
>> ffffc900307c71e8
>> [  739.589760]  ? update_stack_state+0x22/0x2c0
>> [  739.594038]  ? update_stack_state+0x281/0x2c0
>> [  739.598398]  update_stack_state+0x281/0x2c0
>> [  739.602585]  unwind_next_frame.part.0+0xe0/0x360
>> [  739.607204]  ? bio_alloc_bioset+0x223/0x2f0
>> [  739.611389]  ? create_prof_cpu_mask+0x30/0x30
>> [  739.615749]  ? mempool_alloc_slab+0x17/0x20
>> [  739.619935]  unwind_next_frame+0x23/0x30
>> [  739.623860]  arch_stack_walk+0x88/0xf0
>> [  739.627613]  ? bio_alloc_bioset+0x223/0x2f0
>> [  739.631800]  stack_trace_save+0x94/0xc0
>> [  739.635640]  ? filter_irq_stacks+0x70/0x70
>> [  739.639738]  ? blk_mq_put_tag+0x80/0x80
>> [  739.643576]  ? _raw_spin_unlock_irqrestore+0x23/0x40
>> [  739.648545]  ? __wake_up_common_lock+0xfd/0x150
>> [  739.653084]  kasan_save_stack+0x26/0x60
>> [  739.656924]  ? kasan_save_stack+0x26/0x60
>> [  739.660938]  ? __kasan_slab_alloc+0x6d/0x90
>> [  739.665123]  ? kmem_cache_alloc+0x143/0x460
>> [  739.669308]  ? mempool_alloc_slab+0x17/0x20
>> [  739.673494]  ? mempool_alloc+0xef/0x280
>> [  739.677333]  ? bio_alloc_bioset+0x223/0x2f0
>> [  739.681519]  ? blk_mq_rq_ctx_init.isra.0+0x28a/0x3c0
>> [  739.686489]  ? __blk_mq_alloc_requests+0x655/0x680
>> [  739.691288]  ? blkcg_iolatency_throttle+0x5d/0x760
>> [  739.696081]  ? bio_to_wbt_flags+0x47/0xf0
>> [  739.700093]  ? update_io_ticks+0x5e/0xd0
>> [  739.704021]  ? preempt_count_sub+0x18/0xc0
>> [  739.708120]  ? __kasan_check_read+0x11/0x20
>> [  739.712305]  ? blk_mq_submit_bio+0x740/0xce0
>> [  739.716580]  ? blk_mq_try_issue_list_directly+0x1b0/0x1b0
>> [  739.721987]  ? kasan_poison+0x3c/0x50
>> [  739.725650]  ? kasan_unpoison+0x28/0x50
>> [  739.729491]  __kasan_slab_alloc+0x6d/0x90
>> [  739.733503]  kmem_cache_alloc+0x143/0x460
>> [  739.737518]  mempool_alloc_slab+0x17/0x20
>> [  739.741529]  mempool_alloc+0xef/0x280
>> [  739.745194]  ? mempool_free+0x170/0x170
>> [  739.749035]  ? mempool_destroy+0x30/0x30
>> [  739.752961]  ? __fsnotify_update_child_dentry_flags.part.0+0x170/0x170
>> [  739.759498]  bio_alloc_bioset+0x223/0x2f0
>> [  739.763517]  ? __this_cpu_preempt_check+0x13/0x20
>> [  739.768223]  ? bvec_alloc+0xd0/0xd0
>> [  739.771715]  ? __fsnotify_parent+0x1ed/0x590
>> [  739.775988]  ? do_direct_IO+0x150/0x1880
>> [  739.779916]  ? submit_bio+0xb0/0x220
>> [  739.783496]  bio_alloc_kiocb+0x185/0x1c0
>> [  739.787430]  blkdev_direct_IO+0x114/0x400
>> [  739.791441]  generic_file_read_iter+0x152/0x250
>> [  739.795974]  blkdev_read_iter+0x84/0xd0
>> [  739.799815]  io_read+0x1ec/0x770
>> [  739.803056]  ? __rcu_read_unlock+0x5b/0x270
>> [  739.807240]  ? io_setup_async_rw+0x270/0x270
>> [  739.811515]  ? __sbq_wake_up+0x2d/0x1b0
>> [  739.815352]  ? __rcu_read_unlock+0x5b/0x270
>> [  739.819537]  ? sbitmap_queue_clear+0xc9/0xe0
>> [  739.823813]  ? blk_queue_exit+0x35/0x90
>> [  739.827653]  ? __blk_mq_free_request+0x111/0x160
>> [  739.832280]  io_issue_sqe+0xcac/0x27f0
>> [  739.836031]  ? blk_mq_free_plug_rqs+0x3f/0x50
>> [  739.840394]  ? io_poll_add.isra.0+0x290/0x290
>> [  739.844760]  ? io_req_prep+0xcc2/0x1bb0
>> [  739.848598]  ? io_submit_sqes+0x43b/0x1260
>> [  739.852701]  io_submit_sqes+0x5e5/0x1260
>> [  739.856634]  ? io_do_iopoll+0x561/0x720
>> [  739.860474]  ? io_wq_submit_work+0x230/0x230
>> [  739.864746]  ? __kasan_check_write+0x14/0x20
>> [  739.869016]  ? mutex_lock+0x8f/0xe0
>> [  739.872510]  ? __mutex_lock_slowpath+0x20/0x20
>> [  739.876956]  ? __rcu_read_unlock+0x5b/0x270
>> [  739.881144]  __x64_sys_io_uring_enter+0x367/0xef0
>> [  739.885859]  ? io_submit_sqes+0x1260/0x1260
>> [  739.890044]  ? __this_cpu_preempt_check+0x13/0x20
>> [  739.894749]  ? xfd_validate_state+0x3c/0xd0
>> [  739.898936]  ? __schedule+0x5be/0x10c0
>> [  739.902687]  ? restore_fpregs_from_fpstate+0xa2/0x170
>> [  739.907741]  ? kernel_fpu_begin_mask+0x170/0x170
>> [  739.912362]  ? debug_smp_processor_id+0x17/0x20
>> [  739.916903]  ? debug_smp_processor_id+0x17/0x20
>> [  739.921434]  ? fpregs_assert_state_consistent+0x5f/0x70
>> [  739.926662]  ? exit_to_user_mode_prepare+0x4b/0x1e0
>> [  739.931549]  do_syscall_64+0x38/0x90
>> [  739.935129]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [  739.940182] RIP: 0033:0x7f7345d7d89d
>> [  739.943759] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa
>> 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f
>> 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 f5 0c 00 f7 d8 64 89 01 48
>> [  739.962513] RSP: 002b:00007f7345c5ee98 EFLAGS: 00000246 ORIG_RAX:
>> 00000000000001aa
>> [  739.970081] RAX: ffffffffffffffda RBX: 00007f7345fd2fc0 RCX:
>> 00007f7345d7d89d
>> [  739.977216] RDX: 0000000000000000 RSI: 0000000000000020 RDI:
>> 0000000000000004
>> [  739.984349] RBP: 0000000000000020 R08: 0000000000000000 R09:
>> 0000000000000000
>> [  739.991481] R10: 0000000000000000 R11: 0000000000000246 R12:
>> 000055be1d11e2a0
>> [  739.998612] R13: 0000000000000020 R14: 0000000000000000 R15:
>> 0000000000000020
>> [  740.005749]  </TASK>
>> [  740.007945]
>> [  740.009444] Allocated by task 10373:
>> [  740.013084]
>> [  740.014583] Freed by task 10373:
>> [  740.017879]
>> [  740.019378] The buggy address belongs to the object at ffff88c1be016e00
>> [  740.019378]  which belongs to the cache kmalloc-256 of size 256
>> [  740.031886] The buggy address is located 40 bytes inside of
>> [  740.031886]  256-byte region [ffff88c1be016e00, ffff88c1be016f00)
>> [  740.043534] The buggy address belongs to the page:
>> [  740.048345]
>> [  740.049840] Memory state around the buggy address:
>> [  740.054636]  ffff88c1be016d00: fc fc fc fc fc fc fc fc fc fc fc fc fc
>> fc fc fc
>> [  740.061854]  ffff88c1be016d80: fc fc fc fc fc fc fc fc fc fc fc fc fc
>> fc fc fc
>> [  740.069074] >ffff88c1be016e00: fa fb fb fb fb fb fb fb fb fb fb fb fb
>> fb fb fb
>> [  740.076294]                                   ^
>> [  740.080827]  ffff88c1be016e80: fb fb fb fb fb fb fb fb fb fb fb fb fb
>> fb fb fb
>> [  740.088045]  ffff88c1be016f00: fc fc fc fc fc fc fc fc fc fc fc fc fc
>> fc fc fc
>> [  740.095265]
>> ==================================================================
>> [  740.102497] kernel BUG at mm/slub.c:379!
>> [  740.106431] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
>>
> What's the exact command line that triggers this? I am not able to
> trigger it with
> either fio or t/io_uring.
>
> Song
I only had 1 nvme so was creating 4 partitions on it and creating a 
raid10 and doing:

mdadm -C /dev/md10 -l 10 -n 4 /dev/nvme4n1p1 /dev/nvme4n1p2 
/dev/nvme4n1p3 /dev/nvme4n1p4
./t/io_uring /dev/md10-d 256 -p 0 -a 0 -r 100

on top of commit: c14704e1cb556 (md-next branch) + "md: add support for 
REQ_NOWAIT" patch
Also, applied the commit (75feae73a28) Jens pointed earlier today.

