Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19535C43334
	for <linux-raid@archiver.kernel.org>; Fri, 10 Jun 2022 09:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348565AbiFJJPB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Jun 2022 05:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348574AbiFJJOo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Jun 2022 05:14:44 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E8429632D
        for <linux-raid@vger.kernel.org>; Fri, 10 Jun 2022 02:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654852397; x=1686388397;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZHDFcw5x2wNAszp6YVlQ+ukk62WusSkYPhFcolGW+pY=;
  b=KymnZgGM2HH8yEQlELmxVCGr1tCJ1yrKu7SFlx0FtiftNWodfE8PEIHT
   foNOEGwdI8qIcfZJ5yIMCT3CNsRkNt4YGPLOKfUTRuRwbgwcLGweq/fm+
   //CUV/J5wnthjLTkP/SZJGAbo0btXRVNThWGXbkgQGsnT9H+0CLXiixbe
   MtfRZfz4MEzMmr2cPufksLiDaJ7CAVQdc7beO1spv3awrcEvALw6rGxoZ
   2Ct8pxxBwNapxM8z+JWGEJtEEj1YRrHxcY2hxRYUrwOBJ2/yN9N2chLta
   bopi+y4TNp2b4JBKAjLqXDVvAr0VUP6+laMovwZ/mrntG2/UwCvz6AAvD
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="339323839"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="339323839"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 02:13:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="638034679"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.57.21])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 02:13:14 -0700
Date:   Fri, 10 Jun 2022 11:13:10 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, <linfeilong@huawei.com>,
        <lixiaokeng@huawei.com>
Subject: Re: [PATCH 1/5 v2] parse_layout_faulty: fix memleak
Message-ID: <20220610111310.0000315d@linux.intel.com>
In-Reply-To: <00ae6b42-b561-6542-0421-4ab8542d5d75@huawei.com>
References: <fd86d427-2d3e-b337-6de8-d70dcbbd6ce1@huawei.com>
        <00ae6b42-b561-6542-0421-4ab8542d5d75@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 9 Jun 2022 11:06:13 +0800
Wu Guanghao <wuguanghao3@huawei.com> wrote:

> char *m is allocated by xstrdup but not free() before return, will cause
> a memory leak.
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  util.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/util.c b/util.c
> index cc94f96e..46b04afb 100644
> --- a/util.c
> +++ b/util.c
> @@ -427,8 +427,11 @@ int parse_layout_faulty(char *layout)
>         int ln = strcspn(layout, "0123456789");
>         char *m = xstrdup(layout);
>         int mode;
> +
>         m[ln] = 0;
>         mode = map_name(faultylayout, m);
> +       free(m);
> +
>         if (mode == UnSet)
>                 return -1;
> 
> --
> 2.27.0

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
