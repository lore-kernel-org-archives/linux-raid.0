Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D219C43334
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 13:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiGTNBo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 09:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiGTNBn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 09:01:43 -0400
X-Greylist: delayed 1676 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 20 Jul 2022 06:01:42 PDT
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A38A50739
        for <linux-raid@vger.kernel.org>; Wed, 20 Jul 2022 06:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:To
        :Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VVGYqhVhDPUW552IbAdRcIgC7uRswHvm4eUDFPCQjAM=; b=fjEB/Wn/8Jln3QA4V2xgI+/uZG
        MZ4az5nx+pv3XPIUwQTIuKB9JQq20DKOb/wQreELtKgC+Gg+De3z5+57HbWeg4yIjNUzrzCRoIXR8
        W6PJIWDQljRIbbmkmWMuaGk5CDiV5sMArvfPY07FyiQt9jHS7yZE0Y1rVjFdIqVgCXA2dSHKadKhH
        ghCgyD9i6NwqT9lMYuHitNhWcyQqewWS4QHSFuv60m9fkaGjX7Onfc2CGn7niJleeaDbNaCLx8RyT
        +LKpA1lFzFBnl0DIeXDQuFH4OY9gxW5xBa4HwBNDEEasU49JNTUNabqvjDsewKlkjvz38JXrIuLRS
        b/0olRhA==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1oE8tO-0004CB-Ef; Wed, 20 Jul 2022 12:33:30 +0000
Message-ID: <825e0b96-6761-bd38-78e9-56d606878f33@turmel.org>
Date:   Wed, 20 Jul 2022 08:33:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
Content-Language: en-US
To:     Jani Partanen <jiipee@sotapeli.fi>,
        Wols Lists <antlists@youngman.org.uk>,
        Reindl Harald <h.reindl@thelounge.net>,
        Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
References: <87o7xmsjcv.fsf@esperi.org.uk>
 <d28a695e-1958-d438-b43d-65470c1bbe7a@youngman.org.uk>
 <8ac1185f-1522-6343-c6c4-19bd307858f4@sotapeli.fi>
 <0cbb4267-2b0d-5e34-97e0-5e4d13f3275b@youngman.org.uk>
 <4036832a-ee33-8da4-b1f6-739214c5cdad@thelounge.net>
 <130972ea-1d6c-8b60-10fc-b536e1b8db0d@youngman.org.uk>
 <58129f84-1132-26ad-654b-624c43f9431e@thelounge.net>
 <3c2a7de7-505d-1ca8-c334-b4b7d0c8fa59@youngman.org.uk>
 <1fb9ba77-e1ab-c06a-ab1d-c2acb9c2f53a@sotapeli.fi>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <1fb9ba77-e1ab-c06a-ab1d-c2acb9c2f53a@sotapeli.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

As the author of lsdrv, I can say that python3 is on my to-do list, via 
the techniques ESR recommended for mutual compatibility.  Pointless 
syntax changes like this one for constants is discouraging.

FWIW, python 2.7 (the language) is far from dead, as jython has not yet 
released a python 3 (the language) implementation.  I use jython heavily 
in my commercial work, on a platform that is very popular worldwide. 
(Ignition by Inductive Automation, if anyone cares.)

The two primary drivers of the move to python3, namely, distinguishing 
between character and bytes, and the introduction of async programming 
to mitigate the GIL, are both non-issues in jython 2.7 thanks to the 
java standard library.

I suspect python 2.7 (the language) will be alive and kicking for at 
least another decade.

On 7/19/22 18:35, Jani Partanen wrote:
> I said debian specific because it provide some debian stuff. Maybe 
> debian comes python 2.7 installed by default.
> Tool itself havent  got any update in 4 years. It really should be 
> converted to work with python3.
> IIRC python devs have said that python 2.7 should not be used anymore 
> and that was already years ago.
> 
> https://www.python.org/doc/sunset-python-2/
> 
> 
> Wols Lists kirjoitti 20/07/2022 klo 0.51:
>> On 19/07/2022 21:01, Reindl Harald wrote:
>>>
>>>
>>> Am 19.07.22 um 21:22 schrieb Wol:
>>>> On 19/07/2022 19:10, Reindl Harald wrote:
>>>>>
>>>>>
>>>>> Am 19.07.22 um 19:09 schrieb Wols Lists:
>>>>>> Well, LAST I TRIED, it worked fine on gentoo, so it's certainly 
>>>>>> not Debian-specific
>>>>>
>>>>> i can't follow that logic
>>>>
>>>> Gentoo is a rolling release. I strongly suspect that 2.7 is 
>>>> deceased. It is no more. It has shuffled off this mortal coil
>>>
>>> no matter what just because something woked fine on Gentoo don't rule 
>>> out a Debian specific problem and for sure not "certainly"
>>
>> PLEASE FOLLOW THE THREAD.
>>
>> The complaint was it was a Debian-specific PROGRAM - not problem.
>>
>> Cheers,
>> Wol
> 

