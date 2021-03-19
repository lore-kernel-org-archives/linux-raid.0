Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E2CC433DB
	for <linux-raid@archiver.kernel.org>; Fri, 19 Mar 2021 12:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D7D64E09
	for <linux-raid@archiver.kernel.org>; Fri, 19 Mar 2021 12:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhCSMcC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 19 Mar 2021 08:32:02 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17247 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhCSMbn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 19 Mar 2021 08:31:43 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1616157094; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=SXdW+47GYm1yRL+lC5AfX6G4ijxnYVePiHNv8L5d4bi1AY71Xww7zYto0TWaTFXA+8cHpI4dRNeOdnvx0AfueeAYS4QIhj/50YwCL5rpQ5RUu8ob7qPUTXZCIMz9yPlxJ3L712MtbO3/5ZxEHdu5k2u23UI7xpuWGyI8B90k9i8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1616157094; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=T+7Fxhx+KWbfsWxRf5wo1MNWiGJuTzxLNZZgFVW1vJ8=; 
        b=SfCNIR9grVV3Us6C3FiwA/CqP6sXnQ+6enlsEhur326i8iHYtUAELr8KSNSoivDlouWBViC7yCFPPNIWqN7HTOBubj/l7urVge/9wvf3NzZZYU9XkFtYxBFoeGxPpMCHWPB7sPsAzxDSkrbCZKGSlID+rk3rQ30C39lWK7ClgQc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1616157092513613.9814121998568; Fri, 19 Mar 2021 13:31:32 +0100 (CET)
Subject: Re: [PATCH] Monitor: make libudev dependency optional
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210318161235.23168-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <a97ca438-dabe-6b70-01ba-889c9f2a996e@trained-monkey.org>
Date:   Fri, 19 Mar 2021 08:31:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210318161235.23168-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/18/21 12:12 PM, Mariusz Tkaczyk wrote:
> Make -ludev configurable, enabled by default.
> To disable it, -DNO_LIBUDEV has to be set explicitly in CXFALGS.
> 
> This patch restores commit cab9c67d461c ("mdmonitor: set small delay
> once") for configuration without libudev to bring minimal support in
> such case.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  Makefile  |  7 ++++++-
>  Monitor.c | 28 +++++++++++++++++++++++-----
>  2 files changed, 29 insertions(+), 6 deletions(-)

Applied!

Thanks for taking care of this!

Jes

