From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Sun, 14 Nov 2010 17:48:53 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1011141745400.1154@uplift.swm.pp.se>
References: <4CE00206.4000301@geograph.co.za>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE00206.4000301@geograph.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: Zoltan Szecsei <zoltans@geograph.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 14 Nov 2010, Zoltan Szecsei wrote:

> *If I have to reformat the drives and redo mdadm --create, other than mdadm 
> stop, how can I get rid of all the /dev/md* etc etc so that when I restart 
> this exercise, the original bad RAID does not interfere with this new 
> attempt?

Look into "--zero-superblock" for all drives.

> *Partition alignment?
> Is this relevant for modern HDs (I'm using 5900rpm Seagate 2TB drives)
> None of the mdadm helps I've googled or received speak about how to correctly 
> format the drives before running mdadm --create.
> All the benchmarks & performance tests I've found, do not bother to say 
> whether they have aligned the partitions on the HD

Me recommendation is to not use partitions at all, just use the whole 
device (/dev/sdX).

> *What is the correct fdisk or parted method get rid of the DOS & GPT flags, 
> and create a correctly aligned partition, and should this be a 0xda partiton 
> (& then I use metatdata 1.2 for mdadm)?

I just "dd if=/dev/zero of=/dev/sdX bs=1024000 count=1" to zero the first 
megabyte of the drive to get rid of the partition table (you get rid of 
the v1.2 metadata at the same time actually). Then you know for sure 
you're correctly aligned as well as md is 4k aligned.

> *Chunk size:
> After reading MANY different opinions, I'm guessing staying at the default 
> chunk size is optimal? Anyone want to add to this argument?

Default should be fine.

> *After this, do I mkfs ext4 first, or LVM first?

LVM if you want to use LVM. Filesystems live in lv:s in the LVM concept.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
