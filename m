Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE19C001DB
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 16:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjHNQk7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 12:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbjHNQkp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 12:40:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1696110
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 09:40:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5738A6245D
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 16:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F8AC433C7
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 16:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692031243;
        bh=7lXlZvyb7mvU++r53L2QCqpqtgqDUKTTMGimJ89reH4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=O6YQ9IZ2R8lckOUiF73u8ErROlzEKjJBBPwXfEkbgLz5ELbKre1b4Xyy+tt7fbwSR
         RuhuI7DU0dmUHS0MBT++POFxIlafqL6i8DTMeh5Bq9Z71qVeHgdDvIwCm+LZkhBBGk
         f2BvpMfNc6iffzxMvQ8cgVj3/6yBtps3PDa6GwmQqv7J613R5c8bU7ufHa5d4lWIVF
         MgNcsdTkGvfxzHKBSF3Q1wdajeb/sTIL6gfIj473/mWgBF53wKZzTaoT2fU7uN0aPJ
         3ozZpiiZBeM+DikK5dzyu+1tpCub8sO1jDFoxjqF5IiTIzakhXcjsX/Eqoim6VYLxX
         lenL32n3ytZPw==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2b962535808so68723521fa.0
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 09:40:43 -0700 (PDT)
X-Gm-Message-State: AOJu0YxPnXjPDFXPpv0vC2QI+4vCCIfchaSw/bY6Eea8+YtePKFFZyGy
        stuW/M4bnW1tonKnIC6M232bdjFj6JGMx7QEMVQ=
X-Google-Smtp-Source: AGHT+IEKX7zSsxdJwWQbXEZWmqEBN72oOgntNaB8sIdXzQkvMSo5WmHzu6+IQPxNrt9ucuBcnbh6Zi+F4mmnBohbRiM=
X-Received: by 2002:a2e:890d:0:b0:2b6:a08d:e142 with SMTP id
 d13-20020a2e890d000000b002b6a08de142mr7073346lji.7.1692031241713; Mon, 14 Aug
 2023 09:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230814135356.1113639-1-xueshi.hu@smartx.com>
In-Reply-To: <20230814135356.1113639-1-xueshi.hu@smartx.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 15 Aug 2023 00:40:28 +0800
X-Gmail-Original-Message-ID: <CAPhsuW5pLNtJGQM2R-diAGuFpx7Fu3SGgtAEJzHshykynR_0NA@mail.gmail.com>
Message-ID: <CAPhsuW5pLNtJGQM2R-diAGuFpx7Fu3SGgtAEJzHshykynR_0NA@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] md/raid1: call free_r1bio() before allow_barrier()
To:     Xueshi Hu <xueshi.hu@smartx.com>
Cc:     yukuai3@huawei.com, dan.j.williams@intel.com, neilb@suse.de,
        akpm@linux-foundation.org, neilb@suse.com,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Aug 14, 2023 at 9:54=E2=80=AFPM Xueshi Hu <xueshi.hu@smartx.com> wr=
ote:
>
> Because raid reshape changes the r1conf::raid_disks and the mempool, it
> orders that there's no in-flight r1bio when reshaping. However, the
> current caller of allow_barrier() allows the reshape
> operation to proceed even if the old r1bio requests have not been freed.

Applied v6 to md-next after updating some commit log.

Thanks,
Song

>
> -> v2:
>         - fix the problem one by one instead of calling
>         blk_mq_freeze_queue() as suggested by Yu Kuai
> -> v3:
>         - add freeze_array_totally() to replace freeze_array() instead
>           of gave up in raid1_reshape()
>         - add a missed fix in raid_end_bio_io()
>         - add a small check at the start of raid1_reshape()
> -> v4:
>         - add fix tag and revise the commit message
>         - drop patch 1 as there is an ongoing systematic fix for the bug
>         - drop patch 3 as it's unrelated which will be sent in
>         another patch
> -> v5:
>         - split the patch into three parts, with each individual patch fi=
x
>         one bug.
> -> v6:
>         - drop the fix tag in patch 1.
>
>
> Xueshi Hu (3):
>   md/raid1: call free_r1bio() before allow_barrier()
>   md/raid1: free the r1bio firstly before waiting for blocked rdev
>   md/raid1: keep the barrier held until handle_read_error() finished
>
>  drivers/md/raid1.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> --
> 2.40.1
>
