From: wimpunk <wim-raid@tisnix.be>
Subject: Re: no auto detection of software raid 5 on boot
Date: Fri, 07 Jan 2005 17:48:01 +0100
Message-ID: <41DEBD41.201@tisnix.be>
References: <1105114981.41deb765668b9@familycook1.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1105114981.41deb765668b9@familycook1.net>
Sender: linux-raid-owner@vger.kernel.org
To: google@familycook1.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You're trying to detect the raid before the scsi driver gets loaded.

wim.

google@familycook1.net wrote:
> I am having a problem with auto detection of software raid 5.
> 
> I can set up the the raid device, mkfs.ex3, and mount the disk; but at reboot
> the raid device is not auto decteced.  After the system comes up I can do a
> mdadm -A and the raid will assemble and then I can mount it.
> 
> One interesting note.  I am trying to get the raid system to work on Fedora core
> 2.  But if I boot a Fedora core 3 rescue CD, the raid gets auto detected.
> 
> Any help would be very much appreciated.
> 
> 
> This post is long, but I will try to give all the information that I see
> requested on other posts.
> 
> 
> I am running Fedora core 2 with an updated kernel:  2.6.9-1.11_FC2
> 
> -------------------------  Partition Tables
> -----------------------------------------
> 
> [root@tv-server root]# fdisk -l /dev/sda
> 
> Disk /dev/sda: 160.0 GB, 160041885696 bytes
> 255 heads, 63 sectors/track, 19457 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1        2000    16064968+  fd  Linux raid autodetect
> 
> [root@tv-server root]# fdisk -l /dev/sdb
> 
> Disk /dev/sdb: 160.0 GB, 160041885696 bytes
> 255 heads, 63 sectors/track, 19457 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1        2000    16064968+  fd  Linux raid autodetect
> [root@tv-server root]# fdisk -l /dev/sdc
> 
> Disk /dev/sdc: 160.0 GB, 160041885696 bytes
> 255 heads, 63 sectors/track, 19457 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1               1        2000    16064968+  fd  Linux raid autodetect
> [root@tv-server root]#
> 
> --------------------------  Running mdadm
> --------------------------------------------------------------------
> 
> [root@tv-server root]# mdadm  --create --verbose /dev/md0 --level=5
> --raid-devices=3 --chunk=128 /dev/sda1 /dev/sdb1  /dev/sdc1
> mdadm: layout defaults to left-symmetric
> mdadm: /dev/sda1 appears to contain an ext2fs file system
>     size=64259584K  mtime=Thu Jan  6 05:59:08 2005
> mdadm: /dev/sda1 appears to be part of a raid array:
>     level=5 devices=3 ctime=Thu Jan  6 18:41:48 2005
> mdadm: /dev/sdb1 appears to be part of a raid array:
>     level=5 devices=3 ctime=Thu Jan  6 18:41:48 2005
> mdadm: /dev/sdc1 appears to contain an ext2fs file system
>     size=64259584K  mtime=Thu Jan  6 05:59:08 2005
> mdadm: /dev/sdc1 appears to be part of a raid array:
>     level=5 devices=3 ctime=Thu Jan  6 18:41:48 2005
> mdadm: size set to 16064896K
> Continue creating array? y
> mdadm: array /dev/md0 started.
> 
> -------------------------  Log file from running mdadm
> --------------------------------------------------
> 
> Jan  6 19:47:20 tv-server kernel: md: bind<sda1>
> Jan  6 19:47:20 tv-server kernel: md: bind<sdb1>
> Jan  6 19:47:20 tv-server kernel: md: bind<sdc1>
> Jan  6 19:47:20 tv-server kernel: raid5: automatically using best checksumming
> function: pIII_sse
> Jan  6 19:47:20 tv-server kernel:    pIII_sse  :  3196.000 MB/sec
> Jan  6 19:47:20 tv-server kernel: raid5: using function: pIII_sse (3196.000
> MB/sec)
> Jan  6 19:47:20 tv-server kernel: md: raid5 personality registered as nr 4 Jan 
> 6 19:47:20 tv-server kernel: raid5: device sdb1 operational as raid disk 1 Jan 
> 6 19:47:20 tv-server kernel: raid5: device sda1 operational as raid disk 0 Jan 
> 6 19:47:20 tv-server kernel: raid5: allocated 3166kB for md0 Jan  6 19:47:20
> tv-server kernel: raid5: raid level 5 set md0 active with 2 out of 3 devices,
> algorithm 2 Jan  6 19:47:20 tv-server kernel: RAID5 conf printout: Jan  6
> 19:47:20 tv-server kernel:  --- rd:3 wd:2 fd:1 Jan  6 19:47:20 tv-server
> kernel:  disk 0, o:1, dev:sda1 Jan  6 19:47:20 tv-server kernel:  disk 1, o:1,
> dev:sdb1 Jan  6 19:47:20 tv-server kernel: RAID5 conf printout: Jan  6 19:47:20
> tv-server kernel:  --- rd:3 wd:2 fd:1 Jan  6 19:47:20 tv-server kernel:  disk 0,
> o:1, dev:sda1 Jan  6 19:47:20 tv-server kernel:  disk 1, o:1, dev:sdb1 Jan  6
> 19:47:20 tv-server kernel:  disk 2, o:1, dev:sdc1 Jan  6 19:47:20 tv-server
> kernel: md: syncing RAID array md0 Jan  6 19:47:20 tv-server kernel: md:
> minimum _guaranteed_ reconstruction
> speed: 1000 KB/sec/disc.
> Jan  6 19:47:20 tv-server kernel: md: using maximum available idle IO bandwith
> (but not more than 200000 KB/sec) for reconstruction. Jan  6 19:47:20 tv-server
> kernel: md: using 128k window, over a total of 16064896 blocks.
> 
>     . . .
> 
> Jan  6 20:06:47 tv-server kernel: md: md0: sync done.
> Jan  6 20:06:47 tv-server kernel: RAID5 conf printout:
> Jan  6 20:06:47 tv-server kernel:  --- rd:3 wd:3 fd:0
> Jan  6 20:06:47 tv-server kernel:  disk 0, o:1, dev:sda1
> Jan  6 20:06:47 tv-server kernel:  disk 1, o:1, dev:sdb1
> Jan  6 20:06:47 tv-server kernel:  disk 2, o:1, dev:sdc1
> 
> --------------------------------------  Making file system and mounting
> ---------------------------------------------------------
> 
> [root@tv-server root]# mkfs.ext3 /dev/md0
> mke2fs 1.35 (28-Feb-2004)
> Filesystem label=
> OS type: Linux
> Block size=4096 (log=2)
> Fragment size=4096 (log=2)
> 4022592 inodes, 8032448 blocks
> 401622 blocks (5.00%) reserved for the super user
> First data block=0
> 246 block groups
> 32768 blocks per group, 32768 fragments per group
> 16352 inodes per group
> Superblock backups stored on blocks:
>         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
>         4096000, 7962624
> 
> Writing inode tables: done
> Creating journal (8192 blocks): done
> Writing superblocks and filesystem accounting information: done
> 
> This filesystem will be automatically checked every 24 mounts or 180 days,
> whichever comes first.  Use tune2fs -c or -i to override.
> 
> [root@tv-server root]# mount /md0
> [root@tv-server root]#
> 
> -------------------------------------  Rebooted system
> -------------------------------------------------------
> 
> At this point there is no /dev/md0
> 
> But a mdadm -A reassembles the raid device
> 
> mdadm -A --verbose  /dev/md0 /dev/sda1 /dev/sdb1  /dev/sdc1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 2.
> mdadm: added /dev/sdb1 to /dev/md0 as 1
> mdadm: added /dev/sdc1 to /dev/md0 as 2
> mdadm: added /dev/sda1 to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 3 drives.
> [root@tv-server root]#
> [root@tv-server root]#
> [root@tv-server root]# vi /etc/fstab
> [root@tv-server root]#
> [root@tv-server root]# mount /md0
> [root@tv-server root]#
> 
> 
> 
> ----------------------------------  Compleate dmesg from reboot
> -------------------------------------------------------------------------
> 
> 3CM] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [APC1] (IRQs *16), disabled.
> ACPI: PCI Interrupt Link [APC2] (IRQs *17), disabled.
> ACPI: PCI Interrupt Link [APC3] (IRQs *18), disabled.
> ACPI: PCI Interrupt Link [APC4] (IRQs *19), disabled.
> ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
> ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0, disabled.
> ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0, disabled.
> ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0, disabled.
> ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
> ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0, disabled.
> ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
> ACPI: PCI Interrupt Link [APCS] (IRQs *23), disabled.
> ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0, disabled.
> ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
> ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
> ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled. Linux Plug and
> Play Support v0.97 (c) Adam Belay
> usbcore: registered new driver usbfs
> usbcore: registered new driver hub
> PCI: Using ACPI for IRQ routing
> ACPI: PCI Interrupt Link [LSMB] enabled at IRQ 5
> ACPI: PCI interrupt 0000:00:01.1[A] -> GSI 5 (level, low) -> IRQ 5
> ACPI: PCI Interrupt Link [LUBA] enabled at IRQ 11
> ACPI: PCI interrupt 0000:00:02.0[A] -> GSI 11 (level, low) -> IRQ 11
> ACPI: PCI Interrupt Link [LUBB] enabled at IRQ 11
> ACPI: PCI interrupt 0000:00:02.1[B] -> GSI 11 (level, low) -> IRQ 11
> ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 5
> ACPI: PCI interrupt 0000:00:02.2[C] -> GSI 5 (level, low) -> IRQ 5
> ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 5
> ACPI: PCI interrupt 0000:00:04.0[A] -> GSI 5 (level, low) -> IRQ 5
> ACPI: PCI Interrupt Link [LAPU] enabled at IRQ 11
> ACPI: PCI interrupt 0000:00:05.0[A] -> GSI 11 (level, low) -> IRQ 11
> ACPI: PCI Interrupt Link [LACI] enabled at IRQ 5
> ACPI: PCI interrupt 0000:00:06.0[A] -> GSI 5 (level, low) -> IRQ 5
> ACPI: PCI Interrupt Link [LFIR] enabled at IRQ 11
> ACPI: PCI interrupt 0000:00:0d.0[A] -> GSI 11 (level, low) -> IRQ 11
> ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 11
> ACPI: PCI interrupt 0000:01:07.0[A] -> GSI 11 (level, low) -> IRQ 11
> ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 11
> ACPI: PCI interrupt 0000:01:09.0[A] -> GSI 11 (level, low) -> IRQ 11
> ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 5
> ACPI: PCI interrupt 0000:01:0a.0[A] -> GSI 5 (level, low) -> IRQ 5
> ACPI: PCI interrupt 0000:01:0a.1[A] -> GSI 5 (level, low) -> IRQ 5
> ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 5
> ACPI: PCI interrupt 0000:01:0b.0[A] -> GSI 5 (level, low) -> IRQ 5
> ACPI: PCI Interrupt Link [L3CM] enabled at IRQ 11
> ACPI: PCI interrupt 0000:02:01.0[A] -> GSI 11 (level, low) -> IRQ 11
> ACPI: PCI interrupt 0000:03:00.0[A] -> GSI 11 (level, low) -> IRQ 11
> apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
> apm: overridden by ACPI.
> audit: initializing netlink socket (disabled)
> audit(1105043267.652:0): initialized
> Total HugeTLB memory allocated, 0
> VFS: Disk quotas dquot_6.5.1
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> SELinux:  Registering netfilter hooks
> Initializing Cryptographic API
> ksign: Installing public key data
> Loading keyring
> - Added public key DD066BD18199F20B
> - User ID: Red Hat, Inc. (Kernel Module GPG key)
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> ACPI: Processor [CPU0] (supports C1)
> isapnp: Scanning for PnP cards...
> isapnp: No Plug & Play device found
> Real Time Clock Driver v1.12
> Linux agpgart interface v0.100 (c) Dave Jones
> agpgart: Detected NVIDIA nForce2 chipset
> agpgart: Maximum main memory to use for agp memory: 439M
> agpgart: AGP aperture is 64M @ 0xd8000000
> serio: i8042 AUX port at 0x60,0x64 irq 12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> Serial: 8250/16550 driver $Revision: 1.90 $ 76 ports, IRQ sharing enabled ttyS0
> at I/O 0x3f8 (irq = 4) is a 16550A ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
> divert: not allocating divert_blk for non-ethernet device lo Uniform
> Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> NFORCE2: IDE controller at PCI slot 0000:00:09.0
> NFORCE2: chipset revision 162
> NFORCE2: not 100% native mode: will probe irqs later
> NFORCE2: BIOS didn't set cable bits correctly. Enabling workaround.
> NFORCE2: BIOS didn't set cable bits correctly. Enabling workaround.
> NFORCE2: 0000:00:09.0 (rev a2) UDMA133 controller
>     ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
>     ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA Probing IDE
> interface ide0...
> hda: MAXTOR 6L080J4, ATA DISK drive
> hdb: SAMSUNG SV1204H, ATA DISK drive
> Using cfq io scheduler
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> Probing IDE interface ide1...
> hdc: PLEXTOR CD-R PX-W2410A, ATAPI CD/DVD-ROM drive
> hdd: SAMSUNG SV1204H, ATA DISK drive
> ide1 at 0x170-0x177,0x376 on irq 15
> Probing IDE interface ide2...
> ide2: Wait for ready failed before probe !
> Probing IDE interface ide3...
> ide3: Wait for ready failed before probe !
> Probing IDE interface ide4...
> ide4: Wait for ready failed before probe !
> Probing IDE interface ide5...
> ide5: Wait for ready failed before probe !
> hda: max request size: 128KiB
> hda: 156355584 sectors (80054 MB) w/1819KiB Cache, CHS=65535/16/63, UDMA(133)
> hda: cache flushes supported
>  hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 hda8 >
> hdb: max request size: 128KiB
> hdb: 234493056 sectors (120060 MB) w/2048KiB Cache, CHS=65535/16/63, UDMA(100)
> hdb: cache flushes supported
>  hdb: hdb1
> hdd: max request size: 128KiB
> hdd: 234493056 sectors (120060 MB) w/2048KiB Cache, CHS=65535/16/63, UDMA(100)
> hdd: cache flushes supported
>  hdd: hdd1
> hdc: ATAPI 40X CD-ROM CD-R/RW drive, 4096kB Cache, UDMA(33) Uniform CD-ROM
> driver Revision: 3.20 ide-floppy driver 0.99.newide
> usbcore: registered new driver hiddev
> usbcore: registered new driver usbhid
> drivers/usb/input/hid-core.c: v2.0:USB HID core driver
> mice: PS/2 mouse device common for all mice
> input: AT Translated Set 2 keyboard on isa0060/serio0
> input: ImExPS/2 Logitech Explorer Mouse on isa0060/serio1
> md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
> NET: Registered protocol family 2
> IP: routing cache hash table of 1024 buckets, 32Kbytes
> TCP: Hash tables configured (established 32768 bind 9362) Initializing IPsec
> netlink socket
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> ACPI: (supports S0 S1 S4 S4bios S5)
> ACPI wakeup devices:
> HUB0 HUB1 USB0 USB1 USB2 F139 MMAC MMCI UAR1
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> RAMDISK: Compressed image found at block 0
> VFS: Mounted root (ext2 filesystem).
> SCSI subsystem initialized
> libata version 1.02 loaded.
> sata_sil version 0.54
> ACPI: PCI interrupt 0000:01:07.0[A] -> GSI 11 (level, low) -> IRQ 11
> ata1: SATA max UDMA/100 cmd 0xE081C080 ctl 0xE081C08A bmdma 0xE081C000 irq 11
> ata2: SATA max UDMA/100 cmd 0xE081C0C0 ctl 0xE081C0CA bmdma 0xE081C008 irq 11
> ata1: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 88:207f
> ata1: dev 0 ATA, max UDMA/133, 312581808 sectors: lba48
> ata1: dev 0 configured for UDMA/100
> scsi0 : sata_sil
> ata2: no device found (phy stat 00000000)
> scsi1 : sata_sil
>   Vendor: ATA       Model: ST3160827AS       Rev: 3.42
>   Type:   Direct-Access                      ANSI SCSI revision: 05
> SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB) SCSI device sda:
> drive cache: write back
>  sda: sda1
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> ACPI: PCI interrupt 0000:01:0b.0[A] -> GSI 5 (level, low) -> IRQ 5
> ata3: SATA max UDMA/100 cmd 0xE081E080 ctl 0xE081E08A bmdma 0xE081E000 irq 5
> ata4: SATA max UDMA/100 cmd 0xE081E0C0 ctl 0xE081E0CA bmdma 0xE081E008 irq 5
> ata3: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 88:007f
> ata3: dev 0 ATA, max UDMA/133, 312581808 sectors: lba48
> ata3(0): applying Seagate errata fix
> ata3: dev 0 configured for UDMA/100
> scsi2 : sata_sil
> ata4: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 88:007f
> ata4: dev 0 ATA, max UDMA/133, 312581808 sectors: lba48
> ata4(0): applying Seagate errata fix
> ata4: dev 0 configured for UDMA/100
> scsi3 : sata_sil
>   Vendor: ATA       Model: ST3160023AS       Rev: 3.05
>   Type:   Direct-Access                      ANSI SCSI revision: 05
> SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB) SCSI device sdb:
> drive cache: write back
>  sdb: sdb1
> Attached scsi disk sdb at scsi2, channel 0, id 0, lun 0
>   Vendor: ATA       Model: ST3160023AS       Rev: 3.05
>   Type:   Direct-Access                      ANSI SCSI revision: 05
> SCSI device sdc: 312581808 512-byte hdwr sectors (160042 MB) SCSI device sdc:
> drive cache: write back
>  sdc: sdc1
> Attached scsi disk sdc at scsi3, channel 0, id 0, lun 0 kjournald starting. 
> Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> Freeing unused kernel memory: 148k freed
> SELinux:  Disabled at runtime.
> SELinux:  Unregistering netfilter hooks
> ACPI: Power Button (FF) [PWRF]
> ACPI: PCI interrupt 0000:00:02.2[C] -> GSI 5 (level, low) -> IRQ 5 ehci_hcd
> 0000:00:02.2: EHCI Host Controller
> PCI: Setting latency timer of device 0000:00:02.2 to 64 ehci_hcd 0000:00:02.2:
> irq 5, pci mem e0836000 ehci_hcd 0000:00:02.2: new USB bus registered, assigned
> bus number 1
> PCI: cache line size of 64 is not supported by device 0000:00:02.2 ehci_hcd
> 0000:00:02.2: USB 2.0 enabled, EHCI 1.00, driver 2004-May-10 hub 1-0:1.0: USB
> hub found hub 1-0:1.0: 6 ports detected
> ohci_hcd: 2004 Feb 02 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
> ACPI: PCI interrupt 0000:00:02.0[A] -> GSI 11 (level, low) -> IRQ 11 ohci_hcd
> 0000:00:02.0: OHCI Host Controller
> PCI: Setting latency timer of device 0000:00:02.0 to 64 ohci_hcd 0000:00:02.0:
> irq 11, pci mem e083e000 ohci_hcd 0000:00:02.0: new USB bus registered,
> assigned bus number 2 hub 2-0:1.0: USB hub found hub 2-0:1.0: 3 ports detected
> ACPI: PCI interrupt 0000:00:02.1[B] -> GSI 11 (level, low) -> IRQ 11 ohci_hcd
> 0000:00:02.1: OHCI Host Controller
> PCI: Setting latency timer of device 0000:00:02.1 to 64 ohci_hcd 0000:00:02.1:
> irq 11, pci mem e086c000 ohci_hcd 0000:00:02.1: new USB bus registered,
> assigned bus number 3 hub 3-0:1.0: USB hub found hub 3-0:1.0: 3 ports detected
> EXT3 FS on hda5, internal journal
> device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com
> cdrom: open failed.
> Adding 1048312k swap on /dev/hda3.  Priority:-1 extents:1 kjournald starting. 
> Commit interval 5 seconds EXT3 FS on hda1, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on hda2, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on hda6, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on hda8, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on hda7, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on hdb1, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on hdd1, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
> parport0: irq 7 detected
> Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0 Attached
> scsi generic sg1 at scsi2, channel 0, id 0, lun 0,  type 0 Attached scsi
> generic sg2 at scsi3, channel 0, id 0, lun 0,  type 0 inserting floppy driver
> for 2.6.9-1.11_FC2 FDC 0 is a post-1991 82077
> ieee1394: Initialized config rom entry `ip1394'
> ohci1394: $Rev: 1223 $ Ben Collins <bcollins@debian.org>
> ACPI: PCI interrupt 0000:00:0d.0[A] -> GSI 11 (level, low) -> IRQ 11
> PCI: Setting latency timer of device 0000:00:0d.0 to 64
> ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[11]  MMIO=[e3084000-e30847ff]  Max
> Packet=[2048]
> ACPI: PCI interrupt 0000:02:01.0[A] -> GSI 11 (level, low) -> IRQ 11
> 3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
> 0000:02:01.0: 3Com PCI 3c920 Tornado at 0xc000. Vers LK1.1.19
> divert: allocating divert_blk for eth0
> CSLIP: code copyright 1989 Regents of the University of California ISDN
> subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/1.1.2.3/1.1.2.2/1.1.2.2 loaded
> HiSax: Linux Driver for passive ISDN cards
> HiSax: Version 3.5 (module)
> HiSax: Layer1 Revision 2.46.2.5
> HiSax: Layer2 Revision 2.30.2.4
> HiSax: TeiMgr Revision 2.20.2.3
> HiSax: Layer3 Revision 2.22.2.3
> HiSax: LinkLayer Revision 2.59.2.4
> hisax_isac: ISAC-S/ISAC-SX ISDN driver v0.1.0
> hisax_fcpcipnp: Fritz!Card PCI/PCIv2/PnP ISDN driver v0.0.1
> HiSax: Card 1 Protocol EDSS1 Id=fcpcipnp0 (0)
> HiSax: DSS1 Rev. 2.32.2.3
> HiSax: 2 channels added
> HiSax: MAX_WAITING_CALLS added
> ACPI: PCI interrupt 0000:01:09.0[A] -> GSI 11 (level, low) -> IRQ 11
> hisax_fcpcipnp: found adapter Fritz!Card PCI v2 at 0000:01:09.0
> forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.30.
> ACPI: PCI interrupt 0000:00:04.0[A] -> GSI 5 (level, low) -> IRQ 5
> PCI: Setting latency timer of device 0000:00:04.0 to 64
> divert: allocating divert_blk for eth1
> eth1: forcedeth.c: subsystem: 01043:80a7 bound to 0000:00:04.0
> divert: freeing divert_blk for eth0
> HiSax module removed
> ISDN-subsystem unloaded
> divert: freeing divert_blk for eth1
> ip_tables: (C) 2000-2002 Netfilter core team
> ip_tables: (C) 2000-2002 Netfilter core team
> ACPI: PCI interrupt 0000:02:01.0[A] -> GSI 11 (level, low) -> IRQ 11
> 3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
> 0000:02:01.0: 3Com PCI 3c920 Tornado at 0xc000. Vers LK1.1.19
> divert: allocating divert_blk for eth0
> ip_tables: (C) 2000-2002 Netfilter core team
> forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.30.
> ACPI: PCI interrupt 0000:00:04.0[A] -> GSI 5 (level, low) -> IRQ 5
> PCI: Setting latency timer of device 0000:00:04.0 to 64
> divert: allocating divert_blk for eth1
> eth1: forcedeth.c: subsystem: 01043:80a7 bound to 0000:00:04.0
> eth1: no link during initialization.
> eth1: link up.
> ip_tables: (C) 2000-2002 Netfilter core team
> CSLIP: code copyright 1989 Regents of the University of California PPP generic
> driver version 2.4.2
> divert: not allocating divert_blk for non-ethernet device ppp0
> NET: Registered protocol family 10
> Disabled Privacy Extensions on device c036c5e0(lo)
> IPv6 over IPv4 tunneling driver
> divert: not allocating divert_blk for non-ethernet device sit0
> eth0: no IPv6 routers present
> eth1: no IPv6 routers present
> parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
> parport0: irq 7 detected
> lp0: using parport0 (polling).
> lp0: console ready
> 
> 
> 
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
