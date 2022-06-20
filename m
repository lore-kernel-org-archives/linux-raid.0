Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42FB1C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 15:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbiFTPES (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 11:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243531AbiFTPD6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 11:03:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8C92C100
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 07:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655735852; x=1687271852;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e1CsuGLTl9o7ol4nSfB/4eR7ixLFaRubWtai0Hp3DMg=;
  b=hhpocETMs7ksqS3VxuVerJbHKxOKhFIBwrXu2Zr4oh9yoLh0jP6TApFV
   Mf6/Xc+Gi+WDxWUqB0xH+wIdvaZSKe6w3HSl86wkSrZ6ErK6lFj2fAmmK
   iasd5X5HzlnTTDXTfuMf+DRDiQOZ1DneNxkPJiHJS/3vMZcYvooIDSzPA
   kRbBiZ58WairTf5rzcuE3yIQRUL81/2WT5aHnZyUaJIbPtHb/xTCd9Ff6
   Z3457BYRx/0aiB/RQQZRfMwJFKErbhNfMHGopFJGKcVYR8+2UVb0iwri6
   YHNaiAV2A+0EmR/mBYxTmm9FciJLFd3lsofPJk3FhWpbx980xVsh0PEE1
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="279960572"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="279960572"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:37:32 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="591204030"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.65])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:37:28 -0700
Date:   Mon, 20 Jun 2022 16:37:25 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>
Subject: Re: [PATCH mdadm v1 07/14] mdadm: Fix optional --write-behind
 parameter
Message-ID: <20220620163725.00001690@linux.intel.com>
In-Reply-To: <20220609211130.5108-8-logang@deltatee.com>
References: <20220609211130.5108-1-logang@deltatee.com>
        <20220609211130.5108-8-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu,  9 Jun 2022 15:11:23 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> The commit noted below changed the behaviour of --write-behind to
> require an argument. This broke the 06wrmostly test with the error:
> 
>   mdadm: Invalid value for maximum outstanding write-behind writes: (null).
>          Must be between 0 and 16383.
> 
> To fix this, check if optarg is NULL before parising it, as the origial
> code did.
> 
> Fixes: 60815698c0ac ("Refactor parse_num and use it to parse optarg.")
> Cc: Mateusz Grzonka <mateusz.grzonka@intel.com>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
