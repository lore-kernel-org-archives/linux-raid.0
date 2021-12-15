Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B526C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 22:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhLOWU5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Dec 2021 17:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbhLOWU5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Dec 2021 17:20:57 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07659C061574
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 14:20:57 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x5so21988207pfr.0
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 14:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=YovlX2R+wFjqRr65cRKljes8SsJ6gKgMaXhiNeFXgvc=;
        b=d/xUE8Lilv3cmj6sISipH8cQGV8nqc45Ds7fjciGgWstXv4UbUIwjKAKTF1DO+XFPp
         maLGfeGCGtUVqfzCB3kIE4PsK2IacGw9h2hWEkbK0tZ8PNz6GpZFhob1hdfSz2nlm1Eu
         wYWP8uPSlpKymOhnlHYGsYxmvQPKIpy6WS8mc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YovlX2R+wFjqRr65cRKljes8SsJ6gKgMaXhiNeFXgvc=;
        b=C0cTwH7bhdSdBXR9GUYdo7gTBF3LDoyP4Kkh4TX9Km+8I/Mstnue3Ql511Df2Fz8Cv
         2f7CD8+b+9J4vM2Cv5BhhSXHLVcToBDrRsDw5k+RA6pettXjGILszgIP8VfrsNgylm4p
         nKhE62saNMO7O3Q+F3U6xJSz2frv/PKfidQrnFRdHHdSekdu5YCkyriKp/3/T+fp8Qb2
         p8iMoQO3+mnNY5xAvB73ROacSiE7B/9E4NZcq04FGvf2t0OJGHAym2WN2u/aJY2HcWya
         3hy04130oHW2k1nuFXTMN+hUo8z3cEiO4GQ8TqI+gTMdCM17dsjk01Cl83UMyJUKD3Jm
         Axeg==
X-Gm-Message-State: AOAM5318G8D0hDp9zQhf0eF3F7jbCNRwJQ9q35l41bl/Ch8O7ZNXUCZa
        mMYt9QzKqCEcq/6lqzNpiIzY6g==
X-Google-Smtp-Source: ABdhPJxk+Regem0cWBSvxIaIVYUlj2HxOsIoR4Gm8B8jAsWEJ7Jkdzv+0T0jeryMzYX23eM8dAjRXQ==
X-Received: by 2002:a63:4b0e:: with SMTP id y14mr9499253pga.8.1639606856471;
        Wed, 15 Dec 2021 14:20:56 -0800 (PST)
Received: from [192.168.1.5] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id x18sm3907583pfh.210.2021.12.15.14.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 14:20:56 -0800 (PST)
Message-ID: <9a85af03-a551-6650-3807-c177659cd17b@digitalocean.com>
Date:   Wed, 15 Dec 2021 15:20:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v5 3/4] md: raid10 add nowait support
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rgoldwyn@suse.de
References: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
 <20211215060906.3230-1-vverma@digitalocean.com>
 <20211215060906.3230-3-vverma@digitalocean.com>
 <CAPhsuW5=GLRW9g2QxgBfcx_OKq08x5GqGO4iC86x6YzDHRz8fA@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW5=GLRW9g2QxgBfcx_OKq08x5GqGO4iC86x6YzDHRz8fA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/15/21 1:42 PM, Song Liu wrote:
