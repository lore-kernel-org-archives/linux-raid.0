Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298EFC43334
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jul 2022 05:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbiGZFWZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jul 2022 01:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiGZFWY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Jul 2022 01:22:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B602813D4C
        for <linux-raid@vger.kernel.org>; Mon, 25 Jul 2022 22:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C4D7611F4
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 05:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F55C341C8
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 05:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658812942;
        bh=Is7Z/1go8YFFHKdEdXzRC+BPx6Mo5+MM2962f+3cmgE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WV3uGw7kn+KPgb2xsk6i2WCx4fsmgIAJz/lmc2MSomZXRh8OxBklGQ8Pf/ylbI2/M
         cn4iVufDJhoRrdo7zadpQSWNwLijEGjc2bv1Zf4oYo2dhRKAjKLmsTkFPU8uXz9xE7
         SXSDDVqpC+p8X63Y4gFAyvuAaXFeZZPjLw37j2a8M8dPTaVqBDxPrIZRv+IAFSIjuI
         VnRAARmjdQdp4KjkfYhEPCZf7VaELFgkFvm+aKSK1k1sMhx1WMY6snvp8v4UGoLycu
         U7WKFgliHBaE18sMhSVB1RTCSBhF/hX3VTfYUbUXXWUgqh4UWXqefxEYgo0FKqWfuB
         c0aTW21CKkOfQ==
Received: by mail-yb1-f175.google.com with SMTP id 123so803635ybv.7
        for <linux-raid@vger.kernel.org>; Mon, 25 Jul 2022 22:22:22 -0700 (PDT)
X-Gm-Message-State: AJIora/LtVAWDhNTv21mpUIgpUeVHGHkAlGFcK/qWtOjvv9kNlxHRcjc
        fAGtZyCH9HDhlYVYdk9Yv1Mbj8XOnvSR+MBD+Ms=
X-Google-Smtp-Source: AGRyM1vw5fldwq2G/6uN+ULfhs7C1fYN7F9NNcOeNwrpMD1x3IjGBRySS6pB0btKWfMQjZS0w4gXEZ15sDhuEQCCW7k=
X-Received: by 2002:a25:8611:0:b0:66e:d9e7:debc with SMTP id
 y17-20020a258611000000b0066ed9e7debcmr12121888ybk.257.1658812941844; Mon, 25
 Jul 2022 22:22:21 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2207241426320.26078@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2207241426320.26078@file01.intranet.prod.int.rdu2.redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 25 Jul 2022 22:22:11 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7-NtUDEqBCSnjQPW+Z8bcgMkaK6BsWUN4_fuULcpoCiw@mail.gmail.com>
Message-ID: <CAPhsuW7-NtUDEqBCSnjQPW+Z8bcgMkaK6BsWUN4_fuULcpoCiw@mail.gmail.com>
Subject: Re: [PATCH] md-raid10: fix KASAN warning
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Jul 24, 2022 at 11:29 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> There's a KASAN warning in raid10_remove_disk when running the lvm
> test lvconvert-raid-reshape.sh. We fix this warning by verifying that the
> value "number" is valid.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

Could you please add the KASAN message to the commit log?

Thanks,
Song

>
> ---
>  drivers/md/raid10.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/md/raid10.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/raid10.c  2022-07-13 19:05:50.000000000 +0200
> +++ linux-2.6/drivers/md/raid10.c       2022-07-13 19:07:05.000000000 +0200
> @@ -2167,9 +2167,12 @@ static int raid10_remove_disk(struct mdd
>         int err = 0;
>         int number = rdev->raid_disk;
>         struct md_rdev **rdevp;
> -       struct raid10_info *p = conf->mirrors + number;
> +       struct raid10_info *p;
>
>         print_conf(conf);
> +       if (unlikely(number >= mddev->raid_disks))
> +               return 0;
> +       p = conf->mirrors + number;
>         if (rdev == p->rdev)
>                 rdevp = &p->rdev;
>         else if (rdev == p->replacement)
>
