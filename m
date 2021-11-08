Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF4BC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  8 Nov 2021 22:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCC3B619BB
	for <linux-raid@archiver.kernel.org>; Mon,  8 Nov 2021 22:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240752AbhKHWmF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Nov 2021 17:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239019AbhKHWmF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 Nov 2021 17:42:05 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A6AC061570
        for <linux-raid@vger.kernel.org>; Mon,  8 Nov 2021 14:39:20 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id g25-20020a9d5f99000000b0055af3d227e8so23545145oti.11
        for <linux-raid@vger.kernel.org>; Mon, 08 Nov 2021 14:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=sWq7ndhlIh0Xxm2Trvu865dXAVJI2eTDNdllRHjZRsc=;
        b=PWPE4G0/i8BM53ifP/KvT3ftpnWoSyr20o0vq2/jq/L5ugnxABnozgVyZ6z+DPt7j4
         q5li1LV+DPr+hdC+YQzyNIO+qIGAN/zZBB19JoTVosLsabDgfaZZrG9itG42ff2N78n7
         rYhg9JAY119AJLqCpzCEBJykGhUAAExiS5/vY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sWq7ndhlIh0Xxm2Trvu865dXAVJI2eTDNdllRHjZRsc=;
        b=Ubjw7qKcZ88dXiPJOqTkbzMaD3IGWfkPvnXNyzA+yWv69tGoG+5hWUcrGKErZeAUpR
         W/uK80M0sqXNACkjBUautvCJyWsT+ZUZEiEN4MPdl+vw5HbHCSe6t8vHivPCstMlU06E
         3h+1HzvEiqH0XPl3i1aXU5gwceQPdVXBkn4d8DBNwND1tP7j0KDNeLUenYRT0ykJFntx
         Wc4G8DRZ+f4piMTtPwbHtShjKFSL6V58Vb6QrpxyH5eFQPAjSr/EYm4Wweaffo8l0Qj6
         sWUYow1WiDKCfafSo8VxxWZk5lKcv15ExiLwzQtrz1XujQuERLXB329kBtcQwqCEfK7H
         pJeA==
X-Gm-Message-State: AOAM530Q5IKuwFzuEQXGWs54+uCzVUNRyiQNmpA+2v1BP5DjaFjThGAN
        OjGsMI4zb3L5JwSvtsZwA29e1cM1d7cX5kk6
X-Google-Smtp-Source: ABdhPJzxS2UKHbzRBzGbpj27ikiV0SkVmvLnAA2toZlq9GHDv6yX9VxTYb0zPFIGKp9jIIjwD/7d7Q==
X-Received: by 2002:a05:6830:2695:: with SMTP id l21mr2034287otu.197.1636411159614;
        Mon, 08 Nov 2021 14:39:19 -0800 (PST)
Received: from [192.168.1.7] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id c18sm7980132ots.64.2021.11.08.14.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 14:39:19 -0800 (PST)
Message-ID: <97bff08e-ecb7-37d7-c113-7f33bfca02d9@digitalocean.com>
Date:   Mon, 8 Nov 2021 15:39:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v3 2/2] md: raid1 add nowait support
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
References: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
 <20211104045149.9599-1-vverma@digitalocean.com>
 <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 11/8/21 3:32 PM, Song Liu wrote:
> On Wed, Nov 3, 2021 at 9:52 PM Vishal Verma <vverma@digitalocean.com> wrote:
>> This adds nowait support to the RAID1 driver. It makes RAID1 driver
>> return with EAGAIN for situations where it could wait for eg:
>>
>>    - Waiting for the barrier,
>>    - Array got frozen,
>>    - Too many pending I/Os to be queued.
>>
>> wait_barrier() fn is modified to return bool to support error for
>> wait barriers. It returns true in case of wait or if wait is not
>> required and returns false if wait was required but not performed
>> to support nowait.
>>
>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
>> ---
>>   drivers/md/raid1.c | 74 +++++++++++++++++++++++++++++++++++-----------
>>   1 file changed, 57 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 7dc8026cf6ee..2e191fc2147b 100644
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
>> +       if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
> We change wait_barrier to wait_read_barrier here, I guess this is a typo?
>
> Please include changes in raid10 and raid456 (or don't set QUEUE_FLAG_NOWAIT
> for these personalities) and resend the patch. We will target it for
> the next merge
> window (5.17).
>
> Thanks,
> Song
>
> Thanks Song. I am almost done with the raid10 change and will do the
> raid456 soon and resend.
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
