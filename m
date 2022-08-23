Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB220C32774
	for <linux-raid@archiver.kernel.org>; Tue, 23 Aug 2022 17:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344106AbiHWRQl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 Aug 2022 13:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344151AbiHWRPg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 Aug 2022 13:15:36 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549F7BBC
        for <linux-raid@vger.kernel.org>; Tue, 23 Aug 2022 06:50:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661262612; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=E4rxDFGOYl30x4btQT0Ht0WFkJ6cbPiaroXlziTf33wfvx/yL1z61vYHriTNfYMkRpHUl1R7rmlJi4+V/u6nVv8bKfFOhvRe4FXw/xX46jRHbz1d+ffEz9kXl7VFRKKuXRNcMkkNCsmrvESifSsb1yX8ejcK0ygsofKIChVCcIE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1661262612; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=30HGHQq/5hp3hWc+Gh0imDRvIoD6AMJX4Dsz0wF3dwo=; 
        b=FeCMavV5JY0tZbz/gksinfJHSn6NyOB48c1W+Q1pE0bmLIBrSxxG77qlF3CBDK9GWkS7wDtfBYCBqqjU3PXhuzJw+rkQmNIrMVlU20AGpULfXanE7p0e+ovh179uXAcmxcm8SHQhPo3mKfzNe0VZoz2hXvxPpOQTmzn1H8gO24k=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 166126260974456.14244826691322; Tue, 23 Aug 2022 15:50:09 +0200 (CEST)
Message-ID: <cb71a39d-e8db-f469-e11c-2eb32163c0fd@trained-monkey.org>
Date:   Tue, 23 Aug 2022 09:50:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH mdadm v3 1/2] tests/00readonly: Run udevadm settle before
 setting ro
Content-Language: en-US
To:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
References: <20220727215246.121365-1-logang@deltatee.com>
 <20220727215246.121365-2-logang@deltatee.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220727215246.121365-2-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/27/22 17:52, Logan Gunthorpe wrote:
> In some recent kernel versions, 00readonly fails with:
> 
>   mdadm: failed to set readonly for /dev/md0: Device or resource busy
>   ERROR: array is not read-only!
> 
> This was traced down to a race condition with udev holding a reference
> to the block device at the same time as trying to set it read only.
> 
> To fix this, call udevadm settle before setting the array read only.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  tests/00readonly | 1 +
>  1 file changed, 1 insertion(+)

Applied,

Thanks,
Jes

