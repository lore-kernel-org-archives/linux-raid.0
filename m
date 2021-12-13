Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B728C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 13 Dec 2021 23:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244217AbhLMXfa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Dec 2021 18:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244191AbhLMXfa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Dec 2021 18:35:30 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAED8C061574
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 15:35:29 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id 14so20938058ioe.2
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 15:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aH6+bnijsRiuEQBB90UdLGBJxVmFeY0kMEeq7Ffeh6s=;
        b=JhikysSkSZ+gVBTqCciOP6h4D7gk6h7jqV8Js+b8DsXcqclQvh98h3aRlc5gMzBh6O
         pWPrTg72MRwp5TExDaJjNGslI4FcK50RVhvA4yt6r3BP13WLO+nBPrg9tLAHFIv0oI1/
         xhHsBbEitSxurG53TyagqKIxrUEyzUuXEKF3oq83ZIw/3sXr1yB63EAKgelhLjSSSXaF
         +igUX0ONpHvfb0BUgfDb5fP0J6S90cFf9dXH63GkU1YMMleq/CKM/rkJAfwuhhZOl6s/
         6jxSHH96hxgfJsgQPHPRQaeUz9Tv9m9G5cSwzxckJ+06t0vHHt/T1Sq/eSzr9thtqxem
         ZR7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aH6+bnijsRiuEQBB90UdLGBJxVmFeY0kMEeq7Ffeh6s=;
        b=ymoP5NYQZBQP6N/Soy+jBnmE7ZnoMkiL31BNpNO2FZrjAPOlCC7HyVwSaYnHahdD1b
         6g87TsUiGHXwasvHq0SzE144zdHX3ugmTGy1t2KsfZIi9cX6/IsFeWhqk4a9rXhcq3SY
         TeChuo+C3mqeT5anWmP+ocMdVEtl4oTA1IrossluEy/60Pf2msTtaeINacN2YGBVVOQV
         trRORjgc3BYoYIE25lgxkW8w/gL73k7sRLPiJEUD3LZ9c2FLxeNoE+IXHXpY4qKPA4Ds
         a6OI0ombqqcjhrpFo0eVfyVM7IeWNvJUknDJbTeIBdLda+SGXsahmgK9saSTPu94zLZr
         BXVw==
X-Gm-Message-State: AOAM532v/sJu5lAxWqLY7b7EFSosSE8RhUYPHn439s1k+pfwo07HFwgp
        0wV71uE65xqKUEpS3T4hp+nkpWD5NEU43w==
X-Google-Smtp-Source: ABdhPJxJMSFoeR5/nt9jJ+qkJT7s0cQn+AK1JtJ/V2daOTgdQMOoR+8IF6lhkL+Z0LP6+xpC4s1u6A==
X-Received: by 2002:a05:6602:280f:: with SMTP id d15mr1300358ioe.150.1639438528889;
        Mon, 13 Dec 2021 15:35:28 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-2faa6b4da16sm133554173.33.2021.12.13.15.35.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 15:35:28 -0800 (PST)
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>, Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com>
 <20211110181441.9263-4-vverma@digitalocean.com>
 <CAPhsuW5drRBWOV9-i7cQWHAwSe5qHff5k23Y2-LsNGS_s8updw@mail.gmail.com>
 <2354ab61-0d13-aec5-a45f-23c5cd3db319@digitalocean.com>
 <CAPhsuW7r-JX+zOadzbzLDa0WxZdLws9=mTbPc0ci6qNfRBxgjA@mail.gmail.com>
 <998a933f-e3af-2f2c-79c6-ae5a75f286de@digitalocean.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b70fded5-8f65-7767-25c1-d45b1dcbbddf@kernel.dk>
