Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA52EC761A6
	for <linux-raid@archiver.kernel.org>; Fri, 31 Mar 2023 15:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbjCaPl5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 31 Mar 2023 11:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbjCaPlz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 31 Mar 2023 11:41:55 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E692B4C35;
        Fri, 31 Mar 2023 08:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=I2MG38sGUy8BI/oVdlPmWxhnYdx8SvffbDRY1N1ThI0=; b=N2dQnRrtXF3IJ6W+/1b/WCg5vO
        xo0Sn22+Hj+3z/q0gVblenNDo6+i+sp4CvfHSUqowga3fYPsGapYCIfB6xsEcC6+upjPCxsyFgu3G
        J9HB9GA8ztGDNxptWNPdjQeLzo3rM0PXURC1jEeH87qD6wldZrlpfiS37RTKKuf64vY1u2IWfJ9hG
        YKjHrV9nyc2jdTBsyysHCwgBAjeGTwGNzTX4eZD/NoxuypFM6su2RIXeCXiHuExIcofESKoXgIOWq
        T1dOoM/3u4kwoeKp4lV40mfE4Q7MV+fUB6AZG/Epp3KVL9HpII5UBAY/dQdwcNF7no/lhxKHAgV8p
        OJ1Mw88w==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1piGsn-00EWFM-EG; Fri, 31 Mar 2023 09:41:42 -0600
Message-ID: <825e329f-f18d-7bfd-e8a4-71ee88e17142@deltatee.com>
Date:   Fri, 31 Mar 2023 09:41:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-CA
To:     Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230330202046.795213-1-yukuai1@huaweicloud.com>
 <20230330202046.795213-4-yukuai1@huaweicloud.com>
 <67b0f0fb-e9f3-b716-f22f-0ca091a291b0@deltatee.com>
 <7efda5d2-96bf-05a4-418d-122bfdf2ce04@huaweicloud.com>
 <f54452de-c5f2-aeab-1218-c0ed3990a481@huaweicloud.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <f54452de-c5f2-aeab-1218-c0ed3990a481@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: yukuai1@huaweicloud.com, song@kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, yukuai3@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v3 3/3] md: protect md_thread with rcu
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023-03-31 00:36, Yu Kuai wrote:

>> Yes, you're right, I'll remove patch 2 and update patch 3. And I'll try
>> to run sparse before sending the new version.
>>
> 
> By the way, I observed lots of sparse errors and warnings for current
> code, will it make sense to fix them?

Yup, I fixed a bunch for raid5 last year. There was one I could not fix
though. I would say effort spent fixing those is well spent.

Thanks!

Logan
