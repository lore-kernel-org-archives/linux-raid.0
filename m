Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2D0C04FF3
	for <linux-raid@archiver.kernel.org>; Mon, 24 May 2021 04:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 511DA610CE
	for <linux-raid@archiver.kernel.org>; Mon, 24 May 2021 04:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhEXEkQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 May 2021 00:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhEXEkP (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 24 May 2021 00:40:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42A0C611CB;
        Mon, 24 May 2021 04:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621831128;
        bh=/zWIZI3ezQM1Dl4LaC/TzYoxUOHy+syxhazkSgtgJF8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZF+LOPrAnrLDCgopnhj0LMIECYdOElH0IDNpJlvbFHj6aiityQiaI00NlsEpt1/2a
         79UTpUQy8n/KISa8tNXX7Z9hlmGyiJDx6r9Ls590oI5MkXKEaRJ9TCnrI+LaFdztIV
         VLF9u6zrYC3LxtM97eFLx9raX7CIkxWVdn5frXF9tijAwOG8MJrqwSugNS6DlUgeqE
         Frwwcw2XGYFSn7nfS1GVUaWNsqVYMcu42ZfhS/m3y+gl6EC+97s8YT8G2xz2vXI+aP
         DMw5P/fAxj3cXfqwpoMdWA5L7Ke4glGGrS3L+ISGfqFiapOX960FAu7CJlpOs/wiqT
         uOXDbj4/F1DyQ==
Received: by mail-lf1-f52.google.com with SMTP id v8so33788601lft.8;
        Sun, 23 May 2021 21:38:48 -0700 (PDT)
X-Gm-Message-State: AOAM533UWLDHfxCWHohCOsLQFfTLj7w4SzEfG7a4WqvUO+j1p0MVaZrC
        SyDbaAi6p7KJYHTAbPFuTFmw3hw0BMUG5GkGSno=
X-Google-Smtp-Source: ABdhPJyLNqdxUBHx9zXjZwtz6wj73jwvOrpWkNHgy6aHajFit9H2vAMzKEAIrUmX5a4lvwXpEwG07ltEmWpq5qCYwYE=
X-Received: by 2002:a19:6a10:: with SMTP id u16mr9425700lfu.281.1621831126540;
 Sun, 23 May 2021 21:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210519062215.4111256-1-hch@lst.de> <1102825331.165797.1621422078235@ox.hosteurope.de>
In-Reply-To: <1102825331.165797.1621422078235@ox.hosteurope.de>
From:   Song Liu <song@kernel.org>
Date:   Sun, 23 May 2021 21:38:35 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7W7NfBTHY3A87py1No=FOPZgxMP4Ms43Re3uRnT0JzkQ@mail.gmail.com>
Message-ID: <CAPhsuW7W7NfBTHY3A87py1No=FOPZgxMP4Ms43Re3uRnT0JzkQ@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: remove an incorect assert in in_chunk_boundary
To:     wp1083705-spam02 wp1083705-spam02 <spam02@dazinger.net>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, May 19, 2021 at 4:36 AM wp1083705-spam02 wp1083705-spam02
<spam02@dazinger.net> wrote:
>
>
> > Christoph Hellwig <hch@lst.de> hat am 19.05.2021 08:22 geschrieben:
> >
> >
> > Now that the original bdev is stored in the bio this assert is incorrect
> > and will trigge for any partitioned raid5 device.
> >
> > Reported-by:  Florian D. <spam02@dazinger.net>
> > Fixes: 309dca309fc3 ("block: store a block_device pointer in struct bio"),
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/md/raid5.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 841e1c1aa5e6..7d4ff8a5c55e 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -5311,8 +5311,6 @@ static int in_chunk_boundary(struct mddev *mddev, struct bio *bio)
> >       unsigned int chunk_sectors;
> >       unsigned int bio_sectors = bio_sectors(bio);
> >
> > -     WARN_ON_ONCE(bio->bi_bdev->bd_partno);
> > -
> >       chunk_sectors = min(conf->chunk_sectors, conf->prev_chunk_sectors);
> >       return  chunk_sectors >=
> >               ((sector & (chunk_sectors - 1)) + bio_sectors);
> > --
> > 2.30.2
>
> yes, this solves it, I can confirm with this patch the error/warning message when booting linux-5.12 is gone!

Applied to md-fixes. Thanks all.

@ Florian, would you like to update the Reported-by tag (with your
full name and/or
different email)?

Thanks,
Song
