Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FBEEB64D9
	for <linux-raid@archiver.kernel.org>; Fri,  7 Jul 2023 09:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjGGJOs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 7 Jul 2023 05:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjGGJOr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 7 Jul 2023 05:14:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5051FEE;
        Fri,  7 Jul 2023 02:14:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B0FB618DF;
        Fri,  7 Jul 2023 09:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A19C433C7;
        Fri,  7 Jul 2023 09:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688721285;
        bh=SdCOHuQIsLwUhQIbQXHpaBfiscHFrrPvQbbyukePFho=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SXJysg56Roav9v9nesRcao4+t18D/MoETA0BJqm5656eYe7NdretxAdebiI+sqSfC
         pBZUxQBF0Q4Z2AUKxkJ9xvJ1x2aS4RFN00L1PJdqooiQnuU2GJaCMbrdC1mQlW/mk4
         zaF9IxLlQsrUNV7Z3gniI4N/gws+fPIiWkBxqe+CIjj7EoitRcKDot12scaAkGxkhX
         3ivctb5o+ut0N0xnIHeR8C1pyKb5ZU+hLMV58wuvNxY5hyuOh3MJeCsB716jalf78v
         x/CEQWrhBn9ArxlLrzVshg7YTFsPZNaJ6G17NLPvjAEf6LR2RvD/yv2REGiy5/2ICH
         0cix9My68mWWw==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2b6f943383eso25848461fa.2;
        Fri, 07 Jul 2023 02:14:45 -0700 (PDT)
X-Gm-Message-State: ABy/qLaZydKMZjiF4VEhti2rACHAPY7EcwZ8sjUYJ+XgKB93/VubBE3/
        2t+YjpyNqRlN7baXVcap9BARxFIPN6ZIV+knSW4=
X-Google-Smtp-Source: APBJJlGrChZw35tykuRaSd+JK+g8bPtYdRHSArlRr4iL/9/zPAk7epwByQzmK+WP27erbrMEFv9eKzLBZh/3asQ71G8=
X-Received: by 2002:a2e:9588:0:b0:2b7:a72:103b with SMTP id
 w8-20020a2e9588000000b002b70a72103bmr2074838ljh.53.1688721283907; Fri, 07 Jul
 2023 02:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230701080529.2684932-1-linan666@huaweicloud.com>
In-Reply-To: <20230701080529.2684932-1-linan666@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 7 Jul 2023 17:14:31 +0800
X-Gmail-Original-Message-ID: <CAPhsuW68YFg_gUF7aeeNZ0ZZu6t=64tDg09ORdApt735LK6X0Q@mail.gmail.com>
Message-ID: <CAPhsuW68YFg_gUF7aeeNZ0ZZu6t=64tDg09ORdApt735LK6X0Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] raid10 bugfix
To:     linan666@huaweicloud.com
Cc:     guoqing.jiang@cloud.ionos.com, xni@redhat.com, colyli@suse.de,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        linan122@huawei.com, yukuai3@huawei.com, yi.zhang@huawei.com,
        houtao1@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Jul 1, 2023 at 4:06=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> Changes in v2:
>  - patch 2/3, change function name to dereference_rdev_and_rrdev. Return
>    rdev to reduce output argument.
>
> Li Nan (3):
>   md/raid10: check replacement and rdev to prevent submit the same io
>     twice
>   md/raid10: factor out dereference_rdev_and_rrdev()
>   md/raid10: use dereference_rdev_and_rrdev() to get devices

Applied to md-next. Thanks!
Song

>
>  drivers/md/raid10.c | 42 +++++++++++++++++++++++++-----------------
>  1 file changed, 25 insertions(+), 17 deletions(-)
>
> --
> 2.39.2
>
