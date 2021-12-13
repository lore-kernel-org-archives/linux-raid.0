Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD957C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 13 Dec 2021 05:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhLMF47 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Dec 2021 00:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbhLMF4w (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Dec 2021 00:56:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DECC061751
        for <linux-raid@vger.kernel.org>; Sun, 12 Dec 2021 21:56:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 27917CE0DE5
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 05:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243F6C00446
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 05:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639375007;
        bh=49UVTmpsLgneuupvdq9ocj/zqQL2amIT9xAEW4mh8Uc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=V76XNrJbUoXevetThwIuGgwo5KFSwDPcsTCJY41phzhYVPEGGTQWGaGBmgzOQONKO
         +zNlhc9hToMoEtSOupgGG28p/W9IInVvFp00JjJ5fld9VNJdlGhDDRHZIlYAvOQTVF
         Yjq18m5H0xc/gAGO2yhGHvoJAg3ACrC3kKGZM7NPWQnqzDDy6ZbsIgC1edz/cvlxE2
         MxiCcr938x3a26Rb4m+iWs5X17yyqJbdvoW723B6Oo7Jid3A1iy0dYcqq/qDSJTWXR
         +U4DW3OAE4T+0cQNKzbGxPA+GA8PnaXMa2x/Psws39OkxwnkyMgfW0jLq6x71wiVvr
         Tlh78MFGQn5rw==
Received: by mail-yb1-f178.google.com with SMTP id v64so35717302ybi.5
        for <linux-raid@vger.kernel.org>; Sun, 12 Dec 2021 21:56:47 -0800 (PST)
X-Gm-Message-State: AOAM5303aqt0JVG3U9K6MJl4OMaydL2lQIZRFaE8PelL44w95OLDrNzv
        V23rhV5HW2RHOrDZ3sUyc5YkfRLyqrGL3n6zXrM=
X-Google-Smtp-Source: ABdhPJzjNQRUK8UOrd0XXk7ldbCINcS0OehNBV3d1ZiB4Go/KaxNexFprc0asAPvbXUaKeC4vFGQ0aUwXbd686an2B8=
X-Received: by 2002:a25:bf8f:: with SMTP id l15mr30822264ybk.670.1639375006266;
 Sun, 12 Dec 2021 21:56:46 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com> <20211110181441.9263-4-vverma@digitalocean.com>
 <CAPhsuW5drRBWOV9-i7cQWHAwSe5qHff5k23Y2-LsNGS_s8updw@mail.gmail.com> <2354ab61-0d13-aec5-a45f-23c5cd3db319@digitalocean.com>
In-Reply-To: <2354ab61-0d13-aec5-a45f-23c5cd3db319@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Sun, 12 Dec 2021 21:56:35 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7r-JX+zOadzbzLDa0WxZdLws9=mTbPc0ci6qNfRBxgjA@mail.gmail.com>
Message-ID: <CAPhsuW7r-JX+zOadzbzLDa0WxZdLws9=mTbPc0ci6qNfRBxgjA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Dec 10, 2021 at 10:26 AM Vishal Verma <vverma@digitalocean.com> wrote:
>
>
> On 12/9/21 7:16 PM, Song Liu wrote:
> > On Wed, Nov 10, 2021 at 10:15 AM Vishal Verma <vverma@digitalocean.com> wrote:
> >> Returns EAGAIN in case the raid456 driver would block
> >> waiting for situations like:
> >>
> >>    - Reshape operation,
> >>    - Discard operation.
> >>
> >> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
> >> ---
> >>   drivers/md/raid5.c | 14 ++++++++++++++
> >>   1 file changed, 14 insertions(+)
> >>
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index 9c1a5877cf9f..fa64ee315241 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -5710,6 +5710,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
> >>                  int d;
> >>          again:
> >>                  sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0);
> >> +               /* Bail out if REQ_NOWAIT is set */
> >> +               if (bi->bi_opf & REQ_NOWAIT) {
> >> +                       bio_wouldblock_error(bi);
> >> +                       return;
> >> +               }
> > This is not right. raid5_get_active_stripe() gets refcount on the sh,
> > we cannot simply
> > return here. I think we need the logic after raid5_release_stripe()
> > and before schedule().
> >
> >>                  prepare_to_wait(&conf->wait_for_overlap, &w,
> >>                                  TASK_UNINTERRUPTIBLE);
> >>                  set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
> >> @@ -5820,6 +5825,15 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
> >>          bi->bi_next = NULL;
> >>
> >>          md_account_bio(mddev, &bi);
> >> +       /* Bail out if REQ_NOWAIT is set */
> >> +       if (bi->bi_opf & REQ_NOWAIT &&
> >> +           conf->reshape_progress != MaxSector &&
> >> +           mddev->reshape_backwards
> >> +           ? logical_sector < conf->reshape_safe
> >> +           : logical_sector >= conf->reshape_safe) {
> >> +               bio_wouldblock_error(bi);
> >> +               return true;
> >> +       }
> > This is also problematic, and is the trigger of those error messages.
> > We only want to trigger -EAGAIN when logical_sector is between
> > reshape_progress and reshape_safe.
> >
> > Just to clarify, did you mean doing something like:
> > if (bi->bi_opf & REQ_NOWAIT &&
> > +           conf->reshape_progress != MaxSector &&
> > +           (mddev->reshape_backwards
> > +           ? (logical_sector > conf->reshape_progress && logical_sector < conf->reshape_safe)
> > +           : logical_sector >= conf->reshape_safe)) {

I think this should be
  :   (logical_sector >= conf->reshape_safe && logical_sector <
conf->reshape_progress)

> > +               bio_wouldblock_error(bi);
> > +               return true;
> > +
> >
> > Please let me know if these make sense.
> >
> > Thanks,
> > Song
> >
> >
> > Makes sense. Thanks for your feedback. I'll incorporate it and test.

When testing, please make sure we hit all different conditions with REQ_NOWAIT.

Thanks,
Song
