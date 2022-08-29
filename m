Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B03BECAAD2
	for <linux-raid@archiver.kernel.org>; Mon, 29 Aug 2022 22:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiH2W21 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 Aug 2022 18:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH2W21 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 Aug 2022 18:28:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA417CAB9
        for <linux-raid@vger.kernel.org>; Mon, 29 Aug 2022 15:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0584C612F2
        for <linux-raid@vger.kernel.org>; Mon, 29 Aug 2022 22:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68382C433D7
        for <linux-raid@vger.kernel.org>; Mon, 29 Aug 2022 22:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661812105;
        bh=etLT6ieM2ZdEnh//Pd3Wle+gV1I8PI6BZVaQqEMm0zQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IgChBmD+lPwXJZioKfep8MfR1VA8XC2Eztb2q7QC7+u4zJF1eB7EGmfX//2FRZjbl
         VYgTYoKSzmnpZgyAa2aOR5ZzpuNIXNgphcqp3zI/w9e/4LJFX0jCRcktedBsRzW715
         H6Y2sBiDRQ6dCuSJfmSATArFxIifBtPYMu+pRKirIZioa4MuKBm4Org9v9fyaUfs99
         TrmrbzRWzMrMYKCJstqkXD7tov3WraqV8Atl3VvhWfy+cF2W6mVfVH5pWbEwdvYdC7
         mfpP0UERt11qc/68dMG4lfV1MD6ZSuVwQOFyjuqR4Ie/NYU9OhVyr3jhTMaAaoQAUJ
         cy4enT7aCCJgg==
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-340f82c77baso115711227b3.1
        for <linux-raid@vger.kernel.org>; Mon, 29 Aug 2022 15:28:25 -0700 (PDT)
X-Gm-Message-State: ACgBeo1sU+U+KnFwXp7UeV4+O5DSJVyC4t9QN5clNUGcXiy7jaOsuckA
        Ok5Unqn30wURER2Puc8hNtgwWXwdyQMOgID9fyI=
X-Google-Smtp-Source: AA6agR5UW9IFtumzIbQgqlrc0Zmn0q6YPQjF+Te3deAy2oU02sAqWBM+l97YjVhYd/F52cYkCKRDrRi/VpsvgOzux88=
X-Received: by 2002:a81:1192:0:b0:33e:9091:ae81 with SMTP id
 140-20020a811192000000b0033e9091ae81mr11805779ywr.211.1661812104436; Mon, 29
 Aug 2022 15:28:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220825154627.6879-1-logang@deltatee.com>
In-Reply-To: <20220825154627.6879-1-logang@deltatee.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 29 Aug 2022 15:28:13 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5A_f2ijg=LEYnzn+8b9AzdWBCT3Tz4JRWw2rwyv9TNkg@mail.gmail.com>
Message-ID: <CAPhsuW5A_f2ijg=LEYnzn+8b9AzdWBCT3Tz4JRWw2rwyv9TNkg@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: Ensure stripe_fill happens on non-read IO with journal
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        David Sloan <David.Sloan@eideticom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Aug 25, 2022 at 8:46 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
> When doing degrade/recover tests using the journal a kernel BUG
> is hit at drivers/md/raid5.c:4381 in handle_parity_checks5():
>
>   BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
>
> This was found to occur because handle_stripe_fill() was skipped
> for stripes in the journal due to a condition in that function.
> Thus blocks were not fetched and R5_UPTODATE was not set when
> the code reached handle_parity_checks5().
>
> To fix this, don't skip handle_stripe_fill() unless the stripe is
> for read.
>
> Fixes: 07e83364845e ("md/r5cache: shift complex rmw from read path to write path")
> Link: https://lore.kernel.org/linux-raid/e05c4239-41a9-d2f7-3cfa-4aa9d2cea8c1@deltatee.com/
> Suggested-by: Song Liu <song@kernel.org>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>

Applied to md-next. Thanks!

Song

> ---
>  drivers/md/raid5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 31a0cbf63384..4ec33fd62018 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4047,7 +4047,7 @@ static void handle_stripe_fill(struct stripe_head *sh,
>                  * back cache (prexor with orig_page, and then xor with
>                  * page) in the read path
>                  */
> -               if (s->injournal && s->failed) {
> +               if (s->to_read && s->injournal && s->failed) {
>                         if (test_bit(STRIPE_R5C_CACHING, &sh->state))
>                                 r5c_make_stripe_write_out(sh);
>                         goto out;
>
> base-commit: ba5f3643ff6eed7300fd0cfb327ecb48a8be3fb6
> --
> 2.30.2
