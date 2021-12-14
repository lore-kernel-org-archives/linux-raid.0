Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FABC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 14 Dec 2021 15:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhLNP1k (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Dec 2021 10:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbhLNP1k (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Dec 2021 10:27:40 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1396EC061574
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 07:27:40 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 133so17580204pgc.12
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 07:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=hcUQfwOfmNpfBXTMq8W5LBl1rCrGVfA0EIizGyog4tU=;
        b=MSq3eTDZjEGK56ZG6eeBycMcjqYjMTHX+q+nwe9iHakLQdwVbe7/DZTjHboSgw88lh
         7JLXL0gJ4fWF+CcA7rE6orbkoSb/rVeChuswTpKgi2JgZ+hyk4y4VW0ZH3vCi1x7Yv7x
         sqpMhXPKS9w1q/lMmpsm4dgRzVelotHCtcgnk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hcUQfwOfmNpfBXTMq8W5LBl1rCrGVfA0EIizGyog4tU=;
        b=c5HXcYXLab7+ZFXvdptlr/SnjUaGwRLewh/Ng7VzA5LTnx98251IX4LPbq3fCqGzMJ
         obF/isEGFQl3XpXTz2mLDDqMcjpmTJKXtOBlwl4LqLof8GCfHcnJYzRR4VHLbV+rudjH
         8OKDKSlXtzfxgvzjCf0J7j/3MMdw6KBBB5Rw9fw1NvAc5rYBQDi2EvegD0Pmzx+KS9w5
         9V8vnJfvUnmnHX6pSdslVrHHGKeD/AI1iqn7tO6v83iPwpQUtBdFRUA/E5ByfsRWUqDE
         pdMqstUvU+IkFAY4SxtKbn785gIHn9koDi83hgzmx+++4WPaSBuGUt8t+6mPTMT+L6nt
         F/mw==
X-Gm-Message-State: AOAM533eS3Xkx8bWa1ZshXimI6DeJjhwynK6No1j4co7ZZF4pc0Mi7vK
        UdQ74Rlj9fv0JjQkQAiaf05XuA==
X-Google-Smtp-Source: ABdhPJzhpdXzkRIeaZTPyt7KRn5/xHb+AEpx06NGF/xyGfYSwhvT2Pi19drfIWhE0pCZJ1Z+g9z8cg==
X-Received: by 2002:a63:f4e:: with SMTP id 14mr4267930pgp.575.1639495659392;
        Tue, 14 Dec 2021 07:27:39 -0800 (PST)
Received: from [192.168.1.5] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id r11sm191823pff.81.2021.12.14.07.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 07:27:39 -0800 (PST)
Message-ID: <071cf3df-56ed-c959-77ed-3903ec62b672@digitalocean.com>
Date:   Tue, 14 Dec 2021 08:27:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [RFC PATCH v4 3/4] md: raid10 add nowait support
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com>
 <20211110181441.9263-3-vverma@digitalocean.com>
 <CAPhsuW7UpKURLoPyCtjU44SsVDXKabCrhJOY14U+fB0Hnbv9GA@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW7UpKURLoPyCtjU44SsVDXKabCrhJOY14U+fB0Hnbv9GA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/13/21 5:32 PM, Song Liu wrote:
> On Wed, Nov 10, 2021 at 10:15 AM Vishal Verma <vverma@digitalocean.com> wrote:
>> This adds nowait support to the RAID10 driver. Very similar to
>> raid1 driver changes. It makes RAID10 driver return with EAGAIN
>> for situations where it could wait for eg:
>>
>>    - Waiting for the barrier,
>>    - Too many pending I/Os to be queued,
>>    - Reshape operation,
>>    - Discard operation.
>>
>> wait_barrier() fn is modified to return bool to support error for
>> wait barriers. It returns true in case of wait or if wait is not
>> required and returns false if wait was required but not performed
>> to support nowait.
>>
>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
>> ---
>>   drivers/md/raid10.c | 87 +++++++++++++++++++++++++++++++--------------
>>   1 file changed, 60 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index dde98f65bd04..03983146d31a 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -952,8 +952,9 @@ static void lower_barrier(struct r10conf *conf)
>>          wake_up(&conf->wait_barrier);
>>   }
>>
>> -static void wait_barrier(struct r10conf *conf)
>> +static bool wait_barrier(struct r10conf *conf, bool nowait)
>>   {
>> +       bool ret = true;
>>          spin_lock_irq(&conf->resync_lock);
>>          if (conf->barrier) {
>>                  struct bio_list *bio_list = current->bio_list;
>> @@ -968,26 +969,33 @@ static void wait_barrier(struct r10conf *conf)
>>                   * count down.
>>                   */
>>                  raid10_log(conf->mddev, "wait barrier");
>> -               wait_event_lock_irq(conf->wait_barrier,
>> -                                   !conf->barrier ||
>> -                                   (atomic_read(&conf->nr_pending) &&
>> -                                    bio_list &&
>> -                                    (!bio_list_empty(&bio_list[0]) ||
>> -                                     !bio_list_empty(&bio_list[1]))) ||
>> -                                    /* move on if recovery thread is
>> -                                     * blocked by us
>> -                                     */
>> -                                    (conf->mddev->thread->tsk == current &&
>> -                                     test_bit(MD_RECOVERY_RUNNING,
>> -                                              &conf->mddev->recovery) &&
>> -                                     conf->nr_queued > 0),
>> -                                   conf->resync_lock);
>> +               /* Return false when nowait flag is set */
>> +               if (nowait)
>> +                       ret = false;
>> +               else
>> +                       wait_event_lock_irq(conf->wait_barrier,
>> +                                           !conf->barrier ||
>> +                                           (atomic_read(&conf->nr_pending) &&
>> +                                            bio_list &&
>> +                                            (!bio_list_empty(&bio_list[0]) ||
>> +                                             !bio_list_empty(&bio_list[1]))) ||
>> +                                            /* move on if recovery thread is
>> +                                             * blocked by us
>> +                                             */
>> +                                            (conf->mddev->thread->tsk == current &&
>> +                                             test_bit(MD_RECOVERY_RUNNING,
>> +                                                      &conf->mddev->recovery) &&
>> +                                             conf->nr_queued > 0),
>> +                                           conf->resync_lock);
>>                  conf->nr_waiting--;
>>                  if (!conf->nr_waiting)
>>                          wake_up(&conf->wait_barrier);
>>          }
>> -       atomic_inc(&conf->nr_pending);
>> +       /* Only increment nr_pending when we wait */
>> +       if (ret)
>> +               atomic_inc(&conf->nr_pending);
>>          spin_unlock_irq(&conf->resync_lock);
>> +       return ret;
>>   }
> I guess something like this would simplify the code:
>
> static bool wait_barrier(struct r10conf *conf, bool nowait)
> {
>          bool ret = true;
>          spin_lock_irq(&conf->resync_lock);
>          if (conf->barrier) {
>                  struct bio_list *bio_list = current->bio_list;
>
>                  if (nowait) {
>                          spin_unlock_irq(&conf->resync_lock);
>                          return false;
>                  }
Ack, makes sense to me.
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
> Does this mean we always bail out on discard?
Yeah, I wanted your feedback specifically for this case. I see just 
after this is when wait_barrier() happens
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
