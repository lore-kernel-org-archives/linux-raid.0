Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E88C4338F
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 14:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6673760F36
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 14:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhHBOY7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Aug 2021 10:24:59 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17046 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbhHBOY4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Aug 2021 10:24:56 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1627914282; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=FbfgFdrGku3MWtjKAASlXSKxnKgiDy+4+klmpdUFtI2b/wEeIxMQsSbQovew3EIuaXzLRggmtbBoKIlsH4sHjBC2zsCFOacsVwug01I0Q0RpNFcLf1E6pBtcDAHAZbhSYSVfbQZTYQ/e3WaVa6NRHayoXsXBAOdw0HIJ+gKSO/k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1627914282; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Q7IIaA8OB8Bn8FL+S07bv6RmNn3wI+u7At/4sXHUDJ4=; 
        b=O/VCGEl+ClnzBbZ941zCjTghhLaNSiuOWi6VMhcWZmmnNyVzrLjUpt/votR/Hfkb/f4+ovcxIgDZwOiYBKhQirimmFNobYA3707r7l/PgDzNActojbwBJMjHWDkC4Ts1Lc0amoykEMQyNZldqUEFc52D+6EVoWv1jAXY1rq1loY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1627914281490910.8625225131111; Mon, 2 Aug 2021 16:24:41 +0200 (CEST)
Subject: Re: [PATCH] Add monitor delay parameter to mdadm.conf
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210730091600.28014-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <009437aa-1452-5e3a-df3b-53eb42a7c339@trained-monkey.org>
Date:   Mon, 2 Aug 2021 10:24:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210730091600.28014-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/30/21 5:16 AM, Mariusz Tkaczyk wrote:
> From: oshchirs <oleksandr.shchirskyi@intel.com>
> 
> Add possibility to configure delay for mdadm in monitoring mode
> using mdadm.conf.
> --delay command line argument takes precedence over config file.
> 
> Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  config.c     | 23 ++++++++++++++++++++++-
>  mdadm.c      |  6 ++----
>  mdadm.conf.5 | 24 +++++++++++++++++++++---
>  mdadm.h      |  1 +
Applied!

Thanks,
Jes


