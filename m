Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85FD3C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 05:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69B8060F70
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 05:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhKBFEA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Nov 2021 01:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhKBFEA (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 2 Nov 2021 01:04:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFF8F60F70
        for <linux-raid@vger.kernel.org>; Tue,  2 Nov 2021 05:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635829285;
        bh=ByfyOcitv+4O08k7RVoIQPt8s652jXJryeDCyPHRfiE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KBm6kya2cIRiBDVAR7B293LfgBhxdsMZaGliQFyfy7tvOfpjeFlsnpF+K0lm/Xttr
         ZPctU9p1Z5/iVsTX95bjO72sW+5AGqPTT1EAGH3oGsfCcP3SS+ZShLlfPeyI3dZ8h3
         bLelMTllEDcH4S0ukCiSd6upJl/o+CY++Pxs4Tl7aIxwxxduwcy4V6mWZm2a78n6TE
         +cosgmS1qpq9Wm/SEIfhAyWTWF+9uGx6MQn8ciqBRaezBsfn1mWgwonHbI857YKx2Z
         ze4/5VDTuICFb8VfFy4DE1OlMy/idWe9kSLq1w5gTPspZso4Rms9S7o6E8qy8Lc3DW
         pCcPwbsJV6Wow==
Received: by mail-lj1-f169.google.com with SMTP id k24so13458522ljg.3
        for <linux-raid@vger.kernel.org>; Mon, 01 Nov 2021 22:01:25 -0700 (PDT)
X-Gm-Message-State: AOAM5330Hv4zPO1t1pQd51PwtknMSeF6XP3SeoSF75ds66rKu31v4S2U
        AD1ApG/51FA8Dh8DWifFMOZ9SpFV34E3CrdSUww=
X-Google-Smtp-Source: ABdhPJzL1fAnNkTS9gxJ1kQkQxQsc21KC5l/JEBgIk2xCqjYTw6XNDa4CkZhvpaeJRZq/SNSuMdsPDjnEck/ShvLOc0=
X-Received: by 2002:a2e:b8cd:: with SMTP id s13mr18129489ljp.527.1635829284094;
 Mon, 01 Nov 2021 22:01:24 -0700 (PDT)
MIME-Version: 1.0
References: <20211101215143.1580-1-vverma@digitalocean.com>
In-Reply-To: <20211101215143.1580-1-vverma@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 1 Nov 2021 22:01:12 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5FpeS9AfPYpNgHGCp8dP151g-t8whSiGyuxEfp2O92tg@mail.gmail.com>
Message-ID: <CAPhsuW5FpeS9AfPYpNgHGCp8dP151g-t8whSiGyuxEfp2O92tg@mail.gmail.com>
Subject: Re: [PATCH] md: add support for REQ_NOWAIT
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Nov 1, 2021 at 2:52 PM Vishal Verma <vverma@digitalocean.com> wrote:
>
> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
> for checking whether a given bdev supports handling of REQ_NOWAIT or not.
> Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable
> it for linear target") added support for REQ_NOWAIT for dm. This uses
> a similar approach to incorporate REQ_NOWAIT for md based bios.
>
> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
> ---
>  drivers/md/md.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5111ed966947..51b2df32aed5 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -419,6 +419,12 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
>         if (is_suspended(mddev, bio)) {
>                 DEFINE_WAIT(__wait);
>                 for (;;) {
> +                       /* Bail out if REQ_NOWAIT is set for the bio */
> +                       if (bio->bi_opf & REQ_NOWAIT) {
> +                               bio_wouldblock_error(bio);
> +                               break;

This doesn't look right to me. We already run bio_endio() in
bio_wouldblock_error(), then we still feed the bio to make_request().
Did I misread the logic?

Please also explain how this patch was tested.

Thanks,
Song

> +                       }
> +
>                         prepare_to_wait(&mddev->sb_wait, &__wait,
>                                         TASK_UNINTERRUPTIBLE);
>                         if (!is_suspended(mddev, bio))


[...]
