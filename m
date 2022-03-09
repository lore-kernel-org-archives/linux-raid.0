Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2569C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 16:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbiCIQgr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Mar 2022 11:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbiCIQcp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Mar 2022 11:32:45 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD581AAFE4
        for <linux-raid@vger.kernel.org>; Wed,  9 Mar 2022 08:28:11 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id im7so2396790qvb.4
        for <linux-raid@vger.kernel.org>; Wed, 09 Mar 2022 08:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p3rtsbon/vVhl27hsUB5Jf9YWho2FneG79SAR7NwcdA=;
        b=p5rQCtXwOwgGQFItdztXLqnX4NC2UCHosYmPu3qSVoHTJqJD8F7wps7Rs7ptpJwi8R
         Zc2iPnE/sHamDtOKlK3hTOxzkdUqjXd8oI+RxggLgZuVNpLrOdKfr6AiNa5YUsoPDBYv
         Ln36fjaYxw2XGpZKeVN/5FDHeXpm+u7f9vK4hIbsP3kGmTDXZTF+0bsRivjZSHjMwfQd
         Bf3zzDpWE8+QhRHcuOdZV0/8fKzKCwnvmopZnVAVQw9WprUDxqnOrIONQjsQmPN7+jYX
         aXeOSiW1GvCYVdYmbNpq+wVn0F/9m6GTDuLtMY/fK3KvNFrW+S2x11yebDOAaXrQ26W2
         WlIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p3rtsbon/vVhl27hsUB5Jf9YWho2FneG79SAR7NwcdA=;
        b=16MgMqx46n8GZw9/ZL4asg6DIw0pw+onHRFr3y3wWT67iD7mX4AqMoLe7PHMRdwrfi
         jE2r4IhogKk2+uL70RskxBiJYmxBiBN5vS1T7c+2OgQ4i0GgKSO/M+PWk+F9pCOkpau1
         suatXKJXtKjsuF1DfLj3tIGWbWd4m5jNYYh6KDRVKKU9x5mlFhP86l0/iS4KHJxXVo7y
         QMQ7k6CVjHtdEmMl6PcdkBCx2nrZDLlqbYA0qD4GooKHPLy0GnBP0hdYmBLIerj/jR88
         nEeQFN0eXojlxUHEOy4B0gA5Da+9qd8ggQ/5hatLeu+h8Eg6hVTiKvfvjYfwLImak9Uq
         KLLw==
X-Gm-Message-State: AOAM530Esps0XTmGY7JRgdGNkmUiPkO1svqMW7A/6BHkEaixxkvUOnFZ
        Zuh+q+k6hyFH85SNBrsAsHYRMV/VfZNzVW82rWQ=
X-Google-Smtp-Source: ABdhPJwVNetECNGjEDsJMb4vN1ixFd0EO/U6JIK7HB4ss3haf0fV0dTKtMDXY+xIhIJBvgP2fNU/P3MkJ2js+V6J0eA=
X-Received: by 2002:a05:6214:20a5:b0:435:2d5e:4a48 with SMTP id
 5-20020a05621420a500b004352d5e4a48mr312983qvd.3.1646843278977; Wed, 09 Mar
 2022 08:27:58 -0800 (PST)
MIME-Version: 1.0
References: <0eb91a43-a153-6e29-14b6-65f97b9f3d99@nuclearwinter.com>
 <CAPhsuW68V0ZO55_Un0vnrAt_+XpGRX3yq3nR=35f7P2d5iPvTA@mail.gmail.com>
 <c7c568cf-14e8-b0ce-5690-35aecce9e784@nuclearwinter.com> <CAPhsuW5d50yF59Gg9t_kNAkJ9-OyDs+KF7V8fSeCLU+0DXN8zA@mail.gmail.com>
In-Reply-To: <CAPhsuW5d50yF59Gg9t_kNAkJ9-OyDs+KF7V8fSeCLU+0DXN8zA@mail.gmail.com>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Wed, 9 Mar 2022 10:27:35 -0600
Message-ID: <CAAMCDefXLczm941NDxgXN8j56h+jPGrKK5O0avuJb-q6jmophQ@mail.gmail.com>
Subject: Re: Raid6 check performance regression 5.15 -> 5.16
To:     Song Liu <song@kernel.org>
Cc:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have tested this.  The patch seems to fix the issue.

Test method was:

fedora 5.16.11-200 (check broken taking about 4h50m to 5h6min-2runs
that I have data for)
kernel.org 5.16.13 + this patch (17% done in 25min, 100 more minutes
to finish - seems to be fast again predicted around 2hr, is consistent
with good speed before 5.6.16).

