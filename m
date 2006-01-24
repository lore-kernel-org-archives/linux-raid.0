From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Problems with multiple Promise SATA150 TX4 cards
Date: Tue, 24 Jan 2006 01:39:33 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0601240132560.32305-100000@coffee.psychology.mcmaster.ca>
References: <43D58A8F.6040907@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D58A8F.6040907@nighthawkrad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> So, I bought another TX4 card and another 4 SATA drives and plonked them 
> in the machine, thinking it would be as easy as the last time I did it 
> (going from 4 to 8 drives).

4 drives is easy; 8 is pushing it; 12 requires a fairly heroic system...

> The first problem is that the Promise cards' onboard BIOS(es) only 
> recognise(s) (or, at least, list) 8 of the 12 drives in the machine at 
> boot.  However, once Linux has booted it detects all three cards and all 
> twelve drives, so this is a relatively insignificant issue.

sounds like a spinup time on marginal power to me.

> The second (major) problem is whenever I try to access drives attached 
> to the "first" controller (ie: /dev/sd[abcd], I get ATA timeout errors 
> like these:

with marginal power, weird things happen...

> I have shuffled the cards,cables and physical drives around to determine 
> that this is not a problem with any of them individually - no matter the 
> combination, it only ever happens to drives that are at sd[abcd] (ie: if 
> I rejig the hardware so the drive at /dev/sdh, which was working fine, 
> is on a different cable and controller, but appears at /dev/sdb, it will 
> produce the errors).

did you test the case where all disks had power, but only 8 were plugged 
into controllers? 

> no individual card, cable or drive was responsible.  The errors _only_ 
> occur with three cards in the system, _only_ with whichever drives are 
> attached to the "first" controller (ie: sd[abcd]) and _regardless_ of 
> other system activity.

the "first" card would correspond to position on the PCI bus (slot),
so perhaps that card is getting iffy power.  but did you actually move
around which power cables are supplying which disks?

