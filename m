From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Tue, 7 Apr 2009 13:22:25 -0500
Message-ID: <20090407182227.PZXS26228.cdptpa-omta04.mail.rr.com@Leslie>
References: <87f94c370904061516t51b74f26g9d2b02c09f27283f@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370904061516t51b74f26g9d2b02c09f27283f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> It may or may not be as simple as you describe.
> 
> A lot of modern PSUs have multiple rails.  Each rail is independent
> and provides some number of watts.

Now we are in the area where I am a completely qualified expert.  Designing
power systems is one of my primary tasks, and I regularly design power
systems far larger (up to 100,000 amperes and 5.4 Megawatts) and more
sophisticated than those in PCs.
 
> So if your CPU / graphic rail(s) are getting 300 watts out of your
> 550, then that only leave 250.  And that can be split among 2 or 3
> rails as well.

Since the CPU and graphics card are not even on the same power supply as the
drives, let alone a common rail, this can't apply, can it?  I don't know off
the top of my head how much power the (embedded) GPU uses, but if it is
close to 425 Watts, I'll eat my hat.  The CPU is rated at 125 Watts.  I
haven't checked, but I doubt the eSATA controller is more than 3 watts,
given it has no heat sinks.  At high speed, the fans chew up 35 watts on the
main chassis, although the fans rarely run at more than 1/2 speed.  The
keyboard and mouse are trivial.  I don't know exactly what the fans on the
array draw, but it can't be more than 30 watts - probably much less.

> It definitely gets complicated.

'Not really.  PC supplies are trivial compared to the ones with which I deal
daily.

> Or you may have a simple design where all the 5v lines are tied
> together, same for +12v,-12v.

Yes, my response was simplified.  I checked the total current carrying
capability of each system when I purchased them.  The RAID array supply has
a single 12 rail, a single -12v rail, and a single 5v rail.  It's rated to
be able to handle the spin-up current of 12 of the Hitachi Deskstar drives
on all rails, that being the drive with the highest spin-up current
requirements on all three supplies.  As I said, one of them could be bad,
but the power supplies are not below spec.

> OTOH, if your having issues with power you should be seeing sata
> transmission errors reported in the kernel log.  I don't recall your
> saying, but I assume you've been watching that and nothing is showing
> up during these events?

Yes, I did say, more than once I believe.  There are no errors of any sort
in the logs other than those on the UPS due to a known bug in the UPS
driver, and on the 230G SATA drive, which is known to have problems, but is
not part of the array.  Other than those, the logs only show temperature
info from smartd and sensord, DHCP bindings, etc.

