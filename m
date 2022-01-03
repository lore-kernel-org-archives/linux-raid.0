Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79537C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  3 Jan 2022 15:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbiACPdw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 3 Jan 2022 10:33:52 -0500
Received: from mga12.intel.com ([192.55.52.136]:15930 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231320AbiACPdw (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 3 Jan 2022 10:33:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641224031; x=1672760031;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1bakg9Pmmg2g06mFBpouSczVm1mkMou+gt2APskHNL0=;
  b=i1BqAv9dcsBGk9/TTe4XB7UkPAnKTRRZWXjbbMDuyrdAn6FRANY0wA9c
   7ryuojgvoCo0xj10Ilu90bimup0E1sVDQDE+eV6vekCK0QYqfefuhlA0e
   DKE+7strTvjDuuDXDs55ono3nNhH+b/wlNczav/9KYLbNI/SksPyKDnWF
   +HQlwJRQAv1tY9NKpr5IUr8+PkoGeVz3qWBhx7kZdcm1xRkMmZu7eGPx+
   GvLFV1iE2AWSHytg/yzqcn32QN81roDv/eCtq5VN3uXRF1rY/QX7SZAV1
   5n2jBVdisHxW/0EGIsQVjs3iQAs0B/F/meJ+77vvGIDSjkqGDo3ZIu9Oe
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10215"; a="222071975"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="222071975"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 07:33:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="525632526"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.26.248])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 07:33:47 -0800
Date:   Mon, 3 Jan 2022 16:33:42 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] md: drop queue limitation for RAID1 and RAID10
Message-ID: <20220103161204.00003025@linux.intel.com>
In-Reply-To: <CAPhsuW4LGpGKOSLLCH2_2m1f_OHCdbyCNStjXswEOL7A2hp0Lw@mail.gmail.com>
References: <20211217092955.24010-1-mariusz.tkaczyk@linux.intel.com>
 <CAPhsuW4LGpGKOSLLCH2_2m1f_OHCdbyCNStjXswEOL7A2hp0Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, 1 Jan 2022 16:30:07 -0800
Song Liu <song@kernel.org> wrote:

> On Fri, Dec 17, 2021 at 1:30 AM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > As suggested by Neil Brown[1], this limitation seems to be
> > deprecated.
> >
> > With plugging in use, writes are processed behind the raid thread
> > and conf->pending_count is not increased. This limitation occurs
> > only if caller doesn't use plugs.
> >
> > It can be avoided and often it is (with plugging). There are no
> > reports that queue is growing to enormous size so remove queue
> > limitation for non-plugged IOs too.
> >
> > [1]
> > https://lore.kernel.org/linux-raid/162496301481.7211.18031090130574610495@noble.neil.brown.name
> >
> > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>  
> 
> I applied this patch to md-next, cecause it helps simplify Vishal's
> patches for REQ_NOWAIT. However, I think this change is not complete,
> as we can now remove pending_count from r1conf and r10conf. Please
> send patch on top of md-next to clean up pending_count.
> 
Should I also remove pending_cnt from raid1_plug_cb and raid10_plug_cb?

Thanks,
Mariusz

