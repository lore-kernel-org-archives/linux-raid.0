Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB05C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 14 Feb 2022 09:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244499AbiBNJnF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Feb 2022 04:43:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244556AbiBNJl7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Feb 2022 04:41:59 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2134F66FB9
        for <linux-raid@vger.kernel.org>; Mon, 14 Feb 2022 01:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644831465; x=1676367465;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AzK+7Hwp+kkLxNcjr402DsBCbFNokUJLu8NQvCXqaCs=;
  b=Dd2/wI+Qh2CKGGC0e0sHJQlBcv98Lfy8GRvxsrwApHYq+IrwjcbkaS7j
   lGc1kaATfpUpzYTOdcednEXA5P8MhzSLFGegFXS++l3/+Gv4vJfzF8RFo
   bRxLcdurmlOhsH363UsskySrgmtw8bfAEPL4O016L1Bl0p1WpuA29e9Xy
   8BtCL2wnAnhdGB9PNib7lJogxs+LoIlIaYJC7UBYpoN8mmXmOboCYPS+Y
   6hYppgmq7nF4DDikKvLkmC4gznBAiHFrdGo1wsmRsXnBAe5pl3qWIdMzf
   +6xWXT9KMNZxFIZLL3aKHdfFUR6v5P+KAggvUTkw8JwiMdF1NsYlC5JIh
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="250259041"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="250259041"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 01:37:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="485325173"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.18.154])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 01:37:43 -0800
Date:   Mon, 14 Feb 2022 10:37:38 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     song@kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and
 linear
Message-ID: <20220214103738.000017f8@linux.intel.com>
In-Reply-To: <de8e69dc-4e44-de6f-d3d2-9d52935c9b35@linux.dev>
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
        <20220127153912.26856-2-mariusz.tkaczyk@linux.intel.com>
        <de8e69dc-4e44-de6f-d3d2-9d52935c9b35@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, 12 Feb 2022 09:12:00 +0800
Guoqing Jiang <guoqing.jiang@linux.dev> wrote:

> On 1/27/22 11:39 PM, Mariusz Tkaczyk wrote:
> > Patch 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and
> > fail BIOs if a member is gone") allowed to finish writes earlier
> > (before level dependent actions) for non-redundant arrays.
> >
> > To achieve that MD_BROKEN is added to mddev->flags if drive
> > disappearance is detected. This is done in is_mddev_broken() which
> > is confusing and not consistent with other levels where
> > error_handler() is used. This patch adds appropriate error_handler
> > for raid0 and linear.  
> 
> I think the purpose of them are quite different, as said before, 
> error_handler
> is mostly against rdev while is_mddev_broken is for mddev though it
> needs to test rdev first.

I changed is_mddev_broken to is_rdev_broken, because it checks the
device now. On error it calls md_error and later error_handler.
I unified error handling for each level. Do you consider it as wrong?

> 
> > It also adopts md_error(), we only want to call .error_handler for
> > those levels. mddev->pers->sync_request is additionally checked,
> > its existence implies a level with redundancy.
> >
> > Usage of error_handler causes that disk failure can be requested
> > from userspace. User can fail the array via #mdadm --set-faulty
> > command. This is not safe and will be fixed in mdadm.  
> 
> What is the safe issue here? It would betterr to post mdadm fix
> together.

We can and should block user from damaging raid even if it is
recoverable. It is a regression.
I will fix mdadm. I don't consider it as a big risk (because it is
recoverable) so I focused on kernel part first.

> 
> > It is correctable because failed
> > state is not recorded in the metadata. After next assembly array
> > will be read-write again.  
> 
> I don't think it is a problem, care to explain why it can't be RW
> again?

failed state is not recoverable in runtime, so you need to recreate
array.

> 
> > For safety reason is better to keep MD_BROKEN in runtime only.  
> 
> Isn't MD_BROKEN runtime already? It is mddev_flags not mddev_sb_flags.

Yes, and this is why I didn't propagate it.
> 
> > Signed-off-by: Mariusz Tkaczyk<mariusz.tkaczyk@linux.intel.com>
> > ---
> >   drivers/md/md-linear.c | 15 ++++++++++++++-
> >   drivers/md/md.c        |  6 +++++-
> >   drivers/md/md.h        | 10 ++--------
> >   drivers/md/raid0.c     | 15 ++++++++++++++-
> >   4 files changed, 35 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> > index 1ff51647a682..3c368e3e4641 100644
> > --- a/drivers/md/md-linear.c
> > +++ b/drivers/md/md-linear.c
> > @@ -233,7 +233,8 @@ static bool linear_make_request(struct mddev
> > *mddev, struct bio *bio) bio_sector < start_sector))
> >   		goto out_of_bounds;
> >   
> > -	if (unlikely(is_mddev_broken(tmp_dev->rdev, "linear"))) {
> > +	if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
> > +		md_error(mddev, tmp_dev->rdev);  
> 
> [ ... ]
> 
> >   
> > +static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
> > +{
> > +	if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags)) {  
> 
> s/rdev->mddev/mddev/

Noted.
> 
> > +		char *md_name = mdname(mddev);
> > +
> > +		pr_crit("md/linear%s: Disk failure on %pg
> > detected.\n"
> > +			"md/linear:%s: Cannot continue, failing
> > array.\n",
> > +			md_name, rdev->bdev, md_name);  
> 
> The second md_name is not needed.
Could you elaborate here more? Do you want to skip device name in
second message?

> 
> > +	}
> > +}
> > +
> >   static void linear_quiesce(struct mddev *mddev, int state)
> >   {
> >   }
> > @@ -297,6 +309,7 @@ static struct md_personality linear_personality
> > = .hot_add_disk	= linear_add,
> >   	.size		= linear_size,
> >   	.quiesce	= linear_quiesce,
> > +	.error_handler	= linear_error,
> >   };
> >   
> >   static int __init linear_init (void)
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index e8666bdc0d28..f888ef197765 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -7982,7 +7982,11 @@ void md_error(struct mddev *mddev, struct
> > md_rdev *rdev) 
> >   	if (!mddev->pers || !mddev->pers->error_handler)
> >   		return;
> > -	mddev->pers->error_handler(mddev,rdev);
> > +	mddev->pers->error_handler(mddev, rdev);
> > +
> > +	if (!mddev->pers->sync_request)
> > +		return;  
> 
> The above only valid for raid0 and linear, I guess it is fine if DM 
> don't create LV on top
> of them. But the new checking deserves some comment above.
Will do, could you propose comment?

> 
> > +
> >   	if (mddev->degraded)
> >   		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> >   	sysfs_notify_dirent_safe(rdev->sysfs_state);  
> 
> [ ... ]
> 
> > +static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
> > +{
> > +	if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags)) {
> > +		char *md_name = mdname(mddev);
> > +
> > +		pr_crit("md/raid0%s: Disk failure on %pg
> > detected.\n"
> > +			"md/raid0:%s: Cannot continue, failing
> > array.\n",
> > +			md_name, rdev->bdev, md_name);  
> 
> The comments for linear_error also valid here.
> 
Noted.

Thanks,
Mariusz
