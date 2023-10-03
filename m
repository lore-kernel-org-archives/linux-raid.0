Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5203AE7542B
	for <linux-raid@archiver.kernel.org>; Tue,  3 Oct 2023 06:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjJCGs1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Oct 2023 02:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjJCGs0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 3 Oct 2023 02:48:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3440FAD
        for <linux-raid@vger.kernel.org>; Mon,  2 Oct 2023 23:48:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD151C433C8
        for <linux-raid@vger.kernel.org>; Tue,  3 Oct 2023 06:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696315703;
        bh=GVGbDTzmWrwoyQSVYFNVKrviISRURTeizk43/zX4xas=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lHwQvyHVeBjVaVBc9AGROmx2k5cBDZevnNiZaCM61hmcuViNWuXSVQ5ZQABA1r+Gy
         2JaFnAe1qEmJbktFf8dpMmXJMiytVaMLlu2Cjr7DM6eJ7gebCJv5cFMgxTqHutEQXl
         ObTn5QheIEDrXBULC1WkOfOUyypmvRy0E8vqTwZEdjtOrrPngclf5Rre4DUWmiPTiX
         J4BM50gWtFM+LZYv2Xngfdae0g1ycDSdXB9xeSft0ms/IkoUyBTk9dTcn+jT0Ll7bG
         ht42Adr/oOv1LSCBmo/9dUnnLMDoAOqRbK9gqvWVy/r/KnG2bLz8s60ieyB+FPH0Wd
         cJlxWyAtWPFYQ==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-50435ad51bbso603513e87.2
        for <linux-raid@vger.kernel.org>; Mon, 02 Oct 2023 23:48:23 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy/kOZQy8j/eSU5X7hMw4rnA2cuxhx7HmQYH2T519M4q2daI5FW
        jzbOl6UH6E+eYkthn/7773RBK0tVwRdNcuzTxog=
X-Google-Smtp-Source: AGHT+IEJHWHmEBQSFMSAqBrMpMv9sasQZ+ppN0kPK0XZHkDYwcH0TR+1HjOADopPZecif8rCv17h96IliPecF7AoYGA=
X-Received: by 2002:a05:6512:ac4:b0:504:3a7c:66ce with SMTP id
 n4-20020a0565120ac400b005043a7c66cemr12970456lfu.68.1696315701844; Mon, 02
 Oct 2023 23:48:21 -0700 (PDT)
MIME-Version: 1.0
References: <20231002183422.13047-1-djeffery@redhat.com> <CA+RJvhxrkSXRPc9wELyfYYCy_dpRaa+9=fTY7NQR0tP=MO8xUQ@mail.gmail.com>
In-Reply-To: <CA+RJvhxrkSXRPc9wELyfYYCy_dpRaa+9=fTY7NQR0tP=MO8xUQ@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 2 Oct 2023 23:48:09 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6iSTRGFDfbP_nQR5eeKWEY=begDZ_H8QgK+tqhKaqELw@mail.gmail.com>
Message-ID: <CAPhsuW6iSTRGFDfbP_nQR5eeKWEY=begDZ_H8QgK+tqhKaqELw@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: release batch_last before waiting for another stripe_head
To:     John Pittman <jpittman@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>
Cc:     David Jeffery <djeffery@redhat.com>, linux-raid@vger.kernel.org,
        Laurence Oberman <loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

CC Logan.

On Mon, Oct 2, 2023 at 12:22=E2=80=AFPM John Pittman <jpittman@redhat.com> =
wrote:
>
> Thanks a lot David.  Song, as a note, David's patch was tested by a
> Red Hat customer and it indeed resolved their hit on the deadlock.
> cc. Laurence Oberman who assisted on that case.
>
>
> On Mon, Oct 2, 2023 at 2:39=E2=80=AFPM David Jeffery <djeffery@redhat.com=
> wrote:
> >
> > When raid5_get_active_stripe is called with a ctx containing a stripe_h=
ead in
> > its batch_last pointer, it can cause a deadlock if the task sleeps wait=
ing on
> > another stripe_head to become available. The stripe_head held by batch_=
last
> > can be blocking the advancement of other stripe_heads, leading to no
> > stripe_heads being released so raid5_get_active_stripe waits forever.
> >
> > Like with the quiesce state handling earlier in the function, batch_las=
t
> > needs to be released by raid5_get_active_stripe before it waits for ano=
ther
> > stripe_head.
> >
> >
> > Fixes: 3312e6c887fe ("md/raid5: Keep a reference to last stripe_head fo=
r batch")
> > Signed-off-by: David Jeffery <djeffery@redhat.com>

Thanks for the fix! I applied it to md-fixes.

Question: How easy/difficult is it to reproduce this issue?

Song

> > ---
> >  drivers/md/raid5.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 6383723468e5..0644b83fd3f4 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -854,6 +854,13 @@ struct stripe_head *raid5_get_active_stripe(struct=
 r5conf *conf,
> >
> >                 set_bit(R5_INACTIVE_BLOCKED, &conf->cache_state);
> >                 r5l_wake_reclaim(conf->log, 0);
> > +
> > +               /* release batch_last before wait to avoid risk of dead=
lock */
> > +               if (ctx && ctx->batch_last) {
> > +                       raid5_release_stripe(ctx->batch_last);
> > +                       ctx->batch_last =3D NULL;
> > +               }
> > +
> >                 wait_event_lock_irq(conf->wait_for_stripe,
> >                                     is_inactive_blocked(conf, hash),
> >                                     *(conf->hash_locks + hash));
> > --
> > 2.41.0
> >
>
