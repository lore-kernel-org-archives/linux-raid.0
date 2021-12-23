Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 441D2C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Dec 2021 01:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhLWBrk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Dec 2021 20:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbhLWBrk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Dec 2021 20:47:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7D0C061401
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 17:47:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48EF8B81F45
        for <linux-raid@vger.kernel.org>; Thu, 23 Dec 2021 01:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5A6C36AEA
        for <linux-raid@vger.kernel.org>; Thu, 23 Dec 2021 01:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640224057;
        bh=mD/mnMtaotp3GEwnvNsHrTcuxtN9X5md1lvOnHYP8p0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cUu/OEMySmQkOteuZY7FwD93UDuDq2f3C6N3KWUUI27CVocp/NuqcOH38dWv1D4Q7
         JNBphTstjscy/DXexEw0UkSlUBwVfP3vveW+02cbg1cOw29qBOsAWPChxRAslgJOnq
         WCh0hhYoJCWstwT7JQwA5nmN3yoOkM8eXPracYA1mORjm39Hl9s2M9WvEBkrsJjtAa
         NiIFjIekMryqAshJT3JBNr+ERPXmZNq5DeUhC5lwGhcOyJc+fnr60AXXFrwzsPMRC7
         ORO58JKSOk8kg574SxLB2fZj9TFSg5DA+2Zs9IMzVJf8Z7OaSDMZCCrG0k78ITRMri
         nrFp6TTAO8S+Q==
Received: by mail-yb1-f170.google.com with SMTP id v64so11784364ybi.5
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 17:47:36 -0800 (PST)
X-Gm-Message-State: AOAM532DFv52DhSqrn12pA4sZBhfjpHCoQT/IvbChl5weiwgDHOQC9tU
        qGyNakezBEtoDHcgdleIqLA0EXEqwnfsoZH4OfY=
X-Google-Smtp-Source: ABdhPJz5vGWxa5ygBL7NOlLwpS4pqglj56q2+mUKuDwLYV905JlaUrqW6ncCZdKWyHgM/sMy40aoW7Q1AUYxo5K7bUo=
X-Received: by 2002:a25:bf8f:: with SMTP id l15mr495873ybk.670.1640224055996;
 Wed, 22 Dec 2021 17:47:35 -0800 (PST)
