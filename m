Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179D4C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 22 Dec 2021 23:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243401AbhLVX6c (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Dec 2021 18:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbhLVX6b (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Dec 2021 18:58:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226CFC061574
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 15:58:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA996B81CF8
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 23:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF5DC36AE8
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 23:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640217507;
        bh=0EaoO8S2CyD4P+U4uGwXMIj4TG/r2wyDdgxYwJHvHew=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kmF9GkUdO+hLfyY894jcpacsMroG40JOA8B1aEmbgBlEH9LcVJOW2H6s0eE76hCDZ
         BzSstrdzU2t9v/f2SYi8dI5ez4oh/K9mowZ09ewOIGDbxLqHCcr+MjBcUfOuk4MInl
         k0RUibNPsfsRDtf84pxVXP12arOTLiEsJI4ieTHgNJI107mGDYjqXE0BS1A5uAkQOm
         yuQMng+7S6Zk+r3lxkNwOHUyvfroUPHEZya2KYyjv7b3Nt7zhScD9wa49Ya25g/cHq
         WjyvbNty77P0rlVQa9hXqi3k7KdXrRI0xTzIxibiqdx520Vpq2tNHjG2dGGaALan6V
         s9ARdx1On7zkg==
Received: by mail-yb1-f172.google.com with SMTP id q74so11157264ybq.11
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 15:58:27 -0800 (PST)
X-Gm-Message-State: AOAM531BmBziUvf0JRxEZn7VhyBXrA9/Nw+x/XpCgsQITCWwE0i/5kNG
        jNTFnQLTxtqyOl1/zlqU2RX+rfNTz+K3Tr37yEs=
X-Google-Smtp-Source: ABdhPJxlNPdyxv+/C3xGZg4/rbk8kBiSlfNFDv4QKWz1CrgK9PSnuHL9GQWJZtEymZtk+LwaT/h2VaoG75kckZ5vKYc=
X-Received: by 2002:a25:bf8f:: with SMTP id l15mr28136ybk.670.1640217506729;
 Wed, 22 Dec 2021 15:58:26 -0800 (PST)
MIME-Version: 1.0
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com> <20211221200622.29795-3-vverma@digitalocean.com>
In-Reply-To: <20211221200622.29795-3-vverma@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 22 Dec 2021 15:58:15 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4BALFg1-3msFuRdsg9was5EvZiO5Jwt51f3dTVwSAY_g@mail.gmail.com>
Message-ID: <CAPhsuW4BALFg1-3msFuRdsg9was5EvZiO5Jwt51f3dTVwSAY_g@mail.gmail.com>
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

This doesn't sound right: regular_request_wait() is called in two
places. But we are
not checking the return value in either of them.

Song
[...]
