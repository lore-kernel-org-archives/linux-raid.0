Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F7A1C43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 21:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240737AbiGSVv5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236214AbiGSVvt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 17:51:49 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108706172B
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 14:51:46 -0700 (PDT)
Received: from host86-158-105-35.range86-158.btcentralplus.com ([86.158.105.35] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oDv84-0005jd-6R;
        Tue, 19 Jul 2022 22:51:45 +0100
Message-ID: <3c2a7de7-505d-1ca8-c334-b4b7d0c8fa59@youngman.org.uk>
Date:   Tue, 19 Jul 2022 22:51:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
Content-Language: en-GB
To:     Reindl Harald <h.reindl@thelounge.net>,
        Jani Partanen <jiipee@sotapeli.fi>, Nix <nix@esperi.org.uk>,
        linux-raid@vger.kernel.org
References: <87o7xmsjcv.fsf@esperi.org.uk>
 <d28a695e-1958-d438-b43d-65470c1bbe7a@youngman.org.uk>
 <8ac1185f-1522-6343-c6c4-19bd307858f4@sotapeli.fi>
 <0cbb4267-2b0d-5e34-97e0-5e4d13f3275b@youngman.org.uk>
 <4036832a-ee33-8da4-b1f6-739214c5cdad@thelounge.net>
 <130972ea-1d6c-8b60-10fc-b536e1b8db0d@youngman.org.uk>
 <58129f84-1132-26ad-654b-624c43f9431e@thelounge.net>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <58129f84-1132-26ad-654b-624c43f9431e@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19/07/2022 21:01, Reindl Harald wrote:
> 
> 
> Am 19.07.22 um 21:22 schrieb Wol:
>> On 19/07/2022 19:10, Reindl Harald wrote:
>>>
>>>
>>> Am 19.07.22 um 19:09 schrieb Wols Lists:
>>>> Well, LAST I TRIED, it worked fine on gentoo, so it's certainly not 
>>>> Debian-specific
>>>
>>> i can't follow that logic
>>
>> Gentoo is a rolling release. I strongly suspect that 2.7 is deceased. 
>> It is no more. It has shuffled off this mortal coil
> 
> no matter what just because something woked fine on Gentoo don't rule 
> out a Debian specific problem and for sure not "certainly"

PLEASE FOLLOW THE THREAD.

The complaint was it was a Debian-specific PROGRAM - not problem.

Cheers,
Wol
