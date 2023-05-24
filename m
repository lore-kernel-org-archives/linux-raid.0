Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E781C77B7A
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 10:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbjEXKjD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 06:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbjEXKip (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 06:38:45 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022C9132
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 03:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684924722; x=1716460722;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qyc8Z7pjeSVsbnVgjHkfYsuGcIcY7ZDSTo/pOEMJ89w=;
  b=Eb2qNyqd3/l3di1Zmn6fT+c90ATi+Fj0YNubuIXVonm0MT+wu1+pWvJ/
   L9LZsn/tXU4h/RFqrNWD7T+TKVy2DEhS2V8avyNzYPJW5SnyoVmmXA6Kp
   npCijB8/okuKI/f2/jCi6QGKlGG/i/fZF0d1LBCbSj0ygYZVNbDgUu0un
   FFyqtryjsVRFuAaautbuckLPwtkU8tzD0atNZA+SdHgR+Z32rbW1Sqn/S
   ps/VgpunV5gVeyhV8Gtuy0Fso0HrcGgEX30ASvxh15huVdLHE9UGHJDUc
   cVRDotBfWRaVLF22h1ZKYGABlFUw5lZhF7cAcQwI2siZlmbioWvGkVIZs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="342987769"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="342987769"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 03:38:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="774195602"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="774195602"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.129.144])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 03:38:40 -0700
Date:   Wed, 24 May 2023 12:38:35 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de, logang@deltatee.com, song@kernel.org,
        yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH tests 2/5] tests: add a new test for rdev lifetime
Message-ID: <20230524123835.00001f1f@linux.intel.com>
In-Reply-To: <fab68598-229a-f914-f09e-6ecaa4a88ba4@huaweicloud.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
        <20230523133900.3149123-3-yukuai1@huaweicloud.com>
        <20230524103301.00007195@linux.intel.com>
        <fab68598-229a-f914-f09e-6ecaa4a88ba4@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 24 May 2023 17:05:43 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> Hi,
> 
> ÔÚ 2023/05/24 16:33, Mariusz Tkaczyk Ð´µÀ:
> > On Tue, 23 May 2023 21:38:57 +0800
> > Yu Kuai <yukuai1@huaweicloud.com> wrote:
> >   
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> This test add and remove a underlying disk to raid concurretly, verify
> >> that the following problem is fixed:  
> > 
> > As in previous patch, feel free to move it into separate directory.
> > 
> > This test is limited only to this particular problem you resolved because
> > you are verifying error message in dmesg. It has no additional value because
> > probability that this issue will ever more occur in the same shape is
> > minimal.
> > 
> > IMO you should check how "remove" and "add" are handled, if errors are
> > returned, if there is no trace in dmesg or if processes are not blocked in
> > kernel.  
> 
> It's a litter hard to do that, the problem is that after removing a disk
> from array, add it back might fail. But if I follow this order,
> it'll be hard to trigger the race, simply based on how quickly kernel
> finish queued work. So I just remove and add the disk concurrently, and
> return errors is not concerned as long as kernel doesn't WARN.

Ok, makes sense. All I really care about is to not grep dmesg for particular
error message. We should make verification flexible because in the future error
may come from different place in the same test. That is the main objection here.
Maybe we can do check like in generic mdadm do_test() :
dmesg | grep -iq "error\|call trace\|segfault"

I know that it is done anyway because do_test() is involved but I would prefer
to have this verification in this test anyway to make reported error message
possibility the most meaningful.

But, as we discussed in other patch, probably mdadm is not perfect place not
tests like that so please be aware of it if you will decide to add this test
to kernel.

> > You can check for this error message as a additional step at the end of test
> > but not as a mandatory test pass criteria.
> > 
> > In current form it gives as a knowledge that particular kernel doesn't have
> > your fix, that is all. Because it is race, probably it is not impacting
> > real life scenarios, so that gives a weak motivation to backport the fix
> > (only security reasons matters).
> > 
> > I don't see that this particular scenario requires test. You need to make it
> > more valuable for the future.  
> 
> This is just a regression test for a kerenl problem£¨also for all the
> tests in this patchset) that is solved recently, and I write this test
> from the kernel perspective, not user, I think this is the main
> difference, because I'm not quite familiar how mdadm works, I just know
> how to use it. (I still wonder why not these kernel regression tests is
> not landed in blktests)
> 
> There are more regression tests that I'm planing to add, and is this the
> wrong place to add such tests?

I think we cleared it up in patch#4.

Thanks for quick feedback,
Mariusz
