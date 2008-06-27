From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm: spare rebuilding
Date: Fri, 27 Jun 2008 19:54:05 +1000
Message-ID: <18532.47293.808234.949005@notabene.brown>
References: <48615EE7.7000502@blueyonder.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Buckingham on Tuesday June 24
Sender: linux-raid-owner@vger.kernel.org
To: jbuckingham@blueyonder.co.uk
Cc: linux-raid@vger.kernel.org, Jon Buckingham <jon.buckingham@hp.com>
List-Id: linux-raid.ids

On Tuesday June 24, jbuckingham@blueyonder.co.uk wrote:
> Hi,
> 
> I've rebuilt my server from scratch, and have 4 raided partitions.
> 
> All went fine, however one of the partitions (a raid 5) only
> appears to be using 3 out of 4 disks.
> mdadm indicates that the unused disk is "spare rebuilding",
> but after tens of hours and a reboot it's status is unchanged.
> 
> There is no significant activity by the relevant process
> (md3_raid5) - <1% cpu usage, the same as the other similar processes.
> 
> I have tried removing the "spare" disk and re-adding it, but get...
> nas:~ # mdadm /dev/md3 --remove /dev/sdd4
> mdadm: hot remove failed for /dev/sdd4: Device or resource busy
> 
> nas:~ # mdadm /dev/md3 --add /dev/sdd4
> mdadm: Cannot open /dev/sdd4: Device or resource busy
> 
> There are no obvious errors from the boot log.
> 
> Do you have any ideas how to get all 4 disks used, what the
> issue might be etc? Or am I just impatient?!

No, not impatient...

Maybe a bug that has since been fixed.
What happens if you
  echo sync > /sys/block/md3/md/sync_action
??

NeilBrown


