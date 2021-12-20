Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD2AC433FE
	for <linux-raid@archiver.kernel.org>; Mon, 20 Dec 2021 09:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhLTJjT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Dec 2021 04:39:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:30550 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229842AbhLTJjS (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 20 Dec 2021 04:39:18 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10203"; a="239941853"
X-IronPort-AV: E=Sophos;i="5.88,220,1635231600"; 
   d="scan'208";a="239941853"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 01:39:18 -0800
X-IronPort-AV: E=Sophos;i="5.88,220,1635231600"; 
   d="scan'208";a="520735485"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.9.163])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 01:39:17 -0800
Date:   Mon, 20 Dec 2021 10:39:12 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     song@kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and
 linear
Message-ID: <20211220103912.00000fd2@linux.intel.com>
In-Reply-To: <3d8128c8-7cca-a805-5433-027378cdd060@linux.dev>
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
        <20211216145222.15370-2-mariusz.tkaczyk@linux.intel.com>
        <3d8128c8-7cca-a805-5433-027378cdd060@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Guoqing,
On Fri, 17 Dec 2021 10:00:25 +0800
Guoqing Jiang <guoqing.jiang@linux.dev> wrote:

> > @@ -281,6 +282,17 @@ static void linear_status (struct seq_file
> > *seq, struct mddev *mddev) seq_printf(seq, " %dk rounding",
> > mddev->chunk_sectors / 2); }
> >   
> > +static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
> > +{
> > +	char b[BDEVNAME_SIZE];
> > +
> > +	if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags))
> > +		pr_crit("md/linear%s: Disk failure on %s
> > detected.\n"
> > +			"md/linear:%s: Cannot continue, failing
> > array.\n",
> > +			mdname(mddev), bdevname(rdev->bdev, b),
> > +			mdname(mddev));
> > +}
> > +  
> 
> Do you consider to use %pg to print block device?
 
Will do.
 
> > @@ -588,6 +589,17 @@ static void raid0_status(struct seq_file *seq,
> > struct mddev *mddev) return;
> >   }
> >   
> > +static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
> > +{
> > +	char b[BDEVNAME_SIZE];
> > +
> > +	if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags))
> > +		pr_crit("md/raid0%s: Disk failure on %s
> > detected.\n"
> > +			"md/raid0:%s: Cannot continue, failing
> > array.\n",
> > +			mdname(mddev), bdevname(rdev->bdev, b),
> > +			mdname(mddev));
> > +}
> > +
> >   static void *raid0_takeover_raid45(struct mddev *mddev)
> >   {
> >   	struct md_rdev *rdev;
> > @@ -763,6 +775,7 @@ static struct md_personality raid0_personality=
> >   	.size		= raid0_size,
> >   	.takeover	= raid0_takeover,
> >   	.quiesce	= raid0_quiesce,
> > +	.error_handler	= raid0_error,
> >   };
> >     
> 
> What is the advantage of adding error_handler for raid0 and linear?
> IOW, without implement the error_handler, is there some existing
> issue?
> 
There is no issue. It was suggested by Song:
https://lore.kernel.org/linux-raid/CAPhsuW4X94eJ8aG6i7F0zCmgjuWHSRWuBH2gOJjTe5uWg_rMvQ@mail.gmail.com/

Thanks,
Mariusz
