From: "brandon" <maillists@hosttuls.com>
Subject: Disks keep disapearing
Date: Fri, 9 May 2003 11:53:01 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <002f01c3165c$3a4e2cf0$21dd7e42@admin>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

3 servers I work with are having issues I am so far unable to track
down.  All 3 are setup like this:

RedHat 7.3
2x Zeon w/HyperThreading disabled
2x WD 120GB drives RAID1, ext3
2GB RAM
Kernel 2.4.18-27.7.xsmp

fdisk -l:

Disk /dev/hdd: 255 heads, 63 sectors, 14589 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdd1   *         1         6     48163+  fd  Linux raid autodetect
/dev/hdd2             7       643   5116702+  fd  Linux raid autodetect
/dev/hdd3           644      1280   5116702+  fd  Linux raid autodetect
/dev/hdd4          1281     14589 106904542+   f  Win95 Ext'd (LBA)
/dev/hdd5          1281     14458 105852253+  fd  Linux raid autodetect
/dev/hdd6         14459     14589   1052226   82  Linux swap

Disk /dev/hda: 255 heads, 63 sectors, 14589 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *         1         6     48163+  fd  Linux raid autodetect
/dev/hda2             7       643   5116702+  fd  Linux raid autodetect
/dev/hda3           644      1280   5116702+  fd  Linux raid autodetect
/dev/hda4          1281     14589 106904542+   f  Win95 Ext'd (LBA)
/dev/hda5          1281     14458 105852253+  fd  Linux raid autodetect
/dev/hda6         14459     14589   1052226   82  Linux swap

Filesystem            Size  Used Avail Use% Mounted on
/dev/md1              4.8G  1.1G  3.4G  24% /
/dev/md0               45M   19M   24M  43% /boot
/dev/md3               99G   25G   70G  26% /home
none                 1008M     0 1008M   0% /dev/shm
/dev/md2              4.8G  795M  3.7G  18% /var

=-=-=-=-



All 3 of the servers run fine for about a week, then they crash.  When
they come back up, one of the drives is missing from the array.  Nothing
in the messsages log that I can find is helpful.  Using sar, I can see
that the load average isnt too high before they crash.

When the first server crashed, I thought perhaps the "Win95 Ext'd (LBA)"
partition type might have been causing some problems.  I replaced the
failed drive, just in case it was hardware, partitioned the drive to be
the same, except made the extended part. "5  Extended".  Rebuilt the
array, but still had these crashes.

Any suggestions on how I should go about troubleshooting this? Anyone
know what might be causing this?




=-=-=-=-
Here is a snip of the dmesg output from the last on that crashed:


Real Time Clock Driver v1.10e
oprofile: can't get RTC I/O Ports
block: 1024 slots per queue, batch=256
Uniform Multi-Platform E-IDE driver Revision: 6.31
ide: Assuming 33MHz system bus speed for PIO modes; override with
idebus=xx
PIIX4: IDE controller on PCI bus 00 dev f9
PCI: Enabling device 00:1f.1 (0005 -> 0007)
PIIX4: chipset revision 2
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:DMA
hda: WDC WD1200BB-00DAA1, ATA DISK drive
hdc: SR244W, ATAPI CD/DVD-ROM drive
hdd: WDC WD1200BB-00DAA1, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
blk: queue c0415f44, I/O limit 4095Mb (mask 0xffffffff)
blk: queue c0415f44, I/O limit 4095Mb (mask 0xffffffff)
hda: 234375000 sectors (120000 MB) w/2048KiB Cache, CHS=14589/255/63,
UDMA(100)
blk: queue c04163e8, I/O limit 4095Mb (mask 0xffffffff)
blk: queue c04163e8, I/O limit 4095Mb (mask 0xffffffff)
hdd: 234375000 sectors (120000 MB) w/2048KiB Cache, CHS=14589/255/63,
UDMA(100) ide-floppy driver 0.99.newide Partition check:
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 >
 hdd: hdd1 hdd2 hdd3 hdd4 < hdd5 hdd6 >
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
NET4: Frame Diverter 0.46
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
ide-floppy driver 0.99.newide
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
 [events: 00000014]
 [events: 00000014]
 [events: 00000014]
 [events: 00000014]
 [events: 0000000e]
 [events: 0000000e]
 [events: 0000000e]
 [events: 0000000e]
