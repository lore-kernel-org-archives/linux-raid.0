Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E093EC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 24 May 2022 15:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbiEXPwN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 May 2022 11:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235697AbiEXPwL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 May 2022 11:52:11 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A026E8D7
        for <linux-raid@vger.kernel.org>; Tue, 24 May 2022 08:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=KjcrRn4T/MQCkk++wqiX+anH/aW2OZm6wJd9oW/B6y0=; b=KOFhHH4eVxvvxpDig7CHszxes/
        OYjVnYMglI1l1T+lqiRKpXtCIgxGKeu6ymz/WFceJFo1iDV4bwG1No9rPc3tJru1W3JQtpR65u9aU
        caqGN1i/fgsccwyfelQojdATCL2uy/EHvb7gmcKkV2dFiRxLvE6tCLXihbo3s3kkRckDbW1J9PNRK
        4Um95f6Xj363WnOhxiNy0WOGGKJf+RFlfdYf2WFdLkuFfrqNqaeF59+fxF+RpLuzKIBq4MRnKOFAc
        Mpof/mtLRTJnUVPYBCvlYarsUOIu4vFVv1HLVqWluVPDoLS21LW5ZT1xqJ+WLaLZ2jjmxXlXeVQvK
        sMTs060w==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ntWpB-006R1m-PV; Tue, 24 May 2022 09:51:58 -0600
Message-ID: <c27aea4d-182d-a65e-eef6-a5f2f34d86b4@deltatee.com>
Date:   Tue, 24 May 2022 09:51:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-CA
To:     Donald Buczek <buczek@molgen.mpg.de>, Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
 <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: buczek@molgen.mpg.de, song@kernel.org, guoqing.jiang@linux.dev, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-05-21 12:23, Donald Buczek wrote:
>> I noticed a clear regression with mdadm tests with this patch in md-next
>> (7e6ba434cc6080).
>>
>> Before the patch, tests 07reshape5intr and 07revert-grow would fail
>> fairly infrequently (about 1 in 4 runs for the former and 1 in 30 runs
>> for the latter).
>>
>> After this patch, both tests always fail.
>>
>> I don't have time to dig into why this is, but it would be nice if
>> someone can at least fix the regression. It is hard to make any progress
>> on these tests if we are continuing to further break them.
> 
> Hmmm. I wanted to try to help a bit by reproducing and digging into this.
> 
> But it seems that more or less ALL tests hang my system one way or another.
> 
> I've used a qemu/kvm machine with md-next and mdraid master.
> 
> Is this supposed to work?

I know those tests are full of bugs, I've been trying to remedy that
somewhat. You can run with --tests=07reshape5intr to run a specific
test. And I have a branch[1] with some fixen and also adds a --loop
option to run tests multiple times.

I expect 00raid0 to fail with the master branch, however I have not seen
that specific trace back. Might be worth debugging that one if you can.

Logan

[1] https://github.com/lsgunth/mdadm bugfixes2
