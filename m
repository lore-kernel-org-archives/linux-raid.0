Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07473C433DB
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 15:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C973665249
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 15:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhCHPXU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:23:20 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17251 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhCHPXM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 Mar 2021 10:23:12 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1615216990; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=jvx8Vdp72MsJ870mc0IBEorxK87a9T1s1ok+eXZ0IxLvqcuv4TndOf3adIFycf4DLGZzUpyoybGbPjPEIzW1/pBLLif1vOy3XoqA6uJ7fpHhW0xMfHhZx94JuZC5JA9MXp5K7WbOE1pkQURxWQV5QZDFRYqa/7YK/QzQaLbNJLc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1615216990; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=xItgykWYWv+fvAJ7tCf9sGY9V9fTHOK39BQsY460LKg=; 
        b=IW5Ato/L2NYV4MJ39KI7zi/cks7BreGujSIZXzF35zgS1XSEAQCNAliPisNU4b3EyJyy0TJpjMSVzKn0JR96SJtljCGD0Z7jynwrRRtCPRd09doeowumq8/nhVHt+g1ugAKWJmmLybI3cwyQpQrl0TI/G3AoCLq3yYio2O+H2xg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1615216989018508.3806466436205; Mon, 8 Mar 2021 16:23:09 +0100 (CET)
Subject: Re: [PATCH] mdmonitor: check if udev has finished events processing
To:     Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210114141416.42934-1-oleksandr.shchirskyi@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <a5f929eb-5103-1646-b321-65886157c9cc@trained-monkey.org>
Date:   Mon, 8 Mar 2021 10:23:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210114141416.42934-1-oleksandr.shchirskyi@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/14/21 9:14 AM, Oleksandr Shchirskyi wrote:
> If mdmonitor is awaken by event, wait for udev to finish
> events processing, to eliminate the race between udev and mdadm
> when spare has been added and need to be moved by mdmonitor
> 
> Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
> ---
>  Makefile  |  2 +-
>  Monitor.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 63 insertions(+), 12 deletions(-)

Hi,

I think it is reasonable to require libudev in 2021, so I have applied
this. However if someone feels there is a reason to not have this build
requirement, I will also accept a patch to make this dependency optional.

Second, I took the liberty to replace the ugly C++ style // comments
with proper /* */ ones.

Thanks,
Jes

