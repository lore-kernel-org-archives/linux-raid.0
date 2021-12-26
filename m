Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B92C433F5
	for <linux-raid@archiver.kernel.org>; Sun, 26 Dec 2021 21:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbhLZVU2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Dec 2021 16:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234426AbhLZVU1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Dec 2021 16:20:27 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7747AC06173E
        for <linux-raid@vger.kernel.org>; Sun, 26 Dec 2021 13:20:27 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gj24so12011491pjb.0
        for <linux-raid@vger.kernel.org>; Sun, 26 Dec 2021 13:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:from:to:cc
         :references:in-reply-to:content-transfer-encoding;
        bh=GYwbvVEpNUUtaas6uoHBNio2Xb35CQ9oUsAZwDvJEnE=;
        b=VGkYQ8Vppds64TacCBXNKFqnEDrmURwzwuwm0AAaRZ1d2oVRvn7822it/zOspm3r9H
         UvHIArQCeXAflHjrdaMcUwdT6RWL9THC3EErM3zTj0Vjq7FOW1dSZ3gNFpeOFueqnPc4
         z5O/XjZJSagdYtkZU21kJDYQk6J+dkwxyab9k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=GYwbvVEpNUUtaas6uoHBNio2Xb35CQ9oUsAZwDvJEnE=;
        b=z3LZCZhZx1n5NExU1bZeonY+MMxi3gAGS/W3gUpe4M0QvKFFA6pnUifgt6hc3Sjq6L
         DHGmRcD80uIV3Sun32XQsAQGUEiAJ9ioMkrKryLcWv4d9+d/o7AuzqPIUmcsqR97hq4Z
         LbIg2tzVXVn2t0kKfTSWekCxpHhZQcTwMq2qahQ8UpLXl8ul9coZ9fX4sA9r7q+bBUOW
         DEaHZ52YBOHULFcPYGKH/tAYds/8D7ATn2egyNwOxH6I2Q7kSsI2QiUhB7wA0qF/U/nz
         t6m//UwtuKih7iFUKHkU+P0gwAZq5vL9QQBRff6oylJYsW/60APDldKdC+X1E7S+8MBF
         aS6A==
X-Gm-Message-State: AOAM532TMP9E2DgAYLJ4R9umsO5uGXQAIL73CDPlWiuXdn2sijoN5AEB
        eVAfekV69oPIixelWnCkkMi8pA==
X-Google-Smtp-Source: ABdhPJztPsG9JL8kQNUEBntKSdy6GvIFPcx2FIfE5O5gT7FSAu+MjQBa54nHtgxBOjgVAiUYBy3+hQ==
X-Received: by 2002:a17:903:2285:b0:148:d5d0:5bdf with SMTP id b5-20020a170903228500b00148d5d05bdfmr14631981plh.108.1640553626789;
        Sun, 26 Dec 2021 13:20:26 -0800 (PST)
Received: from [192.168.1.4] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id my5sm15136580pjb.5.2021.12.26.13.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Dec 2021 13:20:25 -0800 (PST)
Message-ID: <30463c91-f07b-ec4a-a519-1a2bf13c4242@digitalocean.com>
Date:   Sun, 26 Dec 2021 14:20:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v6 4/4] md: raid456 add nowait support
From:   Vishal Verma <vverma@digitalocean.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rgoldwyn@suse.de
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com>
 <20211221200622.29795-4-vverma@digitalocean.com>
 <CAPhsuW6ugK+6fcA9d4Jkx8+i9=1cMfrfJE7ZY4WH6TKrWLxP=g@mail.gmail.com>
 <aadc6d52-bc6e-527a-3b9c-0be225f9b727@digitalocean.com>
 <3306ef8e-88e0-74ec-4f7f-efca2605fc24@digitalocean.com>
 <CAPhsuW5m69F19w85N67WGSZfTgPfkgQv0zhYk7uGXwzkoAJh_w@mail.gmail.com>
 <b80a0898-af7f-ec1b-9f4e-6d24cdb2e38a@digitalocean.com>
