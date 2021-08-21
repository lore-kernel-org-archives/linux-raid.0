Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D25C4338F
	for <linux-raid@archiver.kernel.org>; Sat, 21 Aug 2021 00:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9101261042
	for <linux-raid@archiver.kernel.org>; Sat, 21 Aug 2021 00:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhHUAc1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Aug 2021 20:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229783AbhHUAc0 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 20 Aug 2021 20:32:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BC0861175
        for <linux-raid@vger.kernel.org>; Sat, 21 Aug 2021 00:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629505900;
        bh=U5s7pwqFQejZnbF2637G7Qe18H+Si0LOHqFwd5P6O20=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vFEGTodj7JtYEVcu1Za1Hqc10dW8EZvDiMaa/8ceET9DdgvfzK835+aO4FT9uHF+c
         8gFi9iGcoNLJj7BdjVmJBvuYAhwg/2lf0b8cEjqXELWpylL6Oc9PjP+HvvE61GNK9c
         DIKrNGfNzRcMDbC78q4IQc7grs2QFFxTcVqPQgV5Vm0sF8oK13uS3BQ13YHns2jPAS
         04mrHS8N0aVa325WRM5TGm1R+N1YyBSAL3fyDXKVHPqn5dTD9AfLap3C0UEThwyfG5
         sLFaQCf3ZmUVSZQMCWjHCuuau7FzL18ubprWpTg4wuNy2ufaf+8bJ6eJa339I0yEJr
         t5M0f69JIzEJA==
Received: by mail-lj1-f174.google.com with SMTP id q21so19876968ljj.6
        for <linux-raid@vger.kernel.org>; Fri, 20 Aug 2021 17:31:39 -0700 (PDT)
X-Gm-Message-State: AOAM53268WIaNcAyyCESEQUVfmB2/dwPl2PcxYdHojNV2KVZ6KaCcpSh
        Yu79EkByYckXjVCKOBd7Y3hdTUxp+0LB8+KLKiY=
X-Google-Smtp-Source: ABdhPJwAF9Lu3mWp7KbiAZO/3fvFUQ+/CJouh/tMgFdP1KWR6fhf/gOpLaMovLwFw2n55B2wWE85LFBZ+R290cghvEI=
X-Received: by 2002:a2e:9953:: with SMTP id r19mr17896098ljj.270.1629505898512;
 Fri, 20 Aug 2021 17:31:38 -0700 (PDT)
MIME-Version: 1.0
References: <1629266268-3624-1-git-send-email-xni@redhat.com>
In-Reply-To: <1629266268-3624-1-git-send-email-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 20 Aug 2021 17:31:27 -0700
X-Gmail-Original-Message-ID: <CAPhsuW73qcuf-a=ENW+f3ecb548uL2zHxir7dYixrnz5838gZw@mail.gmail.com>
Message-ID: <CAPhsuW73qcuf-a=ENW+f3ecb548uL2zHxir7dYixrnz5838gZw@mail.gmail.com>
Subject: Re: [PATCH v2] md/raid10: Remove rcu_dereference when it doesn't need
 rcu lock to protect
To:     Xiao Ni <xni@redhat.com>
Cc:     Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Aug 17, 2021 at 10:58 PM Xiao Ni <xni@redhat.com> wrote:
>
> One warning message is triggered like this:
> [  695.110751] =============================
> [  695.131439] WARNING: suspicious RCU usage
> [  695.151389] 4.18.0-319.el8.x86_64+debug #1 Not tainted
> [  695.174413] -----------------------------
> [  695.192603] drivers/md/raid10.c:1776 suspicious
> rcu_dereference_check() usage!
> [  695.225107] other info that might help us debug this:
> [  695.260940] rcu_scheduler_active = 2, debug_locks = 1
> [  695.290157] no locks held by mkfs.xfs/10186.
>
> In the first loop of function raid10_handle_discard. It already
> determines which disk need to handle discard request and add the
> rdev reference count rdev->nr_pending. So the conf->mirrors will
> not change until all bios come back from underlayer disks. It
> doesn't need to use rcu_dereference to get rdev.
>
> Fixes: d30588b2731f ('md/raid10: improve raid10 discard request')
> Signed-off-by: Xiao Ni <xni@redhat.com>
> Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>

Applied to md-fixes. Thanks!
Song

> ---
> V2: Fix comment style problem
>
>  drivers/md/raid10.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 16977e8..d5d9233 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1712,6 +1712,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>         } else
>                 r10_bio->master_bio = (struct bio *)first_r10bio;
>
> +       /*
> +        * first select target devices under rcu_lock and
> +        * inc refcount on their rdev.  Record them by setting
> +        * bios[x] to bio
> +        */
>         rcu_read_lock();
>         for (disk = 0; disk < geo->raid_disks; disk++) {
>                 struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
> @@ -1743,9 +1748,6 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>         for (disk = 0; disk < geo->raid_disks; disk++) {
>                 sector_t dev_start, dev_end;
>                 struct bio *mbio, *rbio = NULL;
> -               struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
> -               struct md_rdev *rrdev = rcu_dereference(
> -                       conf->mirrors[disk].replacement);
>
>                 /*
>                  * Now start to calculate the start and end address for each disk.
> @@ -1775,9 +1777,12 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>
>                 /*
>                  * It only handles discard bio which size is >= stripe size, so
> -                * dev_end > dev_start all the time
> +                * dev_end > dev_start all the time.
> +                * It doesn't need to use rcu lock to get rdev here. We already
> +                * add rdev->nr_pending in the first loop.
>                  */
>                 if (r10_bio->devs[disk].bio) {
> +                       struct md_rdev *rdev = conf->mirrors[disk].rdev;
>                         mbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
>                         mbio->bi_end_io = raid10_end_discard_request;
>                         mbio->bi_private = r10_bio;
> @@ -1790,6 +1795,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>                         bio_endio(mbio);
>                 }
>                 if (r10_bio->devs[disk].repl_bio) {
> +                       struct md_rdev *rrdev = conf->mirrors[disk].replacement;
>                         rbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
>                         rbio->bi_end_io = raid10_end_discard_request;
>                         rbio->bi_private = r10_bio;
> --
> 2.7.5
>
