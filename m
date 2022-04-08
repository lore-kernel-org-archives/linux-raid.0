Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA11FC433F5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Apr 2022 16:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiDHQUu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Apr 2022 12:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiDHQUt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Apr 2022 12:20:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A175C101F10
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 09:18:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A816B82BEF
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 16:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E559C385A6
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 16:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649434723;
        bh=6BbOxj4sFpCt5K3Z4yimNNp6Y5zgpdP6RZIZSPZiUps=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IEgyvr8iR8FpT2oQwx4AlSiWoMExDbJuKgnGLjjIIioy/B4Y34EzNioGUxDhPahiV
         iQQLUu0jqKL4S08uvnQBPMRDI9PK13i+kvCZa1XpFf+mp714NadAJmHp2qvO1Y3ui2
         MdK8S4F3nXZV46Ed/cjZauqLZuSOo/dBbD6FrVH2h6WKDIjQrVLUvi4bnmC+BYP9UH
         Rr01i4k/CLdWYOilxtEOvRxtxcEfuBdKVw6q5X4BjAY0MbNA9KavnHWr6a08B5TEDj
         Pj4xcbnbZBvK/wgx8x6IenbBKycs3LSs+Z6upsymGbsBQLu9aYCQrfZgCWw/0dNRzN
         XCAGorDNTuwMA==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2ebef4de9fcso13461027b3.12
        for <linux-raid@vger.kernel.org>; Fri, 08 Apr 2022 09:18:42 -0700 (PDT)
X-Gm-Message-State: AOAM533pZUFT2lYrEmBie2+bn0SFC1uiiwMXQ32IvGutMqaD5ZyvyxdI
        F5Th5dmC9/Oss8MlKWU+w/fVb5Ip3+tu3E55/yg=
X-Google-Smtp-Source: ABdhPJz7QAw6ab7Gb67UpIskJwFgXqO/tbdAcnFkWC4WrYCikiCTa1eTyA2eiuolIdCFrpmx1zv95Ji3pO0cPXLjIg8=
X-Received: by 2002:a0d:d610:0:b0:2eb:70c9:e7b0 with SMTP id
 y16-20020a0dd610000000b002eb70c9e7b0mr17600772ywd.447.1649434722015; Fri, 08
 Apr 2022 09:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220322152339.11892-1-mariusz.tkaczyk@linux.intel.com>
 <20220322152339.11892-2-mariusz.tkaczyk@linux.intel.com> <CAPhsuW6dgAHAFhTwPFZOz8=uxPU9V5H=+hzNY3dXyNxtcr+PMw@mail.gmail.com>
 <20220408140032.00005fe9@linux.intel.com>
In-Reply-To: <20220408140032.00005fe9@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 8 Apr 2022 09:18:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW70YbiHXoa2yOyULX3pnUzQrc=A5DeFG2PXUY6hEOj9Bg@mail.gmail.com>
Message-ID: <CAPhsuW70YbiHXoa2yOyULX3pnUzQrc=A5DeFG2PXUY6hEOj9Bg@mail.gmail.com>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and linear
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Apr 8, 2022 at 7:35 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Thu, 7 Apr 2022 17:16:37 -0700
> Song Liu <song@kernel.org> wrote:
>
> > On Tue, Mar 22, 2022 at 8:24 AM Mariusz Tkaczyk
> > <mariusz.tkaczyk@linux.intel.com> wrote:
> > >
> > > Patch 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and
> > > fail BIOs if a member is gone") allowed to finish writes earlier
> > > (before level dependent actions) for non-redundant arrays.
> > >
> > > To achieve that MD_BROKEN is added to mddev->flags if drive
> > > disappearance is detected. This is done in is_mddev_broken() which
> > > is confusing and not consistent with other levels where
> > > error_handler() is used. This patch adds appropriate error_handler
> > > for raid0 and linear and adopt md_error() to the change.
> > >
> > > Usage of error_handler causes that disk failure can be requested
> > > from userspace. User can fail the array via #mdadm --set-faulty
> > > command. This is not safe and will be fixed in mdadm. It is
> > > correctable because failed state is not recorded in the metadata.
> > > After next assembly array will be read-write again. For safety
> > > reason is better to keep MD_BROKEN in runtime only.
> > >
> > > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> >
> > Sorry for the late response.
> >
> > > ---
> > >  drivers/md/md-linear.c | 14 +++++++++++++-
> > >  drivers/md/md.c        |  6 +++++-
> > >  drivers/md/md.h        | 10 ++--------
> > >  drivers/md/raid0.c     | 14 +++++++++++++-
> > >  4 files changed, 33 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> > > index 1ff51647a682..c33cd28f1dba 100644
> > > --- a/drivers/md/md-linear.c
> > > +++ b/drivers/md/md-linear.c
> > > @@ -233,7 +233,8 @@ static bool linear_make_request(struct mddev
> > > *mddev, struct bio *bio) bio_sector < start_sector))
> > >                 goto out_of_bounds;
> > >
> > > -       if (unlikely(is_mddev_broken(tmp_dev->rdev, "linear"))) {
> > > +       if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
> > > +               md_error(mddev, tmp_dev->rdev);
> >
> > I apologize if we discussed this before. Shall we just call
> > linear_error() here?If we go this way, we don't really need ...
> >
> > >                 bio_io_error(bio);
> > >                 return true;
> > >         }
> > > @@ -281,6 +282,16 @@ static void linear_status (struct seq_file
> > > *seq, struct mddev *mddev) seq_printf(seq, " %dk rounding",
> > > mddev->chunk_sectors / 2); }
> > >
> > > +static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
> > > +{
> > > +       if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
> > > +               char *md_name = mdname(mddev);
> > > +
> > > +               pr_crit("md/linear%s: Disk failure on %pg detected,
> > > failing array.\n",
> > > +                       md_name, rdev->bdev);
> > > +       }
> > > +}
> > > +
> > >  static void linear_quiesce(struct mddev *mddev, int state)
> > >  {
> > >  }
> > > @@ -297,6 +308,7 @@ static struct md_personality linear_personality
> > > = .hot_add_disk   = linear_add,
> > >         .size           = linear_size,
> > >         .quiesce        = linear_quiesce,
> > > +       .error_handler  = linear_error,
> >
> > ... set error_handler here, and ...
> >
> > >  };
> > >
> > >  static int __init linear_init (void)
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 0a89f072dae0..3354afc9d2a3 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -7985,7 +7985,11 @@ void md_error(struct mddev *mddev, struct
> > > md_rdev *rdev)
> > >
> > >         if (!mddev->pers || !mddev->pers->error_handler)
> > >                 return;
> > > -       mddev->pers->error_handler(mddev,rdev);
> > > +       mddev->pers->error_handler(mddev, rdev);
> > > +
> > > +       if (mddev->pers->level == 0 || mddev->pers->level ==
> > > LEVEL_LINEAR)
> > > +               return;
> >
> > ... this check here.
> >
> > Did I miss something?
> >
> Hi Song,
> That is correct, we can do the same for raid0. I did it this way to
> make it similar to redundant levels.
> If you think that it is overhead, I can drop it.

Yeah, it feels like more overhead to me.

I applied 2/3 and 3/3 to md-next. Please take a look and let me know
if anything needs to be fixed.

Thanks,
Song
