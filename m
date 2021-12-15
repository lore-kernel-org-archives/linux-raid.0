Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21AFC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 21:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhLOVpu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Dec 2021 16:45:50 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:54650 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhLOVpt (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 15 Dec 2021 16:45:49 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mxc5r-000148-By; Wed, 15 Dec 2021 21:45:48 +0000
Message-ID: <8ebfb6f7-e9bc-0f10-2dfa-2e4b7bb174af@youngman.org.uk>
Date:   Wed, 15 Dec 2021 21:45:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Debugging system hangs
Content-Language: en-GB
To:     John Stoffel <john@stoffel.org>, Phil Turmel <philip@turmel.org>
Cc:     Roman Mamedov <rm@romanrm.net>,
        linux-raid <linux-raid@vger.kernel.org>
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
 <20211214224658.26cea5a0@nvm>
 <4187acd4-ece5-9d39-a008-5aa01c9b6d76@turmel.org>
 <25017.16380.261760.406891@quad.stoffel.home>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <25017.16380.261760.406891@quad.stoffel.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/12/2021 01:08, John Stoffel wrote:
> Can you explain more about your hardware?  Is it new?  Have you made
> any changes recently?  Is there any over clocking?  As for changes,
> I'm talking both hardware and software.  What daemons are you running?
> Anything that changed is a good thing to take a long hard look at.

Well, it's a new system that's about three years old ... it's a 
home-built, most of which I bought about three years ago, and I'm 
finally finishing off commissioning it.

The hard drives are new Seagate Ironwolves x2 and an old Barracuda, 32GB 
of new DDR4 ram, and a Radeon 4350 video card which is also old but 
hardly used.
> 
> If you have another system, remote syslog might also be something to
> add into the mix.  I also really like serial consoles, so you can
> capture all the output onto another system easily.
> 
Hardware bought for this system is being re-purposed into a raid 
test-bed so I will hopefully have one available soon (if anyone in SE 
London has any 1TB drives they don't want, they'll be welcome for 
this... :-)

> It might also be useful to try going back to an older kernel, but I
> haven't a clue how hard that is with gentoo.  Does the distro still
> expect you to compile everything and bootstrap yourself these days?

Pretty much. There are utilities that make it un-necessary, but it's 
easy enough and encouraged ... so my trouble COULD be as simple as a 
misconfigured kernel ...

But all this will be a learning experience :-)

Cheers,
Wol
