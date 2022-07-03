Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0AD8C43334
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jul 2022 15:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbiGCPAT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jul 2022 11:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiGCPAS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 3 Jul 2022 11:00:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B8E6395;
        Sun,  3 Jul 2022 08:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF61BCE0ED8;
        Sun,  3 Jul 2022 15:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD1BC341C6;
        Sun,  3 Jul 2022 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656860414;
        bh=9xoGh7FTIXdYCae7wfWJR5ibGEP1JE5frDaXf2XOqNI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CnvLdU6diFe19rBYTseEwc/YVC+0lJ5422VKqJpr0Beu3D99iGEJ+17tzMIOVuOde
         hVtJoFav7JO1GGopIvmvy8TIfyw47WIKFJRaf8YZGc24zLnc7/EMBsd6FwysYC3JcR
         sAXcAY3Vn0Q+Fu7b1dslsS8+Q21TTVQ7+nq6MIc99OJYoevJrkaeLw6V/0FFYx8pQM
         UoHBaRDML1fxp0uRYGG7pQoN6yOTSl+UpwzG/jigVq35chCqjx77ocMVR7OBS462kv
         I5tZx0DxOwvpYOKiwQGu61brAyjxQd97p+smckxpNtviIsdmq5qDBsl3QP3jm8N5QC
         6fephEpQyGVLQ==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-31c86fe1dddso14054767b3.1;
        Sun, 03 Jul 2022 08:00:14 -0700 (PDT)
X-Gm-Message-State: AJIora976d36OHVhxEFWZYlekgs8YvMUb7kLDX9MRonx+vTMHtpsb6Eq
        gcYJYbmJoJXRFUNzNdVT6o+7PaK2qXLhuaX0sls=
X-Google-Smtp-Source: AGRyM1ukynLIgOiitvo7ArTq4Xp44i5t+uf5ktShtxOF0oujSdeNPWkJUrhyjr0mSQV9X5gT54Bbfgijakl169LwnEo=
X-Received: by 2002:a0d:d757:0:b0:31c:87bb:d546 with SMTP id
 z84-20020a0dd757000000b0031c87bbd546mr4492672ywd.472.1656860413255; Sun, 03
 Jul 2022 08:00:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220702015411.61522-1-jiaming@nfschina.com>
In-Reply-To: <20220702015411.61522-1-jiaming@nfschina.com>
From:   Song Liu <song@kernel.org>
Date:   Sun, 3 Jul 2022 08:00:02 -0700
X-Gmail-Original-Message-ID: <CAPhsuW42y5JmQPLS59KFYr1GS=LVztyhhbQ1sbB9Ag4ugV1KSA@mail.gmail.com>
Message-ID: <CAPhsuW42y5JmQPLS59KFYr1GS=LVztyhhbQ1sbB9Ag4ugV1KSA@mail.gmail.com>
Subject: Re: [PATCH] md: Fix spelling mistake in comments
To:     Zhang Jiaming <jiaming@nfschina.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Jul 1, 2022 at 6:54 PM Zhang Jiaming <jiaming@nfschina.com> wrote:
>
> There are 2 spelling mistakes in comments. Fix it.
>
> Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>

Applied to md-next.

Thanks,
Song

> ---
>  drivers/md/md-cluster.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 37cbcce3cc66..742b2349fea3 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -40,7 +40,7 @@ struct resync_info {
>
>  /* Lock the send communication. This is done through
>   * bit manipulation as opposed to a mutex in order to
> - * accomodate lock and hold. See next comment.
> + * accommodate lock and hold. See next comment.
>   */
>  #define                MD_CLUSTER_SEND_LOCK                    4
>  /* If cluster operations (such as adding a disk) must lock the
> @@ -689,7 +689,7 @@ static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
>         /*
>          * If resync thread run after raid1d thread, then process_metadata_update
>          * could not continue if raid1d held reconfig_mutex (and raid1d is blocked
> -        * since another node already got EX on Token and waitting the EX of Ack),
> +        * since another node already got EX on Token and waiting the EX of Ack),
>          * so let resync wake up thread in case flag is set.
>          */
>         if (mddev_locked && !test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
> --
> 2.25.1
>
