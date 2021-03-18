Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E06C433DB
	for <linux-raid@archiver.kernel.org>; Thu, 18 Mar 2021 15:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5EA764E89
	for <linux-raid@archiver.kernel.org>; Thu, 18 Mar 2021 15:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhCRPVM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Mar 2021 11:21:12 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17231 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbhCRPUw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Mar 2021 11:20:52 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1616080846; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Q2+H6i6OVGZwRkvXDTCh5spjPiA9HFtOIkd9v2s5N5wBF46jrt1kIP9aZTs53lG3mrXojpRyj5eCE7En8aZq8DiP6UIA/dDk+JF3Qwdnq+6Gt038QG3uxVtdbJosHNMRFuqjdDnzd6CA38OTFFmgFJ0BdU5nDOVZNmi6X9mmzF0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1616080846; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=efoHTvcHMfjRbMto8WPsCI2QqBVSyPA5vbDoZjp25Tw=; 
        b=esmIH58agAtI/qPLLSVjlwNyt0FPdtZMh0ai4QckozavaMQPs9qeXrYhLrm5hv+A1YPsRUHSk0B2T9iRnoalbZuXDTW/aINZR9WciktMp7Eak4QKFpvfcjgCt2/GvkypylzOnbHRffw1//pQxZP5a25kLoIvF0HsCjlrp+4P2q8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1616080844500169.56817978525726; Thu, 18 Mar 2021 16:20:44 +0100 (CET)
Subject: Re: [PATCH] imsm: support for third Sata controller
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210317120154.30806-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <74ba175e-9cd9-0724-232e-bae127eaf760@trained-monkey.org>
Date:   Thu, 18 Mar 2021 11:20:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210317120154.30806-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/17/21 8:01 AM, Mariusz Tkaczyk wrote:
> Add new UEFI TSata variable. Remove CSata variable.
> This variable has been never exposed by UEFI.
> Remove vulnerability to match different hbas with SATA variable.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  platform-intel.c | 58 ++++++++++++++++++++++++++----------------------
>  1 file changed, 31 insertions(+), 27 deletions(-)
> 

Applied!

Thanks,
Jes