Date:   Mon, 13 Dec 2021 16:35:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <998a933f-e3af-2f2c-79c6-ae5a75f286de@digitalocean.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/13/21 3:43 PM, Vishal Verma wrote:
> 
> On 12/12/21 10:56 PM, Song Liu wrote:
>> On Fri, Dec 10, 2021 at 10:26 AM Vishal Verma <vverma@digitalocean.com> wrote:
>>>
>>> On 12/9/21 7:16 PM, Song Liu wrote:
>>>> On Wed, Nov 10, 2021 at 10:15 AM Vishal Verma <vverma@digitalocean.com> wrote:
>>>>> Returns EAGAIN in case the raid456 driver would block
>>>>> waiting for situations like:
>>>>>
>>>>>     - Reshape operation,
>>>>>     - Discard operation.
>>>>>
>>>>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
>>>>> ---
>>>>>    drivers/md/raid5.c | 14 ++++++++++++++
>>>>>    1 file changed, 14 insertions(+)
>>>>>
>>>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>>>> index 9c1a5877cf9f..fa64ee315241 100644
>>>>> --- a/drivers/md/raid5.c
>>>>> +++ b/drivers/md/raid5.c
>>>>> @@ -5710,6 +5710,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
>>>>>                   int d;
>>>>>           again:
>>>>>                   sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0);
>>>>> +               /* Bail out if REQ_NOWAIT is set */
>>>>> +               if (bi->bi_opf & REQ_NOWAIT) {
>>>>> +                       bio_wouldblock_error(bi);
>>>>> +                       return;
>>>>> +               }
>>>> This is not right. raid5_get_active_stripe() gets refcount on the sh,
>>>> we cannot simply
>>>> return here. I think we need the logic after raid5_release_stripe()
>>>> and before schedule().
>>>>
>>>>>                   prepare_to_wait(&conf->wait_for_overlap, &w,
>>>>>                                   TASK_UNINTERRUPTIBLE);
>>>>>                   set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
>>>>> @@ -5820,6 +5825,15 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>>>>>           bi->bi_next = NULL;
>>>>>
>>>>>           md_account_bio(mddev, &bi);
>>>>> +       /* Bail out if REQ_NOWAIT is set */
>>>>> +       if (bi->bi_opf & REQ_NOWAIT &&
>>>>> +           conf->reshape_progress != MaxSector &&
>>>>> +           mddev->reshape_backwards
>>>>> +           ? logical_sector < conf->reshape_safe
>>>>> +           : logical_sector >= conf->reshape_safe) {
>>>>> +               bio_wouldblock_error(bi);
>>>>> +               return true;
>>>>> +       }
>>>> This is also problematic, and is the trigger of those error messages.
>>>> We only want to trigger -EAGAIN when logical_sector is between
>>>> reshape_progress and reshape_safe.
>>>>
>>>> Just to clarify, did you mean doing something like:
>>>> if (bi->bi_opf & REQ_NOWAIT &&
>>>> +           conf->reshape_progress != MaxSector &&
>>>> +           (mddev->reshape_backwards
>>>> +           ? (logical_sector > conf->reshape_progress && logical_sector < conf->reshape_safe)
>>>> +           : logical_sector >= conf->reshape_safe)) {
>> I think this should be
>>    :   (logical_sector >= conf->reshape_safe && logical_sector <
>> conf->reshape_progress)
> 
> 
> if (bi->bi_opf & REQ_NOWAIT &&
>                  conf->reshape_progress != MaxSector &&
>                  (mddev->reshape_backwards
>                  ? (logical_sector > conf->reshape_progress && 
> logical_sector <= conf->reshape_safe)
>                  : (logical_sector >= conf->reshape_safe && 
> logical_sector < conf->reshape_progress))) {
>                          bio_wouldblock_error(bi);
>                          return true;
>          }
> 
> After making this change along with other changes, I ran some tests with 
> 100% reads, 70%read30%writes and 100% writes on a clean raid5 array.
> 
> Unfortunately, I ran into this following task hung with 100% writes 
> (with both libaio and io_uring):
> 
> [21876.856692] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [21876.864518] task:md5_raid5       state:D stack:    0 pid:11675 
> ppid:     2 flags:0x00004000
> [21876.864522] Call Trace:
> [21876.864526]  __schedule+0x2d4/0x970
> [21876.864532]  ? wbt_cleanup_cb+0x20/0x20
> [21876.864535]  schedule+0x4e/0xb0
> [21876.864537]  io_schedule+0x3f/0x70
> [21876.864539]  rq_qos_wait+0xb9/0x130
> [21876.864542]  ? sysv68_partition+0x280/0x280
> [21876.864543]  ? wbt_cleanup_cb+0x20/0x20
> [21876.864545]  wbt_wait+0x92/0xc0
> [21876.864546]  __rq_qos_throttle+0x25/0x40
> [21876.864548]  blk_mq_submit_bio+0xc6/0x5d0
> [21876.864551]  ? submit_bio_checks+0x39e/0x5f0
> [21876.864554]  __submit_bio+0x1bc/0x1d0
> [21876.864555]  ? kmem_cache_free+0x378/0x3c0
> [21876.864558]  ? mempool_free_slab+0x17/0x20
> [21876.864562]  submit_bio_noacct+0x256/0x2a0
> [21876.864565]  0xffffffffc01fa6d9
> [21876.864568]  ? 0xffffffffc01f5d01
> [21876.864569]  raid5_get_active_stripe+0x16c0/0x3e00 [raid456]
> [21876.864571]  ? __wake_up_common_lock+0x8a/0xc0
> [21876.864575]  raid5_get_active_stripe+0x2839/0x3e00 [raid456]
> [21876.864577]  raid5_get_active_stripe+0x2d6e/0x3e00 [raid456]
> [21876.864579]  md_thread+0xae/0x170
> [21876.864581]  ? wait_woken+0x60/0x60
> [21876.864582]  ? md_start_sync+0x60/0x60
> [21876.864584]  kthread+0x127/0x150
> [21876.864586]  ? set_kthread_struct+0x40/0x40
> [21876.864588]  ret_from_fork+0x1f/0x30

What kernel base are you using for your patches?

-- 
Jens Axboe

