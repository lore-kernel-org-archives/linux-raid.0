Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CEAC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 07:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244362AbiEaHg3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 03:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242852AbiEaHg2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 03:36:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BE18198B
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 00:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653982587; x=1685518587;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sUlbr9M0sIdS8vAQqTxBzLFAv+6c4TGmwFeXCB84oWA=;
  b=VrSBrDdLucjzBwJ49yJyFE0PbL1XsQ+RzZCpRw51gqIAG32G3vnZ/hAk
   GCylS9L+0YJFSrAUQuMAC/8TmhpycqVe/Spha0AH/I00TpkL8vYJUCzKB
   5aXXGBTVJuTURCJKcCUJhk5WDx1O5GhHhzoMW7H2HJxQJy92G/OcHX5A1
   3KkJvSqwAtf2bgKT2+TBw1v+WzHUK8Q1tNtcOdg7AOta8KK+UmqTcRZcq
   ulw4R3mgVSWZY1dU46L2a/58H4LVHSAPxlXdqtR0UJkXciQge5auD3Dko
   yugUjRxPBRu6u2s/niG6XUlomX2JYbpmjhpIUTb19syl9vPjhX43txSs+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="300521049"
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="300521049"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 00:36:27 -0700
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="605535290"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.57.59])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 00:36:25 -0700
Date:   Tue, 31 May 2022 09:36:20 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>,
        <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
Subject: Re: [PATCH 1/5] parse_layout_faulty: fix memleak
Message-ID: <20220531093620.000058b4@linux.intel.com>
In-Reply-To: <bd8d7da6-83e7-da9b-1647-d95220a535e7@huawei.com>
References: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
        <bd8d7da6-83e7-da9b-1647-d95220a535e7@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 31 May 2022 14:49:17 +0800
Wu Guanghao <wuguanghao3@huawei.com> wrote:

> char *m is allocated by xstrdup but not free() before return, will cause
> a memory leak
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  util.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/util.c b/util.c
> index cc94f96e..da18a68d 100644
> --- a/util.c
> +++ b/util.c
> @@ -429,6 +429,7 @@ int parse_layout_faulty(char *layout)
>  	int mode;
>  	m[ln] = 0;
>  	mode = map_name(faultylayout, m);
> +	free(m);
>  	if (mode == UnSet)
>  		return -1;
> 

Hi,
Please add empty lines to separate declarations and not related code
sections.

Thanks,
Mariusz
