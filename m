Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF16CC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 23 Dec 2021 02:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242008AbhLWC5u (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Dec 2021 21:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhLWC5t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Dec 2021 21:57:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9ACC061574
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 18:57:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0B5161D33
        for <linux-raid@vger.kernel.org>; Thu, 23 Dec 2021 02:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5178CC36AEB
        for <linux-raid@vger.kernel.org>; Thu, 23 Dec 2021 02:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640228268;
        bh=8kW8UTk1/si7Yh7Rp3sIN91z6XPgmuHQnGD8IkfsojU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mh8XGeFePUQkH/0WSAIlXDVX46Nl4+YlcJKmDwB6vhC8ML8Go2ZbjTeJ+gvj1vQra
         L/8EAaiagOfpwgzsn1w/nQlqhDgyqjk0x6CBXhf/tdeg0X8i87niPGU9BVD//0PpyJ
         dETguxjav5/25aj9xyJRIccveppPrzHrCQGQjs1A85lmrY+BGjzsr8IH2r6Grc6hcs
         jURSA9Vu/VtAxTEwmfRnXI8zBTnLX0jm6m+u+Ci9ZFkAZUpIQQkJd954fUh53XXMYR
         LxzJJBCUnxkT0NtGMFKvfgbG482BD+613v6b1l6exMIEup7dCZAuO4RW7Lorx+ggia
         DGKY27JsslmVA==
Received: by mail-yb1-f180.google.com with SMTP id q74so12132079ybq.11
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 18:57:48 -0800 (PST)
X-Gm-Message-State: AOAM5320B/AW3qok3erQvWmbwhdJ7eSH9n0s4moHJOYNbMbIN/zlG/32
        RPUwBh41qxFA9vCXwCZVs8p13m/c1SsbptFn284=
X-Google-Smtp-Source: ABdhPJy0OddavEaZl9Ax4ZzvNXRuLtvD22rRLIEVocDta2AXsDPAzPd5BOf17cwK2ytHWZrfYFk92whX928fea+JHuU=
X-Received: by 2002:a25:b519:: with SMTP id p25mr746191ybj.195.1640228267393;
 Wed, 22 Dec 2021 18:57:47 -0800 (PST)
MIME-Version: 1.0
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com> <20211221200622.29795-1-vverma@digitalocean.com>
In-Reply-To: <20211221200622.29795-1-vverma@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 22 Dec 2021 18:57:36 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7-4UW3kMo6vcW1Mo=sZZK_AciFHSDaxsprVgjaP5GNzw@mail.gmail.com>
Message-ID: <CAPhsuW7-4UW3kMo6vcW1Mo=sZZK_AciFHSDaxsprVgjaP5GNzw@mail.gmail.com>
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

I have made some changes and applied the set to md-next. However,
I think we don't yet have enough test coverage. Please continue testing
the code and send fixes on top of it. Based on the test results, we will
see whether we can ship it in the next merge window.

Note, md-next branch doesn't have [1], so we need to cherry-pick it
for testing.

Thanks,
Song

[1] a08ed9aae8a3 ("block: fix double bio queue when merging in cached
request path")
