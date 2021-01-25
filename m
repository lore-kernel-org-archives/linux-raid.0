Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CB5C433E0
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 05:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E76B122273
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 05:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbhAZFKm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbhAYOAl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jan 2021 09:00:41 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA54C0617A7
        for <linux-raid@vger.kernel.org>; Mon, 25 Jan 2021 05:57:32 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id n7so2915471oic.11
        for <linux-raid@vger.kernel.org>; Mon, 25 Jan 2021 05:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0Scv2CQzHRXmF/ApG3CAUp2rduzdSqCt18fo2IzgVws=;
        b=F92Rm6AsDKrnd7Njw0L0j3r9RgGaR2fdGzU+moVPTtcYIDG9E1lNtu5XLX+4tedUQh
         nA0XJl+RzNepkgi2menUD2n0Ql6XM8YsnJp5yA+3Ijw4POEKZvZjbdULBbrH42QUK1As
         TnBEPzOaVvWR2HKHwCqUS8hl7U44STMxMEjQ/ZRPi/Wy3r/reeOA3xrGca93ql+QdQLn
         /JtLDpM3w/gdQeVI+h1Wvwj6swK47I6Ny7QCgm9e4rOaF5REMwMLNgsJqaNfpRnZaK0K
         WxtsDESr/SdAQcTWQ5MGP3egqdKoRKPOeR8yNR+nyG4RDH0ZztwGC4lw/IC4CyuNmqNC
         ZYLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0Scv2CQzHRXmF/ApG3CAUp2rduzdSqCt18fo2IzgVws=;
        b=HIfNiEXj1UD3avX2HXsQX36t2jEGo9ZRy6vz9z1vJjE/o1s5BDrN4TLqMh7Gn0fz7I
         Sj1VhOzoXpVs0sIqQLGT1ONmZYJqs/UYh/bG4GpN+dbLdw1a4UnPrGsJJF0foEUbgKQP
         JjGOOT4T5qq09d71vFtshZZKc/SI936bx2VuzSzgio0LByJ5tmqBhKVqmdx8f0g9s3/S
         hFzQrL+FND4v5l+MsM94dR3JMtEuIIv5bxQm4LEQyoNZ+3MyB7vb/K2wdun/emlxKJTP
         wI1rNdUZR7sgVBgtyyYASubhONkZKSYoIXQOrTPi1OinST0RDjuyfQdqokTqDE7cgLeJ
         RhUg==
X-Gm-Message-State: AOAM5304jamQ9eibr6UrTtep6HIZIcSVTpWWgHX+zZ3eYDX5IaB66n6d
        h3EtivcxmaYbIn7V/1vPG4zyMqbwMiHjw+/EECw=
X-Google-Smtp-Source: ABdhPJwTz6me2k2pSZsuKRuAzKjUqHHrlYn6Uw22so/fg0a5kndPFUQfse0PZz8x1DHisLHTdQTZClL9SWg3piVPlRM=
X-Received: by 2002:aca:b441:: with SMTP id d62mr163671oif.91.1611583051572;
 Mon, 25 Jan 2021 05:57:31 -0800 (PST)
MIME-Version: 1.0
References: <1608081982-10839-1-git-send-email-guoqing.jiang@cloud.ionos.com> <CAPhsuW4E+cxg3b7H2Mczp9AyD2T_uwLeKDjGUtWcw7rdPpNaPw@mail.gmail.com>
In-Reply-To: <CAPhsuW4E+cxg3b7H2Mczp9AyD2T_uwLeKDjGUtWcw7rdPpNaPw@mail.gmail.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Mon, 25 Jan 2021 14:57:20 +0100
Message-ID: <CA+res+Qae7BufW5rHsp31Op9zqz4E6TsrFFbYprVna+dY0cRvg@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: cast chunk_sectors to sector_t value
To:     Song Liu <song@kernel.org>
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Song Liu <song@kernel.org> =E4=BA=8E2020=E5=B9=B412=E6=9C=8816=E6=97=A5=E5=
=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=885:29=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Dec 15, 2020 at 5:26 PM Guoqing Jiang
> <guoqing.jiang@cloud.ionos.com> wrote:
> >
> > Currently, raid5 calculates dev_sectors from chunk_sectors without
> > proper cast, which is problematic.
> >
> > Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> > ---
> > I think the recently report about raid5 issue could be related with
> > the setting of dev_sectors.
> >
> > Could someone test it with a large raid5 array? Thanks.
>
> Yes, this was the exact problem. I will apply this to md-next. (probably
> after the merge window).
>
> Thanks,
> Song
>
> >
> >  drivers/md/raid5.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 3934347..ca0b29a 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -7662,7 +7662,7 @@ static int raid5_run(struct mddev *mddev)
> >         }
> >
> >         /* device size must be a multiple of chunk size */
> > -       mddev->dev_sectors &=3D ~(mddev->chunk_sectors - 1);
> > +       mddev->dev_sectors &=3D ~((sector_t)mddev->chunk_sectors - 1);
> >         mddev->resync_max_sectors =3D mddev->dev_sectors;
> >
> >         if (mddev->degraded > dirty_parity_disks &&
> > --
> > 2.7.4
> >
ping, I cant find it in latest mainline, is it forgotten?
