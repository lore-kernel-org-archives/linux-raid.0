Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F216DECAAD8
	for <linux-raid@archiver.kernel.org>; Wed, 21 Sep 2022 22:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiIUWiR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Sep 2022 18:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiIUWiC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Sep 2022 18:38:02 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C306A8942
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 15:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=LP+IN5id5QMDgubl7cN6xcCBOpSXo8N3BR/vUAIpEso=; b=NxYtWkQ8rLTV+SvKyf0AH1gM1C
        hsq2TnON/ekStOr/+XCrpqHo+M+ldIqdqgh3H9uW1aNYDGyMaaHIIjiP49Py0HILMzUywD3M6bkLE
        EJYwh7oP/Jfbtdyr8dDFAx+Rdr0/0n8WP6hZPEcW48MOOfy8abSYZqxCCFldA/5rTJQN5XTEWQnCH
        pIbZB+BsT+XiwvzjyYV4pj0LeeGd3yyc5I8v5XszN5MigPOxX0aOcRbP5iY6MMjf56ErWHBVVGNfq
        k+4GG8mul+EwEhld7ZhPPk49K4QDZoEEBYVN+8IMSh0qDP+SS4tMYaEDUy7g0dytWSqRr7OAoF7lC
        4qVRANYg==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ob8Lu-007IuJ-Pz; Wed, 21 Sep 2022 16:37:59 -0600
Message-ID: <b347b8e9-d136-3430-5be0-b4b14d067dc4@deltatee.com>
Date:   Wed, 21 Sep 2022 16:37:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>, Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     David Sloan <david.sloan@eideticom.com>,
        Yu Kuai <yukuai3@huawei.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        XU pengfei <xupengfei@nfschina.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Zhou nan <zhounan@nfschina.com>
References: <9C523D34-6134-4F86-A357-5F306AC3DD07@fb.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <9C523D34-6134-4F86-A357-5F306AC3DD07@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: songliubraving@fb.com, axboe@kernel.dk, linux-raid@vger.kernel.org, david.sloan@eideticom.com, yukuai3@huawei.com, mateusz.grzonka@intel.com, ssengar@linux.microsoft.com, xupengfei@nfschina.com, guoqing.jiang@linux.dev, zhounan@nfschina.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [GIT PULL] md-next 20220921
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-09-21 15:33, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.1/block branch (for-6.1/drivers branch doesn't exist yet). 
> 
> The major changes are:
> 
> 1. Various raid5 fix and clean up, by Logan Gunthorpe and David Sloan.
> 2. Raid10 performance optimization, by Yu Kuai. 
> 3. Generate CHANGE uevents for md device, by Mateusz Grzonka. 

I may have hit a bug with my tests on the latest md-next branch. Still
trying to hit it again. The last tests I ran for several days with some
patches on the previous md-next branch, but I didn't have Mateusz's
changes, and it also looks like the branch was rebased today so it could
be caused by either of those things. I'll let you know when I know more.

Logan
