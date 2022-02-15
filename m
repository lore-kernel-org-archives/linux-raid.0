Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A0DC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 15 Feb 2022 14:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238500AbiBOOGy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Feb 2022 09:06:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiBOOGy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Feb 2022 09:06:54 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D905F275
        for <linux-raid@vger.kernel.org>; Tue, 15 Feb 2022 06:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644934004; x=1676470004;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qEq89iw6QORUXhJhodUVGj/15nRNZd0WJKKM0Vk705o=;
  b=VmVx6ERrQISvT6AiXecCrl/kX/FY1OIJnDqXeqqTsopG/roJROSWje9M
   9iGx1CUZ43HWReImeMAU22Th5EdezwaAS3eWPAlnZeSKd2TdAKTujhwwc
   VyY7qMlkGQikTO09WOLCztkzBRmKD6K3/3oiQJB6dgMjEYIyoa1SjPhlh
   DdW54fpa8400gMAUnl4FdUrYWt+gxmNNWnbi9H1rGv3gddahHgGiozCg3
   LWrGsNCkPHvDVmuP7rTjla3jjM2PV9gTI0WD2gymdQkAfMe7sDrx1HEMv
   Z5vaWHJbERCiOTS3WbrJY1tgepfvkFBpQyPhS5YEhitULG4dTy+wT7sf7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="230985601"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="230985601"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 06:06:43 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="528876015"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.12.82])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 06:06:42 -0800
Date:   Tue, 15 Feb 2022 15:06:37 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     song@kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and
 linear
Message-ID: <20220215150637.0000584f@linux.intel.com>
In-Reply-To: <67429e77-f669-87f7-c2db-aaa4f545590b@linux.dev>
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
        <20220127153912.26856-2-mariusz.tkaczyk@linux.intel.com>
        <de8e69dc-4e44-de6f-d3d2-9d52935c9b35@linux.dev>
        <20220214103738.000017f8@linux.intel.com>
        <67429e77-f669-87f7-c2db-aaa4f545590b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 15 Feb 2022 11:43:34 +0800
Guoqing Jiang <guoqing.jiang@linux.dev> wrote:

> >> It also adopts md_error(), we only want to call .error_handler for
> >> those levels. mddev->pers->sync_request is additionally checked,
> >> its existence implies a level with redundancy.
> >>
> >> Usage of error_handler causes that disk failure can be requested
> >> from userspace. User can fail the array via #mdadm --set-faulty
> >> command. This is not safe and will be fixed in mdadm.
> >> What is the safe issue here? It would betterr to post mdadm fix
> >> together.  
> > We can and should block user from damaging raid even if it is
> > recoverable. It is a regression.  
> 
> I don't follow, did you mean --set-fault from mdadm could "damaging
> raid"?

Yes, now it will be able to impose failed state. This is a regression I
caused and I'm aware of that.
> 
> > I will fix mdadm. I don't consider it as a big risk (because it is
> > recoverable) so I focused on kernel part first.
> >  
> >>> It is correctable because failed
> >>> state is not recorded in the metadata. After next assembly array
> >>> will be read-write again.  
> >> I don't think it is a problem, care to explain why it can't be RW
> >> again?  
> > failed state is not recoverable in runtime, so you need to recreate
> > array.  
> 
> IIUC, the failfast flag is supposed to be set during transient error
> not permanent failure, the rdev (marked as failfast) need to be
> revalidated and readded to array.
> 

The device is never marked as failed. I checked write paths (because I
introduced more aggressive policy for writes) and if we are in a
critical array, failfast flag is not added to bio for both raid1 and
radi10, see raid1_write_request().
> 
> [ ... ] 
> 
> >>> +		char *md_name = mdname(mddev);
> >>> +
> >>> +		pr_crit("md/linear%s: Disk failure on %pg
> >>> detected.\n"
> >>> +			"md/linear:%s: Cannot continue, failing
> >>> array.\n",
> >>> +			md_name, rdev->bdev, md_name);  
> >> The second md_name is not needed.  
> > Could you elaborate here more? Do you want to skip device name in
> > second message?  
> 
> Yes, we printed two md_name here, seems unnecessary.
> 
I will merge errors to one message.

> 
> >>> --- a/drivers/md/md.c
> >>> +++ b/drivers/md/md.c
> >>> @@ -7982,7 +7982,11 @@ void md_error(struct mddev *mddev, struct
> >>> md_rdev *rdev)
> >>>    	if (!mddev->pers || !mddev->pers->error_handler)
> >>>    		return;
> >>> -	mddev->pers->error_handler(mddev,rdev);
> >>> +	mddev->pers->error_handler(mddev, rdev);
> >>> +
> >>> +	if (!mddev->pers->sync_request)
> >>> +		return;  
> >> The above only valid for raid0 and linear, I guess it is fine if DM
> >> don't create LV on top
> >> of them. But the new checking deserves some comment above.  
> > Will do, could you propose comment?  
> 
> Or, just check if it is raid0 or linear directly instead of implies 
> level with
> redundancy.

Got it.

Thanks,
Mariusz

