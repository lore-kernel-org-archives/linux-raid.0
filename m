Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE9AC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Dec 2021 01:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhLWBW5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Dec 2021 20:22:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56430 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhLWBW4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Dec 2021 20:22:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C80B61D07
        for <linux-raid@vger.kernel.org>; Thu, 23 Dec 2021 01:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF64C36AE5
        for <linux-raid@vger.kernel.org>; Thu, 23 Dec 2021 01:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640222575;
        bh=2ydh+hTHBF6TOpH24LXV7vlzW0+Opy3txTUetmXlF3E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YqNh1C8BJSnxKZ5Ie+JBhzAsDzJihZHbwwEXlHizCKRbCPt88xKsUnisXBtCVU5xD
         Z8dyfNYLnOWDAo+egLFS1uboQ9TGEX2btB/ExIqtQ2gs57GlQ/XidtryoiyVsJaG+h
         t+jqpu5s9lMxu9vGDyXYzN4FLm0scxsblRuQAKH4ebnCtX44+TTeMd+KNzN81HkMmC
         uDz2HGzzuBPVcy+wukS1+EBCu0B90qyab5olR166gtC4r0FAMbdIcRfQK3RD5pzano
         IANwIq1ItSIN8AlcRqwm8LSg7dAOTjehxQBbZhMPRnt2KeuQ3wYGR3sedb3AIACdTB
         GaCTvh47VrkJQ==
Received: by mail-yb1-f177.google.com with SMTP id j2so11592217ybg.9
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 17:22:55 -0800 (PST)
X-Gm-Message-State: AOAM533uZVZGJ73J/WC+qzV/4WReKZFGxeYY451a86b0QbRcvsuiBaKw
        tg87mxzRXYu1B5OiwW0rKNscZbuL+U3DghJI1o4=
X-Google-Smtp-Source: ABdhPJzHfvOzgibiYtenKG1jp9OlmCnUuX5r5y4SI5/l024daWvQov9k/cnz/gLM3vO5j7c2sro6Ur2wWkPLLhGu7fQ=
X-Received: by 2002:a25:850b:: with SMTP id w11mr421941ybk.208.1640222575057;
 Wed, 22 Dec 2021 17:22:55 -0800 (PST)
MIME-Version: 1.0
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com> <20211221200622.29795-1-vverma@digitalocean.com>
In-Reply-To: <20211221200622.29795-1-vverma@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 22 Dec 2021 17:22:43 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4dg1yaqnDy9HaitcdKG7qFc6twb9mrDhRw5OZRRk5xDQ@mail.gmail.com>
Message-ID: <CAPhsuW4dg1yaqnDy9HaitcdKG7qFc6twb9mrDhRw5OZRRk5xDQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] md: add support for REQ_NOWAIT
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rgoldwyn@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 21, 2021 at 12:06 PM Vishal Verma <vverma@digitalocean.com> wrote:
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
> index 5111ed966947..ccd296aa9641 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -418,6 +418,11 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
>         rcu_read_lock();
>         if (is_suspended(mddev, bio)) {
>                 DEFINE_WAIT(__wait);
> +               /* Bail out if REQ_NOWAIT is set for the bio */
> +               if (bio->bi_opf & REQ_NOWAIT) {

We need rcu_read_unlock() here.
