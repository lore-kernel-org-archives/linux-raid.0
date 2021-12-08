Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876F1C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  8 Dec 2021 14:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhLHOq2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Dec 2021 09:46:28 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17213 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbhLHOq2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Dec 2021 09:46:28 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1638974573; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=hQ2LdZfE8Sc4Y9S/hzVhXZplrYQVZo+gOhgxPwGzu0zZqQmwKfjMcdKkiekA8Gs4dFaqJ31B60rLyBmED71dWdePTJAHMh00+WDS4sf7Qf6N/0Rrms+h5YihPAmLjeS1Nc8tGmn4pTjNDOSchfPqXpCJxtgYaq0n/nRDaVmm0fU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1638974573; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=yAdjMbcjfYp9D96BoV95XNcG8+npfptLUiYnyEVyeKY=; 
        b=D9jCH2MMqEWEBLtU4a7ww1jd0LzV06jZv/zHoBftrMSyJBUZ51nkm3STn6Yky1yZry6x3Q/0JAJ/0/BqFsMnbUJ/29vju5ilyNJoJwjxHtOhjEl2iahxCiXObju/oOP7E1E7lskO4+TZQJoaxBsQiS0w4qXZ5Yy5RzyYjGsA4tg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.80] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1638974570924710.4671338864428; Wed, 8 Dec 2021 15:42:50 +0100 (CET)
Subject: Re: [PATCH] mdadm: block creation with long names
To:     Blazej Kucman <blazej.kucman@intel.com>, linux-raid@vger.kernel.org
References: <20211203143115.4544-1-blazej.kucman@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <c4d0d365-0409-31e7-f162-f79cd0f802f5@trained-monkey.org>
Date:   Wed, 8 Dec 2021 09:42:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20211203143115.4544-1-blazej.kucman@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/3/21 9:31 AM, Blazej Kucman wrote:
> This fixes buffer overflows in create_mddev(). It prohibits
> creation with not supported names for DDF and native. For IMSM,
> mdadm will do silent cut to 16 later.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> ---
>  mdadm.8.in | 5 +++++
>  mdadm.c    | 9 ++++++++-
>  mdadm.h    | 5 +++++
>  3 files changed, 18 insertions(+), 1 deletion(-)


Applied,

Thanks,
Jes


