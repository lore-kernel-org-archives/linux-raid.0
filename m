Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DCC6C76196
	for <linux-raid@archiver.kernel.org>; Tue, 28 Mar 2023 07:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjC1Hyh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Mar 2023 03:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbjC1Hyc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Mar 2023 03:54:32 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56143AAA
        for <linux-raid@vger.kernel.org>; Tue, 28 Mar 2023 00:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679990071; x=1711526071;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o/L+1yP/yhdheQqdfALHMPYNtJ28YxlZQXMjuBXqj7Y=;
  b=HuAmiVJtiDZG9Za+61xV7PHJjyN7USZMEnlRhsAunCJtfeEH56IP7kmz
   1g+d9cMfb7v6SPej3WVEt9Mlck+1JH1PLzg0bPmwnn4Czbsrtg+3cWuQp
   B+lNFj6CsNOuKwPZC70TRW6WGrbkIpH4WUlyXN4fmD95p6zP65Us/uJ8a
   0S2GReIB0gRby3jYiHc7HUTEw6EQwRZ8ofCeoil6UWp65SOJfda1neaxW
   DX++T3XlrnkEIojNuBElwcLS+UvB/Hza8rz0Soiu2NdGgvpr6Xg64b8JP
   2GwtRGNkDMWzU5GkD2iu/iTEgSxiIqlf9qglM9D4SCsqyhMbx0RZMDEmB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="320899282"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="320899282"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 00:54:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="748307699"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="748307699"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.40.165])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 00:54:29 -0700
Date:   Tue, 28 Mar 2023 09:54:25 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     miaoguanqin <miaoguanqin@huawei.com>
Cc:     <jes@trained-monkey.org>, <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>, <linfeilong@huawei.com>,
        <lixiaokeng@huawei.com>, <louhongxiang@huawei.com>
Subject: Re: [PATCH 1/4] Fix memory leak in file Assemble
Message-ID: <20230328095425.00007fd6@linux.intel.com>
In-Reply-To: <20230323013053.3238005-2-miaoguanqin@huawei.com>
References: <20230323013053.3238005-1-miaoguanqin@huawei.com>
        <20230323013053.3238005-2-miaoguanqin@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 23 Mar 2023 09:30:50 +0800
miaoguanqin <miaoguanqin@huawei.com> wrote:

> When we test mdadm with asan,we found some memory leaks in Assemble.c
> We fix these memory leaks based on code logic.
> 
> Signed-off-by: miaoguanqin <miaoguanqin@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
