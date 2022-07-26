Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A5DDC00140
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jul 2022 17:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbiGZRRx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jul 2022 13:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiGZRRw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Jul 2022 13:17:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340521A051
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 10:17:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C03346023A
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 17:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22269C433B5
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 17:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658855870;
        bh=OVicrscScgV8xhCMfWtDE2Yn+T7e7oudmNZmBDqoRzE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VLLm7RnD/b+EYrvAdXT+jqHmHDbfiq5VKz2v7RUrQ4J1AA0K2Y88XqPF4oJozVA8J
         X/ks/IRlf53TFK9dcmmHP5yLGjB4P9rcMfjEG8ezP4VWLD07FXVRwI28KeGVfPQ/7k
         Tjbr+KKzaAWCzQXE91lM87c+66U9nLnKap5HUI3MTynis+zeajWiSm5UnDLq4xeJoj
         2YlzrD0gSnws3ohp1nAOmkYEVh/SrmUU3XRcFhfODh0BIppqYnG9IZY5NIN3qjtaBs
         cdNnDVVJpDiglCY4YPsvy8Sbt+ZaWCKv/Gi4e1UetmG5vgY6xoDM+T2n+pqwZEp9Lh
         bb3yZZEsou2xQ==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-31bf3656517so149814657b3.12
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 10:17:50 -0700 (PDT)
X-Gm-Message-State: AJIora82cZu3z8ODQNUt5WF4iofmA+jkBcAsInqJaHgXrAgXoqdYOmgB
        tDHCrbKZpfUoKstotMgj1GWKcD8YSnXF8i7cMk4=
X-Google-Smtp-Source: AGRyM1tvcUlxnozMqZOj2M+UgLLOpqSSYlQodtOmXRqnAOpIxmErwdXG6C5nMf6SxU6afKxpAYE0SM4ylD+JLCWhYHA=
X-Received: by 2002:a0d:f746:0:b0:31e:80dc:725f with SMTP id
 h67-20020a0df746000000b0031e80dc725fmr15917780ywf.460.1658855869156; Tue, 26
 Jul 2022 10:17:49 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2207241426320.26078@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPhsuW7-NtUDEqBCSnjQPW+Z8bcgMkaK6BsWUN4_fuULcpoCiw@mail.gmail.com> <alpine.LRH.2.02.2207260431020.32515@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2207260431020.32515@file01.intranet.prod.int.rdu2.redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 26 Jul 2022 10:17:38 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7rvXnOWz3YwtuD_Scj89RE=T4Ktb-xJ3v=fU_asbNy1g@mail.gmail.com>
Message-ID: <CAPhsuW7rvXnOWz3YwtuD_Scj89RE=T4Ktb-xJ3v=fU_asbNy1g@mail.gmail.com>
Subject: Re: [PATCH] md-raid10: fix KASAN warning
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jul 26, 2022 at 1:33 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> There's a KASAN warning in raid10_remove_disk when running the lvm
> test lvconvert-raid-reshape.sh. We fix this warning by verifying that the
> value "number" is valid.
>

[...]

>  ffff889108f3d380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff889108f3d400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

Applied to md-next. Thanks!
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
