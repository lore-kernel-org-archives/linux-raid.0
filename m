Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2822C3A59D
	for <linux-raid@archiver.kernel.org>; Mon, 24 Oct 2022 04:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJXEdA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiJXEc7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Oct 2022 00:32:59 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F7D753AF
        for <linux-raid@vger.kernel.org>; Sun, 23 Oct 2022 21:32:58 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id r22so11270643ljn.10
        for <linux-raid@vger.kernel.org>; Sun, 23 Oct 2022 21:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=krDAa9xRK8lyCQLKotOxWTGKlSnluuaefH3/GOgFpYs=;
        b=KlMfiHRt3TrwEepk1JX/DA576ikJWMTq+Y89Wy/wGud3LZ2s4ndGJr0f0J2GUqV/4i
         B4Qp7cLjYUIRHjL1XG4WWqkPalgYp1rPEE4YhgZblIY7x3BUM/GuxQRXvptl5BbEPuLl
         eGLhZKDSj/rMbJ8cM0tDig+pmI28HNidmSD95y1/N634fodT5VO9llznjaEcphNs/+HA
         9xbS+09KmMpW+As7Iw25ywDlSqXM8t9PpPz82yPUGtfV67w31q52SLMcEZGhY0kOPc/h
         3Hi8R4ej9Nl+ry1jGEc6Agh186+CB4Yhso+Ehnv5lnFddtUZEyXB/2mOeTgnturD6IiV
         BAJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=krDAa9xRK8lyCQLKotOxWTGKlSnluuaefH3/GOgFpYs=;
        b=N68gVV2nUcApm3/MlHwm9z8DLCNQadoO6EKxDrEx24wdO1c0gvF5BASSzdfDz0Pn+e
         h9B0mrj5VzK+v8WU/Y46GfRYlcS9ItIBupoMs0lnfIpozJViBaSVB6IsR4kbPCAo2K5Y
         erQIlMq3AkkNf3s1QscmWPnlYyk54Bi5kszTfRqrkdgWJBJcsv+PuqY2ogBOGKMxHFB5
         aPZWpDD79wE+9QURcGCzpANWHQuf27BJt3oERTSOs5n52zpoagr5UQWHiAHyOE991ZdV
         nacgY2vnKcUvrfNeAhHVSD3JT/ElwwLkw2XDo7WCs2DkLrh3jCywif1AfHVbdzgXzzzd
         aWFg==
X-Gm-Message-State: ACrzQf0ekwHjFMf7TOJcveD3/3yD/jFL2yn2R6rNjFI6Mb43YcL07OYn
        tYz+pQKoIsXM8bAlBU024m5kEWJjZ6ZqYqgo1TMIRw==
X-Google-Smtp-Source: AMsMyM4LyGnf23EzB+dYN8BaPYltToL7B/NK5F/oFx5edShhBhIV3tr9oyL0rHb9VyZzWuxtTCftE4YYTiQR2ak3bUU=
X-Received: by 2002:a2e:9e50:0:b0:261:e3fd:cdc5 with SMTP id
 g16-20020a2e9e50000000b00261e3fdcdc5mr11355028ljk.56.1666585976218; Sun, 23
 Oct 2022 21:32:56 -0700 (PDT)
MIME-Version: 1.0
References: <20221014122210.47888-1-jinpu.wang@ionos.com> <CAPhsuW7hSruJhubAcmwcpTbGPKXq2H3mBkC3FjBt6mWeZXtyRw@mail.gmail.com>
 <CAHJVUej9hgzH2FH1r2hsVwoBqbnCvi8PWM9j=m5ih_raxCZSpA@mail.gmail.com>
In-Reply-To: <CAHJVUej9hgzH2FH1r2hsVwoBqbnCvi8PWM9j=m5ih_raxCZSpA@mail.gmail.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 24 Oct 2022 06:32:49 +0200
Message-ID: <CAMGffEmLeru6A=EDaY3YwRwfLomrtHn4S2c+PqvAWYPwSa2+Kw@mail.gmail.com>
Subject: Re: [RFC PATCH] md-bitmap: reuse former bitmap chunk size on resizing.
To:     =?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= 
        <florian-ewald.mueller@ionos.com>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Oct 20, 2022 at 10:26 PM Florian-Ewald M=C3=BCller
