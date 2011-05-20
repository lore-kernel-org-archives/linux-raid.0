From: Joe Landman <joe.landman@gmail.com>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 08:18:32 -0400
Message-ID: <4DD65C18.5090804@gmail.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD61948.8050302@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/20/2011 03:33 AM, Ed W wrote:
> On 20/05/2011 03:08, Andy Smith wrote:
>> Are there actually any HBAs that have BBU without using their RAID
>> features?
>>
>> I'd like to stop using hardware RAID but I can't give up the BBU and
>> write cache.

HBAs don't have BBU or write cache.  Only RAIDs do.  While you can run 
the RAID in JBOD mode, you effectively lose the cache (and BBU) aspect 
by doing so.

More in a moment.

> This is a very interesting question. Does anyone know if say the Areca
> ARC-1880ix-24 can be used in the same way, ie battery backed JBOD type mode?

If you absolutely insist on using a large expensive RAID card as a JBOD 
card, yeah, there are things you *can* do to keep access to the cache 
and BBU, though they are counter-intuitive.

First off, the LSI 920x series has a 16 port HBA.  You can look it up on 
their site.  SAS+SATA HBA I think.  LSI likes adorning some of their 
HBAs with some inherent RAID capability (their IR mode).  I personally 
prefer the IT mode, but its sometimes hard/impossible to make the switch 
(this is usually for motherboard mounted 'RAID' units). HBAs can be used 
as RAIDs, though the performance is abysmal (c.f. PERC*, lower end LSI 
... which PERC are rebranded versions of, ...)

Second off, you can turn any of the expensive RAID cards into an 'JBOD' 
by doing something like this:

1) have the unit configured in RAID mode

2) build virtual disks out of single drives, as RAID0.

3) iterate 2 until you exhaust your drives.

4) make sure you prevent these drives from messing with your boot drive 
order ... some bioses "helpfully" reorganize new drives for you by 
messing with this list.

Once the drive is a 1 disk RAID0, you get the cache, and the BBU for the 
cache.  Yeah, its a little weird.  But it does work (we've done this 
with some LSI8888's).

When you do this, then use mdadm atop this.  We've found, generally, by 
doing this, we can build much faster RAIDs than the LSI 8888 units, and 
comparible to the 9260's in terms of performance across the same number 
of disks, at a lower price.  E.g. mdadm and the MD RAID stack are quite 
good.

[...]

> I guess the limitation is that some of these cards can only create a
> small number of arrays and/or they don't use their writeback cache
> efficiently in the case of multiple arrays?

These are the issues.  Most RAID cards aren't thinking they'll be used 
on more than a few LUNs/RAIDs at a time, so they might not scale well 
here, with 16 or 24 single drive RAID0's.

The additional cache doesn't buy you much for this arrangement. Might 
work against you if the card CPU is slow (as most of the hardware RAID 
chips are).

