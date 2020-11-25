Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5259C56202
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A354207BC
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbgKYXVp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:21:45 -0500
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17306 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729779AbgKYXVp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Nov 2020 18:21:45 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1606345597; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=g1p8oK97QK+P/rqJ/CBc819V+gCEBVsxz8cIqDsK6cyYWo1Zy2fxgWYc/6+iC2fGGvbXXJw6NbXw9hyuBYLb4PIbsHSXZLu7n79caD0/Nk11oifj16IYfQIoFoIIXzlG2vLm25epuEoatb1ARPqjCADBPLiGz+b0tJtkimn7Ow4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1606345597; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=TIpaiQRg8RSa5QqQHk/OwUUANofa5b2nYCxh+gXdveY=; 
        b=N4i4TwUAAmQuYDhJTaz0eXlQK588ofTjXoojSBQFvYkCbw+M/ifvZ6Gmp4CnxPd4VLCiGCTm0nlBvgaYsbU2CGmkvxvD0KGjTzh277bYPzjeeXtkBghhP13LmrzmTDwQEHT3rzTLJtkeoWBXXT4/pwP3DeABuBDPUtnei/Lrjag=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1606345596529582.8105314414328; Thu, 26 Nov 2020 00:06:36 +0100 (CET)
Subject: Re: [PATCH] Create.c: close mdfd and generate uevent
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20201124123949.792-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <4a43d8a1-be94-2fdc-a9b2-08906be167e5@trained-monkey.org>
Date:   Wed, 25 Nov 2020 18:06:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201124123949.792-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/24/20 7:39 AM, Mariusz Tkaczyk wrote:
> During mdfd closing change event is not generated because open() is
> called before start watching mddevice by udev.
> Device is ready at this stage. Unblock device, close fd and
> generate event to give a chance next layers to work.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  Create.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Applied!

Thanks,
Jes

