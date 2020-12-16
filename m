Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F46C4361B
	for <linux-raid@archiver.kernel.org>; Wed, 16 Dec 2020 04:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D065E23118
	for <linux-raid@archiver.kernel.org>; Wed, 16 Dec 2020 04:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgLPE1l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:27:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPE1l (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 15 Dec 2020 23:27:41 -0500
X-Gm-Message-State: AOAM533Bqi/ieAaFJbajH0jIYcM6GiU+3KZmjmS1Wd99G4iRP+YEX4Qp
        ipMdnzzfLjKIb1schXU7fhVLXuAc6NknBCQPMsY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608092820;
        bh=VaMI9S0fxHCWxeT+kiixvlt8RBSjwFKlJRbKTJIViZE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Cm+93B/JVlAG7QAfaw/ipBjmpUcanxZTHqgY5BlDL4Hn7JQKvNzyqLV6Vywcxk3HI
         yotrr23zLqOww1YT+z02Wd9zoz1MRK3mjha8hcTGxEHzvMXyHETLEHvHIg62qjdPuy
         LSp8TS6rnGWhasCVmx0L7MajM6dwYiNi1BckkZ7YjN0kiG6ZWYMqEFxczve4GYLb/K
         uHrAm5fqkRFBVOEHRlgVho84eAirw1zuvvQg1ZwH9kuyV+pJKSelS4Lo3E2rF2b9s3
         5ktV2HbEuHjCMBmcsk3zqb4SfB+P868+A06qX3GzmfREZbzx1aYSl1sK3PZA/5hFu0
         xDNvaGmV6zItw==
X-Google-Smtp-Source: ABdhPJyNQ2kM8T3knQnEXeXBYoHDrUNz7j2jj59gCiaIXMytKg2Sf9dbjashh78OGztLiKopndhmMmpayqMl6bRI+Pw=
X-Received: by 2002:a19:650:: with SMTP id 77mr487077lfg.160.1608092818931;
 Tue, 15 Dec 2020 20:26:58 -0800 (PST)
MIME-Version: 1.0
References: <1608081982-10839-1-git-send-email-guoqing.jiang@cloud.ionos.com>
In-Reply-To: <1608081982-10839-1-git-send-email-guoqing.jiang@cloud.ionos.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 15 Dec 2020 20:26:47 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4E+cxg3b7H2Mczp9AyD2T_uwLeKDjGUtWcw7rdPpNaPw@mail.gmail.com>
Message-ID: <CAPhsuW4E+cxg3b7H2Mczp9AyD2T_uwLeKDjGUtWcw7rdPpNaPw@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: cast chunk_sectors to sector_t value
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 15, 2020 at 5:26 PM Guoqing Jiang
<guoqing.jiang@cloud.ionos.com> wrote:
>
> Currently, raid5 calculates dev_sectors from chunk_sectors without
> proper cast, which is problematic.
>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> ---
> I think the recently report about raid5 issue could be related with
> the setting of dev_sectors.
>
> Could someone test it with a large raid5 array? Thanks.

Yes, this was the exact problem. I will apply this to md-next. (probably
after the merge window).

Thanks,
Song

>
>  drivers/md/raid5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 3934347..ca0b29a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7662,7 +7662,7 @@ static int raid5_run(struct mddev *mddev)
>         }
>
>         /* device size must be a multiple of chunk size */
> -       mddev->dev_sectors &= ~(mddev->chunk_sectors - 1);
> +       mddev->dev_sectors &= ~((sector_t)mddev->chunk_sectors - 1);
>         mddev->resync_max_sectors = mddev->dev_sectors;
>
>         if (mddev->degraded > dirty_parity_disks &&
> --
> 2.7.4
>
