Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC73C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 00:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AA1E61104
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 00:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhEKA1z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 May 2021 20:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbhEKA1z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 May 2021 20:27:55 -0400
X-Greylist: delayed 1331 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 May 2021 17:26:50 PDT
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3012DC061574
        for <linux-raid@vger.kernel.org>; Mon, 10 May 2021 17:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QA8w6Mrh5qox/4Uq6o1gRBRVCHyrqeSvNeS/Za5qrPA=; b=ih+BCfRs+8/G2F2Hamc8WbTfRJ
        eL5VcHLdNyUAMtr3kseozxMQdvnqiLMx4aF22flMMZX4JPCjW5/vFiajNAcXDoDbb3CXX7IRVy7sb
        aqfAUjhqSZ7OJNcOMJqtkGYimz7kXcHc2CpSI4cZEXtikElMizJvvhn0WmiNsj35xRLEHkk05fFY3
        rNO3BQNNLagrtEhfQKbPHC2VdYVWNmU7oSf1OrzBJKpDFA0WUQJfxobi2sTZ4NGzR2m10gFIjLkXd
        NkEUUG1QDckD2iaJjROAF6d67flwcbsZB65QQ3mEHNOrFxEwTHuwUOzxNe6q7HqB7P1WVp8Rv1r04
        UWHKT2nA==;
Received: from c-73-43-58-214.hsd1.ga.comcast.net ([73.43.58.214] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1lgFt6-0005JM-S0; Tue, 11 May 2021 00:04:36 +0000
Subject: Re: raid10 redundancy
To:     Wols Lists <antlists@youngman.org.uk>, d tbsky <tbskyd@gmail.com>,
        Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <AD8C004B-FE83-4ABD-B58A-1F7F8683CD1F@websitemanagers.com.au>
 <CAC6SzHKH62XwudewxtOUyNQYi9QSFar=dZ64fz9HiEW1eZh47g@mail.gmail.com>
 <60950C7B.5040706@youngman.org.uk>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <8333ded7-8805-18df-13d8-166ba021ac02@turmel.org>
Date:   Mon, 10 May 2021 20:04:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <60950C7B.5040706@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/7/21 5:46 AM, Wols Lists wrote:
> On 07/05/21 02:12, d tbsky wrote:
>> Adam Goryachev <mailinglists@websitemanagers.com.au>
>>>
>>> I guess it depends on your definition of raid 10... In my experience it means one or more raid 1 arrays combine with raid 0, so if each raid 1 arrays had 2 members, then it is either 2, 4, 6, etc for the total number of drives.
>>
>> indeed. What I want to use is linux raid10 which can be used on
>> 2,3,4,5, etc of disk drives. so it is unlike hardware raid 10.
>>
> If you're worried about losing two drives, okay it's more disk space,
> but add the third drive and go for three copies. Then adding the fourth
> drive will give you extra space. Not the best but heigh ho.
> 
> Or make sure you've got a spare drive configured, so if one drive fails
> the array will rebuild immediately, and your window of danger is minimised.
> 
> Cheers,
> Wol
> 

I do this for my medium-speed read-mostly tasks.  Raid10,n3 across 4 or 
5 disks gives me redundancy comparable to raid6 (lose any two) without 
the CPU load of parity and syndrome calculations.

Phil
