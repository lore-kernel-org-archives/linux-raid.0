From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid5 reshape stuck at 0% - SuSE leap 42.1
Date: Sun, 7 Aug 2016 18:58:06 +0100
Message-ID: <57A776AE.3050308@youngman.org.uk>
References: <57A69012.1010406@youngman.org.uk>
 <alpine.DEB.2.02.1608071154110.3593@uplift.swm.pp.se>
 <57A719CC.6080301@youngman.org.uk> <57A724ED.5070808@youngman.org.uk>
 <alpine.DEB.2.02.1608071630050.3593@uplift.swm.pp.se>
 <57A766DC.4000207@youngman.org.uk>
 <alpine.DEB.2.02.1608071923410.3593@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1608071923410.3593@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/08/16 18:24, Mikael Abrahamsson wrote:
> On Sun, 7 Aug 2016, Wols Lists wrote:
> 
>> [17431.752149] md/raid:md127: reshape_position too early for
>> auto-recovery - aborting.
> 
> Does the hint in the below URL help?
> 
> http://www.spinics.net/lists/raid/msg52319.html
> 
> (to use "--update=revert-reshape")
> 
Okay - it's worked - as in I've got a working array back - a two-drive
raid 5 array with two spares.

So hwo do I now get it to rebuild successfully to give me a working full
raid 5?

I'm guessing it should be "mdadm --grow --raid-devices=3
--backup-file=whatever", but I think I've already tried that, and that's
what got me into this mess :-)

I'm trying to get access to the linux-raid wiki, so once I've got this
working, and I've got the access, all this stuff is going to be written
up and posted to the wiki :-)

Cheers,
Wol
