Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0D2C61DA3
	for <linux-raid@archiver.kernel.org>; Tue, 21 Feb 2023 05:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbjBUFg6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Feb 2023 00:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbjBUFg4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Feb 2023 00:36:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB1323861
        for <linux-raid@vger.kernel.org>; Mon, 20 Feb 2023 21:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676957765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2HrPtdx8QHZkdGIlHKGd5BL9YwmSE4S8Zz3/5wHXLYU=;
        b=hnambNTI0zcQCN9PIZiAv+RGcPbUyCLx+nP3LG7VEOxF7Ni7gxBjf5URcISVx7k2llU/cN
        ttQXj6SQVBc+7u87ShitcbnoOuVuvwTnvJFlYzyd/dlLhn496ge4QLN+cjMoM39wnx5yaE
        uD63o/n2Im8kX9N/HqYkUro4g0E8j/8=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-198-96fMa-dVNfqBITVONSMy0Q-1; Tue, 21 Feb 2023 00:36:04 -0500
X-MC-Unique: 96fMa-dVNfqBITVONSMy0Q-1
Received: by mail-pf1-f200.google.com with SMTP id k24-20020aa790d8000000b005a8ad1228d4so1528741pfk.10
        for <linux-raid@vger.kernel.org>; Mon, 20 Feb 2023 21:36:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676957762;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2HrPtdx8QHZkdGIlHKGd5BL9YwmSE4S8Zz3/5wHXLYU=;
        b=OF1ffqvBxOfqqgoT6mUM3KQygAqP9vhwUkNA2EBhMbbBmvxP+1ZNDBv3jlmvtK0Kww
         KSOLNZPTh2AtVnXLLYUyYXZkXiwBoiWCRbt9dBbIrczKUx3+eaWYcp9a2HDhOlhm4vay
         wcpvdn4b+b9LArhpG6U5nchjMiznpWGjS5Mc8jyXAAT4jroQhzhYZ5IbL5R++xYSFaTe
         uWB+29dS5pvbm6Rcwu8r/hrZmeic0qQUhB0g+TnXiIGGgf5vDkzarxlHpwr1eUHCx23S
         o9iAPG/nB6a3wKBgoAIIe23O3SW+3z7yHCWAcoFse/45UGLm5n1oe+Dh4Jteaef81sMn
         1ntQ==
X-Gm-Message-State: AO0yUKWzXyTmXd5xVpSocKoC8ErKAWgo7c7FiUgG9ouRHMpW7c5X+b3P
        oFLPtQml58GCO3FDicA+SOYn21iOzptvPVC5JvSenr1P+IEn9pcwiZncqQm8EzWVr0dsL549KH5
        HBNXlddmjeQUth6MQ6tsejAnjBoaNDIWISgVGBw==
X-Received: by 2002:a62:8203:0:b0:5aa:59ee:bb5c with SMTP id w3-20020a628203000000b005aa59eebb5cmr319779pfd.25.1676957762307;
        Mon, 20 Feb 2023 21:36:02 -0800 (PST)
X-Google-Smtp-Source: AK7set/RJNATLriX7V5qZJtIuQ+/mF8K1e/NMmNMZAMUmKw/M4ndxdARCbosZgwr2l5G9QXZYdS8U7jEEX3Bl5c3Lk4=
X-Received: by 2002:a62:8203:0:b0:5aa:59ee:bb5c with SMTP id
 w3-20020a628203000000b005aa59eebb5cmr319776pfd.25.1676957761963; Mon, 20 Feb
 2023 21:36:01 -0800 (PST)
MIME-Version: 1.0
References: <20230217183139.106-1-jonathan.derrick@linux.dev>
 <CALTww2-3t-Tyjh1yAZhM+6Rwgh7t2=EFk1hOpvnTuiN91yyfDg@mail.gmail.com> <fd88c91e-f501-005d-3eb2-98a019d3db9e@linux.dev>
