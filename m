Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6D4C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 08:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7528B61050
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 08:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbhJLIqA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Oct 2021 04:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbhJLIp7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Oct 2021 04:45:59 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858B0C06161C
        for <linux-raid@vger.kernel.org>; Tue, 12 Oct 2021 01:43:57 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id bb12so7035779vkb.5
        for <linux-raid@vger.kernel.org>; Tue, 12 Oct 2021 01:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZgZqaOGPm3fGQ9iYZFcmBjXmsmUelLzgvid1aIpfJQ4=;
        b=PWsCk7uXhaqI3sO4lfo2smARJmvXEd45tQOp3dfvQ/CZUwRO4m7RxijZ2V5Xvr81/w
         IyF+bTDVvDYXvEAAw49QpsWU1LGhmTgaKZXiMoFbTeossBkzm+cjCD53tzUMp6v6wUQX
         wpL93gPZ3Z+Av+fjPGzHXfCIK6lDNEkTZxbGpO2aviLF0vADG2OzmD+e90yjvoosnSKT
         hPMxtqc7FVCu8TH3yDusrKCfJuf+Bd8strSePQFIzGQdgrCuel469nqFAPMVI5XH8fwP
         z8XM7emx/adjqNjIMzk8R7DwcruOpDJvKqRUGZLmSYsGxXskH9nrJu47sX1BZtCALpfz
         5+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZgZqaOGPm3fGQ9iYZFcmBjXmsmUelLzgvid1aIpfJQ4=;
        b=Gm184LiH/kYoOo8cBBrdzi40j8WR0HtGu4dJ4/y0ezCimQhD+FBikHySi9+Tpjc+mQ
         ZSSdlVLCL/OTbyR60f+ZczImDy7ij9h2JgVSrzkZUw4TcqjMavjv7mRJUz1ahF73iopS
         k6VF5iAFfOpG/Q95bo0x8WVslWraBID8QrCsX84Ha45A79sx0fEBDkKJPUJkbSjbjJMF
         s6DdUsiZAJac+Bc44Qo1cg/wP3oPOtfQBpUVBgq+GbqdDd5j6kehEwqPligwRpPw3Ed4
         esCqve+YRAb0FontvbQ2+cfbjm8cc86zzDMx+WIckM1JCWeYiH9JyheoPH4cT1D6tceS
         0oBg==
X-Gm-Message-State: AOAM53002ufCHYMkyKsVOW1NtyKsTUQu4oUI7MtLVT9LKUJ20KB9I/t9
        l5/A+YipQc80QySKcwn9sDcZn7r8Eai62E2WNKQtZg==
X-Google-Smtp-Source: ABdhPJz2MWRH30ay4UqAGCweGR1qXBnPa6UC1+/lNVGWcyJvFutNRSSQL58AVsrEME2lXekP2PZFuCbqgB6cZOV3xh0=
X-Received: by 2002:a1f:1ed1:: with SMTP id e200mr25078417vke.7.1634028236636;
 Tue, 12 Oct 2021 01:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <20211008032231.1143467-1-fengli@smartx.com> <CAPhsuW5+bdQwsyjBP=QDGRbtnF021291D_XrhNtV+v-geVouVg@mail.gmail.com>
 <CALTww28b0HGzSTTNGVzeZdRp0nGMDAyY8sQ+cBsSCuYJ4jMaqw@mail.gmail.com>
 <CAHckoCyuqxM8po4JA4=OacVWhYuo9SWescUVOKRFGwdc=aoN8A@mail.gmail.com>
 <CALTww28CsJdmVOLFeoHC8FgbHDK78h8Lncsf9fFA0RYXEj=R9A@mail.gmail.com>
 <CAHckoCzzVP7npmU4LWedzD-f1QmkH4K0iLk_=8ptSFXrFfRoDw@mail.gmail.com> <CAPhsuW4VFTpM94by-iMkTQ=b9Y7FqZ2oqHH+jV-f8BM=YKWyiA@mail.gmail.com>
In-Reply-To: <CAPhsuW4VFTpM94by-iMkTQ=b9Y7FqZ2oqHH+jV-f8BM=YKWyiA@mail.gmail.com>
From:   Li Feng <fengli@smartx.com>
Date:   Tue, 12 Oct 2021 16:43:45 +0800
Message-ID: <CAHckoCxRj1qb=yfeQ2o_8n_BSSLD9JXqm8GopUp2qx9NEPxr7w@mail.gmail.com>
Subject: Re: [PATCH RESEND] md: allow to set the fail_fast on RAID1/RAID10
To:     Song Liu <song@kernel.org>
Cc:     Xiao Ni <xni@redhat.com>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Song Liu <song@kernel.org> =E4=BA=8E2021=E5=B9=B410=E6=9C=8812=E6=97=A5=E5=
=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=884:17=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Oct 12, 2021 at 1:07 AM Li Feng <fengli@smartx.com> wrote:
> >
> > Xiao Ni <xni@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8812=E6=97=A5=
=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=882:58=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Mon, Oct 11, 2021 at 5:42 PM Li Feng <fengli@smartx.com> wrote:
> > > >
> > > > Xiao Ni <xni@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8811=E6=97=
=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=883:49=E5=86=99=E9=81=93=EF=BC=9A
> > > > >
> > > > > Hi all
> > > > >
> > > > > Now the per device sysfs interface file state can change failfast=
. Do
> > > > > we need a new file for failfast?
> > > > >
> > > > > I did a test. The steps are:
> > > > >
> > > > > mdadm -CR /dev/md0 -l1 -n2 /dev/sdb /dev/sdc --assume-clean
> > > > > cd /sys/block/md0/md/dev-sdb
> > > > > echo failfast > state
> > > > > cat state
> > > > > in_sync,failfast
> > > >
> > > > This works,  will it be persisted to disk?
> > > >
> > >
> > > mdadm --detail /dev/md0 can show the failfast information. So it
> > > should be written in superblock.
> > > But I don't find how md does this. I'm looking at this.
> > >
> > Yes, I have tested that it has been persisted, but don't understand who=
 does it.
>
> I think this is not guaranteed to be persistent:
>
> [root@eth50-1 ~]# cat /sys/block/md127/md/rd1/state
> in_sync,failfast
> [root@eth50-1 ~]# echo -failfast >  /sys/block/md127/md/rd1/state
> [root@eth50-1 ~]# cat /sys/block/md127/md/rd1/state
> in_sync
> [root@eth50-1 ~]# mdadm --stop /dev/md*
> mdadm: /dev/md does not appear to be an md device
> mdadm: stopped /dev/md127
> [root@eth50-1 ~]# mdadm -As
> mdadm: /dev/md/0_0 has been started with 4 drives.
> [root@eth50-1 ~]# cat /sys/block/md127/md/rd1/state
> in_sync,failfast
>
> How about we fix state_store to make sure it is always persistent?
>
I agree with you.

> Thanks,
> Song
