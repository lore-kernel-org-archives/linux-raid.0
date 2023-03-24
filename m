Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91812C6FD1C
	for <linux-raid@archiver.kernel.org>; Fri, 24 Mar 2023 13:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjCXNbC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Mar 2023 09:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjCXNbA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Mar 2023 09:31:00 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2461702
        for <linux-raid@vger.kernel.org>; Fri, 24 Mar 2023 06:30:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679664623; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ccMET1lLbz9fmU8+hNPM0BdiXWfdv4jq1IqEEPWhSQS+50EfmX54kTFQ7wjKd53oXzW9j8a8nSIU+tpAEgBtFfaQYUJy1VL1AmIZmrKAFtOG2+5V+wkarRxPk33rT/wrHyjbU4tkGnoh2UCvjz1QVfLHtai9mjfzprLDDUPtpB8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1679664623; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=9PAAgZSyLz1S71OF3zNabtcONE1Oie9Pis3VCU0B5bI=; 
        b=Q4nP5vMpSmq43Pw5f2z74w9a2qW9nbYqnze/yZRq/Mz/k2yWX31dXkVKkBuZv/XXdjF9ajTcJNrbzZ+ymydIRgveIPReLeDUujlIy5ALzw/O6RElsTfaX5g3Y7tA/pJrasx9xsFozjSRebSiLkLDRaPD+5+UkAfs+QlpNd4EA2g=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1679664622114433.933461260816; Fri, 24 Mar 2023 14:30:22 +0100 (CET)
Message-ID: <4cfab958-fddc-d867-4b7a-1a3bf9ea04d3@trained-monkey.org>
Date:   Fri, 24 Mar 2023 09:30:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] Fix null pointer for incremental in mdadm
Content-Language: en-US
To:     miaoguanqin <miaoguanqin@huawei.com>,
        mariusz.tkaczyk@linux.intel.com, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
Cc:     linfeilong@huawei.com, lixiaokeng@huawei.com,
        louhongxiang@huawei.com
References: <20230323013723.3242033-1-miaoguanqin@huawei.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230323013723.3242033-1-miaoguanqin@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/22/23 21:37, miaoguanqin wrote:
> when we excute mdadm --assemble, udev-md-raid-assembly.rules is triggered.
> Then we stop array, we found an coredump for mdadm --incremental.func
> stack are as follows:
> 
> #0  enough (level=10, raid_disks=4, layout=258, clean=1, 
>     avail=avail@entry=0x0) at util.c:555
> #1  0x0000562170c26965 in Incremental (devlist=<optimized out>, 
>     c=<optimized out>, st=0x5621729b6dc0) at Incremental.c:514
> #2  0x0000562170bfb6ff in main (argc=<optimized out>, 
>     argv=<optimized out>) at mdadm.c:1762
> 
> func enough() use array avail,avail allocate space in func count_active,
> it may not alloc space, causing a coredump.We fix this coredump.
> 
> Signed-off-by: miaoguanqin <miaoguanqin@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  Incremental.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/Incremental.c b/Incremental.c
> index a4ff7d4..acbbee7 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -506,6 +506,9 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>  				    GET_OFFSET | GET_SIZE));
>  	active_disks = count_active(st, sra, mdfd, &avail, &info);
>  
> +	if (!avail)
> +		goto out_unlock;
> +
>  	journal_device_missing = (info.journal_device_required) && (info.journal_clean == 0);
>  
>  	if (info.consistency_policy == CONSISTENCY_POLICY_PPL)
> @@ -620,7 +623,8 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>  		rv = 0;
>  	}
>  out:
> -	free(avail);
> +	if (avail)
> +		free(avail);

free(NULL) is legitimate, no need to do the avail check here.

Jes


