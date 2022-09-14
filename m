Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113CBECAAD3
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 13:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiINNrL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 09:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiINNrK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 09:47:10 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3857393B
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 06:46:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663163197; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Zm+6WsurTD2pQCWDX7dPN+2gtwHxe+epsgJ8CQ3hR5KAp3Rubyb5+rZfOsQ4J9kkB3pTBGT2thoEPEAMWEsQf/UML4Ahe/9Nrjl4nw3RWrRRJN1OvGOYLKnFP+rZ1u93MwgYllJp7Btp07IpakSLbRFw8cTCxmuk4s9TWBRKXvM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1663163197; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=jpMshVzi67IIWev57IeHpm9LoDbIxv6x4cqN0RMgSxQ=; 
        b=ZYfBh+74y1gxtdmpbwCLtTTyibpaefuqEfJJie484S9uePc5xHzsPTtoH79z7e8cQnTLP6gIXqdKmR1aJp1LwLHJqxHX8vehYaMfs16vZzYwC2KK8j9tf27RPs848glpu6V+Q8av6bAIfET5OkNJEbKvVDjiUpuzQv3wiKC7vDA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1663163194713852.1436532459261; Wed, 14 Sep 2022 15:46:34 +0200 (CEST)
Date:   Wed, 14 Sep 2022 09:46:32 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v2] mdadm: added support for Intel Alderlake RST on VMD
 platform
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@linux.intel.com>,
        =?UTF-8?B?T2xkxZlpY2ggSmVkbGnEjWth?= <oldium.pro@gmail.com>
Cc:     linux-raid@vger.kernel.org, Coly Li <colyli@suse.de>,
        mariusz.tkaczyk@linux.intel.com
References: <20220831175729.1020-1-oldium.pro@gmail.com>
 <20220914145407.00000d6a@intel.linux.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <f5df5996-579d-0873-ab1f-a0f617db508d@trained-monkey.org>
In-Reply-To: <20220914145407.00000d6a@intel.linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/14/22 08:54, Kinga Tanska wrote:
> On Wed, 31 Aug 2022 19:57:29 +0200
> Oldřich Jedlička <oldium.pro@gmail.com> wrote:
> 
>> Alderlake RST on VMD uses RstVmdV UEFI variable name, so detect it.
>>
>> Signed-off-by: Oldřich Jedlička <oldium.pro@gmail.com>
>> ---
>>  platform-intel.c | 18 +++++++++++++-----
>>  1 file changed, 13 insertions(+), 5 deletions(-)
>>
> 
> Reviewed-by: Kinga Tanska <kinga.tanska@linux.intel.com>
> 
> 
> 
> Looks good to me. I've checked this patch with basic VMD test scope and
> I didn't find any defect.

Applied!

Kinga, thanks for testing.

Jes