In-Reply-To: <b80a0898-af7f-ec1b-9f4e-6d24cdb2e38a@digitalocean.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/25/21 9:02 PM, Vishal Verma wrote:
>
> On 12/25/21 5:07 PM, Song Liu wrote:
>> On Sat, Dec 25, 2021 at 2:13 PM Vishal Verma 
>> <vverma@digitalocean.com> wrote:
>>>
>>> On 12/25/21 12:28 AM, Vishal Verma wrote:
>>>>
>>>> On 12/24/21 7:14 PM, Song Liu wrote:
>>>>> On Tue, Dec 21, 2021 at 12:06 PM Vishal 
>>>>> Verma<vverma@digitalocean.com>  wrote:
>>>>>> Returns EAGAIN in case the raid456 driver would block
>>>>>> waiting for situations like:
>>>>>>
>>>>>>     - Reshape operation,
>>>>>>     - Discard operation.
>>>>>>
>>>>>> Signed-off-by: Vishal Verma<vverma@digitalocean.com>
>>>>> I think we will need the following fix for raid456:
>>>> Ack
>>>>> ============================ 8< ============================
>>>>>
>>>>> diff --git i/drivers/md/raid5.c w/drivers/md/raid5.c
>>>>> index 6ab22f29dacd..55d372ce3300 100644
>>>>> --- i/drivers/md/raid5.c
>>>>> +++ w/drivers/md/raid5.c
>>>>> @@ -5717,6 +5717,7 @@ static void make_discard_request(struct mddev
>>>>> *mddev, struct bio *bi)
>>>>>                           raid5_release_stripe(sh);
>>>>>                           /* Bail out if REQ_NOWAIT is set */
>>>>>                           if (bi->bi_opf & REQ_NOWAIT) {
>>>>> + finish_wait(&conf->wait_for_overlap, &w);
>>>>> bio_wouldblock_error(bi);
>>>>>                                   return;
>>>>>                           }
>>>>> @@ -5734,6 +5735,7 @@ static void make_discard_request(struct mddev
>>>>> *mddev, struct bio *bi)
>>>>> raid5_release_stripe(sh);
>>>>>                                   /* Bail out if REQ_NOWAIT is set */
>>>>>                                   if (bi->bi_opf & REQ_NOWAIT) {
>>>>> +
>>>>> finish_wait(&conf->wait_for_overlap, &w);
>>>>> bio_wouldblock_error(bi);
>>>>>                                           return;
>>>>>                                   }
>>>>> @@ -5829,7 +5831,6 @@ static bool raid5_make_request(struct mddev
>>>>> *mddev, struct bio * bi)
>>>>>           last_sector = bio_end_sector(bi);
>>>>>           bi->bi_next = NULL;
>>>>>
>>>>> -       md_account_bio(mddev, &bi);
>>>>>           /* Bail out if REQ_NOWAIT is set */
>>>>>           if ((bi->bi_opf & REQ_NOWAIT) &&
>>>>>               (conf->reshape_progress != MaxSector) &&
>>>>> @@ -5837,9 +5838,11 @@ static bool raid5_make_request(struct mddev
>>>>> *mddev, struct bio * bi)
>>>>>               ? (logical_sector > conf->reshape_progress &&
>>>>> logical_sector <= conf->reshape_safe)
>>>>>               : (logical_sector >= conf->reshape_safe && 
>>>>> logical_sector
>>>>> < conf->reshape_progress))) {
>>>>>                   bio_wouldblock_error(bi);
>>>>> +               if (rw == WRITE)
>>>>> +                       md_write_end(mddev);
>>>>>                   return true;
>>>>>           }
>>>>> -
>>>>> +       md_account_bio(mddev, &bi);
>>>>>           prepare_to_wait(&conf->wait_for_overlap, &w, 
>>>>> TASK_UNINTERRUPTIBLE);
>>>>>           for (; logical_sector < last_sector; logical_sector +=
>>>>> RAID5_STRIPE_SECTORS(conf)) {
>>>>>                   int previous;
>>>>>
>>>>> ============================ 8< ============================
>>>>>
>>>>> Vishal, please try to trigger all these conditions (including raid1,
>>>>> raid10) and make sure
>>>>> they work properly.
>>>>>
>>>>> For example, I triggered raid5 reshape and used something like the
>>>>> following to make
>>>>> sure the logic is triggered:
>>>>>
>>>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>>>> index 55d372ce3300..e79de48a0027 100644
>>>>> --- a/drivers/md/raid5.c
>>>>> +++ b/drivers/md/raid5.c
>>>>> @@ -5840,6 +5840,11 @@ static bool raid5_make_request(struct mddev
>>>>> *mddev, struct bio * bi)
>>>>>                   bio_wouldblock_error(bi);
>>>>>                   if (rw == WRITE)
>>>>>                           md_write_end(mddev);
>>>>> +               {
>>>>> +                       static int count = 0;
>>>>> +                       if (count++ < 10)
>>>>> +                               pr_info("%s REQ_NOWAIT return\n", 
>>>>> __func__);
>>>>> +               }
>>>>>                   return true;
>>>>>           }
>>>>>           md_account_bio(mddev, &bi);
>>>>>
>>>>> Thanks,
>>>>> Song
>>>>>
>>>> Sure, will try this and verify for raid1/10.
>> Please also try test raid5 with discard. I haven't tested those two
>> conditions yet.
> Ack.

