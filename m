Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26290C07E95
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 14:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10DCD613F5
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 14:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240452AbhGPOob (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jul 2021 10:44:31 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17063 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239786AbhGPOob (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jul 2021 10:44:31 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626445584; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=eWjlHEqbkcrs5RdIipPhWjHNGAjiTGtm/1GAL/XTZ87JaUtD0vZfOH3l9DoQevlQOx18QgzglCsN5+hUNL12Vk2J8RyP8lw6+QCEW3teXrbI1u8BqfuGIAPcj9ppxPRwj3ppoeO4CJRW8+n3S/rl9fYkwwf4NZ08SILTnI+9PwQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1626445584; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=eqbV1Upo1I9X0dyArkhSAl+/Xc6yScT6tZhyXfjDTR8=; 
        b=kBek4ECgxF2b8m54VDwhHNui9RNF8hhiH/aOwFVGkb8lz1GoVKf3y09DDa/bpb2riGU8R/Tq0M74foblQZW6UQV6Gzn97rvXAyVYFEl/D2JNUubhARxZhC0t0va0ZN5LrXSUygqKhOz9cHUXKsaZrcB/zacCycaSC+J56cvxP30=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1626445584021177.88568494520348; Fri, 16 Jul 2021 16:26:24 +0200 (CEST)
Subject: Re: [PATCH 1/3] imsm: correct offset for 4k disks in --examine output
To:     Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210618135332.11293-1-oleksandr.shchirskyi@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <8177f344-f716-23d0-52c5-233feea79b4b@trained-monkey.org>
Date:   Fri, 16 Jul 2021 10:26:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210618135332.11293-1-oleksandr.shchirskyi@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/18/21 9:53 AM, Oleksandr Shchirskyi wrote:
> "Sector Offset" field in Examine output was always printed in 512
> byte sectors. Update it to support 4096 sector size.
> 
> Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
> ---
>  super-intel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied (3x)

Thanks,
Jes

