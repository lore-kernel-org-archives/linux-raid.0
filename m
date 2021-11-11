Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEDCC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 11 Nov 2021 21:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7834860FC1
	for <linux-raid@archiver.kernel.org>; Thu, 11 Nov 2021 21:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhKKVpZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 Nov 2021 16:45:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229868AbhKKVpY (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 11 Nov 2021 16:45:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA02C60F6E
        for <linux-raid@vger.kernel.org>; Thu, 11 Nov 2021 21:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636666954;
        bh=J963HWk0uAcNpEQOjesO+iUMM7rQLP9nvvkI58oYsYs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rLFCagttFET6uyCPdqzRI+Pi//bQZUcGZDAEz+0tNV/+qUI5rS7yQOUaQqbp9MF72
         ic6C07gLGJFu4n2GecRLMGGMmodalvqtIe1ynVPpKm7xSkr2h98IyFqBFoiHJlwXvz
         EUEpZy+/ukS5jaRtOreBFcvpJs+Z1Kq69WneU3x3CA85sfbyeXcB0rSDCxxK24al8r
         ejs9KWzLPCyAvMF//a9EbMWBdTbB2FOuKZulQrotPOrGk6aPTFRRpSPITRV2C1tiBo
         xBvyBX52+8jSbVU53WTSrxNB4HpJrd5RiDOWlDux1NX44U+KXiBy/HOGuMQGIX2NzB
         Ahh6OTZIkaA8A==
Received: by mail-yb1-f177.google.com with SMTP id v138so18485289ybb.8
        for <linux-raid@vger.kernel.org>; Thu, 11 Nov 2021 13:42:34 -0800 (PST)
X-Gm-Message-State: AOAM53131T32PsFrfIUK9RM79z0ONePwBB1Hfw612oWutVlaC4G2ITvl
        /b6oaeuL6qVSNShMiVN/Mc7Tt1G9xqgy0duEUro=
X-Google-Smtp-Source: ABdhPJzm9NdUcyqB3lhAaQD97m+Vg3s3eH02i+A1rWNiikWm5XM8vMFAUykFcQbyZb4bGSySx/TMDwwdJ41CbXLkVd8=
X-Received: by 2002:a25:8882:: with SMTP id d2mr11706807ybl.68.1636666954074;
 Thu, 11 Nov 2021 13:42:34 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com> <20211110181441.9263-4-vverma@digitalocean.com>
In-Reply-To: <20211110181441.9263-4-vverma@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 11 Nov 2021 13:42:23 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7=r4AmCqG3M0hU=fps6a-Zu9KF_RnyNf815d=43wTv5A@mail.gmail.com>
Message-ID: <CAPhsuW7=r4AmCqG3M0hU=fps6a-Zu9KF_RnyNf815d=43wTv5A@mail.gmail.com>
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

I think you mentioned there are some task hung issues, could you
please provide some
information about them?

btw: I am taking vacation this week. So I may not have time to try it
out until next week.

Thanks,
Song

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
>         prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
>         for (; logical_sector < last_sector; logical_sector += RAID5_STRIPE_SECTORS(conf)) {
>                 int previous;
> --
> 2.17.1
>
