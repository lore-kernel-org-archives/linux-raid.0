Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C68C9C07E95
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 14:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD46613F8
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 14:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240439AbhGPOlZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jul 2021 10:41:25 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17015 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240424AbhGPOlY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jul 2021 10:41:24 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626445403; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=IyibvOITRIzhnRWVHugZL6CElTUOyD4/BxoxV1t5WJqPpiUsCY3pBGVHmMy0oYQdkJdjythExqfE/H4mjpWlhcb/0h22bdN+d1kzrPK7GXW4y2bbFGkw2f5o8U7fUApWrnVqoJ6hMZeG8K0Ag/gyzpnDDlXq5yWv5Gwiu7qX3sA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1626445403; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=GoX04t/3pGLWmRfGZUVTTSVEDSvDiWLxScTmsVmPIAc=; 
        b=MvNmN0lzrTtrqjloBPEwpVWHPNgZ/WcMv2DjEAgaMSFXWT4bk+FV5xE9CkgKSwoaM3+GDFdp+nxb/8my7VnNLrceyoYxy7Ed8Bc+CuU53xmCEmVibRGlhdsSsHFvWd59nERRduNO9BF86aEBSW+QJDNaci6FjlXahc+Qb0dRyfM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1626445403322874.5739496175497; Fri, 16 Jul 2021 16:23:23 +0200 (CEST)
Subject: Re: [PATCH] Use dev_open in validate geometry container
To:     Blazej Kucman <blazej.kucman@intel.com>, linux-raid@vger.kernel.org
References: <20210615144539.16504-1-blazej.kucman@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <88b74061-0c6d-8c93-a0ef-a42ec33e1873@trained-monkey.org>
Date:   Fri, 16 Jul 2021 10:23:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210615144539.16504-1-blazej.kucman@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/15/21 10:45 AM, Blazej Kucman wrote:
> Fix regression caused by the patch 1f5d54a06
> ("Manage: Call validate_geometry when adding drive to external container")
> - mdmonitor passes to Manage() routine dev name as min:mjr.
> The open() used in validate_geometry_container()
> in both ddf and imsm requires path, replace open calls by dev_open,
> which allows to use dev path and min:mjr.
> 
> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> ---
>  super-ddf.c   | 2 +-
>  super-intel.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied!

Thanks,
Jes