md: autorun ...
md: considering hdd5 ...
md:  adding hdd5 ...
md:  adding hda5 ...
md: created md3
md: bind<hda5,1>
md: bind<hdd5,2>
md: running: <hdd5><hda5>
md: hdd5's event counter: 0000000e
md: hda5's event counter: 00000014
md: superblock update time inconsistency -- using the most recent one
md: freshest: hda5
md: kicking non-fresh hdd5 from array!
md: unbind<hdd5,1>
md: export_rdev(hdd5)
md: md3: raid array is not clean -- starting background reconstruction
md: RAID level 1 does not need chunksize! Continuing anyway.
kmod: failed to exec /sbin/modprobe -s -k md-personality-3, errno = 2
md: personality 3 is not loaded!
md :do_md_run() returned -22
md: md3 stopped.
md: unbind<hda5,0>
md: export_rdev(hda5)
md: considering hdd3 ...
md:  adding hdd3 ...
md:  adding hda3 ...
md: created md1
md: bind<hda3,1>
md: bind<hdd3,2>
md: running: <hdd3><hda3>
md: hdd3's event counter: 0000000e
md: hda3's event counter: 00000014
md: superblock update time inconsistency -- using the most recent one
md: freshest: hda3
md: kicking non-fresh hdd3 from array!
md: unbind<hdd3,1>
md: export_rdev(hdd3)
md: md1: raid array is not clean -- starting background reconstruction
md: RAID level 1 does not need chunksize! Continuing anyway.
kmod: failed to exec /sbin/modprobe -s -k md-personality-3, errno = 2
md: personality 3 is not loaded!
md :do_md_run() returned -22
md: md1 stopped.
md: unbind<hda3,0>
md: export_rdev(hda3)
md: considering hdd2 ...
md:  adding hdd2 ...
md:  adding hda2 ...
md: created md2
md: bind<hda2,1>
md: bind<hdd2,2>
md: running: <hdd2><hda2>
md: hdd2's event counter: 0000000e
md: hda2's event counter: 00000014
md: superblock update time inconsistency -- using the most recent one
md: freshest: hda2
md: kicking non-fresh hdd2 from array!
md: unbind<hdd2,1>
md: export_rdev(hdd2)
md: md2: raid array is not clean -- starting background reconstruction
md: RAID level 1 does not need chunksize! Continuing anyway.
kmod: failed to exec /sbin/modprobe -s -k md-personality-3, errno = 2
md: personality 3 is not loaded!
md :do_md_run() returned -22
md: md2 stopped.
md: unbind<hda2,0>
md: export_rdev(hda2)
md: considering hdd1 ...
md:  adding hdd1 ...
md:  adding hda1 ...
md: created md0
md: bind<hda1,1>
md: bind<hdd1,2>
md: running: <hdd1><hda1>
md: hdd1's event counter: 0000000e
md: hda1's event counter: 00000014
md: superblock update time inconsistency -- using the most recent one
md: freshest: hda1
md: kicking non-fresh hdd1 from array!
md: unbind<hdd1,1>
md: export_rdev(hdd1)
md: md0: raid array is not clean -- starting background reconstruction
md: RAID level 1 does not need chunksize! Continuing anyway.
kmod: failed to exec /sbin/modprobe -s -k md-personality-3, errno = 2
md: personality 3 is not loaded!
md :do_md_run() returned -22
md: md0 stopped.
md: unbind<hda1,0>
md: export_rdev(hda1)
md: ... autorun DONE.
pci_hotplug: PCI Hot Plug PCI Core version: 0.4
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 16384 buckets, 128Kbytes
TCP: Hash tables configured (established 262144 bind 65536) Linux IP
multicast router 0.06 plus PIM-SM
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
RAMDISK: Compressed image found at block 0
Freeing initrd memory: 133k freed
VFS: Mounted root (ext2 filesystem).
md: raid1 personality registered as nr 3
Journalled Block Device driver loaded
md: Autodetecting RAID arrays.
 [events: 0000000e]
 [events: 00000014]
 [events: 0000000e]
 [events: 00000014]
 [events: 0000000e]
 [events: 00000014]
 [events: 0000000e]
 [events: 00000014]
