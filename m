Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20097C43334
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 07:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiFIHBe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Jun 2022 03:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiFIHBd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Jun 2022 03:01:33 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDECB53C5C
        for <linux-raid@vger.kernel.org>; Thu,  9 Jun 2022 00:01:31 -0700 (PDT)
Received: from host86-156-102-78.range86-156.btcentralplus.com ([86.156.102.78] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nzCAb-0005yX-9w;
        Thu, 09 Jun 2022 08:01:29 +0100
Message-ID: <ba0d6708-1275-6fac-b387-40d5673d6002@youngman.org.uk>
Date:   Thu, 9 Jun 2022 08:01:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: MD Array Unexpected Kernel Hang
Content-Language: en-GB
To:     Alan Braithwaite <alan@braithwaite.dev>,
        o1bigtenor <o1bigtenor@gmail.com>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
References: <0fa973c1-2961-4f8f-99fa-b427a5c694fd@www.fastmail.com>
 <CAPpdf5-wEfpHnteLAG-EHD-we+b+0=KB7RcD=U9dw6K-_3f48w@mail.gmail.com>
 <b80c6d10-760e-40a2-b9ca-86aabf3267d0@www.fastmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <b80c6d10-760e-40a2-b9ca-86aabf3267d0@www.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 09/06/2022 01:25, Alan Braithwaite wrote:
> Appreciated.  Only reason I didn't include it initially is because it's a giant wall of text (which the other debugging info was anyway, so I should have just been proactive).
> 
> Anyway, it can now be found below, annotated with the failing drives first.

The thing that jumps out at me from that is while SMART is available and 
enabled, it should list a bunch of SMART settings, including SCT/ERC. I 
can't see that. That's worrying.

A quick google also says these are old drives, which may or not be a 
concern. That also possibly explains the lack of sct/erc.

Given that you say three drives all failed in the first slot? My money 
would actually be on nothing to do with raid, but a dodgy cable or 
motherboard connector. I don't think they're rated at being swapped over 
that many times ...

I don't know how much help this website will be for you, but take a look...

https://raid.wiki.kernel.org/index.php/Linux_Raid

You've already done some of what this asks for, and I don't actually 
know that the rest of this will be much use ...
https://raid.wiki.kernel.org/index.php/Asking_for_help

Cheers,
Wol
