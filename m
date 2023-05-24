Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE73C77B73
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 09:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbjEXJFw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 05:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240194AbjEXJFu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 05:05:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63628E
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 02:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684919149; x=1716455149;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mZonNzxleSu/nW6F82ZzAUCzAhsCXVZI8o9eGtLQM3w=;
  b=Iq+QiaIfD2hrBRO73IGgXXEM5bRfLLXcEkzyxs78iP988+qf/QouOcog
   gkMTq6wWg8HzKYl2RAsPGDcqgU15xjrbCCXHgVGSDL4MZTdNenX2Dv2Nz
   Mu/tY9ieFBWb+GZ6hDT5bPiZ9gcUsfrk/7wtQ6O3kb+ZxBHIensDjrREi
   TGKGFy9HgyQ7fE/ELoKjuf982RlUDOJvgS3NKIXaAYEv4y8pBSQ77QWZ6
   0OC4ZxUsASNFxN+mhdiWnDSHUGsf3bpU8YKdyqn7UrQJY1skwRou1rwfS
   hwuTZBDrFHbhCf1u5R4VixxzVZlJIokXt7DqFPg/QC0N6tTQ4p+ID6uti
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="439860572"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="439860572"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 02:01:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="698444198"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="698444198"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.129.144])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 02:00:43 -0700
Date:   Wed, 24 May 2023 11:00:38 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de, logang@deltatee.com, yangerkun@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH tests 1/5] tests: add a new test to check if pluged bio
 is unlimited for raid10
Message-ID: <20230524110038.00006c2f@linux.intel.com>
In-Reply-To: <5fdfece6-6a45-7de7-7754-afc16d58145b@huaweicloud.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
        <20230523133900.3149123-2-yukuai1@huaweicloud.com>
        <20230524095314.000007f9@linux.intel.com>
        <5fdfece6-6a45-7de7-7754-afc16d58145b@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 24 May 2023 16:26:45 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> Hi,
> 
> ÔÚ 2023/05/24 15:53, Mariusz Tkaczyk Ð´µÀ:
> > On Tue, 23 May 2023 21:38:56 +0800
> > Yu Kuai <yukuai1@huaweicloud.com> wrote:
> >   
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> Pluged bio is unlimited means that all submitted bio will be pluged, and
> >> those bio won't be issued to underlaying disks until blk_finish_plug() or
> >> blk_flush_plug(). In this case, a lot memory will be used for
> >> raid10_bio and io latency will be very bad.
> >>
> >> This test do some dirty pages writeback for raid10, where plug is used, and
> >> check if device inflight counter exceed threshold.
> >>
> >> This problem is supposed to be fixed by [1].  
> > 
> > The test here is for md, mdadm has nothing to do here. I'm not against it
> > but please extract it to separate directory because like "md_tests".
> > We need to start grouping tests.  
> 
> Sorry I don't understand this, currently the test for md is here, I
> don't see why need a seperate directory, is there a plan to move all
> these tests into new directory?

Yes, that how it was in the past, and I would like to change it because 
tests directory is too big and we are still adding new tests.

Ideally, tests like that should stay with kernel, because repository you are
contributing now is "mdadm" - userspace application to manage md devices, not
the driver itself.
That is why I wanted to highlight that placement is controversial but I'm fine
with that. As you said, we did that in the past.

Song, what do you think? Where we should put the test like in the future?


> >> +
> >> +# check if inflight exceed threshold
> >> +while true; do
> >> +        tmp=`cat /sys/block/md0/inflight | awk '{printf("%d\n", $1 +
> >> $2);}'`
> >> +        if [ $tmp -gt $threshold ]; then
> >> +                die "inflight is greater than 4096"  
> > 
> > The message here is not meaningful, what 4096 is? Please add comment
> > describing why value above 4096 causes an error. We need to understand how
> > the future changes in md may affect this setting (I think that there is a
> > correlation between the value and MAX_PLUG_BIO).  
> 
> MAX_PLUG_BIO is just limit for one task, I'm not sure if there will only
> be one task issuing io, that why I choose a much larger value 4096.

Please add it in comment above the value.

Thanks,
Mariusz
