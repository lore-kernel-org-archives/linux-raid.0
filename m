From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@kth.se>
Subject: Re: Which raid card to buy for Sarge
Date: Fri, 16 Apr 2004 19:44:44 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1x4qrjx1f7.fsf@kth.se>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca>
	<406B9F3E.4020701@wasp.net.au>
	<1082125542.407fece65df29@www.tastycake.net> <yw1x7jwg6jt4.fsf@kth.se>
	<1082132955.408009db77fc2@www.tastycake.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1082132955.408009db77fc2@www.tastycake.net> (Nick Maynard's
 message of "Fri, 16 Apr 2004 17:29:15 +0100")
To: Nick Maynard <nick@tastycake.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nick Maynard <nick@tastycake.net> writes:

>> I'm running four disks off a RocketRAID 1540 SATA card with Linux
>> software RAID since kernel 2.6.0.  The driver included with the kern=
el
>> works just fine.  Any card using the hpt374 chip should work, whatev=
er
>> the name on the box happens to be.
> Yea.  You should note that I have a Rocket 1540, not a RocketRAID
> 1540.  There's a difference

More than the box and the BIOS?

> - shown particularly by the fact that Highpoint release open drivers
> for the RocketRAID and not the Rocket.

I wouldn't use those drivers, having looked briefly at the source code
they do release.  It wasn't pretty.

> Should doesn't necessarily mean does, unfortunately.

Could the onboard bios be messing with you?  Can it be disabled?  I'm
using the card in an Alpha machine that pretty much ignores the bios
extensions.

> My reasoning was exactly the same as yours, except it's bitten me
> where it hurts...
>
>> Perfectly good drivers are included with the kernel.
> And this is where I got bitten.  The standard kernel drivers (HPT374
> is supported by hpt366.o) in 2.6.5 (and 2.4.something) lock up on
> boot, during the probe bit I think.  Are you using any other module?

I'm using the htp366 driver.

--=20
M=E5ns Rullg=E5rd
mru@kth.se
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
