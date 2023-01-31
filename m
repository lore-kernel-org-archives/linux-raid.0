Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D896C636CC
	for <linux-raid@archiver.kernel.org>; Tue, 31 Jan 2023 17:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbjAaRGg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Jan 2023 12:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjAaRG3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Jan 2023 12:06:29 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED312FCFC
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 09:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=PIQYfQ4njUCGdrN5hh/StfzWhy4BBgRq+9WMg5jm4eQ=; b=lTnIxp45sFTloB32hNA6kphueE
        atlBv8pttiFZS1VodqpoYrgU3VdrnIJuqZbrqEE+LhtX6LUaqu3cafHCrs0KB7U2cz82sZ1MTyDL+
        bSnf7Bw1UIVQaUAmbnLo9hROAl3peMOa8MVux7eCF22xr7iCWGRAqc4xVpNIeADJVwgW0D8dLVUfo
        UeHXyvBqujpc5A8UyXwzunSdTnaYx7L5gpTPLJFT4u6Axrzt8VeXVivO+oO1djslHM2uLF8Nkf5nT
        fuiYrvqZFbgu1IJoPOUPgcKuMu92P78jV8H6nnMXG3Y+pza8AYilj0QUgQZU2syI+V457fM0mumhG
        crRcUs4A==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1pMu5P-000skm-Eb; Tue, 31 Jan 2023 10:06:24 -0700
Message-ID: <265fb203-c8d1-f391-c32e-0bd447b5080d@deltatee.com>
Date:   Tue, 31 Jan 2023 10:06:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-CA
To:     Hou Tao <houtao@huaweicloud.com>, linux-raid@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        houtao1@huawei.com, linan122@huawei.com
References: <20230131070719.1702279-1-houtao@huaweicloud.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20230131070719.1702279-1-houtao@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: houtao@huaweicloud.com, linux-raid@vger.kernel.org, song@kernel.org, axboe@kernel.dk, houtao1@huawei.com, linan122@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH] md: don't update recovery_cp when curr_resync is ACTIVE
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023-01-31 12:07 a.m., Hou Tao wrote:
> From: Hou Tao <houtao1@huawei.com>
> 
> Don't update recovery_cp when curr_resync is MD_RESYNC_ACTIVE, otherwise
> md may skip the resync of the first 3 sectors if the resync procedure is
> interrupted before the first calling of ->sync_request() as shown below:
> 
> md_do_sync thread          control thread
>   // setup resync
>   mddev->recovery_cp = 0
>   j = 0
>   mddev->curr_resync = MD_RESYNC_ACTIVE
> 
>                              // e.g., set array as idle
>                              set_bit(MD_RECOVERY_INTR, &&mddev_recovery)
>   // resync loop
>   // check INTR before calling sync_request
>   !test_bit(MD_RECOVERY_INTR, &mddev->recovery
> 
>   // resync interrupted
>   // update recovery_cp from 0 to 3
>   // the resync of three 3 sectors will be skipped
>   mddev->recovery_cp = 3
> 
> Fixes: eac58d08d493 ("md: Use enum for overloaded magic numbers used by mddev->curr_resync")
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Nice Catch! Thanks.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan
