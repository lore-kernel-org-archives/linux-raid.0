Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3813C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 18:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B76BF60F90
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 18:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbhKBSim (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Nov 2021 14:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234858AbhKBSik (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 2 Nov 2021 14:38:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A190160F90
        for <linux-raid@vger.kernel.org>; Tue,  2 Nov 2021 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635878165;
        bh=k+EnlMu0rNHGhKbEHaf8gQ8kx8GSgP/Bj83DmzWUI0g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=if+DJPVXQKsNBRF6ga0Km57wuBPcM6NnSCzfB02TqhRZvW1Ua6FylLcKSLJzLwZzL
         oY6SqrDyXt+yzyWeBXmWyR3K6ZNuT73lFMJOE6bW7zaJX1+3RmSuuUCeaVJIhaC/jy
         bzI5DijoYjNQ7pvzSdDFOPClF4TsICFdIc/RYkbwqAYytDN/dQ0PzlETLNYe2CBU6V
         K7K3KohsMfYu/wCqsenbWJHblsbDBMz03ZrUQIPULRtkTOOic1T9xbgVefFj0CIs2+
         f/9CY+9ye6fR/4CfqXjgsZYPL1NPIAzDbshpislYs/+/DcRV4mdd3HK0P6Iv80X30T
         qsSwN4lzMM14g==
Received: by mail-lf1-f47.google.com with SMTP id u21so404243lff.8
        for <linux-raid@vger.kernel.org>; Tue, 02 Nov 2021 11:36:05 -0700 (PDT)
X-Gm-Message-State: AOAM533xXOs6Xxu9Qk39xdz3eEUirVENXCBPiNzfw0RsQNaQBHRnbtXK
        TAoNX5B2c0ZEAyrTeCzson/KleQ8jyBlwbeTqdE=
X-Google-Smtp-Source: ABdhPJxoFqIn19kpaT0/Z1v3zFCqXV1mSDvx9sND0SlNEZso3zo60Lp0pSzJ827WcQScw8ZZ+FIFHW4yTjF2Z4lys1g=
X-Received: by 2002:a05:6512:3d8a:: with SMTP id k10mr7330583lfv.143.1635878163885;
 Tue, 02 Nov 2021 11:36:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAPhsuW5FpeS9AfPYpNgHGCp8dP151g-t8whSiGyuxEfp2O92tg@mail.gmail.com>
 <20211102144004.25344-1-vverma@digitalocean.com>
In-Reply-To: <20211102144004.25344-1-vverma@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 2 Nov 2021 11:35:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
Message-ID: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
Subject: Re: [PATCH v2] md: add support for REQ_NOWAIT
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 2, 2021 at 7:40 AM Vishal Verma <vverma@digitalocean.com> wrote:
>
> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
> for checking whether a given bdev supports handling of REQ_NOWAIT or not.
> Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable
> it for linear target") added support for REQ_NOWAIT for dm. This uses
> a similar approach to incorporate REQ_NOWAIT for md based bios.
>
> This patch was tested using t/io_uring tool within FIO. A nvme drive
> was partitioned into 2 partitions and a simple raid 0 configuration
> /dev/md0 was created.
>
> md0 : active raid0 nvme4n1p1[1] nvme4n1p2[0]
>       937423872 blocks super 1.2 512k chunks
>
> Before patch:
>
> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>
> Running top while the above runs:
>
> $ ps -eL | grep $(pidof io_uring)
>
>   38396   38396 pts/2    00:00:00 io_uring
>   38396   38397 pts/2    00:00:15 io_uring
>   38396   38398 pts/2    00:00:13 iou-wrk-38397
>
> We can see iou-wrk-38397 io worker thread created which gets created
> when io_uring sees that the underlying device (/dev/md0 in this case)
> doesn't support nowait.
>
> After patch:
>
> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>
> Running top while the above runs:
>
> $ ps -eL | grep $(pidof io_uring)
>
>   38341   38341 pts/2    00:10:22 io_uring
>   38341   38342 pts/2    00:10:37 io_uring
>
> After running this patch, we don't see any io worker thread
> being created which indicated that io_uring saw that the
> underlying device does support nowait. This is the exact behaviour
> noticed on a dm device which also supports nowait.
>
> I also successfully tested this patch on various other
> raid personalities (1, 6 and 10).
>
> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
> ---
>  drivers/md/md.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5111ed966947..11174d32bfd7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5792,6 +5792,7 @@ int md_run(struct mddev *mddev)
>         int err;
>         struct md_rdev *rdev;
>         struct md_personality *pers;
> +       bool nowait = true;
>
>         if (list_empty(&mddev->disks))
>                 /* cannot run an array with no devices.. */
> @@ -5862,8 +5863,13 @@ int md_run(struct mddev *mddev)
>                         }
>                 }
>                 sysfs_notify_dirent_safe(rdev->sysfs_state);
> +               nowait = blk_queue_nowait(bdev_get_queue(rdev->bdev));

This doesn't look right to me. I think we need
    nowait = nowait && blk_queue_nowait(bdev_get_queue(rdev->bdev));

Thanks,
Song
