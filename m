Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C07CDB465
	for <linux-raid@archiver.kernel.org>; Mon, 16 Oct 2023 08:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjJPIOQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Oct 2023 04:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjJPIOO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 Oct 2023 04:14:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2D2A1
        for <linux-raid@vger.kernel.org>; Mon, 16 Oct 2023 01:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697444012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jg8FtnizQvelH1Z+61OibQ0pOC9vyQ6hfXJI0I/tFXM=;
        b=D0N6DU/YE9tVEUz60GckZZwO3GFTm0xv/0NiGCEjmo8XYGNzN+l5BrMLucxLuwKQuucmul
        ij+nUxtf4KV5C5jCSx5WQSOAfbuOJflMoirTtqGQO9hsOh71Ki4H8IB9mRgZnP3n4mWO3D
        OLkiNxr1Ec9yVWJmoJ7Vk70XwjsDH0Q=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-UTMFAs1NMgWxWuWzV_Vhiw-1; Mon, 16 Oct 2023 04:13:28 -0400
X-MC-Unique: UTMFAs1NMgWxWuWzV_Vhiw-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-27d3fe747b1so1779740a91.1
        for <linux-raid@vger.kernel.org>; Mon, 16 Oct 2023 01:13:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697444008; x=1698048808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jg8FtnizQvelH1Z+61OibQ0pOC9vyQ6hfXJI0I/tFXM=;
        b=vz4KJexpsQE9+NVfTPpFIWyIgSuCGpd9kUuMAdY4iN7Rsfxfgefm+qPGfR1DIY6v1P
         8Yo6eCTAmtBk3mteKcr95En5Fxg5HXoA3OMpmPGjZYFvlPU4FjQeu79ypqIFp782vdUT
         Ybi6eFF5xYDfR3uGKoVjDBtcHlj5TZLq1zwhVKfnwIhQ9unt3HLUYZlrXo42m24Ajtxq
         4HDFMWNIdHz8Q68z4qPPH3/l88haX1QHCa0G/a5+P7VPrmkLPRDMjjfNCVZbAQKp1GWM
         /pbWV/A/1/xqxQi8Ww+DwkCx0My6AoUCqfdDt+/qXrpPGErklTLn09960nqCmO2xqgy0
         9Idg==
X-Gm-Message-State: AOJu0YzPMGRCJhXg2cf9HZ+KKiREgv9H+0uVhZ8yL4c5VqVoJWvZ52WS
        3G4FMP2mIn/+vYpIt5mkdvxR//9IOngblpDMy1K7yhazsxeEnH7nT0JbgwkSPJyQdIEC4sQzyWz
        ndKAvLwEwLVe4YiWoNkF6IPW7Whmht1HnK9OEaA==
X-Received: by 2002:a17:90b:2788:b0:27d:1c89:2160 with SMTP id pw8-20020a17090b278800b0027d1c892160mr10017590pjb.47.1697444007814;
        Mon, 16 Oct 2023 01:13:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqnG4A/lmi++DkkpZUH+9g7wcbaXWVnI8p6ZDQ0QCA0QzxxGGWoLHf3nS17Yttcku9urX2z/Xo0yVOKSro0zk=
X-Received: by 2002:a17:90b:2788:b0:27d:1c89:2160 with SMTP id
 pw8-20020a17090b278800b0027d1c892160mr10017580pjb.47.1697444007455; Mon, 16
 Oct 2023 01:13:27 -0700 (PDT)
MIME-Version: 1.0
References: <20231011130522.78994-1-xni@redhat.com> <20231013113034.0000298a@linux.intel.com>
 <CALTww282t6UMePRPPmoxyxBpedbjWC=9ojjHQx8o8sJttnzvSA@mail.gmail.com> <20231013135935.00005679@linux.intel.com>
In-Reply-To: <20231013135935.00005679@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 16 Oct 2023 16:13:16 +0800
Message-ID: <CALTww288hm71bTWSbpvXFH2dBeOT3nyRws_NCSUtumP+-+MYVw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT if
 sb->layout is set
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org, colyli@suse.de,
        neilb@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Oct 13, 2023 at 7:59=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Fri, 13 Oct 2023 18:59:21 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > On Fri, Oct 13, 2023 at 5:31=E2=80=AFPM Mariusz Tkaczyk
