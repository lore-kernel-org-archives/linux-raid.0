Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2932EC388F9
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 07:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7389208CA
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 07:22:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Nm1HpoUR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgKKHWg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Nov 2020 02:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgKKHWc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 Nov 2020 02:22:32 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5E1C0613D1
        for <linux-raid@vger.kernel.org>; Tue, 10 Nov 2020 23:22:31 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id r17so925090ljg.5
        for <linux-raid@vger.kernel.org>; Tue, 10 Nov 2020 23:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R/Ga2OwNrTf5p5RCE3MbR0nMHuSq14fY/OOvZmVd3GE=;
        b=Nm1HpoURvc4UgCskN6SBUFdgt6q89XruJlcQGmlizpLP3hT9ge7yge6B9mwJHJHelq
         yFuKQr0Fx/myF3RIZXIHy9HNgJixafvgWguL7Zgfr4bUCC5XNHKjnwPdm3uUDSMaKfgr
         /lKGIH66e3iCzZy94pmlJo2IUJpC1ZMp24c89NwSb9rizjtraRTxAIA4tu2RFGTtut5E
         hfWDjkdluHWik9gsy/f8PP98jlHBwhtuYAfPuwHsvF/COnu7ixnofkfZ+ViIPk8Om8lU
         BaxJof5BwzVLzIa8LDcxTXNxaMyp6BNbAvBRAvT33x+zgUPFE2GTJ8NMDyfjRaOkqAPL
         MfSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R/Ga2OwNrTf5p5RCE3MbR0nMHuSq14fY/OOvZmVd3GE=;
        b=oG+pV4cgCbThuHzEVU85dBRmRKRYGoyBqvOVUt7G4DPcYNPdvzoQhDaSWhuPtCDDxf
         p+9/13Jl2lqOv8mnkaujmnWLpAzqRlykerNQryGi2DWo4Ud4tJnaRH4Yi3f7hOeyW4BM
         dVt0tXfreZGwDGYoeDNXlTFcjJxyC4zXE8MAKSLmChnf5oeVtpEw0/JABB5ULQFrn/+v
         /aBHOGTxotvO98il19k66Rn5BiVS5QkcIwYlTBmAxRNuS6ZOsQTLmjWRE+5RlbKcDXin
         LMbrzx/4+k1jPpXW6swF20H+/SGsEl1tcPQIYPrfTGeAwOCnswOq3WmW/H0dzJ+wII5J
         iFHA==
X-Gm-Message-State: AOAM532Wl463h4ZB/BIXuvwFqww5YefnUu8drnu5UjanG9/6mgLXUZ3C
        ZHwSLPTkg9sVzVmeNVk68nduQhGwwtafZ46LnIQ1Bw==
X-Google-Smtp-Source: ABdhPJzd8ghuezu9mWRZndk/TYqOhsXZJ7+wF7Sa+6pb2n8ZoHlUR5hCuoT76nIjhO5wrZdltPhUKTFoOJElywxVdio=
X-Received: by 2002:a2e:975a:: with SMTP id f26mr5979744ljj.81.1605079350237;
 Tue, 10 Nov 2020 23:22:30 -0800 (PST)
MIME-Version: 1.0
References: <20201111051658.18904-1-pankaj.gupta.linux@gmail.com>
 <20201111051658.18904-2-pankaj.gupta.linux@gmail.com> <ee573db1-33d0-b210-7205-4736de007488@molgen.mpg.de>
In-Reply-To: <ee573db1-33d0-b210-7205-4736de007488@molgen.mpg.de>
From:   Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Date:   Wed, 11 Nov 2020 08:22:19 +0100
Message-ID: <CALzYo30rZYw2r73QZR0q+HZLaHSEZ8BTxy-W-Ad8tKq4mQZozA@mail.gmail.com>
Subject: Re: [PATCH 1/3] md: improve variable names in md_flush_request()
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Pankaj Gupta <pankaj.gupta.linux@gmail.com>, song@kernel.org,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Paul,

> >   This patch improves readability by using better variable names
> >   in flush request coalescing logic.
>
> Please do not indent the commit message.

o.k

>
> > Signed-off-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> > ---
> >   drivers/md/md.c | 8 ++++----
> >   drivers/md/md.h | 6 +++---
> >   2 files changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 98bac4f304ae..167c80f98533 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -639,7 +639,7 @@ static void md_submit_flush_data(struct work_struct *ws)
> >        * could wait for this and below md_handle_request could wait for those
> >        * bios because of suspend check
> >        */
> > -     mddev->last_flush = mddev->start_flush;
> > +     mddev->prev_flush_start = mddev->start_flush;
> >       mddev->flush_bio = NULL;
> >       wake_up(&mddev->sb_wait);
> >
> > @@ -660,13 +660,13 @@ static void md_submit_flush_data(struct work_struct *ws)
> >    */
> >   bool md_flush_request(struct mddev *mddev, struct bio *bio)
> >   {
> > -     ktime_t start = ktime_get_boottime();
> > +     ktime_t req_start = ktime_get_boottime();
> >       spin_lock_irq(&mddev->lock);
> >       wait_event_lock_irq(mddev->sb_wait,
> >                           !mddev->flush_bio ||
> > -                         ktime_after(mddev->last_flush, start),
> > +                         ktime_after(mddev->prev_flush_start, req_start),
> >                           mddev->lock);
> > -     if (!ktime_after(mddev->last_flush, start)) {
> > +     if (!ktime_after(mddev->prev_flush_start, req_start)) {
> >               WARN_ON(mddev->flush_bio);
> >               mddev->flush_bio = bio;
> >               bio = NULL;
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index ccfb69868c2e..2292c847f9dd 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -495,9 +495,9 @@ struct mddev {
> >        */
> >       struct bio *flush_bio;
> >       atomic_t flush_pending;
> > -     ktime_t start_flush, last_flush; /* last_flush is when the last completed
> > -                                       * flush was started.
> > -                                       */
> > +     ktime_t start_flush, prev_flush_start; /* prev_flush_start is when the previous completed
> > +                                             * flush was started.
> > +                                             */
>
> With the new variable name, the comment could even be removed. ;-)
>
> >       struct work_struct flush_work;
> >       struct work_struct event_work;  /* used by dm to report failure event */
> >       mempool_t *serial_info_pool;
>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

Thanks,
Pankaj
>
>
> Kind regards,
>
> Paul
