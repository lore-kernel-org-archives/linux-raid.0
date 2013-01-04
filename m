From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: RAID5 member disks shrunk
Date: Fri, 04 Jan 2013 16:13:02 +0000
Message-ID: <50E6FF8E.5040309@mpstor.com>
References: <op.wqcditj08s54ea@metabuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.wqcditj08s54ea@metabuntu>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Leach <beamesleach@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Answers inline.

On 03/01/13 15:33, Alex Leach wrote:
> Dear list,
>
> I hope you all had a good festive period. Happy New Year!
>
> Sorry to burden you with this, but I'm in real need of some help! I 
> recently suffered from a failed hard disk in my RAID5 array, and have 
> made some rookie errors since.. I'll try and detail what I did as 
> accurately and concisely as possible. Some help in recovering data 
> from my ext4 partition would be greatly appreciated!
>
> Set up:-
>   1. RAID0 was pre-configured on new machine, with 2x300GB WD 
> Velociraptors. (2010)
>   2. Got another, identical drive and upgrade to RAID5 using Windows 
> Intel Matrix Manager. (2011)
>
> RAID Partitions (roughly):
>   1. 100MB windows boot loader.
>   2. 342GB NTFS Windows installation partition
>   3. 256GB ext4 partition with Kubuntu 12.10, and dmraid.
>
> Non-RAID Partitions (for completeness):
>   Backup Drive: 2TB.
>      1. 200GB Ubuntu 12.10 ext4 (recovabuntu) with dmraid.
>      2. 1800GB NTFS backup and media partition.
>   SAS drive: 600GB
>      1. 600GB ext4 partition, for SQL and other databases.
>
>
> Problem, started about two weeks ago:
>   1. Suffer an IO error on member disk, whilst in Kubuntu. Array 
> DEGRADED.
>   2. Goes unnoticed for at most a day. Shut down immediately, replace 
> HD with new, identical disk.
>   3. Boot into Windows, use Matrix Storage manager to rebuild array on 
> to new disk. Array now fine.
>   4. At some point after the array was rebuilt, back in Kubuntu, the 
> new disk also raised an IO error. DEGRADED again.
>
> Stop gap:
>   5. Panic, and boot into recovabuntu on non-raid disk. The 2TB drive 
> is not a drive I want to (over-)use when not strictly necessary, as 
> this has all my media on it and a couple of (old) backups.
>   6. WD have been stalling the RMA on the failed drive(s) over 
> Christmas, and I didn't want to stress out my 2TB drive too much.
>   7. Decide to get an SSD and use that as primary boot device.
>   8. Whilst at it, I also bought and installed a 5 bay Icy Box HD 
> backplane, upgrading from a 3 bay version. This was trickier than I 
> thought; I had to completely disassemble the PC and mod the 5.25" bays 
> in the case, with drill, dremel, rivet gun, and some spray paint for 
> good measure :)
>
> Human error:
>   9. Putting it back together, I accidentally connected one of the 
> good RAID member drives to the SAS controller, and the SAS drive into 
> one of the SATA ports, which has an Intel ICH10R controller.
>   10. Took a couple boots into BIOS and recovabuntu to realise what 
> I'd done wrong. Array now wants to rebuild on to good disk, using data 
> from the drive that IO Error'd on me. Don't like the sound of that, so 
> I leave it degraded.
>
> (Botched) Recovery:
>   11. Install Arch Linux and Windows onto separate partitions on the 
> SSD drive.
>   12. Read that Intel now support mdadm over dmraid, so install that 
> on Arch.
>   13. Backup some information:
>
>     $ sudo mdadm -D /dev/md/RAID5
>
> /dev/md/RAID5:
>       Container : /dev/md/imsm0, member 0
>      Raid Level : raid5
>      Array Size : 586066944 (558.92 GiB 600.13 GB)
>   Used Dev Size : 293033600 (279.46 GiB 300.07 GB)
>    Raid Devices : 3
>   Total Devices : 2
>
>           State : active, degraded
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-asymmetric
>      Chunk Size : 64K
>
>
>            UUID : 789c5fd2:da9dd3d2:b57d7def:89f68d3c
>     Number   Major   Minor   RaidDevice State
>        1       8        0        0      active sync   /dev/sda
>        1       0        0        1      removed
>        0       8       16        2      active sync   /dev/sdb
>
>
>     $ sudo mdadm -D /dev/md/imsm0
>
> /dev/md/imsm0:
>         Version : imsm
>      Raid Level : container
>   Total Devices : 3
>
> Working Devices : 3
>
>
>            UUID : 4528e473:abbe0e9f:25a8bb6b:bb9e9999
>   Member Arrays : /dev/md/RAID5
>
>     Number   Major   Minor   RaidDevice
>
>        0       8        0        -        /dev/sda
>        1       8       96        -        /dev/sdg
>        2       8       16        -        /dev/sdb
>
>
>     $ sfdisk -d /dev/sda > sda.out (and same for sdg and sdb)
>     $ ls -l /dev/sd[agb].out
> -rw-r--r-- 1 albl500 users   259 Dec 18 10:45 sda.out
> -rw-r--r-- 1 albl500 users     0 Dec 18 10:47 sdb.out
> -rw-r--r-- 1 albl500 users     0 Dec 18 10:47 sdg.out
>
>     $ cat sda.out
>
> # partition table of /dev/sda
> unit: sectors
>
> /dev/sda1 : start=     2048, size=   204800, Id= 7, bootable
> /dev/sda2 : start=   206848, size=667994112, Id= 7
> /dev/sda3 : start=668200960, size=503928832, Id= 7
> /dev/sda4 : start=        0, size=        0, Id= 0
>
>   14. Figure I should zero the superblocks and re-create the array. 
> Really should have backed up as much as possible before this...
>     $ sudo mdadm --misc --zero-superblock /dev/sd[agb]
>
>     $ sudo mdadm --create /dev/md/imsm0 --raid-devices=2 
> --uuid='4528e473:abbe0e9f:25a8bb6b:bb9e9999' --metadata=imsm /dev/sda 
> /dev/sdg /dev/sdb
> mdadm: container /dev/md/imsm0 prepared.
>
>     $ sudo mdadm --create --verbose /dev/md/RAID5 --raid-devices=3 
> --level=5 --chunk=64 --layout=la --size=293033600 
> --uuid='789c5fd2b57d7def:89f68d3c' -e imsm /dev/sda /dev/sdg /dev/sdb
> mdadm: /dev/sdb not enough space (586066062 < 586067200)
> mdadm: /dev/sdb is smaller than given size. 0K < 293033600K + metadata
> mdadm: /dev/sdc not enough space (586066062 < 586067200)
> mdadm: /dev/sdc is not suitable for this array.
> mdadm: create aborted

