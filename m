From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Port Multipliers
Date: Fri, 11 Sep 2009 07:14:16 +1200
Message-ID: <4AA95008.4030401@sauce.co.nz>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com> 	<70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com> <c268e4660909101114h36229a34xc354a41a4f3610d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660909101114h36229a34xc354a41a4f3610d4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: "Majed B." <majedb@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Drew wrote:
>>If you're looking at port multipliers, you need to find PCI-Express
>>modules if you want them to be fast. The PCI ones are gonna be very
>>slow when you have more than 2 disks per card.
> 
> 
> The existing server we're planning to re-purpose for this is an IBM
> xSeries with two free PCI-X/100 slots and dual PCIe/x4 slots.

Your best bet might be to use one of these HBA's:
 
http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/lsisas3801e/index.html

although you would need to check whether it functions OK in an x4 slot - 
obviously the maximum performance will not be reached, but if you are 
only using one output you should be OK.

This would then be connected to an enclosure like this:

http://www.aicipc.com/ProductDetail.aspx?ref=XJ1000%20series%20-%203U%2016-bay

which contains a port expander to all the drives.

I have been running 2 similar setups (although using the LSISAS3442E-R 
version of the HBA - around $US230 in an x8 slot), for over a year 
without any trouble, with the drives configured as an md RAID6.

The HBA's can have an alternate firmware loaded which removes the 
onboard hardware RAID0,1 functionality.

Regards,

Richard
