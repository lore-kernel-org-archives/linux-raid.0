From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: RE: What raid to build on that drives?
Date: Mon, 1 Dec 2003 16:49:58 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <7FD257BF8564D4119DA800508BDF07AA0FB51D47@usahm012.exmi01.exch.eds.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Timo Boettcher' <spida@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>    I have 3 * 36GB discs and 5 * 18GB discs on two u160 scsi channels?
>>    What possibilities do I have to build a raid on them? I want to be
>>    able to survive one failed disc, but get as much space and
>>    performance out of the discs as possible.

> How about two RAID5 arrays, one with the 3*36GB=72GB and the other using
> the 5*18GB=72GB.  Then throw both of these under a RAID0 which will get
> you 144GB and still be able to survive 1 disk failure.

Here's a twisted thought, which would increase your available space, but
probably at the expense of some amount of performance degradation:

1. Partition your 36GB disks so first partition is the same size as one of
your 18GB disks, and the second partition is the remainder of the disk (also
about 18GB).

2. Create a RAID5 array containing 8*18GB disks (5 18GB disks + 3 18GB
partitions) = approx 126GB usable.

3. Create a RAID5 array containing 3*18GB partitions = approx 36 GB usable.

4. At this point, I would *NOT* recommend building a RAID0 array from (2)
and (3), as you will end up generating a lot of contention on the 36GB disks
by doing so. Either use them as separate devices, or concatenate them (using
LVM perhaps) if you really need all of the space in "one place".

This will get you a total of about 162GB usable while still being able to
survive a single disk failure.

I imagine simultaneous rebuilds of both RAID5 devices would not be a
pleasant experience. :-)

Cheers,

	Scott
	scott.bailey@eds.com
