Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC6DC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 20 May 2022 20:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348051AbiETUhs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 May 2022 16:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239375AbiETUhr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 May 2022 16:37:47 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC72D029C
        for <linux-raid@vger.kernel.org>; Fri, 20 May 2022 13:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:To:
        MIME-Version:Date:Message-ID:cc:content-disposition;
        bh=9C5PvMkA6Dyogw26Xnic6Tv3vkVmW0Od8QCOA3ZajPo=; b=K6YwEiSYoyi8KgVZbhF5nIOnnz
        V1FtMsjoycTVOIewLD2rM9EGeoWNthCIv93LtsOcyMMzlJ5zfGdi6XFC7KI6ZdCV2VPIzKw7oeEXY
        kXLVraASVcf5CqHoBVNRgUBJYVesNNnaXH0AMLYDlQ4+sB4RpFsD1tcCiMFB0f4cuHhWuqSS3HIXW
        g/OQVTB/08M5MF2yyXAwyz1VYWfP0YLPPAKjqt2poD2qgGdSrSbhVIMmxvPOSFuDjPSKxXuLToUKL
        RKKsbgA8kffBGfv8T1tuJxlNMSoP5QexAW5gmTPZBOil2sAfDnh8Rahgpjwm24bhiWvCivM9y0584
        TpBmPWQA==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ns9NX-003H8B-L1; Fri, 20 May 2022 14:37:44 -0600
Message-ID: <4f8ab88b-a619-5d4d-8e3b-9baffb2ec236@deltatee.com>
Date:   Fri, 20 May 2022 14:37:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-CA
To:     himanshu.madhani@oracle.com, linux-raid@vger.kernel.org
References: <20220510170920.18730-1-himanshu.madhani@oracle.com>
 <20220510170920.18730-8-himanshu.madhani@oracle.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220510170920.18730-8-himanshu.madhani@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: himanshu.madhani@oracle.com, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v3 7/7] tests: avoid passing chunk size to raid1
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org




On 2022-05-10 11:09, himanshu.madhani@oracle.com wrote:
> From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> 
> '04update-metadata' test fails with error, "specifying chunk size is
> forbidden for this level" added by commit, 5b30a34aa4b5e. Hence,
> correcting the test to ignore passing chunk size to raid1.
> 
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>

[snip]

> diff --git a/tests/05r1-re-add b/tests/05r1-re-add
> index fa6bbcb421e5..12da5644dee5 100644
> --- a/tests/05r1-re-add
> +++ b/tests/05r1-re-add
> @@ -14,6 +14,7 @@ sleep 4
>  mdadm $md0 -f $dev2
>  sleep 1
>  mdadm $md0 -r $dev2
> +cat /proc/mdstat
>  mdadm $md0 -a $dev2
>  #cat /proc/mdstat
>  check nosync

This hunk doesn't seem like it should be in this patch.


In any case, I've integrated a few of your patches into my work which
fixes 4 more tests that I had previously marked as broken. Sadly I still
have 25 tests that appear to be broken in different ways which I'm
probably not going to get to myself.

The current branch is here:

https://github.com/lsgunth/mdadm bugfixes2

I'm waiting for my kernel series to be accepted into md-next before
sending these patches to the list so I can put a stable git hash of the
kernel version I tested against in the commit message of the last
commit. After that, I intend on getting back to the work I was
originally trying to do. When I do send the series I'll rebase on the
current master in case your patches have been accepted.

Thanks,

Logan
