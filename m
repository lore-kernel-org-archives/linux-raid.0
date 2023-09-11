Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F246CA0ED0
	for <linux-raid@archiver.kernel.org>; Mon, 11 Sep 2023 22:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354714AbjIKV7a (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239352AbjIKOSk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 11 Sep 2023 10:18:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7245DE
        for <linux-raid@vger.kernel.org>; Mon, 11 Sep 2023 07:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694441916; x=1725977916;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qYSd61TVB0F8sXHsY6QMfghBVoIlLkKJPSn7nXp7MJY=;
  b=nGXQzzzTWV39HHe0eE3XJQbT9zYNz7bWkjI5bJ1f4SRPsQteTcts8+di
   /LHMQjIJmYlr28ap/9UKLPx55aqVynS5bpArkoVmWcLP/dQhhTsZAkShY
   QA9TB0Riin4+tYrihk9czCyU4/sKg+/0Xz96qsUww9SWfOMQQIyvhUBDM
   TEuEqgoPD3gpO+ACjNhQx65AKUaWu/TFVZQN+3T+YJgiRgdrOisr3J2iR
   qeWL+X+1ycUYdGzcBqbDPv2i/zGWK77zJKvoAqD9/ZfuAHUUnsoZScKCR
   wMa6eEQl4SqTcUoq5Kaq+iEBCKg/CyDihyAe5/MKvSOL3WDDyEGa8ZPEa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="381898788"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="381898788"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 07:18:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="917040939"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="917040939"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.141.71])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 07:18:25 -0700
Date:   Mon, 11 Sep 2023 16:18:20 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH v4 1/2] Mdmonitor: Improve udev event handling
Message-ID: <20230911161820.00007e6f@linux.intel.com>
In-Reply-To: <52f43128-6f68-49fd-9b25-c3026d007d83@trained-monkey.org>
References: <20230705145020.31144-1-mateusz.grzonka@intel.com>
        <52f43128-6f68-49fd-9b25-c3026d007d83@trained-monkey.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 1 Sep 2023 11:35:57 -0400
Jes Sorensen <jes@trained-monkey.org> wrote:

> On 7/5/23 10:50, Mateusz Grzonka wrote:
> > Mdmonitor is waiting for udev queue to become empty.
> > Even if the queue becomes empty, udev might still be processing last event.
> > However we want to wait and wake up mdmonitor when udev finished
> > processing events..
> > 
> > Also, the udev queue interface is considered legacy and should not be
> > used outside of udev.
> > 
> > Use udev monitor instead, and wake up mdmonitor on every event triggered
> > by udev for md block device.
> > 
> > We need to generate more change events from kernel, because they are
> > missing in some situations, for example, when rebuild started.
> > This will be addressed in a separate patch.
> > 
> > Move udev specific code into separate functions, and place them in udev.c
> > file. Also move use_udev() logic from lib.c into newly created file.
> > 
> > Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>  
> 
> Generally looks good to me.
> 
> One question, is there a minimum version of udev required for this to
> work or has it been around long enough that we don't need to worry?
> 
> Thanks,
> Jes
> 
> 

Hi Jes,
We don't need to worry. I checked one random commit (25e773e) from 2014 and
udev_monitor stuff is there.

Thanks,
Mariusz
