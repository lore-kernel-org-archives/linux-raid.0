Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86167EE4993
	for <linux-raid@archiver.kernel.org>; Wed, 23 Aug 2023 13:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbjHWNtX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Aug 2023 09:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236135AbjHWNtW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Aug 2023 09:49:22 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D585CEE
        for <linux-raid@vger.kernel.org>; Wed, 23 Aug 2023 06:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692798560; x=1724334560;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gVKW6ERXP8V5F2MEMoACbmr8j7qopmnLK1j46wtwE3g=;
  b=WltZmFdCE+RWCU0PUWqA7VJpexB5RVYctMR3eKVbYeK7u8NFEl7AdERG
   ATf2JXcNyjgkA4be3n51GkSG6cHfhr8HuXBf/AJ2V7b/T6RvLyEW/0vLN
   rOBbYPV7bDGDqIRLXFoSGE3zvAEYRFO2daXaHJaIfnIFYwIGMZdpf1uKI
   xLSq41E5kHRY8CEN+Cdhs4Cs1faAAU9ISaRfYsoOFjyKyTtKOY1XSEPDB
   yHEvgs6k7f4bByiWOmG2mG1aHc7ucwr/wRhmdcUCwITcLXkTB6TgaZLQa
   70Ngez2hF2YmNI0vt+tYm2INbzuvK1wkNFiZQCq1Ut51cLXQ4eWbQrlk5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="354493801"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="354493801"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 06:49:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="802109830"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="802109830"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.143.195])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 06:49:17 -0700
Date:   Wed, 23 Aug 2023 15:49:13 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Guanqin Miao <miaoguanqin@huawei.com>
Cc:     <jes@trained-monkey.org>, <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>, <linfeilong@huawei.com>,
        <lixiaokeng@huawei.com>, <louhongxiang@huawei.com>
Subject: Re: [PATCH 2/4] Fix memory leak in file Kill
Message-ID: <20230823154913.00001e5e@linux.intel.com>
In-Reply-To: <20230424080637.2152893-3-miaoguanqin@huawei.com>
References: <20230424080637.2152893-1-miaoguanqin@huawei.com>
        <20230424080637.2152893-3-miaoguanqin@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 24 Apr 2023 16:06:35 +0800
Guanqin Miao <miaoguanqin@huawei.com> wrote:

> When we test mdadm with asan, we found some memory leaks in Kill.c
> We fix these memory leaks based on code logic.
> 
> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> ---
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
