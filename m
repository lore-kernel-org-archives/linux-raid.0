From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Which raid card to buy for Sarge
Date: Thu, 01 Apr 2004 08:49:02 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406B9F3E.4020701@wasp.net.au>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
>>If would not use the "raid" feature of the Highpoint cards, because it is only 
>>software raid and not so performant as a hardware raid. If you don't need a 
> 
> 
> please don't say things like this.  HW raid is *NOT* generally
> faster or better than software raid.  yes, if you're building a 
> quad-gigabit fileserver out of an old P5/100 you had sitting around,
> you're not even going to start looking at sw raid.

One point. Hardware raid (and faux hardware raid) provides real hot swap with on-the-fly rebuilds.
Linux software raid can't (yet).
Both promise and highpoint proprietary ide raid drivers can, but no raw kernel or libata drivers can 
as yet, and the interface between the hotswap driver and md driver is no where near there.

With the Highpoint driver I get a drive failure and the card starts beeping. I fire up the 
management util, remove the faulty drive, swap it out and insert the new drive in the array. The 
array starts rebuilding - no effect on the uptime and only a slight loss in throughput. Plus it's 
seamless.

I used a pair of Highpoint Rocketraid 1540 cards with the Highpoint driver (as it presented all 8 
drives as 8 units on a scsi chain) with linux md raid-5, and I have now moved onto 3 Promise 
SATA150-TX4 units in an md raid-5.

I did play with the highpoint raid-5 (which can now span controllers) and it's management features, 
hotswap and hot-rebuild were quite good.

Not that I'm advocating hardware or faux hardware raid, just noting that linux software raid still 
has a large deficiency.

Regards,
Brad