Do you have suggestion around how to test this. As in use fstrim or 
something
to issue discard op to the raid5 array?

>>
>>> I am running into an issue during raid10 reshape. I can see the nowait
>>> code getting triggered during reshape, but it seems like the reshape
>>> operation was stuck as soon as I issued write IO using FIO to the array
>>> during reshape.
>>> FIO also seem stuck i.e no IO went through...
>> Maybe the following could fix it?
>>
>> Thanks,
>> Song
> Hmm no luck, still the same issue.
It seems both: iou-wrk thread & md_reshape thread are hung during reshape..

[  247.889279] task:iou-wrk-9013    state:D stack:    0 pid: 9088 ppid:  
8869 flags:0x00004000
[  247.889282] Call Trace:
[  247.889284]  <TASK>
[  247.889286]  __schedule+0x2d5/0x9b0
[  247.889292]  ? preempt_count_add+0x74/0xc0
[  247.889295]  schedule+0x58/0xd0
[  247.889298]  wait_barrier+0x1ad/0x270 [raid10]
[  247.889301]  ? wait_woken+0x60/0x60
[  247.889304]  regular_request_wait+0x42/0x1e0 [raid10]
[  247.889306]  ? default_wake_function+0x1a/0x30
[  247.889308]  ? autoremove_wake_function+0x12/0x40
[  247.889310]  raid10_write_request+0x85/0x670 [raid10]
[  247.889312]  ? r10bio_pool_alloc+0x26/0x30 [raid10]
[  247.889314]  ? md_write_start+0xa7/0x270
[  247.889318]  raid10_make_request+0xe8/0x170 [raid10]
[  247.889320]  md_handle_request+0x13d/0x1d0
[  247.889322]  ? submit_bio_checks+0x1f6/0x5a0
[  247.889325]  md_submit_bio+0x6d/0xa0
[  247.889326]  __submit_bio+0x94/0x140
[  247.889327]  submit_bio_noacct+0xe1/0x2a0
[  247.889329]  submit_bio+0x48/0x120
[  247.889330]  blkdev_direct_IO+0x19b/0x540
[  247.889332]  ? hctx_unlock+0x17/0x40
[  247.889335]  ? blk_mq_request_issue_directly+0x57/0x80
[  247.889338]  generic_file_direct_write+0x9f/0x190
[  247.889342]  __generic_file_write_iter+0x9d/0x1c0
[  247.889345]  blkdev_write_iter+0xe7/0x160
[  247.889347]  io_write+0x153/0x300
[  247.889350]  ? __this_cpu_preempt_check+0x13/0x20
[  247.889352]  ? __perf_event_task_sched_in+0x81/0x230
[  247.889355]  ? debug_smp_processor_id+0x17/0x20
[  247.889356]  ? __perf_event_task_sched_out+0x77/0x510
[  247.889359]  io_issue_sqe+0x387/0x19c0
[  247.889361]  ? _raw_spin_lock_irqsave+0x1d/0x50
[  247.889363]  ? lock_timer_base+0x72/0xa0
[  247.889367]  io_wq_submit_work+0x67/0x170
[  247.889369]  io_worker_handle_work+0x2b0/0x500
[  247.889372]  io_wqe_worker+0x1ca/0x360
[  247.889374]  ? _raw_spin_unlock+0x1a/0x30
[  247.889376]  ? preempt_count_add+0x74/0xc0
[  247.889377]  ? io_workqueue_create+0x60/0x60
[  247.889380]  ret_from_fork+0x1f/0x30

