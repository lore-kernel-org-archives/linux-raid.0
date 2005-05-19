From: Jay Strauss <me@heyjay.com>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Thu, 19 May 2005 13:40:22 -0500
Message-ID: <428CDD96.2070006@heyjay.com>
References: <428A09A3.9000802@heyjay.com> <428A81FB.1070201@home.se> <428CB19B.8010402@heyjay.com> <428CBB4A.8080900@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428CBB4A.8080900@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Hardy wrote:
> That's more like what we were expecting!
> 
> I can't tell you why its like that or how, but this *is* the typical
> problem with IDE. Most likely the chipset is being detected incorrectly,
> or its being detected correctly but there is some errata that's
> disabling dma, or maybe dma is experimental for the card.
> 
> Places to look for information are in the dmesg for the sis chipset's
> detection diagnostics, then on the internet as a google for your sis
> chipset number then "linux dma" maybe. You may end up with some ide
> things on your kernel command line (via grub or lilo)
> 
> I'll reiterate something I said previously though, other than
> write-caching (which is potentially dangerous) none of the other hdparm
> or IDE settings are really going to give you that much of a boost unless
> your workload is specifically tunable. They're all just little minor
> twiddles you can do - nothing even close to the difference between
> having DMA or not. So I'd just focus on enabling DMA. The other stuff is
> all uninteresting compared to it.
> 
> -Mike
> 

Thanks for the reply Mike.  After some Googling and looking at my kernel 
config file,  it seems that SIS support is a module, like so:

CONFIG_BLK_DEV_SIS5513=m

I found this link but can't find any of the files that it references

http://kerneltrap.org/comment/reply/4925/129324

I'm not sure if having CONFIG_BLK_DEV_SIS5513 as a module has anything 
to do with this.

I can't get to my box right now, because out of curiosity I did hdparm 
-D 0 /dev/hda and ran the dd test, I think it crashed the box.  The box 
is in my basement at home, so I'll have to wait until tonight.

Jay