> On Tue, Dec 14, 2021 at 10:09 PM Vishal Verma <vverma@digitalocean.com> wrote:
>> This adds nowait support to the RAID10 driver. Very similar to
>> raid1 driver changes. It makes RAID10 driver return with EAGAIN
>> for situations where it could wait for eg:
>>
>> - Waiting for the barrier,
>> - Too many pending I/Os to be queued,
>> - Reshape operation,
>> - Discard operation.
>>
>> wait_barrier() fn is modified to return bool to support error for
>> wait barriers. It returns true in case of wait or if wait is not
>> required and returns false if wait was required but not performed
>> to support nowait.
>>
>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
>> ---
>>   drivers/md/raid10.c | 57 +++++++++++++++++++++++++++++++++++----------
>>   1 file changed, 45 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index dde98f65bd04..f6c73987e9ac 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -952,11 +952,18 @@ static void lower_barrier(struct r10conf *conf)
>>          wake_up(&conf->wait_barrier);
>>   }
>>
>> -static void wait_barrier(struct r10conf *conf)
>> +static bool wait_barrier(struct r10conf *conf, bool nowait)
>>   {
>>          spin_lock_irq(&conf->resync_lock);
>>          if (conf->barrier) {
>>                  struct bio_list *bio_list = current->bio_list;
>> +
>> +               /* Return false when nowait flag is set */
>> +               if (nowait) {
>> +                       spin_unlock_irq(&conf->resync_lock);
>> +                       return false;
>> +               }
>> +
>>                  conf->nr_waiting++;
>>                  /* Wait for the barrier to drop.
>>                   * However if there are already pending
>> @@ -988,6 +995,7 @@ static void wait_barrier(struct r10conf *conf)
>>          }
>>          atomic_inc(&conf->nr_pending);
>>          spin_unlock_irq(&conf->resync_lock);
>> +       return true;
>>   }
>>
>>   static void allow_barrier(struct r10conf *conf)
>> @@ -1101,17 +1109,25 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
>>   static void regular_request_wait(struct mddev *mddev, struct r10conf *conf,
>>                                   struct bio *bio, sector_t sectors)
>>   {
>> -       wait_barrier(conf);
>> +       /* Bail out if REQ_NOWAIT is set for the bio */
>> +       if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
>> +               bio_wouldblock_error(bio);
>> +               return;
>> +       }
> I think we also need regular_request_wait to return bool and handle it properly.
>
> Thanks,
> Song
>
Ack, will fix it. Thanks!
>>          while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>>              bio->bi_iter.bi_sector < conf->reshape_progress &&
>>              bio->bi_iter.bi_sector + sectors > conf->reshape_progress) {
>>                  raid10_log(conf->mddev, "wait reshape");
>> +               if (bio->bi_opf & REQ_NOWAIT) {
>> +                       bio_wouldblock_error(bio);
>> +                       return;
>> +               }
>>                  allow_barrier(conf);
>>                  wait_event(conf->wait_barrier,
>>                             conf->reshape_progress <= bio->bi_iter.bi_sector ||
>>                             conf->reshape_progress >= bio->bi_iter.bi_sector +
>>                             sectors);
>> -               wait_barrier(conf);
>> +               wait_barrier(conf, false);
>>          }
>>   }
>>
>> @@ -1179,7 +1195,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>>                  bio_chain(split, bio);
>>                  allow_barrier(conf);
>>                  submit_bio_noacct(bio);
>> -               wait_barrier(conf);
>> +               wait_barrier(conf, false);
>>                  bio = split;
>>                  r10_bio->master_bio = bio;
>>                  r10_bio->sectors = max_sectors;
>> @@ -1338,7 +1354,7 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
>>                  raid10_log(conf->mddev, "%s wait rdev %d blocked",
>>                                  __func__, blocked_rdev->raid_disk);
>>                  md_wait_for_blocked_rdev(blocked_rdev, mddev);
>> -               wait_barrier(conf);
>> +               wait_barrier(conf, false);
>>                  goto retry_wait;
>>          }
>>   }
>> @@ -1357,6 +1373,11 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>>                                              bio_end_sector(bio)))) {
>>                  DEFINE_WAIT(w);
>>                  for (;;) {
>> +                       /* Bail out if REQ_NOWAIT is set for the bio */
>> +                       if (bio->bi_opf & REQ_NOWAIT) {
>> +                               bio_wouldblock_error(bio);
>> +                               return;
>> +                       }
>>                          prepare_to_wait(&conf->wait_barrier,
>>                                          &w, TASK_IDLE);
>>                          if (!md_cluster_ops->area_resyncing(mddev, WRITE,
>> @@ -1381,6 +1402,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>>                                BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
>>                  md_wakeup_thread(mddev->thread);
>>                  raid10_log(conf->mddev, "wait reshape metadata");
>> +               if (bio->bi_opf & REQ_NOWAIT) {
>> +                       bio_wouldblock_error(bio);
>> +                       return;
>> +               }
>>                  wait_event(mddev->sb_wait,
>>                             !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
>>
>> @@ -1390,6 +1415,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>>          if (conf->pending_count >= max_queued_requests) {
>>                  md_wakeup_thread(mddev->thread);
>>                  raid10_log(mddev, "wait queued");
>> +               if (bio->bi_opf & REQ_NOWAIT) {
>> +                       bio_wouldblock_error(bio);
>> +                       return;
>> +               }
>>                  wait_event(conf->wait_barrier,
>>                             conf->pending_count < max_queued_requests);
>>          }
>> @@ -1482,7 +1511,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>>                  bio_chain(split, bio);
>>                  allow_barrier(conf);
>>                  submit_bio_noacct(bio);
>> -               wait_barrier(conf);
>> +               wait_barrier(conf, false);
>>                  bio = split;
>>                  r10_bio->master_bio = bio;
>>          }
>> @@ -1607,7 +1636,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>>          if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
>>                  return -EAGAIN;
>>
>> -       wait_barrier(conf);
>> +       if (bio->bi_opf & REQ_NOWAIT) {
>> +               bio_wouldblock_error(bio);
>> +               return 0;
>> +       }
>> +       wait_barrier(conf, false);
>>
>>          /*
>>           * Check reshape again to avoid reshape happens after checking
>> @@ -1649,7 +1682,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>>                  allow_barrier(conf);
>>                  /* Resend the fist split part */
>>                  submit_bio_noacct(split);
>> -               wait_barrier(conf);
>> +               wait_barrier(conf, false);
>>          }
>>          div_u64_rem(bio_end, stripe_size, &remainder);
>>          if (remainder) {
>> @@ -1660,7 +1693,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>>                  /* Resend the second split part */
>>                  submit_bio_noacct(bio);
>>                  bio = split;
>> -               wait_barrier(conf);
>> +               wait_barrier(conf, false);
>>          }
>>
>>          bio_start = bio->bi_iter.bi_sector;
>> @@ -1816,7 +1849,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>>                  end_disk_offset += geo->stride;
>>                  atomic_inc(&first_r10bio->remaining);
>>                  raid_end_discard_bio(r10_bio);
>> -               wait_barrier(conf);
>> +               wait_barrier(conf, false);
>>                  goto retry_discard;
>>          }
>>
>> @@ -2011,7 +2044,7 @@ static void print_conf(struct r10conf *conf)
>>
>>   static void close_sync(struct r10conf *conf)
>>   {
>> -       wait_barrier(conf);
>> +       wait_barrier(conf, false);
>>          allow_barrier(conf);
>>
>>          mempool_exit(&conf->r10buf_pool);
>> @@ -4819,7 +4852,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
>>          if (need_flush ||
>>              time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
>>                  /* Need to update reshape_position in metadata */
>> -               wait_barrier(conf);
>> +               wait_barrier(conf, false);
>>                  mddev->reshape_position = conf->reshape_progress;
>>                  if (mddev->reshape_backwards)
>>                          mddev->curr_resync_completed = raid10_size(mddev, 0, 0)
>> --
>> 2.17.1
>>
