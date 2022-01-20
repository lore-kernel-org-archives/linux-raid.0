Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C67C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 20 Jan 2022 07:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbiATH62 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Jan 2022 02:58:28 -0500
Received: from mga07.intel.com ([134.134.136.100]:42707 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240985AbiATH61 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Jan 2022 02:58:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642665507; x=1674201507;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dGnlFI7pW04uwDGzsdCDzYXOVtAgqD8P8pnLxvIj+ss=;
  b=PpVHoD6PQmqBUItNvn1l3IMTHGMPmy/HP/XbzRQC10UDxFWvuvF6bUgB
   x/U7LvjPJWoL56qRBaAUhIzZU1LaJtzpy46IJGIlWNbQCayAchZg+2u4P
   F9hxKS8P70ZZOBKxKl7cLQu/JCkownnDSkRrc0G5BHn9ZTj3XfmzAEP6Q
   OyJaf5AzdmoIgwcBRFTCPtieWTz1Mxnu0Hwek4NIgbRnOVOhO30cYDef0
   laXduJI/kG0/dHZvQf7Y7PAD19OnicaQK7rV1mJHHLQHiHDScSjZbkd/l
   Mbl9CsRoUESgPy87xZibxgHuUinDi2kiiCGTSfO/rGOQxDWBwaSVkWVGv
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10232"; a="308631577"
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="308631577"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 23:58:26 -0800
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="532664921"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.17.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 23:58:25 -0800
Date:   Thu, 20 Jan 2022 08:58:20 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH] udev: adapt rules to systemd v247
Message-ID: <20220120085820.0000704a@linux.intel.com>
In-Reply-To: <2263d913-f062-9ae0-9830-7c628e5eaeb7@trained-monkey.org>
References: <20220114154433.7386-1-mariusz.tkaczyk@linux.intel.com>
        <2263d913-f062-9ae0-9830-7c628e5eaeb7@trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 19 Jan 2022 08:22:14 -0500
Jes Sorensen <jes@trained-monkey.org> wrote:

> On 1/14/22 10:44, Mariusz Tkaczyk wrote:
> > New events have been added in kernel 4.14 ("bind" and "unbind").
> > Systemd maintainer suggests to modify "add|change" branches.
> > This patches implements their suggestions. There is no issue yet
> > because new event types are not used in md.
> > 
> > Please see systemd announcement for details[1].
> > 
> > [1]
> > https://lists.freedesktop.org/archives/systemd-devel/2020-November/045646.html
> > 
> > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> 
> Hi Mariusz,
> 
> It looks fine to me, but it does raise the question how does this
> change affect anyone building mdadm running an older systemd since
> you're removing most of the add|change triggers in this patch?
> 
Hi Jes,

Before 4.14 we had tree types of events:
add, change, remove

After 4.14 we have five types of events:
add, change, remove, bind, unbind

I just changed "add|change" to != "remove". Instead verifying positive
cases, I excluded the negative one. The result is the same. I can't see
any risk of regression here for older systemd.

Thanks,
Mariusz
