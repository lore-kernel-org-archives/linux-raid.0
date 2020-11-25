Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5287C56202
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A6DC20872
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbgKYXX1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:23:27 -0500
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17307 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729779AbgKYXX0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Nov 2020 18:23:26 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1606345699; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=EhDjZ1OhjKnJlwh3RB4tADyA6j1b2MLkPeUv57eilWx900njrC57J7RP8rEGuObIZJof45WIZYYjNUgo6/TlJWcvdprtBo3v9qWCSJtEI1bSp4Hl7ivTdlRvJR+xXfSmcFWWk12NtEoAO/dq6Q+qWdaAMbwvtOZNMR4KH0CV/hY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1606345699; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=12BznMtTR+h0EJbWc1TQTM6ODUhCkc0qMRwFPybavNc=; 
        b=Ph99xSuDwzTwHHPu4WHHcqoESWxlxLMemTUqNn8q1aOd8+8DbNMKvlcpdKfvWBJsCYLGJWy2mlLmGS+kII4oOmcwjMsagWWg+m16pG4K7jqU/rIGX85ac+p4WClNhw0Y4byyDzt/EjCETmiBsa+LQq6jKym9qtYa7+YKbaxHN5E=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1606345699550198.92417198831902; Thu, 26 Nov 2020 00:08:19 +0100 (CET)
Subject: Re: [PATCH] imsm: remove redundant calls to imsm_get_map
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20201124145853.1482-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <bc16664f-6cea-5764-fd16-dfad69f2c551@trained-monkey.org>
Date:   Wed, 25 Nov 2020 18:08:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201124145853.1482-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/24/20 9:58 AM, Mariusz Tkaczyk wrote:
> MAP_0 is gotten and the beginning, there is no need to get it again.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  super-intel.c | 2 --
>  1 file changed, 2 deletions(-)

Applied!

Thanks,
Jes