Not sure if this will help but I had something similar recently. After 
updating from mdadm-2.6.9 on kernel 2.6.35 to mdadm-3.2.6 on kernel 
3.6.6 I noticed that reusing the same "create" command with the same 
"size" argument did not work anymore, complaining about devices being 
too small.

The command having worked before, I looked deeper into it and realized 
that between the time the array was initially created on mdadm-2.6.9 and 
when it was re-created on mdadm-3.2.6 some changes to mdadm were made 
that reserved more space for superblocks etc.

While I used to simply allocate an extra 256KB of space for the 
superblock when passing in the "size" argument, I changed this to a lot 
higher for any subsequent array.

Considering that your array was built on one system and that you tried 
to run the "create" command on another, this is what could have happened.

In a more positive light, the fact that it did not do anything probably 
saved you from it overwriting the old array by creating it at a so 
slightly different array.

Not sure what the guideline is here in this case, but I would recommend 
only "recreating" arrays to repair them in last resort, and if necessary 
to do, only by using the same version of mdadm/kernel, just to be sure 
there aren't any changes in the code that will cause your array to be 
recreated not in the same exact way.

>
>
>   15. If I leave off the size option, then the array gets built, and 
> verifies all 3 drives without a single IO error. So the drives seem to 
> be okay now. But when they are assembled, the Array Size and Used Dev 
> Size come out smaller than with the previous array, whose details are 
> above. Now, after re-creating and verifying (with no size option), I 
> get these results:
>
>     $ sudo mdadm -D /dev/md/RAID5
>
> /dev/md/RAID5:
>       Container : /dev/md/imsm0, member 0
>      Raid Level : raid5
>      Array Size : 586065920 (558.92 GiB 600.13 GB)
>   Used Dev Size : 293033024 (279.46 GiB 300.07 GB)
>    Raid Devices : 3
>   Total Devices : 3
>
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-asymmetric
>      Chunk Size : 64K
>
>
>            UUID : 2cdc3f5c:7d91eb7d:51b57c72:bdbfc1fb
>     Number   Major   Minor   RaidDevice State
>        2       8       16        0      active sync   /dev/sda
>        1       8      112        1      active sync   /dev/sdg
>        0       8       32        2      active sync   /dev/sdb
>
>     $ sudo sfdisk -d /dev/md126  # this is: /dev/md/RAID5
>
> # partition table of /dev/md126
> unit: sectors
>
> /dev/md126p1 : start=     2048, size=   204800, Id= 7, bootable
> /dev/md126p2 : start=   206848, size=667994112, Id= 7
> /dev/md126p3 : start=668200960, size=503928832, Id= 7
> /dev/md126p4 : start=        0, size=        0, Id= 0
>
>   16. When I saw these partitions in /dev, I was very happy! I thought 
> I had everything back, but I couldn't mount a single one of the file 
> systems. I used testdisk to try and recover the partitions, and this 
> changed the partition table to point to different start and end 
> positions for p1 and p2, deleting p3. I could mount and recover data 
> from my NTFS windows partition, but the ext4 partition could not be 
> recovered at all; I suspect because of the new Minor numbers and the 
> apparent reduced device and array sizes.
Minors numbers are irrelevant to ext4, a device can be allocated 
different minor numbers and still have its filesystem read (devices do 
not always mount on the same sdX device after all)

