Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4436FEE49A3
	for <linux-raid@archiver.kernel.org>; Wed, 23 Aug 2023 13:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbjHWNvB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Aug 2023 09:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbjHWNvB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Aug 2023 09:51:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F744E62
        for <linux-raid@vger.kernel.org>; Wed, 23 Aug 2023 06:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692798658; x=1724334658;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nsa2wdA1FaqdFkb9DU0Xqes5bmy5BizDoaSZeceAXs0=;
  b=LTBUqZQLm5gK4U+WML4vPHVWN5yU1H6K3jKwQgz572XgeDb5OYirTL3c
   Ka16U1NZNLwQ28oGdUclBFjsUtBuXYB8MryLiBmBjbzpuAJU4wIH60tkf
   p3FGV2OENYBy14mRRLKN1vq9w/dE5I0UNT6RPOvaCcNW3Ab7ZJzd7DDMu
   +9YF8tVhSt2EA/bUyoyzjMpU0kIIx+BP2U4lqjwBfAy3sLBI2bWXOk79X
   v7t+ztWrKqaYCKcw6hGPjzV/dr8rtHFOaNdalsqpUTrP/cYcRa5adBz8I
   MWyFIxzroHHUye1FcY539bdIost96f1dbZKP4LZGCF0XVekCPNaA27Qms
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="354494174"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="354494174"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 06:50:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="713580630"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="713580630"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.143.195])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 06:50:55 -0700
Date:   Wed, 23 Aug 2023 15:50:51 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Guanqin Miao <miaoguanqin@huawei.com>
Cc:     <jes@trained-monkey.org>, <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>, <linfeilong@huawei.com>,
        <lixiaokeng@huawei.com>, <louhongxiang@huawei.com>
Subject: Re: [PATCH 3/4] Fix memory leak in file Manage
Message-ID: <20230823155051.000067ea@linux.intel.com>
In-Reply-To: <20230424080637.2152893-4-miaoguanqin@huawei.com>
References: <20230424080637.2152893-1-miaoguanqin@huawei.com>
        <20230424080637.2152893-4-miaoguanqin@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 24 Apr 2023 16:06:36 +0800
Guanqin Miao <miaoguanqin@huawei.com> wrote:

> When we test mdadm with asan, we found some memory leaks in Manage.c
> We fix these memory leaks based on code logic.
> 
> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> ---
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

