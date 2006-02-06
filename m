From: "Hans Rasmussen" <hans@sbsfor.com>
Subject: Raid 1 always degrades after a reboot.
Date: Mon, 6 Feb 2006 15:08:07 -0800
Message-ID: <001b01c62b72$3128a050$f400a8c0@tweety>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all.

After every reboot, my brand new Raid1 array comes up degraded.  It's always 
/dev/sdb1 that is unavailable or removed.

The hardware is as follows......

2x200MB Seagate SATA drives, in RAID 1.... These are for data only, OS is on 
a separate IDE disk.
LVM Partitions for my data on the RAID
Promise SATA300 TX2Plus Sata Card. (use their kernel module, ULSATA2)
Asus P3B motherboard and 400Mhz P2 (getting replaced in the near future)

Software

Mandriva 2006 download edition, upgraded from Mandrake 9.1
Kernel 2.6.12-15mdk (not rebuilt)
MDADM version 00.90.01

Logs, etc......

 dmesg
Linux version 2.6.12-15mdk (qateam@mercury.mandriva.com) (gcc version 4.0.1 
(4.0.1-5mdk for Mandriva Linux release 2006.0)) #1 Mon Jan 9 17:08:48 MST 
2006
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
 BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000027ffc000 (usable)
 BIOS-e820: 0000000027ffc000 - 0000000027fff000 (ACPI data)
 BIOS-e820: 0000000027fff000 - 0000000028000000 (ACPI NVS)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
639MB LOWMEM available.
On node 0 totalpages: 163836
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 159740 pages, LIFO batch:31
  HighMem zone: 0 pages, LIFO batch:1
