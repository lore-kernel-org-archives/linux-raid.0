Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FFA3C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 17 Dec 2021 08:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhLQIiV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Dec 2021 03:38:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:24699 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhLQIiV (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 17 Dec 2021 03:38:21 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="263884456"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="263884456"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 00:38:01 -0800
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="683311076"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.21.206])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 00:38:00 -0800
Date:   Fri, 17 Dec 2021 09:37:55 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     song@kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/3] raid5: introduce MD_BROKEN
Message-ID: <20211217093755.00007264@linux.intel.com>
In-Reply-To: <3d5fe975-265f-557e-5d13-88ef6b06bcba@linux.dev>
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
        <20211216145222.15370-4-mariusz.tkaczyk@linux.intel.com>
        <3d5fe975-265f-557e-5d13-88ef6b06bcba@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Guoqing,

On Fri, 17 Dec 2021 10:26:27 +0800
Guoqing Jiang <guoqing.jiang@linux.dev> wrote:

> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 1240a5c16af8..8b5561811431 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -690,6 +690,9 @@ static int has_failed(struct r5conf *conf)
> >   {
> >   	int degraded;
> >   
> > +	if (test_bit(MD_BROKEN, &conf->mddev->flags))
> > +		return 1;
> > +
> >   	if (conf->mddev->reshape_position == MaxSector)
> >   		return conf->mddev->degraded > conf->max_degraded;
> >   
> > @@ -2877,34 +2880,29 @@ static void raid5_error(struct mddev
> > *mddev, struct md_rdev *rdev) unsigned long flags;
> >   	pr_debug("raid456: error called\n");
> >   
> > -	spin_lock_irqsave(&conf->device_lock, flags);
> > -
> > -	if (test_bit(In_sync, &rdev->flags) &&
> > -	    mddev->degraded == conf->max_degraded) {
> > -		/*
> > -		 * Don't allow to achieve failed state
> > -		 * Don't try to recover this device
> > -		 */
> > -		conf->recovery_disabled = mddev->recovery_disabled;
> > -		spin_unlock_irqrestore(&conf->device_lock, flags);
> > -		return;
> > -	}
> > +	pr_crit("md/raid:%s: Disk failure on %s, disabling
> > device.\n",
> > +		mdname(mddev), bdevname(rdev->bdev, b));
> >   
> > +	spin_lock_irqsave(&conf->device_lock, flags);
> >   	set_bit(Faulty, &rdev->flags);
> >   	clear_bit(In_sync, &rdev->flags);
> >   	mddev->degraded = raid5_calc_degraded(conf);
> > +
> > +	if (has_failed(conf)) {
> > +		set_bit(MD_BROKEN, &mddev->flags);  
> 
> What about other callers of has_failed? Do they need to set BROKEN
> flag? Or set the flag in has_failed if it returns true, just FYI.
> 

The function checks rdev->state for faulty. There are two, places
where it can be set:
- raid5_error (handled here)
- raid5_spare_active (not a case IMO).

I left it in raid5_error to be consistent with other levels.
I think that moving it t has_failed is safe but I don't see any
additional value in it.
I see that in raid5_error we hold device_lock. It is not true for
all has_failed calls.

Do you have any recommendations?

Thanks,
Mariusz 

