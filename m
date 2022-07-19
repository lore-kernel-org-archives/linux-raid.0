Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE88C43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 22:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238680AbiGSWfs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237616AbiGSWfr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 18:35:47 -0400
Received: from box.sotapeli.fi (sotapeli.fi [37.59.98.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC42192AF
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 15:35:46 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0D10383694;
        Wed, 20 Jul 2022 00:35:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sotapeli.fi; s=dkim;
        t=1658270142; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=7xOUgZwzc+qxtKft7PjLISfUuNnaFSVcSj1f9d+JWCI=;
        b=olZisA6JABRfe3T/sGHk+PsMv6eunU4MhsBjrh7fCcNxdh8S2uXY5PM9Xkfkle7zkNO8Wy
        h+4h8zrHbRHyMY6727gIXIt6pBPU4i6a4278usRQaZ5Xiiwib++VdLxnre4AJkpJdfd2eh
        VIYIntPhgwJMmD5I1qfMFaHJP7W0gVCKHNBPvBPxpV09pNZuEDwGffrRcpJIJh0DTVL8dW
        JgmWTvDkjVUw1aytmrIMtNRSVX6bO4PyZIjxeIGI3dgEij9NhWKklieBjUnCUNnRlDgCy+
        ljJQk9/U5o2EB0n6+1IIgtrADpSVSN5JPhLhSYXyBXuAsQ8slFfZ3DFyMh4jGQ==
Message-ID: <1fb9ba77-e1ab-c06a-ab1d-c2acb9c2f53a@sotapeli.fi>
Date:   Wed, 20 Jul 2022 01:35:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
To:     Wols Lists <antlists@youngman.org.uk>,
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
From:   Jani Partanen <jiipee@sotapeli.fi>
In-Reply-To: <3c2a7de7-505d-1ca8-c334-b4b7d0c8fa59@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I said debian specific because it provide some debian stuff. Maybe 
debian comes python 2.7 installed by default.
Tool itself havent  got any update in 4 years. It really should be 
converted to work with python3.
IIRC python devs have said that python 2.7 should not be used anymore 
and that was already years ago.

https://www.python.org/doc/sunset-python-2/


Wols Lists kirjoitti 20/07/2022 klo 0.51:
> On 19/07/2022 21:01, Reindl Harald wrote:
>>
>>
>> Am 19.07.22 um 21:22 schrieb Wol:
>>> On 19/07/2022 19:10, Reindl Harald wrote:
>>>>
>>>>
>>>> Am 19.07.22 um 19:09 schrieb Wols Lists:
>>>>> Well, LAST I TRIED, it worked fine on gentoo, so it's certainly 
>>>>> not Debian-specific
>>>>
>>>> i can't follow that logic
>>>
>>> Gentoo is a rolling release. I strongly suspect that 2.7 is 
>>> deceased. It is no more. It has shuffled off this mortal coil
>>
>> no matter what just because something woked fine on Gentoo don't rule 
>> out a Debian specific problem and for sure not "certainly"
>
> PLEASE FOLLOW THE THREAD.
>
> The complaint was it was a Debian-specific PROGRAM - not problem.
>
> Cheers,
> Wol

