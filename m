From: Phil Turmel <philip@turmel.org>
Subject: Re: Failed during rebuild (raid5)
Date: Mon, 06 May 2013 21:46:03 -0400
Message-ID: <51885CDB.8040508@turmel.org>
References: <51839E4F.7050102@midgaard.us> <CANU9nTneT2CRWJhdN=d87Hb7W9M+apQH+fRE-S+sieZ-W6+hjg@mail.gmail.com> <51866602.8000704@midgaard.us> <518693EF.6090802@midgaard.us> <518721CD.2040108@turmel.org> <51878BD0.9010809@midgaard.us> <5187A3D2.6060109@turmel.org> <5188189D.1060806@midgaard.us> <51884D49.3090602@turmel.org> <5188556A.7050605@midgaard.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5188556A.7050605@midgaard.us>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Boman <aboman@midgaard.us>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/06/2013 09:14 PM, Andreas Boman wrote:
> fdisk -lu /dev/sd[bcdefg]
> 
> Disk /dev/sdb: 1500.3 GB, 1500301910016 bytes
> 255 heads, 63 sectors/track, 182401 cylinders, total 2930277168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x3d1e17f0
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1              63  2930272064  1465136001   fd  Linux raid
> autodetect

Oooo!  That's not good.  Your partitions are not on 4k boundaries, so
they won't be compatible with modern large drives.  Modern fdisk puts
the first partition at sector 2048 by default.  (Highly recommended.)
You're stuck with this on the old drives until you can rebuild the
entire array.

[trim /]

> Disk /dev/sdf: 3000.6 GB, 3000592982016 bytes
> 255 heads, 63 sectors/track, 364801 cylinders, total 5860533168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x3d1e17f0
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdf1              63  2930272064  1465136001   fd  Linux raid
> autodetect
> Partition 1 does not start on physical sector boundary.

This is serious.  The drives will run, but every block written to them
will create at least two read-modify-write cycles on 4k sectors.  In
addition to crushing your array's performance, it will prevent scrub
actions from fixing UREs (the read part of the R-M-W will fail).

Fortunately, these new drives are bigger than the originals, so you can
put the partition at sector 2048 and still have it the same size as the
originals.  Warning:  v0.90 has problems with partitions greater than
2GB in some kernel versions.  When you are ready to fix your overall
partition alignment issues, you probably want to switch to v1.1 or v1.2
metadata as well.

[trim /]

>> I would encourage you to take your backups of critical files as soon as
>> the array is running, before you add a fifth disk.  Then you can add two
>> disks and recover/reshape simultaneously.
> 
> Hmm.. any hints as to how to do that at the same time? That does sound
> better.

I believe you would set "sync_max" to "0" before adding the spares, then
issue the "--grow" command to reshape, then set "sync_max" to "max".
Others may want to chime in here.

Phil