MIME-Version: 1.0
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com> <20211221200622.29795-3-vverma@digitalocean.com>
In-Reply-To: <20211221200622.29795-3-vverma@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 22 Dec 2021 17:47:25 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5BdiSy0WREjEbmTkHEkN4gHwvP=44yVe2v+B+LTG=3JA@mail.gmail.com>
Message-ID: <CAPhsuW5BdiSy0WREjEbmTkHEkN4gHwvP=44yVe2v+B+LTG=3JA@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] md: raid10 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rgoldwyn@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 21, 2021 at 12:06 PM Vishal Verma <vverma@digitalocean.com> wrote:
>
> This adds nowait support to the RAID10 driver. Very similar to
> raid1 driver changes. It makes RAID10 driver return with EAGAIN
> for situations where it could wait for eg:
>
>   - Waiting for the barrier,
>   - Too many pending I/Os to be queued,
>   - Reshape operation,
>   - Discard operation.
>
> wait_barrier() and regular_request_wait() fn are modified to return bool
> to support error for wait barriers. They returns true in case of wait
> or if wait is not required and returns false if wait was required
> but not performed to support nowait.
>
> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
> ---
>  drivers/md/raid10.c | 90 +++++++++++++++++++++++++++++++--------------
>  1 file changed, 62 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index dde98f65bd04..7ceae00e863e 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -952,8 +952,9 @@ static void lower_barrier(struct r10conf *conf)
>         wake_up(&conf->wait_barrier);
>  }
>
> -static void wait_barrier(struct r10conf *conf)
> +static bool wait_barrier(struct r10conf *conf, bool nowait)
>  {
> +       bool ret = true;
>         spin_lock_irq(&conf->resync_lock);
>         if (conf->barrier) {
>                 struct bio_list *bio_list = current->bio_list;
> @@ -968,26 +969,33 @@ static void wait_barrier(struct r10conf *conf)
>                  * count down.
>                  */
>                 raid10_log(conf->mddev, "wait barrier");
> -               wait_event_lock_irq(conf->wait_barrier,
> -                                   !conf->barrier ||
> -                                   (atomic_read(&conf->nr_pending) &&
> -                                    bio_list &&
> -                                    (!bio_list_empty(&bio_list[0]) ||
> -                                     !bio_list_empty(&bio_list[1]))) ||
> -                                    /* move on if recovery thread is
> -                                     * blocked by us
> -                                     */
> -                                    (conf->mddev->thread->tsk == current &&
> -                                     test_bit(MD_RECOVERY_RUNNING,
> -                                              &conf->mddev->recovery) &&
> -                                     conf->nr_queued > 0),
> -                                   conf->resync_lock);
> +               /* Return false when nowait flag is set */
> +               if (nowait)
> +                       ret = false;
> +               else
> +                       wait_event_lock_irq(conf->wait_barrier,
> +                                           !conf->barrier ||
> +                                           (atomic_read(&conf->nr_pending) &&
> +                                            bio_list &&
> +                                            (!bio_list_empty(&bio_list[0]) ||
> +                                             !bio_list_empty(&bio_list[1]))) ||
> +                                            /* move on if recovery thread is
> +                                             * blocked by us
> +                                             */
> +                                            (conf->mddev->thread->tsk == current &&
> +                                             test_bit(MD_RECOVERY_RUNNING,
> +                                                      &conf->mddev->recovery) &&
> +                                             conf->nr_queued > 0),
> +                                           conf->resync_lock);
>                 conf->nr_waiting--;
>                 if (!conf->nr_waiting)
>                         wake_up(&conf->wait_barrier);
>         }
> -       atomic_inc(&conf->nr_pending);
> +       /* Only increment nr_pending when we wait */
> +       if (ret)
> +               atomic_inc(&conf->nr_pending);
>         spin_unlock_irq(&conf->resync_lock);
> +       return ret;
>  }
>
>  static void allow_barrier(struct r10conf *conf)
> @@ -1098,21 +1106,30 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
>   * currently.
>   * 2. If IO spans the reshape position.  Need to wait for reshape to pass.
>   */
> -static void regular_request_wait(struct mddev *mddev, struct r10conf *conf,
> +static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
>                                  struct bio *bio, sector_t sectors)
>  {
> -       wait_barrier(conf);
> +       /* Bail out if REQ_NOWAIT is set for the bio */
> +       if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
> +               bio_wouldblock_error(bio);
> +               return false;
> +       }
>         while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>             bio->bi_iter.bi_sector < conf->reshape_progress &&
>             bio->bi_iter.bi_sector + sectors > conf->reshape_progress) {
>                 raid10_log(conf->mddev, "wait reshape");
> +               if (bio->bi_opf & REQ_NOWAIT) {
> +                       bio_wouldblock_error(bio);
> +                       return false;
> +               }
>                 allow_barrier(conf);
>                 wait_event(conf->wait_barrier,
>                            conf->reshape_progress <= bio->bi_iter.bi_sector ||
>                            conf->reshape_progress >= bio->bi_iter.bi_sector +
>                            sectors);
> -               wait_barrier(conf);
> +               wait_barrier(conf, false);
>         }
> +       return true;
>  }
>
>  static void raid10_read_request(struct mddev *mddev, struct bio *bio,
> @@ -1179,7 +1196,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>                 bio_chain(split, bio);
>                 allow_barrier(conf);
>                 submit_bio_noacct(bio);
> -               wait_barrier(conf);
> +               wait_barrier(conf, false);
>                 bio = split;
>                 r10_bio->master_bio = bio;
>                 r10_bio->sectors = max_sectors;
> @@ -1338,7 +1355,7 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
>                 raid10_log(conf->mddev, "%s wait rdev %d blocked",
>                                 __func__, blocked_rdev->raid_disk);
>                 md_wait_for_blocked_rdev(blocked_rdev, mddev);

I think we need more handling here.

> -               wait_barrier(conf);
> +               wait_barrier(conf, false);
>                 goto retry_wait;
>         }
>  }
> @@ -1356,6 +1373,11 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>                                             bio->bi_iter.bi_sector,
>                                             bio_end_sector(bio)))) {
>                 DEFINE_WAIT(w);
> +               /* Bail out if REQ_NOWAIT is set for the bio */
> +               if (bio->bi_opf & REQ_NOWAIT) {
> +                       bio_wouldblock_error(bio);
> +                       return;
> +               }
>                 for (;;) {
>                         prepare_to_wait(&conf->wait_barrier,
>                                         &w, TASK_IDLE);
> @@ -1381,6 +1403,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>                               BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
>                 md_wakeup_thread(mddev->thread);
>                 raid10_log(conf->mddev, "wait reshape metadata");
> +               if (bio->bi_opf & REQ_NOWAIT) {
> +                       bio_wouldblock_error(bio);
> +                       return;
> +               }
>                 wait_event(mddev->sb_wait,
>                            !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
>
> @@ -1390,6 +1416,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>         if (conf->pending_count >= max_queued_requests) {
>                 md_wakeup_thread(mddev->thread);
>                 raid10_log(mddev, "wait queued");

We need the check before logging "wait queued".

> +               if (bio->bi_opf & REQ_NOWAIT) {
> +                       bio_wouldblock_error(bio);
> +                       return;
> +               }
>                 wait_event(conf->wait_barrier,
>                            conf->pending_count < max_queued_requests);
>         }
> @@ -1482,7 +1512,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>                 bio_chain(split, bio);
>                 allow_barrier(conf);
>                 submit_bio_noacct(bio);
> -               wait_barrier(conf);
> +               wait_barrier(conf, false);
>                 bio = split;
>                 r10_bio->master_bio = bio;
>         }
> @@ -1607,7 +1637,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>         if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
>                 return -EAGAIN;
>
> -       wait_barrier(conf);
> +       if (bio->bi_opf & REQ_NOWAIT) {
> +               bio_wouldblock_error(bio);
> +               return 0;

Shall we return -EAGAIN here?

> +       }
> +       wait_barrier(conf, false);
>
>         /*
>          * Check reshape again to avoid reshape happens after checking
> @@ -1649,7 +1683,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>                 allow_barrier(conf);
>                 /* Resend the fist split part */
>                 submit_bio_noacct(split);
> -               wait_barrier(conf);
> +               wait_barrier(conf, false);
>         }
>         div_u64_rem(bio_end, stripe_size, &remainder);
>         if (remainder) {
> @@ -1660,7 +1694,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>                 /* Resend the second split part */
>                 submit_bio_noacct(bio);
>                 bio = split;
> -               wait_barrier(conf);
> +               wait_barrier(conf, false);
>         }
>
>         bio_start = bio->bi_iter.bi_sector;
> @@ -1816,7 +1850,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>                 end_disk_offset += geo->stride;
>                 atomic_inc(&first_r10bio->remaining);
>                 raid_end_discard_bio(r10_bio);
> -               wait_barrier(conf);
> +               wait_barrier(conf, false);
>                 goto retry_discard;
>         }
>
> @@ -2011,7 +2045,7 @@ static void print_conf(struct r10conf *conf)
>
>  static void close_sync(struct r10conf *conf)
>  {
> -       wait_barrier(conf);
> +       wait_barrier(conf, false);
>         allow_barrier(conf);
>
>         mempool_exit(&conf->r10buf_pool);
> @@ -4819,7 +4853,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
>         if (need_flush ||
>             time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
>                 /* Need to update reshape_position in metadata */
> -               wait_barrier(conf);
> +               wait_barrier(conf, false);
>                 mddev->reshape_position = conf->reshape_progress;
>                 if (mddev->reshape_backwards)
>                         mddev->curr_resync_completed = raid10_size(mddev, 0, 0)
> --
> 2.17.1
>
