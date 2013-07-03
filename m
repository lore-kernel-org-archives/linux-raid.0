From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Mdadm server eating drives
Date: Tue, 02 Jul 2013 20:50:12 -0500
Message-ID: <51D38354.6090001@hardwarefreak.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com> <CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com> <51BA7B28.9030808@turmel.org> <CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com> <CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com> <CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com> <51BB8A67.5000605@turmel.org> <51BB8B86.9050803@turmel.org> <CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com> <alpine.DEB.2.00.1306180609260.4696@uplift.swm.pp.se> <CAPSPcXiXo=pVfmp770==Vvj+yMU1sLMVxNf1dwCoh0At1zz3vQ@mail.gmail.com> <51CC72A4.4040508@jungers.net> <CAPSPcXhZosdmKiG-rhQXu+NcNJ2yLjfT1hAor1cCHWi1kM08aA@mail.gmail.com> <51D233A5.504@hardwarefreak.com> <CAPSPcXjOPben0xGqcUKwyZn4pX
 403uFbp5f57f=LEV371ZuDjw@mail.gmail.com> <51D32DBB.8030401@hardwarefreak.com> <CAPSPcXg_fy-YYfwa1w4=3ZzA3sb71V+Kvai7qHAXNfiS3WAXGQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXg_fy-YYfwa1w4=3ZzA3sb71V+Kvai7qHAXNfiS3WAXGQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/2/2013 3:58 PM, Barrett Lewis wrote:

> https://docs.google.com/file/d/0B1w3WvCHlYUWSGdBdjh3dWpuUnc/edit?usp=sharing

Drives don't beep, they can't.  They don't contain transducers, never
have.  And you don't have a RAID card.  So that beep must be from the
motherboard connected PC speaker, which means you have raidmon or
another md monitoring daemon active.  If this is the case it was simply
giving an audible alert that a drive had been dropped.

> Good starting point, I'll do that tonight.  Any particular trusty
> brands?  Otherwise all I can really go off of is price (like before, I
> just tried to pay a little extra for "not the cheapest").

For troubleshooting purposes I'd think any recent 400+ watt ATX PSU you
have lying around should work, assuming there's no high wattage PCIe GPU
card in the box sucking +12V power, and assuming you have all the
necessary y-cables and SATA power adapters, etc.  Try a spare PSU if
possible before plunking cash on a possibly unneeded replacement.

For a permanent replacement, I'll tell ya, they're all of pretty much
similar quality today, except for the fan, after you get off the very
bottom of the barrel.  Cheap units come with cheap sleeve bearing fans
that don't last.  I buy near the bottom of the barrel and replace the
fans on day one.  I buy quality fans in bulk on closeout/overstock/etc
every few years specifically for this purpose.  Most don't have standard
2 pin PC connectors so I cut the one off the stock crap fan and solder
it to the good one.  Currently I'm draining a box of a dozen 80x25mm NMB
-30 series Boxers for PSU duty, and a box of a dozen Nidec BetaV 92x25mm
industrial fans for chassis duty.  All double ball bearing, highest
quality you can get.  Not the quietest, butthey're high CFM and high
static pressure.  Others in this class are Sanyo Denki, Pabst, Delta,
Panaflow, etc.  I won't use 120mm fans in PSUs or chassis, but that's a
discussion for another day.

Either of these two should be ok.  I'm not into the goofy lights and
what not on the Apevia, or the triple fan design (more to replace), but
at least it has a fan speed controller.  Both have great reviews, and
plenty of +12V power.  The one thing I -really- like about the Apevia is
the single +12V rail rated at 35 amps.  Single rail is always better,
contrary to popular belief.  Multiple +12V rail PSUs came into existence
because they're cheaper to produce, not because they're any better.
2/3/4 small MOSFETS, one per rail, are cheaper than one big MOSFET.
Take a look at any -real- server PSU design.  They're all single +12V
rail, some rated to 150 amps (1800 watts).

http://www.newegg.com/Product/Product.aspx?Item=N82E16817101021
http://www.newegg.com/Product/Product.aspx?Item=N82E16817148008

>> Forgot to ask previously.  This system is attached to a UPS isn't it?
> 
> Yes, the server is plugged in through a dedicated UPS.

Good, takes care of that.

>> I assume this resides on a different machine.
> 
> 4 drives in an external USB enclosure.  3 are a RAID0.

Ok, so this is your workstation, not a dedicated server?  Does it have a
PCIe GPU?  If so what wattage?  Ok, if you don't know that, what model?

>> Were the drives were attached to the onboard SATA controller or an HBA?
> 
> All 6 drives and my OS SSD are plugged into onboard SATA.

I counted 8 drives in the picture.

-- 
Stan


