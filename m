Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B12CC43217
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 06:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbiEIGwP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 May 2022 02:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235007AbiEIGmR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 May 2022 02:42:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF90318C5BB
        for <linux-raid@vger.kernel.org>; Sun,  8 May 2022 23:38:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12B3D6120C
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 06:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4F6C385AB
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 06:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652078287;
        bh=3tG7YDqt4ro5bBJHs+KmHoHIsp9UMgdAuUAgUE95sN4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WcL6Ga8HupbuF93hk3rxJh0BDYQnsy0NWFzD/tM+87FAPRdpRcpujj16TSfr6b+g8
         3cK09DkZZ9LKJ6Ik2xp9AOdplLO/zbmfhhss6wPoi3Xk+HaRvQo+VKh+mRN+cZMnPX
         VPua5Gx6eXX30FOuTib82TKMrXZF9BACj9EfZEgRVqk4uNIKNRUD8WzDtVcLKrnICm
         KxMyAf6r+BVieI0DN3Qo51dPoJLjlg9UK2EVdxisT9yXfLii+CYcvsPc/DZHoVPzOv
         59ZXbmn3boHvGjuCuOqRoj9DqZ5qEBoHBTTFU+jm8C2ZUZbCAMjVyCTDqiYjITYXeQ
         JHmj5flC4K5dg==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-2f16645872fso133175807b3.4
        for <linux-raid@vger.kernel.org>; Sun, 08 May 2022 23:38:07 -0700 (PDT)
X-Gm-Message-State: AOAM532F5zMpw3EhjLaMdBfxU/8eiMiHEi/Txj7+b720Jc1i9VsSORjO
        lVzG/uzc+9cL+Tx7qK4g3XCCysjtoVFkoUilF1c=
X-Google-Smtp-Source: ABdhPJwobpCefaJhAhOGV/+LAIDu2yHARQijRQV9wFdyy92isVrCK7snziSVsLYrOw/LgLQFbtu9JsVjWEFwGtZxyeU=
X-Received: by 2002:a0d:d787:0:b0:2f4:dfc5:9a70 with SMTP id
 z129-20020a0dd787000000b002f4dfc59a70mr12831679ywd.447.1652078286431; Sun, 08
 May 2022 23:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220505081641.21500-1-guoqing.jiang@linux.dev> <20220506113656.25010-1-guoqing.jiang@linux.dev>
In-Reply-To: <20220506113656.25010-1-guoqing.jiang@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Sun, 8 May 2022 23:37:55 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
Message-ID: <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, May 6, 2022 at 4:37 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>
> Unregister sync_thread doesn't need to hold reconfig_mutex since it
> doesn't reconfigure array.
>
> And it could cause deadlock problem for raid5 as follows:
>
> 1. process A tried to reap sync thread with reconfig_mutex held after echo
>    idle to sync_action.
> 2. raid5 sync thread was blocked if there were too many active stripes.
> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
>    which causes the number of active stripes can't be decreased.
> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
>    to hold reconfig_mutex.
>
> More details in the link:
> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
>
> Let's call unregister thread between mddev_unlock and mddev_lock_nointr
> (thanks for the report from kernel test robot <lkp@intel.com>) if the
> reconfig_mutex is held, and mddev_is_locked is introduced accordingly.

mddev_is_locked() feels really hacky to me. It cannot tell whether
mddev is locked
by current thread. So technically, we can unlock reconfigure_mutex for
other thread
by accident, no?


>
> Reported-by: Donald Buczek <buczek@molgen.mpg.de>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
>  drivers/md/md.c | 9 ++++++++-
>  drivers/md/md.h | 5 +++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 309b3af906ad..525f65682356 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9432,10 +9432,17 @@ void md_reap_sync_thread(struct mddev *mddev)
>  {
>         struct md_rdev *rdev;
>         sector_t old_dev_sectors = mddev->dev_sectors;
> -       bool is_reshaped = false;
> +       bool is_reshaped = false, is_locked = false;
>
> +       if (mddev_is_locked(mddev)) {
> +               is_locked = true;
> +               mddev_unlock(mddev);
> +       }
>         /* resync has finished, collect result */
>         md_unregister_thread(&mddev->sync_thread);
> +       if (is_locked)
> +               mddev_lock_nointr(mddev);
> +
>         if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>             !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
>             mddev->degraded != mddev->raid_disks) {
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 6ac283864533..af6f3978b62b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -549,6 +549,11 @@ static inline int mddev_trylock(struct mddev *mddev)
>  }
>  extern void mddev_unlock(struct mddev *mddev);
>
> +static inline int mddev_is_locked(struct mddev *mddev)
> +{
> +       return mutex_is_locked(&mddev->reconfig_mutex);
> +}
> +
>  static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
>  {
>         atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
> --
> 2.31.1
>
