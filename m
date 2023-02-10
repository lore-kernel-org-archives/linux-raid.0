Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7970C05027
	for <linux-raid@archiver.kernel.org>; Fri, 10 Feb 2023 17:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjBJRdN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Feb 2023 12:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbjBJRc5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Feb 2023 12:32:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B37B795E4
        for <linux-raid@vger.kernel.org>; Fri, 10 Feb 2023 09:32:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FC8BB824BF
        for <linux-raid@vger.kernel.org>; Fri, 10 Feb 2023 17:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12F5C433D2
        for <linux-raid@vger.kernel.org>; Fri, 10 Feb 2023 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676050373;
        bh=uR+un5xT0wIT5naOrWtLnGT74dgskOqkzlPUth4zSoA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Bf0lwHoPR4jHz5n/d8WWHRpCOeZJt1gbz+EQJisCvDZk7oOF903IciqPfy97a+7xp
         Wocmbw4rG3FcVZLkBhQykGW2axleBMgnADUFRHdRhmXk6JnRIcCKBhm67E9qwHRiv5
         co/jpx5Ec4XsXGFB/hlPoCmPi6QV0TwDk0XHYUUusRTYtYDMr9tHemGpWD0zM+RwVE
         bN8tjqdyjwl9lLJ7BR4GueFJ73KnO8UooJSVBoDJXnh4ih2FInwEljJdY2WjYeVDjW
         7stO412Ezfgvjxa39BnaKkeITzgmVjEggt83Pj7FjRwRLQK0DX076JQbn/JdEuwOw2
         C9rj4LVL+kgFQ==
Received: by mail-lf1-f41.google.com with SMTP id bi36so9388623lfb.8
        for <linux-raid@vger.kernel.org>; Fri, 10 Feb 2023 09:32:52 -0800 (PST)
X-Gm-Message-State: AO0yUKVyNN9McHZIEyk0qN4IEC/7upyXE9Inlb3XpTZ4SADVKyXP/P/m
        zzqTV88s6YuUGz+8fGkEFn+hu28EMMdq4OKXzU0=
X-Google-Smtp-Source: AK7set9aCv6UIvsrm+d6cDV5jte5U3PiU44Wdmavrqt5z2GCRLSXG4EDCK+a+OeE3BvXAYU021J/a9OrtNEdy1BDjpE=
X-Received: by 2002:ac2:4e4c:0:b0:4cc:a1e3:c04b with SMTP id
 f12-20020ac24e4c000000b004cca1e3c04bmr2931294lfr.15.1676050370953; Fri, 10
 Feb 2023 09:32:50 -0800 (PST)
MIME-Version: 1.0
References: <20230118005319.147-1-jonathan.derrick@linux.dev> <80812f87-a743-2deb-3d43-d07fcc4ce895@linux.dev>
In-Reply-To: <80812f87-a743-2deb-3d43-d07fcc4ce895@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Fri, 10 Feb 2023 09:32:38 -0800
X-Gmail-Original-Message-ID: <CAPhsuW65Qai4Dq-wzrcMbCR-s7J9astse1K8U8TwoAuxD4FyzQ@mail.gmail.com>
Message-ID: <CAPhsuW65Qai4Dq-wzrcMbCR-s7J9astse1K8U8TwoAuxD4FyzQ@mail.gmail.com>
Subject: Re: [PATCH] md: Use optimal I/O size for last bitmap page
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     linux-raid@vger.kernel.org,
        Sushma Kalakota <sushma.kalakota@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jonathan,

On Thu, Feb 9, 2023 at 12:38 PM Jonathan Derrick
<jonathan.derrick@linux.dev> wrote:
>
> Hi Song,
>
> Any thoughts on this?

I am really sorry that I missed this patch.