[  247.908367] task:md5_reshape     state:D stack:    0 pid: 9087 
ppid:     2 flags:0x00004000
[  247.908369] Call Trace:
[  247.908370]  <TASK>
[  247.908371]  __schedule+0x2d5/0x9b0
[  247.908373]  schedule+0x58/0xd0
[  247.908375]  raise_barrier+0xb7/0x170 [raid10]
[  247.908377]  ? wait_woken+0x60/0x60
[  247.908378]  reshape_request+0x1b9/0x920 [raid10]
[  247.908380]  ? __this_cpu_preempt_check+0x13/0x20
[  247.908382]  ? __perf_event_task_sched_in+0x81/0x230
[  247.908384]  raid10_sync_request+0x1073/0x1640 [raid10]
[  247.908386]  ? _raw_spin_unlock+0x1a/0x30
[  247.908388]  ? __switch_to+0x12e/0x430
[  247.908390]  ? __schedule+0x2dd/0x9b0
[  247.908392]  ? blk_flush_plug+0xeb/0x120
[  247.908393]  ? preempt_count_add+0x74/0xc0
[  247.908394]  ? _raw_spin_lock_irqsave+0x1d/0x50
[  247.908396]  md_do_sync.cold+0x3fa/0x97f
[  247.908399]  ? wait_woken+0x60/0x60
[  247.908401]  md_thread+0xae/0x170
[  247.908402]  ? preempt_count_add+0x74/0xc0
[  247.908403]  ? _raw_spin_lock_irqsave+0x1d/0x50
[  247.908405]  kthread+0x177/0x1a0
[  247.908407]  ? md_start_sync+0x60/0x60
[  247.908408]  ? set_kthread_struct+0x40/0x40
[  247.908410]  ret_from_fork+0x1f/0x30
[  247.908412]  </TASK>

>> diff --git i/drivers/md/raid10.c w/drivers/md/raid10.c
>> index e2c524d50ec0..291eceaeb26c 100644
>> --- i/drivers/md/raid10.c
>> +++ w/drivers/md/raid10.c
>> @@ -1402,14 +1402,14 @@ static void raid10_write_request(struct mddev
>> *mddev, struct bio *bio,
>>               : (bio->bi_iter.bi_sector + sectors > 
>> conf->reshape_safe &&
>>                  bio->bi_iter.bi_sector < conf->reshape_progress))) {
>>                  /* Need to update reshape_position in metadata */
>> -               mddev->reshape_position = conf->reshape_progress;
>> -               set_mask_bits(&mddev->sb_flags, 0,
>> -                             BIT(MD_SB_CHANGE_DEVS) |
>> BIT(MD_SB_CHANGE_PENDING));
>> -               md_wakeup_thread(mddev->thread);
>>                  if (bio->bi_opf & REQ_NOWAIT) {
>>                          bio_wouldblock_error(bio);
>>                          return;
>>                  }
>> +               mddev->reshape_position = conf->reshape_progress;
>> +               set_mask_bits(&mddev->sb_flags, 0,
>> +                             BIT(MD_SB_CHANGE_DEVS) |
>> BIT(MD_SB_CHANGE_PENDING));
>> +               md_wakeup_thread(mddev->thread);
>>                  raid10_log(conf->mddev, "wait reshape metadata");
>>                  wait_event(mddev->sb_wait,
>>                             !test_bit(MD_SB_CHANGE_PENDING, 
>> &mddev->sb_flags));
