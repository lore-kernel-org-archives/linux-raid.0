Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C20C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 08:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE61160EB6
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 08:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhJLIT6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Oct 2021 04:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232541AbhJLIT6 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 12 Oct 2021 04:19:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFF6660F23;
        Tue, 12 Oct 2021 08:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634026677;
        bh=O6YnQ6b4Trs6QluMttA3AsFs4aF9SM6xHU/t4DKvyTg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BZdnk4kj10eF4uEL6UQmlX9cXLWKhntEHIog5IiiWy6oi03Rs9Vy7hiLkoMhb01cK
         jkTMvDk3/sOBe8RY6RI3z5BqnRY2kIdrTfg96CxHS+JzKGwP9zBPMuzUXwp9ZC1OkB
         NJUacUssiNN5o3CVEzhgoGRTONDLUhhKakBld00Z1/9Sxvk3LEkrzmYWRAmzJxFvjQ
         BAEhmY2czxDkkZurU7PoPFstdMkndfphZ41VupVyoZPTsVlD9bbkq+PsaXQgpkcFrg
         qs35g/FOskmvwWI+RHt9w40Vhce1DrugvKNc92XT5eM58rLbbnibObKRrCJr49hb2c
         AaT4ixBlT+iLw==
Received: by mail-lf1-f54.google.com with SMTP id u18so84176791lfd.12;
        Tue, 12 Oct 2021 01:17:56 -0700 (PDT)
X-Gm-Message-State: AOAM530PIop8lR92HAGFVlhFVXo2Acpwx8utvQup1hzMwdb1BWomUHpE
        IM/BHBtZ7lgO4XJDUYVeq3NaqQYmpZ74Xi5FZKk=
X-Google-Smtp-Source: ABdhPJzzS8BadDYCdKON8s6JDRiKBtNpl1vB+T18h7RmJroMdHNwePQeKdXq4Urk7tLajYxYtDSkgGqauBXv5xb5xfs=
X-Received: by 2002:a2e:3907:: with SMTP id g7mr28814014lja.285.1634026675077;
 Tue, 12 Oct 2021 01:17:55 -0700 (PDT)
MIME-Version: 1.0
References: <20211008032231.1143467-1-fengli@smartx.com> <CAPhsuW5+bdQwsyjBP=QDGRbtnF021291D_XrhNtV+v-geVouVg@mail.gmail.com>
 <CALTww28b0HGzSTTNGVzeZdRp0nGMDAyY8sQ+cBsSCuYJ4jMaqw@mail.gmail.com>
 <CAHckoCyuqxM8po4JA4=OacVWhYuo9SWescUVOKRFGwdc=aoN8A@mail.gmail.com>
 <CALTww28CsJdmVOLFeoHC8FgbHDK78h8Lncsf9fFA0RYXEj=R9A@mail.gmail.com> <CAHckoCzzVP7npmU4LWedzD-f1QmkH4K0iLk_=8ptSFXrFfRoDw@mail.gmail.com>
In-Reply-To: <CAHckoCzzVP7npmU4LWedzD-f1QmkH4K0iLk_=8ptSFXrFfRoDw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 12 Oct 2021 01:17:43 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4VFTpM94by-iMkTQ=b9Y7FqZ2oqHH+jV-f8BM=YKWyiA@mail.gmail.com>
Message-ID: <CAPhsuW4VFTpM94by-iMkTQ=b9Y7FqZ2oqHH+jV-f8BM=YKWyiA@mail.gmail.com>
Subject: Re: [PATCH RESEND] md: allow to set the fail_fast on RAID1/RAID10
To:     Li Feng <fengli@smartx.com>
Cc:     Xiao Ni <xni@redhat.com>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Oct 12, 2021 at 1:07 AM Li Feng <fengli@smartx.com> wrote:
>
> Xiao Ni <xni@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8812=E6=97=A5=E5=
=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=882:58=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Mon, Oct 11, 2021 at 5:42 PM Li Feng <fengli@smartx.com> wrote:
> > >
> > > Xiao Ni <xni@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8811=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=883:49=E5=86=99=E9=81=93=EF=BC=9A
> > > >
> > > > Hi all
> > > >
> > > > Now the per device sysfs interface file state can change failfast. =
Do
> > > > we need a new file for failfast?
> > > >
> > > > I did a test. The steps are:
> > > >
> > > > mdadm -CR /dev/md0 -l1 -n2 /dev/sdb /dev/sdc --assume-clean
> > > > cd /sys/block/md0/md/dev-sdb
> > > > echo failfast > state
> > > > cat state
> > > > in_sync,failfast
> > >
> > > This works,  will it be persisted to disk?
> > >
> >
> > mdadm --detail /dev/md0 can show the failfast information. So it
> > should be written in superblock.
> > But I don't find how md does this. I'm looking at this.
> >
> Yes, I have tested that it has been persisted, but don't understand who d=
oes it.

I think this is not guaranteed to be persistent:

[root@eth50-1 ~]# cat /sys/block/md127/md/rd1/state
in_sync,failfast
[root@eth50-1 ~]# echo -failfast >  /sys/block/md127/md/rd1/state
[root@eth50-1 ~]# cat /sys/block/md127/md/rd1/state
in_sync
[root@eth50-1 ~]# mdadm --stop /dev/md*
mdadm: /dev/md does not appear to be an md device
mdadm: stopped /dev/md127
[root@eth50-1 ~]# mdadm -As
mdadm: /dev/md/0_0 has been started with 4 drives.
[root@eth50-1 ~]# cat /sys/block/md127/md/rd1/state
in_sync,failfast

How about we fix state_store to make sure it is always persistent?

Thanks,
Song
