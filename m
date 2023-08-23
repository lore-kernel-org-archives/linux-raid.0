Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6C9EE4993
	for <linux-raid@archiver.kernel.org>; Wed, 23 Aug 2023 13:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbjHWNwH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Aug 2023 09:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236328AbjHWNwG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Aug 2023 09:52:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF46CCEC
        for <linux-raid@vger.kernel.org>; Wed, 23 Aug 2023 06:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692798724; x=1724334724;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LwcRc5U1KXvn3HpTBwWiTyCBDdF9/oXelVulJsq95Jo=;
  b=lci98i3DV+Q5Lf4/yPPtUZfxDXglEWuA/N/pk5Kmz5YpoPVMjf9snpEQ
   3rODV9Ux59ApSR2p7fkr3c2tp1PDtPncqONVGlSmU4Pk2u3Pi9c/4L7ah
   J9PcWPh3NdQCALR9LIKxYbloZiPZlOsCFD9m43WOSmASo5wdJmRbsXYjJ
   Lx56g5PYELrEJ/1uxDLc4r1CLuAkWMK74C0CQOptFnwAQ1YwbrGnlgPzU
   h16YmrSzhyhszld7kUMnlAFu3UFEJydv4PYxsaNoeAmC7MkSD2O0ILWjn
   rT4WZXBTD2p/heRlo5nrfqIxREnYaKPuKgeu4U4JlXUFnKAzvPjMZhEck
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="405166082"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="405166082"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 06:52:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="826734327"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="826734327"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.143.195])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 06:52:02 -0700
Date:   Wed, 23 Aug 2023 15:51:58 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Guanqin Miao <miaoguanqin@huawei.com>
Cc:     <jes@trained-monkey.org>, <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>, <linfeilong@huawei.com>,
        <lixiaokeng@huawei.com>, <louhongxiang@huawei.com>
Subject: Re: [PATCH 4/4] Fix memory leak in file mdadm
Message-ID: <20230823155158.00001471@linux.intel.com>
In-Reply-To: <20230424080637.2152893-5-miaoguanqin@huawei.com>
References: <20230424080637.2152893-1-miaoguanqin@huawei.com>
        <20230424080637.2152893-5-miaoguanqin@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 24 Apr 2023 16:06:37 +0800
Guanqin Miao <miaoguanqin@huawei.com> wrote:

> When we test mdadm with asan, we found some memory leaks in mdadm.c
> We fix these memory leaks based on code logic.
> 
> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> ---
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
