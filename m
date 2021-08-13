Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 902DAC4338F
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 19:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 654FC60F91
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 19:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhHMTWF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Aug 2021 15:22:05 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17035 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhHMTWF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Aug 2021 15:22:05 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1628882495; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=MwrANqqwulveXmb2D8kgHfzoIpDWY//WNoiajeNDi9e3H+gqSwfJtsrj4pnKZXmGiT5lUwhlR9Sl2LeQ5CiMGtvj4XZG4ZhWHEsH3uK82age38KpwsoQirVpVKMQUEszja87FEli6ryfAJhYkhwr6QbfLtwZFVgPf1K62lpF4gQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1628882495; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=iLvryPrRY0SfvGUXhvERPSRMeQWM+8Kk4YG3QdlBhhY=; 
        b=FepB0pA6dS09s8CwgXfq+nW9DvDRYRgzHm5HPfq3wCiuTOiWMpUvpzcYWtFl4T1n8rku38+UiaSvRa/AvOtUD2Hlsx65mxrTJ5bV2OxOAhPufhSs1m5E8Tdzm98v8ZWzEA8uRGAjnZoShPRu+iZzNnJ0jDQPaAMXK4VGVJoTJnQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1628882493442614.2065751410587; Fri, 13 Aug 2021 21:21:33 +0200 (CEST)
Subject: Re: [PATCH] Utils: Change sprintf to snprintf
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
References: <20210812114848.17341-1-mateusz.kusiak@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <a049f907-1708-cab2-d0db-d5c4e0082fa8@trained-monkey.org>
Date:   Fri, 13 Aug 2021 15:21:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210812114848.17341-1-mateusz.kusiak@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/12/21 7:48 AM, Mateusz Kusiak wrote:
> Using sprintf can cause segmentation fault by exceeding the size of buffer array.
> 
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
>  util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks!

Jes

