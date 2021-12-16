Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D5BC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 16 Dec 2021 00:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhLPAaa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Dec 2021 19:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhLPAa3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Dec 2021 19:30:29 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC5BC061574
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 16:30:29 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q16so21453899pgq.10
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 16:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:from:to:cc
         :references:in-reply-to:content-transfer-encoding;
        bh=euSxqqnakQ3lBLDP3ZtdFQf4RI1fd6RrcyODU0UVQzc=;
        b=hd5B+hRNOBMsu88L1EeZWaz77g0X1uulzMjhA223vjN24kaoYIce3fGEK97eHuU8c0
         QMuP5Qd/8PEc3EVZPu8FF7yqZ1uEYgO9OsUWfNhNoz7oCWjtc0W/qn/0pUKKWTqB7psu
         xYj+YpAQI238zCBHwhdALJBsc4L06m2LRYydc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=euSxqqnakQ3lBLDP3ZtdFQf4RI1fd6RrcyODU0UVQzc=;
        b=QwvagDMoMpWGQuglEV4TRmotlU8B9BarGeBab+BVM+TGhiGkzVHnqlORhbnbhazUP0
         maPo5giwM6WjqCYrr0+CTeY05Ke+z6tzK1NKHhUA+6krGapq8MWIKYWIBidGiBiRZXUp
         5CfyiZEVXW3GDJrSeV+AkmlyFyipwUBpaKfzPt9fHD6ZDMWtuh3UBUKSIrWj8ftzgM8k
         P/zdhJ9Qo1az4orl4c0ZfZ1gaO8ZNj6wqBijwySaY8RgZnMTaKjOK6NMJr45XZ8V9YTX
         dWsm2ZHbI0BLDzopoPmpg3bC54rOWptwTgEPq8U/zAFc1OIz3VSVOFJUP6b8cIliO3lq
         QlFg==
X-Gm-Message-State: AOAM532FOL+mUVXz+m257g0wKKptP8EQZ71JRA04aRW18JrLDO4GEacF
        Xo7lDGp8JP9RK5QUNSVHseGIbQ==
X-Google-Smtp-Source: ABdhPJxt6PN2sqyI1z5wq9EgBESooE2bEX0YX9mbNubtU3c+pE0eRIYYaPApvK7Du8S8JZEQnV4SRA==
X-Received: by 2002:a63:5920:: with SMTP id n32mr9962260pgb.226.1639614628798;
        Wed, 15 Dec 2021 16:30:28 -0800 (PST)
Received: from [192.168.1.5] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id j6sm1362503pjv.35.2021.12.15.16.30.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 16:30:28 -0800 (PST)
Message-ID: <7592d323-a07f-e333-220c-e9a7321a16f3@digitalocean.com>
Date:   Wed, 15 Dec 2021 17:30:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v5 3/4] md: raid10 add nowait support
From:   Vishal Verma <vverma@digitalocean.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rgoldwyn@suse.de
References: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
 <20211215060906.3230-1-vverma@digitalocean.com>
 <20211215060906.3230-3-vverma@digitalocean.com>
 <CAPhsuW5=GLRW9g2QxgBfcx_OKq08x5GqGO4iC86x6YzDHRz8fA@mail.gmail.com>
 <9a85af03-a551-6650-3807-c177659cd17b@digitalocean.com>
