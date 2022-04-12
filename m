Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5034EC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 12 Apr 2022 15:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353658AbiDLPeT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Apr 2022 11:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243314AbiDLPeS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Apr 2022 11:34:18 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F112F390
        for <linux-raid@vger.kernel.org>; Tue, 12 Apr 2022 08:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649777520; x=1681313520;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zXVGuoYScRPpyhu0xTiy0biuSWgTrxq6U6tIQsSHxqs=;
  b=YhuaUNUe+D2UhAV/MAQKWlzFsyKxzs08DegxG41Z3lHcp3A6AvcaMBgB
   2cz7PcWUs7/64C1zVa211idUSLnIsMMDnOKWLfvNuSmWpammtbqcSrzLV
   WYPuyl8sUyEwEqUEU8fpeZaH14rkowxURclp6tAxE9mXb7w+132Jf9PN7
   vryeo4gtXxZU7fdaXSbL2T+zDvwsG+MylHVASgVGdNutIpu1GveSKeGSW
   RDqdsVDraXXmZxGiVeDovgh7xkC5xzE5Y8V9gPCqHyVl2yZaWI7brEw7n
   /wZxqaOqAhvfVzaNmn63bwFyern9xfddNkTDlokDVFnEWvAD9HHwJgtLP
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="262150711"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="262150711"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 08:31:59 -0700
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="572808041"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.213.8.244])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 08:31:58 -0700
Date:   Tue, 12 Apr 2022 17:31:53 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and
 linear
Message-ID: <20220412173153.00006e1a@linux.intel.com>
In-Reply-To: <CAPhsuW70YbiHXoa2yOyULX3pnUzQrc=A5DeFG2PXUY6hEOj9Bg@mail.gmail.com>
References: <20220322152339.11892-1-mariusz.tkaczyk@linux.intel.com>
        <20220322152339.11892-2-mariusz.tkaczyk@linux.intel.com>
        <CAPhsuW6dgAHAFhTwPFZOz8=uxPU9V5H=+hzNY3dXyNxtcr+PMw@mail.gmail.com>
        <20220408140032.00005fe9@linux.intel.com>
        <CAPhsuW70YbiHXoa2yOyULX3pnUzQrc=A5DeFG2PXUY6hEOj9Bg@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 8 Apr 2022 09:18:28 -0700
Song Liu <song@kernel.org> wrote:

> On Fri, Apr 8, 2022 at 7:35 AM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > On Thu, 7 Apr 2022 17:16:37 -0700
> > Song Liu <song@kernel.org> wrote:
> >  
> > > On Tue, Mar 22, 2022 at 8:24 AM Mariusz Tkaczyk
> > > <mariusz.tkaczyk@linux.intel.com> wrote:  
> > > >
> > > > Patch 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and
> > > > fail BIOs if a member is gone") allowed to finish writes earlier
> > > > (before level dependent actions) for non-redundant arrays.
> > > >
> > > > To achieve that MD_BROKEN is added to mddev->flags if drive
> > > > disappearance is detected. This is done in is_mddev_broken() which
> > > > is confusing and not consistent with other levels where
> > > > error_handler() is used. This patch adds appropriate error_handler
> > > > for raid0 and linear and adopt md_error() to the change.
> > > >
> > > > Usage of error_handler causes that disk failure can be requested
> > > > from userspace. User can fail the array via #mdadm --set-faulty
> > > > command. This is not safe and will be fixed in mdadm. It is
> > > > correctable because failed state is not recorded in the metadata.
> > > > After next assembly array will be read-write again. For safety
> > > > reason is better to keep MD_BROKEN in runtime only.
> > > >
> > > > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>  
> > >
> > > Sorry for the late response.
> > >  
> > > > ---
> > > >  drivers/md/md-linear.c | 14 +++++++++++++-
> > > >  drivers/md/md.c        |  6 +++++-
> > > >  drivers/md/md.h        | 10 ++--------
> > > >  drivers/md/raid0.c     | 14 +++++++++++++-
> > > >  4 files changed, 33 insertions(+), 11 deletions(-)
> > > >
> > > > diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> > > > index 1ff51647a682..c33cd28f1dba 100644
> > > > --- a/drivers/md/md-linear.c
> > > > +++ b/drivers/md/md-linear.c
> > > > @@ -233,7 +233,8 @@ static bool linear_make_request(struct mddev
> > > > *mddev, struct bio *bio) bio_sector < start_sector))
> > > >                 goto out_of_bounds;
> > > >
> > > > -       if (unlikely(is_mddev_broken(tmp_dev->rdev, "linear"))) {
> > > > +       if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
> > > > +               md_error(mddev, tmp_dev->rdev);  
> > >
> > > I apologize if we discussed this before. Shall we just call
> > > linear_error() here?If we go this way, we don't really need ...
> > >  
> > > >                 bio_io_error(bio);
> > > >                 return true;
> > > >         }
> > > > @@ -281,6 +282,16 @@ static void linear_status (struct seq_file
> > > > *seq, struct mddev *mddev) seq_printf(seq, " %dk rounding",
> > > > mddev->chunk_sectors / 2); }
> > > >
> > > > +static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
> > > > +{
> > > > +       if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
> > > > +               char *md_name = mdname(mddev);
> > > > +
> > > > +               pr_crit("md/linear%s: Disk failure on %pg detected,
> > > > failing array.\n",
> > > > +                       md_name, rdev->bdev);
> > > > +       }
> > > > +}
> > > > +
> > > >  static void linear_quiesce(struct mddev *mddev, int state)
> > > >  {
> > > >  }
> > > > @@ -297,6 +308,7 @@ static struct md_personality linear_personality
> > > > = .hot_add_disk   = linear_add,
> > > >         .size           = linear_size,
> > > >         .quiesce        = linear_quiesce,
> > > > +       .error_handler  = linear_error,  
> > >
> > > ... set error_handler here, and ...
> > >  
> > > >  };
> > > >
> > > >  static int __init linear_init (void)
> > > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > > index 0a89f072dae0..3354afc9d2a3 100644
> > > > --- a/drivers/md/md.c
> > > > +++ b/drivers/md/md.c
> > > > @@ -7985,7 +7985,11 @@ void md_error(struct mddev *mddev, struct
> > > > md_rdev *rdev)
> > > >
> > > >         if (!mddev->pers || !mddev->pers->error_handler)
> > > >                 return;
> > > > -       mddev->pers->error_handler(mddev,rdev);
> > > > +       mddev->pers->error_handler(mddev, rdev);
> > > > +
> > > > +       if (mddev->pers->level == 0 || mddev->pers->level ==
> > > > LEVEL_LINEAR)
> > > > +               return;  
> > >
> > > ... this check here.
> > >
> > > Did I miss something?
> > >  
> > Hi Song,
> > That is correct, we can do the same for raid0. I did it this way to
> > make it similar to redundant levels.
> > If you think that it is overhead, I can drop it.  
> 
> Yeah, it feels like more overhead to me.
> 
> I applied 2/3 and 3/3 to md-next. Please take a look and let me know
> if anything needs to be fixed.
> 
Now the first patch is just a code refactor with different error message.
I think that we can drop it. Do you agree?

Thanks,
Mariusz

