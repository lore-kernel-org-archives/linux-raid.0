Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C24C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 12 Apr 2022 16:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350788AbiDLQii (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Apr 2022 12:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237070AbiDLQih (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Apr 2022 12:38:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1EDE19
        for <linux-raid@vger.kernel.org>; Tue, 12 Apr 2022 09:36:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94F5BB81A00
        for <linux-raid@vger.kernel.org>; Tue, 12 Apr 2022 16:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1930CC385A5
        for <linux-raid@vger.kernel.org>; Tue, 12 Apr 2022 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649781376;
        bh=Mx+WETgJAyu1nDQjVixGAQghV5Z060QHa0TWLj85mPI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Li362FgjXbpAR5apMsJPOC5PrpIee6YQmgLfUBhtKjOltB7EGjN/FMhFpRJ82uzaW
         4/BgMF3ckfa/anb4SM5ZZwRFuc7qemLP3+pEggSzMWqdGWlqOVZyEmb7cO7VGcgNRg
         uxA3aY67gYIARecLYZrFBaEiGGmUR9+7VNZdDMB+O6VlExw+mvePuNSihW2aZQdFqv
         lrEAJJd+0r4tHhCf+SHGtkd7OKITrSEdQSYbXxYQ/7DifItiCIDmDzOt9AaK8Z210z
         y5daB5DMWrC6ciB+vU/dz6cgynu+TpyoD/10QV0F728qnWqLRzVAPu+H+YvzrKTJt/
         CMKMdQF0fV4+w==
Received: by mail-yb1-f179.google.com with SMTP id q19so3063624ybd.6
        for <linux-raid@vger.kernel.org>; Tue, 12 Apr 2022 09:36:16 -0700 (PDT)
X-Gm-Message-State: AOAM533ua4u+mx4gzX/e2QvexCj5P13dvbdkimUfc3pjxL/Qpol/Xj99
        vB4NaSCZEI9tGt905lmswFHbi+LuyMHcMZmH0DI=
X-Google-Smtp-Source: ABdhPJxRp1RQYWlfa4GwdXZmaY5GdolWAs87a7UBFpeSM8kLUDQVCEWsq0jsWm5AiZ2+f+L/1fyzJUfu2u4Kz7B289w=
X-Received: by 2002:a25:8b81:0:b0:629:17d5:68c1 with SMTP id
 j1-20020a258b81000000b0062917d568c1mr25358166ybl.449.1649781375069; Tue, 12
 Apr 2022 09:36:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220322152339.11892-1-mariusz.tkaczyk@linux.intel.com>
 <20220322152339.11892-2-mariusz.tkaczyk@linux.intel.com> <CAPhsuW6dgAHAFhTwPFZOz8=uxPU9V5H=+hzNY3dXyNxtcr+PMw@mail.gmail.com>
 <20220408140032.00005fe9@linux.intel.com> <CAPhsuW70YbiHXoa2yOyULX3pnUzQrc=A5DeFG2PXUY6hEOj9Bg@mail.gmail.com>
 <20220412173153.00006e1a@linux.intel.com>
In-Reply-To: <20220412173153.00006e1a@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 12 Apr 2022 09:36:02 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4ZkqRQpW7UA45m_EB_sGcxL84RAg2JS5ZcZ8seGwMj+g@mail.gmail.com>
Message-ID: <CAPhsuW4ZkqRQpW7UA45m_EB_sGcxL84RAg2JS5ZcZ8seGwMj+g@mail.gmail.com>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and linear
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Apr 12, 2022 at 8:32 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Fri, 8 Apr 2022 09:18:28 -0700
> Song Liu <song@kernel.org> wrote:
>
> > On Fri, Apr 8, 2022 at 7:35 AM Mariusz Tkaczyk
> > <mariusz.tkaczyk@linux.intel.com> wrote:
> > >
> > > On Thu, 7 Apr 2022 17:16:37 -0700
> > > Song Liu <song@kernel.org> wrote:
> > >
> > > > On Tue, Mar 22, 2022 at 8:24 AM Mariusz Tkaczyk
> > > > <mariusz.tkaczyk@linux.intel.com> wrote:
> > > > >
> > > > > Patch 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and
> > > > > fail BIOs if a member is gone") allowed to finish writes earlier
> > > > > (before level dependent actions) for non-redundant arrays.
> > > > >
> > > > > To achieve that MD_BROKEN is added to mddev->flags if drive
> > > > > disappearance is detected. This is done in is_mddev_broken() which
> > > > > is confusing and not consistent with other levels where
> > > > > error_handler() is used. This patch adds appropriate error_handler
> > > > > for raid0 and linear and adopt md_error() to the change.
> > > > >
> > > > > Usage of error_handler causes that disk failure can be requested
> > > > > from userspace. User can fail the array via #mdadm --set-faulty
> > > > > command. This is not safe and will be fixed in mdadm. It is
> > > > > correctable because failed state is not recorded in the metadata.
> > > > > After next assembly array will be read-write again. For safety
> > > > > reason is better to keep MD_BROKEN in runtime only.
> > > > >
> > > > > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> > > >
> > > > Sorry for the late response.
> > > >
> > > > > ---
> > > > >  drivers/md/md-linear.c | 14 +++++++++++++-
> > > > >  drivers/md/md.c        |  6 +++++-
> > > > >  drivers/md/md.h        | 10 ++--------
> > > > >  drivers/md/raid0.c     | 14 +++++++++++++-
> > > > >  4 files changed, 33 insertions(+), 11 deletions(-)
> > > > >
> > > > > diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> > > > > index 1ff51647a682..c33cd28f1dba 100644
> > > > > --- a/drivers/md/md-linear.c
> > > > > +++ b/drivers/md/md-linear.c
> > > > > @@ -233,7 +233,8 @@ static bool linear_make_request(struct mddev
> > > > > *mddev, struct bio *bio) bio_sector < start_sector))
> > > > >                 goto out_of_bounds;
> > > > >
> > > > > -       if (unlikely(is_mddev_broken(tmp_dev->rdev, "linear"))) {
> > > > > +       if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
> > > > > +               md_error(mddev, tmp_dev->rdev);
> > > >
> > > > I apologize if we discussed this before. Shall we just call
> > > > linear_error() here?If we go this way, we don't really need ...
> > > >
> > > > >                 bio_io_error(bio);
> > > > >                 return true;
> > > > >         }
> > > > > @@ -281,6 +282,16 @@ static void linear_status (struct seq_file
> > > > > *seq, struct mddev *mddev) seq_printf(seq, " %dk rounding",
> > > > > mddev->chunk_sectors / 2); }
> > > > >
> > > > > +static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
> > > > > +{
> > > > > +       if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
> > > > > +               char *md_name = mdname(mddev);
> > > > > +
> > > > > +               pr_crit("md/linear%s: Disk failure on %pg detected,
> > > > > failing array.\n",
> > > > > +                       md_name, rdev->bdev);
> > > > > +       }
> > > > > +}
> > > > > +
> > > > >  static void linear_quiesce(struct mddev *mddev, int state)
> > > > >  {
> > > > >  }
> > > > > @@ -297,6 +308,7 @@ static struct md_personality linear_personality
> > > > > = .hot_add_disk   = linear_add,
> > > > >         .size           = linear_size,
> > > > >         .quiesce        = linear_quiesce,
> > > > > +       .error_handler  = linear_error,
> > > >
> > > > ... set error_handler here, and ...
> > > >
> > > > >  };
> > > > >
> > > > >  static int __init linear_init (void)
> > > > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > > > index 0a89f072dae0..3354afc9d2a3 100644
> > > > > --- a/drivers/md/md.c
> > > > > +++ b/drivers/md/md.c
> > > > > @@ -7985,7 +7985,11 @@ void md_error(struct mddev *mddev, struct
> > > > > md_rdev *rdev)
> > > > >
> > > > >         if (!mddev->pers || !mddev->pers->error_handler)
> > > > >                 return;
> > > > > -       mddev->pers->error_handler(mddev,rdev);
> > > > > +       mddev->pers->error_handler(mddev, rdev);
> > > > > +
> > > > > +       if (mddev->pers->level == 0 || mddev->pers->level ==
> > > > > LEVEL_LINEAR)
> > > > > +               return;
> > > >
> > > > ... this check here.
> > > >
> > > > Did I miss something?
> > > >
> > > Hi Song,
> > > That is correct, we can do the same for raid0. I did it this way to
> > > make it similar to redundant levels.
> > > If you think that it is overhead, I can drop it.
> >
> > Yeah, it feels like more overhead to me.
> >
> > I applied 2/3 and 3/3 to md-next. Please take a look and let me know
> > if anything needs to be fixed.
> >
> Now the first patch is just a code refactor with different error message.
> I think that we can drop it. Do you agree?

Yes, I think we can drop it.

Thanks,
Song
