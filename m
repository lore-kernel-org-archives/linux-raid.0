Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D800EB64D9
	for <linux-raid@archiver.kernel.org>; Fri,  7 Jul 2023 09:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbjGGJCc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 7 Jul 2023 05:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjGGJCb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 7 Jul 2023 05:02:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49451FEB;
        Fri,  7 Jul 2023 02:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54C00618D6;
        Fri,  7 Jul 2023 09:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEC4C433C9;
        Fri,  7 Jul 2023 09:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688720549;
        bh=GcjyvAqlB1nFoHnR6u7qvh6E/8eckipjnRXnkOO5UR0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pdfLlMHxyuZ1crlZqegbrRJAtjkB+goX1CQhW+JSm8mTCi/s9y2I9j1RT/5TJnOsc
         iD6lCXkyG6ujjZxy/8QeNRcuxPfx4pSaaueK/0k7+4GjKZ2wR7ucmpDyO7w5tOo4md
         7vKDfAZl2gajDZgoLAaAEQTB47wIFwN/QcXyVqJUL65oFKEA+fjKdfIR9FGqiPBv0d
         XhV83XLPIEG5XQ/UAn8QPT6vYMvhwXsqVIAV+14tFHtaivO4HN5cXNDLccdDsfmTDF
         xsTOeg/iJzB/a6rUTVsgogX0BwjC2qo7THplO/k1VctSRxW3mvT3U9/QDRF5v057gx
         A1xREGdmm8LdA==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-4f95bf5c493so2420404e87.3;
        Fri, 07 Jul 2023 02:02:29 -0700 (PDT)
X-Gm-Message-State: ABy/qLZ62p4Lwzmo34r7b8WBcfrldWp6J/Vgd5+Hl4ZFsSxPPSii3LIK
        9pBwhU1WdAtyR5y1x9u46OpCSEfGTvlpjKjuHY8=
X-Google-Smtp-Source: APBJJlHOVAjiNT1y+X5iuKR9dT0pGLklPJ2XlvR7B0rPRmIjdUb7Hnc5heIbdMQCiSDZavgDwG14LS2pWv2jx70ok7c=
X-Received: by 2002:a05:6512:3253:b0:4fa:5e76:7ad4 with SMTP id
 c19-20020a056512325300b004fa5e767ad4mr3150740lfr.10.1688720547581; Fri, 07
 Jul 2023 02:02:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230628012931.88911-1-yukuai1@huaweicloud.com> <a2bf6819-224f-4b2d-89c9-67528469b03f@huaweicloud.com>
In-Reply-To: <a2bf6819-224f-4b2d-89c9-67528469b03f@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 7 Jul 2023 17:02:15 +0800
X-Gmail-Original-Message-ID: <CAPhsuW7j4TcVDRSqsj2XMOLHv_suvP5vUZG5c9Jh8W3XVi=nkA@mail.gmail.com>
Message-ID: <CAPhsuW7j4TcVDRSqsj2XMOLHv_suvP5vUZG5c9Jh8W3XVi=nkA@mail.gmail.com>
Subject: Re: [PATCH -next 0/2] md: clean up and fix for mddev_suspend()
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     xni@redhat.com, colyli@suse.de, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Jul 7, 2023 at 9:25=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2023/06/28 9:29, Yu Kuai =E5=86=99=E9=81=93:
> > From: Yu Kuai <yukuai3@huawei.com>
> >
> > This patchset is minor changes that I found by code review while I'm
> > working on synchronize io and array configuration. I'm planing to
> > refactor mddev_suspend() from:
> >
> > mddev_lock
> > // array configuration
> > mddev_unlock
> >
> > and:
> >
> > mddev_lock
> > mddev_suspend
> > // array configuration
> > mddev_resume
> > mddev_unlock
> >
> > to:
> >
> > mddev_suspend
> > mddev_lock
> > // array configuration
> > mddev_unlock
> > mddev_resume
> >
>
> Friendly ping ...

Applied to md-next. Thanks!

Song
