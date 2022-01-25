Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82B8C433FE
	for <linux-raid@archiver.kernel.org>; Tue, 25 Jan 2022 08:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454369AbiAYI7L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Jan 2022 03:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453970AbiAYI4s (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 Jan 2022 03:56:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00917C058CA8
        for <linux-raid@vger.kernel.org>; Tue, 25 Jan 2022 00:00:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACA05B815F3
        for <linux-raid@vger.kernel.org>; Tue, 25 Jan 2022 08:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664D1C340E0
        for <linux-raid@vger.kernel.org>; Tue, 25 Jan 2022 08:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643097656;
        bh=8qb5EVc8JFmsQun4iGlfXHIFxW8CZ58iA6DtAyBfWbo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MN+UlJZLV3cMBG97iq7Ap7U/p8/oOyFvax6t3H8NXDUbHVBrifN94L5eop7pBxA6s
         ldZQCwRP7BhKQ1UE34guUQSjsl55Uf7VpRdQdzO/LfRRhRdPmpf4hMKZNNkw5T8N3j
         wVy6v+KlXU+RUHosLx3OFVJTNQDITe6r0gmL3zJB/2O0EWYsEM07fkkqATySEvkkOQ
         yh72moYFP7M/9gdoHRKZh6aIgc81EypenFu9DNyyF4vatARH0zTrEh3UBLr2ahGp/v
         PPLkZ2SsmkNF5CxSsv10rjj2Q0j0y9P1lgdBygtE6GXRkvaTozSBnlbzitgZBNczSz
         jKD8zeEOIulLA==
Received: by mail-yb1-f174.google.com with SMTP id i62so12819074ybg.5
        for <linux-raid@vger.kernel.org>; Tue, 25 Jan 2022 00:00:56 -0800 (PST)
X-Gm-Message-State: AOAM530YdH/2fBRbeGV7RoJ7e1eeh/OFzAzuJYgTBo7QrvPtGgGJ8eP/
        QGvOrfFzPfYLqVrTnmTf6Y656i2zFTtgHH6syw0=
X-Google-Smtp-Source: ABdhPJzE0ChTuzHVQV+U/wv6ARwukapx8IFQmD8hO10Utrm5YQG3XSGHnX1S3Gu/DHqdZz0HjBdopf5B3i+qfwg6+kU=
X-Received: by 2002:a25:bc0e:: with SMTP id i14mr28436551ybh.670.1643097655496;
 Tue, 25 Jan 2022 00:00:55 -0800 (PST)
MIME-Version: 1.0
References: <747C2684-B570-473E-9146-E8AB53102236@filmlight.ltd.uk>
 <20220123180058.372f72ce@gecko.fritz.box> <70008df6-ef90-6e8d-8a57-9b30077508e7@molgen.mpg.de>
 <C5CCA1CE-E120-4BCB-925E-981DBA7A29F4@filmlight.ltd.uk>
In-Reply-To: <C5CCA1CE-E120-4BCB-925E-981DBA7A29F4@filmlight.ltd.uk>
From:   Song Liu <song@kernel.org>
Date:   Tue, 25 Jan 2022 00:00:44 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6wc2iPfzb+9DZ130RqNWfOmxJpkA59x58WN1s18Uuahg@mail.gmail.com>
Message-ID: <CAPhsuW6wc2iPfzb+9DZ130RqNWfOmxJpkA59x58WN1s18Uuahg@mail.gmail.com>
Subject: Re: [dm-devel] Raid0 performance regression
To:     Roger Willcocks <roger@filmlight.ltd.uk>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, dm-devel@redhat.com,
        linux-raid <linux-raid@vger.kernel.org>,
        Lukas Straub <lukasstraub2@web.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jan 24, 2022 at 8:49 AM Roger Willcocks <roger@filmlight.ltd.uk> wrote:
>
>
>
> > On 23 Jan 2022, at 21:34, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> >
> > Dear Roger,
> >
> >
> > Am 23.01.22 um 19:00 schrieb Lukas Straub:
> >> CC'ing Song Liu (md-raid maintainer) and linux-raid mailing list.
> >> On Fri, 21 Jan 2022 16:38:03 +0000 Roger Willcocks wrote:
> >
> >>> we noticed a thirty percent drop in performance on one of our raid
> >>> arrays when switching from CentOS 6.5 to 8.4; it uses raid0-like
> >
> > For those outside the CentOS universe, what Linux kernel versions are those?
> >
>
> 2.6.32 (and backported changes) and 4.18.0 (sim.)
>
> >>> striping to balance (by time) access to a pair of hardware raid-6
> >>> arrays. The underlying issue is also present in the native raid0
> >>> driver so herewith the gory details; I'd appreciate your thoughts.
> >>>
> >>> --
> >>>
> >>> blkdev_direct_IO() calls submit_bio() which calls an outermost
> >>> generic_make_request() (aka submit_bio_noacct()).
> >>>
> >>> md_make_request() calls blk_queue_split() which cuts an incoming
> >>> request into two parts with the first no larger than get_max_io_size()
> >>> bytes (which in the case of raid0, is the chunk size):
> >>>
> >>>   R -> AB
> >>>   blk_queue_split() gives the second part 'B' to generic_make_request()
> >>> to worry about later and returns the first part 'A'.
> >>>
> >>> md_make_request() then passes 'A' to a more specific request handler,
> >>> In this case raid0_make_request().
> >>>
> >>> raid0_make_request() cuts its incoming request into two parts at the
> >>> next chunk boundary:
> >>>
> >>> A -> ab
> >>>
> >>> it then fixes up the device (chooses a physical device) for 'a', and
> >>> gives both parts, separately, to generic make request()
> >>>
> >>> This is where things go awry, because 'b' is still targetted to the
> >>> original device (same as 'B'), but 'B' was queued before 'b'. So we
> >>> end up with:
> >>>
> >>>   R -> Bab
> >>>
> >>> The outermost generic_make_request() then cuts 'B' at
> >>> get_max_io_size(), and the process repeats. Ascii art follows:
> >>>
> >>>
> >>>     /---------------------------------------------------/   incoming rq
> >>>
> >>>     /--------/--------/--------/--------/--------/------/   max_io_size
> >>>       |--------|--------|--------|--------|--------|--------|--------| chunks
> >>>
> >>> |...=====|---=====|---=====|---=====|---=====|---=====|--......| rq out
> >>>       a    b  c     d  e     f  g     h  i     j  k     l
> >>>
> >>> Actual submission order for two-disk raid0: 'aeilhd' and 'cgkjfb'
> >>>
> >>> --
> >>>
> >>> There are several potential fixes -
> >>>
> >>> simplest is to set raid0 blk_queue_max_hw_sectors() to UINT_MAX
> >>> instead of chunk_size, so that raid0_make_request() receives the
> >>> entire transfer length and cuts it up at chunk boundaries;
> >>>
> >>> neatest is for raid0_make_request() to recognise that 'b' doesn't
> >>> cross a chunk boundary so it can be sent directly to the physical
> >>> device;
> >>>
> >>> and correct is for blk_queue_split to requeue 'A' before 'B'.
> >>>
> >>> --
> >>>
> >>> There's also a second issue - with large raid0 chunk size (256K), the
> >>> segments submitted to the physical device are at least 128K and
> >>> trigger the early unplug code in blk_mq_make_request(), so the
> >>> requests are never merged. There are legitimate reasons for a large
> >>> chunk size so this seems unhelpful.
> >>>
> >>> --
> >>>
> >>> As I said, I'd appreciate your thoughts.
> >
> > Thank you for the report and the analysis.
> >
> > Is the second issue also a regression? If not, I suggest to split it into a separate thread.
> >
>
> Yes this is also a regression, both issues above have to be addressed to recover the
> original performance.
>
> Specifically, an md raid0 array with 256K chunk size interleaving two x 12-disk raid6
> devices (Adaptec 3154 controller, 50MB files stored contiguously on disk, four threads)
> can achieve a sequential read rate of 3800 MB/sec with the (very) old 6.5 kernel; this
> falls to 2500 MB/sec with the relatively newer kernel.
>
> This change to raid0.c:
>
> -               blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
> +              blk_queue_max_hw_sectors(mddev->queue, UINT_MAX);

I guess this is OK.

>
> improves things somewhat, the sub-chunk requests are now submitted in order but we
> still only get 2800 MB/sec because no merging takes place; the controller struggles to
> keep up with the large number of sub-chunk transfers. This additional change to
> blk-mq.c:
>
> -               if (request_count >= BLK_MAX_REQUEST_COUNT || (last &&
> +               if (request_count >= BLK_MAX_REQUEST_COUNT || (false && last &&
>                     blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
>                         blk_flush_plug_list(plug, false);

We recently did some optimization for BLK_MAX_REQUEST_COUNT ([1] and some
follow up). We can probably do something similar for BLK_PLUG_FLUSH_SIZE.

Thanks,
Song

[1] https://lore.kernel.org/all/20210907230338.227903-1-songliubraving@fb.com/
