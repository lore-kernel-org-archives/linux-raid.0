Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A7CC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 06:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiCIGgu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Mar 2022 01:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiCIGgt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Mar 2022 01:36:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4E415F614
        for <linux-raid@vger.kernel.org>; Tue,  8 Mar 2022 22:35:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFE0BB81FB9
        for <linux-raid@vger.kernel.org>; Wed,  9 Mar 2022 06:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49954C340E8
        for <linux-raid@vger.kernel.org>; Wed,  9 Mar 2022 06:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646807748;
        bh=Yu6rX+er6dggP7MwnItMFemrr9GUu+utrL0S3orIhWw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jjBM9uQVXOaC6tX+SsGHjkKu4KyOiuQikyp4EUPmEN5mMGuZuMH+Yq85NbAP4sEi0
         yALIgGzmV2uj7vG5WwjaROvdtZOQoljeZracexQ55Pc9I/xUMWSpl2kCxJ9xKtq109
         BNNGpBFy9TnIZ1dOjs546wpb5LtR+g+QdjKKyxDNnUM5drYeFukCXNL/fQZL5gHJ9w
         XvkXSdwT1JfA+zQ9n4zMmDaFg2hXzLI48Jensp49XMeuZ5GH0A2X4u7Vvm9FOGCZky
         A9rdvt9zjNqtUN1zJIx1eTkp/G6RO2l2LkZuQUF+tOg0LclS1oDjXU4iqE38G008tH
         A0ax5jwMUA+vg==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-2dbfe58670cso12245827b3.3
        for <linux-raid@vger.kernel.org>; Tue, 08 Mar 2022 22:35:48 -0800 (PST)
X-Gm-Message-State: AOAM533tLmtxV65ghTsVfgae5vTsxi/ealSYiYP67lzBLQWaRaLlvFUt
        InNKBkEAH7sUtF6ZYNgac7n/2glwRViHGTz+TZU=
X-Google-Smtp-Source: ABdhPJz47DRjHLVR5tbmFzXv8aG0qlbx87m1i/TVkGnmUEEgi7AcmTkRCy268D/C8ucIIUHuF47bwO1iCMBV4v1J7jU=
X-Received: by 2002:a0d:fb45:0:b0:2d0:d09a:576c with SMTP id
 l66-20020a0dfb45000000b002d0d09a576cmr16327368ywf.447.1646807747044; Tue, 08
 Mar 2022 22:35:47 -0800 (PST)
MIME-Version: 1.0
References: <0eb91a43-a153-6e29-14b6-65f97b9f3d99@nuclearwinter.com>
 <CAPhsuW68V0ZO55_Un0vnrAt_+XpGRX3yq3nR=35f7P2d5iPvTA@mail.gmail.com> <c7c568cf-14e8-b0ce-5690-35aecce9e784@nuclearwinter.com>
In-Reply-To: <c7c568cf-14e8-b0ce-5690-35aecce9e784@nuclearwinter.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 8 Mar 2022 22:35:36 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5d50yF59Gg9t_kNAkJ9-OyDs+KF7V8fSeCLU+0DXN8zA@mail.gmail.com>
Message-ID: <CAPhsuW5d50yF59Gg9t_kNAkJ9-OyDs+KF7V8fSeCLU+0DXN8zA@mail.gmail.com>
Subject: Re: Raid6 check performance regression 5.15 -> 5.16
To:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        Roger Heflin <rogerheflin@gmail.com>,
        Wilson Jonathan <i400sjon@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Mar 8, 2022 at 2:51 PM Larkin Lowrey <llowrey@nuclearwinter.com> wrote:
