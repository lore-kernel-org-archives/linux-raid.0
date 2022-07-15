Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 006A8C43334
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jul 2022 21:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiGOViA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jul 2022 17:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiGOVh6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 15 Jul 2022 17:37:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CFD87205
        for <linux-raid@vger.kernel.org>; Fri, 15 Jul 2022 14:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A57C8B82D13
        for <linux-raid@vger.kernel.org>; Fri, 15 Jul 2022 21:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EA5C34115
        for <linux-raid@vger.kernel.org>; Fri, 15 Jul 2022 21:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657921075;
        bh=05YXL3tztz9EqjODt7KBTZL42/H34wrLV2+Xv/GqCEo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bFYp3WmgprhnCOMxV51fovqvC8Uvj90s4kNfdGxV9ic5xb7xiY8V6c7u6nYtZqRO7
         pzFVEhRPQyqLa29yzcl3t1yqooD4qegn+Cm19aPl3fXD3Mx9lnL7aJPYcPaWNL5ixP
         GhfJGtNadEcw9/REiOjtZ1rUugmTOktXsIqDV9Bk3vmS1OK6GcWpRbG2dFdyFug2BJ
         WRzbtPumaEvtJUZfieCLDyIphl/kr73uiOCsgtkS+STWAKRw7IcjnVjxZQpFmzAWeh
         3bDKqCkyoGkjsW1Gu4Dyy22hD2kyzBqeIQnubtDVlKD3cwOtfZ9n2oeAjNEUwjpfL4
         xoWekcTh9bBlw==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-31dfe25bd49so21558777b3.2
        for <linux-raid@vger.kernel.org>; Fri, 15 Jul 2022 14:37:55 -0700 (PDT)
X-Gm-Message-State: AJIora+giD3Vrpv0SLn3n8vJZlidEsa1DeNTuA6X0HcI9vgis6rQ9FWk
        lLbv3XFSBxo7jCzLzBJ3gIKXZCApwd5ZkfX20C4=
X-Google-Smtp-Source: AGRyM1t5LZQXWmNrCfVKAC4dTNTbMmhfvCYMiB/6K136ws069YwJ1rb6+FQhLzjsBsQi+HPU3FTOKomqW6N4hvyoLkY=
X-Received: by 2002:a81:8004:0:b0:318:7e2d:5bd5 with SMTP id
 q4-20020a818004000000b003187e2d5bd5mr18375866ywf.211.1657921074452; Fri, 15
 Jul 2022 14:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220707090834.1881470-1-liu.yun@linux.dev>
In-Reply-To: <20220707090834.1881470-1-liu.yun@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Fri, 15 Jul 2022 14:37:43 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5VzKNQrmZDhnVz9Fyn2=JvdeaffSOCodAmVMcVM+fFCg@mail.gmail.com>
Message-ID: <CAPhsuW5VzKNQrmZDhnVz9Fyn2=JvdeaffSOCodAmVMcVM+fFCg@mail.gmail.com>
Subject: Re: [PATCH] raid5: fix duplicate checks for rdev->saved_raid_disk
To:     Jackie Liu <liu.yun@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jul 7, 2022 at 2:09 AM Jackie Liu <liu.yun@linux.dev> wrote:
>
> From: Jackie Liu <liuyun01@kylinos.cn>
>
> 'first' will always be greater than or equal to 0, it is unnecessary to
> repeat the 0 check, clean it up.
>
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>

For some reason, the patch won't apply. Could you please resend?

Thanks,
Song

> ---
>  drivers/md/raid5.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 20e53b167f81..a0b38a0ea9c3 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8063,8 +8063,7 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
>          * find the disk ... but prefer rdev->saved_raid_disk
>          * if possible.
>          */
> -       if (rdev->saved_raid_disk >= 0 &&
> -           rdev->saved_raid_disk >= first &&
> +       if (rdev->saved_raid_disk >= first &&
>             rdev->saved_raid_disk <= last &&
>             conf->disks[rdev->saved_raid_disk].rdev == NULL)
>                 first = rdev->saved_raid_disk;
> --
> 2.25.1
>
