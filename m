Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04561C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 18:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243174AbhLISFz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:05:55 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56800 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhLISFz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 13:05:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6E388CE2588
        for <linux-raid@vger.kernel.org>; Thu,  9 Dec 2021 18:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8A6C004DD
        for <linux-raid@vger.kernel.org>; Thu,  9 Dec 2021 18:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639072938;
        bh=+ao4LkkmbXoR+p58EoE8PqxiZWfvivA2ods3PZC4Xi4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sRWmsTrdeSR/iwgsMJnUrEWoNuQd8ruyPa6l8Kt2Qox013+Mv/dbpxcP70bEixCTy
         oelm6Q1hA1Caj/+QoWMrRXfjfqNuouEOghAdTe+uikoptCpRM4GI5rmi8Ty970NyTn
         GsmvBiDysWZ5g/rne7sDaOv+jDfmF0AbY4V7+9WBuJJ5H7Ptlk6cxpZonjY0cZr/HE
         wpLKm17clumhTRKnQwxPZkxkXd66bVUt9d2E6e0aMYaA8Vu698IiP7VTi/de65dFg8
         Uhe47qwViYix49+lJzpLNsbKwwNgyCbcF3JZ+vIStw1J4VJJubtMT09A1U+4kAPvyt
         4bKNc4R/RYN7Q==
Received: by mail-yb1-f170.google.com with SMTP id q74so15517570ybq.11
        for <linux-raid@vger.kernel.org>; Thu, 09 Dec 2021 10:02:18 -0800 (PST)
X-Gm-Message-State: AOAM530R8hg7EOA8NgqBVynOORkbTQxawqJHrTB4uMu1FOBiqOrfYo5i
        p/QvFRlrtFhcrWzdJxyNSI9/fv+ICHnYtrdg9d4=
X-Google-Smtp-Source: ABdhPJzg8G/Cn5SL/j1yZ9KhHqEwg3IxP8c8ISmle3s3wxJb0FX/QLyxpao70cxeAJxESlpo/IsMzImGT6MfoJ2JF4E=
X-Received: by 2002:a25:b519:: with SMTP id p25mr8093122ybj.195.1639072937831;
 Thu, 09 Dec 2021 10:02:17 -0800 (PST)
MIME-Version: 1.0
References: <1639029324-4026-1-git-send-email-xni@redhat.com> <1639029324-4026-2-git-send-email-xni@redhat.com>
In-Reply-To: <1639029324-4026-2-git-send-email-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 9 Dec 2021 10:02:06 -0800
X-Gmail-Original-Message-ID: <CAPhsuW48S-L9QTH6q_7+Nq0+MmOfswPu5epMq=bkGokxBRE2ew@mail.gmail.com>
Message-ID: <CAPhsuW48S-L9QTH6q_7+Nq0+MmOfswPu5epMq=bkGokxBRE2ew@mail.gmail.com>
Subject: Re: [PATCH 1/2] md/raid0: Free r0conf memory when register integrity failed
To:     Xiao Ni <xni@redhat.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Dec 8, 2021 at 9:55 PM Xiao Ni <xni@redhat.com> wrote:
>
> It doesn't free memory when register integrity failed. And move
> free conf codes into a single function.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/raid0.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 62c8b6adac70..3fa47df1c60e 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -356,6 +356,7 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
>         return array_sectors;
>  }
>
> +static void free_conf(struct r0conf *conf);
>  static void raid0_free(struct mddev *mddev, void *priv);
>
>  static int raid0_run(struct mddev *mddev)
> @@ -413,19 +414,30 @@ static int raid0_run(struct mddev *mddev)
>         dump_zones(mddev);
>
>         ret = md_integrity_register(mddev);
> +       if (ret)
> +               goto free;
>
>         return ret;
> +
> +free:
> +       free_conf(conf);

Can we just use raid0_free() here? Also, after freeing conf,
we should set mddev->private to NULL.

Thanks,
Song