md: autorun ...
md: considering hda1 ...
md:  adding hda1 ...
md:  adding hdd1 ...
md: created md0
md: bind<hdd1,1>
md: bind<hda1,2>
md: running: <hda1><hdd1>
md: hda1's event counter: 00000014
md: hdd1's event counter: 0000000e
md: superblock update time inconsistency -- using the most recent one
md: freshest: hda1
md: kicking non-fresh hdd1 from array!
md: unbind<hdd1,1>
md: export_rdev(hdd1)
md: md0: raid array is not clean -- starting background reconstruction
md: RAID level 1 does not need chunksize! Continuing anyway.
md0: max total readahead window set to 508k
md0: 1 data-disks, max readahead per data-disk: 508k
raid1: device hda1 operational as mirror 0
raid1: md0, not all disks are operational -- trying to recover array
raid1: raid set md0 active with 1 out of 2 mirrors
md: updating md0 RAID superblock on device
md: hda1 [events: 00000015]<6>(write) hda1's sb offset: 48064
md: recovery thread got woken up ...
md0: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: considering hda2 ...
md:  adding hda2 ...
md:  adding hdd2 ...
md: created md2
md: bind<hdd2,1>
md: bind<hda2,2>
md: running: <hda2><hdd2>
md: hda2's event counter: 00000014
md: hdd2's event counter: 0000000e
md: superblock update time inconsistency -- using the most recent one
md: freshest: hda2
md: kicking non-fresh hdd2 from array!
md: unbind<hdd2,1>
md: export_rdev(hdd2)
md: md2: raid array is not clean -- starting background reconstruction
md: RAID level 1 does not need chunksize! Continuing anyway.
md2: max total readahead window set to 508k
md2: 1 data-disks, max readahead per data-disk: 508k
raid1: device hda2 operational as mirror 0
raid1: md2, not all disks are operational -- trying to recover array
raid1: raid set md2 active with 1 out of 2 mirrors
md: updating md2 RAID superblock on device
md: hda2 [events: 00000015]<6>(write) hda2's sb offset: 5116608
md: recovery thread got woken up ...
md2: no spare disk to reconstruct array! -- continuing in degraded mode
md0: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: considering hda3 ...
md:  adding hda3 ...
md:  adding hdd3 ...
md: created md1
md: bind<hdd3,1>
md: bind<hda3,2>
md: running: <hda3><hdd3>
md: hda3's event counter: 00000014
md: hdd3's event counter: 0000000e
md: superblock update time inconsistency -- using the most recent one
md: freshest: hda3
md: kicking non-fresh hdd3 from array!
md: unbind<hdd3,1>
md: export_rdev(hdd3)
md: md1: raid array is not clean -- starting background reconstruction
md: RAID level 1 does not need chunksize! Continuing anyway.
md1: max total readahead window set to 508k
md1: 1 data-disks, max readahead per data-disk: 508k
raid1: device hda3 operational as mirror 0
raid1: md1, not all disks are operational -- trying to recover array
raid1: raid set md1 active with 1 out of 2 mirrors
md: updating md1 RAID superblock on device
md: hda3 [events: 00000015]<6>(write) hda3's sb offset: 5116608
md: recovery thread got woken up ...
md1: no spare disk to reconstruct array! -- continuing in degraded mode
md2: no spare disk to reconstruct array! -- continuing in degraded mode
md0: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: considering hda5 ...
md:  adding hda5 ...
md:  adding hdd5 ...
md: created md3
md: bind<hdd5,1>
md: bind<hda5,2>
md: running: <hda5><hdd5>
md: hda5's event counter: 00000014
md: hdd5's event counter: 0000000e
md: superblock update time inconsistency -- using the most recent one
md: freshest: hda5
md: kicking non-fresh hdd5 from array!
md: unbind<hdd5,1>
md: export_rdev(hdd5)
md: md3: raid array is not clean -- starting background reconstruction
md: RAID level 1 does not need chunksize! Continuing anyway.
md3: max total readahead window set to 508k
md3: 1 data-disks, max readahead per data-disk: 508k
raid1: device hda5 operational as mirror 0
raid1: md3, not all disks are operational -- trying to recover array
raid1: raid set md3 active with 1 out of 2 mirrors
md: updating md3 RAID superblock on device
md: hda5 [events: 00000015]<6>(write) hda5's sb offset: 105852160
md: recovery thread got woken up ...
md3: no spare disk to reconstruct array! -- continuing in degraded mode
md1: no spare disk to reconstruct array! -- continuing in degraded mode
md2: no spare disk to reconstruct array! -- continuing in degraded mode
md0: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: ... autorun DONE.
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery. kjournald
starting.  Commit interval 5 seconds
EXT3-fs: md(9,1): orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 96928
ext3_orphan_cleanup: deleting unreferenced inode 257967
ext3_orphan_cleanup: deleting unreferenced inode 257958
ext3_orphan_cleanup: deleting unreferenced inode 96927
ext3_orphan_cleanup: deleting unreferenced inode 592773
ext3_orphan_cleanup: deleting unreferenced inode 257653
ext3_orphan_cleanup: deleting unreferenced inode 368804
ext3_orphan_cleanup: deleting unreferenced inode 193627
EXT3-fs: md(9,1): 8 orphan inodes deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
Freeing unused kernel memory: 188k freed
Adding Swap: 1052216k swap-space (priority -1)
Adding Swap: 1052216k swap-space (priority -2)
usb.c: registered new driver usbdevfs
usb.c: registered new driver hub
usb-uhci.c: $Revision: 1.275 $ time 06:15:20 Mar 14 2003
usb-uhci.c: High bandwidth mode enabled
PCI: Setting latency timer of device 00:1d.0 to 64
usb-uhci.c: USB UHCI at I/O 0xe800, IRQ 16
usb-uhci.c: Detected 2 ports
usb.c: new USB bus registered, assigned bus number 1
hub.c: USB hub found
hub.c: 2 ports detected
usb-uhci.c: v1.275:USB Universal Host Controller Interface driver EXT3
FS 2.4-0.9.18, 14 May 2002 on md(9,1), internal journal kjournald
starting.  Commit interval 5 seconds EXT3 FS 2.4-0.9.18, 14 May 2002 on
md(9,0), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.18, 14 May 2002 on md(9,3), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.18, 14 May 2002 on md(9,2), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ide-floppy driver 0.99.newide
hdc: ATAPI 24X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.12













