Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A9ECDB47E
	for <linux-raid@archiver.kernel.org>; Fri, 13 Oct 2023 11:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjJMLAW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Oct 2023 07:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjJMLAU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Oct 2023 07:00:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEAEAD
        for <linux-raid@vger.kernel.org>; Fri, 13 Oct 2023 03:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697194774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OY+6MsDEF1MqhCUocgCCBSv6+CgqaUCNnEkLBqt32DI=;
        b=Mr0xlOmcNP3nK1QwkcH8EFz8jnF3CiT0MXrdjY8OGKd3cy8XKX0u6SaVYbNCrLZQ7pCcGl
        RHczHMwnkoWWbqN8NGpQYOqpeF+bLrnCP22fYntW4xRDwVAJQXKhwUy2k21ovW/kK2bgN2
        8gEi9BOeCIdcTnJhPS2r7D65yxKpHFU=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-D9rg1PP2PRaOQ0i7Aos1QA-1; Fri, 13 Oct 2023 06:59:32 -0400
X-MC-Unique: D9rg1PP2PRaOQ0i7Aos1QA-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-27d2391146dso1160644a91.2
        for <linux-raid@vger.kernel.org>; Fri, 13 Oct 2023 03:59:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697194772; x=1697799572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OY+6MsDEF1MqhCUocgCCBSv6+CgqaUCNnEkLBqt32DI=;
        b=Ltm3cZObaXUF0XP2onuqkblyFG2TVs8zpePRkjQRhRaY4d7Eia99oHJcIb7AKcJCnN
         GkFvhTrjW0PXGrcOkmyoTkfHcD+NDGpI9yUAgtsaSN8QRLFNZiZIEYy7r3SIRArbuLQp
         u6GWdy2RIkyvL1leAxMdEbUXZwbmU3yIQlQNemJ5aFOwa4iZsXL/q6DOroGU1hUK9pT1
         oPjfZnFTOuthz+QzXNEOztNrrfnjaUEpWx+BxHBsDySC9cJuQHwHk4XaNh71UQBFHp7m
         l7oj3WeT7+zvK5UElYz1XWByHtMzMn0N9tMbt3Oz7YZTybA5/obOZK0+WUNjlX4BCtVB
         lzIA==
X-Gm-Message-State: AOJu0YwbsYQ5On+RIqvD4+vX0j0ciRPutBrZVoLzTdoyjcBJlEkhEIGV
        My/gbWJRI3EG1pnQmHOVc4Xwe+94hQ8t7dNiai+Qi0UAsZq3RT1GkxCdFXJbCkCdtq4dAxyavXT
        ZwK5qHJUW3TOe7p8AI2nCEl9tZw4m3jQBTbU8CA==
X-Received: by 2002:a17:90b:120e:b0:27d:e5d:33bf with SMTP id gl14-20020a17090b120e00b0027d0e5d33bfmr6018010pjb.15.1697194771786;
        Fri, 13 Oct 2023 03:59:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbVXQHJOD/MTRT93YY9OEYZgaDgKTNMCLmJnRXJ93869rhuAFRWMw4spVPhGBO5mxXRIYiG0/svyAfWePnLck=
X-Received: by 2002:a17:90b:120e:b0:27d:e5d:33bf with SMTP id
 gl14-20020a17090b120e00b0027d0e5d33bfmr6018003pjb.15.1697194771459; Fri, 13
 Oct 2023 03:59:31 -0700 (PDT)
MIME-Version: 1.0
References: <20231011130522.78994-1-xni@redhat.com> <20231013113034.0000298a@linux.intel.com>
In-Reply-To: <20231013113034.0000298a@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 13 Oct 2023 18:59:21 +0800
Message-ID: <CALTww282t6UMePRPPmoxyxBpedbjWC=9ojjHQx8o8sJttnzvSA@mail.gmail.com>
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