> > <mariusz.tkaczyk@linux.intel.com> wrote:
> > >
> > > On Wed, 11 Oct 2023 21:05:22 +0800
> > > Xiao Ni <xni@redhat.com> wrote:
> > >
> > > > In kernel space super_1_validate sets mddev->layout to -1 if
> > > > MD_FEATURE_RAID0_LAYOUT is not set. MD_FEATURE_RAID0_LAYOUT is set =
in
> > > > mdadm write_init_super1. Now only raid with more than one zone can =
set
> > > > this bit. But for raid0 with same size member disks, it doesn't set=
 this
> > > > bit. The layout is *unknown* when running mdadm -D command. In fact=
 it
> > > > should be RAID0_ORIG_LAYOUT which gets from default_layout.
> > > >
> > > > So set MD_FEATURE_RAID0_LAYOUT when sb->layout has value.
> > > >
> > > > Fixes: 329dfc28debb ('Create: add support for RAID0 layouts.')
> > > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > > ---
> > > >  super1.c | 21 ++-------------------
> > > >  1 file changed, 2 insertions(+), 19 deletions(-)
> > > >
> > > > diff --git a/super1.c b/super1.c
> > > > index 856b02082662..f29751b4a5c7 100644
> > > > --- a/super1.c
> > > > +++ b/super1.c
> > > > @@ -1978,26 +1978,10 @@ static int write_init_super1(struct superty=
pe *st)
> > > >       unsigned long long sb_offset;
> > > >       unsigned long long data_offset;
> > > >       long bm_offset;
> > > > -     int raid0_need_layout =3D 0;
> > > >
> > > > -     for (di =3D st->info; di; di =3D di->next) {
> > > > +     for (di =3D st->info; di; di =3D di->next)
> > > >               if (di->disk.state & (1 << MD_DISK_JOURNAL))
> > > >                       sb->feature_map |=3D
> > > > __cpu_to_le32(MD_FEATURE_JOURNAL);
> > > > -             if (sb->level =3D=3D 0 && sb->layout !=3D 0) {
> > > > -                     struct devinfo *di2 =3D st->info;
> > > > -                     unsigned long long s1, s2;
> > > > -                     s1 =3D di->dev_size;
> > > > -                     if (di->data_offset !=3D INVALID_SECTORS)
> > > > -                             s1 -=3D di->data_offset;
> > > > -                     s1 /=3D __le32_to_cpu(sb->chunksize);
> > > > -                     s2 =3D di2->dev_size;
> > > > -                     if (di2->data_offset !=3D INVALID_SECTORS)
> > > > -                             s2 -=3D di2->data_offset;
> > > > -                     s2 /=3D __le32_to_cpu(sb->chunksize);
> > > > -                     if (s1 !=3D s2)
> > > > -                             raid0_need_layout =3D 1;
> > > > -             }
> > > > -     }
> > > >
> > > >       for (di =3D st->info; di; di =3D di->next) {
> > > >               if (di->disk.state & (1 << MD_DISK_FAULTY))
> > > > @@ -2139,8 +2123,7 @@ static int write_init_super1(struct supertype=
 *st)
> > > >                       sb->bblog_offset =3D 0;
> > > >               }
> > > >
> > > > -             /* RAID0 needs a layout if devices aren't all the sam=
e size
> > > > */
> > > > -             if (raid0_need_layout)
> > > > +             if (sb->level =3D=3D 0 && sb->layout)
> > > >                       sb->feature_map |=3D
> > > > __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
> > > >               sb->sb_csum =3D calc_sb_1_csum(sb);
> > > Hi Xiao,
> > >
> > > I read Neil patch:
> > > https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D329=
dfc28de
> > >
> > > For sure Neil has a purpose to make it this way. I think that because=
 it
> > > breaks creation when layout is not supported by kernel. Neil wanted t=
o keep
> > > possible largest compatibility so it sets layout feature only if it i=
s
> > > necessary. Your change forces layout bit to be always used. Can you t=
est
> > > this change on kernel without raid0_layout support? I expect regressi=
on for
> > > same dev size raid arrays.
> >
> > Hi Mariusz
> >
> > Thanks for pointing out this. I only think the kernel which supports
> > MD_FEATURE_RAID0_LAYOUT
> >
> > >
> > > I think that before we will set layout bit we should check kernel
> > > version, it must be higher than 5.4. In the future we would remove th=
is
> > > check.

Hi Mariusz

I just noticed the kernel version should be 3.14 rather than 5.4. In
kernel 3.14 (20d0189b1012 block: Introduce new bio_split()) introduces
this problem. So 5.4 is a typo error?

Regards
Xiao

