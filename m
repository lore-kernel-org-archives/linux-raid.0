Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 644E1C761A6
	for <linux-raid@archiver.kernel.org>; Tue, 28 Mar 2023 10:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbjC1K35 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Mar 2023 06:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjC1K34 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Mar 2023 06:29:56 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0156184
        for <linux-raid@vger.kernel.org>; Tue, 28 Mar 2023 03:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679999395; x=1711535395;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mjA0wRxujU1LL34pOeQaUbqfT+I9Q8IRfT9e4a65A5o=;
  b=FpGpPZ3UOb+P37vIb/GeaKKwxldSvSVyxJctORClccDR2fApK1SKZfj5
   qBemQy5U8JjeFq6cfmkYe+8SRbPxrpNN57KNPoYhrWn/haNBTIRXD1aOx
   9jh2X1vVt55lpRnmX7SCWJcQrw3AAJyimluLj56FYiNwLcZIlrLCIg1Ri
   OW0hPUPDg8Blm7AsWNHl5xpytleac4WnvTa/od5MSCjLXURqj60ME87iA
   v3JoJrq1lrZMLzyo5vL53dTH7cq/SYS92jAvFqPpvcVkO+FcC/jLYrygf
   YcB7pZuv/Iwr91ypYKRFyRUWSAgOEngw3DGTHNu65/m+isJnscvsKHdBG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="338031036"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="338031036"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 03:29:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="858024573"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="858024573"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.40.165])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 03:29:52 -0700
Date:   Tue, 28 Mar 2023 12:29:48 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     miaoguanqin <miaoguanqin@huawei.com>
Cc:     <jes@trained-monkey.org>, <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>, <linfeilong@huawei.com>,
        <lixiaokeng@huawei.com>, <louhongxiang@huawei.com>
Subject: Re: [PATCH 4/4] Fix memory leak in file mdadm
Message-ID: <20230328122948.00001e4a@linux.intel.com>
In-Reply-To: <20230323013053.3238005-5-miaoguanqin@huawei.com>
References: <20230323013053.3238005-1-miaoguanqin@huawei.com>
        <20230323013053.3238005-5-miaoguanqin@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 23 Mar 2023 09:30:53 +0800
miaoguanqin <miaoguanqin@huawei.com> wrote:

> When we test mdadm with asan,we found some memory leaks in mdadm.c
> We fix these memory leaks based on code logic.
> 
space after comma.
> Signed-off-by: miaoguanqin <miaoguanqin@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
