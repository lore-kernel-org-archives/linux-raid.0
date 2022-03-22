Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C9BC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 22 Mar 2022 15:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238547AbiCVPd6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Mar 2022 11:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiCVPd4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Mar 2022 11:33:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E2382D1B
        for <linux-raid@vger.kernel.org>; Tue, 22 Mar 2022 08:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647963149; x=1679499149;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vw+RGYdJvHWxjWj4OYXEz4fq3Gz0/ItSH48UCIH3AQ0=;
  b=Wj3Im+m7UGZSnJ2pyDUk3nDe6V5Wh+bU/QRleUEbHtWLMoG2C6KOcAoo
   KYSMUrcuqoqeCQoY0HohYNPU6bQ0e3ixX9abVOvAmuNNx+WOpyXnQJQs2
   HfQ9+aXvIYt8BMwF8yyZ4/VR8LkRuqHCzn+cscztu+R38lAt8kqqlKZZI
   crstrfOhCIdkrQJTo6eA3V/gnVUiiBTkpK7dvA/YHRrOHkxIN1k4QHBQl
   f617ddw/BqCEvcmpPQCOeQSnSwfmj/BaUoaPhr7orugkYd13YSE1E6XoT
   cG7UXALrC5HOV5oztGMbVaGI3xEG5mwDfSGq37vjbj4MBxDdXVd00vFom
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="321048599"
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="321048599"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 08:32:29 -0700
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="518926460"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.10.5])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 08:32:27 -0700
Date:   Tue, 22 Mar 2022 16:32:23 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] udev: adapt rules to systemd v247
Message-ID: <20220322163223.00000251@linux.intel.com>
In-Reply-To: <20220120085820.0000704a@linux.intel.com>
References: <20220114154433.7386-1-mariusz.tkaczyk@linux.intel.com>
        <2263d913-f062-9ae0-9830-7c628e5eaeb7@trained-monkey.org>
        <20220120085820.0000704a@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Coly,
Could you review?

Thanks,
Mariusz

On Thu, 20 Jan 2022 08:58:20 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> On Wed, 19 Jan 2022 08:22:14 -0500
> Jes Sorensen <jes@trained-monkey.org> wrote:
> 
> > On 1/14/22 10:44, Mariusz Tkaczyk wrote:  
> > > New events have been added in kernel 4.14 ("bind" and "unbind").
> > > Systemd maintainer suggests to modify "add|change" branches.
> > > This patches implements their suggestions. There is no issue yet
> > > because new event types are not used in md.
> > > 
> > > Please see systemd announcement for details[1].
> > > 
> > > [1]
> > > https://lists.freedesktop.org/archives/systemd-devel/2020-November/045646.html
> > > 
> > > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>  
> > 
> > Hi Mariusz,
> > 
> > It looks fine to me, but it does raise the question how does this
> > change affect anyone building mdadm running an older systemd since
> > you're removing most of the add|change triggers in this patch?
> >   
> Hi Jes,
> 
> Before 4.14 we had tree types of events:
> add, change, remove
> 
> After 4.14 we have five types of events:
> add, change, remove, bind, unbind
> 
> I just changed "add|change" to != "remove". Instead verifying positive
> cases, I excluded the negative one. The result is the same. I can't
> see any risk of regression here for older systemd.
> 
> Thanks,
> Mariusz

