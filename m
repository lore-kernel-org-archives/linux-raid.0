Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF493C05027
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 16:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbjBAQ6P (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 11:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjBAQ6I (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 11:58:08 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD2B2069E
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 08:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=8fpwLYPK+8eqd62BRG88BDVBzjrBW5JmeMCcWALFYSs=; b=QfzWZu+7hy1gcHprulUKq2hDok
        Cq9JtrxG88RdPLjmR6NoRFf2HyCvs0chGywguLMs7vlkAppyr+lbKZfXv30bWUYdduUQ8UKaKkd2P
        hFZqrDbAcDmwiIgrIe/jpoHcSww1dcs76xHXcXBybECbhG9+2sOxQKgaqbzxlIX+C13sFF8msKdFB
        Ux1zBwJSGzUEj7HGn9kWWf+3HP9OrKamJcMwTtwl/RCzesAhzlKnxtlQmgTotM/4Hu5XNBG+FwV60
        1CyHGTcoEyjd8K6ABrRLhm4uwkommhFghibun7armwjwiBIe3lp4ANYB65SHMh5dDOtgZ3E2i8p3Y
        IMlUyAaA==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1pNGQt-001fB0-Kw; Wed, 01 Feb 2023 09:58:04 -0700
Message-ID: <4637a244-dd94-3180-c945-fcf6558dc2a3@deltatee.com>
Date:   Wed, 1 Feb 2023 09:58:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     Hou Tao <houtao@huaweicloud.com>, linux-raid@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        houtao1@huawei.com
References: <20230201075920.444720-1-houtao@huaweicloud.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20230201075920.444720-1-houtao@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: houtao@huaweicloud.com, linux-raid@vger.kernel.org, song@kernel.org, axboe@kernel.dk, houtao1@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v2] md: use MD_RESYNC_* whenever possible
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023-02-01 00:59, Hou Tao wrote:
> From: Hou Tao <houtao1@huawei.com>
> 
> Just replace magic numbers by MD_RESYNC_* enumerations.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Looks good to me. Thanks

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan
