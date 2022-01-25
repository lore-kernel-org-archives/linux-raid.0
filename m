Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380B0C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 25 Jan 2022 16:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347075AbiAYQCR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Jan 2022 11:02:17 -0500
Received: from mga14.intel.com ([192.55.52.115]:52190 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1582996AbiAYQAQ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 25 Jan 2022 11:00:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643126416; x=1674662416;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pH2iELV2/gUSqoGoJ/FR0aG96jZMRAo4IJiB6Di8o9w=;
  b=c6vqu7Jk+0/r195127I/VhYrvfmeph2MG5JydYIRIBIsvv0yx5hHo2SK
   18cJo9AYnpnvUDh/V5u2N9FFoiATMplrOEvWxnHaP1OmQNyV233KiUQJ/
   FfcHlaFgvcDcdBYjWEL4oCsQP8Xm7kyzMPO7jauCUdlPtDGkz2wYBYdGa
   pIVDz3zRAO5F32Rzn31rGENSy3XeuFjTVpXRSjYXa0qzedhMNqvLNmNpP
   XRPwwmS0YI2BPMRyJ3O2W56DAopLm5oYd71KlmOfUgTxFDDQwj+HppjNZ
   0kNiTGwPpvLlA15vexZyEmlVgq/GW7bkp7WK93PkCWiTr5tmmVC6EwHna
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="246550958"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="246550958"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 07:52:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="534783044"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.27.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 07:52:30 -0800
Date:   Tue, 25 Jan 2022 16:52:25 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Use MD_BROKEN for redundant arrays
Message-ID: <20220125165225.00000407@linux.intel.com>
In-Reply-To: <20211217090238.00000166@linux.intel.com>
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
        <CAPhsuW4zmx+mU6vxiTARPme3P0ANMNbC537SDKj2dEDKc_30kg@mail.gmail.com>
        <20211217090238.00000166@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 17 Dec 2021 09:02:38 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> Hi Song,
> 
> On Thu, 16 Dec 2021 16:52:23 -0800
> Song Liu <song@kernel.org> wrote:
> > > Mariusz Tkaczyk (3):
> > >   raid0, linear, md: add error_handlers for raid0 and linear
> > >   md: Set MD_BROKEN for RAID1 and RAID10
> > >   raid5: introduce MD_BROKEN  
> > 
> > The set looks good to me. The only concern is that we changed some
> > messages. While dmesg is not a stable API, I believe there are
> > people grep on it to detect errors.
> > Therefore, please try to keep these messages same as before (as much
> > as possible).
> 
> Will do.
> After sending it, I realized that my approach is not correct when
> mddev->fail_last_dev is on. MD_BRKOEN should be set even if we agree
> to remove the "last" drive. I will fix it too.
> 

Hi Song,
For raid0 and linear i added new messages so it shouldn't be a problem.
I added one message in raid5 for failed state:
+		pr_crit("md/raid:%s: Cannot continue on %d devices.\n",

Do you want to remove it?
Other errors are same. Order is also preserved.

Thanks,
Mariusz
