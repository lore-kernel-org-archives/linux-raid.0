Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3568C4338F
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 16:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC78A6103A
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 16:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbhHMQud (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Aug 2021 12:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236320AbhHMQuc (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 13 Aug 2021 12:50:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4E24610FA
        for <linux-raid@vger.kernel.org>; Fri, 13 Aug 2021 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628873405;
        bh=zSkzixBuo77YxNGN9ENOYTj0/4+ulQFSpv/Mk8OB9+U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LhJAorQrewaKWB7QKh+Q5wVhDbteMGBpqhDbyTdGQDkgu5ENVpqTvaUWSagCQpOgc
         Ss7Y3v6FjDcdv+VGM7hoHKmmDs4V5H5kVKF+PlLUC/07LLD3JBo49k0/9clkIP3zLa
         bT7kDeCmAcGsRI2GQln5daPsJH49qWwdNfKcFVKkw31D/zDJJ8VuMEXia/eFyHge5B
         LMmNgk+/I2Znt8pI0CV3CwMDumHkn3ECh1HQboPMrCandekizKGXIL50ER1x4hD9D6
         FPSXMyKcyycuSy5XIwh45XyKARWHylh5GSyNooe1PYF1jn7uX2tiyOcOlep64XbQw8
         khVpX+RDUpAUw==
Received: by mail-lj1-f174.google.com with SMTP id a7so16460561ljq.11
        for <linux-raid@vger.kernel.org>; Fri, 13 Aug 2021 09:50:05 -0700 (PDT)
X-Gm-Message-State: AOAM5321S3yWra9Emo6RCY39IhlKkUox3TtKQjFix4FLt1S6yUhQfBKd
        kkaGYg5/xsRURUHIVdZ1c9+6bzQCL9TtjI6YHug=
X-Google-Smtp-Source: ABdhPJyTAqthdLsexj2OLjU0vjQsQABl0Uyxz2Ij0Y3kn6Gth9Tz9f73vuS8wBrmxgxIiiANzfB7lXSTP0wCAfXtvI0=
X-Received: by 2002:a2e:9243:: with SMTP id v3mr2453044ljg.357.1628873404147;
 Fri, 13 Aug 2021 09:50:04 -0700 (PDT)
MIME-Version: 1.0
References: <1628481709-3824-1-git-send-email-xni@redhat.com>
In-Reply-To: <1628481709-3824-1-git-send-email-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 13 Aug 2021 09:49:53 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6iGBrdso3yStTxxv00qxLbW_gP_2H1CMsi5YzPFU5aqA@mail.gmail.com>
Message-ID: <CAPhsuW6iGBrdso3yStTxxv00qxLbW_gP_2H1CMsi5YzPFU5aqA@mail.gmail.com>
Subject: Re: [PATCH 1/1] md/raid10: Remove rcu_dereference when it doesn't
 need rcu lock to protect
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Aug 8, 2021 at 9:02 PM Xiao Ni <xni@redhat.com> wrote:
>
> In the first loop of function raid10_handle_discard. It already
> determines which disk need to handle discard request and add the
> rdev reference count. So the conf->mirrors will not change until
> all bios come back from underlayer disks. It doesn't need to use
> rcu_dereference to get rdev.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>

Will we get performance benefits from this change? If not, I would
prefer to keep the code as-is.

Thanks,
Song

> ---
>  drivers/md/raid10.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 16977e8..cef9869 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1743,9 +1743,8 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>         for (disk = 0; disk < geo->raid_disks; disk++) {
>                 sector_t dev_start, dev_end;
>                 struct bio *mbio, *rbio = NULL;
> -               struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
> -               struct md_rdev *rrdev = rcu_dereference(
> -                       conf->mirrors[disk].replacement);
> +               struct md_rdev *rdev = conf->mirrors[disk].rdev;
> +               struct md_rdev *rrdev = conf->mirrors[disk].replacement;
>
>                 /*
>                  * Now start to calculate the start and end address for each disk.
> --
> 2.7.5
>
