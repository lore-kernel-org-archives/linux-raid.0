Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93ADEEB64DA
	for <linux-raid@archiver.kernel.org>; Fri,  7 Jul 2023 09:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbjGGJhN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 7 Jul 2023 05:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbjGGJhL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 7 Jul 2023 05:37:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB582105;
        Fri,  7 Jul 2023 02:37:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C445618DF;
        Fri,  7 Jul 2023 09:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6375FC433D9;
        Fri,  7 Jul 2023 09:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688722629;
        bh=LiQDwPwTkBNAq6Qw/pxa2ZzWigHnaTtJLG4PuMYRTg0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lnqBvV0Y4ozrI0ckSNZOieXkU5tXT/O0IgcmbC6SqEPn17zehD74nBDRLuRmzwf7B
         oah8TIlh9bYSwcRN/+V+kBqdOIW6nSnCT3khroTAc2PQzeWrT+6wqsKl7snZn9KlcC
         LdwnvJLlZOLs5FkebVBmiXheGDk3YjbNLLi8fX2vJtDc1dW/510ZMWvc7ZJFV+6T3M
         JkbpHfwMKK+CgH2kPuJIbp82RmX4So+jzK/zIewoPsQugMk+RCyx+Qo8U9BKugjf5u
         wMVYEENf7L1irZ6rFBFNVQXzfuny0qI+YZ8jMtV/oXN1z3y9r0TdJSotWHXCxa6Hta
         V32Qg9tu0w27A==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-4fb8574a3a1so2500756e87.1;
        Fri, 07 Jul 2023 02:37:09 -0700 (PDT)
X-Gm-Message-State: ABy/qLY70ugQF/GoPeb9QhU84K9x3Vw8x3Z57ARWpww81oxnoBZtl/xc
        J38in1aEE7+oYzginvDmKOKB5o/T3JVg399dwNk=
X-Google-Smtp-Source: APBJJlHTmxouDwdCH2EEfJexLiCy9F8BTrk7JONjMu/+VY/8uZTK043qrMe0fyX49ipBmvXdDdeBpoufEemGsjSWHtw=
X-Received: by 2002:a05:6512:3a82:b0:4f9:cd02:4af1 with SMTP id
 q2-20020a0565123a8200b004f9cd024af1mr3851999lfu.34.1688722627389; Fri, 07 Jul
 2023 02:37:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230628010756.70649-1-yukuai1@huaweicloud.com>
 <20230628010756.70649-3-yukuai1@huaweicloud.com> <CAPhsuW500i9LEcSsAchje46b2maKdj4EVaefPtinZfdP+AqELw@mail.gmail.com>
 <e5d746d0-1d42-3d60-450b-2450f24f0915@huaweicloud.com> <4690dfff-ad72-bf83-7feb-75018712eb17@huaweicloud.com>
 <d6a6ec52-3c33-726f-1ce2-40168bfa7e27@huaweicloud.com>
In-Reply-To: <d6a6ec52-3c33-726f-1ce2-40168bfa7e27@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 7 Jul 2023 17:36:54 +0800
X-Gmail-Original-Message-ID: <CAPhsuW5jy=SrWnGVPYQyLJBY3bN7uK1OnXQsh8J_ety=oieZeg@mail.gmail.com>
Message-ID: <CAPhsuW5jy=SrWnGVPYQyLJBY3bN7uK1OnXQsh8J_ety=oieZeg@mail.gmail.com>
Subject: Re: [PATCH -next v2 2/2] md/raid5-cache: fix null-ptr-deref in r5l_reclaim_thread()
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     xni@redhat.com, logang@deltatee.com, hch@lst.de, shli@fb.com,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawwe.com,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Jul 7, 2023 at 5:19=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2023/07/07 17:16, Yu Kuai =E5=86=99=E9=81=93:
> > Perhaps you means this order?
> >
> > r5l_exit_log
> >   flush_work(&log->disable_writeback_work)
> >   conf->log =3D NULL
> >   md_unregister_thread(&log->reclaim_thread)
> >
> > I think this is better indeed.
> Never mind, this is wrong, I got confused...
>
> Please ignore this and take a look at my original fix.

How about

r5l_exit_log
  md_unregister_thread(&log->reclaim_thread)
  conf->log =3D NULL
  flush_work(&log->disable_writeback_work)

?

Thanks,
Song
