Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84853C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  9 Nov 2022 22:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiKIWJB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Nov 2022 17:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiKIWI7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Nov 2022 17:08:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F8E303E3
        for <linux-raid@vger.kernel.org>; Wed,  9 Nov 2022 14:08:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5391861CFE
        for <linux-raid@vger.kernel.org>; Wed,  9 Nov 2022 22:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA266C433D7
        for <linux-raid@vger.kernel.org>; Wed,  9 Nov 2022 22:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668031735;
        bh=tBsklYpWzAcBLml//X5oGRl0nkCA74Sy6OFpeO3JWNU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hXtM3sqESvjF7+9C6r0r9A2klr+IQeyhWybGA9N5N3AD4N0rQkQxYDvSZAt/Ck2gz
         prWcDiT5iYREX7hYJfQpElHpeF1/2COtWTOTwgyw35FvjXX7wTHkApAGF6ewKDPE/7
         JcvhSsKSBag4wZz9s0eo9TfmwgTcBeL+Sqn0/GuRt/FonmuNHMBN0/N4ihN3CfL2rq
         r1pAFAIyPobUcZDxNo2OSm0yOM6d3+RRC4niGzQj2Ul4tHLkXM9u5SYW/UE8MAoRzq
         U7CHm+q6zumx7rIqOJLoJ9+lhKVBldySMlbAPKJYw8WPCl2TrHdkEbsCqOU6Z4CZ6V
         MMY+l1lqNOwcw==
Received: by mail-ej1-f43.google.com with SMTP id t25so389529ejb.8
        for <linux-raid@vger.kernel.org>; Wed, 09 Nov 2022 14:08:55 -0800 (PST)
X-Gm-Message-State: ACrzQf26PBzQ5oyHioLpWGFzwEVN2HASSdl8gaJn8fHk2t8j3wpRmMzW
        Z9jjqyhUUiFSaz13S/yq/1TJ43pc84LC0tvuuJY=
X-Google-Smtp-Source: AMsMyM6iDLfRRqM9D3sSL+j/B0hBza1OjX+Mv5xO49lzdJZfUxLIKI753SyBfIrXNCU7auNbwJgRr54FU+lJz6psN7M=
X-Received: by 2002:a17:907:b602:b0:7ad:e82c:3355 with SMTP id
 vl2-20020a170907b60200b007ade82c3355mr45112939ejc.3.1668031733907; Wed, 09
 Nov 2022 14:08:53 -0800 (PST)
MIME-Version: 1.0
References: <20221109101037.2414944-1-hch@lst.de>
In-Reply-To: <20221109101037.2414944-1-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Wed, 9 Nov 2022 14:08:42 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6OjTvMFQsAz2oVO5U5unf2ubkXkj3fT-qa0FP3m--L9Q@mail.gmail.com>
Message-ID: <CAPhsuW6OjTvMFQsAz2oVO5U5unf2ubkXkj3fT-qa0FP3m--L9Q@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: use bdev_write_cache instead of open coding it
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 9, 2022 at 2:10 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Use the bdev_write_cache instead of two equivalent open coded checks.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Applied to md-next. Thanks!
Song

> ---
>  drivers/md/raid5-cache.c | 5 +----
>  drivers/md/raid5-ppl.c   | 5 +----
>  2 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 832d8566e1656..4458b551ec4d0 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -3061,7 +3061,6 @@ void r5c_update_on_rdev_error(struct mddev *mddev, struct md_rdev *rdev)
>
>  int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
>  {
> -       struct request_queue *q = bdev_get_queue(rdev->bdev);
>         struct r5l_log *log;
>         int ret;
>
> @@ -3090,9 +3089,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
>         if (!log)
>                 return -ENOMEM;
>         log->rdev = rdev;
> -
> -       log->need_cache_flush = test_bit(QUEUE_FLAG_WC, &q->queue_flags) != 0;
> -
> +       log->need_cache_flush = bdev_write_cache(rdev->bdev);
>         log->uuid_checksum = crc32c_le(~0, rdev->mddev->uuid,
>                                        sizeof(rdev->mddev->uuid));
>
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index 31b9157bc9ae9..e495939bb3e03 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -1301,8 +1301,6 @@ static int ppl_validate_rdev(struct md_rdev *rdev)
>
>  static void ppl_init_child_log(struct ppl_log *log, struct md_rdev *rdev)
>  {
> -       struct request_queue *q;
> -
>         if ((rdev->ppl.size << 9) >= (PPL_SPACE_SIZE +
>                                       PPL_HEADER_SIZE) * 2) {
>                 log->use_multippl = true;
> @@ -1316,8 +1314,7 @@ static void ppl_init_child_log(struct ppl_log *log, struct md_rdev *rdev)
>         }
>         log->next_io_sector = rdev->ppl.sector;
>
> -       q = bdev_get_queue(rdev->bdev);
> -       if (test_bit(QUEUE_FLAG_WC, &q->queue_flags))
> +       if (bdev_write_cache(rdev->bdev))
>                 log->wb_cache_on = true;
>  }
>
> --
> 2.30.2
>