On Wed, Mar 9, 2022 at 12:35 AM Song Liu <song@kernel.org> wrote:
>
> On Tue, Mar 8, 2022 at 2:51 PM Larkin Lowrey <llowrey@nuclearwinter.com> wrote:
> >
> > On Tue, Mar 8, 2022 at 3:50 PM Song Liu <song@kernel.org> wrote:
> > > On Mon, Mar 7, 2022 at 10:21 AM Larkin Lowrey <llowrey@nuclearwinter.com> wrote:
> > >> I am seeing a 'check' speed regression between kernels 5.15 and 5.16.
> > >> One host with a 20 drive array went from 170MB/s to 11MB/s. Another host
> > >> with a 15 drive array went from 180MB/s to 43MB/s. In both cases the
> > >> arrays are almost completely idle. I can flip between the two kernels
> > >> with no other changes and observe the performance changes.
> > >>
> > >> Is this a known issue?
> > >
> > > I am not aware of this issue. Could you please share
> > >
> > >    mdadm --detail /dev/mdXXXX
> > >
> > > output of the array?
> > >
> > > Thanks,
> > > Song
> >
> > Host A:
> > # mdadm --detail /dev/md1
> > /dev/md1:
> >             Version : 1.2
> >       Creation Time : Thu Nov 19 18:21:44 2020
> >          Raid Level : raid6
> >          Array Size : 126961942016 (118.24 TiB 130.01 TB)
> >       Used Dev Size : 9766303232 (9.10 TiB 10.00 TB)
> >        Raid Devices : 15
> >       Total Devices : 15
> >         Persistence : Superblock is persistent
> >
> >       Intent Bitmap : Internal
> >
> >         Update Time : Tue Mar  8 12:39:14 2022
> >               State : clean
> >      Active Devices : 15
> >     Working Devices : 15
> >      Failed Devices : 0
> >       Spare Devices : 0
> >
> >              Layout : left-symmetric
> >          Chunk Size : 512K
> >
> > Consistency Policy : bitmap
> >
> >                Name : fubar:1  (local to host fubar)
> >                UUID : eaefc9b7:74af4850:69556e2e:bc05d666
> >              Events : 85950
> >
> >      Number   Major   Minor   RaidDevice State
> >         0       8        1        0      active sync   /dev/sda1
> >         1       8       17        1      active sync   /dev/sdb1
> >         2       8       33        2      active sync   /dev/sdc1
> >         3       8       49        3      active sync   /dev/sdd1
> >         4       8       65        4      active sync   /dev/sde1
> >         5       8       81        5      active sync   /dev/sdf1
> >        16       8       97        6      active sync   /dev/sdg1
> >         7       8      113        7      active sync   /dev/sdh1
> >         8       8      129        8      active sync   /dev/sdi1
> >         9       8      145        9      active sync   /dev/sdj1
> >        10       8      161       10      active sync   /dev/sdk1
> >        11       8      177       11      active sync   /dev/sdl1
> >        12       8      193       12      active sync   /dev/sdm1
> >        13       8      209       13      active sync   /dev/sdn1
> >        14       8      225       14      active sync   /dev/sdo1
> >
> > Host B:
> > # mdadm --detail /dev/md1
> > /dev/md1:
> >             Version : 1.2
> >       Creation Time : Thu Oct 10 14:18:16 2019
> >          Raid Level : raid6
> >          Array Size : 140650080768 (130.99 TiB 144.03 TB)
> >       Used Dev Size : 7813893376 (7.28 TiB 8.00 TB)
> >        Raid Devices : 20
> >       Total Devices : 20
> >         Persistence : Superblock is persistent
> >
> >       Intent Bitmap : Internal
> >
> >         Update Time : Tue Mar  8 17:40:48 2022
> >               State : clean
> >      Active Devices : 20
> >     Working Devices : 20
> >      Failed Devices : 0
> >       Spare Devices : 0
> >
> >              Layout : left-symmetric
> >          Chunk Size : 128K
> >
> > Consistency Policy : bitmap
> >
> >                Name : mcp:1
> >                UUID : 803f5eb5:e59d4091:5b91fa17:64801e54
> >              Events : 302158
> >
> >      Number   Major   Minor   RaidDevice State
> >         0       8        1        0      active sync   /dev/sda1
> >         1      65      145        1      active sync   /dev/sdz1
> >         2      65      177        2      active sync   /dev/sdab1
> >         3      65      209        3      active sync   /dev/sdad1
> >         4       8      209        4      active sync   /dev/sdn1
> >         5      65      129        5      active sync   /dev/sdy1
> >         6       8      241        6      active sync   /dev/sdp1
> >         7      65      241        7      active sync   /dev/sdaf1
> >         8       8      161        8      active sync   /dev/sdk1
> >         9       8      113        9      active sync   /dev/sdh1
> >        10       8      129       10      active sync   /dev/sdi1
> >        11      66       33       11      active sync   /dev/sdai1
> >        12      65        1       12      active sync   /dev/sdq1
> >        13       8       65       13      active sync   /dev/sde1
> >        14      66       17       14      active sync   /dev/sdah1
> >        15       8       49       15      active sync   /dev/sdd1
> >        19      66       81       16      active sync   /dev/sdal1
> >        16      66       65       17      active sync   /dev/sdak1
> >        17       8      145       18      active sync   /dev/sdj1
> >        18      66      129       19      active sync   /dev/sdao1
> >
> > The regression was introduced somewhere between these two Fedora kernels:
> > 5.15.18-200 (good)
> > 5.16.5-200 (bad)
>
> Hi folks,
>
> Sorry for the regression and thanks for sharing your array setup and
> observations.
>
> I think I have found the fix for it. I will send a patch for it. If
> you want to try the fix
> sooner, you can find it at:
>
> For 5.16:
> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=tmp/fix-5.16&id=872c1a638b9751061b11b64a240892c989d1c618
>
> For 5.17:
> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=tmp/fix-5.17&id=c06ccb305e697d89fe99376c9036d1a2ece44c77
>
> Thanks,
> Song
