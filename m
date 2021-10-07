Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6806AC433F5
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 06:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BBAF611AE
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 06:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240283AbhJGGWP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Oct 2021 02:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240278AbhJGGWP (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 7 Oct 2021 02:22:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1B216105A
        for <linux-raid@vger.kernel.org>; Thu,  7 Oct 2021 06:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633587621;
        bh=Hkz+TjkDVPMhEjH5ofaYFURCWjpm0Hli/uAcyPQIAN8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VkuYODYVALdLvoEalmGxJXB0nACJG7J/c3G+8MKNN2AiEcEMjOtCS7x4/Erj1VKye
         +jNDsiwIRgjb6P6pJdcnn54NPCVr3tBrHoReX2Z3ccvlbp5xiqHmvvSTqLnuxdlA3R
         cCa1Pb/1QPfF1R7XP+G5wa+S88Wbybb5fDK7CE+ga6j89XVvmnzzK/V6b+OFi3TcK7
         xh3emllzKZGMDUWbAIoAMtQH+YrYlM3sUDkWdbjhPEa28HdVpDd/Dgtzv2GgI9mGDi
         UKgbrLfInxFlQtL1w4qKwH0KFpj8FASxc+SeWBe1BOvnCeZjg/onuztOBsxb02ZJFu
         KcApM9NdDc6Tw==
Received: by mail-lf1-f47.google.com with SMTP id n8so19584870lfk.6
        for <linux-raid@vger.kernel.org>; Wed, 06 Oct 2021 23:20:21 -0700 (PDT)
X-Gm-Message-State: AOAM533QMW3W4LC3Nc9qrUgjVz7BUG73LbDPdoE/RHCXKN/JU4RbbIDJ
        dHw1MmCN0CU7rGDHyptSKtioDxMuyEAr9XvLdsY=
X-Google-Smtp-Source: ABdhPJz2pBMSCQNvn8y6EwUpM39x30HfQQoJ4PzPFH8hQT7Fms5a/uSLnb0hRUrj7VF4kdlPbm5X13iu+FZbrtuhwyI=
X-Received: by 2002:a05:6512:39c4:: with SMTP id k4mr2474991lfu.14.1633587620266;
 Wed, 06 Oct 2021 23:20:20 -0700 (PDT)
MIME-Version: 1.0
References: <20211004153453.14051-1-guoqing.jiang@linux.dev> <20211004153453.14051-5-guoqing.jiang@linux.dev>
In-Reply-To: <20211004153453.14051-5-guoqing.jiang@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Wed, 6 Oct 2021 23:20:09 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5DF-5O19M6GFCsdjZbtNSiG__QO4JqynFYpMBD0FTQuw@mail.gmail.com>
Message-ID: <CAPhsuW5DF-5O19M6GFCsdjZbtNSiG__QO4JqynFYpMBD0FTQuw@mail.gmail.com>
Subject: Re: [PATCH 4/6] md/raid10: add 'read_err' to raid10_read_request
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Oct 4, 2021 at 8:40 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> Add the paramenter since the err retry logic is only meaningful when
> the caller is handle_read_error.
>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
>  drivers/md/raid10.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index aa2636582841..29eb538db953 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1116,7 +1116,7 @@ static void regular_request_wait(struct mddev *mddev, struct r10conf *conf,
>  }
>
>  static void raid10_read_request(struct mddev *mddev, struct bio *bio,
> -                               struct r10bio *r10_bio)
> +                               struct r10bio *r10_bio, bool read_err)
>  {
>         struct r10conf *conf = mddev->private;
>         struct bio *read_bio;
> @@ -1129,7 +1129,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>         struct md_rdev *err_rdev = NULL;
>         gfp_t gfp = GFP_NOIO;
>
> -       if (slot >= 0 && r10_bio->devs[slot].rdev) {
> +       if (read_err && slot >= 0 && r10_bio->devs[slot].rdev) {

How about we just move this section to a separate function?

Thanks,
Song

>                 /*
>                  * This is an error retry, but we cannot
>                  * safely dereference the rdev in the r10_bio,
> @@ -1519,7 +1519,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
>                         conf->geo.raid_disks);
>
>         if (bio_data_dir(bio) == READ)
> -               raid10_read_request(mddev, bio, r10_bio);
> +               raid10_read_request(mddev, bio, r10_bio, false);
>         else
>                 raid10_write_request(mddev, bio, r10_bio);
>  }
> @@ -2918,7 +2918,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
>         rdev_dec_pending(rdev, mddev);
>         allow_barrier(conf);
>         r10_bio->state = 0;
> -       raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
> +       raid10_read_request(mddev, r10_bio->master_bio, r10_bio, true);
>  }
>
>  static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
> --
> 2.31.1
>
