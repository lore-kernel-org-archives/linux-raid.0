Return-Path: <SRS0=W2Jx=DV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E94C433DF
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 819162222A
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgJNPe0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Oct 2020 11:34:26 -0400
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17337 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729906AbgJNPeZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Oct 2020 11:34:25 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1602689662; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=fnxYKxTcmnNLY27bTfnLpy2XZJP1fLZms5h6hI+OkAU4DDzoLPyXyU4DJtY5KxYuSWVi4X26ZJPKKflKA+uY5LxdqwtNDk58VouYkss+yxd7o37rOm/XLtrIFW2mORs90+MFnb80NHvlCybV0WAKSEZLcy278/ED8UBlSG0Jib4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1602689662; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=hIxAxk9TbwPvgkQtPJGuJzc00HtsKHsrDjXaqlOBoZA=; 
        b=JIwW62KZk+0dEBcYBAwgrC1kKqJzU/fCz2ZxKRjnbmJXr4lgBMw6pJ5Rsl2neW4JxzWQlQLamk1Yr8mjePG8K18XlDQHfyJnzTFz+PAJTcQjIxPG4kszaU537EknCyj8cfi2wZJ7B5cmzIzs6Mx6ZLuetIC6bWWGR8DFMiIIIMk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1602689661203374.5634732661397; Wed, 14 Oct 2020 17:34:21 +0200 (CEST)
Subject: Re: [PATCH 2/4] Monitor: stop notifing about containers.
To:     Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20200909083120.10396-1-mariusz.tkaczyk@intel.com>
 <20200909083120.10396-3-mariusz.tkaczyk@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <ef52f9d6-0619-4984-5370-70a7c00ab288@trained-monkey.org>
Date:   Wed, 14 Oct 2020 11:34:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200909083120.10396-3-mariusz.tkaczyk@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/9/20 4:31 AM, Mariusz Tkaczyk wrote:
> Stop reporting any events from container but still track them,
> it is important for spare migration.
> Stop mdmonitor if no redundant array is presented in mdstat.
> There is nothing to follow.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>  Monitor.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)

Applied!

Thanks,
Jes

