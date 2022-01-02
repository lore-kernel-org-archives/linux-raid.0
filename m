Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E952C433F5
	for <linux-raid@archiver.kernel.org>; Sun,  2 Jan 2022 00:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbiABAMG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 1 Jan 2022 19:12:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45504 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiABAMF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 1 Jan 2022 19:12:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71886B8076E
        for <linux-raid@vger.kernel.org>; Sun,  2 Jan 2022 00:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD9AC36AEA
        for <linux-raid@vger.kernel.org>; Sun,  2 Jan 2022 00:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641082323;
        bh=FjrTwDOdJ3Y6vEa4NZufP1gH1rxvRSJmVD/GDHpXVW8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BpjGTr3pUuXAA6eJUlIYqQa5agV6QhhuDb1xOChyP54YQ072bBdGfk+G6xiGMWCrG
         jyS7lr8eEVZCfBE3akhEG6ZYXEqQ59nSvHriHBV9ArNk/a+bDmEl+JrDbEX86X+PL2
         836w31IEue3VcPKpSvODeQ7c/gZRGRTnuGUgGqcmXY2Iv1/mzBhIGGjrv/ECYNLdJr
         o4KwtfenIN77PNAofLANMAOcbCFBSLc26lYhFgbzdazVULsecV2crI5VmP1qC1LAnF
         9ASu2cX85DlrXqRYcRNSk1Ylrr7n/pp+3dLimUM8mZVPi8MTtvw1SHdex5fgK9zJT4
         rx0NDu1qG9pgQ==
Received: by mail-yb1-f175.google.com with SMTP id o185so62327969ybo.12
        for <linux-raid@vger.kernel.org>; Sat, 01 Jan 2022 16:12:03 -0800 (PST)
X-Gm-Message-State: AOAM533iEXEMxAvxQeBHRI2iP/8NgaK+wpDffREmEyd5OUplfPmZwJdz
        zl2DK/mdPZ3JqgkAUtrZixxUc1iCNrlHgyJYuE4=
X-Google-Smtp-Source: ABdhPJxAKE0o5OmJxFL1Ce6mnOsYTkirBU3OBXDGZuZMH9kQ0Hmu2oJcNcSDlaJuKGNLIL8bdaiCvPgQFXcfJFTWLHM=
X-Received: by 2002:a25:8e10:: with SMTP id p16mr39013191ybl.219.1641082322239;
 Sat, 01 Jan 2022 16:12:02 -0800 (PST)
MIME-Version: 1.0
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com> <CAPhsuW7-4UW3kMo6vcW1Mo=sZZK_AciFHSDaxsprVgjaP5GNzw@mail.gmail.com>
In-Reply-To: <CAPhsuW7-4UW3kMo6vcW1Mo=sZZK_AciFHSDaxsprVgjaP5GNzw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Sat, 1 Jan 2022 16:11:51 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6CR_+4pJx=Faf5KwusAoy1vOte9qQKBWy6fwNkp1PETA@mail.gmail.com>
Message-ID: <CAPhsuW6CR_+4pJx=Faf5KwusAoy1vOte9qQKBWy6fwNkp1PETA@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] md: add support for REQ_NOWAIT
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rgoldwyn@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Dec 22, 2021 at 6:57 PM Song Liu <song@kernel.org> wrote:
>
> On Tue, Dec 21, 2021 at 12:06 PM Vishal Verma <vverma@digitalocean.com> wrote:
> >
> > commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
> > for checking whether a given bdev supports handling of REQ_NOWAIT or not.
> > Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable
> > it for linear target") added support for REQ_NOWAIT for dm. This uses
> > a similar approach to incorporate REQ_NOWAIT for md based bios.
> >
> > This patch was tested using t/io_uring tool within FIO. A nvme drive
> > was partitioned into 2 partitions and a simple raid 0 configuration
> > /dev/md0 was created.
> >
> > md0 : active raid0 nvme4n1p1[1] nvme4n1p2[0]
> >       937423872 blocks super 1.2 512k chunks
> >
> > Before patch:
> >
> > $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
> >
> > Running top while the above runs:
> >
> > $ ps -eL | grep $(pidof io_uring)
> >
> >   38396   38396 pts/2    00:00:00 io_uring
> >   38396   38397 pts/2    00:00:15 io_uring
> >   38396   38398 pts/2    00:00:13 iou-wrk-38397
> >
> > We can see iou-wrk-38397 io worker thread created which gets created
> > when io_uring sees that the underlying device (/dev/md0 in this case)
> > doesn't support nowait.
> >
> > After patch:
> >
> > $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
> >
> > Running top while the above runs:
> >
> > $ ps -eL | grep $(pidof io_uring)
> >
> >   38341   38341 pts/2    00:10:22 io_uring
> >   38341   38342 pts/2    00:10:37 io_uring
> >
> > After running this patch, we don't see any io worker thread
> > being created which indicated that io_uring saw that the
> > underlying device does support nowait. This is the exact behaviour
> > noticed on a dm device which also supports nowait.
> >
> > For all the other raid personalities except raid0, we would need
> > to train pieces which involves make_request fn in order for them
> > to correctly handle REQ_NOWAIT.
> >
> > Signed-off-by: Vishal Verma <vverma@digitalocean.com>
>
> I have made some changes and applied the set to md-next. However,
> I think we don't yet have enough test coverage. Please continue testing
> the code and send fixes on top of it. Based on the test results, we will
> see whether we can ship it in the next merge window.
>
> Note, md-next branch doesn't have [1], so we need to cherry-pick it
> for testing.

I went through all these changes again and tested many (but not all)
cases. The latest version is available in md-next branch.

Vishal, please run tests on this version and send fixes if anything
is broken.

Thanks,
Song
