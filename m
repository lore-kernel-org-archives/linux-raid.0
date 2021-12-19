Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FB7C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 19 Dec 2021 03:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbhLSD0h (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 18 Dec 2021 22:26:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229710AbhLSD0h (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 18 Dec 2021 22:26:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639884396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VQ3YF45Y/7oH8nNPP0sHhUO+OipmO/s67AScaqTakQ0=;
        b=FoaBYrnFPThbw+EBBOvEWkiYtts8eCOL+kO4PcIoPxPqYz6L/PJU/J9FV5XMD4/uVa/uWr
        H84J30XWLLfbakdvb03h9SUN82zbFeqMGL3RYgaCNTMQySiiSmj8NXAPu3SvpOKdii8e7x
        PUqYsXkNTZzzJfCea+bpbiJZiJCBFKw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204--vrbjsINOsqgUxRDCp60jA-1; Sat, 18 Dec 2021 22:26:35 -0500
X-MC-Unique: -vrbjsINOsqgUxRDCp60jA-1
Received: by mail-ed1-f71.google.com with SMTP id f20-20020a056402355400b003f81df0975bso3878679edd.9
        for <linux-raid@vger.kernel.org>; Sat, 18 Dec 2021 19:26:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VQ3YF45Y/7oH8nNPP0sHhUO+OipmO/s67AScaqTakQ0=;
        b=v0lpQY0R48a03Bz8z1zWso3bNtR9mHQfxx/MrugjTVWOMXElASgn8wjeNzprFDmXPY
         16fmK3em67+fYu20fDRXfOfM52sbz2Dh+9JO7WYhlRKQAT9xvB7tNMPfGTKCr43i9B/o
         2l9dJ+YDhEwTs/3DVLoT5fgxfbUcsrE6HLpmsfWjaL5jAwyfpqfPS7jlVb1qH6btZIqY
         LPrBaCcNvbN2Cak3IW6JvUH8QzfrHAyixC5rPDeULTz8BYGFTCxQygRtreQfdjJzuZxY
         OTKQu1nghb7l/moQ+Qt0+brjcjXnkx8z9O6vJaRIKeTt963tu5rVRNJWA7096obRSovk
         zCCA==
X-Gm-Message-State: AOAM530U4EXPNqjErnVrqQEXFXEb35zCuuIcnQvXwR05tqcmyds8odqz
        WqU4+fvZkcfj06JcVcNy087n/4mLafmyH+v79/xzOIeod5gZdRI2Z5ZIFkEcpBDZAK1a7L02d2h
        gkQQHxaFSlctov6NjtJlnOIZC0Dg1Xm0VY+b7Zg==
X-Received: by 2002:a05:6402:278e:: with SMTP id b14mr9589091ede.354.1639884393971;
        Sat, 18 Dec 2021 19:26:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyUt4wmq4sCvgpKsjygO2C+cioArPW/JAcDke2gj9MQnoEl5j73YHvZmu4kOkCuInd63hiWUeYRbNK5MAUGFYk=
X-Received: by 2002:a05:6402:278e:: with SMTP id b14mr9589075ede.354.1639884393752;
 Sat, 18 Dec 2021 19:26:33 -0800 (PST)
MIME-Version: 1.0
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
 <20211216145222.15370-2-mariusz.tkaczyk@linux.intel.com> <3d8128c8-7cca-a805-5433-027378cdd060@linux.dev>
In-Reply-To: <3d8128c8-7cca-a805-5433-027378cdd060@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Sun, 19 Dec 2021 11:26:23 +0800
Message-ID: <CALTww2_QettJ2_=g=wNf_PMSesi0WiOz8OihFmWkMYNHe6L-dA@mail.gmail.com>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and linear
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Dec 17, 2021 at 10:00 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>
>
> On 12/16/21 10:52 PM, Mariusz Tkaczyk wrote:
> > Patch 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and fail BIOs
> > if a member is gone") allowed to finish writes earlier (before level
> > dependent actions) for non-redundant arrays.
> >
> > To achieve that MD_BROKEN is added to mddev->flags if drive disappearance
> > is detected. This is done in is_mddev_broken() which is confusing and not
> > consistent with other levels where error_handler() is used.
> > This patch adds appropriate error_handler for raid0 and linear.
> >
> > It also adopts md_error(), we only want to call .error_handler for those
> > levels. mddev->pers->sync_request is additionally checked, its existence
> > implies a level with redundancy.
> >
> > Usage of error_handler causes that disk failure can be requested from
> > userspace. User can fail the array via #mdadm --set-faulty command. This
> > is not safe and will be fixed in mdadm. It is correctable because failed
> > state is not recorded in the metadata. After next assembly array will be
> > read-write again. For safety reason is better to keep MD_BROKEN in
> > runtime only.
> >
> > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> > ---
> >   drivers/md/md-linear.c | 15 ++++++++++++++-
> >   drivers/md/md.c        |  6 +++++-
> >   drivers/md/md.h        | 10 ++--------
> >   drivers/md/raid0.c     | 15 ++++++++++++++-
> >   4 files changed, 35 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> > index 1ff51647a682..415d2615d17a 100644
> > --- a/drivers/md/md-linear.c
> > +++ b/drivers/md/md-linear.c
> > @@ -233,7 +233,8 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
> >                    bio_sector < start_sector))
> >               goto out_of_bounds;
> >
> > -     if (unlikely(is_mddev_broken(tmp_dev->rdev, "linear"))) {
> > +     if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
> > +             md_error(mddev, tmp_dev->rdev);
> >               bio_io_error(bio);
> >               return true;
> >       }
> > @@ -281,6 +282,17 @@ static void linear_status (struct seq_file *seq, struct mddev *mddev)
> >       seq_printf(seq, " %dk rounding", mddev->chunk_sectors / 2);
> >   }
> >
> > +static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
> > +{
> > +     char b[BDEVNAME_SIZE];
> > +
> > +     if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags))
> > +             pr_crit("md/linear%s: Disk failure on %s detected.\n"
> > +                     "md/linear:%s: Cannot continue, failing array.\n",
> > +                     mdname(mddev), bdevname(rdev->bdev, b),
> > +                     mdname(mddev));
> > +}
> > +
>
> Do you consider to use %pg to print block device?
>
> >   static void linear_quiesce(struct mddev *mddev, int state)
> >   {
> >   }
> > @@ -297,6 +309,7 @@ static struct md_personality linear_personality =
> >       .hot_add_disk   = linear_add,
> >       .size           = linear_size,
> >       .quiesce        = linear_quiesce,
> > +     .error_handler  = linear_error,
> >   };
> >
> >   static int __init linear_init (void)
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index e8666bdc0d28..f888ef197765 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -7982,7 +7982,11 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
> >
> >       if (!mddev->pers || !mddev->pers->error_handler)
> >               return;
> > -     mddev->pers->error_handler(mddev,rdev);
> > +     mddev->pers->error_handler(mddev, rdev);
> > +
> > +     if (!mddev->pers->sync_request)
> > +             return;
> > +
>
> What is the reason of the above change? I suppose dm event can be missed.

Hi Guoqing

What's the dm event here? From my understanding, this patch only wants
to set MD_BROKEN
in error handler. Now raid0 and linear only need to do this job in
md_error. It checks ->sync_request
here and can return for raid0 and linear. In the error handler raid0
and linear already set MD_BROKEN.

Best Regards
Xiao