In-Reply-To: <fd88c91e-f501-005d-3eb2-98a019d3db9e@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 21 Feb 2023 13:35:50 +0800
Message-ID: <CALTww28rr6FdO=-E7G=MM7hT5QszpTc6hQH9grQ+aiuUixtY5A@mail.gmail.com>
Subject: Re: [PATCH v2] md: Use optimal I/O size for last bitmap page
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Feb 21, 2023 at 11:31 AM Jonathan Derrick
<jonathan.derrick@linux.dev> wrote:
>
>
>
> On 2/20/2023 7:38 PM, Xiao Ni wrote:
> > On Sat, Feb 18, 2023 at 2:36 AM Jonathan Derrick
> > <jonathan.derrick@linux.dev> wrote:
> >>
> >> From: Jon Derrick <jonathan.derrick@linux.dev>
> >>
> >> If the bitmap space has enough room, size the I/O for the last bitmap
> >> page write to the optimal I/O size for the storage device. The expanded
> >> write is checked that it won't overrun the data or metadata.
> >>
> >> This change helps increase performance by preventing unnecessary
> >> device-side read-mod-writes due to non-atomic write unit sizes.
> >
> > Hi Jonathan
> >
> > Thanks for your patch.
> >
> > Could you explain more about the how the optimal io size can affect
> > the device-side read-mod-writes?
>
> The effects of device-side read-mod-writes are a device-specific implementation detail.
> This is not something expected to be universal as its an abstracted detail.
>
> However the NVMe spec allows the storage namespace to provide implementation
> hints about its underlying media.
>
> Both NPWA and NOWS are used in the NVMe driver, where NOWS provides the
> optimal_io hint:
>
> Per NVMe Command Set 1.0b, Figure 97
> Namespace Preferred Write Alignment (NPWA): This field indicates the recommended
> write alignment in logical blocks for this namespace
>
> Namespace Optimal Write Size (NOWS): This field indicates the size in logical blocks
> for optimal write performance for this namespace.
>
> Per 5.8.2.1 Improved I/O examples (non-normative)
> When constructing write operations, the host should minimally construct writes
> that meet the recommendations of NPWG and NPWA, but may achieve optimal write
> performance by constructing writes that meet the recommendation of NOWS.
>
>
> It then makes sense that an NVMe drive would provide optimal io size hints
> that matches its underlying media unit size, such that sub-4k writes might
> invoke a device-side read-mod-write whereas 4k writes become atomic.

Thanks very much for the detailed explanation.

If I want to try it myself, it must use nvme disks that have 4k
optimal_io_size, right?
I tried to check in many environments with this command:
cat /sys/block/nvme4n1/queue/optimal_io_size (it shows 0)

So I need to find a machine that is optimal_io_size is 4096, right?

