Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58F8C07E95
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 14:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BEBA613F7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 14:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240203AbhGPOez (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jul 2021 10:34:55 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17028 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239803AbhGPOez (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jul 2021 10:34:55 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626445918; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=KOfb2EvSCbOpH6JCnZimFdYG+S/QgZvO5LhPOEs2qnReY1IxzsWhLmJ5J9msMRtuki7vH925Aj4K4elKSbbWDoY7tiz37RmLC1jjuiscjMBezAJxYDBPiXZck2tssM34lfO86vRGsThgn6PI+aGjjB+1ANGx7HO0FhhruSVmv9Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1626445918; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=qasyJyVO3ohSOHaVdNGvUn5NZDt6JGhW9vF+MNdIpv8=; 
        b=KEYY3DptG8+PxwCe2A9Tf4Cig29YqU7ia1hMXvQ/PUGDYChAdF8YBVgZuX5pq8LHcY021JN9W2quxF2+vdwWy5IGp+M3pvxneB8sDLJCzEdgfK8pV+MlsJzh7BFo70vmRodhlZcHn0hdmvYP5QD6oRcrXzXSK5VHl3UA22FBWLg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1626445916279475.2997785665377; Fri, 16 Jul 2021 16:31:56 +0200 (CEST)
Subject: Re: [PATCH] Add error handling for chunk size in RAID1
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20210715102523.28298-1-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <7e8e499e-cc6d-0684-005f-320d88ae4493@trained-monkey.org>
Date:   Fri, 16 Jul 2021 10:31:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210715102523.28298-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/15/21 6:25 AM, Mateusz Grzonka wrote:
> Print error if chunk size is set as it is not supported.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  Create.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Applied!

Thanks,
Jes

