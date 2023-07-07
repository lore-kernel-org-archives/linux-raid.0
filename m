Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD29EB64D9
	for <linux-raid@archiver.kernel.org>; Fri,  7 Jul 2023 09:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjGGJMD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 7 Jul 2023 05:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjGGJMC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 7 Jul 2023 05:12:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3E61B6
        for <linux-raid@vger.kernel.org>; Fri,  7 Jul 2023 02:12:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BCE7618BB
        for <linux-raid@vger.kernel.org>; Fri,  7 Jul 2023 09:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C74C433CA
        for <linux-raid@vger.kernel.org>; Fri,  7 Jul 2023 09:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688721120;
        bh=YZ/SU3/e8t2Sl04r7wpS6Gu2AzAdaz7i4ntFrz2MrD0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=i5jzDukXbWYr88i351ePO3Hg4w65Chsy81+8cF/erq3KS1nuX6dTtv+KcFrCMBsiD
         GzBf2B2PzYl4vp+XPoPUjd73pV/1rJ3WAKSm66aHwha7NY/zpg0ncwOZOoYXJDgSrM
         UZ54oSrxqzQNZ7oogmpywpqHzwSYmeVdYNPRypigGHmU9m6Fcs0JEyYbu/YRHnatjS
         61iIZKCN0Khqusg6MxhHs+JzDsyArr7UXy3kpjvkgk+vM6ZqN9ykUBxBUI6LP5GySy
         tpMMmHuM3+NnX4GEBDd3+f83pgDFTnnE85EbEjQuX6K/Vijg3KyoqGFMgJIitK4ard
         R+iBWkTZt2Tmw==
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2b6f0508f54so24702141fa.3
        for <linux-raid@vger.kernel.org>; Fri, 07 Jul 2023 02:12:00 -0700 (PDT)
X-Gm-Message-State: ABy/qLZGdO736BBNg+BaLjroj9OX0x4uqDJ2PKd9KzD3QAOXQ73I2drp
        lYDjeF3pO0+nK+ftOlSd7JwwubCrNqcXNoNJLBI=
X-Google-Smtp-Source: APBJJlFBRWh2WAX5A0wrGeDAK0bKbK7lW1PbwetOJbWbd2dZ3KfleWVR7uFqVDzsdxEHmIKQzzub0e72Wr0kChs3SVQ=
X-Received: by 2002:a2e:b0f0:0:b0:2b6:eceb:9bb with SMTP id
 h16-20020a2eb0f0000000b002b6eceb09bbmr2955093ljl.45.1688721118443; Fri, 07
 Jul 2023 02:11:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230705113227.148494-1-jinpu.wang@ionos.com> <04cc9d64-1683-caac-35ff-9275af6ce508@huaweicloud.com>
 <CAMGffEkQvaR_QqQf8qpb3OiECb1AmFF+0sFbU24zAOpHX6zrNw@mail.gmail.com>
In-Reply-To: <CAMGffEkQvaR_QqQf8qpb3OiECb1AmFF+0sFbU24zAOpHX6zrNw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 7 Jul 2023 17:11:45 +0800
X-Gmail-Original-Message-ID: <CAPhsuW4atoDRk8CwM=86pJAj+yJSAX=JPUuBXXTh7T3p43VobQ@mail.gmail.com>
Message-ID: <CAPhsuW4atoDRk8CwM=86pJAj+yJSAX=JPUuBXXTh7T3p43VobQ@mail.gmail.com>
Subject: Re: [PATCHv3] md/raid1: Avoid lock contention from wake_up()
To:     Jinpu Wang <jinpu.wang@ionos.com>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jul 6, 2023 at 2:29=E2=80=AFPM Jinpu Wang <jinpu.wang@ionos.com> wr=
ote:
>
> On Thu, Jul 6, 2023 at 8:14=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
> >
> > =E5=9C=A8 2023/07/05 19:32, Jack Wang =E5=86=99=E9=81=93:
> > > wake_up is called unconditionally in a few paths such as make_request=
(),
> > > which cause lock contention under high concurrency workload like belo=
w
> > >      raid1_end_write_request
> > >       wake_up
> > >        __wake_up_common_lock
> > >         spin_lock_irqsave
> > >
> > > Improve performance by only call wake_up() if waitqueue is not empty
> > >
> > LGTM
> >
> > Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Kuai,
> Thank you very much for the review and suggestions!
>
> >
> > > Fio test script:
> > >
> > > [global]
> > > name=3Drandom reads and writes
> > > ioengine=3Dlibaio
> > > direct=3D1
> > > readwrite=3Drandrw
> > > rwmixread=3D70
> > > iodepth=3D64
> > > buffered=3D0
> > > filename=3D/dev/md0
> > > size=3D1G
> > > runtime=3D30
> > > time_based
> > > randrepeat=3D0
> > > norandommap
> > > refill_buffers
> > > ramp_time=3D10
> > > bs=3D4k
> > > numjobs=3D400
> > > group_reporting=3D1
> > > [job1]
> > >
> > > Test result with 2 ramdisk in raid1 on a Intel Broadwell 56 cores ser=
ver.
> > >
> > >       Before this patch       With this patch
> > >       READ    BW=3D4621MB/s     BW=3D7337MB/s
> > >       WRITE   BW=3D1980MB/s     BW=3D3144MB/s
> > >
> > > The patch is inspired by Yu Kuai's change for raid10:
> > > https://lore.kernel.org/r/20230621105728.1268542-1-yukuai1@huaweiclou=
d.com
> > >
> > > Cc: Yu Kuai <yukuai3@huawei.com>
> > > Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> > > ---

Applied to md-next. Thanks!

Song