In-Reply-To: <9a85af03-a551-6650-3807-c177659cd17b@digitalocean.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/15/21 3:20 PM, Vishal Verma wrote:
>
> On 12/15/21 1:42 PM, Song Liu wrote:
>> On Tue, Dec 14, 2021 at 10:09 PM Vishal Verma 
>> <vverma@digitalocean.com> wrote:
>>> This adds nowait support to the RAID10 driver. Very similar to
>>> raid1 driver changes. It makes RAID10 driver return with EAGAIN
>>> for situations where it could wait for eg:
>>>
>>> - Waiting for the barrier,
>>> - Too many pending I/Os to be queued,
>>> - Reshape operation,
>>> - Discard operation.
>>>
>>> wait_barrier() fn is modified to return bool to support error for
>>> wait barriers. It returns true in case of wait or if wait is not
>>> required and returns false if wait was required but not performed
>>> to support nowait.
>>>
>>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
>>> ---
>>>   drivers/md/raid10.c | 57 
>>> +++++++++++++++++++++++++++++++++++----------
>>>   1 file changed, 45 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index dde98f65bd04..f6c73987e9ac 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>>> @@ -952,11 +952,18 @@ static void lower_barrier(struct r10conf *conf)
>>>          wake_up(&conf->wait_barrier);
>>>   }
>>>
>>> -static void wait_barrier(struct r10conf *conf)
>>> +static bool wait_barrier(struct r10conf *conf, bool nowait)
>>>   {
>>>          spin_lock_irq(&conf->resync_lock);
>>>          if (conf->barrier) {
>>>                  struct bio_list *bio_list = current->bio_list;
>>> +
>>> +               /* Return false when nowait flag is set */
>>> +               if (nowait) {
>>> + spin_unlock_irq(&conf->resync_lock);
>>> +                       return false;
>>> +               }
>>> +
>>>                  conf->nr_waiting++;
>>>                  /* Wait for the barrier to drop.
>>>                   * However if there are already pending
>>> @@ -988,6 +995,7 @@ static void wait_barrier(struct r10conf *conf)
>>>          }
>>>          atomic_inc(&conf->nr_pending);
>>>          spin_unlock_irq(&conf->resync_lock);
>>> +       return true;
>>>   }
>>>
>>>   static void allow_barrier(struct r10conf *conf)
>>> @@ -1101,17 +1109,25 @@ static void raid10_unplug(struct blk_plug_cb 
>>> *cb, bool from_schedule)
>>>   static void regular_request_wait(struct mddev *mddev, struct 
>>> r10conf *conf,
>>>                                   struct bio *bio, sector_t sectors)
>>>   {
>>> -       wait_barrier(conf);
>>> +       /* Bail out if REQ_NOWAIT is set for the bio */
>>> +       if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
>>> +               bio_wouldblock_error(bio);
>>> +               return;
>>> +       }
>> I think we also need regular_request_wait to return bool and handle 
>> it properly.
>>
>> Thanks,
>> Song
>>
> Ack, will fix it. Thanks!

Ran into this while running with io_uring. With the current v5 (raid10 
patch) on top of md-next branch.
./t/io_uring -a 0 -d 256 </dev/raid10>

It didn't trigger with aio (-a 1)

[  248.128661] BUG: kernel NULL pointer dereference, address: 
00000000000000b8
[  248.135628] #PF: supervisor read access in kernel mode
[  248.140762] #PF: error_code(0x0000) - not-present page
[  248.145903] PGD 0 P4D 0
[  248.148443] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  248.152800] CPU: 49 PID: 9461 Comm: io_uring Kdump: loaded Not 
tainted 5.16.0-rc3+ #2
[  248.160629] Hardware name: Dell Inc. PowerEdge R650xs/0PPTY2, BIOS 
1.3.8 08/31/2021
[  248.168279] RIP: 0010:raid10_end_read_request+0x74/0x140 [raid10]
[  248.174373] Code: 48 60 48 8b 58 58 48 c1 e2 05 49 03 55 08 48 89 4a 
10 40 84 f6 75 48 f0 41 80 4c 24 18 01 4c 89 e7 e8 e0 b8 ff ff 49 8b 4d 
00 <48> 8b 83 b8 00 00 00 f0 ff 8b f0 00 00 00 0f 94 c2 a8 01 74 04 84
[  248.193120] RSP: 0018:ffffb1c38d598ce8 EFLAGS: 00010086
[  248.198344] RAX: ffff8e5da2a1a100 RBX: 0000000000000000 RCX: 
ffff8e5d89747000
[  248.205479] RDX: 000000008040003a RSI: 0000000080400039 RDI: 
ffff8e1e00044900
[  248.212611] RBP: ffffb1c38d598d30 R08: 0000000000000000 R09: 
0000000000000001
[  248.219744] R10: ffff8e5da2a1ae00 R11: 000000411bab9000 R12: 
ffff8e5da2a1ae00
[  248.226877] R13: ffff8e5d8973fc00 R14: 0000000000000000 R15: 
0000000000001000
[  248.234009] FS:  00007fc26b07d700(0000) GS:ffff8e9c6e600000(0000) 
knlGS:0000000000000000
[  248.242096] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  248.247843] CR2: 00000000000000b8 CR3: 00000040b25d4005 CR4: 
0000000000770ee0
[  248.254973] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  248.262107] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  248.269240] PKRU: 55555554
[  248.271953] Call Trace:
[  248.274406]  <IRQ>
[  248.276425]  bio_endio+0xf6/0x170
[  248.279743]  blk_update_request+0x12d/0x470
[  248.283931]  ? sbitmap_queue_clear_batch+0xc7/0x110
[  248.288809]  blk_mq_end_request_batch+0x76/0x490
[  248.293429]  ? dma_direct_unmap_sg+0xdd/0x1a0
[  248.297786]  ? smp_call_function_single_async+0x46/0x70
[  248.303015]  ? mempool_kfree+0xe/0x10
[  248.306680]  ? mempool_kfree+0xe/0x10
[  248.310345]  nvme_pci_complete_batch+0x26/0xb0
[  248.314792]  nvme_irq+0x298/0x2f0
[  248.318110]  ? nvme_unmap_data+0xf0/0xf0
[  248.322038]  __handle_irq_event_percpu+0x3f/0x190
[  248.326744]  handle_irq_event_percpu+0x33/0x80
[  248.331190]  handle_irq_event+0x39/0x60
[  248.335028]  handle_edge_irq+0xbe/0x1e0
[  248.338869]  __common_interrupt+0x6b/0x110
[  248.342967]  common_interrupt+0xbd/0xe0
[  248.346808]  </IRQ>
[  248.348912]  <TASK>
[  248.351018]  asm_common_interrupt+0x1e/0x40
[  248.355206] RIP: 0010:_raw_spin_unlock_irqrestore+0x1e/0x37
[  248.360780] Code: 02 5d c3 0f 1f 44 00 00 5d c3 66 90 0f 1f 44 00 00 
55 48 89 e5 c6 07 00 0f 1f 40 00 f7 c6 00 02 00 00 74 01 fb bf 01 00 00 
00 <e8> ed 8e 5b ff 65 8b 05 66 7e 52 78 85 c0 74 02 5d c3 0f 1f 44 00

