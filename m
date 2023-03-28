Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FA2C76196
	for <linux-raid@archiver.kernel.org>; Tue, 28 Mar 2023 09:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjC1Jis (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Mar 2023 05:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC1Jis (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Mar 2023 05:38:48 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67E2BE
        for <linux-raid@vger.kernel.org>; Tue, 28 Mar 2023 02:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679996326; x=1711532326;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KoBLOpm67GghMQxJ2/+f4MZcFEEF24Wcve9EdYvwsVI=;
  b=cuy4Vv8+haxM+tSRXQpwSksagKV9AniEjFxZVKajymcpu1Tl0w1Yqgg2
   LoNvcWh2pSDU7uiy8WD1m7JKqjrHEzMsw6uj5onWJY2a4tyil3TyF/9X3
   vqIDliJPngAiHqD2rDz90HYjGZUQhK8SU/VJCRIP2RgI9cMMgegFy1SuB
   ONE7wsvXvn95hjQh5Ux9z2omsTEDgqyoV3kzEf59xWbVIaVUzWEIg7qYK
   XMw7FDaNTRk0eAXHmv0rrq8/iSgpcVAoDApI7CEowvu8lbPfKUU2pxYqD
   lBT2HTVmmqYGcJ9+VAWi8BO/yK67/OrP6MZOK9uJU0I05u58nfNMhKTLv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="339246375"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="339246375"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 02:38:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="748346122"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="748346122"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.40.165])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 02:38:44 -0700
Date:   Tue, 28 Mar 2023 11:38:39 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     miaoguanqin <miaoguanqin@huawei.com>
Cc:     <jes@trained-monkey.org>, <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>, <linfeilong@huawei.com>,
        <lixiaokeng@huawei.com>, <louhongxiang@huawei.com>
Subject: Re: [PATCH 2/4] Fix memory leak in file Kill
Message-ID: <20230328113839.000078e3@linux.intel.com>
In-Reply-To: <20230323013053.3238005-3-miaoguanqin@huawei.com>
References: <20230323013053.3238005-1-miaoguanqin@huawei.com>
        <20230323013053.3238005-3-miaoguanqin@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,
see comments below.

On Thu, 23 Mar 2023 09:30:51 +0800
miaoguanqin <miaoguanqin@huawei.com> wrote:

> When we test mdadm with asan,we found some memory leaks in Kill.c
missing space after ","

> We fix these memory leaks based on code logic.
> 
> Signed-off-by: miaoguanqin <miaoguanqin@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  Kill.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/Kill.c b/Kill.c
> index bfd0efdc..46a1a8a0 100644
> --- a/Kill.c
> +++ b/Kill.c
> @@ -41,6 +41,7 @@ int Kill(char *dev, struct supertype *st, int force, int
> verbose, int noexcl)
>  	 *  4 - failed to find a superblock.
>  	 */
>  
> +	int flags = 0;

could you name it "free_super" or something like that? could you use bool?

Thanks,
Mariusz
