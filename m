From: jlewis@lewis.org
Subject: Re: Which raid card to buy for Sarge
Date: Fri, 16 Apr 2004 18:34:18 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404161833040.30488@web1.mmaero.com>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca>
 <406B9F3E.4020701@wasp.net.au> <1082125542.407fece65df29@www.tastycake.net>
 <yw1x7jwg6jt4.fsf@kth.se> <1082132955.408009db77fc2@www.tastycake.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1082132955.408009db77fc2@www.tastycake.net>
To: Nick Maynard <nick@tastycake.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 16 Apr 2004, Nick Maynard wrote:

> > Perfectly good drivers are included with the kernel.
> And this is where I got bitten.  The standard kernel drivers (HPT374 is
> supported by hpt366.o) in 2.6.5 (and 2.4.something) lock up on boot,
> during the probe bit I think.  Are you using any other module?

Sounds like the same problem I had with a Rocket100 (not RAID) which uses
the HPT370A chip.  I'm hoping eventually the hpt366 driver will be fixed
to support this chip (if it hasn't already).

----------------------------------------------------------------------
 Jon Lewis *jlewis@lewis.org*|  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
