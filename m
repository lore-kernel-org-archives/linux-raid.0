Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DEBEE49B2
	for <linux-raid@archiver.kernel.org>; Wed, 23 Aug 2023 13:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbjHWNnL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Aug 2023 09:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbjHWNnK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Aug 2023 09:43:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE96CCCB
        for <linux-raid@vger.kernel.org>; Wed, 23 Aug 2023 06:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692798188; x=1724334188;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FCLMlcFQW4fEzGsmbS1UnwlkubNcAGtDjqs/0Ngqces=;
  b=W6XBBvCqr9zHQiY1+QGRy8Foh/hazelNvTkHmeEjBhBAx4qltYfn4UR3
   z2Rlr6+6W/ep/ySHE7ZXZ7BpW2/mILK58kJ0Rt6zGlL+e3Nr45NglndVu
   kGZ7aDTQMevLhnrg0n0CCJSewFxmKMo9j/nqA0C4p8MGDhx9tfXOGAcRH
   DiIn4g2RycpJewfMPrL2lQW5act3tAmViyGqw6Z8K7J6H6BqNuA18DAaw
   aSKRf8og7WE5uXs8+p6UpoQoO1xcmhWtLqM+oKyKn2JQKzgMoCs/uRDIF
   A1SXaOAULAeRmY1XeMKHdD2NbPmcL/tyntJL5JKWKxd9m5hisyvzPnV51
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="373048935"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="373048935"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 06:43:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="713579519"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="713579519"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.143.195])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 06:43:05 -0700
Date:   Wed, 23 Aug 2023 15:43:01 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Guanqin Miao <miaoguanqin@huawei.com>
Cc:     <jes@trained-monkey.org>, <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>, <linfeilong@huawei.com>,
        <lixiaokeng@huawei.com>, <louhongxiang@huawei.com>
Subject: Re: [PATCH 1/4] Fix memory leak in file Assemble
Message-ID: <20230823154301.00006d16@linux.intel.com>
In-Reply-To: <20230424080637.2152893-2-miaoguanqin@huawei.com>
References: <20230424080637.2152893-1-miaoguanqin@huawei.com>
        <20230424080637.2152893-2-miaoguanqin@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 24 Apr 2023 16:06:34 +0800
Guanqin Miao <miaoguanqin@huawei.com> wrote:

> When we test mdadm with asan, we found some memory leaks in Assemble.c
> We fix these memory leaks based on code logic.
> 
> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> ---

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
