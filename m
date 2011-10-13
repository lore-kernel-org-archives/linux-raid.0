From: Phil Turmel <philip@turmel.org>
Subject: Re: Data recovery from linear array (Intel SS4000-E)
Date: Thu, 13 Oct 2011 17:09:49 -0400
Message-ID: <4E97539D.8040007@turmel.org>
References: <4E972C82.1020605@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E972C82.1020605@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Moos <jmoos@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Johannes,

On 10/13/2011 02:22 PM, Johannes Moos wrote:
> Hi,
> I've got an Intel SS4000-E NAS configured with a linear array consisting of four disks.
> I made backups of the three remaining disks with ddrescue and was going to work with these.

You *do* understand that "linear" has *no* redundancy?  If you can't read anything at all off the bad drive, that fraction of your data is *gone*.

As a linear array, files that are entirely allocated on the other three are likely to be recoverable.

> OK, so here is what I did so far:
> 
> losetup -v /dev/loop0 Disk0_Partition3.ddr
> losetup -v /dev/loop1 Disk1_Partition3.ddr
> losetup -v /dev/loop3 Disk3_Partition3.ddr

All of this is good.

> Then I tried to start the array with mdadm -v -A /dev/md0 /dev/loop{0,1,3}
> 
> mdadm output:
> 
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/loop0 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/loop1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/loop3 is identified as a member of /dev/md0, slot 3.
> mdadm: added /dev/loop1 to /dev/md0 as 1
> mdadm: no uptodate device for slot 2 of /dev/md0
> mdadm: added /dev/loop3 to /dev/md0 as 3
> mdadm: added /dev/loop0 to /dev/md0 as 0
> mdadm: /dev/md0 assembled from 3 drives - not enough to start the array.

Right.  No redundancy.  All members must be present.

> Additional information:
> mdadm -E /dev/loop0 (same for loop1 and loop3):
> 
> /dev/loop0:
>           Magic : a92b4efc
>         Version : 0.90.01
>            UUID : 296ef59c:674f522d:4ae90a34:0cdee8cc
>   Creation Time : Mon Jun 30 12:54:30 2008
>      Raid Level : linear
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 1
> 
>     Update Time : Mon Jun 30 12:54:30 2008
>           State : active
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 351f715e - correct
>          Events : 15
> 
>        Rounding : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     0       8        3        0      active sync   /dev/sda3
> 
>    0     0       8        3        0      active sync   /dev/sda3
>    1     1       8       19        1      active sync
>    2     2       8       35        2      active sync
>    3     3       8       51        3      active sync
> 
> Please help me out here recovering my data :)

About 3/4, but yes.  Good thing it wasn't a stripe set (Raid 0).  You'd have lost much more.

Anyways, to get what you can:

Create a zeroed placeholder file for the missing drive (must be exactly the right size):

dd if=/dev/zero of=Disk2_Partition3.fake bs=512 count=624353185

and loop mount it like the others.  Then re-create the array:

mdadm --zero-superblock /dev/loop{0,1,3}
mdadm --create --metadata=0.90 --level=linear -n 4 /dev/md0 /dev/loop{0,1,2,3}

Then mount and fsck.  Inodes on the missing drive will be gone.  Data from the missing drive will be zeroes, of course.  File data from the good drives that had metadata on the missing one might show up in lost+found.

If you layered LVM between the array and multiple volumes, you might find some of them completely intact.  Please share the output of 'lsdrv'[1] if so, along with your lvm.conf backup, if you want help figuring that part out.

HTH,

Phil

[1] http://github.com/pturmel/lsdrv
