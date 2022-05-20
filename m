Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E4DC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 20 May 2022 18:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbiETSpk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 May 2022 14:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238179AbiETSpj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 May 2022 14:45:39 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68E55E769
        for <linux-raid@vger.kernel.org>; Fri, 20 May 2022 11:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:To:
        MIME-Version:Date:Message-ID:cc:content-disposition;
        bh=39vOllTxCndqNVQaLtKwJUpQYLAU0PC/yw43KpjLJuY=; b=iGPHR9VSXej5NgwYg7y+HSZLak
        0c10YAyAhcbYDbVcC5JNlwS3vTYbFrWQvH8XT35x3B90TZ6iEdLuosErbfXRjk+4wI33Iywluoh9H
        ukmnnTEBlv2VjYqEdAqYQ7OxxEaJ5c1WMY70K3dpz8Ae8qiMv6/ltAj/Iz+1ON6ImKyPM6YXvvG/u
        cXXWlKPoU7b2fCxiJWi+QhZEDO8mYD4AcdYDqHWvihrDNq8bWqcADSl1QzoQB3EFdoPvGXVMrufKD
        IY8aX6QI1qCUQTd4qk0wdIcsBb1Bs2yuLCzkASiadN4mxwHhctqzG89jj8swkvWzCohB/01oDjZ61
        WtsFtcYw==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ns7d1-003FhG-Jg; Fri, 20 May 2022 12:45:37 -0600
Message-ID: <2a6073e9-12ea-f468-6bfd-92609ce824df@deltatee.com>
Date:   Fri, 20 May 2022 12:45:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-CA
To:     himanshu.madhani@oracle.com, linux-raid@vger.kernel.org
References: <20220510170920.18730-1-himanshu.madhani@oracle.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220510170920.18730-1-himanshu.madhani@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: himanshu.madhani@oracle.com, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v3 0/7] Resurrect mdadm test cases
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi Himanshu,

On 2022-05-10 11:09, himanshu.madhani@oracle.com wrote:
> From: Himanshu Madhani <himanshu.madhani@oracle.com>
> 
> Hi, 
> 
> I am picking up patches that were submitted earlier [1] and received
> comments which were addressed in [2]. This series is an attempt to
> resurrect the review request with combined patchset that resolves error
> encountered while running test cases for each of the raid types.
> 
> I've tested this series with latest 5.18.0-rc4+ kernel. 
> 
> [1] https://marc.info/?l=linux-raid&m=162697853622376&w=2
> 
> [2] https://marc.info/?l=linux-raid&m=163907488120973&w=2

I have also been working on these tests for the last couple weeks to get
them cleaned up and more reliable. I just sent a series fixing a number
of the kernel issues that I've found. I have another series in the works
for mdadm which has some overlap with yours. Seems you've fixed a number
of tests I haven't though and vice versa.

You can see my WIP branch here:

https://github.com/lsgunth/mdadm/  bugfixes


> Sudhakar Panneerselvam (7):
>   Revert "mdadm: fix coredump of mdadm --monitor -r"

I actually saw this issue too and have a fix for it that doesn't involve
reverting. See:

https://github.com/lsgunth/mdadm/commit/575e1debb983d8ed837e66462529aea025129f65


Thanks,

Logan
