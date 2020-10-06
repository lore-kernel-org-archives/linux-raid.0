Return-Path: <SRS0=H5I/=DN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5408C4363D
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 11:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C0C52083B
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 11:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgJFL3k (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Oct 2020 07:29:40 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:32402 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgJFL3k (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 6 Oct 2020 07:29:40 -0400
Received: from host86-157-96-171.range86-157.btcentralplus.com ([86.157.96.171] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kPlA1-000BeG-67; Tue, 06 Oct 2020 12:29:38 +0100
Subject: Re: do i need to give up on this setup
To:     Roger Heflin <rogerheflin@gmail.com>,
        Daniel Sanabria <sanabria.d@gmail.com>
Cc:     Roman Mamedov <rm@romanrm.net>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAHscji30ACa2d0qz-nr5vqPYOP642dwjS5BY07g2DQS7GBG-2A@mail.gmail.com>
 <20201005184449.54225175@natsu>
 <CAHscji0pNezf6xCpjWto5-21ayoCeLWm34GTYh5TSgxkOw90mw@mail.gmail.com>
 <20201005190421.4ecd8f1b@natsu>
 <CAHscji1VrccTOaQc4GdWof4E+Bzs5KL0-tJJj0ZUM9Db=QBriw@mail.gmail.com>
 <CAAMCDedZfx+w3NT_QgB0KGkeEQikCtYVy9YuiNEhNaEjXF1C8w@mail.gmail.com>
 <CAHscji01ikKz4fQ_9i4Tb3AraTD+ZcXBbK-Mm+zY4p3p2qbF4Q@mail.gmail.com>
 <CAAMCDeeRNnoC6mdj7L1PdD5Ztek1tzm++UPi3k=hWvBUA=oLxQ@mail.gmail.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <5be31543-22ec-dd9f-fd08-d759c4b0df3a@youngman.org.uk>
Date:   Tue, 6 Oct 2020 12:29:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAAMCDeeRNnoC6mdj7L1PdD5Ztek1tzm++UPi3k=hWvBUA=oLxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 06/10/2020 11:53, Roger Heflin wrote:
> When the card has an
> issue all of the ports seem to stop responding to commands.  I am
> guessing the firmware on the card somehow crashes or gets into some
> sort of endless loop.  I reported it to marvel, they blamed the OS'es
> ACHI drivers,even though the AHCI drivers worked perfectly fine with
> the built in AMD ports.

So we've got the crap drives on the crap controllers ... would it make 
any difference if you put the Greens on the motherboard, and the Caviars 
on the Marvell? Caviars I believe are good quality drives that might 
take enough load off the Marvell to enable it to work sort-of okay ...

Oh - and replace the Greens pretty soon - I don't know how they compare 
against other drives quality-wise, but they are optimised in a raid 
anti-pattern.

Cheers,
Wol
