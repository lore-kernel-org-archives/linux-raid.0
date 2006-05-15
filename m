From: Joseph Marc Olstad <solidcomputing@shaw.ca>
Subject: aesthetic request for bogus-raid warning message
Date: Mon, 15 May 2006 17:45:27 -0600
Message-ID: <1147736727.7847.21.camel@linux.site>
Reply-To: solidcomputing@shaw.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an aesthetic feature request/bug report for Novell/SuSE or
perhaps other distros
Priority, low to medium

Distro SuSE 10.0 64bit, perhaps others

I have a bootable software RAID1/RAID5 combo set up over three drives
(oddly enough it works great with 2 on the sata channel and 1 on the
ide, great work Linux RAID guys, UUU all the time).  The
feature-request/bug is this: My Motherboard (NForce410 chipset) supports
bogus-raid for windows and I have dissabled the bogus raid in the bios.
Yet every time I go into LVM and it tells me that I have to learn how to
set up a software raid (which I already have and did) and says that my
raid won't work on kernel >2.4 even though it's a software raid and is
working under 2.6.  

The first time I saw the message telling me to learn how to set up a
software raid nearly caused me to fall off my chair.  This could freak
out another raid n00b.  Luckily I pressed OK and everything was fine.
What I would think would be good is if the YaST LVM would notice that I
already have a software raid and not bring up the doomsday error message
that my bogus raid doesn't work on kernel 2.6 please learn how to set up
a software raid when my software raid is 100% fine and already set up.

This isn't a huge issue, but I thought I'd provide some feedback.  I
love my software RAID so far.  So far I haven't had to re-build it,
we'll see what happens when I have to replace a drive ;)

Joe
Solid Computing Corp
780-710-FAST




