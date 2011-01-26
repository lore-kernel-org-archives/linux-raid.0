From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Subject: Re: VFS: Cannot open root device "md1" or unknown-block(2,0)
Date: Wed, 26 Jan 2011 15:42:41 +0100
Message-ID: <4D4032E1.8050607@fold.natur.cuni.cz>
References: <4D3EE564.6000406@fold.natur.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D3EE564.6000406@fold.natur.cuni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
  it turned put for some reason I had the partitoin type set to Linux
instead of Linux raid autodetect (0xfd). That was the reason why md-raid
did not bother to look over the disks at all.
  On the other hand I suspect kernel should be updated to say that not only 0.90
format is supported but nowadays also 1.0 format.
  Finally, linux-2.6.37/Documentation/md.txt is a bit outdated as well
as the mdadm manpage. Users placing a root filesystem on a raid should be
instructed to use "root=UUID=07da7a4f:66ca6146:cb201669:f728008a" syntax whenever
possible because that is the only way to ensure you mount as root filesystem
the proper raid device next time again (it is not certain a raid will be
mounted under same name as it used to be on the next time). This is even
more pronounced becuase once you temporarily assemble and mount an array
from for example a live CD the super-minor numbers on each component device
will be updated. It can easily happen that your /dev/md0 becomes /dev/md125
because you mounted it once from a liveCD and the only way to fix that is to:

mdadm --stop /dev/md125
vi /etc/mdadm.conf # add /dev/md0 with proper list of component devices)
mdadm --assemble /dev/md0 --update=major-minor # this will overwrite the
                        # preferred minor number on each component device

From the above you can see that you need a live CD to boot of if you want to
mangle your raid with the root system placed on it. Of course you have to
modify the /etc/mdadm.conf on the liveCD-based temp filesystem before
assembling+updating temporarily the array.

There is mdadm --super-minor=# switch but I did not figure out how to
apply it over a running array without the need to stop it a re-assemble
back.

Maybe that helps to somebody once,
Martin


