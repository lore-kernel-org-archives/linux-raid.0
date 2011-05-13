From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm does not create partition devices whatsoever, "partitionable"
 functionality broken
Date: Fri, 13 May 2011 15:22:09 -0400
Message-ID: <4DCD84E1.3040704@turmel.org>
References: <4DCD4A83.8060202@pulseforce.com>	<4DCD6119.3080705@turmel.org>	<4DCD67EF.1070602@pulseforce.com>	<4DCD6B27.70402@pulseforce.com> <20110513234055.4307c536@natsu> <4DCD72AF.1070809@pulseforce.com> <4DCD75FE.8010703@turmel.org> <4DCD7E78.6050000@pulseforce.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DCD7E78.6050000@pulseforce.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher White <linux@pulseforce.com>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Christopher,

On 05/13/2011 02:54 PM, Christopher White wrote:
> Hello again Phil (and Roman). Thanks to your back-and-forth, the bug has now finally been completely narrowed down: It is a bug in (g)parted!

Good to know.  A pointer to the formal bug report would be a good followup, when you have it.

> The issue is that (g)parted doesn't properly call the kernel API for re-scanning the device when you operate on md disks as compared to physical disks.
> 
> Your information (Phil) that (g)parted chokes on an assertion is good information for when I report this bug. It's not impossible that you must handle md-disks differently from physical disks and that (g)parted is not aware of that distinction, therefore choking on the partition table rescan API.
> 
> Either way, this is fantastic news, because it means it's not an md kernel bug, where waiting for a fix would have severely pushed back my current project. I'm glad it was simply (g)parted failing to tell the kernel to re-read the partition tables.
> 
> ---
> 
> With this bug out of the way (I'll be reporting it to parted's mailing list now),one thing that's been bugging me during my hours of research is that the vast majority of users use either a single, large RAID array and virtually partition that with LVM, or alternatively breaking each disk into many small partitions and making multiple smaller arrays out of those partitions. Very few people seem to use md's built-in support for partitionable raid arrays.
> 
> This makes me a tiny bit wary to trust the stability of md's partitionable implementation, even though I suspect it is rock solid. I suspect the reason that most people don't use the feature is for legacy/habit reasons, since md used to support only a single partition, so there's avast amount of guides telling people to use LVM. Do any of you know anything about this and can advise on whether I should go for a single-partition MD array with LVM, or a partitionable MD array?
> 
> As far as performance goes, the CPU overhead of LVM is in the 1-5% range from what I've heard, and I have zero need for the other features LVM provides (snapshots, backups, online resizing, clusters of disks acting as one disk, etc), so it just feels completely overkill and worthless when all I need is a single, partitionable RAID array.

I always use LVM.  While the lack of attention to MD partitions might justify that, the real reason is the sheer convenience of creating, manipulating, and deleting logical volumes on the fly.  While you may not need it *now*, when you discover that you *do* need it, you won't be able to use it.  Online resizing of any of your LVs is the killer feature.

Also, I'd be shocked if the LVM overhead for plain volumes was close to 1%.  In fact, I'd be surprised if it was even 0.1%.  Do you have any benchmarks that show otherwise?

> All I need is the ability to (in the future) add more disks to the array, grow the array, and then resize+move the partitions around using regular partitioning tools treating the RAID array as a single disk, and md's partitionable arrays support doing this since they act as a disk, where if you add more hard disks to your array; the available, unallocated space on that array simply grows and partitions on it can be expanded and relocated to take advantage of this. I don't need LVM for any of that, as long as md's implementation is stable.

If you can take the downtime, this is true.

Phil
