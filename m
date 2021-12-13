Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE432C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 13 Dec 2021 23:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbhLMXui (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Dec 2021 18:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhLMXuh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Dec 2021 18:50:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49369C061574
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 15:50:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 110F3B8172A
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 23:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A6CC34604
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 23:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639439434;
        bh=pQObzqGknZ7bqUTKLhZ+zq5leGXXGCIyYg3hqM8F+sM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sEdo8fnPzDsz5ZRAA8PDWYqM5vJXMeOZfauBWmTMBON6uLPrCD0sz9ApZuPpqDvrX
         guLR01ghbk8+O+UV2cenDWjhfo2eUz91Ys6u0kZn1wwTYZmlUjOYHrYpts+y9o3vs6
         pNibKK+OjD8J2fdHICt4pxqMz0Rq1G/li/7yKkTbn58MY7TwwoEdXS8G7RS+JkK6Hg
         HN/D7ovCdaLgxVZ/rks8nussGTeKG8brImW/TpaLaqqYl2EbHjMETN4ZVN9o4pIRs6
         hiCvnhnHMdV+2+vbABqMG6bVeMk7NABPSLPw+9cqKdWJVYpWX07BDAA9S+fWaEi1er
         JNEpwP10NtGSw==
Received: by mail-yb1-f179.google.com with SMTP id q74so42194407ybq.11
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 15:50:34 -0800 (PST)
X-Gm-Message-State: AOAM5310ujrWrGZknSdkHNoZ8wpJqYtP6Qa4cuK1B/JwBz6CtccI2+xL
        ezmbO2hueBWtxv3vZldueWt76VzRnJSlDdvP/3M=
X-Google-Smtp-Source: ABdhPJzbfzH3UacknKYqcNjlKebKIe8ei7+QuTcnY1iCulBZJpsWS0HfZ8XvENn+lEdYsa/F6r+PDORWtU3pe3zh+Gg=
X-Received: by 2002:a25:a283:: with SMTP id c3mr2005176ybi.219.1639439433817;
 Mon, 13 Dec 2021 15:50:33 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com>
In-Reply-To: <20211110181441.9263-1-vverma@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 13 Dec 2021 15:50:23 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7roOn=n4sX3ysN-z+WPLqUYFwUZr-SNspD1ajD5CONYg@mail.gmail.com>
Message-ID: <CAPhsuW7roOn=n4sX3ysN-z+WPLqUYFwUZr-SNspD1ajD5CONYg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/4] md: add support for REQ_NOWAIT
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 10, 2021 at 10:15 AM Vishal Verma <vverma@digitalocean.com> wrote:
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
> ---
>  drivers/md/md.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5111ed966947..a30c78afcab6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -419,6 +419,11 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
>         if (is_suspended(mddev, bio)) {
>                 DEFINE_WAIT(__wait);
>                 for (;;) {
> +                       /* Bail out if REQ_NOWAIT is set for the bio */
> +                       if (bio->bi_opf & REQ_NOWAIT) {
> +                               bio_wouldblock_error(bio);
> +                               return;
> +                       }

We need a rcu_read_unlock() before bio_wouldbock_error(bio).

>                         prepare_to_wait(&mddev->sb_wait, &__wait,
>                                         TASK_UNINTERRUPTIBLE);
>                         if (!is_suspended(mddev, bio))
> @@ -5792,6 +5797,7 @@ int md_run(struct mddev *mddev)
>         int err;
>         struct md_rdev *rdev;
>         struct md_personality *pers;
> +       bool nowait = true;
>
>         if (list_empty(&mddev->disks))
>                 /* cannot run an array with no devices.. */
> @@ -5862,8 +5868,13 @@ int md_run(struct mddev *mddev)
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
> @@ -7007,6 +7018,15 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
>         set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>         if (!mddev->thread)
>                 md_update_sb(mddev, 1);
> +       /*
> +        * If the new disk does not support REQ_NOWAIT,
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