<florian-ewald.mueller@ionos.com> wrote:
>
> Hello Song,
>
> Thank you for taking this patch into consideration.
> This patch was indeed meant only as a RFC.
>
> We have, sometimes, the situation that a md-raid1 device of e.g. size=3D1=
28G, created
> with bitmap=3Dinternal and bitmap-chunk=3D256M, needs to be resized to (l=
et's say) size=3D8T.
>
> We originally set the bitmap-chunk=3D256M because we found it a good comp=
romise between performance and resync speed.
> With that bitmap-chunk=3D256G and the starting size=3D128G, the md-bitmap=
 code will use only 512 bits fitting into a page (4K).
>
> When resizing to size=3D8T, the md-bitmap code will attempt to reuse the =
space available (4k) and calculate a bitmap-chunk=3D2G.
> We found here that such a huge bitmap-chunk (2G) is not so suitable for a=
n eventual, later resync process.
> Also taking into consideration that IOPS issued on the now resized device=
 won't increase/differ significantly.
>
> This is a particular usage scenario and the effect of this patch may, ind=
eed, not be optimal in some other use case.
>
> Best regards,
> Florian
>
>
resent with plain text, so it's available on mainlist
>
> On Thu, Oct 20, 2022 at 9:22 PM Song Liu <song@kernel.org> wrote:
>>
>> On Fri, Oct 14, 2022 at 5:22 AM Jack Wang <jinpu.wang@ionos.com> wrote:
>> >
>> > From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
>> >
>> > On bitmap resizing, attempt to reuse the former chunk size (if any)
>> > in order to preserve the, ev. on purpose set, chunk size resolution.
>>
>> Could you please explain more on why we would rather keep the chunk size
>> instead of recalculating it?
>>
>> Thanks,
>> Song
>>
>> >
>> > Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
>> > Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
>> > ---
>> >  drivers/md/md-cluster.c |  3 ++-
>> >  drivers/md/raid1.c      |  3 ++-
>> >  drivers/md/raid10.c     | 12 ++++++++----
>> >  drivers/md/raid5.c      |  3 ++-
>> >  4 files changed, 14 insertions(+), 7 deletions(-)
>> >
>> > diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>> > index 10e0c5381d01..9929631bdc94 100644
>> > --- a/drivers/md/md-cluster.c
>> > +++ b/drivers/md/md-cluster.c
>> > @@ -604,7 +604,8 @@ static int process_recvd_msg(struct mddev *mddev, =
struct cluster_msg *msg)
>> >         case BITMAP_RESIZE:
>> >                 if (le64_to_cpu(msg->high) !=3D mddev->pers->size(mdde=
v, 0, 0))
>> >                         ret =3D md_bitmap_resize(mddev->bitmap,
>> > -                                           le64_to_cpu(msg->high), 0,=
 0);
>> > +                                           le64_to_cpu(msg->high),
>> > +                                           mddev->bitmap_info.chunksi=
ze, 0);
>> >                 break;
>> >         default:
>> >                 ret =3D -1;
>> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> > index 05d8438cfec8..8f1d25064a53 100644
>> > --- a/drivers/md/raid1.c
>> > +++ b/drivers/md/raid1.c
>> > @@ -3225,7 +3225,8 @@ static int raid1_resize(struct mddev *mddev, sec=
tor_t sectors)
>> >             mddev->array_sectors > newsize)
>> >                 return -EINVAL;
>> >         if (mddev->bitmap) {
>> > -               int ret =3D md_bitmap_resize(mddev->bitmap, newsize, 0=
, 0);
>> > +               int ret =3D md_bitmap_resize(mddev->bitmap, newsize,
>> > +                               mddev->bitmap_info.chunksize, 0);
>> >                 if (ret)
>> >                         return ret;
>> >         }
>> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> > index 3aa8b6e11d58..8f0453b6e0c6 100644
>> > --- a/drivers/md/raid10.c
>> > +++ b/drivers/md/raid10.c
>> > @@ -4346,7 +4346,8 @@ static int raid10_resize(struct mddev *mddev, se=
ctor_t sectors)
>> >             mddev->array_sectors > size)
>> >                 return -EINVAL;
>> >         if (mddev->bitmap) {
>> > -               int ret =3D md_bitmap_resize(mddev->bitmap, size, 0, 0=
);
>> > +               int ret =3D md_bitmap_resize(mddev->bitmap, size,
>> > +                               mddev->bitmap_info.chunksize, 0);
>> >                 if (ret)
>> >                         return ret;
>> >         }
>> > @@ -4618,7 +4619,8 @@ static int raid10_start_reshape(struct mddev *md=
dev)
>> >                 newsize =3D raid10_size(mddev, 0, conf->geo.raid_disks=
);
>> >
>> >                 if (!mddev_is_clustered(mddev)) {
>> > -                       ret =3D md_bitmap_resize(mddev->bitmap, newsiz=
e, 0, 0);
>> > +                       ret =3D md_bitmap_resize(mddev->bitmap, newsiz=
e,
>> > +                                       mddev->bitmap_info.chunksize, =
0);
>> >                         if (ret)
>> >                                 goto abort;
>> >                         else
>> > @@ -4640,13 +4642,15 @@ static int raid10_start_reshape(struct mddev *=
mddev)
>> >                             MD_FEATURE_RESHAPE_ACTIVE)) || (oldsize =
=3D=3D newsize))
>> >                         goto out;
>> >
>> > -               ret =3D md_bitmap_resize(mddev->bitmap, newsize, 0, 0)=
;
>> > +               ret =3D md_bitmap_resize(mddev->bitmap, newsize,
>> > +                               mddev->bitmap_info.chunksize, 0);
>> >                 if (ret)
>> >                         goto abort;
>> >
>> >                 ret =3D md_cluster_ops->resize_bitmaps(mddev, newsize,=
 oldsize);
>> >                 if (ret) {
>> > -                       md_bitmap_resize(mddev->bitmap, oldsize, 0, 0)=
;
>> > +                       md_bitmap_resize(mddev->bitmap, oldsize,
>> > +                                       mddev->bitmap_info.chunksize, =
0);
>> >                         goto abort;
>> >                 }
>> >         }
>> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> > index 7b820b81d8c2..bff7d3d779ae 100644
>> > --- a/drivers/md/raid5.c
>> > +++ b/drivers/md/raid5.c
>> > @@ -8372,7 +8372,8 @@ static int raid5_resize(struct mddev *mddev, sec=
tor_t sectors)
>> >             mddev->array_sectors > newsize)
>> >                 return -EINVAL;
>> >         if (mddev->bitmap) {
>> > -               int ret =3D md_bitmap_resize(mddev->bitmap, sectors, 0=
, 0);
>> > +               int ret =3D md_bitmap_resize(mddev->bitmap, sectors,
>> > +                               mddev->bitmap_info.chunksize, 0);
>> >                 if (ret)
>> >                         return ret;
>> >         }
>> > --
>> > 2.34.1
>> >
