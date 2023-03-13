Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1CFC61DA4
	for <linux-raid@archiver.kernel.org>; Mon, 13 Mar 2023 20:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCMU00 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Mar 2023 16:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCMU0Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Mar 2023 16:26:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDE9898F0
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 13:26:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8500D614AC
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 20:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E163EC433EF
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 20:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678739180;
        bh=CChvX4srwvz9SOzvuxaHpE51RKp2mlTbHVuGFE8OUs0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=V6k3M6vt9chUX5lwfSJhuWYBiUPGPZn2KLw+AI/glzpX93xf0n2gX3fM/78JbqiC7
         8/PKGKns8ITUwQ9e1UMZPPQ08F1mKxj9RJ62wsXG7bOSgkFKe8RoCOYFsK8PdHwNdR
         ZpD3i4oT/aCaMvOyRLuKUTY/VE8mZOAg9tvVDCSZTTXYTno+bo5McogM8YXWA3xBX1
         7d9V0yOgTL3WTYvd8pzcE8V9KZYFkXfZuLzIRxJp39zYhWQQTFlqGGfcCIOkunOU58
         K9gZvKx8ZrC/+hii3EYaY1SW3uc74o3D3HZZ5KGOHmX3IW4GN7mU/fOEMctHPEQZz5
         I5RfJzioktOrw==
Received: by mail-lf1-f44.google.com with SMTP id bp27so7007367lfb.6
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 13:26:20 -0700 (PDT)
X-Gm-Message-State: AO0yUKWdz3TbvTVE+Df6WR9oQpyOzFIB39s7R32VhGNnVvKxApYbg/nm
        OD7mgb+GlHcPYrbcB0HxPH+/qRWP+R4PTV0aoMo=
X-Google-Smtp-Source: AK7set8t5bZewnVmueC4ZYDMXq322Y71ytRkscf5juGm7ZoAXqQ5pfORoD710Q3YIM4vzyzH6BQYq1izrhuZhtDK2sM=
X-Received: by 2002:ac2:5ece:0:b0:4dd:a74d:aca3 with SMTP id
 d14-20020ac25ece000000b004dda74daca3mr11218933lfq.3.1678739178947; Mon, 13
 Mar 2023 13:26:18 -0700 (PDT)
MIME-Version: 1.0
References: <167805578596.8008.14753053536858832084@noble.neil.brown.name>
In-Reply-To: <167805578596.8008.14753053536858832084@noble.neil.brown.name>
From:   Song Liu <song@kernel.org>
Date:   Mon, 13 Mar 2023 13:26:06 -0700
X-Gmail-Original-Message-ID: <CAPhsuW71w8eWhB4+C+QS=2GU2oZV8sS464PTvFhnrqORqftQGg@mail.gmail.com>
Message-ID: <CAPhsuW71w8eWhB4+C+QS=2GU2oZV8sS464PTvFhnrqORqftQGg@mail.gmail.com>
Subject: Re: [PATCH] md: avoid signed overflow in slot_store()
To:     NeilBrown <neilb@suse.de>
Cc:     Dan Carpenter <error27@gmail.com>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Mar 5, 2023 at 2:36=E2=80=AFPM NeilBrown <neilb@suse.de> wrote:
>
>
> slot_store() uses kstrtouint() to get a slot number, but stores the
> result in an "int" variable (by casting a pointer).
> This can result in a negative slot number if the unsigned int value is
> very large.
>
> A negative number means that the slot is empty, but setting a negative
> slot number this way will not remove the device from the array.  I don't
> think this is a serious problem, but it could cause confusion and it is
> best to fix it.
>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: NeilBrown <neilb@suse.de>

Applied to md-fixes. Thanks!

Song

> ---
>  drivers/md/md.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 02b0240e7c71..d4bfa35fb20a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3131,6 +3131,9 @@ slot_store(struct md_rdev *rdev, const char *buf, s=
ize_t len)
>                 err =3D kstrtouint(buf, 10, (unsigned int *)&slot);
>                 if (err < 0)
>                         return err;
> +               if (slot < 0)
> +                       /* overflow */
> +                       return -ENOSPC;
>         }
>         if (rdev->mddev->pers && slot =3D=3D -1) {
>                 /* Setting 'slot' on an active array requires also
> --
> 2.39.2
>
