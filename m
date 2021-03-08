Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F98FC433E0
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 15:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1899865208
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 15:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhCHPoU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:44:20 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17255 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbhCHPoD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 Mar 2021 10:44:03 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1615218235; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=bLnMhRKPKWUvpbLw+hhyS83WNNVR7sLpARDwnDbmH282i8R21UYab+S98dggkreFBsqJw6XeZY9ZrIVspXeeUU8kXguvfj2G+Z9EDWg3msxkPe6UnP+PiI5LgAEhMk/EPZM02tF0ZJKl0UC1RNMjZJMLcUV3SO4xNUCcIqV7Np4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1615218235; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=dOk25EzA9ykmeVJ2YNp9Bc7wOM/g1r9g2tf6WWIIdfc=; 
        b=C0qKxRJtJs2HNXeux5aBGkLq2luIqK9I6khnIwuvWPvzbMZ4IdMz/TsNoH0xogu9U6Sn3N4KYHw+1QuNyAwYM2OZ41jr8s5gAOGM3560fsFN9ZosTyvhm1CITeJueU0ulCecRDfFE2+A+vWGwGSFQJGS7qivAwQcIh8c2a4NucY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1615218233723374.3242338933003; Mon, 8 Mar 2021 16:43:53 +0100 (CET)
Subject: Re: [PATCH] imsm: add verbose flag to compare_super
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210205132958.32364-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <90409df5-de13-6ae3-b517-461be2ec0139@trained-monkey.org>
Date:   Mon, 8 Mar 2021 10:43:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210205132958.32364-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/5/21 8:29 AM, Mariusz Tkaczyk wrote:
> IMSM does more than comparing metadata and errors reported directly
> from compare_super_imsm can be useful.
> 
> Add verbose flag to compare_super method and make all not critical
> error printing configurable.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  Assemble.c    |  2 +-
>  Examine.c     |  2 +-
>  Incremental.c |  2 +-
>  mdadm.h       |  3 ++-
>  super-ddf.c   |  3 ++-
>  super-intel.c | 21 ++++++++++++---------
>  super0.c      |  3 ++-
>  super1.c      |  3 ++-
>  8 files changed, 23 insertions(+), 16 deletions(-)

Applied!
Thanks,
Jes
