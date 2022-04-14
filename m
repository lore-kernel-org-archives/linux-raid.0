Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05B2C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 14 Apr 2022 19:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbiDNTEm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Apr 2022 15:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244730AbiDNTEl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Apr 2022 15:04:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F51EA345
        for <linux-raid@vger.kernel.org>; Thu, 14 Apr 2022 12:02:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E44461BFD
        for <linux-raid@vger.kernel.org>; Thu, 14 Apr 2022 19:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF89C385A1
        for <linux-raid@vger.kernel.org>; Thu, 14 Apr 2022 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649962934;
        bh=JbM1O4llxqIXw06CMwvK5P/+TFyNAdXwVDSE2pod5kA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XPJ77gg391UzrkiOg9k0sTExzXGm0g7aguvpNAccn0HyvUd9YMXFjRg4U7tDYfbZB
         IwvJkYcdlMWklf9oKhCZ0lxF5g0xdWo+9Wf32lXd/z/VNdnz+U5YHp5CnrOJGd3bQO
         hN/0GO2MMuaSSK1UUDOTMMpzVKfRFgD0MvnxWItfDWHyeiVcgOGaMP98QaGelbekyS
         GFBa5Zh06dKPAHlf/TovEvL8hR6Exb6tzUQ1a0oyCKzHtYYwLvV2IfRGSUTWrx8z2c
         w2U/WkJy/KjkVBxaYoxqB8t1WUZYzTujETKjFb2DgrWx1v6mZjxDEnXBB64wdUQOxE
         Ww3WhFrfSFDog==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2eba37104a2so65725617b3.0
        for <linux-raid@vger.kernel.org>; Thu, 14 Apr 2022 12:02:14 -0700 (PDT)
X-Gm-Message-State: AOAM533WaRc4zerOGo5XPKHzMl3Xw82Eq1j7/FaWKW6/bxSt3dl7pRXV
        Cj2b60j5IN1bMwcnEgWVPqBMs6qjwFEPaTUgah0=
X-Google-Smtp-Source: ABdhPJxmOwYGKqIxMBC5ZGKo/OYjqOyuQW8/dKQ8SuAFv+n2dt83EdsV2S6DgT/MXfXvVelD7glpSDWRDAPBgicHAvY=
X-Received: by 2002:a81:238b:0:b0:2eb:fd76:29f8 with SMTP id
 j133-20020a81238b000000b002ebfd7629f8mr3091802ywj.472.1649962933540; Thu, 14
 Apr 2022 12:02:13 -0700 (PDT)
MIME-Version: 1.0
References: <7ffe1f1e-1054-6119-83a8-53edd89a902b@plouf.fr.eu.org>
In-Reply-To: <7ffe1f1e-1054-6119-83a8-53edd89a902b@plouf.fr.eu.org>
From:   Song Liu <song@kernel.org>
Date:   Thu, 14 Apr 2022 12:02:02 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5+Y4K+fNSgx5AYwHkAHPw8i9z01LWrXM5qOP8qvvzuCg@mail.gmail.com>
Message-ID: <CAPhsuW5+Y4K+fNSgx5AYwHkAHPw8i9z01LWrXM5qOP8qvvzuCg@mail.gmail.com>
Subject: Re: [PATCH v2] md/raid0: Ignore RAID0 layout if the second zone has
 only one device
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc:     NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Apr 12, 2022 at 11:54 PM Pascal Hambourg <pascal@plouf.fr.eu.org> wrote:
>
> The RAID0 layout is irrelevant if all members have the same size so the
> array has only one zone. It is *also* irrelevant if the array has two
> zones and the second zone has only one device, for example if the array
> has two members of different sizes.
>
> So in that case it makes sense to allow assembly even when the layout is
> undefined, like what is done when the array has only one zone.
>
> Reviewed-By: NeilBrown <neilb@suse.de>
> Signed-off-by: Pascal Hambourg <pascal@plouf.fr.eu.org>

Thanks for the patch and thanks Neil for the review.

Applied to md-next with two minor changes:

s/ENOTSUPP/EOPNOTSUPP/
s/Reviewed-By/Review-by/

Thanks,
Song

> ---
>
> Changes since v1:
> - add missing Signed-off-by
> - add missing subsystem maintainer in recipients
>
> ---
>   drivers/md/raid0.c | 31 ++++++++++++++++---------------
>   1 file changed, 16 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index b21e101183f4..7623811cc11c 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -128,21 +128,6 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
>         pr_debug("md/raid0:%s: FINAL %d zones\n",
>                  mdname(mddev), conf->nr_strip_zones);
>
> -       if (conf->nr_strip_zones == 1) {
> -               conf->layout = RAID0_ORIG_LAYOUT;
> -       } else if (mddev->layout == RAID0_ORIG_LAYOUT ||
> -                  mddev->layout == RAID0_ALT_MULTIZONE_LAYOUT) {
> -               conf->layout = mddev->layout;
> -       } else if (default_layout == RAID0_ORIG_LAYOUT ||
> -                  default_layout == RAID0_ALT_MULTIZONE_LAYOUT) {
> -               conf->layout = default_layout;
> -       } else {
> -               pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layout setting\n",
> -                      mdname(mddev));
> -               pr_err("md/raid0: please set raid0.default_layout to 1 or 2\n");
> -               err = -ENOTSUPP;
> -               goto abort;
> -       }
>         /*
>          * now since we have the hard sector sizes, we can make sure
>          * chunk size is a multiple of that sector size
> @@ -273,6 +258,22 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
>                          (unsigned long long)smallest->sectors);
>         }
>
> +       if (conf->nr_strip_zones == 1 || conf->strip_zone[1].nb_dev == 1) {
> +               conf->layout = RAID0_ORIG_LAYOUT;
> +       } else if (mddev->layout == RAID0_ORIG_LAYOUT ||
> +                  mddev->layout == RAID0_ALT_MULTIZONE_LAYOUT) {
> +               conf->layout = mddev->layout;
> +       } else if (default_layout == RAID0_ORIG_LAYOUT ||
> +                  default_layout == RAID0_ALT_MULTIZONE_LAYOUT) {
> +               conf->layout = default_layout;
> +       } else {
> +               pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layout setting\n",
> +                      mdname(mddev));
> +               pr_err("md/raid0: please set raid0.default_layout to 1 or 2\n");
> +               err = -ENOTSUPP;
> +               goto abort;
> +       }
> +
>         pr_debug("md/raid0:%s: done.\n", mdname(mddev));
>         *private_conf = conf;
>
> --
> 2.11.0
>
