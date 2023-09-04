Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDD0C71153
	for <linux-raid@archiver.kernel.org>; Mon,  4 Sep 2023 07:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350901AbjIDHsn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Sep 2023 03:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244268AbjIDHsm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Sep 2023 03:48:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E8AD9
        for <linux-raid@vger.kernel.org>; Mon,  4 Sep 2023 00:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693813719; x=1725349719;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DhzsF5XZ4mj8eQU4wfIemrnTK181iilqQC6Z4C9cZwU=;
  b=P6LPcHczrfP0Z6FRzFXpltISP4uWnqeUeVs57y1Gydqt7o2j7gSXNubj
   KxIf0OZudmJtL/TbU67lz96//44/lcio1Cg67RJNP4Dc9gxduA6+QBjk2
   t5aZLRQGfe/xTGPeNgijlWltBFmTYMFq4gtAQEMBMsVD8nwTPSCoX+Amq
   0+/Q4KSC9f73Pp3a3OxRuD90acoM6HjhCxqQtVh/ZC+FSrKVckwNxTXPG
   R2TsAUtBK4/4X/rGouAySNTO46YHcgLaPPqc2zJ7FeWirpiH0UWBCCx1r
   60MYqbWkpCHFs1Kp7ryUx6LmEFuulUAeHsMlIcHRJ49DPjsgJ9kXGMCqm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="442936747"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="442936747"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 00:48:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="883947186"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="883947186"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.106])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 00:48:32 -0700
Date:   Mon, 4 Sep 2023 09:48:32 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org
Subject: Re: [PATCH v5] Incremental: remove obsoleted calls to udisks
Message-ID: <20230904094832.000033a7@linux.intel.com>
In-Reply-To: <3dddeea7-cfda-63d3-7169-e42ef05f9467@trained-monkey.org>
References: <20230813164613.11912-1-colyli@suse.de>
        <3dddeea7-cfda-63d3-7169-e42ef05f9467@trained-monkey.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 1 Sep 2023 11:47:09 -0400
Jes Sorensen <jes@trained-monkey.org> wrote:

> On 8/13/23 12:46, Coly Li wrote:
> > Utility udisks is removed from udev upstream, calling this obsoleted
> > command in run_udisks() doesn't make any sense now.
> > 
> > This patch removes the calls chain of udisks, which includes routines
> > run_udisk(), force_remove(), and 2 locations where force_remove() are
> > called. Considering force_remove() is removed with udisks util, it is
> > fair to remove Manage_stop() inside force_remove() as well.
> > 
> > In the two modifications where calling force_remove() are removed,
> > the failure from Manage_subdevs() can be safely ignored, because,
> > 1) udisks doesn't exist, no need to check the return value to umount
> >    the file system by udisks and remove the component disk again.
> > 2) After the 'I' inremental remove, there is another 'r' hot remove
> >    following up. The first incremental remove is a best-try effort.
> > 
> > Therefore in this patch, where force_remove() is removed, the return
> > value of calling Manage_subdevs() is not checked too.
> > 
> > Signed-off-by: Coly Li <colyli@suse.de>
> > Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> > Cc: Jes Sorensen <jes@trained-monkey.org>
> > ---
> > Changelog,
> > v5: change Mariusz's email address as he suggested
> > v4: add Reviewed-by from Mariusz.
> > v3: remove the almost-useless warning message, and make the change
> >    more simplified.
> > v2: improve based on code review comments from Mariusz.
> > v1: initial version.
> > 
> >  Incremental.c | 64 +++++++++++----------------------------------------
> >  1 file changed, 13 insertions(+), 51 deletions(-)  
> 
> Been out of the loop for a while, trying to catch up.
> 
> Mariusz, do you consider this one good to go now? You were the one
> providing feedback multiple times.
> 
> Thanks,
> Jes
> 
> 

Hi Jes,

Yes, I see this as a good change. The current behavior is not stable, because
udev is not able to "umount"- if array is not mounted it is stopped, otherwise
not.

With the change, we will not try to stop it at all- fair for me, behavior is
same every time. If we cannot stop array every time we should not try to.

Thanks,
Mariusz
