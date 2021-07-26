Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64193C4338F
	for <linux-raid@archiver.kernel.org>; Mon, 26 Jul 2021 01:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A49460F11
	for <linux-raid@archiver.kernel.org>; Mon, 26 Jul 2021 01:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhGZA0Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 25 Jul 2021 20:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhGZA0Q (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 25 Jul 2021 20:26:16 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F71C061757
        for <linux-raid@vger.kernel.org>; Sun, 25 Jul 2021 18:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JcEAUKPCnEWlqXwMtHLvtLK0mbzqxs/zqwphHFoB8rM=; b=Qr4hCG30WzW/GNsK6M0fgnwZTT
        /hA/3MYDF3N7Uee6a4y46kPv1zpn57RbNkMVUarkW1cCMJRU0nMWdS2p+lOUEbl9hppoUKb9rz47g
        bD9YKaVW082d1nSWCS0yl9BciEiPT6yW+hebibqY4P2jOl9TW4Bz6c1Rk1mQoBeeIlrMkC/msoQcP
        cv7nBLfCxr1Es3bTXzZpRScgpplWdyJzCLkJs+rctJOZ9AS00dhZqytjqLRTAoiIY+uGruY/mqIoh
        X0UpHS1Cm/j0yyq2QlXW3bTMpX6cYjOJ+igzkIktPSmoPysDLNSU1Q2U0IvuafWHRnBAYuQNdan1Q
        Duy4mRCw==;
Received: from c-73-43-58-214.hsd1.ga.comcast.net ([73.43.58.214] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1m7p4t-00020f-Ia; Mon, 26 Jul 2021 01:06:43 +0000
Subject: Re: SSD based sw RAID: is ERC/TLER really important?
To:     Peter Grandi <pg@raid.list.sabi.co.UK>,
        list Linux RAID <linux-raid@vger.kernel.org>
References: <2232919.g0K5C1TF2C@chirone>
 <24828.30134.873619.942883@cyme.ty.sabi.co.uk>
 <e4ecfd01-cffc-f154-5f7c-5ca08a12fd33@turmel.org>
 <24829.15553.689641.666563@cyme.ty.sabi.co.uk>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <85c7e18c-5a77-2a20-b170-2a45d7e37dc7@turmel.org>
Date:   Sun, 25 Jul 2021 21:06:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <24829.15553.689641.666563@cyme.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Peter,

On 7/25/21 6:28 AM, Peter Grandi wrote:
>>> * The purpose of having a long device error retry is to instead to
>>> minimize the chances of declaring a drive failed, hoping that many
>>> retries succeed. (but note the difference between reads and writes).
>>> * It is possible to set the kernel timeouts higher than device retry
>>> periods, if one does not care about latency, to minimize the
>>> chances of declaring a drive failed (not[e] the difference
>>> between Linux command timeouts and retry timeouts, the latter
>>> can also be long).
> 
>> You understanding is incorrect.
>> Read errors do *not* kick drives out. It takes several read
>> errors in a short time to fail a drive out of an array.
> 
> I am sorry that I was not clear enough and therefore:
> 
> * You failed to understand the relevance of "note the difference
>    between reads and writes" which I added precisely because I
>    guessed that someone unfamiliar with storage device would need
>    that terse qualifier.
> 
> * You failed to understand the relevance of the "to minimize the
>    chances of declaring a drive failed".
> 
> * You failed to realize that I was addressing tersely the
>    original poster's case of a drive being declared failed
>    because of a drive timeout longer than the kernel command
>    timeout, without going in detail about all other possible
>    cases.
> 

You have reminded me that your mail should have been blackholed--a rule 
I put in many years agao.  I have updated the rule to be more inclusive. 
  I must not be the only one ignoring you, causing you to use multiple 
subdomains.

No need to reply.  I won't see it.

Phil
