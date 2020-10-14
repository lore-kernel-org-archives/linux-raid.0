Return-Path: <SRS0=W2Jx=DV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32624C43457
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFF762222E
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgJNPi0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Oct 2020 11:38:26 -0400
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17369 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgJNPi0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Oct 2020 11:38:26 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1602689903; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Zw0blJF1tTYjc7DptB+UA417tsuszgNXbSlIBOD4MtLYG8BY22O0BzO6FdNzp4RRLiC/xobfhWiceiu3K8mAUri3uGatTzw9mt9NEC59RDHJKgtGI7GVnNT/KjU5PUqIJyam2DhTWzzO5/E2YpGQpt24opCKfjY1z7Sm7HeO3+Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1602689903; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=nkbiD1HYeSv0cJp9UDDG/EuPQeplBZCcM8R6iWQcjRw=; 
        b=QxLoY2z4/O4TxhYZmL7jqLngsVsG3igT/ahC27J0BkMMrgIdrojPZx3+lTzi9W/R70ofCg1XfWsB3CSfzC3N6dixkiQS6TPP2po4rqsazeCd7mVNpj0bX5v5ORt473PlyKaHf+kxweiXoxHueR8YcUlr8CMRdNyvEbt9eCV2Lsk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1602689900923122.07298676244625; Wed, 14 Oct 2020 17:38:20 +0200 (CEST)
Subject: Re: [PATCH 4/4] Check if other Monitor instance running before fork.
To:     Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20200909083120.10396-1-mariusz.tkaczyk@intel.com>
 <20200909083120.10396-5-mariusz.tkaczyk@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <35186b77-bb79-aff7-07c8-77d3586310db@trained-monkey.org>
Date:   Wed, 14 Oct 2020 11:38:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200909083120.10396-5-mariusz.tkaczyk@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/9/20 4:31 AM, Mariusz Tkaczyk wrote:
> From: Blazej Kucman <blazej.kucman@intel.com>
> 
> Make error message visible to the user.
> 
> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>  Monitor.c | 44 ++++++++++++++++++++++++++++----------------
>  1 file changed, 28 insertions(+), 16 deletions(-)

Applied!

Thanks,
Jes


