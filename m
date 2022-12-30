Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEB1C4167B
	for <linux-raid@archiver.kernel.org>; Fri, 30 Dec 2022 10:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbiL3KjA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Dec 2022 05:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiL3Ki7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 30 Dec 2022 05:38:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61400101E3
        for <linux-raid@vger.kernel.org>; Fri, 30 Dec 2022 02:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672396695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AQulwiKtYiaPuuoNEmPSCSrTfFcWcq8QyxpM7GVLj6U=;
        b=akEkTkAHZoEIjiJgJ4wr2hJnCgFTDE1FC8xhGiezR5kEbWMyYdDzWUI8KEbqEr9NLeGM9S
        kTKjWCADb+69s18Yl4JpkV4uNbN1zUnpV8szp4/yK6Abhaxd0pq9x6fxco72pJLXNaLREC
        TBkln2ff6fNv66TGjm+U7xUBOBCEoEA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-589-3j3sZDuxP_a6Rhoke-x9Aw-1; Fri, 30 Dec 2022 05:38:11 -0500
X-MC-Unique: 3j3sZDuxP_a6Rhoke-x9Aw-1
Received: by mail-pj1-f69.google.com with SMTP id a23-20020a17090a8c1700b002263980f032so1554225pjo.5
        for <linux-raid@vger.kernel.org>; Fri, 30 Dec 2022 02:38:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AQulwiKtYiaPuuoNEmPSCSrTfFcWcq8QyxpM7GVLj6U=;
        b=kbByq9hSpHL9Q30kY5LCTRxV0G+M+7u/7x1SLu69BL64sh0IMutbeMPc6IGjyRgoXa
         CaYkrZnNzowUj8dkrUQ0uiTFVqzihIbG6yAyPHJWD9jW7gxcK8gJWr01BWoTE42v+Eiz
         FKl5eJOw1piyDrZAaK8A+apIi4XeDbToNO00b2xWneNkNxghVdfWyPSyx1rglzdP9Vz3
         zomVTIyrIxrF1BcBezqx00wx/s1VBYzogqJwUrBYBO8Yn4DUgWBa8dj+SRQ8kZ8AhJXH
         X5hR+O6wr+wd9YUrAxLT7YQfsctVId4Lj9p6T8U7onshRgNQjm23fuvChlklEMkHHSVc
         Jl5Q==
X-Gm-Message-State: AFqh2kpuVIWr5BzaQ4sVAa1sQi97KwPykA5pLk+2J9f/6KzO7ojx3lCM
        Jz1CqGiDIT7ezMXSp4rMXcQAqr52X0ACMvZwrNo5Dwa2DrkPD8iAhHZlOd7+0w81WOztbK3vxpF
        7ghKeL/PL/HKx5xdyg0YNigSLKKVzrCUiJl7p3g==
X-Received: by 2002:a17:902:ee41:b0:191:255c:9bd5 with SMTP id 1-20020a170902ee4100b00191255c9bd5mr1769848plo.82.1672396690444;
        Fri, 30 Dec 2022 02:38:10 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvKiKolEQxrovEdqSf3K/t/R18c2UCWPxb22oz8rA19E69dy2+Wn47Z5cyEg8LMD/h/9zoHPlUpPshg8Mmn7fI=
X-Received: by 2002:a17:902:ee41:b0:191:255c:9bd5 with SMTP id
 1-20020a170902ee4100b00191255c9bd5mr1769845plo.82.1672396690084; Fri, 30 Dec
 2022 02:38:10 -0800 (PST)
MIME-Version: 1.0
References: <20221230090748.53598-1-xni@redhat.com> <293f8482-8032-d857-2811-1fdd022b0742@molgen.mpg.de>
In-Reply-To: <293f8482-8032-d857-2811-1fdd022b0742@molgen.mpg.de>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 30 Dec 2022 18:37:58 +0800
Message-ID: <CALTww28mmnVwL_FWT6zXXEdSk=6B24zXVxji-Etm=SxFhjPnVg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Don't handle change event against raw devices
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org,
        ncroxon@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Dec 30, 2022 at 6:20 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Xiao,
>
>
> Thank you for the patch.
>
> Am 30.12.22 um 10:07 schrieb Xiao Ni:
>
> It=E2=80=99d be great if you described the problem.

Hi Paul

Thanks. I'll describe more in next version.
>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   udev-md-raid-assembly.rules | 10 ++++++++++
> >   1 file changed, 10 insertions(+)
> >
> > diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
> > index 39b4344b8592..748ea05dadaa 100644
> > --- a/udev-md-raid-assembly.rules
> > +++ b/udev-md-raid-assembly.rules
> > @@ -11,6 +11,11 @@ SUBSYSTEM!=3D"block", GOTO=3D"md_inc_end"
> >   ENV{SYSTEMD_READY}=3D=3D"0", GOTO=3D"md_inc_end"
> >
> >   # handle potential components of arrays (the ones supported by md)
> > +# For member devices which are md/dm devices, we don't need to
> > +# handle add event. Because md/dm devices need to do some init jobs.
> > +# Then the change event happens.
> > +# When adding md/dm devices, ID_FS_TYPE only be linux_raid_member
>
> A verb is missing. Maybe: =E2=80=A6 can only be =E2=80=A6
>
> > +# after change event happens.
> >   ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", GOTO=3D"md_inc"
> >
> >   # "noiswmd" on kernel command line stops mdadm from handling
> > @@ -28,6 +33,11 @@ GOTO=3D"md_inc_end"
> >
> >   LABEL=3D"md_inc"
> >
> > +# We only handle add event on raw disks. If we handle change event on =
raw disk,
> > +# the tool parted can't change partition table unless clear superblock=
 on
>
> 1.  *the* partition table
> 2.  Please excuse my ignorance, but what is a =E2=80=9Cclear superblock=
=E2=80=9D?

It means clearing superblock with command mdadm --zero-superblock

>
> > +# member disks
>
> Add a dot/period at the end of sentences?
>
> > +ACTION=3D=3D"change", KERNEL!=3D"dm-*|md*", GOTO=3D"md_inc_end"
> > +
> >   # remember you can limit what gets auto/incrementally assembled by
> >   # mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
> >   ACTION!=3D"remove", IMPORT{program}=3D"BINDIR/mdadm --incremental --e=
xport $devnode --offroot $env{DEVLINKS}"
>


Best Regards
Xiao

