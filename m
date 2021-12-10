Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4373C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 02:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235861AbhLJCUD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235841AbhLJCUC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 21:20:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E07C061746
        for <linux-raid@vger.kernel.org>; Thu,  9 Dec 2021 18:16:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6BA1B82702
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 02:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EB7C004DD
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 02:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639102585;
        bh=FYn5g9oV2ef1IRChSRjHasarMf4pm5yHLQ1xXca/PVo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JOWrODeNxlfH0vCusvFFzMBat2VI05CoRV+K7pZ5zhdFjgvUCvY8a6r3HGN9iIYaH
         3MT2Un/CDyAUt43+e7XgQb0S2gFWHpJnJquio4G1/yemKQCQN/XmVHTulzIli3/tO0
         SYaCSmQSIj0Uk3TkV7IshowvMhBCODx7kgpLbq+xiFKgt4GQa3MXCepXQzDKaVhQLD
         veT78i/wB9mE+CKt3I5WmrFVHr36i5F9jbQv5TlAaQ/xlKsz9nQ7TA5uMUYySVesnZ
         voCNcSHmFpd0efZxN4x1/iJi5p+poJvZSIPxd/Lw3dhU2PCY5JedlFvdhNHpNFo/s2
         35efRKvez+JXA==
Received: by mail-yb1-f169.google.com with SMTP id v203so18141785ybe.6
        for <linux-raid@vger.kernel.org>; Thu, 09 Dec 2021 18:16:25 -0800 (PST)
X-Gm-Message-State: AOAM531XDk6rT9r/Q4Azk1UvJTHwY7UwyRhDBSCi5IVTsAvuC0/jE7AG
        OJpnXu3N913JeflPAnsSI0rusu9ctTT62wMF8Ko=
X-Google-Smtp-Source: ABdhPJxXVXaKp8dPb0OKRHVhNuIVfHMMMNiBYrZ94bv8Et0SKbP6brbwWF2CJ09ysX6wHoH3IpQKLhaFCA7ol+ohY9c=
X-Received: by 2002:a25:8284:: with SMTP id r4mr11537330ybk.47.1639102584526;
 Thu, 09 Dec 2021 18:16:24 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com> <20211110181441.9263-4-vverma@digitalocean.com>
In-Reply-To: <20211110181441.9263-4-vverma@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 9 Dec 2021 18:16:13 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5drRBWOV9-i7cQWHAwSe5qHff5k23Y2-LsNGS_s8updw@mail.gmail.com>
Message-ID: <CAPhsuW5drRBWOV9-i7cQWHAwSe5qHff5k23Y2-LsNGS_s8updw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 10, 2021 at 10:15 AM Vishal Verma <vverma@digitalocean.com> wrote:
>
> Returns EAGAIN in case the raid456 driver would block
> waiting for situations like:
>
>   - Reshape operation,
>   - Discard operation.
>
> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
> ---
>  drivers/md/raid5.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 9c1a5877cf9f..fa64ee315241 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5710,6 +5710,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
>                 int d;
>         again:
>                 sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0);
> +               /* Bail out if REQ_NOWAIT is set */
> +               if (bi->bi_opf & REQ_NOWAIT) {
> +                       bio_wouldblock_error(bi);
> +                       return;
> +               }

This is not right. raid5_get_active_stripe() gets refcount on the sh,
we cannot simply
return here. I think we need the logic after raid5_release_stripe()
and before schedule().

>                 prepare_to_wait(&conf->wait_for_overlap, &w,
>                                 TASK_UNINTERRUPTIBLE);
>                 set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
> @@ -5820,6 +5825,15 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>         bi->bi_next = NULL;
>
>         md_account_bio(mddev, &bi);
> +       /* Bail out if REQ_NOWAIT is set */
> +       if (bi->bi_opf & REQ_NOWAIT &&
> +           conf->reshape_progress != MaxSector &&
> +           mddev->reshape_backwards
> +           ? logical_sector < conf->reshape_safe
> +           : logical_sector >= conf->reshape_safe) {
> +               bio_wouldblock_error(bi);
> +               return true;
> +       }

This is also problematic, and is the trigger of those error messages.
We only want to trigger -EAGAIN when logical_sector is between
reshape_progress and reshape_safe.

Please let me know if these make sense.

Thanks,
Song
