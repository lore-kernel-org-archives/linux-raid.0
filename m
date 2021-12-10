Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FC5C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 07:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbhLJHW0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Dec 2021 02:22:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49112 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237181AbhLJHWZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Dec 2021 02:22:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AD5DB82767
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 07:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD13C341CA
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 07:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639120729;
        bh=Tz37VLHjq8t0V4j3bMRL4B89VosEpskuN002+JUS8aA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YTGl3PGAUcYVM0+bC4RvV/qmBTQ6lMqzG0waS/grRE7O+DMmVrKdnnzj1UHIuNWZu
         LR4K97G39RfNFoY5koHUraZMXWjcX4InTOKlsgBs/Ji1Osschu5KSv9qiq7RJb5IOf
         zPbfCTZ4z4tdnwraMoY55RNrEf9AD0UtBvk6GJXN9kYAA7+yRkkaqQIOhE+MbqCjaw
         H08ul/CEm/Rdzb/xa5RpScq9wtFx0rPNgvx0s440R+bUqDTz5uiWUt+40WHgwnWFge
         7Ylp/ahOgtGm612um+DTSqM7D98hLbVGD4Z3/hrjYehoAgQMjiImy1RM9x85AnPFTE
         CYYimPzNcftMg==
Received: by mail-yb1-f179.google.com with SMTP id 131so19228335ybc.7
        for <linux-raid@vger.kernel.org>; Thu, 09 Dec 2021 23:18:49 -0800 (PST)
X-Gm-Message-State: AOAM5323FDLPq9oqZspFS2FdKDs24kc0I++8M3rD+gCiajqJ6IguFwgF
        B8lcxnS08aahg78otvsjZX764zrYS2Q+CMiu1cM=
X-Google-Smtp-Source: ABdhPJzAQ5gNI2GBTMag8KSqp4YKUefc/EqxccXVCenKIalpy72DKArORmRybhLRDE9VgbU0isXy1KIPJI1xjTmBYYI=
X-Received: by 2002:a25:850b:: with SMTP id w11mr1085048ybk.208.1639120728181;
 Thu, 09 Dec 2021 23:18:48 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com> <20211110181441.9263-4-vverma@digitalocean.com>
 <CAPhsuW5drRBWOV9-i7cQWHAwSe5qHff5k23Y2-LsNGS_s8updw@mail.gmail.com>
In-Reply-To: <CAPhsuW5drRBWOV9-i7cQWHAwSe5qHff5k23Y2-LsNGS_s8updw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 9 Dec 2021 23:18:37 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4bg4cNfXZ1-8KO90ZY5gxvKsz_aB7vWG2-LJS854_WVw@mail.gmail.com>
Message-ID: <CAPhsuW4bg4cNfXZ1-8KO90ZY5gxvKsz_aB7vWG2-LJS854_WVw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 9, 2021 at 6:16 PM Song Liu <song@kernel.org> wrote:
>
> On Wed, Nov 10, 2021 at 10:15 AM Vishal Verma <vverma@digitalocean.com> wrote:
> >
> > Returns EAGAIN in case the raid456 driver would block
> > waiting for situations like:
> >
> >   - Reshape operation,
> >   - Discard operation.
> >
> > Signed-off-by: Vishal Verma <vverma@digitalocean.com>
> > ---
> >  drivers/md/raid5.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 9c1a5877cf9f..fa64ee315241 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -5710,6 +5710,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
> >                 int d;
> >         again:
> >                 sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0);
> > +               /* Bail out if REQ_NOWAIT is set */
> > +               if (bi->bi_opf & REQ_NOWAIT) {
> > +                       bio_wouldblock_error(bi);
> > +                       return;
> > +               }
>
> This is not right. raid5_get_active_stripe() gets refcount on the sh,
> we cannot simply
> return here. I think we need the logic after raid5_release_stripe()
> and before schedule().
>
> >                 prepare_to_wait(&conf->wait_for_overlap, &w,
> >                                 TASK_UNINTERRUPTIBLE);
> >                 set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
> > @@ -5820,6 +5825,15 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
> >         bi->bi_next = NULL;
> >
> >         md_account_bio(mddev, &bi);
> > +       /* Bail out if REQ_NOWAIT is set */
> > +       if (bi->bi_opf & REQ_NOWAIT &&
> > +           conf->reshape_progress != MaxSector &&
> > +           mddev->reshape_backwards
> > +           ? logical_sector < conf->reshape_safe
> > +           : logical_sector >= conf->reshape_safe) {

There is also an Operator Precedence bug here. "&&" goes before "?
:", so we need
"()" around the "? :" block.

Thanks,
Song
