From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Which raid card to buy for Sarge
Date: Thu, 01 Apr 2004 12:03:12 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406BCCC0.8070104@wasp.net.au>
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

Yup. Currently, SCSI has the hardware and driver support.
SATA has the hardware support, but not the driver support (Yet).


Regards,
Brad
