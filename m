Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A722AECAAD8
	for <linux-raid@archiver.kernel.org>; Fri, 16 Sep 2022 18:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiIPSiK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Sep 2022 14:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiIPSiG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Sep 2022 14:38:06 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD162B7EEE;
        Fri, 16 Sep 2022 11:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=4+dPLZdWUnKzU4ZkJ4V0RP0ju1C8Qy705+qCVjBHdRE=; b=KBGBDU5flIZiXtwxOkpRrwNZ3X
        TDSCi56pEtLE4YWFm+e3pqgLQmWoSBej9nI1JVVf5h6aGUncEjIqD4n877IFykd1Cnq3eHwqS2gwJ
        HqvYP+QQR2d8KgjJGj+AJCq7noHbR+euAzXrebrW1UdjfOOHoJBQQV8edYHLptDh2Dmlti+BVJ1M7
        1OnP4agyVxfrMq/UPU3YiCZbPo8LTfnKpTsccWCZWnLlA25G+fG8VueqoIw3IqySSB3AU1dwiyVzT
        hgem3IqdKffmp1KbJkGZY9f1G/7KAdYQHu2KKRr1SItaK43I7zkkiQ1XD+Mik+aOoVOMfGlkkvsik
        aQ3mtELw==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oZGDt-003JQG-Rj; Fri, 16 Sep 2022 12:37:58 -0600
Message-ID: <d8f1465b-df4e-a94b-f075-b5b46c95000a@deltatee.com>
Date:   Fri, 16 Sep 2022 12:37:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-CA
To:     Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org,
        guoqing.jiang@linux.dev, pmenzel@molgen.mpg.de
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com
References: <20220916113428.774061-1-yukuai1@huaweicloud.com>
 <20220916113428.774061-6-yukuai1@huaweicloud.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220916113428.774061-6-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: yukuai1@huaweicloud.com, song@kernel.org, guoqing.jiang@linux.dev, pmenzel@molgen.mpg.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v3 5/5] md/raid10: convert resync_lock to use seqlock
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-09-16 05:34, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Currently, wait_barrier() will hold 'resync_lock' to read 'conf->barrier',
> and io can't be dispatched until 'barrier' is dropped.
> 
> Since holding the 'barrier' is not common, convert 'resync_lock' to use
> seqlock so that holding lock can be avoided in fast path.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Reviewed-and-Tested-by: Logan Gunthorpe <logang@deltatee.com>

So far, I've run this series 3 times through the mdadm test suite and
haven't detected any issues.

Thanks,

Logan
