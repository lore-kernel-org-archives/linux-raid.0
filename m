From: "John Stoffel" <john@stoffel.org>
Subject: Re: Partitioning md devices versus partitioining underlying devices
Date: Fri, 7 Apr 2006 09:36:33 -0400
Message-ID: <17462.27361.399266.911375@smtp.charter.net>
References: <443532DA.7090809@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <443532DA.7090809@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


andy> Here's a concrete example. I have two 3ware RAID-5 arrays, each
andy> made up of 12 500 GB drives. When presented to Linux, these are
andy> /dev/sda and /dev/sdb -- each 5.5 TB in size.

andy> I want to stripe the two arrays together, so that 24 drives are
andy> all operating as one unit. However, I don't want an 11 TB
andy> filesystem. I want to keep my filesystems down below 6 TB.

Why?  What are you issues with large filesystems?  I assume this is
related to your NAS -> NAS mirror question as well.  Also, what will
you do if a single controller fails?  Or do you care?  

andy> 1)  partition the 3ware devices to make /dev/sda1, /dev/sda2, /dev/sdb1 
andy> and /dev/sdb2.  Then I can create TWO md RAID-0 devices -- /dev/sda1 + 
andy> /dev/sdb1 = /dev/md1, /dev/sda2 + /dev/sdb2 = /dev/md2

andy> OR

andy> 2) create /dev/md1 from the entire 3ware devices -- /dev/sda + /dev/sdb 
andy> = /dev/md1 -- and then partition /dev/md1 into two devices.

The general plan I would use is to start at the low level and go from:

	/dev/sda1 -> md1 -> LVM -> partition

But the question is whether to use Hardware RAID5, or Software RAID5.
If the data is really important, I'd probably think seriously about
using Neil's RAID6 patches because a single disk failure takes so long
to re-sync and recover from, and RAID6 helps close that gap alot.

So I think I'd probably just ignore a controller failing issue, since
I'm mirroring the data to a totally seperate device, and just build a
single large RAID6 device with a single hot spare disk.  So you'd have
21 x 500GB worth of data.  

Heck, I'd also look into getting a server with multiple PCI busses and
getting non-3ware controllers across more busses since I'd get better
performance.  But the 3ware should hopefully hide single disk hot-swap
issues better.  It's a tradeoff and time for testing.

Anyway, try to put each 3ware onto it's own PCI bus if you can.  

So, ontop of that huge RAID6 volume, I'd stick LVM and then carve out
the PVs -> LVs and make the filesystem I want onto the LVs.  

andy> The question is, are these essentially equivalent alternatives?
andy> Is there any theoretical reason why one choice would be better
andy> than the other -- in terms of security, performance, memory
andy> usage, etc.

If you add in LVM to the mix, I think they are both equivilent, since
you use LVM as an interface layer to hide the details of the lower
layers from the filesystem.  With LVM you can add/move/delete PVs
(Physical Volumes) from a system and move data around with the system
live.  

This would allow you to do a quick shutdown to add new hardware/disks
and then bring up the system.  With the system live and serving data,
you can then build new PVs, add them into LVM and then move data from
old controllers/disks to new disks, all while serving data and keeping
up redundancy.  It's really cool.  

You do take some performance hit while doing this, since you are
copying lots and lots of data around, but it's not bad at all.

Look for a stable filesystem which allows you to resize it while
mounted.  I think XFS lets you do this, but double check.  

John
