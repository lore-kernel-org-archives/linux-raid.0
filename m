Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50461C7EE23
	for <linux-raid@archiver.kernel.org>; Fri, 19 May 2023 22:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbjESWIy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 19 May 2023 18:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjESWIx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 19 May 2023 18:08:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80E6124;
        Fri, 19 May 2023 15:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 495D865B54;
        Fri, 19 May 2023 22:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2998C433EF;
        Fri, 19 May 2023 22:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684534131;
        bh=A862GEbtFBEgeb5HWFNn49oFai0Kv8zFpjOdOO5uVr8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jQDPPo10njg0MuoDZXS7ZW9p99kR4BgmYagm2KgH/+O9zJrjpnTF/VvqSDdzJhvkv
         mQxbzU4Xc/jckpyRxpicecttFMK6mOM6H+olovTVrwhR7QANozdc/MuUGfaOxZqKem
         8Y/HUDJxaJfR1sEMzDL0lQW3EY2e+90WIXirUwoRDPwHCfQD842TWxOQ+BKoK34dYL
         NWP24JGwNwRScsEUJGrs/nJmSCj4fR5pyK3hGKkOuD2Vo6GVXZRjdiGgAcrO0cTsY7
         JrrrGgHgzWkbDK8R4v91ateC71gjwQwBCtSCN6kgSyo7RhsS6O4m98p5WInHsCgcGV
         6SHz61RBMISAQ==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2af290cf9b7so9125991fa.3;
        Fri, 19 May 2023 15:08:51 -0700 (PDT)
X-Gm-Message-State: AC+VfDyrGAYG/deV3N6Loi32/l+vh1asOx/2/ojV0cWt3tl4O5sUUkTh
        pm2K2ztRjRFOjT9DHU/tLYyG38D1rzwmfQYdbDs=
X-Google-Smtp-Source: ACHHUZ5+SDjgOAbfgBoDywViw0xTfhfRuUsUgx4RdMJjHNDfUxirps8DEQnixHNvfDms4sbCmrlgqpHnvcStbQ4cPNc=
X-Received: by 2002:ac2:485c:0:b0:4f2:40dd:e2cf with SMTP id
 28-20020ac2485c000000b004f240dde2cfmr1142411lfy.55.1684534129761; Fri, 19 May
 2023 15:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230515134808.3936750-1-linan666@huaweicloud.com> <CAPhsuW7m5hFY2L=2_FA-Qq3Yxr0a4r_QHdXSeZQ8kLgXMvj1sA@mail.gmail.com>
In-Reply-To: <CAPhsuW7m5hFY2L=2_FA-Qq3Yxr0a4r_QHdXSeZQ8kLgXMvj1sA@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 19 May 2023 15:08:37 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7xWOcX8jOpyzTV2hVFj8XXwH0frgYx9r8xD6VNndPDng@mail.gmail.com>
Message-ID: <CAPhsuW7xWOcX8jOpyzTV2hVFj8XXwH0frgYx9r8xD6VNndPDng@mail.gmail.com>
Subject: Re: [PATCH OLK-5.10 v3 0/4] md: bugfix of writing raid sysfs
To:     linan666@huaweicloud.com
Cc:     neilb@suse.de, Rob.Becker@riverbed.com, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linan122@huawei.com,
        yukuai3@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com,
        yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Btw, what does "OLK-5.10" mean?

Song


On Fri, May 19, 2023 at 3:07=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> On Mon, May 15, 2023 at 6:49=E2=80=AFAM <linan666@huaweicloud.com> wrote:
> >
> > From: Li Nan <linan122@huawei.com>
> >
> > The patch series fix the bug of writing raid sysfs.
> >
> > Changes in v2:
> >  - in patch 1, move check out of md_bitmap_checkpage().
> >  - in patch 2, use div64_u64() and DIV64_U64_ROUND_UP() instead of dire=
ctly
> >    '/', and chang old_delay/old_delay to unsigned int.
> >  - in patch 4, use 'goto' to make changes more readable.
> >
> > Changes in v2:
> >  - add patch "md/raid10: optimize check_decay_read_errors()".
> >  - in patch 2, return ret-value of strict_strtoul_scaled if error occur=
s.
> >  - in patch 3, optimize format.
> >
> > Li Nan (4):
> >   md/raid10: fix slab-out-of-bounds in md_bitmap_get_counter
> >   md/raid10: fix overflow in safe_delay_store
> >   md/raid10: fix wrong setting of max_corr_read_errors
> >   md/raid10: optimize check_decay_read_errors()
>
> I applied 1/4 to md-next.
>
> Thanks,
> Song
