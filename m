Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B9CC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Dec 2021 05:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346398AbhLWF1e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Dec 2021 00:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhLWF1c (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Dec 2021 00:27:32 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D0AC061401
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 21:27:32 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id u20so4224130pfi.12
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 21:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WkeAwhEdB+7J+yxlgyZbAp4xvl/4lZjLGHAo1J0gL44=;
        b=BCh2iE/tsW77wAZY9pcs/VOPKmO/2q3q11EjMMUbRbSPrlZQxcGiISfqHoFeXBmeOI
         mdx+92bwP9NA4908FD/QD92SdkmG84vC80poaxV9fd1HhsgYLSXQFla4fg3ryk8gO2GI
         AgQrsg2xCCaVk0/4HvfLjaFpOIaC2HN+NcMcOF/aKEOp1tVio2LmzAET14muQPwRJEvk
         u7D/ZniQPIqBi+kfqgcydgGDXDvjzvaCnivoSkUghplrp/0RQ8fbjOV1BL9PUKZi8fnf
         /J0Xzwa/sRzUYtuz4PzKOMSMyk+dpqx3Gbdd/y4DH+wh6gfZMM2E7fT5iND2qUDr11B/
         wddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WkeAwhEdB+7J+yxlgyZbAp4xvl/4lZjLGHAo1J0gL44=;
        b=zjyQoYyYuOuLAO2B3dDafs/84H0DnbtKpEln7NzYc50zAtTntHhLuFm/8dB6QOZgcc
         md/kbftlBc3Nt4UkJn+lFO2eYTDhyu/KcOjnbUF4Eh9Y0v4084xS4Q1+I2xs5OF8t3IS
         IyFCzkZIin11xp4WLssChFgpQmjrbxzBEsKqrsGxzhLd8BAoScw7mxQEnBHePlyISIJc
         nkA6HTGFshdC5HnPhD5k63bYDcy6WyYvRmKgV+A2o9eTIIDc525R8SGGrfArFAzTi6ff
         9JuwcfXeCrvFtsHDZghMuadaaIAqqBFe8IO13szMhjXxHBp5uuxzS04hC1raEVCeDCW5
         3WfQ==
X-Gm-Message-State: AOAM533KaeODQP8V/SkscK7HYIzAWnWDEC8ecvJ3jGg0Amyru92wa3XO
        2VxphdcsSslzXDkBc1NhqCSpeI+Eis9APbpIxyp5VW24XG4=
X-Google-Smtp-Source: ABdhPJxEoTa2HgAGzT6cjeEk5PyAA3/GMdNIibyw7Wn6gT2sBO0+EYYlNb8nGcUsDeOJMRIrMWbYurzXeCdPAAym9O8=
X-Received: by 2002:a05:6a00:1485:b0:4bb:317a:a909 with SMTP id
 v5-20020a056a00148500b004bb317aa909mr855063pfu.29.1640237251811; Wed, 22 Dec
 2021 21:27:31 -0800 (PST)
MIME-Version: 1.0
References: <CAGRSmLugFZo95qAOrGoKcfWN2wxe_h3Nyw8EVa+8sRVvPyu3_g@mail.gmail.com>
 <CAJj0OuvmhKP7TsamiA8X+qf38n=_94c8yR42NpUVoNp1jYqgUg@mail.gmail.com>
 <CAGRSmLvPWsYnCwkg61QJB4zjge4mu_-LOthicVzSFJo8+nj5sg@mail.gmail.com>
 <2726e0eb-90c1-b771-25c4-072caf5105be@youngman.org.uk> <02affda1-1f10-997a-616b-f9963a2ec995@grumpydevil.homelinux.org>
 <CAGRSmLvv-bipFyWCbnnU0t2=AK1PG-n7XP9H61eOWe2y+XYsjA@mail.gmail.com> <20211220170808.0000055e@linux.intel.com>
In-Reply-To: <20211220170808.0000055e@linux.intel.com>
From:   "David F." <df7729@gmail.com>
Date:   Wed, 22 Dec 2021 21:27:20 -0800
Message-ID: <CAGRSmLsSOh9vbPpDqgkaFtHsXUv7m5q3FRYb6Y5GLRBh9OUNWw@mail.gmail.com>
Subject: Re: Latest HP ProLiant DL380 G10 RAID1 support?
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
        Wol <antlists@youngman.org.uk>,
        "C.J. Collier" <cjac@colliertech.org>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I haven't been able to get the screen pic to see what it's configured
in or more information from Windows side yet other than "This is an HP
Server and it has SR controller in it. I believe it is called software
RAID."

"

On Mon, Dec 20, 2021 at 8:09 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi David,
>
> On Sun, 19 Dec 2021 19:05:45 -0800
> "David F." <df7729@gmail.com> wrote:
>
> > The report shows:
> >
> > RAID bus controller [0104]: Intel Corporation C620 Series
> > Chipset Family SSATA Controller [RAID mode] [8086:a1d6] (rev 09)
> >     Subsystem: Hewlett Packard Enterprise Device [1590:00e6]
> >     Kernel driver in use: ahci
>
> It seems to be IMSM (Intel) raid, officially called "VROC". Could you
> confirm it?
>
> >> Output of blkid command:
> >> /dev/sdc1: UUID="B6C669F7C669B7EF" TYPE="ntfs" PARTLABEL="'Recovery'"
> >> PARTUUID="8713d776-d472-46ef-8023-cb599f2017bf"
> >> /dev/sdc2: UUID="006A-0698" TYPE="vfat" PARTLABEL="'EFI system
> >> partition'" PARTUUID="661cc486-d53a-412c-882e-140aeb126baf"
> >> /dev/sdc3: UUID="4EBEAEE02F3D5ED1" TYPE="ntfs" PARTLABEL="'Microsoft
> >> reserved partition'" PARTUUID="5ef03407-ebcd-4a72-86d1-fd1f5a047b8e"
> >> /dev/sdc4: UUID="3D629FBB15FAC28A" TYPE="ntfs" PARTLABEL="'Basic data
> >> partition'" PARTUUID="e5ef9438-fad4-4ee8-b7c0-c225ecba2173"
> >> /dev/sdd1: UUID="B6C669F7C669B7EF" TYPE="ntfs" PARTLABEL="'Recovery'"
> >> PARTUUID="8713d776-d472-46ef-8023-cb599f2017bf"
> >> /dev/sdd2: UUID="006A-0698" TYPE="vfat" PARTLABEL="'EFI system
> >> partition'" PARTUUID="661cc486-d53a-412c-882e-140aeb126baf"
> >> /dev/sdd3: UUID="4EBEAEE02F3D5ED1" TYPE="ntfs" PARTLABEL="'Microsoft
> >> reserved partition'" PARTUUID="5ef03407-ebcd-4a72-86d1-fd1f5a047b8e"
> >> /dev/sdd4: UUID="3D629FBB15FAC28A" TYPE="ntfs" PARTLABEL="'Basic data
> >> partition'" PARTUUID="e5ef9438-fad4-4ee8-b7c0-c225ecba2173"
> >> /dev/sdf1: UUID="714C-EFFD" TYPE="vfat"
> >> /dev/sdb: PTTYPE="PMBR"
> >> /dev/sde: PTTYPE="PMBR"
>
> If it is IMSM, blkid should report:
> /dev/<disk>: TYPE="isw_raid_member"
> for each member drive. Metadata seems to be destroyed but let confirm
> first that we have IMSM here.
>
> Thanks,
> Mariusz