DMI 2.3 present.
ACPI: RSDP (v000 ASUS                                  ) @ 0x000f58a0
ACPI: RSDT (v001 ASUS   P3B_F    0x30303031 MSFT 0x31313031) @ 0x27ffc000
ACPI: FADT (v001 ASUS   P3B_F    0x30303031 MSFT 0x31313031) @ 0x27ffc080
ACPI: BOOT (v001 ASUS   P3B_F    0x30303031 MSFT 0x31313031) @ 0x27ffc040
ACPI: DSDT (v001   ASUS P3B_F    0x00001000 MSFT 0x0100000b) @ 0x00000000
ACPI: PM-Timer IO Port: 0xe408
Allocating PCI resources starting at 28000000 (gap: 28000000:d7ff0000)
Built 1 zonelists
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (01503000)
Initializing CPU#0
Kernel command line: auto BOOT_IMAGE=linux root=306 quiet acpi=ht 
resume=/dev/hda5 splash=silent
bootsplash: silent mode.
PID hash table entries: 4096 (order: 12, 65536 bytes)
Detected 400.955 MHz processor.
Using pmtmr for high-res timesource
Console: colour dummy device 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 644744k/655344k available (2348k kernel code, 10028k reserved, 717k 
data, 268k init, 0k highmem, 0k BadRAM)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay loop... 794.62 BogoMIPS (lpj=397312)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0183f9ff 00000000 00000000 00000000 
00000000 00000000 00000000
CPU: After vendor identify, caps: 0183f9ff 00000000 00000000 00000000 
00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
CPU: After all inits, caps: 0183f9ff 00000000 00000000 00000040 00000000 
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel Pentium II (Deschutes) stepping 02
Enabling fast FPU save and restore... done.
Checking 'hlt' instruction... OK.
checking if image is initramfs...it isn't (bad gzip magic numbers); looks 
like an initrd
Freeing initrd memory: 299k freed
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xf08b0, last bus=1
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20050309
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
PnPBIOS: Disabled
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:01:00.0
PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:04.0
Simple Boot Flag at 0x3a set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
audit: initializing netlink socket (disabled)
audit(1139207174.020:0): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
devfs: 2004-01-31 Richard Gooch (rgooch@atnf.csiro.au)
devfs: boot_options: 0x0
Initializing Cryptographic API
Limiting direct PCI/PCI transfers.
vesafb: framebuffer at 0xe3000000, mapped to 0xe8880000, using 3750k, total 
4096k
vesafb: mode is 800x600x16, linelength=1600, pages=3
vesafb: protected mode interface info at c000:474c
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
bootsplash 3.1.6-2004/03/31: looking for picture...<6> silentjpeg size 34430 
bytes,<6>...found (800x600, 34382 bytes, v3).
Console: switching to colour frame buffer device 93x30
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing enabled
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
RAMDISK driver initialized: 16 RAM disks of 32000K size 1024 blocksize
pktcdvd: v0.2.0a 2004-07-14 Jens Axboe (axboe@suse.de) and petero2@telia.com
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller at PCI slot 0000:00:04.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xb800-0xb807, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xb808-0xb80f, BIOS settings: hdc:pio, hdd:DMA
Probing IDE interface ide0...
hda: WDC WD400JB-00ENA0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdd: LTN526D, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 78165360 sectors (40020 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(33)
hda: cache flushes not supported
 /dev/ide/host0/bus0/target0/lun0: p1 p2 < p5 p6 p7 p8 p9 p10 >
mice: PS/2 mouse device common for all mice
md: md driver 0.90.1 MAX_MD_DEVS=256, MD_SB_DISKS=27
NET: Registered protocol family 2
IP: routing cache hash table of 8192 buckets, 64Kbytes
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
NET: Registered protocol family 1
swsusp: Suspend partition has wrong signature?
BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
devfs_mk_dev: could not append to parent for md/0
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
RAMDISK: cramfs filesystem found at block 0
RAMDISK: Loading 232KiB [1 disk] into ram disk... done.
VFS: Mounted root (cramfs filesystem) readonly.
input: AT Translated Set 2 keyboard on isa0060/serio0
SCSI subsystem initialized
libata version 1.11 loaded.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
logips2pp: Detected unknown logitech mouse model 1
Freeing unused kernel memory: 268k freed
input: PS/2 Logitech Mouse on isa0060/serio1
usbcore: registered new driver usbfs
usbcore: registered new driver hub
USB Universal Host Controller Interface driver v2.2
PCI: Found IRQ 4 for device 0000:00:04.2
uhci_hcd 0000:00:04.2: UHCI Host Controller
uhci_hcd 0000:00:04.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:04.2: irq 4, io base 0x0000b400
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ts: Compaq touchscreen protocol output
EXT3 FS on hda6, internal journal
device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
Adding 1421712k swap on /dev/hda5.  Priority:-1 extents:1
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 64M @ 0xe4000000
PROMISE SATA-II 150/300 Series Linux Driver v1.01.0.20
PCI: Found IRQ 10 for device 0000:00:0b.0
ulsata2:[info] Drive 1/0: ST3200827AS            390721967s 200050MB  UDMA6
ulsata2:[info] Drive 3/0: ST3200827AS            390721967s 200050MB  UDMA6
scsi0 : ulsata2
  Vendor:           Model: ST3200827AS       Rev:
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
SCSI device sda: drive cache: write through
SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
SCSI device sda: drive cache: write through
 /dev/scsi/host0/bus0/target0/lun0: p1
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
  Vendor:           Model: ST3200827AS       Rev:
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sdb: 390721968 512-byte hdwr sectors (200050 MB)
SCSI device sdb: drive cache: write through
SCSI device sdb: 390721968 512-byte hdwr sectors (200050 MB)
SCSI device sdb: drive cache: write through
 /dev/scsi/host0/bus0/target2/lun0: p1
Attached scsi disk sdb at scsi0, channel 0, id 2, lun 0
md: raid1 personality registered as nr 3
md: md0 stopped.
md: bind<sdb1>
md: bind<sda1>
md: kicking non-fresh sdb1 from array!
md: unbind<sdb1>
md: export_rdev(sdb1)
raid1: raid set md0 active with 1 out of 2 mirrors
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Supermount version 2.0.4 for kernel 2.6
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SGI XFS with ACLs, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem dm-0
Ending clean XFS mount for filesystem: dm-0
XFS mounting filesystem dm-1
Ending clean XFS mount for filesystem: dm-1
XFS mounting filesystem dm-2
Ending clean XFS mount for filesystem: dm-2
XFS mounting filesystem dm-3
Ending clean XFS mount for filesystem: dm-3
loop: loaded (max 8 devices)
hdd: ATAPI 52X CD-ROM drive, 120kB Cache, UDMA(33)


sfdisk --list /dev/sda

Disk /dev/sda: 24321 cylinders, 255 heads, 63 sectors/track
Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0

   Device Boot Start     End   #cyls    #blocks   Id  System
/dev/sda1   *      0+  24320   24321- 195358401   fd  Linux raid autodetect
/dev/sda2          0       -       0          0    0  Empty
/dev/sda3          0       -       0          0    0  Empty
/dev/sda4          0       -       0          0    0  Empty


sfdisk --list /dev/sdb

Disk /dev/sdb: 24321 cylinders, 255 heads, 63 sectors/track
Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0

   Device Boot Start     End   #cyls    #blocks   Id  System
/dev/sdb1          0+  24320   24321- 195358401   fd  Linux raid autodetect
/dev/sdb2          0       -       0          0    0  Empty
/dev/sdb3          0       -       0          0    0  Empty
/dev/sdb4          0       -       0          0    0  Empty

cat /etc/mdadm.conf
DEVICE /dev/sda1 /dev/sdb1
ARRAY /dev/md0 UUID=9c025315:ba66d88a:6c87d7c4:c84f3d70 auto=yes


 mdadm --detail /dev/md0.......(This is after the rebuild, do not have this 
in degraded mode at the moment)
/dev/md0:
        Version : 00.90.01
  Creation Time : Sun Feb  5 13:32:36 2006
     Raid Level : raid1
     Array Size : 195358336 (186.31 GiB 200.05 GB)
    Device Size : 195358336 (186.31 GiB 200.05 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Feb  6 15:00:46 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 9c025315:ba66d88a:6c87d7c4:c84f3d70
         Events : 0.74066

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1

Happy to give any other info.

Thanks

Hans Rasmussen
CIS/GIS Coordinator
SBS Forestry Inc.
250-561-1140 


