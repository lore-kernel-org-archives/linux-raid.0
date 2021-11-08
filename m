Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799C1C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  8 Nov 2021 22:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56B0F61052
	for <linux-raid@archiver.kernel.org>; Mon,  8 Nov 2021 22:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240732AbhKHWfp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Nov 2021 17:35:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239746AbhKHWfn (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 8 Nov 2021 17:35:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A2EE61052
        for <linux-raid@vger.kernel.org>; Mon,  8 Nov 2021 22:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636410778;
        bh=MTgdkvjhVh2zeDXPT5aVfSCT2EqMEid8XvXHx2FDRYk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bYOC/5/ehxIFKaax7GaoA/7i4igj6xL6WBhYENs2+VeyYrdtcKENZYuWokw6IzYMk
         c7pQXIg101ZzMElxNjCXVfE8jOra/ow+kz1a740zpasEig3RifdF1XR6imxi/y5rpv
         JRN3jpqvGtoJRmXkNM5x6PByuUzai2nIfyEY76nLRPhclZV91hvX4h6QrIsn1ktYru
         9gPF/iUmBmIJ1Lgm1GgsiAzfJVu7Vty3Kfluf9PTeSnB/z3V2uVa+xGo+p8hWP/2gQ
         Q7EGX8BS6+1ZmJMBW2LDlAKuNSA0SoXRUy5Xf1AZfcyNlpUV2O9HMGT3X7LqKfAH80
         i8OkBDuvFFGwA==
Received: by mail-yb1-f178.google.com with SMTP id e136so44387972ybc.4
        for <linux-raid@vger.kernel.org>; Mon, 08 Nov 2021 14:32:58 -0800 (PST)
X-Gm-Message-State: AOAM531OkrCGFrTNmQLpl98Rt8lmMDQKrnDkjjujYZ18DYlj5+fRkR8S
        94NnCu1lOOVatl0uRHLjB7MxM4p6CMI/ACISYnw=
X-Google-Smtp-Source: ABdhPJzc+p42EKIWFq95RtcBztL75jP0ICTlf7afNLx6MpFG70Fj/iUo+QOgs7Xh22pNoxKmldV+Ku3ToQ4Ji0k+Bx0=
X-Received: by 2002:a25:bd45:: with SMTP id p5mr3233831ybm.213.1636410777669;
 Mon, 08 Nov 2021 14:32:57 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
 <20211104045149.9599-1-vverma@digitalocean.com>
In-Reply-To: <20211104045149.9599-1-vverma@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 8 Nov 2021 14:32:46 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
Message-ID: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] md: raid1 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 3, 2021 at 9:52 PM Vishal Verma <vverma@digitalocean.com> wrote:
>
> This adds nowait support to the RAID1 driver. It makes RAID1 driver
> return with EAGAIN for situations where it could wait for eg:
>
>   - Waiting for the barrier,
>   - Array got frozen,
>   - Too many pending I/Os to be queued.
>
> wait_barrier() fn is modified to return bool to support error for
> wait barriers. It returns true in case of wait or if wait is not
> required and returns false if wait was required but not performed
> to support nowait.
>
> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
> ---
>  drivers/md/raid1.c | 74 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 57 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7dc8026cf6ee..2e191fc2147b 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -929,8 +929,9 @@ static void lower_barrier(struct r1conf *conf, sector_t sector_nr)
>         wake_up(&conf->wait_barrier);
>  }
>
> -static void _wait_barrier(struct r1conf *conf, int idx)
> +static bool _wait_barrier(struct r1conf *conf, int idx, bool nowait)
>  {
> +       bool ret = true;
>         /*
>          * We need to increase conf->nr_pending[idx] very early here,
>          * then raise_barrier() can be blocked when it waits for
> @@ -961,7 +962,7 @@ static void _wait_barrier(struct r1conf *conf, int idx)
>          */
>         if (!READ_ONCE(conf->array_frozen) &&
>             !atomic_read(&conf->barrier[idx]))
> -               return;
> +               return ret;
>
>         /*
>          * After holding conf->resync_lock, conf->nr_pending[idx]
> @@ -979,18 +980,27 @@ static void _wait_barrier(struct r1conf *conf, int idx)
>          */
>         wake_up(&conf->wait_barrier);
>         /* Wait for the barrier in same barrier unit bucket to drop. */
> -       wait_event_lock_irq(conf->wait_barrier,
> -                           !conf->array_frozen &&
> -                            !atomic_read(&conf->barrier[idx]),
> -                           conf->resync_lock);
> +       if (conf->array_frozen || atomic_read(&conf->barrier[idx])) {
> +               /* Return false when nowait flag is set */
> +               if (nowait)
> +                       ret = false;
> +               else {
> +                       wait_event_lock_irq(conf->wait_barrier,
> +                                       !conf->array_frozen &&
> +                                       !atomic_read(&conf->barrier[idx]),
> +                                       conf->resync_lock);
> +               }
> +       }
>         atomic_inc(&conf->nr_pending[idx]);
>         atomic_dec(&conf->nr_waiting[idx]);
>         spin_unlock_irq(&conf->resync_lock);
> +       return ret;
>  }
>
> -static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
> +static bool wait_read_barrier(struct r1conf *conf, sector_t sector_nr, bool nowait)
>  {
>         int idx = sector_to_idx(sector_nr);
> +       bool ret = true;
>
>         /*
>          * Very similar to _wait_barrier(). The difference is, for read
> @@ -1002,7 +1012,7 @@ static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
>         atomic_inc(&conf->nr_pending[idx]);
>
>         if (!READ_ONCE(conf->array_frozen))
> -               return;
> +               return ret;
>
>         spin_lock_irq(&conf->resync_lock);
>         atomic_inc(&conf->nr_waiting[idx]);
> @@ -1013,19 +1023,27 @@ static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
>          */
>         wake_up(&conf->wait_barrier);
>         /* Wait for array to be unfrozen */
> -       wait_event_lock_irq(conf->wait_barrier,
> -                           !conf->array_frozen,
> -                           conf->resync_lock);
> +       if (conf->array_frozen || atomic_read(&conf->barrier[idx])) {
> +               if (nowait)
> +                       /* Return false when nowait flag is set */
> +                       ret = false;
> +               else {
> +                       wait_event_lock_irq(conf->wait_barrier,
> +                                       !conf->array_frozen,
> +                                       conf->resync_lock);
> +               }
> +       }
>         atomic_inc(&conf->nr_pending[idx]);
>         atomic_dec(&conf->nr_waiting[idx]);
>         spin_unlock_irq(&conf->resync_lock);
> +       return ret;
>  }
>
> -static void wait_barrier(struct r1conf *conf, sector_t sector_nr)
> +static bool wait_barrier(struct r1conf *conf, sector_t sector_nr, bool nowait)
>  {
>         int idx = sector_to_idx(sector_nr);
>
> -       _wait_barrier(conf, idx);
> +       return _wait_barrier(conf, idx, nowait);
>  }
>
>  static void _allow_barrier(struct r1conf *conf, int idx)
> @@ -1236,7 +1254,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>          * Still need barrier for READ in case that whole
>          * array is frozen.
>          */
> -       wait_read_barrier(conf, bio->bi_iter.bi_sector);
> +       if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
> +                               bio->bi_opf & REQ_NOWAIT)) {
> +               bio_wouldblock_error(bio);
> +               return;
> +       }
>
>         if (!r1_bio)
>                 r1_bio = alloc_r1bio(mddev, bio);
> @@ -1336,6 +1358,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>                      bio->bi_iter.bi_sector, bio_end_sector(bio))) {
>
>                 DEFINE_WAIT(w);
> +               if (bio->bi_opf & REQ_NOWAIT) {
> +                       bio_wouldblock_error(bio);
> +                       return;
> +               }
>                 for (;;) {
>                         prepare_to_wait(&conf->wait_barrier,
>                                         &w, TASK_IDLE);
> @@ -1353,17 +1379,26 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>          * thread has put up a bar for new requests.
>          * Continue immediately if no resync is active currently.
>          */
> -       wait_barrier(conf, bio->bi_iter.bi_sector);
> +       if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,

We change wait_barrier to wait_read_barrier here, I guess this is a typo?

Please include changes in raid10 and raid456 (or don't set QUEUE_FLAG_NOWAIT
for these personalities) and resend the patch. We will target it for
the next merge
window (5.17).

Thanks,
Song


> +                               bio->bi_opf & REQ_NOWAIT)) {
> +               bio_wouldblock_error(bio);
> +               return;
> +       }
>
>         r1_bio = alloc_r1bio(mddev, bio);
>         r1_bio->sectors = max_write_sectors;
>
>         if (conf->pending_count >= max_queued_requests) {
>                 md_wakeup_thread(mddev->thread);
> +               if (bio->bi_opf & REQ_NOWAIT) {
> +                       bio_wouldblock_error(bio);
> +                       return;
> +               }
>                 raid1_log(mddev, "wait queued");
>                 wait_event(conf->wait_barrier,
>                            conf->pending_count < max_queued_requests);
>         }
> +
>         /* first select target devices under rcu_lock and
>          * inc refcount on their rdev.  Record them by setting
>          * bios[x] to bio
> @@ -1458,9 +1493,14 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>                                 rdev_dec_pending(conf->mirrors[j].rdev, mddev);
>                 r1_bio->state = 0;
>                 allow_barrier(conf, bio->bi_iter.bi_sector);
> +
> +               if (bio->bi_opf & REQ_NOWAIT) {
> +                       bio_wouldblock_error(bio);
> +                       return;
> +               }
>                 raid1_log(mddev, "wait rdev %d blocked", blocked_rdev->raid_disk);
>                 md_wait_for_blocked_rdev(blocked_rdev, mddev);
> -               wait_barrier(conf, bio->bi_iter.bi_sector);
> +               wait_barrier(conf, bio->bi_iter.bi_sector, false);
>                 goto retry_write;
>         }
>
> @@ -1687,7 +1727,7 @@ static void close_sync(struct r1conf *conf)
>         int idx;
>
>         for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++) {
> -               _wait_barrier(conf, idx);
> +               _wait_barrier(conf, idx, false);
>                 _allow_barrier(conf, idx);
>         }
>
> --
> 2.17.1
>