> 
> Various logs etc appended.
> 
> Thanks
> 
> Jon B
> 
> ----------------------------------
> opensuse 10.3
> 
> nas:~ # uname -a
> Linux nas 2.6.22.5-31-default #1 SMP 2007/09/21 22:29:00 UTC i686 athlon i386 GNU/Linux
> 
> nas:~ # rpm -qa | grep mdadm
> mdadm-2.6.2-16
> ----------------------------------
> nas:~ # cat /proc/mdstat
> Personalities : [raid1] [raid0] [raid6] [raid5] [raid4]
> md3 : active raid5 sda4[0] sdd4[4] sdc4[2] sdb4[1]
>        576435840 blocks super 1.0 level 5, 128k chunk, algorithm 2 [4/3] [UUU_]
>        bitmap: 2/184 pages [8KB], 512KB chunk
> 
> md1 : active raid1 sda2[0] sdd2[3] sdc2[2] sdb2[1]
>        41945640 blocks super 1.0 [4/4] [UUUU]
>        bitmap: 0/161 pages [0KB], 128KB chunk
> 
> md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
>        10490340 blocks super 1.0 [4/4] [UUUU]
>        bitmap: 1/161 pages [4KB], 32KB chunk
> 
> md2 : active(auto-read-only) raid5 sda3[0] sdd3[4] sdc3[2] sdb3[1]
>        1590144 blocks super 1.0 level 5, 128k chunk, algorithm 2 [4/4] [UUUU]
>        bitmap: 0/9 pages [0KB], 32KB chunk
> 
> unused devices: <none>
> ----------------------------------
> nas:~ # mdadm --detail /dev/md3
> /dev/md3:
>          Version : 01.00.03
>    Creation Time : Mon Jun 23 22:03:45 2008
>       Raid Level : raid5
>       Array Size : 576435840 (549.73 GiB 590.27 GB)
>    Used Dev Size : 384290560 (183.24 GiB 196.76 GB)
>     Raid Devices : 4
>    Total Devices : 4
> Preferred Minor : 3
>      Persistence : Superblock is persistent
> 
>    Intent Bitmap : Internal
> 
>      Update Time : Tue Jun 24 21:37:33 2008
>            State : active, degraded
>   Active Devices : 3
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 1
> 
>           Layout : left-symmetric
>       Chunk Size : 128K
> 
>             Name : 3
>             UUID : 17ae4fee:d1380d07:c3265e31:3c77f88f
>           Events : 1256
> 
>      Number   Major   Minor   RaidDevice State
>         0       8        4        0      active sync   /dev/sda4
>         1       8       20        1      active sync   /dev/sdb4
>         2       8       36        2      active sync   /dev/sdc4
>         4       8       52        3      spare rebuilding   /dev/sdd4
> ----------------------------------
> nas:~ # mdadm -E /dev/sdd4
> /dev/sdd4:
>            Magic : a92b4efc
>          Version : 01
>      Feature Map : 0x3
>       Array UUID : 17ae4fee:d1380d07:c3265e31:3c77f88f
>             Name : 3
>    Creation Time : Mon Jun 23 22:03:45 2008
>       Raid Level : raid5
>     Raid Devices : 4
> 
>    Used Dev Size : 384290720 (183.24 GiB 196.76 GB)
>       Array Size : 1152871680 (549.73 GiB 590.27 GB)
>        Used Size : 384290560 (183.24 GiB 196.76 GB)
>     Super Offset : 384290848 sectors
> Recovery Offset : 48750592 sectors
>            State : clean
>      Device UUID : 086e1682:4ba0454f:673f8a77:b56f3b92
> 
> Internal Bitmap : -93 sectors from superblock
>      Update Time : Tue Jun 24 21:47:17 2008
>         Checksum : 135f5478 - correct
>           Events : 1258
> 
>           Layout : left-symmetric
>       Chunk Size : 128K
> 
>      Array Slot : 4 (0, 1, 2, failed, 3)
>     Array State : uuuU 1 failed
> ----------------------------------
> nas:~ # mdadm -E /dev/sda4
> /dev/sda4:
>            Magic : a92b4efc
>          Version : 01
>      Feature Map : 0x1
>       Array UUID : 17ae4fee:d1380d07:c3265e31:3c77f88f
>             Name : 3
>    Creation Time : Mon Jun 23 22:03:45 2008
>       Raid Level : raid5
>     Raid Devices : 4
> 
>    Used Dev Size : 384290720 (183.24 GiB 196.76 GB)
>       Array Size : 1152871680 (549.73 GiB 590.27 GB)
>        Used Size : 384290560 (183.24 GiB 196.76 GB)
>     Super Offset : 384290848 sectors
>            State : clean
>      Device UUID : 6ed4d11c:2092f54b:8d530f91:c1813c49
> 
> Internal Bitmap : -93 sectors from superblock
>      Update Time : Tue Jun 24 21:47:17 2008
>         Checksum : 7868f2de - correct
>           Events : 1258
> 
>           Layout : left-symmetric
>       Chunk Size : 128K
> 
>      Array Slot : 0 (0, 1, 2, failed, 3)
>     Array State : Uuuu 1 failed
> ----------------------------------
> 
> nas:~ # grep -i -C6 raid /var/log/boot.msg
> <6>ata6.00: ATA-7: WDC WD2500YD-01NVB1, 10.02E01, max UDMA/133
> <6>ata6.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/1)
> <6>ata6.00: configured for UDMA/133
> <5>scsi 4:0:0:0: Direct-Access     ATA      WDC WD2500YD-01N 10.0 PQ: 0 ANSI: 5
> <5>scsi 5:0:0:0: Direct-Access     ATA      WDC WD2500YD-01N 10.0 PQ: 0 ANSI: 5
> <4>ACPI Exception (processor_core-0787): AE_NOT_FOUND, Processor Device is not present [20070126]
> <6>md: raid1 personality registered for level 1
> <6>BIOS EDD facility v0.16 2004-Jun-25, 4 devices found
> <6>usbcore: registered new interface driver usbfs
> <6>usbcore: registered new interface driver hub
> <6>usbcore: registered new device driver usb
> <7>ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> <4>ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 21
> --
> <5>sd 5:0:0:0: [sdd] 490234752 512-byte hardware sectors (251000 MB)
> <5>sd 5:0:0:0: [sdd] Write Protect is off
> <7>sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> <5>sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> <6> sdd: sdd1 sdd2 sdd3 sdd4
> <5>sd 5:0:0:0: [sdd] Attached SCSI disk
> <6>md: raid0 personality registered for level 0
> <6>raid5: automatically using best checksumming function: pIII_sse
> <4>   pIII_sse  :  5641.000 MB/sec
> <4>raid5: using function: pIII_sse (5641.000 MB/sec)
> <4>raid6: int32x1    706 MB/s
> <4>raid6: int32x2    747 MB/s
> <4>raid6: int32x4    671 MB/s
> <4>raid6: int32x8    516 MB/s
> <4>raid6: mmxx1     1504 MB/s
> <4>raid6: mmxx2     2760 MB/s
> <4>raid6: sse1x1     344 MB/s
> <4>raid6: sse1x2     382 MB/s
> <4>raid6: sse2x1     440 MB/s
> <4>raid6: sse2x2     640 MB/s
> <4>raid6: using algorithm sse2x2 (640 MB/s)
> <6>md: raid6 personality registered for level 6
> <6>md: raid5 personality registered for level 5
> <6>md: raid4 personality registered for level 4
> <6>md: md2 stopped.
> <6>md: md0 stopped.
> <6>md: bind<sdb1>
> <6>md: bind<sdc1>
> <6>md: bind<sdd1>
> <6>md: bind<sda1>
> <3>md: md0: raid array is not clean -- starting background reconstruction
> <6>raid1: raid set md0 active with 4 out of 4 mirrors
> <6>md0: bitmap file is out of date (4 < 5) -- forcing full recovery
> <6>md0: bitmap file is out of date, doing full recovery
> <6>md0: bitmap initialized from disk: read 11/11 pages, set 327824 bits, status: 0
> <6>created bitmap (161 pages) for device md0
> <4>swsusp: Basic memory bitmaps created
> <4>swsusp: Basic memory bitmaps freed
> <4>swsusp: Basic memory bitmaps created
> <4>swsusp: Basic memory bitmaps freed
> <4>Attempting manual resume
> <1>Read-error on swap-device (9:2:8)
> <6>md: resync of RAID array md0
> <6>md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> <6>md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
> <6>md: using 128k window, over a total of 10490340 blocks.
> <6>kjournald starting.  Commit interval 5 seconds
> <6>EXT3 FS on md0, internal journal
> <6>EXT3-fs: mounted filesystem with ordered data mode.
> --
> <6>md: md1 stopped.
> <6>device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
> <6>md: bind<sdb2>
> <6>md: bind<sdc2>
> <6>md: bind<sdd2>
> <6>md: bind<sda2>
> <6>raid1: raid set md1 active with 4 out of 4 mirrors
> <6>md1: bitmap initialized from disk: read 11/11 pages, set 2 bits, status: 0
> <6>created bitmap (161 pages) for device md1
> <6>md: md2 stopped.
> <6>md: bind<sdb3>
> <6>md: bind<sdc3>
> <6>md: bind<sdd3>
> <6>md: bind<sda3>
> <6>raid5: device sda3 operational as raid disk 0
> <6>raid5: device sdd3 operational as raid disk 3
> <6>raid5: device sdc3 operational as raid disk 2
> <6>raid5: device sdb3 operational as raid disk 1
> <6>raid5: allocated 4204kB for md2
> <4>raid5: raid level 5 set md2 active with 4 out of 4 devices, algorithm 2
> <4>RAID5 conf printout:
> <4> --- rd:4 wd:4
> <4> disk 0, o:1, dev:sda3
> <4> disk 1, o:1, dev:sdb3
> <4> disk 2, o:1, dev:sdc3
> <4> disk 3, o:1, dev:sdd3
> <6>md2: bitmap initialized from disk: read 1/1 pages, set 0 bits, status: 0
> --
> <6>md: md3 stopped.
> <6>md: bind<sdb4>
> <7>ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d80000916254]
> <6>md: bind<sdc4>
> <6>md: bind<sdd4>
> <6>md: bind<sda4>
> <6>raid5: device sda4 operational as raid disk 0
> <6>raid5: device sdc4 operational as raid disk 2
> <6>raid5: device sdb4 operational as raid disk 1
> <6>raid5: allocated 4204kB for md3
> <1>raid5: raid level 5 set md3 active with 3 out of 4 devices, algorithm 2
> <4>RAID5 conf printout:
> <4> --- rd:4 wd:3
> <4> disk 0, o:1, dev:sda4
> <4> disk 1, o:1, dev:sdb4
> <4> disk 2, o:1, dev:sdc4
> <4> disk 3, o:1, dev:sdd4
> <6>md3: bitmap initialized from disk: read 12/12 pages, set 3 bits, status: 0
> --
> Loading required kernel modules
> doneActivating swap-devices in /etc/fstab...
> failedmount: according to mtab, /dev/md0 is already mounted on /
> 
> Activating device mapper...
> done
> Starting MD Raid mdadm: /dev/md1 has been started with 4 drives.
> mdadm: /dev/md2 has been started with 4 drives.
> mdadm: /dev/md3 has been started with 4 drives.
> Checking file systems...
> fsck 1.40.2 (12-Jul-2007)
> /dev/md1: clean, 74739/5248992 files, 2949291/10486410 blocks
> /sbin/fsck.xfs: XFS file system.
> -------------------------------------
