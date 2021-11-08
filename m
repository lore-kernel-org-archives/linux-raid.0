Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C48E4C433F5
	for <linux-raid@archiver.kernel.org>; Mon,  8 Nov 2021 22:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8B5561390
	for <linux-raid@archiver.kernel.org>; Mon,  8 Nov 2021 22:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238230AbhKHWUs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Nov 2021 17:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229627AbhKHWUq (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 8 Nov 2021 17:20:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8342F613A6
        for <linux-raid@vger.kernel.org>; Mon,  8 Nov 2021 22:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636409881;
        bh=09zRVXAN8PlsIsOpGM5yDZd397+CEV5gWNL2YnstSTQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ffpPd+sv83lCiBEkwOsIkenrf92iw0sxtsaLovb1nHheVbAtglYnl/Eq/iyn1el+f
         FY7nHeKUJEt4FyEn0kQjEEfErc6JMy7X1hZqs8t/tcyylffKjJAqjwHwrHP5pb1IE6
         WB05xzhk273EskD+MjTU3vhknHnFfvAekeWe7XwgmrYwwuvrcpl9JSCYOVMjcfPEms
         UVyCZLG7B213PCyrWVbpd4UoEjmjco1Jd6g3RPClxN94tTuqXw860KYKBr68Txt3/B
         fSlWE0QIbxB3IQ69UxN6w2NQCk8OSpb5gphBoSCx61Z5pPXV0UUvCC2pT8isnzQaT8
         /YiWGlaIUF78g==
Received: by mail-yb1-f171.google.com with SMTP id e136so44299722ybc.4
        for <linux-raid@vger.kernel.org>; Mon, 08 Nov 2021 14:18:01 -0800 (PST)
X-Gm-Message-State: AOAM530ixGwHBKHQxUgQKo2DGwtW7PkCi1wmj8w0mxPhB2V7t7HUOdci
        FgDjfE6InWjP2MBIogzexI/+dd2S/m4WSgp+UmE=
X-Google-Smtp-Source: ABdhPJxCpR+94pFD7wCrzHl8+bMQVD3XMLxScbESnWjOt/2kNUpHsmFm9rPp6SVy/xh2WlpPQROl5M+rdDpnmqdgCc8=
X-Received: by 2002:a25:660d:: with SMTP id a13mr2877461ybc.460.1636409880685;
 Mon, 08 Nov 2021 14:18:00 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
 <20211104045149.9599-1-vverma@digitalocean.com> <20211104045149.9599-2-vverma@digitalocean.com>
In-Reply-To: <20211104045149.9599-2-vverma@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 8 Nov 2021 14:17:49 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6OtyJ_e9ZSqDE1YRk+zfNfQn0KRGOBe2AetUe5c=BvMQ@mail.gmail.com>
Message-ID: <CAPhsuW6OtyJ_e9ZSqDE1YRk+zfNfQn0KRGOBe2AetUe5c=BvMQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] md: add support for REQ_NOWAIT
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 3, 2021 at 9:52 PM Vishal Verma <vverma@digitalocean.com> wrote:
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
> For all the other raid personalities except raid0, we would need
> to train pieces which involves make_request fn in order for them
> to correctly handle REQ_NOWAIT.
>
> Signed-off-by: Vishal Verma <vverma@digitalocean.com>

I think we still need the logic in md_handle_request() similar to v1?

Thanks,
Song

> ---
>  drivers/md/md.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5111ed966947..73089776475f 100644
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
> +               nowait = nowait && blk_queue_nowait(bdev_get_queue(rdev->bdev));
>         }
>
> +       /* Set the NOWAIT flags if all underlying devices support it */
> +       if (nowait)
> +               blk_queue_flag_set(QUEUE_FLAG_NOWAIT, mddev->queue);
> +
>         if (!bioset_initialized(&mddev->bio_set)) {
>                 err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
>                 if (err)
> @@ -7007,6 +7013,14 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
>         set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>         if (!mddev->thread)
>                 md_update_sb(mddev, 1);
> +       /* If the new disk does not support REQ_NOWAIT,
> +        * disable on the whole MD.
> +        */
> +       if (!blk_queue_nowait(bdev_get_queue(rdev->bdev))) {
> +               pr_info("%s: Disabling nowait because %s does not support nowait\n",
> +                       mdname(mddev), bdevname(rdev->bdev, b));
> +               blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, mddev->queue);
> +       }
>         /*
>          * Kick recovery, maybe this spare has to be added to the
>          * array immediately.
> --
> 2.17.1
>
