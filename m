Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C973C38142
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 07:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjBAHHI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 02:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBAHHH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 02:07:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E6E11C
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 23:07:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 610416134A
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 07:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90EFC4339E
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 07:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675235225;
        bh=pxFRylil5Y0pEGjvs0/y16fYOI4N8WHqZfUOsPNkZQE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=In/yctUfk7qvf+pxNtTtoip6+3vhdKprvFGwgGc/Y8HI/VmUgeCE4MKBVvcbu3C1f
         sTIIMiGmvbi7URVMeiTmdOTo9flCLFLiVWy+rwthyrTo90erpf+jTtt4lbWlU7cI1e
         NTEdPphCWq9cvQjAfOpPRCvBE2xE5nBIFkb58nlxMxW8aROQomF+VZwoLOk8jweM3A
         kG7zPcik6Mvw4BOPEV7HCC4GT+9UuloLxIbB28Z8Xy1EW5SnRmN6YF04zmZ/sUpURG
         7SM60QVMW7otrEhL304dozVq2RyR96hP/MWz04dS2OKRg8FH1E6kPyB2gAY2GZyZkZ
         0gYnx1ZZztnwg==
Received: by mail-lf1-f44.google.com with SMTP id j17so27902059lfr.3
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 23:07:05 -0800 (PST)
X-Gm-Message-State: AO0yUKV3rPTcoLA3WE29MeTmmLnA99d8u6BGd6Yet/FICsVBvB3pCTz6
        FcQxMAQUH36ss5qjEXLmtALcfABnW2xq3QzZrZs=
X-Google-Smtp-Source: AK7set9+8J/qgORqNs+Kw90yJrMS7Y8v3mBoO8jBd5NNiXgUud0eMYelNHGhaScuxfDMWsPLkKs5REzRsSi7MK0B2wA=
X-Received: by 2002:a05:6512:31b:b0:4d5:82bb:c06d with SMTP id
 t27-20020a056512031b00b004d582bbc06dmr253962lfp.256.1675235223794; Tue, 31
 Jan 2023 23:07:03 -0800 (PST)
MIME-Version: 1.0
References: <20230201064657.2768402-1-houtao@huaweicloud.com>
In-Reply-To: <20230201064657.2768402-1-houtao@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 31 Jan 2023 23:06:51 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6GmGdtaALpcY7LpsEr4SHXLRxDb9iZWTPG2h8q2UX5Mw@mail.gmail.com>
Message-ID: <CAPhsuW6GmGdtaALpcY7LpsEr4SHXLRxDb9iZWTPG2h8q2UX5Mw@mail.gmail.com>
Subject: Re: [PATCH] md: use MD_RESYNC_* whenever possible
To:     Hou Tao <houtao@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Logan Gunthorpe <logang@deltatee.com>, houtao1@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jan 31, 2023 at 10:18 PM Hou Tao <houtao@huaweicloud.com> wrote:
>
> From: Hou Tao <houtao1@huawei.com>
>
> Just replace magic numbers by MD_RESYNC_* enumerations.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Thanks for the patch. But it doesn't apply. I guess this is caused
by some local debug commit?

Song

> ---
> Hi,
>
> The cleanup patch should be sent out with patch "md: don't update
> recovery_cp when curr_resync is ACTIVE" together as a tiny patchset,
> but i forgot about it, so now send it alone.
>
>  drivers/md/md.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 67ef1c768456..16da504aa156 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6156,7 +6156,7 @@ static void md_clean(struct mddev *mddev)
>         mddev->new_level = LEVEL_NONE;
>         mddev->new_layout = 0;
>         mddev->new_chunk_sectors = 0;
> -       mddev->curr_resync = 0;
> +       mddev->curr_resync = MD_RESYNC_NONE;
>         atomic64_set(&mddev->resync_mismatches, 0);
>         mddev->suspend_lo = mddev->suspend_hi = 0;
>         mddev->sync_speed_min = mddev->sync_speed_max = 0;
> @@ -8887,7 +8887,7 @@ void md_do_sync(struct md_thread *thread)
>         atomic_set(&mddev->recovery_active, 0);
>         last_check = 0;
>
> -       if (j>2) {
> +       if (j >= MD_RESYNC_ACTIVE) {
>                 pr_debug("md: resuming %s of %s from checkpoint.\n",
>                          desc, mdname(mddev));
>                 pr_info("md: resuming %s of %s from 0x%llx\n", desc, mdname(mddev), j);
> @@ -8967,7 +8967,7 @@ void md_do_sync(struct md_thread *thread)
>                 if (j > max_sectors)
>                         /* when skipping, extra large numbers can be returned. */
>                         j = max_sectors;
> -               if (j > 2)
> +               if (j >= MD_RESYNC_ACTIVE)
>                         mddev->curr_resync = j;
>                 mddev->curr_mark_cnt = io_sectors;
>                 if (last_check == 0)
> --
> 2.29.2
>
