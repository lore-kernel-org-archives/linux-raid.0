From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Which raid card to buy for Sarge
Date: Thu, 01 Apr 2004 03:07:02 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406BCDA6.1030902@pobox.com>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca> <406B9F3E.4020701@wasp.net.au> <406BAC2F.8090407@pobox.com> <406BAF18.8010005@wasp.net.au> <20040401074921.GA27234@bluff>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040401074921.GA27234@bluff>
To: Sandro Dentella <sandro.dentella@tin.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sandro Dentella wrote:
> On Thu, Apr 01, 2004 at 09:56:40AM +0400, Brad Campbell wrote:
> 
>>Jeff Garzik wrote:
>>
>>
>>>>it out and insert the new drive in the array. The array starts 
>>>>rebuilding - no effect on the uptime and only a slight loss in 
>>>>throughput. Plus it's seamless.
>>>
>>>Yeah, md+mdadm can do all this right now, provided the hardware and 
>>>driver support is there...
>>>
>>
>>Yes, my point however is for low budget stuff with software raid the driver 
>>support is not yet there in a vanilla kernel.
>>I can't just whack a sata drive off one of my promise SATA150-TX4 
>>controllers, pop another one in and have the kernel rescan the partition 
>>table and realise a new drive was present. (YET!)
> 
> 
> I'm sort of confused... which are the combinations that allow me to hotswap a
> disk w/ software raid. I don't mind doing some mdadm operations, I'm just
> interested in how I can avoid rebooting. 
> 
> I thought I couldn't, now I learn you can "provided the hardware and driver
> support is there"... can you detail a little more?

AFAICS, the steps should be:

1) (optional) be nice, and tell md you are about to yank a drive using 
hot-remove
2) (required on ICH5, optional on others) be nice, and tell SATA you are 
about to yank a drive (not implemented yet in libata)
3) unplug the SATA cable
4) swap out drives
5) plug in the SATA cable (kernel automatically notices the new device; 
not implemented yet in libata)
6) new device is probed by kernel SATA driver
7) kernel executes /sbin/hotplug (normal for any hotplug event)
8a) /sbin/hotplug magic issues the md ioctls to hot-add a new device. 
This requires some knowledge in code, or in a config file, of how to 
associate a new device on a random controller with a specific array.
	or
8b) sysadmin uses mdadm to hot-add the new device, to the specified array.