[  248.379525] RSP: 0018:ffffb1c3a429b958 EFLAGS: 00000206
[  248.384749] RAX: 0000000000000001 RBX: ffff8e5d8973fd08 RCX: 
ffff8e5d8973fd10
[  248.391884] RDX: 0000000000000001 RSI: 0000000000000246 RDI: 
0000000000000001
[  248.399017] RBP: ffffb1c3a429b958 R08: 0000000000000000 R09: 
ffffb1c3a429b970
[  248.406148] R10: 0000000000000c00 R11: 0000000000000001 R12: 
0000000000000001
[  248.413280] R13: 0000000000000246 R14: 0000000000000000 R15: 
0000000000000003
[  248.420415]  __wake_up_common_lock+0x8a/0xc0
[  248.424686]  __wake_up+0x13/0x20
[  248.427919]  raid10_make_request+0x101/0x170 [raid10]
[  248.432971]  md_handle_request+0x179/0x1e0
[  248.437071]  ? submit_bio_checks+0x1f6/0x5a0
[  248.441345]  md_submit_bio+0x6d/0xa0
[  248.444924]  __submit_bio+0x94/0x140
[  248.448504]  submit_bio_noacct+0xe1/0x2a0
[  248.452515]  submit_bio+0x48/0x120
[  248.455923]  blkdev_direct_IO+0x220/0x540
[  248.459935]  ? __fsnotify_parent+0xff/0x330
[  248.464121]  ? __fsnotify_parent+0x10f/0x330
[  248.468393]  ? common_interrupt+0x73/0xe0
[  248.472408]  generic_file_read_iter+0xa5/0x160
[  248.476852]  blkdev_read_iter+0x38/0x70
[  248.480693]  io_read+0x119/0x420
[  248.483923]  ? sbitmap_queue_clear_batch+0xc7/0x110
[  248.488805]  ? blk_mq_end_request_batch+0x378/0x490
[  248.493684]  io_issue_sqe+0x7ec/0x19c0
[  248.497436]  ? io_req_prep+0x6a9/0xe60
[  248.501190]  io_submit_sqes+0x2a0/0x9f0
[  248.505030]  ? __fget_files+0x6a/0x90
[  248.508693]  __x64_sys_io_uring_enter+0x1da/0x8c0
[  248.513401]  do_syscall_64+0x38/0x90
[  248.516979]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  248.522033] RIP: 0033:0x7fc26b19b89d
[  248.525611] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 
48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 f5 0c 00 f7 d8 64 89 01 48
[  248.544360] RSP: 002b:00007fc26b07ce98 EFLAGS: 00000246 ORIG_RAX: 
00000000000001aa
[  248.551925] RAX: ffffffffffffffda RBX: 00007fc26b3f2fc0 RCX: 
00007fc26b19b89d
[  248.559058] RDX: 0000000000000020 RSI: 0000000000000020 RDI: 
0000000000000004
[  248.566189] RBP: 0000000000000020 R08: 0000000000000000 R09: 
0000000000000000
[  248.573322] R10: 0000000000000001 R11: 0000000000000246 R12: 
00005623a4b7a2a0
[  248.580456] R13: 0000000000000020 R14: 0000000000000020 R15: 
0000000000000020
[  248.587591]  </TASK>

