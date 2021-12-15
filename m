Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A66C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 22:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhLOWUL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Dec 2021 17:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbhLOWUK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Dec 2021 17:20:10 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5371AC061574
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 14:20:10 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y7so17799149plp.0
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 14:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=hq3aa3/mR0XPG37OLEWCn2wsiiRrpPikP/IwjX+pfro=;
        b=UQku9easbvzNuRVjT2bRtwJmWOYoAp9JF++DZ7SvuUTvV4c4PBuny+oQ5e/3Mfl2k+
         nk6neX+0n0SDlK7TgNxZJA0XRQX4WtFbEE/dqV87mhlP+ktJJMKqdGIvRM1P+wf4jqzG
         BOMYqwh9Q82ENirctlkWakYj4Y0EYgCl25LdI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hq3aa3/mR0XPG37OLEWCn2wsiiRrpPikP/IwjX+pfro=;
        b=2ihUOs4hSn03/o9xAbljtSIUe9eximQN1cO7eZfzNDYL8+9yjqQULTf3xKJzajNNpc
         nbkOHtQWXW1h+wxxlyssPamIRhOV1RFb6sOnIzcITy7d0ODpM7irHA4IVK8JSFtt/BG2
         VOclrhNieW9rMVW2hMHJa49Gq/Wdns24HFH3sDdtLa+jqQd0VvevWsPpOnVNe3VcxJKP
         Hht8T2tZ3J34j5bjK+c2tlZU5SLwrDT604Uyhq44Ia1CeaMlb5/Ayw9w/k6veFT/mzb2
         WL8ldu39Jpf0cpSlwH0bZlueWoID0lVrHq5KIS3tKPrljpsogu4Hk1zKrkrJ9SkuR/8r
         jswg==
X-Gm-Message-State: AOAM5321GiuMRMKlJTXTiumT0pZOTQfs38Df3eIUVigfpbOPSaPXiUYj
        zS6yXK3DhoNTRDwJfP4TTXyka2HwkI8b+gk/
X-Google-Smtp-Source: ABdhPJxZrZAp+nguvDID/8DwdvZQLBjifRq4YVUCOYcxR3VSbJmWvL7/DDE0sPClRRAHdiTlN20acw==
X-Received: by 2002:a17:90b:350c:: with SMTP id ls12mr2217313pjb.197.1639606809559;
        Wed, 15 Dec 2021 14:20:09 -0800 (PST)
Received: from [192.168.1.5] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id c21sm3686813pfl.138.2021.12.15.14.20.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 14:20:09 -0800 (PST)
Message-ID: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
Date:   Wed, 15 Dec 2021 15:20:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v5 2/4] md: raid1 add nowait support
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rgoldwyn@suse.de
References: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
 <20211215060906.3230-1-vverma@digitalocean.com>
 <20211215060906.3230-2-vverma@digitalocean.com>
 <CAPhsuW5vrMcyMHXNyyFUkzdHnWAGs+WUSLwkrrpyt81Bu3ap2g@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW5vrMcyMHXNyyFUkzdHnWAGs+WUSLwkrrpyt81Bu3ap2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/15/21 1:33 PM, Song Liu wrote:
