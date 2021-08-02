Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9A7C4338F
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 15:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9647610FB
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 15:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhHBPtD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Aug 2021 11:49:03 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17006 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbhHBPs7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Aug 2021 11:48:59 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1627919320; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=JFJTRQXnAYvUPmBWqrizl/0cNilq2/y9AIATXOYxqqPebftGqiMx8IRJNQZ2osIq8qVO1+w+NutirfyNOlWaWSne8sJera0Ip9LRuDJG8ntgTZi6r3r7QI3Og9fEhG3eufrFamaWu7ofF3ZsvffjCaPrpn30qvKj0o/HXUJb52s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1627919320; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=VQBYvqUIZwxdkr/qi2kN03rBuK6BJh8xbsnDQP3GWQY=; 
        b=kBC0kx1zLfG1LsfkJ47WwN1gnMMs644sYl6ErqIkyS2HgkCw2kBIrurV8Ai1NB/1rumyUvEhOeVWQB2fRW1df5LTgpDU82bdoxkhq3pCG0eaxWcF0c6VRmvX6HIhu9v8rzXOohL/MNC3PVOUgjhks3CyrhDSKsDGr5PMNMwK9xg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1627919320350521.7357846296704; Mon, 2 Aug 2021 17:48:40 +0200 (CEST)
Subject: Re: [PATCH 4/5] tests: fix swap_super path
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Cc:     linux-raid@vger.kernel.org
References: <20210722182903.GA25359@oracle.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <9cf86355-23fc-5e19-f9dd-8325a89f0c43@trained-monkey.org>
Date:   Mon, 2 Aug 2021 11:48:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210722182903.GA25359@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/22/21 2:29 PM, Sudhakar Panneerselvam wrote:
> This fixes '04r5swap' test.
> 
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> ---
>  tests/04r5swap | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/04r5swap b/tests/04r5swap
> index 5373a60725fb..8c6a97ba7339 100644
> --- a/tests/04r5swap
> +++ b/tests/04r5swap
> @@ -7,7 +7,7 @@ mdadm -S $md0
>  
>  mdadm -E --metadata=0 $dev1  > $targetdir/d1
>  for d in $dev0 $dev1 $dev2 $dev3
> -do $dir/swap_super $d
> +do $PWD/swap_super $d
>  done
>  mdadm -E --metadata=0.swap  $dev1  > $targetdir/d1s
>  diff -u $targetdir/d1 $targetdir/d1s
> 

There are a ton of test cases referencing $dir. I'd say either set $dir
correctly or fix all of them.

Thanks,
Jes

