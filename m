From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Which raid card to buy for Sarge
Date: Thu, 01 Apr 2004 00:44:15 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406BAC2F.8090407@pobox.com>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca> <406B9F3E.4020701@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <406B9F3E.4020701@wasp.net.au>
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell wrote:
> Mark Hahn wrote:
> 
>>> If would not use the "raid" feature of the Highpoint cards, because 
>>> it is only software raid and not so performant as a hardware raid. If 
>>> you don't need a 
>>
>>
>>
>> please don't say things like this.  HW raid is *NOT* generally
>> faster or better than software raid.  yes, if you're building a 
>> quad-gigabit fileserver out of an old P5/100 you had sitting around,
>> you're not even going to start looking at sw raid.
> 
> 
> One point. Hardware raid (and faux hardware raid) provides real hot swap 
> with on-the-fly rebuilds.
> Linux software raid can't (yet).
> Both promise and highpoint proprietary ide raid drivers can, but no raw 
> kernel or libata drivers can as yet, and the interface between the 
> hotswap driver and md driver is no where near there.

No real need to have much interfacing.  As long as the low level 
hardware and driver support hotswap, md will notice when the drive stops 
responding, or starts spitting out nothing but errors.  Of course, it is 
the nice thing to do, to use mdadm to hot-remove the drive first :)


> With the Highpoint driver I get a drive failure and the card starts 
> beeping. I fire up the management util, remove the faulty drive, swap it 
> out and insert the new drive in the array. The array starts rebuilding - 
> no effect on the uptime and only a slight loss in throughput. Plus it's 
> seamless.

Yeah, md+mdadm can do all this right now, provided the hardware and 
driver support is there...

	Jeff