>
> On Tue, Mar 8, 2022 at 3:50 PM Song Liu <song@kernel.org> wrote:
> > On Mon, Mar 7, 2022 at 10:21 AM Larkin Lowrey <llowrey@nuclearwinter.com> wrote:
> >> I am seeing a 'check' speed regression between kernels 5.15 and 5.16.
> >> One host with a 20 drive array went from 170MB/s to 11MB/s. Another host
> >> with a 15 drive array went from 180MB/s to 43MB/s. In both cases the
> >> arrays are almost completely idle. I can flip between the two kernels
> >> with no other changes and observe the performance changes.
> >>
> >> Is this a known issue?
> >
> > I am not aware of this issue. Could you please share
> >
> >    mdadm --detail /dev/mdXXXX
> >
> > output of the array?
> >
> > Thanks,
> > Song
>
> Host A:
> # mdadm --detail /dev/md1
> /dev/md1:
>             Version : 1.2
>       Creation Time : Thu Nov 19 18:21:44 2020
>          Raid Level : raid6
>          Array Size : 126961942016 (118.24 TiB 130.01 TB)
>       Used Dev Size : 9766303232 (9.10 TiB 10.00 TB)
>        Raid Devices : 15
>       Total Devices : 15
>         Persistence : Superblock is persistent
>
>       Intent Bitmap : Internal
>
>         Update Time : Tue Mar  8 12:39:14 2022
>               State : clean
>      Active Devices : 15
>     Working Devices : 15
>      Failed Devices : 0
>       Spare Devices : 0
>
>              Layout : left-symmetric
>          Chunk Size : 512K
>
> Consistency Policy : bitmap
>
>                Name : fubar:1  (local to host fubar)
>                UUID : eaefc9b7:74af4850:69556e2e:bc05d666
>              Events : 85950
>
>      Number   Major   Minor   RaidDevice State
>         0       8        1        0      active sync   /dev/sda1
>         1       8       17        1      active sync   /dev/sdb1
>         2       8       33        2      active sync   /dev/sdc1
>         3       8       49        3      active sync   /dev/sdd1
>         4       8       65        4      active sync   /dev/sde1
>         5       8       81        5      active sync   /dev/sdf1
>        16       8       97        6      active sync   /dev/sdg1
>         7       8      113        7      active sync   /dev/sdh1
>         8       8      129        8      active sync   /dev/sdi1
>         9       8      145        9      active sync   /dev/sdj1
>        10       8      161       10      active sync   /dev/sdk1
>        11       8      177       11      active sync   /dev/sdl1
>        12       8      193       12      active sync   /dev/sdm1
>        13       8      209       13      active sync   /dev/sdn1
>        14       8      225       14      active sync   /dev/sdo1
>
> Host B:
> # mdadm --detail /dev/md1
> /dev/md1:
>             Version : 1.2
>       Creation Time : Thu Oct 10 14:18:16 2019
>          Raid Level : raid6
>          Array Size : 140650080768 (130.99 TiB 144.03 TB)
>       Used Dev Size : 7813893376 (7.28 TiB 8.00 TB)
>        Raid Devices : 20
>       Total Devices : 20
>         Persistence : Superblock is persistent
>
>       Intent Bitmap : Internal
>
>         Update Time : Tue Mar  8 17:40:48 2022
>               State : clean
>      Active Devices : 20
>     Working Devices : 20
>      Failed Devices : 0
>       Spare Devices : 0
>
>              Layout : left-symmetric
>          Chunk Size : 128K
>
> Consistency Policy : bitmap
>
>                Name : mcp:1
>                UUID : 803f5eb5:e59d4091:5b91fa17:64801e54
>              Events : 302158
>
>      Number   Major   Minor   RaidDevice State
>         0       8        1        0      active sync   /dev/sda1
>         1      65      145        1      active sync   /dev/sdz1
>         2      65      177        2      active sync   /dev/sdab1
>         3      65      209        3      active sync   /dev/sdad1
>         4       8      209        4      active sync   /dev/sdn1
>         5      65      129        5      active sync   /dev/sdy1
>         6       8      241        6      active sync   /dev/sdp1
>         7      65      241        7      active sync   /dev/sdaf1
>         8       8      161        8      active sync   /dev/sdk1
>         9       8      113        9      active sync   /dev/sdh1
>        10       8      129       10      active sync   /dev/sdi1
>        11      66       33       11      active sync   /dev/sdai1
>        12      65        1       12      active sync   /dev/sdq1
>        13       8       65       13      active sync   /dev/sde1
>        14      66       17       14      active sync   /dev/sdah1
>        15       8       49       15      active sync   /dev/sdd1
>        19      66       81       16      active sync   /dev/sdal1
>        16      66       65       17      active sync   /dev/sdak1
>        17       8      145       18      active sync   /dev/sdj1
>        18      66      129       19      active sync   /dev/sdao1
>
> The regression was introduced somewhere between these two Fedora kernels:
> 5.15.18-200 (good)
> 5.16.5-200 (bad)

Hi folks,

Sorry for the regression and thanks for sharing your array setup and
observations.

I think I have found the fix for it. I will send a patch for it. If
you want to try the fix
sooner, you can find it at:

For 5.16:
https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=tmp/fix-5.16&id=872c1a638b9751061b11b64a240892c989d1c618

For 5.17:
https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=tmp/fix-5.17&id=c06ccb305e697d89fe99376c9036d1a2ece44c77

Thanks,
Song
