Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F005CDB482
	for <linux-raid@archiver.kernel.org>; Fri, 13 Oct 2023 12:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjJMMNe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Oct 2023 08:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbjJMMNd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Oct 2023 08:13:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7C4C2
        for <linux-raid@vger.kernel.org>; Fri, 13 Oct 2023 05:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697199171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FYH+bhLf3SCV8aqoP++Pr62buEFM7m7iR0kVIFcPzuo=;
        b=fz60KS5TCxL4UA8BzBV3iWXVmn5LIDFhdwJD0BfjfIPs58dzfN3gJDdBCgz+M/HhKVKFs+
        dtNt72oMGqRm3tW4jREsMqfX/IpofUBBuOYO3vupYPJLVFPojMD568EubA0d17XAWisxa9
        9no87Rv7mPIgcROPOv93Ce+vhV1VJRY=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-Ml4ZeRowNuG3ZWy9qTqMIA-1; Fri, 13 Oct 2023 08:12:50 -0400
X-MC-Unique: Ml4ZeRowNuG3ZWy9qTqMIA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-27d0d9a0e0bso1524903a91.1
        for <linux-raid@vger.kernel.org>; Fri, 13 Oct 2023 05:12:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697199169; x=1697803969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYH+bhLf3SCV8aqoP++Pr62buEFM7m7iR0kVIFcPzuo=;
        b=RPl1nwzg9VfWKNId4eYpdVrWyx14MTLZxQoGEC3Zj66xFmT7fqQoXiUJKNS1aW0iFr
         vURoI1THPA7edPWHY673DDOuhVdDWOsjnw95u/ikhvPlFezQe2+4v3q8kDtiaZpqbqZT
         4IvCm/OJJmXtVQzmKojiFLn7D1WIjVRCVe4y0jcnda9p1AAIGbtDh184/cRv8vXU7pcd
         mM7AMiSD35RfJ6hrzqq60cUBwlkk/nYtTlRnk1egUvCHX5M2fdb/dzrb36h0ShJ7T+7Q
         vwVc8AiZbebLQrAs92HiWLAzESp8eSSq3lZbW/4Gm6f78z4yzLfRoik90/31RxigcY8h
         AeWA==
X-Gm-Message-State: AOJu0YzvP4Fovk6MC16RJFduOmQ5dfKVupJdABXFkX81HJe3qOpAMfCN
        79h2WsLspQJFYMZWt7fy59x59zMpO1gZYTMpIb0Y44gA3O547y/MxiO/C8Vb3UWLhxVTFXD55VN
        O05cSHNsr4GwjA3U7IPRcxCDqE8PrJg7jyUctsWtqt7CDUGn94k4=
X-Received: by 2002:a17:90a:f48f:b0:268:557e:1848 with SMTP id bx15-20020a17090af48f00b00268557e1848mr23551684pjb.2.1697199169161;
        Fri, 13 Oct 2023 05:12:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBvA6sxwqduYMOHMNKjitLGiCoD4RHhnQ5i4MZ/EXdYo7Tk3TFhg+8T1vmgC8xsL6oV7ocy5/Xpef6kqIPGPo=
X-Received: by 2002:a17:90a:f48f:b0:268:557e:1848 with SMTP id
 bx15-20020a17090af48f00b00268557e1848mr23551646pjb.2.1697199168178; Fri, 13
 Oct 2023 05:12:48 -0700 (PDT)
MIME-Version: 1.0
References: <20231011130522.78994-1-xni@redhat.com> <20231013113034.0000298a@linux.intel.com>
 <CALTww282t6UMePRPPmoxyxBpedbjWC=9ojjHQx8o8sJttnzvSA@mail.gmail.com> <20231013135935.00005679@linux.intel.com>
In-Reply-To: <20231013135935.00005679@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 13 Oct 2023 20:12:38 +0800
Message-ID: <CALTww29C_kS9e9hxbz+GFWVvAci1CZSfHxWTigD3zCYdZghmYw@mail.gmail.com>
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
>
> >
> > Let me check if I understand right:
> >
> > It needs to check raid0_need_layout when <=3D kernel 5.4. It can set
> > MD_FEATURE_RAID0_LAYOUT for all raid0 > kernel 5.4
>
> Correct! I'm accepting risk in extraordinary cases. In general, kernel is=
 bumped
> not downgraded.

Thanks. I'll send a new version :)

>
> >
> >
> > > So, it forces the calculations made by Neil back but I think that we =
can
> > > simply compare dev_size and data_offset between members.
> >
> > We don't need to consider the compatibility anymore in future?
> >
> Not sure if I get your question correctly. This property is supported now=
 so
> why we should? It is already there so we are safe to set it.

I asked because you said we can remove the check in future. So I don't
know why we don't need the check in future. The check here should be
the kernel version check, right?

>
> This comment is about code optimization here:
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
>
> I think that we can check:
> if (di->dev_size !=3D di2->dev_size || di->data_offset !=3D di2->data_off=
set)
>     raid0_need_layout =3D 1;
>
> but I could be wrong here, it is zoned raid, I don't have experience in t=
his
> area. It is existing code so you don't need to dig into. You can left it =
as is.
>
> Isn't the size of members saved somewhere, do we need to count it?

In fact, I have the same question as you. It looks like it can do as
your code mentioned above. We only store the member disk size in
superblock. I'll seft it as is.

Best Regards
Xiao

