Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7928DC433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Apr 2022 14:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236967AbiDHOhj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Apr 2022 10:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236970AbiDHOh3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Apr 2022 10:37:29 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88EA215907
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 07:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649428524; x=1680964524;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0JsIqQZ3vyoi4KSTerZ6HC3MpGFSCYpVQVS5wzky4JE=;
  b=hcW1jHP0XEQ0rYqKbhdM8baYN2KuyrikmAtsyVmSC8sLG0+Ltzct53yR
   lxDxtKd4JkguhWp3yFJ3mIk9xEEO9PchVTEkBj+GqhnCHJYmYW+ZI0aJd
   Gn9azWLS7ZAC518RTtnfM0QlGBVjJ44h8nsWi/WXo53BZ6SurD+s0KvG+
   DdFuql7g7TiMTtrqxBP6Q3fj4+sV/2pqILobFOJWS5xuY29uYtx6mlRoO
   xdmhvwT8TWD5OCnzex3jscXHtLSMA0dMBOH9asdjsxWjDp0VU3DHi+bpC
   3YteadGVJYMyGqbS3wW345/pfcIQllaGzfLUp2S/GyRvIHJkJSPRZpHzq
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241538540"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="241538540"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 07:35:24 -0700
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="550521271"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.213.26.67])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 07:35:22 -0700
Date:   Fri, 8 Apr 2022 16:35:17 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and
 linear
Message-ID: <20220408140032.00005fe9@linux.intel.com>
In-Reply-To: <CAPhsuW6dgAHAFhTwPFZOz8=uxPU9V5H=+hzNY3dXyNxtcr+PMw@mail.gmail.com>
References: <20220322152339.11892-1-mariusz.tkaczyk@linux.intel.com>
 <20220322152339.11892-2-mariusz.tkaczyk@linux.intel.com>
 <CAPhsuW6dgAHAFhTwPFZOz8=uxPU9V5H=+hzNY3dXyNxtcr+PMw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 7 Apr 2022 17:16:37 -0700
Song Liu <song@kernel.org> wrote:

> On Tue, Mar 22, 2022 at 8:24 AM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > Patch 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and
> > fail BIOs if a member is gone") allowed to finish writes earlier
> > (before level dependent actions) for non-redundant arrays.
> >
> > To achieve that MD_BROKEN is added to mddev->flags if drive
> > disappearance is detected. This is done in is_mddev_broken() which
> > is confusing and not consistent with other levels where
> > error_handler() is used. This patch adds appropriate error_handler
> > for raid0 and linear and adopt md_error() to the change.
> >
> > Usage of error_handler causes that disk failure can be requested
> > from userspace. User can fail the array via #mdadm --set-faulty
> > command. This is not safe and will be fixed in mdadm. It is
> > correctable because failed state is not recorded in the metadata.
> > After next assembly array will be read-write again. For safety
> > reason is better to keep MD_BROKEN in runtime only.
> >
> > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>  
> 
> Sorry for the late response.
> 
> > ---
> >  drivers/md/md-linear.c | 14 +++++++++++++-
> >  drivers/md/md.c        |  6 +++++-
> >  drivers/md/md.h        | 10 ++--------
> >  drivers/md/raid0.c     | 14 +++++++++++++-
> >  4 files changed, 33 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> > index 1ff51647a682..c33cd28f1dba 100644
> > --- a/drivers/md/md-linear.c
> > +++ b/drivers/md/md-linear.c
> > @@ -233,7 +233,8 @@ static bool linear_make_request(struct mddev
> > *mddev, struct bio *bio) bio_sector < start_sector))
> >                 goto out_of_bounds;
> >
> > -       if (unlikely(is_mddev_broken(tmp_dev->rdev, "linear"))) {
> > +       if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
> > +               md_error(mddev, tmp_dev->rdev);  
> 
> I apologize if we discussed this before. Shall we just call
> linear_error() here?If we go this way, we don't really need ...
> 
> >                 bio_io_error(bio);
> >                 return true;
> >         }
> > @@ -281,6 +282,16 @@ static void linear_status (struct seq_file
> > *seq, struct mddev *mddev) seq_printf(seq, " %dk rounding",
> > mddev->chunk_sectors / 2); }
> >
> > +static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
> > +{
> > +       if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
> > +               char *md_name = mdname(mddev);
> > +
> > +               pr_crit("md/linear%s: Disk failure on %pg detected,
> > failing array.\n",
> > +                       md_name, rdev->bdev);
> > +       }
> > +}
> > +
> >  static void linear_quiesce(struct mddev *mddev, int state)
> >  {
> >  }
> > @@ -297,6 +308,7 @@ static struct md_personality linear_personality
> > = .hot_add_disk   = linear_add,
> >         .size           = linear_size,
> >         .quiesce        = linear_quiesce,
> > +       .error_handler  = linear_error,  
> 
> ... set error_handler here, and ...
> 
> >  };
> >
> >  static int __init linear_init (void)
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 0a89f072dae0..3354afc9d2a3 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -7985,7 +7985,11 @@ void md_error(struct mddev *mddev, struct
> > md_rdev *rdev)
> >
> >         if (!mddev->pers || !mddev->pers->error_handler)
> >                 return;
> > -       mddev->pers->error_handler(mddev,rdev);
> > +       mddev->pers->error_handler(mddev, rdev);
> > +
> > +       if (mddev->pers->level == 0 || mddev->pers->level ==
> > LEVEL_LINEAR)
> > +               return;  
> 
> ... this check here.
> 
> Did I miss something?
> 
Hi Song,
That is correct, we can do the same for raid0. I did it this way to
make it similar to redundant levels.
If you think that it is overhead, I can drop it.

Thanks,
Mariusz