My guess is that there is corruption (to an unknown extent) but that 
NTFS is more forgiving about it. Have you made sure that the data you 
recovered on your NTFS partition is still good?

The fact that your ext4 partition "shrunk" (assuming it is the last one) 
should not (to be tested, simply a hunch out of memory) prevent it from 
mounting, at least when trying to force it.

>
>   17. It seems the Used Dev size has reduced by 576kB ( = 512kB + 
> 64kB), which I thought could be partially explained by an MBR being 
> present on the disks, but I have been unable to think where the extra 
> 64kB could be taken up.
>
>   18. So I backup the first 512kB of each member disk, and write zeros 
> to those areas, with dd.
>
>     $ sudo dd if=/dev/sdX of=sdX.out bs=512 count=1
>     $ sudo dd if=/dev/zero of=/dev/sdX bs=512 count=1
>
>   19. Still unable to create an array with the right size (after 
> zeroing superblocks). Updating the super-minor doesn't seem to apply 
> to imsm containers, and I can't think of any other way to get this to 
> re-assemble correctly.
>
> So, I've got myself into a real mess here. I don't have the space to 
> backup every disk image, which I've seen recommended pretty much 
> everywhere.
> Any help getting me out of this mess would be really, really appreciated!
>
> Kind regards,
> Alex
>
Mhhhh, had not seen the part where your array got created in the end. If 
your NTFS partition on the RAID is here, chances are the other should be 
too. Try to look for ext3 file headers by examining the contents of your 
RAID with hexdump at the offset at which your partition is supposed to 
start.

The fact that "create" was ran and that there are no backups of the 
images does not help your case.

HTH.

Regards,
Ben.

