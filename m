Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DF8ECAAD5
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 12:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiILMsR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 08:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiILMsQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 08:48:16 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FBA13EAA
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 05:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:To
        :Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I2NDlYATpEud+jFTqmz73BGOGqAOtjfQd3gNKy5lKiI=; b=muBBacM3YQIYD2ckZOShporW1J
        tDzaYXuTCfA/UCpqI3tv6+r1e+qFbfaG6MD05yFos78027dIGhUtRRTTg5upPKszzOigMCXD7pgoB
        dAQXBW1KXcMthVJdBUYIZGnWCWT+oq1DXbCZpxNWyfHCQWPKoxqWXZIpzTetCtUPIYXKFlq1DiigD
        pJNLIysUooEW0nGbnlmdSa1BnledX+mn/sAwDChv4QeaUt4cBBNSQrFKHCQwYafzeql26II0xOwPl
        iC23eabdfu7p7qErQdoLDYpguhTp/Wzyv2Nw79DJrOrkkXOyIWsBhyrCJuDxkkFmrdEVStXccIera
        1DdLwI7w==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1oXirF-0006Hl-Bn; Mon, 12 Sep 2022 12:48:13 +0000
Message-ID: <ef7f0cb8-3cbd-bf94-d60b-3c604668bd0d@turmel.org>
Date:   Mon, 12 Sep 2022 08:48:12 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: 3 way mirror
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
 <73143dc1-e259-9dd1-d146-81d6c576b5d4@youngman.org.uk>
 <e12bc8eb-6be0-f5a2-c57e-b0685752ae2b@turmel.org>
 <3e694d50-a636-3fc8-b662-0268f680c738@youngman.org.uk>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <3e694d50-a636-3fc8-b662-0268f680c738@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If you suffer a drive failure, your odds of a successful rebuild onto 
that spare are decidedly mixed.

https://marc.info/?l=linux-raid&m=139050322510249&w=2

On 9/12/22 04:06, Wols Lists wrote:
> On 12/09/2022 01:58, Phil Turmel wrote:
>> Hi Wol,
>>
>> On 9/11/22 06:08, Wols Lists wrote:
>>
>> [trim /]
>>
>>> old one is still good I'd go for a 3-disk raid-5 plus spare. That's 
>>> my current setup.
>>
>> Eww.  Don't do that.  Always convert raid5+spare to raid6.
>>
> At the moment the fourth drive is, in my mind, a transient backup. I 
> don't want to make it an actual part of the array in case I want to 
> remove it.
> 
> I'm thinking of getting a second matching drive, but seeing as I've 
> bought 16TB of drive space in the recentish past, another 8TB seems 
> excessive :-)
> 
> Cheers,
> Wol

