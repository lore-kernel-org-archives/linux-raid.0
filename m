From: Phil Turmel <philip@turmel.org>
Subject: Re: Can this array be recovered?
Date: Tue, 25 Dec 2012 01:05:35 -0500
Message-ID: <50D9422F.9010403@turmel.org>
References: <kbb975$nj1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <kbb975$nj1$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jaap Winius <jwinius@umrk.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/24/2012 11:14 PM, Jaap Winius wrote:
> Hi folks,
> 
> While attempting to grow a RAID1 array after replacing the disks, it 
> looks like I've messed things up a bit. I started with this:
> 
> ~# mdadm --detail /dev/md1
> /dev/md1:
>         Version : 0.90
>   Creation Time : Sat Jun 19 23:34:39 2010
>      Raid Level : raid1
>      Array Size : 767130560 (731.59 GiB 785.54 GB)
>   Used Dev Size : 767130560 (731.59 GiB 785.54 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 1
>     Persistence : Superblock is persistent
> 
>     Update Time : Mon Dec 24 21:02:13 2012
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
> 
>            UUID : 9be57e97:2c46675a:b5a3dfee:de98bb27
>          Events : 0.2246
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       66        0      active sync   /dev/sde2
>        1       8       82        1      active sync   /dev/sdf2
> 
> Growing the array at this point wasn't working, because for some reason 
> the size of one of the two partitions (/dev/sdf2) used for the array was 
> still being reported with its previous smaller size (767130560) in /sys/
> devices/virtual/block/md1/md/dev-sde2/size.
> 
> So, I stopped the array to experiment with the "--update=devicesize" 
> option, but then stupidly issued these commands:
> 
> ~# mdadm --assemble /dev/md1 --update=devicesize /dev/sdf2
> mdadm: /dev/md1 assembled from 1 drive - need all 2 to start it (use --
> run to insist).
> ~# mdadm --assemble /dev/md1 --update=devicesize /dev/sdf2 /dev/sde2
> mdadm: cannot open device /dev/sdf2: Device or resource busy
> mdadm: /dev/sdf2 has no superblock - assembly aborted

The array was partially assembled, but not started.  So /dev/md1 and
/dev/sdf2 were busy.  You should have stopped /dev/md1 before the
re-assembly attempt.  Too late, now.

> After this, the array refused to respond to any commands until I stopped 
> it once more. However, it then refused to start up again (assemble). So I 
> saw somewhere that I might be able to recover it with a create command:
> 
> ~# mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sd[ef]2
> mdadm: /dev/sde2 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Sat Jun 19 23:34:39 2010
> mdadm: Note: this array has metadata at the start and
>     may not be suitable as a boot device.  If you plan to
>     store '/boot' on this device please ensure that
>     your boot-loader understands md/v1.x metadata, or use
>     --metadata=0.90
> mdadm: /dev/sdf2 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Sat Jun 19 23:34:39 2010
> mdadm: largest drive (/dev/sde2) exceeds size (767129464K) by more than 1%
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md1 started.

It warned you :-).  You said "y" and destroyed your LVM metadata.
Modern mdadm defaults to metadata v1.2, placed near the beginning of the
device.  The original v0.90 metadata is placed at the end of the device.

> Perhaps this was an even more destructive thing to do. Anyway, the array 
> now looks like this:
> 
> ~# mdadm --detail /dev/md1
> /dev/md1:
>         Version : 1.2
>   Creation Time : Tue Dec 25 02:07:11 2012
>      Raid Level : raid1
>      Array Size : 767129464 (731.59 GiB 785.54 GB)
>   Used Dev Size : 767129464 (731.59 GiB 785.54 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Dec 25 02:07:11 2012
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
> 
>            Name : bitis:1  (local to host bitis)
>            UUID : a8eca0e2:dd9941a3:03d8b0f0:d11c9994
>          Events : 0
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       66        0      active sync   /dev/sde2
>        1       8       82        1      active sync   /dev/sdf2
> 
> It now has a different UUID (that was expected), but it also seems to 
> contain no data. I was hoping to find an LVM physical volume, but pvscan 
> is not detecting anything on the array. Oops. Luckily the data wasn't too 
> important, but the loss is nevertheless irritating.
> 
> Might there still be a way to recover my lost LVM data, or is this 
> situation hopeless?

Stop the array.  Create it again, but specify v0.90 or v1.0 metadata.
(v1.0 also puts the superblock at the end.)

Since v1.2 metadata skips the first 4k, the critical part of the LVM
metadata is probably intact, and it'll "just work".

After you recover your data, you should consider rebuilding your array
with default (v1.2) metadata for everything other than your boot filesystem.

HTH, and Merry Christmas.

Phil
