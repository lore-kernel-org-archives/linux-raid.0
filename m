From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: large devices (3ware)
Date: Wed, 21 Aug 2002 12:53:56 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1020821124910.22717A-100000@Maggie.Linux-Consulting.com>
References: <Pine.LNX.4.33.0208211514040.31769-100000@router.windsormachine.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33.0208211514040.31769-100000@router.windsormachine.com>
To: Mike Dresser <mdresser_l@windsormachine.com>
Cc: jlewis@lewis.org, effrem.norwood@exstor.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 21 Aug 2002, Mike Dresser wrote:

> On Wed, 21 Aug 2002 jlewis@lewis.org wrote:
> 

...

> > What sorts of cases are you using that allow for mounting 12 drives close
> > enough to the controller for all the cables to reach?
> 
> I was looking at a rack mount case today, that would let me put 23 drives
> in a 7" high case.  All those cables should reach with standard 18"
> cables.
> 
> About 450 bucks for the case, and around 900 for the adapters.
> 

3ware has modified hardware that allows it to drive longer ide cables
( that exceed the 18" cable length )

3ware has a 8-port ide card ... for 8 master ide disks but its
still on one pci buss ( i think thats the bottle neck )

if you have 12, 26 ide disks... you'd need a 2nd pci slot...but again
on the one pci buss...

8 disks ( 160GB each ) is 1TeraByte of data that can be moving back and
forth on that pci buss...

i think it'd be better to put one ide controller ( like the 3-ware )
into one motherboard... and use a different server for the next 8 disks

-- am looking for benchmarks of 8-24-48 hard disks systems

we have 8-drive 1U chassis  - cabling is an issue... due to 18" maximum
but so far, we havent seen any major problems w/ the 24" and 26" length
cables..
	http://www.Linux-1U.net/Dwg/jpg.sm/c2610.jpg

thanx
alvin