Martin Mokrejs wrote:
> Hi,
>   I have freshly installed a Gentoo Linux on a new server machine with
> ICH10 (/dev/sd[ab]) and LSI HBA (/dev/sd[cdefghij]) controllers.
> All drives are 2TB SATA.
> I installed grub to boot the kernel and the root filesystem is on raid1
> spread over /dev/sd[ac]2. Somehow, linux kernel does not assemble the
> raid device for me. I do see complaints about raid5 array which I made
> intentionally using 1.2 format but I do not see any complaints regarding
> the /dev/sd[ab] disks which contain the / and /boot filesystems. Could
> the kernel be more verbose on arrays which were assembled?
> 
> [    0.000000] Linux version 2.6.37 (root@livecd) (gcc version 4.5.2 (Gentoo 4.5.2 p1.0, pie-0.4.5) ) #1 SMP Sat Jan 22 01:01:25 MET 2011
> [    0.000000] Command line: root=/dev/md1 console=ttyS0,115200n8 console=tty0 udev
> 
> [    3.601080] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    3.608883] ata1.00: ATA-8: Hitachi HDS722020ALA330, JKAOA3MA, max UDMA/133
> [    3.616100] ata1.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
> [    3.624950] ata1.00: configured for UDMA/133
> [    3.629582] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72202 JKAO PQ: 0 ANSI: 5
> [    3.638273] sd 0:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
> [    3.646490] sd 0:0:0:0: [sda] Write Protect is off
> [    3.646518] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    3.657099] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.669532]  sda: sda1 sda2
> [    3.672812] sd 0:0:0:0: [sda] Attached SCSI disk
> 
> [   13.036888] md: linear personality registered for level -1
> [   13.036889] md: raid0 personality registered for level 0
> [   13.036890] md: raid1 personality registered for level 1
> [   13.036891] md: raid10 personality registered for level 10
> [   13.036892] md: raid6 personality registered for level 6
> [   13.036893] md: raid5 personality registered for level 5
> [   13.036894] md: raid4 personality registered for level 4
> [   13.036983] device-mapper: uevent: version 1.0.3
> [   13.037059] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
> 
> [   14.551313] md: Waiting for all devices to be available before autodetect
> [   14.558351] md: If you don't use raid, use raid=noautodetect
> [   14.564428] md: Autodetecting RAID arrays.
> [   14.586086] md: invalid raid superblock magic on sdd1
> [   14.591395] md: sdd1 does not have a valid v0.90 superblock, not importing!
> [   14.616667] md: invalid raid superblock magic on sdf1
> [   14.621985] md: sdf1 does not have a valid v0.90 superblock, not importing!
> [   14.641946] md: invalid raid superblock magic on sdg1
> [   14.647253] md: sdg1 does not have a valid v0.90 superblock, not importing!
> [   14.669732] md: invalid raid superblock magic on sdh1
> [   14.669733] md: sdh1 does not have a valid v0.90 superblock, not importing!
> [   14.687563] md: invalid raid superblock magic on sdi1
> [   14.687564] md: sdi1 does not have a valid v0.90 superblock, not importing!
> [   14.703926] md: invalid raid superblock magic on sdj1
> [   14.709233] md: sdj1 does not have a valid v0.90 superblock, not importing!
> [   14.735670] md: invalid raid superblock magic on sde1
> [   14.753500] md: sde1 does not have a valid v0.90 superblock, not importing!
> [   14.760707] md: Scanned 7 and added 0 devices.
> [   14.765391] md: autorun ...
> [   14.768429] md: ... autorun DONE.
> [   14.772014] Root-NFS: no NFS server address
> [   14.776433] VFS: Unable to mount root fs via NFS, trying floppy.
> [   14.782759] VFS: Cannot open root device "md1" or unknown-block(2,0)
> [   14.789359] Please append a correct "root=" boot option; here are the available partitions:
> [   14.798159] 0800      1953514584 sda  driver: sd
> [   14.803076]   0801        31463271 sda1 00000000-0000-0000-0000-000000000000
> [   14.810430]   0802      1922048730 sda2 00000000-0000-0000-0000-000000000000
> [   14.817781] 0810      1953514584 sdb  driver: sd
> [   14.822710]   0811       805314321 sdb1 00000000-0000-0000-0000-000000000000
> [   14.830054]   0812      1148197680 sdb2 00000000-0000-0000-0000-000000000000
> [   14.837400] 0b00         1048575 sr0  driver: sr
> [   14.842319] 0820      1953514584 sdc  driver: sd
> [   14.847248]   0821        31463271 sdc1 00000000-0000-0000-0000-000000000000
> [   14.854599]   0822      1922048730 sdc2 00000000-0000-0000-0000-000000000000
> [   14.861944] 0830      1953514584 sdd  driver: sd
> [   14.866867]   0831      1953512001 sdd1 00000000-0000-0000-0000-000000000000
> [   14.874220] 0850      1953514584 sdf  driver: sd
> [   14.879139]   0851      1953512001 sdf1 00000000-0000-0000-0000-000000000000
> [   14.886483] 0860      1953514584 sdg  driver: sd
> [   14.891410]   0861      1953512001 sdg1 00000000-0000-0000-0000-000000000000
> [   14.898763] 0870      1953514584 sdh  driver: sd
> [   14.903685]   0871      1953512001 sdh1 00000000-0000-0000-0000-000000000000
> [   14.911035] 0880      1953514584 sdi  driver: sd
> [   14.915958]   0881      1953512001 sdi1 00000000-0000-0000-0000-000000000000
> [   14.923311] 0890      1953514584 sdj  driver: sd
> [   14.928231]   0891      1953512001 sdj1 00000000-0000-0000-0000-000000000000
> [   14.935581] 0840      1953514584 sde  driver: sd
> [   14.940502]   0841      1953512001 sde1 00000000-0000-0000-0000-000000000000
> [   14.947854] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(2,0)
> [   14.956552] Pid: 1, comm: swapper Not tainted 2.6.37 #1
> [   14.962016] Call Trace:
> [   14.964704]  [<ffffffff81472841>] panic+0x8c/0x18d
> [   14.969734]  [<ffffffff8147297e>] ? printk+0x3c/0x3e
> [   14.974941]  [<ffffffff8171809f>] mount_block_root+0x1cc/0x1ea
> [   14.981012]  [<ffffffff81718274>] mount_root+0xa8/0xaf
> [   14.986389]  [<ffffffff81718d7c>] ? initrd_load+0x2b3/0x2ba
> [   14.992200]  [<ffffffff817183eb>] prepare_namespace+0x170/0x1a9
> [   14.998360]  [<ffffffff81717d73>] kernel_init+0x1ad/0x1bd
> [   15.003999]  [<ffffffff81002e54>] kernel_thread_helper+0x4/0x10
> [   15.010157]  [<ffffffff81717bc6>] ? kernel_init+0x0/0x1bd
> [   15.015795]  [<ffffffff81002e50>] ? kernel_thread_helper+0x0/0x10
> 
> 
> I wonder what is the problem that the array is not recognized automatically.
> I had teh array as 1.0 superblock format but have now even re-created the array
> with 0.90 format, still no luck. Finally, I tried also to set which devices
> should be used to assemble the raid1 array on a kernel command-line but again
> with no luck. Please find attached two system boot logs for some clue.
> The first was gathered when the rai1 arrays were 1.0 format and the latter
> attached file is when I created the 0.90 formats.
> 
> The only thing coming to my mind is that I did not install the mdadm package
> into the server (used the one from an installation CDROM) and although this is
> needed not by the kernel to mount the root filesystem ... who knows, I have
> installed the missing package and added that to boot runlevel. However, before
> I reboot the machine remotely again I wanted to ask for some advice.
> 
> # mdadm -D /dev/md0
> /dev/md0:
>         Version : 0.90
>   Creation Time : Tue Jan 25 14:52:46 2011
>      Raid Level : raid1
>      Array Size : 31463168 (30.01 GiB 32.22 GB)
>   Used Dev Size : 31463168 (30.01 GiB 32.22 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 127
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Jan 25 16:17:45 2011
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
> 
>            UUID : 89510a08:86a1c6a6:cb201669:f728008a (local to host livecd)
>          Events : 0.20
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       8       33        1      active sync   /dev/sdc1
> # mdadm -D /dev/md1
> /dev/md1:
>         Version : 0.90
>   Creation Time : Tue Jan 25 14:53:03 2011
>      Raid Level : raid1
>      Array Size : 1922048640 (1833.01 GiB 1968.18 GB)
>   Used Dev Size : 1922048640 (1833.01 GiB 1968.18 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 125
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Jan 25 16:52:58 2011
>           State : active, resyncing
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
> 
>  Rebuild Status : 15% complete
> 
>            UUID : 07da7a4f:66ca6146:cb201669:f728008a (local to host livecd)
>          Events : 0.6
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/sda2
>        1       8       34        1      active sync   /dev/sdc2
> #
> 
> 
> Thank you for any clues,
> Martin

