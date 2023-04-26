Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39AFC77B73
	for <linux-raid@archiver.kernel.org>; Wed, 26 Apr 2023 03:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239318AbjDZDo3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Apr 2023 23:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239221AbjDZDo2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 Apr 2023 23:44:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3453810C2
        for <linux-raid@vger.kernel.org>; Tue, 25 Apr 2023 20:44:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7E5862019
        for <linux-raid@vger.kernel.org>; Wed, 26 Apr 2023 03:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28389C4339C
        for <linux-raid@vger.kernel.org>; Wed, 26 Apr 2023 03:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682480666;
        bh=P+bnnOW55nizjKJ76UHtNyrAfTPyDwe4VzShi7tnEO8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=I7wjTVpALdxXSki8kDqUFFWD2sQyQMT0VrD717buGMfTEXLubAo4hrZ9VSrDOOOoq
         zPUboxXy9P43frZ5HpP1+SPh4987BT+NVnnQTj09f5DR3O/+tEnST43ijkpQYrKu0U
         fAfYDrHqVgwjXTYhFbIdpV/BIVeI9BMqrgvSKT9jXO/Edi/EDJeEjy76bWhBehR4aT
         l4rBnarzKjb0gkwpz+/4+wA+RiOn1XNFlooLbL4D922D/KKiUbtwLBjk+FQW/wJzq5
         E9k/kCYbnfWm8ZtiJHdRYWF1jmMLiWAfPFOUmIT+cKUDIvL0X1aJkycrYmetJ5pXvE
         TNlnEjn6KdE/g==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2a8aea2a654so64151821fa.1
        for <linux-raid@vger.kernel.org>; Tue, 25 Apr 2023 20:44:26 -0700 (PDT)
X-Gm-Message-State: AAQBX9fYy1RDO/UQibqGstVAKT7Z7sVSj0yzpJKJJxayqnMekedjiTMP
        ZWGG1nAOqNRpUDUj1FVPaQcHp8srytR6SWSs+X8=
X-Google-Smtp-Source: AKy350b+QBZROkfz1BrHMlvVHV6QTu6yhQF3KYAD3S00INLWuumRYIa8YEOWbnrcDGY4ucKQS4s8fwwZssRuiTCNSg8=
X-Received: by 2002:a2e:7c0e:0:b0:2a7:acb7:cabc with SMTP id
 x14-20020a2e7c0e000000b002a7acb7cabcmr4021919ljc.40.1682480664181; Tue, 25
 Apr 2023 20:44:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230425011438.71046-1-jonathan.derrick@linux.dev>
In-Reply-To: <20230425011438.71046-1-jonathan.derrick@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Tue, 25 Apr 2023 20:44:12 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6f+6nqqaap1pP_rETSk_WA68keq6wCxEJojkYcVw-Vhw@mail.gmail.com>
Message-ID: <CAPhsuW6f+6nqqaap1pP_rETSk_WA68keq6wCxEJojkYcVw-Vhw@mail.gmail.com>
Subject: Re: [PATCH] md: Fix bitmap offset type in sb writer
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     linux-raid@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Apr 24, 2023 at 6:16=E2=80=AFPM Jonathan Derrick
<jonathan.derrick@linux.dev> wrote:
>
> Bitmap offset is allowed to be negative, indicating that bitmap precedes
> metadata. Change the type back from sector_t to loff_t to satisfy
> conditionals and calculations.
>
> Signed-off-by: Jonathan Derrick <jonathan.derrick@linux.dev>

I added the following to the patch and applied it to md-next.

Thanks,
Song

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 10172f200b67 ("md: Fix types in sb writer")

> ---
>  drivers/md/md-bitmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 920bb68156d2..29ae7f7015e4 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -237,8 +237,8 @@ static int __write_sb_page(struct md_rdev *rdev, stru=
ct bitmap *bitmap,
>         struct block_device *bdev;
>         struct mddev *mddev =3D bitmap->mddev;
>         struct bitmap_storage *store =3D &bitmap->storage;
> -       sector_t offset =3D mddev->bitmap_info.offset;
> -       sector_t ps, sboff, doff;
> +       loff_t sboff, offset =3D mddev->bitmap_info.offset;
> +       sector_t ps, doff;
>         unsigned int size =3D PAGE_SIZE;
>         unsigned int opt_size =3D PAGE_SIZE;
>
> --
> 2.40.0
>
