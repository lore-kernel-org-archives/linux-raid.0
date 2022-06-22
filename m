Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31255C43334
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 23:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377265AbiFVXck (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 19:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359248AbiFVXci (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 19:32:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA696424B1
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 16:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88C35B8204D
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 23:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F95C341C6
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 23:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655940755;
        bh=DLTkfUqDXHysyErLbteZVoL2oRuSMOztxY2gKii8NEI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b4HXfERu9UOPB+MlC6UhGtseyepb8AV5Lzi2czgJW+ZfrwxvU9QuK4AjwNWRknjIo
         ri/TdDkBujuoJmUGbu0NXmbi/pJBcqbTIXTTMaM/7YoiHfTtl9eSLDzUmRHbDSgmHp
         XMiN899By18026cW4iBFzm7daojVc9P5QOJOFPabo165LuPp5uS1L0+x5dVG2FFfw5
         CrwP7BgTkEaxlc52hfyMc1R3ilBwnKHWkM82jco1scClwC39Bk6ixaMeS1DxhyG6iP
         NqGfLc7OFkE2wsU8dCdUJ8c6NLcqUgy1p6MXA55e8SOxJIdTPUsl24+5ByUixVtUYd
         wLwSHt3/Mf4iw==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-3176d94c236so178422267b3.3
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 16:32:35 -0700 (PDT)
X-Gm-Message-State: AJIora+tKR7NmuPVVRLl6Plzz664fNATBKu+2h3nZtldhy4lzbAelI1y
        JnXi5KcDIHnisTdunIyFzgWFRVfH+QkXxaSUPX8=
X-Google-Smtp-Source: AGRyM1uojdUUjRzyVtg6gGxnnjvqYyblrqg+dNuFcEJ2q4fhkhwCys1hY5PiyMPDjv5gbI+LFiEXjy5+qNvYs9mVEtg=
X-Received: by 2002:a81:4ed4:0:b0:317:9581:589b with SMTP id
 c203-20020a814ed4000000b003179581589bmr7145367ywb.472.1655940754213; Wed, 22
 Jun 2022 16:32:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220621031129.24778-1-guoqing.jiang@linux.dev>
In-Reply-To: <20220621031129.24778-1-guoqing.jiang@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Wed, 22 Jun 2022 16:32:23 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5SGxiosMw28km7v7bM9qSDRGbLFvyyH1nsAPg2_RcZgA@mail.gmail.com>
Message-ID: <CAPhsuW5SGxiosMw28km7v7bM9qSDRGbLFvyyH1nsAPg2_RcZgA@mail.gmail.com>
Subject: Re: [PATCH V2] md: unlock mddev before reap sync_thread in action_store
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jun 20, 2022 at 8:11 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> Since the bug which commit 8b48ec23cc51a ("md: don't unregister sync_thread
> with reconfig_mutex held") fixed is related with action_store path, other
> callers which reap sync_thread didn't need to be changed.
>
> Let's pull md_unregister_thread from md_reap_sync_thread, then fix previous
> bug with belows.
>
> 1. unlock mddev before md_reap_sync_thread in action_store.
> 2. save reshape_position before unlock, then restore it to ensure position
>    not changed accidentally by others.
>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
> V2 changes:
> 1. add set_bit(MD_RECOVERY_INTR, &mddev->recovery) before unregister sync thread
>
> And I didn't find regression with this version after run mdadm tests.
>
>  drivers/md/dm-raid.c |  1 +
>  drivers/md/md.c      | 19 +++++++++++++++++--
>  2 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 9526ccbedafb..d43b8075c055 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3725,6 +3725,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
>         if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
>                 if (mddev->sync_thread) {
>                         set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +                       md_unregister_thread(&mddev->sync_thread);
>                         md_reap_sync_thread(mddev);
>                 }
>         } else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c7ecb0bffda0..04bab0511312 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4830,6 +4830,19 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>                         if (work_pending(&mddev->del_work))
>                                 flush_workqueue(md_misc_wq);
>                         if (mddev->sync_thread) {
> +                               sector_t save_rp = mddev->reshape_position;
> +
> +                               mddev_unlock(mddev);
> +                               set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +                               md_unregister_thread(&mddev->sync_thread);
> +                               mddev_lock_nointr(mddev);
> +                               /*
> +                                * set RECOVERY_INTR again and restore reshape
> +                                * position in case others changed them after
> +                                * got lock, eg, reshape_position_store and
> +                                * md_check_recovery.
> +                                */

Hmm.. do we really need to handle reshape_position changed case? What would
break if we don't?

Thanks,
Song

> +                               mddev->reshape_position = save_rp;
>                                 set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>                                 md_reap_sync_thread(mddev);
>                         }
> @@ -6197,6 +6210,7 @@ static void __md_stop_writes(struct mddev *mddev)
>                 flush_workqueue(md_misc_wq);
>         if (mddev->sync_thread) {
>                 set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +               md_unregister_thread(&mddev->sync_thread);
>                 md_reap_sync_thread(mddev);
>         }
>
> @@ -9303,6 +9317,7 @@ void md_check_recovery(struct mddev *mddev)
>                          * ->spare_active and clear saved_raid_disk
>                          */
>                         set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +                       md_unregister_thread(&mddev->sync_thread);
>                         md_reap_sync_thread(mddev);
>                         clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>                         clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> @@ -9338,6 +9353,7 @@ void md_check_recovery(struct mddev *mddev)
>                         goto unlock;
>                 }
>                 if (mddev->sync_thread) {
> +                       md_unregister_thread(&mddev->sync_thread);
>                         md_reap_sync_thread(mddev);
>                         goto unlock;
>                 }
> @@ -9417,8 +9433,7 @@ void md_reap_sync_thread(struct mddev *mddev)
>         sector_t old_dev_sectors = mddev->dev_sectors;
>         bool is_reshaped = false;
>
> -       /* resync has finished, collect result */
> -       md_unregister_thread(&mddev->sync_thread);
> +       /* sync_thread should be unregistered, collect result */
>         if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>             !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
>             mddev->degraded != mddev->raid_disks) {
> --
> 2.31.1
>