>
> On 1/17/2023 5:53 PM, Jonathan Derrick wrote:
> > From: Jon Derrick <jonathan.derrick@linux.dev>
> >
> > If the bitmap space has enough room, size the I/O for the last bitmap
> > page write to the optimal I/O size for the storage device. The expanded
> > write is checked that it won't overrun the data or metadata.
> >
> > This change helps increase performance by preventing unnecessary
> > device-side read-mod-writes due to non-atomic write unit sizes.
> >
> > Ex biosnoop log. Device lba size 512, optimal size 4k:
> > Before:
> > Time        Process        PID     Device      LBA        Size      Lat
> > 0.843734    md0_raid10     5267    nvme0n1   W 24         3584      1.17
> > 0.843933    md0_raid10     5267    nvme1n1   W 24         3584      1.36
> > 0.843968    md0_raid10     5267    nvme1n1   W 14207939968 4096      0.01
> > 0.843979    md0_raid10     5267    nvme0n1   W 14207939968 4096      0.02
> >
> > After:
> > Time        Process        PID     Device      LBA        Size      Lat
> > 18.374244   md0_raid10     6559    nvme0n1   W 24         4096      0.01
> > 18.374253   md0_raid10     6559    nvme1n1   W 24         4096      0.01
> > 18.374300   md0_raid10     6559    nvme0n1   W 11020272296 4096      0.01
> > 18.374306   md0_raid10     6559    nvme1n1   W 11020272296 4096      0.02

Do we see significant improvements from io benchmarks?

IIUC, fewer future HDDs will use 512B LBA size.We probably don't need
such optimizations in the future.

Thanks,
Song

> >
> > Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
> > ---
> >  drivers/md/md-bitmap.c | 27 ++++++++++++++++++---------
> >  1 file changed, 18 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> > index e7cc6ba1b657..569297ea9b99 100644
> > --- a/drivers/md/md-bitmap.c
> > +++ b/drivers/md/md-bitmap.c
> > @@ -220,6 +220,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
> >       rdev = NULL;
> >       while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
> >               int size = PAGE_SIZE;
> > +             int optimal_size = PAGE_SIZE;
> >               loff_t offset = mddev->bitmap_info.offset;
> >
> >               bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
> > @@ -228,9 +229,14 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
> >                       int last_page_size = store->bytes & (PAGE_SIZE-1);
> >                       if (last_page_size == 0)
> >                               last_page_size = PAGE_SIZE;
> > -                     size = roundup(last_page_size,
> > -                                    bdev_logical_block_size(bdev));
> > +                     size = roundup(last_page_size, bdev_logical_block_size(bdev));
> > +                     if (bdev_io_opt(bdev) > bdev_logical_block_size(bdev))
> > +                             optimal_size = roundup(last_page_size, bdev_io_opt(bdev));
> > +                     else
> > +                             optimal_size = size;
> >               }
> > +
> > +
> >               /* Just make sure we aren't corrupting data or
> >                * metadata
> >                */
> > @@ -246,9 +252,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
> >                               goto bad_alignment;
> >               } else if (offset < 0) {
> >                       /* DATA  BITMAP METADATA  */
> > -                     if (offset
> > -                         + (long)(page->index * (PAGE_SIZE/512))
> > -                         + size/512 > 0)
> > +                     loff_t off = offset + (long)(page->index * (PAGE_SIZE/512));
> > +                     if (size != optimal_size &&
> > +                         off + optimal_size/512 <= 0)
> > +                             size = optimal_size;
> > +                     else if (off + size/512 > 0)
> >                               /* bitmap runs in to metadata */
> >                               goto bad_alignment;
> >                       if (rdev->data_offset + mddev->dev_sectors
> > @@ -257,10 +265,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
> >                               goto bad_alignment;
> >               } else if (rdev->sb_start < rdev->data_offset) {
> >                       /* METADATA BITMAP DATA */
> > -                     if (rdev->sb_start
> > -                         + offset
> > -                         + page->index*(PAGE_SIZE/512) + size/512
> > -                         > rdev->data_offset)
> > +                     loff_t off = rdev->sb_start + offset + page->index*(PAGE_SIZE/512);
> > +                     if (size != optimal_size &&
> > +                         off + optimal_size/512 <= rdev->data_offset)
> > +                             size = optimal_size;
> > +                     else if (off + size/512 > rdev->data_offset)
> >                               /* bitmap runs in to data */
> >                               goto bad_alignment;
> >               } else {
