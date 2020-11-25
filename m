Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE98C6379D
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BE54207BC
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731385AbgKYXYZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:24:25 -0500
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17382 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729720AbgKYXYZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Nov 2020 18:24:25 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1606345756; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=gLtWJ5+TALLupUFR3HsW40eiC3L7voRbG8e6wYNSqidF6382hGQ1ghwXFYzigHWFcDlJPW8rgnBGm7geExLBQyADTBYH3TDPEE5q7zDylDnOXnzMCinI2RHTkv+TGiF29jBqlQG3iIBJju8NcsS4xU28Nw1COk8qQ1oaLcR8xO8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1606345756; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Vhp0QZTyMYijT5I+ND5s1nFhQP4Cdxd0EmG53fTr24U=; 
        b=GtMB9nL2TnaWQmSKTv4ZtrT9RjyumyR3D8y0JxfjSEtfrikj8cVUbcdIhTp4g4AC/mKqA7Yiywo5uy30XlNdFxDvfWYRyiOADItuBn84SnV7JQP8ROOBeL9oyRMlLPj/tUKbjIzwIfgyVd4dBnyLHlLOl4/P3upSyy5E0VVLgPI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1606345755403516.3652020419794; Thu, 26 Nov 2020 00:09:15 +0100 (CET)
Subject: Re: [PATCH] Monitor: don't use default modes when creating a file
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20201124154101.1836-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <5b07787e-ef8c-8d54-cc34-0e1625ea6a4b@trained-monkey.org>
Date:   Wed, 25 Nov 2020 18:09:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201124154101.1836-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/24/20 10:41 AM, Mariusz Tkaczyk wrote:
> Replace fopen() calls by open() with creation mode directly specified.
> This fixes the potential security issue. Use octal values instead masks.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  Monitor.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)

Applied!

Thanks,
Jes

