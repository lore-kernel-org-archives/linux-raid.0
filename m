Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40372C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 01:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhLOBIN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Dec 2021 20:08:13 -0500
Received: from li1843-175.members.linode.com ([172.104.24.175]:35136 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhLOBIN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Dec 2021 20:08:13 -0500
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id C0CDF1E80A;
        Tue, 14 Dec 2021 20:08:12 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 494DEA76D6; Tue, 14 Dec 2021 20:08:12 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25017.16380.261760.406891@quad.stoffel.home>
Date:   Tue, 14 Dec 2021 20:08:12 -0500
From:   "John Stoffel" <john@stoffel.org>
To:     Phil Turmel <philip@turmel.org>
Cc:     Roman Mamedov <rm@romanrm.net>,
        Wols Lists <antlists@youngman.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Re: Debugging system hangs
In-Reply-To: <4187acd4-ece5-9d39-a008-5aa01c9b6d76@turmel.org>
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
        <20211214224658.26cea5a0@nvm>
        <4187acd4-ece5-9d39-a008-5aa01c9b6d76@turmel.org>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Phil" == Phil Turmel <philip@turmel.org> writes:

Phil> On 12/14/21 12:46 PM, Roman Mamedov wrote:
>> On Tue, 14 Dec 2021 15:54:50 +0000
>> Wols Lists <antlists@youngman.org.uk> wrote:
>> 

>>> Any advice on how to debug a hang - basically I need something that'll
>>> just sit there so when it crashes (and I press the reset button to
>>> recover) I'll have some sort of trace. It would be nice to prove it's
>>> not the disk stack at fault ...
>>> 
>>> Obviously, "set these options in the kernel" won't faze me ...
>> 
>> Set up "netconsole":
>> https://www.kernel.org/doc/html/latest/networking/netconsole.html
>> https://wiki.ubuntu.com/Kernel/Netconsole
>> 

Phil> +1 for netconsole.  Also enable the SysRq key for thread dumps.
Phil> So you have the dump before you reset.

Can you explain more about your hardware?  Is it new?  Have you made
any changes recently?  Is there any over clocking?  As for changes,
I'm talking both hardware and software.  What daemons are you running?
Anything that changed is a good thing to take a long hard look at.  

If you have another system, remote syslog might also be something to
add into the mix.  I also really like serial consoles, so you can
capture all the output onto another system easily.

It might also be useful to try going back to an older kernel, but I
haven't a clue how hard that is with gentoo.  Does the distro still
expect you to compile everything and bootstrap yourself these days?

Good luck!
John

