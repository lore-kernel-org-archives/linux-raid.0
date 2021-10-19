Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B2DC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 06:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3E76610A1
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 06:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhJSGcL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Oct 2021 02:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhJSGcK (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 19 Oct 2021 02:32:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B59610A1
        for <linux-raid@vger.kernel.org>; Tue, 19 Oct 2021 06:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634624997;
        bh=9V01ojk54SoY/01bnI77JNMrmymFwXSVZJccSMMZuj8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rc6K3ObeyvFHXZ/gjH1vSg2JceJlFYcUeutG/boTXkieEvECBaranxyX+G986UjkC
         iL44JgKcTaZyx+1U7cCS0KmlVASi4gFhIeQz88oG9JT7URZ6xdK4nhO8JRIK4XFVCg
         d8Ony+HsTgSp/x8PINQs8nB3fpRjxmEY3lf4MGmSdzMkmugBoy1OXXY1D3w7vIBoOx
         OQRKC6d4THlFY56JGFK5eBxfborZjqacL+EoDX+6BexrAZ7eYPgmJMdNn0tyw0ldZ+
         Bi5NpHlPlpY1xFJ82S4WXyy3nUGF/UZ2SYZOj6MOH5GIjN2aGTRgPzZWWbgSZRyHry
         vPXkMUDDN50mA==
Received: by mail-wm1-f46.google.com with SMTP id y16-20020a05600c17d000b0030db7a51ee2so1314585wmo.0
        for <linux-raid@vger.kernel.org>; Mon, 18 Oct 2021 23:29:57 -0700 (PDT)
X-Gm-Message-State: AOAM532a8HGFcYOlU6bj6p0dJ5k5NY5Z0A2MYeinFa3lqjJz7Cs8AfBm
        nlAZlfGwiSIgHacW0UDGeGxxh2sYGP6/Xy2BH/4=
X-Google-Smtp-Source: ABdhPJw3YKPimmda83JPjq+m7dLzt+j+9JpU7vl6uHKTxIFIdQzwN4t4sv4kz+XmCCNB9AnTqixrHy6b+clXbv3bgVk=
X-Received: by 2002:a05:600c:283:: with SMTP id 3mr4009624wmk.157.1634624996369;
 Mon, 18 Oct 2021 23:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <20211017135019.27346-1-guoqing.jiang@linux.dev> <20211017135019.27346-2-guoqing.jiang@linux.dev>
In-Reply-To: <20211017135019.27346-2-guoqing.jiang@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Mon, 18 Oct 2021 23:29:45 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7U6Vqu0PGWStsNPB=rFqDHTTdZk-pNp4MHQ6yCkKd8kA@mail.gmail.com>
Message-ID: <CAPhsuW7U6Vqu0PGWStsNPB=rFqDHTTdZk-pNp4MHQ6yCkKd8kA@mail.gmail.com>
Subject: Re: [PATCH 1/3] md/bitmap: don't set max_write_behind if there is no
 write mostly device
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Oct 17, 2021 at 6:50 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> We shouldn't set it since write behind IO should only happen to write
> mostly device.
>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>

Applied to md-next with a couple minor changes.

> ---
>  drivers/md/md-bitmap.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index e29c6298ef5c..9424879d8d7e 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2469,11 +2469,29 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
>  {
>         unsigned long backlog;
>         unsigned long old_mwb = mddev->bitmap_info.max_write_behind;
> +       struct md_rdev *rdev;
> +       bool has_write_mostly = false;
>         int rv = kstrtoul(buf, 10, &backlog);
>         if (rv)
>                 return rv;
>         if (backlog > COUNTER_MAX)
>                 return -EINVAL;
> +
> +       /*
> +        * Without write mostly device, it doesn't make sense to set
> +        * backlog for max_write_behind.
> +        */
> +       rdev_for_each(rdev, mddev)
> +               if (test_bit(WriteMostly, &rdev->flags)) {
> +                       has_write_mostly = true;
> +                       break;
> +               }

Added curly brackets for multi-line block.

> +       if (!has_write_mostly) {
> +               pr_warn_ratelimited("%s: can't set backlog, no write mostly"
> +                                   " device available\n", mdname(mddev));

Merged the two strings to a single line. checkpatch.pl should complain
about splitting a print string.

> +               return -EINVAL;
> +       }
> +
>         mddev->bitmap_info.max_write_behind = backlog;
>         if (!backlog && mddev->serial_info_pool) {
>                 /* serial_info_pool is not needed if backlog is zero */
> --
> 2.31.1
>
