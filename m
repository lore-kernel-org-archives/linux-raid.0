Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0FCC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 17 Dec 2021 08:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhLQICp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Dec 2021 03:02:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:22902 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233168AbhLQICp (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 17 Dec 2021 03:02:45 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="226993277"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="226993277"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 00:02:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="506676892"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.21.206])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 00:02:43 -0800
Date:   Fri, 17 Dec 2021 09:02:38 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Use MD_BROKEN for redundant arrays
Message-ID: <20211217090238.00000166@linux.intel.com>
In-Reply-To: <CAPhsuW4zmx+mU6vxiTARPme3P0ANMNbC537SDKj2dEDKc_30kg@mail.gmail.com>
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
        <CAPhsuW4zmx+mU6vxiTARPme3P0ANMNbC537SDKj2dEDKc_30kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

On Thu, 16 Dec 2021 16:52:23 -0800
Song Liu <song@kernel.org> wrote:
> > Mariusz Tkaczyk (3):
> >   raid0, linear, md: add error_handlers for raid0 and linear
> >   md: Set MD_BROKEN for RAID1 and RAID10
> >   raid5: introduce MD_BROKEN  
> 
> The set looks good to me. The only concern is that we changed some
> messages. While dmesg is not a stable API, I believe there are people
> grep on it to detect errors.
> Therefore, please try to keep these messages same as before (as much
> as possible).

Will do.
After sending it, I realized that my approach is not correct when
mddev->fail_last_dev is on. MD_BRKOEN should be set even if we agree to
remove the "last" drive. I will fix it too.

Thanks,
Mariusz


