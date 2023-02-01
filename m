Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE3A9C05027
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 07:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjBAHHm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 02:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjBAHHg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 02:07:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DD883C9
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 23:07:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B92706134A
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 07:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24718C4339E
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 07:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675235255;
        bh=ExAQ1X41eVfZ2T9UL1KKoeYDJr4JVP2Yjz3iwoDKPKI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DEAi432OlVvPq46A7qYRsPkGws15clCuBDgcl78s9hJ32izZvtBhqNgTFcerLCL1z
         mHuL76kZGY9N1vBMAxIP3QIrjmI4tPDlIYh8qAmEaDiJ7dXBQgWg1lWRMURR9MmZQD
         grMY4rSXVpk4DNmGcdg8Jbtz9XK+a6Bh5LsI6BsPxwqhCGrzB41yHckdPelV7tpl1U
         k4h2MPHgMmjKeP7gL+AWcZlu3cNsFNbweBbpFXHt2MTNiwXX9z269/u3nqu0Vn+pbI
         C+RSVSkXfSN/ft0Wtxlhe9zpaCtaHRukLQ2L9ouj1GYUwHEdyQN241RogiYglSCp6f
         GiY1p+L0+tSNw==
Received: by mail-lj1-f174.google.com with SMTP id bf19so3928214ljb.6
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 23:07:35 -0800 (PST)
X-Gm-Message-State: AO0yUKVYMxICxbxb2eA+NTLs/k9vUVbB3pESUb5WBNf+1UcisOT6D0xC
        /kYn7k7QsTvnz/cglMaznMZIUCC1YaHWCrRxsk8=
X-Google-Smtp-Source: AK7set8FJ2p7nVVLmIH0M4J5+UQCgzTgOCdeINai/0EbVJ21FQTwLLgnz4O8jpAw0AFCuZUOqtAsGLoh0DfSAEE0Ns0=
X-Received: by 2002:a2e:87d0:0:b0:290:70d1:7157 with SMTP id
 v16-20020a2e87d0000000b0029070d17157mr144814ljj.172.1675235253211; Tue, 31
 Jan 2023 23:07:33 -0800 (PST)
MIME-Version: 1.0
References: <20230131070719.1702279-1-houtao@huaweicloud.com> <265fb203-c8d1-f391-c32e-0bd447b5080d@deltatee.com>
In-Reply-To: <265fb203-c8d1-f391-c32e-0bd447b5080d@deltatee.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 31 Jan 2023 23:07:21 -0800
X-Gmail-Original-Message-ID: <CAPhsuW68d8zaF6zH5+As5k3WyY2-qt49+WrLJKv8PuqfVfNbcQ@mail.gmail.com>
Message-ID: <CAPhsuW68d8zaF6zH5+As5k3WyY2-qt49+WrLJKv8PuqfVfNbcQ@mail.gmail.com>
Subject: Re: [PATCH] md: don't update recovery_cp when curr_resync is ACTIVE
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Hou Tao <houtao@huaweicloud.com>, linux-raid@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, houtao1@huawei.com,
        linan122@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jan 31, 2023 at 9:06 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
>
> On 2023-01-31 12:07 a.m., Hou Tao wrote:
> > From: Hou Tao <houtao1@huawei.com>
> >
> > Don't update recovery_cp when curr_resync is MD_RESYNC_ACTIVE, otherwise
> > md may skip the resync of the first 3 sectors if the resync procedure is
> > interrupted before the first calling of ->sync_request() as shown below:
> >
> > md_do_sync thread          control thread
> >   // setup resync
> >   mddev->recovery_cp = 0
> >   j = 0
> >   mddev->curr_resync = MD_RESYNC_ACTIVE
> >
> >                              // e.g., set array as idle
> >                              set_bit(MD_RECOVERY_INTR, &&mddev_recovery)
> >   // resync loop
> >   // check INTR before calling sync_request
> >   !test_bit(MD_RECOVERY_INTR, &mddev->recovery
> >
> >   // resync interrupted
> >   // update recovery_cp from 0 to 3
> >   // the resync of three 3 sectors will be skipped
> >   mddev->recovery_cp = 3
> >
> > Fixes: eac58d08d493 ("md: Use enum for overloaded magic numbers used by mddev->curr_resync")
> > Signed-off-by: Hou Tao <houtao1@huawei.com>
>
> Nice Catch! Thanks.
>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Applied to md-next. Thanks!

Song
