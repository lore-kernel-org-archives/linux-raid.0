From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Re: Mdadm server eating drives
Date: Tue, 2 Jul 2013 15:58:21 -0500
Message-ID: <CAPSPcXg_fy-YYfwa1w4=3ZzA3sb71V+Kvai7qHAXNfiS3WAXGQ@mail.gmail.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com>
	<CAPSPcXihHrAi2TB9Fuxb1qOGMc_WzwGoXAA7nHdwe2knkO0LkQ@mail.gmail.com>
	<CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com>
	<CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com>
	<51BA7B28.9030808@turmel.org>
	<CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com>
	<CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com>
	<CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com>
	<51BB8A67.5000605@turmel.org>
	<51BB8B86.9050803@turmel.org>
	<CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com>
	<alpine.DEB.2.00.1306180609260.4696@uplift.swm.pp.se>
	<CAPSPcXiXo=pVfmp770==Vvj+yMU1sLMVxNf1dwCoh0At1zz3vQ@mail.gmail.com>
	<51CC72A4.4040508@jungers.net>
	<CAPSPcXhZosdmKiG-rhQXu+NcNJ2yLjfT1hAor1cCHWi1kM08aA@mail.gmail.com>
	<51D233A5.504@hardwarefreak.com>
	<CAPSPcXjOPben0xGqcUKwyZn4pX403uFbp5f57f=LEV371ZuDjw@mail.gmail.com>
	<51D32DBB.8030401@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51D32DBB.8030401@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 2, 2013 at 2:44 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> I checked out the chassis on the NZXT site.  With the front fans
> removed, you have only 2x120mm low rpm, low static pressure, and low CFM
> exhaust fans, one on in the PSU, one top rear.  With 8 drives packed in
> such close proximity and with other lower resistance intake paths (the
> perforated chassis bottom), you won't get enough air through the front
> drive cage to cool those drives properly over a long period.
>
> However, running with the two front fans removed for a couple of days on
> an occasion or two shouldn't have overheated the drives to the point of
> permanent damage, assuming ambient air temp was ~75F or lower, and
> assuming you were not performing long array operations such as rebuilds
> or reshapes--if you did so the drives could get hot enough, long enough,
> to be permanently damaged.
>

Interesting.  Just to be clear, I never intentionally ran it without
the fans on.  The picture I sent was from when I first assembled the
server and hadn't put the fans in or plugged the machine in.  Also the
few times the fans were left of were, as you said "for a couple of
days on an occasion or two", but other than that the fans have always
been on.  It is possible though that one of those events was during a
resync, since the fans were off because I was swapping out a failed
drive and forgot to put them on.  Which is when I came home to hear
this beeping noise coming from all my drives.
https://docs.google.com/file/d/0B1w3WvCHlYUWSGdBdjh3dWpuUnc/edit?usp=sharing
I don't know what that beeping is, but it is a later recording, the
original event had many drives beeping at once (some with slightly
lower/higher pitches).  I thought maybe it might have been an overheat
alarm or something similar.  Most of those original drives have been
replaced at this point.  But it was also at that time that I first
started pulling wires on things (looking for which drives were
beeping) that I found the broken power connector.  This was back when
this all started in february.


> I wouldn't.  Most of your gear is probably fine.  Get the PSU swapped
> out and see if that fixes it.  You may still have to wipe the drives and
> build a new array.  You should know pretty quickly if the PSU swap fixed
> the problem, as drives will not continue to drop, or they will.

Good starting point, I'll do that tonight.  Any particular trusty
brands?  Otherwise all I can really go off of is price (like before, I
just tried to pay a little extra for "not the cheapest").

> Forgot to ask previously.  This system is attached to a UPS isn't it?

Yes, the server is plugged in through a dedicated UPS.

> I assume this resides on a different machine.

4 drives in an external USB enclosure.  3 are a RAID0.

> Were the drives were attached to the onboard SATA controller or an HBA?

All 6 drives and my OS SSD are plugged into onboard SATA.


Thanks for your help!
Barrett
