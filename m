From: Nix <nix@esperi.org.uk>
Subject: Re: Multiple raids on one machine?
Date: Tue, 27 Jun 2006 10:56:23 +0100
Message-ID: <871wtahqgo.fsf@hades.wkstn.nix>
References: <449F100D.6030509@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449F100D.6030509@cjx.com> (Chris Allen's message of "25 Jun 2006 23:37:17 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25 Jun 2006, Chris Allen uttered the following:
> Back to my 12 terabyte fileserver, I have decided to split the storage
> into four partitions each of 3TB. This way I can choose between XFS
> and EXT3 later on.
> 
> So now, my options are between the following:
> 
> 1. Single 12TB /dev/md0, partitioned into four 3TB partitions. But how do
> I do this? fdisk won't handle it. Can GNU Parted handle partitions this big?
> 
> 2. Partition the raw disks into four partitions and make /dev/md0,md1,md2,md3.
> But am I heading for problems here? Is there going to be a big performance hit
> with four raid5 arrays on the same machine? Am I likely to have dataloss problems
> if my machine crashes?

There is a third alternative which can be useful if you have a mess of
drives of widely-differing capacities: make several RAID arrays so as to tesselate
space across all the drives, and then pile an LVM on the top of all of them to
fuse them back into one again.

The result should give you the reliability of RAID-5 and the resizeability of
LVM :)

e.g. the config on my home server, which for reasons of disks-bought-at-
different-times has disks varying in size from 10Gb through 40Gb to
72Gb. Discounting the tiny RAID-1 array used for booting off (LILO won't
boot from RAID-5), it looks like this:

Two RAID arrays, positioned so as to fill up as much space as possible
on the various physical disks:

     Raid Level : raid5
     Array Size : 76807296 (73.25 GiB 78.65 GB)
    Device Size : 76807296 (36.62 GiB 39.33 GB)
   Raid Devices : 3
[...]
    Number   Major   Minor   RaidDevice State
       0       8        6        0      active sync   /dev/sda6
       1       8       22        1      active sync   /dev/sdb6
       3      22        5        2      active sync   /dev/hdc5

     Array Size : 19631104 (18.72 GiB 20.10 GB)
    Device Size : 19631104 (9.36 GiB 10.05 GB)
   Raid Devices : 3

     Raid Level : raid5
    Number   Major   Minor   RaidDevice State
       0       8       23        0      active sync   /dev/sdb7
       1       8        7        1      active sync   /dev/sda7
       3       3        5        2      active sync   /dev/hda5

(Note that the arrays share some disks, the largest ones: each lays
claim to almost the whole of one of the smaller disks.)

Then atop that we have two LVM volume groups, one filling up any
remaining non-RAIDed space and used for non-critical stuff which can be
regenerated on demand (if a disk dies the whole VG will vanish; if we
wanted to avoid that we could make that space into a RAID-1 array, but I
have a lot of easily-regeneratable data and so didn't bother with that),
and one filling *both* RAID arrays:

  VG    #PV #LV #SN Attr   VSize  VFree  Devices
  disks   3   7   0 wz--n- 43.95G 21.80G /dev/sda8(0)
  disks   3   7   0 wz--n- 43.95G 21.80G /dev/sdb8(0)
  disks   3   7   0 wz--n- 43.95G 21.80G /dev/hdc6(0)
  raid    2   9   0 wz--n- 91.96G 49.77G /dev/md1(0)
  raid    2   9   0 wz--n- 91.96G 49.77G /dev/md2(0)

The result can survive any single disk failure, just like a single
RAID-5 array: the worst case is that one of the /dev/c's dies and both
arrays go degraded at once, but nothing else bad would happen to the
RAIDed storage.

Try doing *that* with hardware RAID. :)))

-- 
`NB: Anyone suggesting that we should say "Tibibytes" instead of
 Terabytes there will be hunted down and brutally slain.
 That is all.' --- Matthew Wilcox
