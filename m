Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEFDC433EF
	for <linux-raid@archiver.kernel.org>; Sun, 17 Jul 2022 05:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiGQFb6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Jul 2022 01:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiGQFb5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 17 Jul 2022 01:31:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3E922B2E
        for <linux-raid@vger.kernel.org>; Sat, 16 Jul 2022 22:31:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B7B160FAF
        for <linux-raid@vger.kernel.org>; Sun, 17 Jul 2022 05:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D47C341CD
        for <linux-raid@vger.kernel.org>; Sun, 17 Jul 2022 05:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658035915;
        bh=KkdGrdwp5Q/M2TBioRiz7Y7An71RrKUQiUzWHuOxGAw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WqSNQl+z6m3hMpZk3e3BUALi/KrtxLPIizKzzjRsKcTxJqJUSPllpaGdkCYAQNcWt
         x9DOC0A+px7hxP46t30I1xatHzTthU34n6CeCRaWPAbYtQiqL+hQTI35TOi7huKeih
         ubT6kCQEkiXIGJ2b6FOejnSsTGyjiJKh+idquAQ19vxeYfo2wJetofe5f2wu5ZbyUs
         yk1SyUV8K1cerIDfG3BVGdUyH/gsJyk1rjKqY0LfORXapGhHJTYI8kdduJ5+xbCNKo
         Gq0amF3KdXQ9PBu9125OhriYlkC5JXmA1aRK+NHoizOXLmzTp3mzGqmkri4LfUk5Wl
         pMfsUFJVbDTFA==
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-31c86fe1dddso80785957b3.1
        for <linux-raid@vger.kernel.org>; Sat, 16 Jul 2022 22:31:55 -0700 (PDT)
X-Gm-Message-State: AJIora/4cLDgMIW46bwtXIiGPfptMw/6vWLcghsd49Sn5T5RfWwRberb
        +8ikRmQlfuHknrnF2hH2TmP5uMpShJ/A40iBIHQ=
X-Google-Smtp-Source: AGRyM1vRNnlH+ColX0ydVPFOeWZf5e9MKuzdMdzdQ2ufjwVUUOSArAnjtLIDxY8ZehWDk53N4u0iTXFobDEYQG5tY2g=
X-Received: by 2002:a0d:d285:0:b0:31e:1eca:6996 with SMTP id
 u127-20020a0dd285000000b0031e1eca6996mr1092750ywd.211.1658035914984; Sat, 16
 Jul 2022 22:31:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220716031136.1426264-1-liu.yun@linux.dev>
In-Reply-To: <20220716031136.1426264-1-liu.yun@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Sat, 16 Jul 2022 22:31:44 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7O2V1D4OT7xJKnjeQVVd8=oKLsxq7K4mXJGR31MN03Lw@mail.gmail.com>
Message-ID: <CAPhsuW7O2V1D4OT7xJKnjeQVVd8=oKLsxq7K4mXJGR31MN03Lw@mail.gmail.com>
Subject: Re: [PATCH RESEND] raid5: fix duplicate checks for rdev->saved_raid_disk
To:     Jackie Liu <liu.yun@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Jul 15, 2022 at 8:11 PM Jackie Liu <liu.yun@linux.dev> wrote:
>
> From: Jackie Liu <liuyun01@kylinos.cn>
>
> 'first' will always be greater than or equal to 0, it is unnecessary to
> repeat the 0 check, clean it up.
>
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>

This looks identical to the original version. Which branch is this based on?
Please rebase on top of md-next branch and resend the patch:

https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/log/?h=md-next

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