> On Tue, Dec 14, 2021 at 10:09 PM Vishal Verma <vverma@digitalocean.com> wrote:
>> This adds nowait support to the RAID1 driver. It makes RAID1 driver
>> return with EAGAIN for situations where it could wait for eg:
>>
>> - Waiting for the barrier,
>> - Array got frozen,
>> - Too many pending I/Os to be queued.
>>
>> wait_barrier() fn is modified to return bool to support error for
>> wait barriers. It returns true in case of wait or if wait is not
>> required and returns false if wait was required but not performed
>> to support nowait.
> Please see some detailed comments below. But a general and more important
> question: were you able to trigger these conditions (path that lead to
> bio_wouldblock_error) in the tests?
>
> Ideally, we should test all these conditions. If something is really
> hard to trigger,
> please highlight that in the commit log, so that I can run more tests on them.
>
> Thanks,
> Song
>
>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
>> ---
>>   drivers/md/raid1.c | 74 +++++++++++++++++++++++++++++++++++-----------
>>   1 file changed, 57 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 7dc8026cf6ee..727d31de5694 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -929,8 +929,9 @@ static void lower_barrier(struct r1conf *conf, sector_t sector_nr)
>>          wake_up(&conf->wait_barrier);
>>   }
>>
>> -static void _wait_barrier(struct r1conf *conf, int idx)
>> +static bool _wait_barrier(struct r1conf *conf, int idx, bool nowait)
>>   {
>> +       bool ret = true;
>>          /*
>>           * We need to increase conf->nr_pending[idx] very early here,
>>           * then raise_barrier() can be blocked when it waits for
>> @@ -961,7 +962,7 @@ static void _wait_barrier(struct r1conf *conf, int idx)
>>           */
>>          if (!READ_ONCE(conf->array_frozen) &&
>>              !atomic_read(&conf->barrier[idx]))
>> -               return;
>> +               return ret;
>>
>>          /*
>>           * After holding conf->resync_lock, conf->nr_pending[idx]
>> @@ -979,18 +980,27 @@ static void _wait_barrier(struct r1conf *conf, int idx)
>>           */
>>          wake_up(&conf->wait_barrier);
>>          /* Wait for the barrier in same barrier unit bucket to drop. */
>> -       wait_event_lock_irq(conf->wait_barrier,
>> -                           !conf->array_frozen &&
>> -                            !atomic_read(&conf->barrier[idx]),
>> -                           conf->resync_lock);
>> +       if (conf->array_frozen || atomic_read(&conf->barrier[idx])) {
> Do we really need this check?
This was done when looking at the wait_event_lock_irq conditions.
I am not very sure about this.
>> +               /* Return false when nowait flag is set */
>> +               if (nowait)
>> +                       ret = false;
>> +               else {
>> +                       wait_event_lock_irq(conf->wait_barrier,
>> +                                       !conf->array_frozen &&
>> +                                       !atomic_read(&conf->barrier[idx]),
>> +                                       conf->resync_lock);
>> +               }
>> +       }
>>          atomic_inc(&conf->nr_pending[idx]);
> Were you able to trigger the condition in the tests? I think we should
> only increase
> nr_pending for ret == true. Otherwise, we will leak a nr_pending.
No I wasn't able to. Makes sense about nr_pending. Thanks for catching.
>
>>          atomic_dec(&conf->nr_waiting[idx]);
>>          spin_unlock_irq(&conf->resync_lock);
>> +       return ret;
>>   }
>>
>> -static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
>> +static bool wait_read_barrier(struct r1conf *conf, sector_t sector_nr, bool nowait)
>>   {
>>          int idx = sector_to_idx(sector_nr);
>> +       bool ret = true;
>>
>>          /*
>>           * Very similar to _wait_barrier(). The difference is, for read
>> @@ -1002,7 +1012,7 @@ static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
>>          atomic_inc(&conf->nr_pending[idx]);
>>
>>          if (!READ_ONCE(conf->array_frozen))
>> -               return;
>> +               return ret;
>>
>>          spin_lock_irq(&conf->resync_lock);
>>          atomic_inc(&conf->nr_waiting[idx]);
>> @@ -1013,19 +1023,27 @@ static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
>>           */
>>          wake_up(&conf->wait_barrier);
>>          /* Wait for array to be unfrozen */
>> -       wait_event_lock_irq(conf->wait_barrier,
>> -                           !conf->array_frozen,
>> -                           conf->resync_lock);
>> +       if (conf->array_frozen || atomic_read(&conf->barrier[idx])) {
> I guess we don't need this either. Also, the condition there is not identical
> to wait_barrier (no need to check conf->barrier[idx]).
OK
>> +               if (nowait)
>> +                       /* Return false when nowait flag is set */
>> +                       ret = false;
>> +               else {
>> +                       wait_event_lock_irq(conf->wait_barrier,
>> +                                       !conf->array_frozen,
>> +                                       conf->resync_lock);
>> +               }
>> +       }
>>          atomic_inc(&conf->nr_pending[idx]);
> ditto on nr_pending.
OK
>
>>          atomic_dec(&conf->nr_waiting[idx]);
>>          spin_unlock_irq(&conf->resync_lock);
>> +       return ret;
>>   }
>>
>> -static void wait_barrier(struct r1conf *conf, sector_t sector_nr)
>> +static bool wait_barrier(struct r1conf *conf, sector_t sector_nr, bool nowait)
>>   {
>>          int idx = sector_to_idx(sector_nr);
>>
>> -       _wait_barrier(conf, idx);
>> +       return _wait_barrier(conf, idx, nowait);
>>   }
>>
>>   static void _allow_barrier(struct r1conf *conf, int idx)
>> @@ -1236,7 +1254,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>>           * Still need barrier for READ in case that whole
>>           * array is frozen.
>>           */
>> -       wait_read_barrier(conf, bio->bi_iter.bi_sector);
>> +       if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
>> +                               bio->bi_opf & REQ_NOWAIT)) {
>> +               bio_wouldblock_error(bio);
>> +               return;
>> +       }
>>
>>          if (!r1_bio)
>>                  r1_bio = alloc_r1bio(mddev, bio);
>> @@ -1336,6 +1358,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>>                       bio->bi_iter.bi_sector, bio_end_sector(bio))) {
>>
>>                  DEFINE_WAIT(w);
>> +               if (bio->bi_opf & REQ_NOWAIT) {
>> +                       bio_wouldblock_error(bio);
>> +                       return;
>> +               }
>>                  for (;;) {
>>                          prepare_to_wait(&conf->wait_barrier,
>>                                          &w, TASK_IDLE);
>> @@ -1353,17 +1379,26 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>>           * thread has put up a bar for new requests.
>>           * Continue immediately if no resync is active currently.
>>           */
>> -       wait_barrier(conf, bio->bi_iter.bi_sector);
>> +       if (!wait_barrier(conf, bio->bi_iter.bi_sector,
>> +                               bio->bi_opf & REQ_NOWAIT)) {
>> +               bio_wouldblock_error(bio);
>> +               return;
>> +       }
>>
>>          r1_bio = alloc_r1bio(mddev, bio);
>>          r1_bio->sectors = max_write_sectors;
>>
>>          if (conf->pending_count >= max_queued_requests) {
>>                  md_wakeup_thread(mddev->thread);
>> +               if (bio->bi_opf & REQ_NOWAIT) {
>> +                       bio_wouldblock_error(bio);
> I think we need to fix conf->nr_pending before returning.
OK, this one I am not sure. You mean dec conf->nr_pending?
>> +                       return;
>> +               }
>>                  raid1_log(mddev, "wait queued");
>>                  wait_event(conf->wait_barrier,
>>                             conf->pending_count < max_queued_requests);
>>          }
>> +
>>          /* first select target devices under rcu_lock and
>>           * inc refcount on their rdev.  Record them by setting
>>           * bios[x] to bio
>> @@ -1458,9 +1493,14 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>>                                  rdev_dec_pending(conf->mirrors[j].rdev, mddev);
>>                  r1_bio->state = 0;
>>                  allow_barrier(conf, bio->bi_iter.bi_sector);
>> +
>> +               if (bio->bi_opf & REQ_NOWAIT) {
>> +                       bio_wouldblock_error(bio);
>> +                       return;
>> +               }
>>                  raid1_log(mddev, "wait rdev %d blocked", blocked_rdev->raid_disk);
>>                  md_wait_for_blocked_rdev(blocked_rdev, mddev);
>> -               wait_barrier(conf, bio->bi_iter.bi_sector);
>> +               wait_barrier(conf, bio->bi_iter.bi_sector, false);
>>                  goto retry_write;
>>          }
>>
>> @@ -1687,7 +1727,7 @@ static void close_sync(struct r1conf *conf)
>>          int idx;
>>
>>          for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++) {
>> -               _wait_barrier(conf, idx);
>> +               _wait_barrier(conf, idx, false);
>>                  _allow_barrier(conf, idx);
>>          }
>>
>> --
>> 2.17.1
>>
