Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18461C636D6
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 11:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbjBWL0t (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 06:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbjBWL0r (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 06:26:47 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D533E055
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 03:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677151606; x=1708687606;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=id6S/kVXugjBK+788uEbx7nmlN7tFIbcJkN9h/sDlXE=;
  b=mFUUXaxxrmcLGx4Hpy/P5XPoUiUV+AhlSn4NQNUQkZojbVu6AFd8SNxE
   WLAAbM0WDr/0d/B72k2sTkl1gVZF9EXDN6MvrjgDOVKqSmZRtvfrDcP9Y
   H5dQNAe9h1EytGbu6De+i2T82LQQsXB8kGlz/HIPPs/VdU/yH0W1TiY1a
   klpETXBj3fZtak7pwTyM5J3ZtRis9vewBqEUShThpLEiqNt4m5A0G92D9
   O4EcOHUwNXySJ2couPhN7v2LlSqEO8PPIOTgtrvX3zy5TQKx4jI9wRKJV
   x4YRPEz/4QiLTDCIl1dm+9+gYwmxIQlrrXlCC0OS28Qb77Ykzn1/EmMvj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="419413003"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="419413003"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 03:26:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="846524858"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="846524858"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.55.48])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 03:26:43 -0800
Date:   Thu, 23 Feb 2023 12:26:37 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     miaoguanqin <miaoguanqin@huawei.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>, linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Wu Guanghao <wuguanghao3@huawei.com>, <lixiaokeng@huawei.com>
Subject: Re: [PATCH] Fix memory leak for function Manage_subdevs Manage_add
 Kill V2
Message-ID: <20230223122509.00002817@linux.intel.com>
In-Reply-To: <5ab784a2-df14-62d7-873a-622b34b6a646@huawei.com>
References: <5ab784a2-df14-62d7-873a-622b34b6a646@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 22 Feb 2023 16:30:53 +0800
miaoguanqin <miaoguanqin@huawei.com> wrote:

> When we test mdadm with asan,we found some memory leaks.
> We fix these memory leaks based on code logic.
> 
> Signed-off-by: miaoguanqin <miaoguanqin@huawei.com>
> ---
>   Assemble.c | 16 +++++++++++++---
>   Kill.c     | 10 +++++++++-
>   Manage.c   | 16 +++++++++++++++-
>   mdadm.c    |  6 ++++++
>   4 files changed, 43 insertions(+), 5 deletions(-)
> 
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Coly, could you please take a look?

Thanks,
Mariusz