>>>          while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>>>              bio->bi_iter.bi_sector < conf->reshape_progress &&
>>>              bio->bi_iter.bi_sector + sectors > 
>>> conf->reshape_progress) {
>>>                  raid10_log(conf->mddev, "wait reshape");
>>> +               if (bio->bi_opf & REQ_NOWAIT) {
>>> +                       bio_wouldblock_error(bio);
>>> +                       return;
>>> +               }
>>>                  allow_barrier(conf);
>>>                  wait_event(conf->wait_barrier,
>>>                             conf->reshape_progress <= 
>>> bio->bi_iter.bi_sector ||
>>>                             conf->reshape_progress >= 
>>> bio->bi_iter.bi_sector +
>>>                             sectors);
>>> -               wait_barrier(conf);
>>> +               wait_barrier(conf, false);
>>>          }
>>>   }
>>>
>>> @@ -1179,7 +1195,7 @@ static void raid10_read_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>                  bio_chain(split, bio);
>>>                  allow_barrier(conf);
>>>                  submit_bio_noacct(bio);
>>> -               wait_barrier(conf);
>>> +               wait_barrier(conf, false);
>>>                  bio = split;
>>>                  r10_bio->master_bio = bio;
>>>                  r10_bio->sectors = max_sectors;
>>> @@ -1338,7 +1354,7 @@ static void wait_blocked_dev(struct mddev 
>>> *mddev, struct r10bio *r10_bio)
>>>                  raid10_log(conf->mddev, "%s wait rdev %d blocked",
>>>                                  __func__, blocked_rdev->raid_disk);
>>>                  md_wait_for_blocked_rdev(blocked_rdev, mddev);
>>> -               wait_barrier(conf);
>>> +               wait_barrier(conf, false);
>>>                  goto retry_wait;
>>>          }
>>>   }
>>> @@ -1357,6 +1373,11 @@ static void raid10_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>> bio_end_sector(bio)))) {
>>>                  DEFINE_WAIT(w);
>>>                  for (;;) {
>>> +                       /* Bail out if REQ_NOWAIT is set for the bio */
>>> +                       if (bio->bi_opf & REQ_NOWAIT) {
>>> +                               bio_wouldblock_error(bio);
>>> +                               return;
>>> +                       }
>>> prepare_to_wait(&conf->wait_barrier,
>>>                                          &w, TASK_IDLE);
>>>                          if (!md_cluster_ops->area_resyncing(mddev, 
>>> WRITE,
>>> @@ -1381,6 +1402,10 @@ static void raid10_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>                                BIT(MD_SB_CHANGE_DEVS) | 
>>> BIT(MD_SB_CHANGE_PENDING));
>>>                  md_wakeup_thread(mddev->thread);
>>>                  raid10_log(conf->mddev, "wait reshape metadata");
>>> +               if (bio->bi_opf & REQ_NOWAIT) {
>>> +                       bio_wouldblock_error(bio);
>>> +                       return;
>>> +               }
>>>                  wait_event(mddev->sb_wait,
>>>                             !test_bit(MD_SB_CHANGE_PENDING, 
>>> &mddev->sb_flags));
>>>
>>> @@ -1390,6 +1415,10 @@ static void raid10_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>          if (conf->pending_count >= max_queued_requests) {
>>>                  md_wakeup_thread(mddev->thread);
>>>                  raid10_log(mddev, "wait queued");
>>> +               if (bio->bi_opf & REQ_NOWAIT) {
>>> +                       bio_wouldblock_error(bio);
>>> +                       return;
>>> +               }
>>>                  wait_event(conf->wait_barrier,
>>>                             conf->pending_count < max_queued_requests);
>>>          }
>>> @@ -1482,7 +1511,7 @@ static void raid10_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>                  bio_chain(split, bio);
>>>                  allow_barrier(conf);
>>>                  submit_bio_noacct(bio);
>>> -               wait_barrier(conf);
>>> +               wait_barrier(conf, false);
>>>                  bio = split;
>>>                  r10_bio->master_bio = bio;
>>>          }
>>> @@ -1607,7 +1636,11 @@ static int raid10_handle_discard(struct mddev 
>>> *mddev, struct bio *bio)
>>>          if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
>>>                  return -EAGAIN;
>>>
>>> -       wait_barrier(conf);
>>> +       if (bio->bi_opf & REQ_NOWAIT) {
>>> +               bio_wouldblock_error(bio);
>>> +               return 0;
>>> +       }
>>> +       wait_barrier(conf, false);
>>>
>>>          /*
>>>           * Check reshape again to avoid reshape happens after checking
>>> @@ -1649,7 +1682,7 @@ static int raid10_handle_discard(struct mddev 
>>> *mddev, struct bio *bio)
>>>                  allow_barrier(conf);
>>>                  /* Resend the fist split part */
>>>                  submit_bio_noacct(split);
>>> -               wait_barrier(conf);
>>> +               wait_barrier(conf, false);
>>>          }
>>>          div_u64_rem(bio_end, stripe_size, &remainder);
>>>          if (remainder) {
>>> @@ -1660,7 +1693,7 @@ static int raid10_handle_discard(struct mddev 
>>> *mddev, struct bio *bio)
>>>                  /* Resend the second split part */
>>>                  submit_bio_noacct(bio);
>>>                  bio = split;
>>> -               wait_barrier(conf);
>>> +               wait_barrier(conf, false);
>>>          }
>>>
>>>          bio_start = bio->bi_iter.bi_sector;
>>> @@ -1816,7 +1849,7 @@ static int raid10_handle_discard(struct mddev 
>>> *mddev, struct bio *bio)
>>>                  end_disk_offset += geo->stride;
>>>                  atomic_inc(&first_r10bio->remaining);
>>>                  raid_end_discard_bio(r10_bio);
>>> -               wait_barrier(conf);
>>> +               wait_barrier(conf, false);
>>>                  goto retry_discard;
>>>          }
>>>
>>> @@ -2011,7 +2044,7 @@ static void print_conf(struct r10conf *conf)
>>>
>>>   static void close_sync(struct r10conf *conf)
>>>   {
>>> -       wait_barrier(conf);
>>> +       wait_barrier(conf, false);
>>>          allow_barrier(conf);
>>>
>>>          mempool_exit(&conf->r10buf_pool);
>>> @@ -4819,7 +4852,7 @@ static sector_t reshape_request(struct mddev 
>>> *mddev, sector_t sector_nr,
>>>          if (need_flush ||
>>>              time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
>>>                  /* Need to update reshape_position in metadata */
>>> -               wait_barrier(conf);
>>> +               wait_barrier(conf, false);
>>>                  mddev->reshape_position = conf->reshape_progress;
>>>                  if (mddev->reshape_backwards)
>>>                          mddev->curr_resync_completed = 
>>> raid10_size(mddev, 0, 0)
>>> -- 
>>> 2.17.1
>>>
