Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8312BC4338F
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jul 2021 17:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A2AB60EB5
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jul 2021 17:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhGWQji (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Jul 2021 12:39:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhGWQji (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 23 Jul 2021 12:39:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BCB860EB5
        for <linux-raid@vger.kernel.org>; Fri, 23 Jul 2021 17:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627060811;
        bh=AeHg1syjnl1e5Mi4VzBm5E+ZAHwuRiMcdy5SSQrOnW0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dSeuuJ8IdNdNEvzpbK+hsmVUhlkX3PCqKyJr3joSGzi1yzZyeTFltriZxza6pjbDi
         /4KgtrTgMkOcmYPQBTNSHqGAc/PYxYJD4EM868YcjP3SCAzqKCJwshsGDMjAedv4zT
         2oqa9EgASbJ8z4L9hIIV4+hh5XSTmJ3Zqs2VrW1zaAvi7U9WZqLuKNvlIW29XwPLv+
         cZk/tbfP/O+DS+f+fpqhRkgOTj4raD6xuQJbzgnqxPf7nWR3e8mZGQXpB9o6wUeisP
         ARTtYNBqMONCPBbtAoPiAZZUCtw2Xlna9behkXwBZ543vlR3LjD7tfKwnffWaLsEXN
         48IbpKvuGw/CQ==
Received: by mail-lf1-f49.google.com with SMTP id r26so3234403lfp.5
        for <linux-raid@vger.kernel.org>; Fri, 23 Jul 2021 10:20:11 -0700 (PDT)
X-Gm-Message-State: AOAM533Da/r17JJ+dyIhhGCEcOMk30bviRSczOdpdYbJHhj2vKQTWMZr
        yw1XeX7rcrZ5q0LeGDAqdRHS5Y9qjlV+XdQ8Fsk=
X-Google-Smtp-Source: ABdhPJyJl3dMmQAzQhaPFhR/Mi7c0bVDc44AH3FnfQ4qQEY4onN7EcNzGAEerBTz9F4nlkWFaD2GoxA9afOJAf9/4gA=
X-Received: by 2002:a05:6512:3c9a:: with SMTP id h26mr3817994lfv.160.1627060809648;
 Fri, 23 Jul 2021 10:20:09 -0700 (PDT)
MIME-Version: 1.0
References: <E1lxlU5-002GZB-TY@dogben.com> <2398043c-8503-3a52-b995-6acce0d68917@kylinos.cn>
In-Reply-To: <2398043c-8503-3a52-b995-6acce0d68917@kylinos.cn>
From:   Song Liu <song@kernel.org>
Date:   Fri, 23 Jul 2021 10:19:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4SMBfkUEvRo4Q944g=OLFutCS958nJVopK4UkYgBCAPQ@mail.gmail.com>
Message-ID: <CAPhsuW4SMBfkUEvRo4Q944g=OLFutCS958nJVopK4UkYgBCAPQ@mail.gmail.com>
Subject: Re: [PATCH v2][RESEND] md/raid10: properly indicate failure when
 ending a failed write request
To:     Guoqing Jiang <jiangguoqing@kylinos.cn>
Cc:     Wei Shuyu <wsy@dogben.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>,
        Paul Clements <paul.clements@us.sios.com>,
        Yufen Yu <yuyufen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jun 29, 2021 at 12:24 AM Guoqing Jiang <jiangguoqing@kylinos.cn> wrote:
>
>
>
> On 6/28/21 3:15 PM, wsy@dogben.com wrote:
> > Similar to commit 2417b9869b81882ab90fd5ed1081a1cb2d4db1dd, this patch
> > fixes the same bug in raid10. Also cleanup the comments.
> >
> > Fixes: 7cee6d4e6035 ("md/raid10: end bio when the device faulty")
> > Signed-off-by: Wei Shuyu <wsy@dogben.com>

Applied to md-next.

I fixed some issues highlighted by checkpatch.pl. For the next time, please run
checkpatch.pl before sending the patch.

Thanks,
Song

> > ---
> >   drivers/md/raid1.c  | 2 --
> >   drivers/md/raid10.c | 4 ++--
> >   2 files changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index ced076ba560e..753822ca9613 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -472,8 +472,6 @@ static void raid1_end_write_request(struct bio *bio)
> >               /*
> >                * When the device is faulty, it is not necessary to
> >                * handle write error.
> > -              * For failfast, this is the only remaining device,
> > -              * We need to retry the write without FailFast.
> >                */
> >               if (!test_bit(Faulty, &rdev->flags))
> >                       set_bit(R1BIO_WriteError, &r1_bio->state);
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 13f5e6b2a73d..40e845fb9717 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -469,12 +469,12 @@ static void raid10_end_write_request(struct bio *bio)
> >                       /*
> >                        * When the device is faulty, it is not necessary to
> >                        * handle write error.
> > -                      * For failfast, this is the only remaining device,
> > -                      * We need to retry the write without FailFast.
> >                        */
> >                       if (!test_bit(Faulty, &rdev->flags))
> >                               set_bit(R10BIO_WriteError, &r10_bio->state);
> >                       else {
> > +                             /* Fail the request */
> > +                             set_bit(R10BIO_Degraded, &r10_bio->state);
> >                               r10_bio->devs[slot].bio = NULL;
> >                               to_put = bio;
> >                               dec_rdev = 1;
>
> Acked-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
>
> Thanks,
> Guoqing
