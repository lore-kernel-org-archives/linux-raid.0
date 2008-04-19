From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: RE: Software/ Hardware RAID info
Date: Sat, 19 Apr 2008 14:10:07 +0100
Message-ID: <18441.61231.961400.928853@tree.ty.sabi.co.uk>
References: <1208560939.7243.146.camel@isis>
	<A20315AE59B5C34585629E258D76A97C087DB6@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C087DB6@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> I am new to setting up RAID arrays, and I have experimented
>> in the past with software only RAID, but now I have a new
>> Dell PowerEdge 1900 with a SAS RAID controller daughter card.

>> My question is: What is the difference in tools that I will
>> use to create and manage this hardware array?  Can I still
>> use all the same techniques and tools such as mdadm, LVM2,
>> and GParted to manage my array? or is it all in the bios.

Either way. Some people prefer hw/BIOS RAID, some people prefer
sw/Linux RAID. I prefer the latter in most cases because of its
flexibility, but the former is simpler to deal with.

>> Another question is how should I format these disks?

My usual generic advice is to use RAID10, unless you really know
what you are doing, and JFS as filesystem on top. You can't go
much wrong with these choices.

I guess that in your case convenience is more important than
flexibility and hw/BIOS RAID10 may be simpler to setup than
sw/Linux RAID10, even if the latter is particularly flexible.

Also I dread to think of people who use LVM2 at all, and in
particular with RAID, as there are many pitfalls, and LVM is
almost always unncessary (except in two cases perhaps, and I
don't think even in those case it makes much sense anymore).

>> Typically I would use a root file system, and a swap file
>> system that is twice the size of my memory.

Simple and flexible.

>> Since all four of my disks are used for hardware RAID, can I
>> partition this into 2 array's? one for my root, and the other
>> for swap...

That sounds very peculiar. Linux swap does not really need RAID,
except perhaps RAID1 for extreme cases.

>> Any advice into setting this up is greatly appreciated.

> The simple answer is that nobody can give you anything but a
> generic answer unless you supply much more data.

So I tried :-).

> [ ... ] You did the write thing to ask before you set it up.
> For what it is worth, if you got a contract from Dell, then
> they will typically spend time on the phone at least helping
> you figure out the basics. [ ... ]

Uhm, I would not suggest asking Dell support for this. More like
suggest finding some good papers on RAID, and some HOWTOs, and
studying them carefully. Storage design is a complex and
difficult subject that might take years of study, not call
centre advice over the phone.

Or just my pithy "can't go much wrong" extremely generic advice
above for those without the time.
