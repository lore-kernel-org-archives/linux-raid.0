Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39DAC56202
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61AAA207BC
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgKYXUi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:20:38 -0500
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17379 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbgKYXUi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Nov 2020 18:20:38 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1606345527; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Lmh0AvZTYoaGLSTj/YDlgWEzYxeEMph5lF0hs8dVDuEJ0WIfcfJs/uXhC1m3RMSdjTLnzYraf713V+t3dJPzKkO0pe/UNHoU96KCFpFd6DEYn7LZJFAQpzgnOAZND14V6QnTDBxJOjJr7EakY976jbzrt6/1zqEV7X7rnRhaHZY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1606345527; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=XnJKU73+xGZIVVnFWAF8S3xRYjXBPaWipzm+eTew/hg=; 
        b=FTgWiMqJaDV5Tm5gR28QrzUS3XdL4AWl6gxIwpSnpTxFyvpRdsNQGkJlXUpXqGDDAij+OCn227Vtr7IEnRuo6fzltETrkK7kagE1MJxm48McvR+9BJbyGsO8sMHMt8RRC4J+7JkQzy0lRGGxKtH50S0qch50RgOVVAbfWbrIeMg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1606345525870497.4524260274993; Thu, 26 Nov 2020 00:05:25 +0100 (CET)
Subject: Re: [PATCH] Detail: fix segfault during IMSM raid creation
To:     Lidong Zhong <lidong.zhong@suse.com>, linux-raid@vger.kernel.org
Cc:     Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
References: <20201122151229.16365-1-lidong.zhong@suse.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <f1e7b627-d6f1-8cf5-c5c2-e68700d1e304@trained-monkey.org>
Date:   Wed, 25 Nov 2020 18:05:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201122151229.16365-1-lidong.zhong@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/22/20 10:12 AM, Lidong Zhong wrote:
> It can be reproduced with non IMSM hardware and IMSM_NO_PLATFORM
> environmental variable set. The array state is inactive when creating
> an IMSM container. And the structure info is NULL because load_super()
> always fails since no intel HBA information could be obtained.
> 
> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
> Reported-by: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
> Fixes: 64bf4dff3430 (Detail: show correct raid level when the array is inactive)
> ---
>  Detail.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Thanks,
Jes

