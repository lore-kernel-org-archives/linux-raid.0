Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7963C07E95
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 14:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9602A6102A
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 14:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhGPOd2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jul 2021 10:33:28 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17020 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbhGPOd1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jul 2021 10:33:27 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626445831; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=TnwYk7AAgAcKdZ3jDWMUwZO1UuZfh3N6ADafH/VLUyj5k0gfjPuqZCzaFVJurTYjp67L6+3K32CH46Cl9EyTwRVyM4Dvb3hKOLKjBqXPkMrc30Q5UwSA9NAaJdalv67Wi9SNjGjY9lfVE92TFu6FEayD6wbRqGGVXs49xVOd6+s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1626445831; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=BoVb1FzxJ24xPxLJutWY1t7zYZxdTmQJbaq+P8lYvHA=; 
        b=fChI8LnTxmxoSKVLD3Xps/sX2WbhyulUOWcO1AKRX3Y2AzWTJbt1m4ZJkyJjhCwP6VWonWKGjokxb9JP1mwGjXHEVeh7bZMvt8MhxSDO6a5RTV28cTaDAq42W8PPMZ34BdPWd1kD1OHLLLZu3RfyThWdagthyjrJxOSEiiWAYM0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1626445830330705.2078334424157; Fri, 16 Jul 2021 16:30:30 +0200 (CEST)
Subject: Re: [PATCH] imsm: Fix possible memory leaks and refactor freeing
 struct dl
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20210628121504.2334-1-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <ab099629-cd1d-1a1a-e6e0-6cb4153a6a9f@trained-monkey.org>
Date:   Fri, 16 Jul 2021 10:30:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210628121504.2334-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/28/21 8:15 AM, Mateusz Grzonka wrote:
> Free memory allocated by structs dl and intel_super.
> Allow __free_imsm_disk to decide if fd has to be closed and propagate it
> across code instead of direct struct dl freeing.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  super-intel.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)

Applied!

Thanks,
Jes