On Fri, Oct 13, 2023 at 5:31=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Wed, 11 Oct 2023 21:05:22 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > In kernel space super_1_validate sets mddev->layout to -1 if
> > MD_FEATURE_RAID0_LAYOUT is not set. MD_FEATURE_RAID0_LAYOUT is set in m=
dadm
> > write_init_super1. Now only raid with more than one zone can set this b=
it.
> > But for raid0 with same size member disks, it doesn't set this bit. The
> > layout is *unknown* when running mdadm -D command. In fact it should be
> > RAID0_ORIG_LAYOUT which gets from default_layout.
> >
> > So set MD_FEATURE_RAID0_LAYOUT when sb->layout has value.
> >
> > Fixes: 329dfc28debb ('Create: add support for RAID0 layouts.')
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  super1.c | 21 ++-------------------
> >  1 file changed, 2 insertions(+), 19 deletions(-)
> >
> > diff --git a/super1.c b/super1.c
> > index 856b02082662..f29751b4a5c7 100644
> > --- a/super1.c
> > +++ b/super1.c
> > @@ -1978,26 +1978,10 @@ static int write_init_super1(struct supertype *=
st)
> >       unsigned long long sb_offset;
> >       unsigned long long data_offset;
> >       long bm_offset;
> > -     int raid0_need_layout =3D 0;
> >
> > -     for (di =3D st->info; di; di =3D di->next) {
> > +     for (di =3D st->info; di; di =3D di->next)
> >               if (di->disk.state & (1 << MD_DISK_JOURNAL))
> >                       sb->feature_map |=3D __cpu_to_le32(MD_FEATURE_JOU=
RNAL);
> > -             if (sb->level =3D=3D 0 && sb->layout !=3D 0) {
> > -                     struct devinfo *di2 =3D st->info;
> > -                     unsigned long long s1, s2;
> > -                     s1 =3D di->dev_size;
> > -                     if (di->data_offset !=3D INVALID_SECTORS)
> > -                             s1 -=3D di->data_offset;
> > -                     s1 /=3D __le32_to_cpu(sb->chunksize);
> > -                     s2 =3D di2->dev_size;
> > -                     if (di2->data_offset !=3D INVALID_SECTORS)
> > -                             s2 -=3D di2->data_offset;
> > -                     s2 /=3D __le32_to_cpu(sb->chunksize);
> > -                     if (s1 !=3D s2)
> > -                             raid0_need_layout =3D 1;
> > -             }
> > -     }
> >
> >       for (di =3D st->info; di; di =3D di->next) {
> >               if (di->disk.state & (1 << MD_DISK_FAULTY))
> > @@ -2139,8 +2123,7 @@ static int write_init_super1(struct supertype *st=
)
> >                       sb->bblog_offset =3D 0;
> >               }
> >
> > -             /* RAID0 needs a layout if devices aren't all the same si=
ze
> > */
> > -             if (raid0_need_layout)
> > +             if (sb->level =3D=3D 0 && sb->layout)
> >                       sb->feature_map |=3D
> > __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
> >               sb->sb_csum =3D calc_sb_1_csum(sb);
> Hi Xiao,
>
> I read Neil patch:
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D329dfc2=
8de
>
> For sure Neil has a purpose to make it this way. I think that because it =
breaks
> creation when layout is not supported by kernel. Neil wanted to keep poss=
ible
> largest compatibility so it sets layout feature only if it is necessary.
> Your change forces layout bit to be always used. Can you test this change=
 on
> kernel without raid0_layout support? I expect regression for same dev siz=
e raid
> arrays.

Hi Mariusz

Thanks for pointing out this. I only think the kernel which supports
MD_FEATURE_RAID0_LAYOUT

>
> I think that before we will set layout bit we should check kernel
> version, it must be higher than 5.4. In the future we would remove this c=
heck.

Let me check if I understand right:

It needs to check raid0_need_layout when <=3D kernel 5.4. It can set
MD_FEATURE_RAID0_LAYOUT for all raid0 > kernel 5.4


> So, it forces the calculations made by Neil back but I think that we can =
simply
> compare dev_size and data_offset between members.

We don't need to consider the compatibility anymore in future?

Best Regards
Xiao
>
> Thanks,
> Mariusz
>

