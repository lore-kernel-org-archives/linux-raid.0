Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CA2C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 27 Jan 2021 04:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06EAD2070C
	for <linux-raid@archiver.kernel.org>; Wed, 27 Jan 2021 04:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239512AbhA0EpB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:45:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394945AbhAZSvt (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 26 Jan 2021 13:51:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29B5722A84
        for <linux-raid@vger.kernel.org>; Tue, 26 Jan 2021 18:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611687068;
        bh=2rTkgVU+LTvrXuY/4CyD4QmBScd+nz4JQiolwughZPU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XeeI41C0VcojjpjloYtH2W69E7F7dGTzRFxE2WNc7wIXGP0IRE0AJXM6kesrEG90e
         pEXZ8LS2qLcnU81TZdWPgrZpQUKS/mpBC/N/U6SIaEhnPjhiv00eTwEUzoUMPq++5W
         FDgpOXBy2rURKR82AZN5/h1mHmTrU8/filwno8wpSP5g0fqsYtvlgRgYXMQMIliQye
         8XnpoL0UxHPqx4JsFk9rZch+nPhUtFVCEKD/n+Ll9Dz3t2mkAMNpJQwiB85TjeU3m3
         k9AG4g3cEIFHU/OxPqB36+b7QcFoDBO3HwIgX2HBtwu+xhdN7398kxJmv715/IzaB8
         +pyFGAyDQXZFA==
Received: by mail-lf1-f51.google.com with SMTP id f1so14319372lfu.3
        for <linux-raid@vger.kernel.org>; Tue, 26 Jan 2021 10:51:08 -0800 (PST)
X-Gm-Message-State: AOAM532/q2WbxVUXuBGgNpsPjp2N9DdPGY2QfqV9A7auUEHajKZUYyAg
        pLy8PyJLZICKS5y8ArM9iGzoVf/Gi7T+mmJPgSc=
X-Google-Smtp-Source: ABdhPJzXPCqfU2w6CneJnYJvhhAUaQpNMtol7VTmohIhtb9L/s6VkXwTsYSLTotJKSkQAybbdYWsbp3CFMPkhk1mld0=
X-Received: by 2002:ac2:5199:: with SMTP id u25mr3102991lfi.438.1611687066427;
 Tue, 26 Jan 2021 10:51:06 -0800 (PST)
MIME-Version: 1.0
References: <1608081982-10839-1-git-send-email-guoqing.jiang@cloud.ionos.com>
 <CAPhsuW4E+cxg3b7H2Mczp9AyD2T_uwLeKDjGUtWcw7rdPpNaPw@mail.gmail.com> <CA+res+Qae7BufW5rHsp31Op9zqz4E6TsrFFbYprVna+dY0cRvg@mail.gmail.com>
In-Reply-To: <CA+res+Qae7BufW5rHsp31Op9zqz4E6TsrFFbYprVna+dY0cRvg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 26 Jan 2021 10:50:55 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7fwJ_eHuT_ug8SmNQOPx3BG-_xLRhf1N+8Mh2-+djN4w@mail.gmail.com>
Message-ID: <CAPhsuW7fwJ_eHuT_ug8SmNQOPx3BG-_xLRhf1N+8Mh2-+djN4w@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: cast chunk_sectors to sector_t value
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jan 25, 2021 at 5:57 AM Jack Wang <jack.wang.usish@gmail.com> wrote=
:
>
> Song Liu <song@kernel.org> =E4=BA=8E2020=E5=B9=B412=E6=9C=8816=E6=97=A5=
=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=885:29=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Tue, Dec 15, 2020 at 5:26 PM Guoqing Jiang
> > <guoqing.jiang@cloud.ionos.com> wrote:
> > >
> > > Currently, raid5 calculates dev_sectors from chunk_sectors without
> > > proper cast, which is problematic.
> > >
> > > Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> > > ---
> > > I think the recently report about raid5 issue could be related with
> > > the setting of dev_sectors.
> > >
> > > Could someone test it with a large raid5 array? Thanks.
> >
> > Yes, this was the exact problem. I will apply this to md-next. (probabl=
y
> > after the merge window).
> >
> > Thanks,
> > Song
> >
> > >
> > >  drivers/md/raid5.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > index 3934347..ca0b29a 100644
> > > --- a/drivers/md/raid5.c
> > > +++ b/drivers/md/raid5.c
> > > @@ -7662,7 +7662,7 @@ static int raid5_run(struct mddev *mddev)
> > >         }
> > >
> > >         /* device size must be a multiple of chunk size */
> > > -       mddev->dev_sectors &=3D ~(mddev->chunk_sectors - 1);
> > > +       mddev->dev_sectors &=3D ~((sector_t)mddev->chunk_sectors - 1)=
;
> > >         mddev->resync_max_sectors =3D mddev->dev_sectors;
> > >
> > >         if (mddev->degraded > dirty_parity_disks &&
> > > --
> > > 2.7.4
> > >
> ping, I cant find it in latest mainline, is it forgotten?

Applied to md-next. Thanks.

Song