Regards
Xiao
>
> >
> > Regards
> > Xiao
> >>
> >> Example Intel/Solidigm P5520
> >> Raid10, Chunk-size 64M, bitmap-size 57228 bits
> >>
> >> $ mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/nvme{0,1,2,3}n1 --assume-clean --bitmap=internal --bitmap-chunk=64M
> >> $ fio --name=test --direct=1 --filename=/dev/md0 --rw=randwrite --bs=4k --runtime=60
> >>
> >> Without patch:
> >>   write: IOPS=1676, BW=6708KiB/s (6869kB/s)(393MiB/60001msec); 0 zone resets
> >>
> >> With patch:
> >>   write: IOPS=15.7k, BW=61.4MiB/s (64.4MB/s)(3683MiB/60001msec); 0 zone resets
> >>
> >> Biosnoop:
> >> Without patch:
> >> Time        Process        PID     Device      LBA        Size      Lat
> >> 1.410377    md0_raid10     6900    nvme0n1   W 16         4096      0.02
> >> 1.410387    md0_raid10     6900    nvme2n1   W 16         4096      0.02
> >> 1.410374    md0_raid10     6900    nvme3n1   W 16         4096      0.01
> >> 1.410381    md0_raid10     6900    nvme1n1   W 16         4096      0.02
> >> 1.410411    md0_raid10     6900    nvme1n1   W 115346512  4096      0.01
> >> 1.410418    md0_raid10     6900    nvme0n1   W 115346512  4096      0.02
> >> 1.410915    md0_raid10     6900    nvme2n1   W 24         3584      0.43
> >> 1.410935    md0_raid10     6900    nvme3n1   W 24         3584      0.45
> >> 1.411124    md0_raid10     6900    nvme1n1   W 24         3584      0.64
> >> 1.411147    md0_raid10     6900    nvme0n1   W 24         3584      0.66
> >> 1.411176    md0_raid10     6900    nvme3n1   W 2019022184 4096      0.01
> >> 1.411189    md0_raid10     6900    nvme2n1   W 2019022184 4096      0.02
> >>
> >> With patch:
> >> Time        Process        PID     Device      LBA        Size      Lat
> >> 5.747193    md0_raid10     727     nvme0n1   W 16         4096      0.01
> >> 5.747192    md0_raid10     727     nvme1n1   W 16         4096      0.02
> >> 5.747195    md0_raid10     727     nvme3n1   W 16         4096      0.01
> >> 5.747202    md0_raid10     727     nvme2n1   W 16         4096      0.02
> >> 5.747229    md0_raid10     727     nvme3n1   W 1196223704 4096      0.02
> >> 5.747224    md0_raid10     727     nvme0n1   W 1196223704 4096      0.01
> >> 5.747279    md0_raid10     727     nvme0n1   W 24         4096      0.01
> >> 5.747279    md0_raid10     727     nvme1n1   W 24         4096      0.02
> >> 5.747284    md0_raid10     727     nvme3n1   W 24         4096      0.02
> >> 5.747291    md0_raid10     727     nvme2n1   W 24         4096      0.02
> >> 5.747314    md0_raid10     727     nvme2n1   W 2234636712 4096      0.01
> >> 5.747317    md0_raid10     727     nvme1n1   W 2234636712 4096      0.02
> >>
> >> Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
> >> ---
> >> v1->v2: Add more information to commit message
> >>
> >>  drivers/md/md-bitmap.c | 27 ++++++++++++++++++---------
> >>  1 file changed, 18 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> >> index e7cc6ba1b657..569297ea9b99 100644
> >> --- a/drivers/md/md-bitmap.c
> >> +++ b/drivers/md/md-bitmap.c
> >> @@ -220,6 +220,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
> >>         rdev = NULL;
> >>         while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
> >>                 int size = PAGE_SIZE;
> >> +               int optimal_size = PAGE_SIZE;
> >>                 loff_t offset = mddev->bitmap_info.offset;
> >>
> >>                 bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
> >> @@ -228,9 +229,14 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
> >>                         int last_page_size = store->bytes & (PAGE_SIZE-1);
> >>                         if (last_page_size == 0)
> >>                                 last_page_size = PAGE_SIZE;
> >> -                       size = roundup(last_page_size,
> >> -                                      bdev_logical_block_size(bdev));
> >> +                       size = roundup(last_page_size, bdev_logical_block_size(bdev));
> >> +                       if (bdev_io_opt(bdev) > bdev_logical_block_size(bdev))
> >> +                               optimal_size = roundup(last_page_size, bdev_io_opt(bdev));
> >> +                       else
> >> +                               optimal_size = size;
> >>                 }
> >> +
> >> +
> >>                 /* Just make sure we aren't corrupting data or
> >>                  * metadata
> >>                  */
> >> @@ -246,9 +252,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
> >>                                 goto bad_alignment;
> >>                 } else if (offset < 0) {
> >>                         /* DATA  BITMAP METADATA  */
> >> -                       if (offset
> >> -                           + (long)(page->index * (PAGE_SIZE/512))
> >> -                           + size/512 > 0)
> >> +                       loff_t off = offset + (long)(page->index * (PAGE_SIZE/512));
> >> +                       if (size != optimal_size &&
> >> +                           off + optimal_size/512 <= 0)
> >> +                               size = optimal_size;
> >> +                       else if (off + size/512 > 0)
> >>                                 /* bitmap runs in to metadata */
> >>                                 goto bad_alignment;
> >>                         if (rdev->data_offset + mddev->dev_sectors
> >> @@ -257,10 +265,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
> >>                                 goto bad_alignment;
> >>                 } else if (rdev->sb_start < rdev->data_offset) {
> >>                         /* METADATA BITMAP DATA */
> >> -                       if (rdev->sb_start
> >> -                           + offset
> >> -                           + page->index*(PAGE_SIZE/512) + size/512
> >> -                           > rdev->data_offset)
> >> +                       loff_t off = rdev->sb_start + offset + page->index*(PAGE_SIZE/512);
> >> +                       if (size != optimal_size &&
> >> +                           off + optimal_size/512 <= rdev->data_offset)
> >> +                               size = optimal_size;
> >> +                       else if (off + size/512 > rdev->data_offset)
> >>                                 /* bitmap runs in to data */
> >>                                 goto bad_alignment;
> >>                 } else {
> >> --
> >> 2.27.0
> >>
> >
>

