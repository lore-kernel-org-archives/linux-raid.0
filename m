Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB380C4332F
	for <linux-raid@archiver.kernel.org>; Tue,  1 Nov 2022 20:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiKAUV3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Nov 2022 16:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiKAUV1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Nov 2022 16:21:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1036F62DD
        for <linux-raid@vger.kernel.org>; Tue,  1 Nov 2022 13:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9548DB81F0E
        for <linux-raid@vger.kernel.org>; Tue,  1 Nov 2022 20:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B734C433D6
        for <linux-raid@vger.kernel.org>; Tue,  1 Nov 2022 20:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667334084;
        bh=+Bc7dg2H0VkmoZ9D7R6W7ijbGY05yXLdfMzpuE4kM7I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=twMQ1BoNIxbNyaRMlqCrnt/CqVpGDqOIygtqqu9O7vALBCOmAd6OmY387tZf9PHxV
         RW4DCIEBq9Oc23sL5zPgQVdCKsvMCiKBMo3UTCSowC77YYGOyM1OvN+WF9Q2JadeNJ
         19a7Tl1WvafvIT085yK+2EgkzgQEE0K9EnXAMsif193Ina4MtDhmVpszmy86PhHxIg
         jhNB2xgH/NQSw984F2VJBI0BD2rBnkNY+tbxSUOXQH2P7Rt7XIQnu3aoVFhm11fxmA
         p+xocsRu/gjsVRLbZ2KMecXald4UKMWoZjrCySkouAMrci+oUriJTVO5RShSuaKWJ0
         7z6HptBz3l0WA==
Received: by mail-ej1-f43.google.com with SMTP id bj12so39865316ejb.13
        for <linux-raid@vger.kernel.org>; Tue, 01 Nov 2022 13:21:24 -0700 (PDT)
X-Gm-Message-State: ACrzQf1gMHL0hTJFNf2Quhoqj1I1LZ850kYT/wxGNHIE0fEJb7Yo9/dP
        Jz0SLfxG7a6vhnEC1AHZbx+O8KEwrHksW4VqO1M=
X-Google-Smtp-Source: AMsMyM6PLqYZMWT3hNkjKcmwlProMnYspiaW9kJMyEHCmVGonMFCa+i4o1wfIql0arNb2zTH3703wnGMNV4SANd6Vic=
X-Received: by 2002:a17:907:628f:b0:72f:58fc:3815 with SMTP id
 nd15-20020a170907628f00b0072f58fc3815mr19604601ejc.719.1667334082483; Tue, 01
 Nov 2022 13:21:22 -0700 (PDT)
MIME-Version: 1.0
References: <20221101050819.12509-1-xni@redhat.com>
In-Reply-To: <20221101050819.12509-1-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 1 Nov 2022 13:21:10 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7QLFpMbsYcisTm32zdeeYEXMT+M76S=Kjn5rurTF8Lpw@mail.gmail.com>
Message-ID: <CAPhsuW7QLFpMbsYcisTm32zdeeYEXMT+M76S=Kjn5rurTF8Lpw@mail.gmail.com>
Subject: Re: [PATCH 1/1] Don't set discard sectors for request queue
To:     Xiao Ni <xni@redhat.com>
Cc:     yi.zhang@redhat.com, ming.lei@redhat.com,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Oct 31, 2022 at 10:08 PM Xiao Ni <xni@redhat.com> wrote:

Please update the subject as md/raid0, raid10: xxx.

>
> It should use disk_stack_limits to get a proper max_discard_sectors
> rather than setting a value by stack drivers.
>
> And there is a bug. If all member disks are rotational devices,
> raid0/raid10 set max_discard_sectors. So the member devices are
> not ssd/nvme, but raid0/raid10 export the wrong value. It reports
> warning messages in function __blkdev_issue_discard when mkfs.xfs

Please provide more information about this bug: the warning message,
the impact, etc. in the commit log.

>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> Reported-by: Yi Zhang <yi.zhang@redhat.com>

Thanks,
Song

> ---
>  drivers/md/raid0.c  | 1 -
>  drivers/md/raid10.c | 2 --
>  2 files changed, 3 deletions(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index aced0ad8cdab..9d4831ca802c 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -398,7 +398,6 @@ static int raid0_run(struct mddev *mddev)
>
>                 blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
>                 blk_queue_max_write_zeroes_sectors(mddev->queue, mddev->chunk_sectors);
> -               blk_queue_max_discard_sectors(mddev->queue, UINT_MAX);
>
>                 blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
>                 blk_queue_io_opt(mddev->queue,
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 3aa8b6e11d58..9a6503f5cb98 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4145,8 +4145,6 @@ static int raid10_run(struct mddev *mddev)
>         conf->thread = NULL;
>
>         if (mddev->queue) {
> -               blk_queue_max_discard_sectors(mddev->queue,
> -                                             UINT_MAX);
>                 blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
>                 blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
>                 raid10_set_io_opt(conf);
> --
> 2.32.0 (Apple Git-132)
>
