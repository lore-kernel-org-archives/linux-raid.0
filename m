Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBA5C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  9 Nov 2021 20:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A19BD610A8
	for <linux-raid@archiver.kernel.org>; Tue,  9 Nov 2021 20:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244843AbhKIVCn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 Nov 2021 16:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244824AbhKIVCm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 9 Nov 2021 16:02:42 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30238C061764
        for <linux-raid@vger.kernel.org>; Tue,  9 Nov 2021 12:59:56 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id t21so834568plr.6
        for <linux-raid@vger.kernel.org>; Tue, 09 Nov 2021 12:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:from:to:cc
         :references:in-reply-to:content-transfer-encoding;
        bh=8iRndmnXDDo+h6E5u+hLcOa1kwzrWCQUNwwIkNl5VL0=;
        b=EPBUHexIb7DRjQg5uUPbjM7JXWfBvjY1ooAD4vahaNS9Aj76hDe/lIPooLk/oIbaYR
         vXVuvBLmLsD7QNryOySv1I4A1gwdAbjPVWQ80mrEZJked+g34Q+G/OXBcK0auC6tn+2V
         UdmOePvZW/56BEv0XHDMUhk/LdUWqlhCHBRoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=8iRndmnXDDo+h6E5u+hLcOa1kwzrWCQUNwwIkNl5VL0=;
        b=egGB2X95pSn/1lLkw2xO252f+5Pee7AKSfr+qR9De0xZBjSZGYRaFw9gZ55Yv+e+E2
         tjeD+NrDOYcL5VJhyHHMA56xJvd74KPvRMdZLJl2JSbQww6f8JHFaP/o01N/5lSsjxcu
         EDETVjwXoehJcmtVXcDqcu9UZlBvo0ZEw/PXIPGL6iZFHcvxU6t065O3nodgcCbcYuBb
         LVrbtdy2cI+Kr7yTsoosYc3m254aGaniitMEKzO1FfKjqLE974gSdDOmsn/vlTzrGlVS
         4gLbX2zfynsGzYmqU3Vc+s8TePh47zcHMDRkw+3VTv66kSwHfjk7dr3FrXx5TCVuByQ0
         zljg==
X-Gm-Message-State: AOAM5320CCHf5lzH+WZ9ljgUVuSPxXQx6PrUdSf+PKHgsR3BmTNA/jME
        2u1/MgPMzOuj4RInXyw4omDUmDIeJx6eeg==
X-Google-Smtp-Source: ABdhPJyP/TJMIyQykLMu0em5LcEHe0lzrrK+byHurB1aavKABsWBg5IQBH04GpOErT99cz031Vt7Lw==
X-Received: by 2002:a17:902:7001:b0:141:67d3:adc6 with SMTP id y1-20020a170902700100b0014167d3adc6mr10012196plk.65.1636491595448;
        Tue, 09 Nov 2021 12:59:55 -0800 (PST)
Received: from [172.16.224.166] (wsip-174-76-37-175.ph.ph.cox.net. [174.76.37.175])
        by smtp.gmail.com with ESMTPSA id y190sm9145143pfg.153.2021.11.09.12.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 12:59:54 -0800 (PST)
Message-ID: <4d0dd51b-9176-99df-2002-77ecf48c6d20@digitalocean.com>
Date:   Tue, 9 Nov 2021 13:59:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v3 2/2] md: raid1 add nowait support
From:   Vishal Verma <vverma@digitalocean.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
References: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
 <20211104045149.9599-1-vverma@digitalocean.com>
 <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <97bff08e-ecb7-37d7-c113-7f33bfca02d9@digitalocean.com>
In-Reply-To: <97bff08e-ecb7-37d7-c113-7f33bfca02d9@digitalocean.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

I did modify raid456 and raid10 with nowait support, but unfortunately 
have been running into kernel task hung and panics while doing write IO 
and having hard time trying to debug.

Shall I post the patches in to get the feedback or go with an 
alternative route to have a flag to only enable nowait for raid1 for now?

Thanks,

Vishal

