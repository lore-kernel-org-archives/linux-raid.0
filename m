From: Nick Maynard <nick@tastycake.net>
Subject: Re: Which raid card to buy for Sarge
Date: Fri, 16 Apr 2004 17:29:15 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1082132955.408009db77fc2@www.tastycake.net>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca> <406B9F3E.4020701@wasp.net.au> <1082125542.407fece65df29@www.tastycake.net> <yw1x7jwg6jt4.fsf@kth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yw1x7jwg6jt4.fsf@kth.se>
To: =?iso-8859-1?b?TeVucyA=?= =?iso-8859-1?b?UnVsbGflcmQ=?= <mru@kth.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I'm running four disks off a RocketRAID 1540 SATA card with Linux
> software RAID since kernel 2.6.0.  The driver included with the kernel
> works just fine.  Any card using the hpt374 chip should work, whatever
> the name on the box happens to be.
Yea.  You should note that I have a Rocket 1540, not a RocketRAID 1540.  There's
a difference - shown particularly by the fact that Highpoint release open
drivers for the RocketRAID and not the Rocket.
Should doesn't necessarily mean does, unfortunately.  My reasoning was exactly
the same as yours, except it's bitten me where it hurts...

> Perfectly good drivers are included with the kernel.
And this is where I got bitten.  The standard kernel drivers (HPT374 is
supported by hpt366.o) in 2.6.5 (and 2.4.something) lock up on boot, during the
probe bit I think.  Are you using any other module?

Cheers,

--

Nick Maynard
nick@tastycake.net
