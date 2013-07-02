From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Re: Mdadm server eating drives
Date: Tue, 2 Jul 2013 10:48:59 -0500
Message-ID: <CAPSPcXjOPben0xGqcUKwyZn4pX403uFbp5f57f=LEV371ZuDjw@mail.gmail.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com>
	<51B896A2.9090105@websitemanagers.com.au>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51D233A5.504@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

After sending the last email I went out and bought 2 new WD reds, and
a new motherboard.  I came back and in those 2 hours all but 1 of my
drives failed to the point of being unable to read the superblock so
it really seems like my array is ended

On Mon, Jul 1, 2013 at 8:57 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> I noticed one drive was going up and down and determined that
>> the drive had actual physical damage to the power connecter and
>> was losing and regaining power through vibration.
>
> This intermittent contact could have damaged the PSU.  You've continued
> to have drive and lockup problems since replacing this drive with bad
> connector.

I hadn't thought of it until you said so but I bet you are right about
the iffy connector.  It certainly seemed as if I never had an issue
with the array for 8 months, and then suddenly everything got unstable
at once, and since then I've lost atleast 6 hard drives.

>
> The pink elephant in the room is thermal failure due to insufficient
> airflow.  The symptoms you describe sound like drives overheating.  What
> chassis is this?  Make/model please.  If you've installed individual
> drive hot swap cages, etc, it would be helpful if you snapped a photo or
> two and made those available.
>
>

It is also possible that there were cooling issues.  The case is an
NZXT H2.  It has some fans blowing directly on all the hard drives,
but there were a few times I have to admit I took the fans off to work
on things and forgot to put them back on for a few days, coming back
to find them very hot to the touch.  I would have mentioned that
earlier, but a data recovery place told me that it was unlikely that
would be a culprit (after they had my money).

I don't have any drives in special cages but here's a pic anyway.  The
two fanboxes that sit in front of them are taken off.
https://docs.google.com/file/d/0B1w3WvCHlYUWRVhWOVd0Qmt1TUk/edit?usp=sharing


Maybe thats all academic at this point.  I guess i'll have to rebuild
my server from scratch since all my disks seem destroyed and I can't
trust the mobo, cpu, or psu.  Atleast I can memtest the ram.  The psu
wasn't dirt cheap, Thermaltake TR2 500w @ $58.  Should I buy all new
everything?  If so, while I'm at can you suggest a set of consumer
level hardware ideal running a personal mdadm server.  Powered but not
overpowered, reliable not bleeding edge.  If I need 6-8 sata ports,
should I do onboard or get a controller?

I still have one backup allthough I'm very nervous now since it's on a
3 disk RAID0, just asking to implode (created in an emergency).
