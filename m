From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Which raid card to buy for Sarge
Date: Thu, 01 Apr 2004 09:56:40 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406BAF18.8010005@wasp.net.au>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca> <406B9F3E.4020701@wasp.net.au> <406BAC2F.8090407@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <406BAC2F.8090407@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Garzik wrote:

>> With the Highpoint driver I get a drive failure and the card starts 
>> beeping. I fire up the management util, remove the faulty drive, swap 
>> it out and insert the new drive in the array. The array starts 
>> rebuilding - no effect on the uptime and only a slight loss in 
>> throughput. Plus it's seamless.
> 
> 
> Yeah, md+mdadm can do all this right now, provided the hardware and 
> driver support is there...
> 

Yes, my point however is for low budget stuff with software raid the driver support is not yet there 
in a vanilla kernel.
I can't just whack a sata drive off one of my promise SATA150-TX4 controllers, pop another one in 
and have the kernel rescan the partition table and realise a new drive was present. (YET!)

My entire point was that for the types of controllers that were being discussed (Highpoint was 
particularly mentioned, but you can really interchange any multi-port ATA/SATA controller for this) 
that the kernel support was not there *yet* but hardware raid or faux hardware raid will buy you 
this support *now*.

Regards,
Brad
