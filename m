From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Stress testing system?
Date: Fri, 8 Oct 2004 19:49:49 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410082349.i98NnsN19757@www.watkins-home.com>
References: <41670DF3.5040807@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41670DF3.5040807@h3c.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When using wget, run it on both systems (full duplex).  This will transfer
about twice as much data per second.  Assuming you have a full duplex
network!  If not, switches are very low cost today.

I think this is what you intended, but your note was vague IMO.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mike Hardy
Sent: Friday, October 08, 2004 6:00 PM
To: 'linux-raid@vger.kernel.org'
Subject: Re: Stress testing system?


This is a little off topic, but I stress systems with four loops

loop one unpacks the kernel source, moves it to a new name, unpacks the 
kernel source again, and diffs the two, deletes and repeats (tests 
memory, disk caching)

loop two unpacks the kernel source, does a make allconfig and a make -j5 
bzImage modules, then a make clean and repeats. should get the cpu burning

loop three should run bonnie++ on the array

loop four should work with another machine. each machine should wget 
some very large file (1GBish) with output to /dev/null so that the NIC 
has to serve interrupts at max

If that doesn't cook your machine in 48 hours or so, I can't think of 
anything that will.

This catches out every machine I try it on for some reason or another, 
but after a couple tweaks its usually solid.

Slightly more on-topic, one thing that I have do to frequently is boot 
with noapic or acpi=off due to interrupt handling problems with various 
motherboards.

Additionally, I think there have been reports of problems with raid and 
LVM, and there have also been problems with SATA and possibly with 
Maxtor drives, so you have may have some tweaking to do. Mentioning 
versions of things (distribution, kernel, hardware parts and part 
numbers etc) would help

I'm interested to hear what other people do to burn their machines in 
though...

Good luck.
-Mike

Robin Bowes wrote:
> Hi,
> 
> I've got six 250GB Maxtor drives connected to 2 Promise SATA controllers 
>  configured as follows:
> 
> Each disk has two partitions: 1.5G and 248.5G.
> 
> /dev/sda1 & /dev/sdd1 are mirrored and form the root filesystem.
> 
> /dev/sd[abcdef]2 are configured as a RAID5 array with one hot spare.
> 
> I use lvm to create a 10G /usr partition, a 5G /var partition, and the 
> rest of the array (994G) in /home.
> 
> The system in which I installed these drives was rock-solid before I 
> added the RAID storage (it had a single 120G drive). However, since 
> adding the 6 disks I have experienced the system simply powering down 
> and requiring filesystem recovering when it restarted.
> 
> I suspected this was down to an inadequate power supply (it was 400W) so 
> I've upgrade to an OCZ 520W PSU.
> 
> I'd like to stress test the system to see if the new PSU has sorted the 
> problem, i.e. really work the disks.
> 
> What's the best way to do get all six drives working as hard as possible?
> 
> Thanks,
> 
> R.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

