From: Jose Luis Domingo Lopez <linux-raid@24x7linux.com>
Subject: Re: Stupid Question?
Date: Mon, 24 May 2004 01:23:59 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040523232359.GA16899@localhost>
References: <134.2f7071f3.2de27730@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <134.2f7071f3.2de27730@aol.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday, 23 May 2004, at 17:52:48 -0400,
AndyLiebman@aol.com wrote:

> I feel like this is a stupid question. But I actually don't know the answer 
> to it. If I'm going to make a Software RAID array with a bunch of identical 
> disks, do the disks have to have at least one partition on them? Or can I use 
> disks with NO partitions? 
> 
You can use any block device as part of a Linux software RAID device, so
full disks with no partitions inside should be OK. I seem to remember
that this is not the case with LVM, wher you have (should?) to create a
partition even if you want to use the full disk, but is late and maybe I
and mixing things.

> Similarly, if I have made a hardware RAID array (say, with a 3ware 8506 
> card), do I have to create at least a single partition on it before I put a file 
> system on it? 
> 
I don't think so. You can "format" any block device, like a disk
partition, a logical volume, and even a file on disk through the loop
device, so the requirement for a partition table doesn't seem to exist.
I think the only thing needed is a couple of (major,minor) trhough which
to access the underlying block device.

> If partitions aren't necessary, is there any advantage or disadvantage to 
> having a single partition on a disk versus having none? Is having no partitions 
> faster? 
> 
A disk with no partition table is a contiguous block device from sector
zero to the end of the device. Maybe you should follow LVM's advice
about using full disks with no partition table. From pvcreate(8):

DESCRIPTION
       pvcreate initializes PhysicalVolume for later use by the Logical Volume
       Manager (LVM).  Each PhysicalVolume can  be  a  disk  partition,  whole
       disk, meta device, or loopback file.  For DOS disk partitions, the par-
       tition id should be set to 0x8e using fdisk(8), cfdisk(8), or a equiva-
       lent.   For whole disk devices only the partition table must be erased,
       which will effectively destroy all data on that disk.  This can be done
       by zeroing the first sector with:

       dd if=/dev/zero of=PhysicalVolume bs=512 count=1


Greetings.

-- 
Jose Luis Domingo Lopez
Linux Registered User #189436     Debian Linux Sid (Linux 2.6.6)
