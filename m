Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 118C9C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 24 Sep 2021 21:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E65D76140A
	for <linux-raid@archiver.kernel.org>; Fri, 24 Sep 2021 21:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346894AbhIXVLo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Sep 2021 17:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233217AbhIXVLo (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 24 Sep 2021 17:11:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 918986140F
        for <linux-raid@vger.kernel.org>; Fri, 24 Sep 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632517810;
        bh=f5h2ldwGpyAo9ota7BSHUvS661W+1jlBhKdeM5u78z8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Hpk3NjrzRPht+pcUi1UKc0+5uvS9i3BWyoJY9jvRqppUu7GgZo5wakM4Pb2kXM80N
         X+OgiF22K2rOg5k/a+0yNKE4dHI9t3oSjlfwuAOs6LBsj7XpUaN8u2nTP433EjD7Fb
         dzpYIQmCi4L02j/ybuC293Bwzbk6FwkGp/aowl2ccIGwSvV0H7PWmvDH7ISSpCJZFF
         C2Oh2bBE5mJMEhar0eCm4IXSR7IUmcZ54hQu86e/UmnwQ6dwPeRaBrq3H3G1oBNrSK
         bPZCy8Q6QOSifx/QpAWLgsJTTKGPqu4Xo87MtauHCFDpbPmEJZ+zxSjZMy0TCTvAhv
         gqncjJ3zJdzwQ==
Received: by mail-lf1-f41.google.com with SMTP id i25so46025343lfg.6
        for <linux-raid@vger.kernel.org>; Fri, 24 Sep 2021 14:10:10 -0700 (PDT)
X-Gm-Message-State: AOAM530g0hslP6YgrJ3RSnPpjHah5JmaW8NLkCtSLAJBPViqL4JpO5l+
        SmJf4hK0ipox1cjJYVM9rTO1SPNtxPwNIFDnI54=
X-Google-Smtp-Source: ABdhPJwA+ksmgKDOmoWE6Dw48eXe4IrrlQJ9bxW4z2BcCnV9uWahlsOONz4oogztXYsqhGjuFrTSs2zB7PX/l5aewKQ=
X-Received: by 2002:a05:651c:b0b:: with SMTP id b11mr13665269ljr.234.1632517808941;
 Fri, 24 Sep 2021 14:10:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210917153452.5593-1-mariusz.tkaczyk@linux.intel.com> <20210917153452.5593-2-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20210917153452.5593-2-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 24 Sep 2021 14:09:56 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com>
Message-ID: <CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com>
Subject: Re: [PATCH 1/2] md, raid1, raid10: Set MD_BROKEN for RAID1 and RAID10
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Sep 17, 2021 at 8:35 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> The idea of stopping all writes if devices is failed, introduced by
> 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and fail BIOs if
> a member is gone") seems to be reasonable so use MD_BROKEN for RAID1 and
> RAID10. Support in RAID456 is added in next commit.
> If userspace (mdadm) forces md to fail the device (Failure state
> written via sysfs), then EBUSY is expected if array will become failed.
> To achieve that, check for MD_BROKEN and if is set, then return EBUSY to
> be complaint with userspace.
> For faulty state, handled via ioctl, let the error_handler to decide.
>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Thanks for the patch and sorry for the late reply.

> ---
>  drivers/md/md.c     | 16 ++++++++++------
>  drivers/md/md.h     |  4 ++--
>  drivers/md/raid1.c  |  1 +
>  drivers/md/raid10.c |  1 +
>  4 files changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c322841d4edc..ac20eb2ddff7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -926,8 +926,9 @@ static void super_written(struct bio *bio)
>                 pr_err("md: %s gets error=%d\n", __func__,
>                        blk_status_to_errno(bio->bi_status));
>                 md_error(mddev, rdev);
> -               if (!test_bit(Faulty, &rdev->flags)
> -                   && (bio->bi_opf & MD_FAILFAST)) {
> +               if (!test_bit(Faulty, &rdev->flags) &&
> +                    !test_bit(MD_BROKEN, &mddev->flags) &&
> +                    (bio->bi_opf & MD_FAILFAST)) {

So with MD_BROKEN, we will not try to update the SB?

>                         set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>                         set_bit(LastDev, &rdev->flags);
>                 }
> @@ -2979,7 +2980,8 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>         int err = -EINVAL;
>         if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
>                 md_error(rdev->mddev, rdev);
> -               if (test_bit(Faulty, &rdev->flags))
> +
> +               if (!test_bit(MD_BROKEN, &rdev->mddev->flags))

I don't think this makes much sense. EBUSY for already failed array
sounds weird.
Also, shall we also set MD_BROKEN here?

>                         err = 0;
>                 else
>                         err = -EBUSY;
> @@ -7974,12 +7976,14 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>         if (!mddev->pers || !mddev->pers->error_handler)
>                 return;
>         mddev->pers->error_handler(mddev,rdev);
> -       if (mddev->degraded)
> +       if (mddev->degraded && !test_bit(MD_BROKEN, &mddev->flags))
>                 set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>         sysfs_notify_dirent_safe(rdev->sysfs_state);
>         set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -       set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -       md_wakeup_thread(mddev->thread);
> +       if (!test_bit(MD_BROKEN, &mddev->flags)) {
> +               set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +               md_wakeup_thread(mddev->thread);
> +       }
>         if (mddev->event_work.func)
>                 queue_work(md_misc_wq, &mddev->event_work);
>         md_new_event(mddev);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 4c96c36bd01a..e01433f3b46a 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -259,8 +259,8 @@ enum mddev_flags {
>         MD_NOT_READY,           /* do_md_run() is active, so 'array_state'
>                                  * must not report that array is ready yet
>                                  */
> -       MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
> -                                * I/O in case an array member is gone/failed.
> +       MD_BROKEN,              /* This is used to stop I/O and mark device as
> +                                * dead in case an array becomes failed.
>                                  */
>  };
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 19598bd38939..79462d860177 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1639,6 +1639,7 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>                  */
>                 conf->recovery_disabled = mddev->recovery_disabled;
>                 spin_unlock_irqrestore(&conf->device_lock, flags);
> +               set_bit(MD_BROKEN, &mddev->flags);
>                 return;
>         }
>         set_bit(Blocked, &rdev->flags);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index aa2636582841..02a4d84b4d2e 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1964,6 +1964,7 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>                  * Don't fail the drive, just return an IO error.
>                  */
>                 spin_unlock_irqrestore(&conf->device_lock, flags);
> +               set_bit(MD_BROKEN, &mddev->flags);
>                 return;
>         }
>         if (test_and_clear_bit(In_sync, &rdev->flags))
> --
> 2.26.2
>