On 11/8/21 3:39 PM, Vishal Verma wrote:
>
> On 11/8/21 3:32 PM, Song Liu wrote:
>> On Wed, Nov 3, 2021 at 9:52 PM Vishal Verma <vverma@digitalocean.com> 
>> wrote:
>>> This adds nowait support to the RAID1 driver. It makes RAID1 driver
>>> return with EAGAIN for situations where it could wait for eg:
>>>
>>>    - Waiting for the barrier,
>>>    - Array got frozen,
>>>    - Too many pending I/Os to be queued.
>>>
>>> wait_barrier() fn is modified to return bool to support error for
>>> wait barriers. It returns true in case of wait or if wait is not
>>> required and returns false if wait was required but not performed
>>> to support nowait.
>>>
>>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
>>> ---
>>>   drivers/md/raid1.c | 74 
>>> +++++++++++++++++++++++++++++++++++-----------
>>>   1 file changed, 57 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index 7dc8026cf6ee..2e191fc2147b 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -929,8 +929,9 @@ static void lower_barrier(struct r1conf *conf, 
>>> sector_t sector_nr)
>>>          wake_up(&conf->wait_barrier);
>>>   }
>>>
>>> -static void _wait_barrier(struct r1conf *conf, int idx)
>>> +static bool _wait_barrier(struct r1conf *conf, int idx, bool nowait)
>>>   {
>>> +       bool ret = true;
>>>          /*
>>>           * We need to increase conf->nr_pending[idx] very early here,
>>>           * then raise_barrier() can be blocked when it waits for
>>> @@ -961,7 +962,7 @@ static void _wait_barrier(struct r1conf *conf, 
>>> int idx)
>>>           */
>>>          if (!READ_ONCE(conf->array_frozen) &&
>>>              !atomic_read(&conf->barrier[idx]))
>>> -               return;
>>> +               return ret;
>>>
>>>          /*
>>>           * After holding conf->resync_lock, conf->nr_pending[idx]
>>> @@ -979,18 +980,27 @@ static void _wait_barrier(struct r1conf *conf, 
>>> int idx)
>>>           */
>>>          wake_up(&conf->wait_barrier);
>>>          /* Wait for the barrier in same barrier unit bucket to 
>>> drop. */
>>> -       wait_event_lock_irq(conf->wait_barrier,
>>> -                           !conf->array_frozen &&
>>> - !atomic_read(&conf->barrier[idx]),
>>> -                           conf->resync_lock);
>>> +       if (conf->array_frozen || atomic_read(&conf->barrier[idx])) {
>>> +               /* Return false when nowait flag is set */
>>> +               if (nowait)
>>> +                       ret = false;
>>> +               else {
>>> + wait_event_lock_irq(conf->wait_barrier,
>>> +                                       !conf->array_frozen &&
>>> + !atomic_read(&conf->barrier[idx]),
>>> +                                       conf->resync_lock);
>>> +               }
>>> +       }
>>>          atomic_inc(&conf->nr_pending[idx]);
>>>          atomic_dec(&conf->nr_waiting[idx]);
>>>          spin_unlock_irq(&conf->resync_lock);
>>> +       return ret;
>>>   }
>>>
>>> -static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
>>> +static bool wait_read_barrier(struct r1conf *conf, sector_t 
>>> sector_nr, bool nowait)
>>>   {
>>>          int idx = sector_to_idx(sector_nr);
>>> +       bool ret = true;
>>>
>>>          /*
>>>           * Very similar to _wait_barrier(). The difference is, for 
>>> read
>>> @@ -1002,7 +1012,7 @@ static void wait_read_barrier(struct r1conf 
>>> *conf, sector_t sector_nr)
>>>          atomic_inc(&conf->nr_pending[idx]);
>>>
>>>          if (!READ_ONCE(conf->array_frozen))
>>> -               return;
>>> +               return ret;
>>>
>>>          spin_lock_irq(&conf->resync_lock);
>>>          atomic_inc(&conf->nr_waiting[idx]);
>>> @@ -1013,19 +1023,27 @@ static void wait_read_barrier(struct r1conf 
>>> *conf, sector_t sector_nr)
>>>           */
>>>          wake_up(&conf->wait_barrier);
>>>          /* Wait for array to be unfrozen */
>>> -       wait_event_lock_irq(conf->wait_barrier,
>>> -                           !conf->array_frozen,
>>> -                           conf->resync_lock);
>>> +       if (conf->array_frozen || atomic_read(&conf->barrier[idx])) {
>>> +               if (nowait)
>>> +                       /* Return false when nowait flag is set */
>>> +                       ret = false;
>>> +               else {
>>> + wait_event_lock_irq(conf->wait_barrier,
>>> + !conf->array_frozen,
>>> +                                       conf->resync_lock);
>>> +               }
>>> +       }
>>>          atomic_inc(&conf->nr_pending[idx]);
>>>          atomic_dec(&conf->nr_waiting[idx]);
>>>          spin_unlock_irq(&conf->resync_lock);
>>> +       return ret;
>>>   }
>>>
>>> -static void wait_barrier(struct r1conf *conf, sector_t sector_nr)
>>> +static bool wait_barrier(struct r1conf *conf, sector_t sector_nr, 
>>> bool nowait)
>>>   {
>>>          int idx = sector_to_idx(sector_nr);
>>>
>>> -       _wait_barrier(conf, idx);
>>> +       return _wait_barrier(conf, idx, nowait);
>>>   }
>>>
>>>   static void _allow_barrier(struct r1conf *conf, int idx)
>>> @@ -1236,7 +1254,11 @@ static void raid1_read_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>           * Still need barrier for READ in case that whole
>>>           * array is frozen.
>>>           */
>>> -       wait_read_barrier(conf, bio->bi_iter.bi_sector);
>>> +       if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
>>> +                               bio->bi_opf & REQ_NOWAIT)) {
>>> +               bio_wouldblock_error(bio);
>>> +               return;
>>> +       }
>>>
>>>          if (!r1_bio)
>>>                  r1_bio = alloc_r1bio(mddev, bio);
>>> @@ -1336,6 +1358,10 @@ static void raid1_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>                       bio->bi_iter.bi_sector, bio_end_sector(bio))) {
>>>
>>>                  DEFINE_WAIT(w);
>>> +               if (bio->bi_opf & REQ_NOWAIT) {
>>> +                       bio_wouldblock_error(bio);
>>> +                       return;
>>> +               }
>>>                  for (;;) {
>>> prepare_to_wait(&conf->wait_barrier,
>>>                                          &w, TASK_IDLE);
>>> @@ -1353,17 +1379,26 @@ static void raid1_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>           * thread has put up a bar for new requests.
>>>           * Continue immediately if no resync is active currently.
>>>           */
>>> -       wait_barrier(conf, bio->bi_iter.bi_sector);
>>> +       if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
>> We change wait_barrier to wait_read_barrier here, I guess this is a 
>> typo?
>>
>> Please include changes in raid10 and raid456 (or don't set 
>> QUEUE_FLAG_NOWAIT
>> for these personalities) and resend the patch. We will target it for
>> the next merge
>> window (5.17).
>>
>> Thanks,
>> Song
>>
>> Thanks Song. I am almost done with the raid10 change and will do the
>> raid456 soon and resend.
>>> + bio->bi_opf & REQ_NOWAIT)) {
>>> +               bio_wouldblock_error(bio);
>>> +               return;
>>> +       }
>>>
>>>          r1_bio = alloc_r1bio(mddev, bio);
>>>          r1_bio->sectors = max_write_sectors;
>>>
>>>          if (conf->pending_count >= max_queued_requests) {
>>>                  md_wakeup_thread(mddev->thread);
>>> +               if (bio->bi_opf & REQ_NOWAIT) {
>>> +                       bio_wouldblock_error(bio);
>>> +                       return;
>>> +               }
>>>                  raid1_log(mddev, "wait queued");
>>>                  wait_event(conf->wait_barrier,
>>>                             conf->pending_count < max_queued_requests);
>>>          }
>>> +
>>>          /* first select target devices under rcu_lock and
>>>           * inc refcount on their rdev.  Record them by setting
>>>           * bios[x] to bio
>>> @@ -1458,9 +1493,14 @@ static void raid1_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>> rdev_dec_pending(conf->mirrors[j].rdev, mddev);
>>>                  r1_bio->state = 0;
>>>                  allow_barrier(conf, bio->bi_iter.bi_sector);
>>> +
>>> +               if (bio->bi_opf & REQ_NOWAIT) {
>>> +                       bio_wouldblock_error(bio);
>>> +                       return;
>>> +               }
>>>                  raid1_log(mddev, "wait rdev %d blocked", 
>>> blocked_rdev->raid_disk);
>>>                  md_wait_for_blocked_rdev(blocked_rdev, mddev);
>>> -               wait_barrier(conf, bio->bi_iter.bi_sector);
>>> +               wait_barrier(conf, bio->bi_iter.bi_sector, false);
>>>                  goto retry_write;
>>>          }
>>>
>>> @@ -1687,7 +1727,7 @@ static void close_sync(struct r1conf *conf)
>>>          int idx;
>>>
>>>          for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++) {
>>> -               _wait_barrier(conf, idx);
>>> +               _wait_barrier(conf, idx, false);
>>>                  _allow_barrier(conf, idx);
>>>          }
>>>
>>> -- 
>>> 2.17.1
>>>
