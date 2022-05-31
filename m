Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74764C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 07:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244561AbiEaHmj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 03:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244623AbiEaHmf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 03:42:35 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E853BBE5
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 00:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653982952; x=1685518952;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BbBnGtOp+JQn+c9ltOVL4DR8OdPebNlYV+8YiJx1544=;
  b=DCUE5O9ldtQbv57bKOr+1Bec6JN+AtHIPvgupGxuPef9f9nKFrsNLiz2
   3bzHvjZhilH3BfZUZBa89GbwX4eReMwuW4m+1UB92fraxInbxVGdry59f
   mgJ7YED4V2ttlr70G73Zb3TozPocxRJAxhQSS0q9N3LRA+l+GjvByVl+V
   gJgdSMH8sQ5hjI8kK0blTtUKDrNoalbo/gB+VPZA4WQVrYlfNki5Cx5ux
   i7MFiHaOHkss5mlHxC6g8O2byaIJpkAFAMCFIBrHy4b1ah7OcF5laQWv8
   CMGlePa6WjznMQPjCVrAfkjVIj1TZmz2ZVelLvjqmqx4PSVPRm5+/B8pc
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="273979925"
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="273979925"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 00:42:32 -0700
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="605537171"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.57.59])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 00:42:30 -0700
Date:   Tue, 31 May 2022 09:42:25 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>,
        <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
Subject: Re: [PATCH 2/5] Detail: fix memleak
Message-ID: <20220531094225.00007913@linux.intel.com>
In-Reply-To: <e6c9be61-f217-3b6b-35f6-0b8474c4527a@huawei.com>
References: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
        <e6c9be61-f217-3b6b-35f6-0b8474c4527a@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 31 May 2022 14:49:46 +0800
Wu Guanghao <wuguanghao3@huawei.com> wrote:

> char *sysdev = xstrdup() but not free() in for loop, will cause memory
> leak
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  Detail.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Detail.c b/Detail.c
> index ce7a8445..4ef26460 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -303,6 +303,7 @@ int Detail(char *dev, struct context *c)
>  				if (path)
>  					printf("MD_DEVICE_%s_DEV=%s\n",
>  					       sysdev, path);
> +				free(sysdev);
>  			}
>  		}
>  		goto out;

Acked-by: mariusz.tkaczyk@linux.intel.com
