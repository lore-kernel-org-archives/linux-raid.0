From: Sebastian Utz <su@rotamente.com>
Subject: Software RAID-5 attempt to access beyond end of device...
Date: Fri, 27 Aug 2004 17:37:13 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1093621033.13979.49.camel@slurp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a problem with an Software RAID-5 at the top of 4 IDE-Drives
connected via 2 Promise UltraTX2 (20268) IDE controller.

FS is EXT3.
Kernel 2.6.8.1	(problem occured with 2.6.7, update didn't helped)
CPU: Pentium II 400
Mainboard: Asus P2B-S

After 29% usage, I've got an Kernel oops and system stalls:
-------- snip start -------------
Aug 27 16:30:18 gharb kernel: attempt to access beyond end of device
Aug 27 16:30:18 gharb kernel: md0: rw=1, want=6917529027856096120,
limit=241215360
Aug 27 16:30:18 gharb kernel: Buffer I/O error on device md0, logical
block 864691128482012014
Aug 27 16:30:18 gharb kernel: lost page write due to I/O error on md0
Aug 27 16:30:18 gharb kernel: Unable to handle kernel paging request at
virtual address d5c85204
Aug 27 16:30:18 gharb kernel:  printing eip:
Aug 27 16:30:18 gharb kernel: c026b031
Aug 27 16:30:18 gharb kernel: *pde = 00000000
Aug 27 16:30:18 gharb kernel: Oops: 0000 [#1]
Aug 27 16:30:18 gharb kernel: PREEMPT
Aug 27 16:30:18 gharb kernel: Modules linked in: b1pci b1dma b1 capi
capifs kernelcapi
Aug 27 16:30:18 gharb kernel: CPU:    0
Aug 27 16:30:18 gharb kernel: EIP:   
0060:[generic_make_request+17/496]    Not tainted
Aug 27 16:30:18 gharb kernel: EFLAGS: 00010296   (2.6.8.1)
Aug 27 16:30:18 gharb kernel: EIP is at generic_make_request+0x11/0x1f0
Aug 27 16:30:18 gharb kernel: eax: 00000000   ebx: c9226ba8   ecx:
d5c85200   edx: 00060008
Aug 27 16:30:18 gharb kernel: esi: c7cc7860   edi: c7cc7860   ebp:
0c001000   esp: d139bd0c
Aug 27 16:30:18 gharb kernel: ds: 007b   es: 007b   ss: 0068
Aug 27 16:30:18 gharb kernel: Process kjournald (pid: 268,
threadinfo=d139a000 task=d1399710)
Aug 27 16:30:18 gharb kernel: Stack: 00000000 00000000 d1399710 c0118b00
d139bd3c d139bd3c 00000000 0e60a778
Aug 27 16:30:18 gharb kernel:        00000000 00000000 d1399710 c0118b00
d139bd3c d139bd3c 00000000 d139a000
Aug 27 16:30:18 gharb kernel:        c0104fb5 c7cc7860 00000000 c9226ba8
c7cc7860 00000001 00000040 c026b26d
Aug 27 16:30:18 gharb kernel: Call Trace:
Aug 27 16:30:18 gharb kernel:  [autoremove_wake_function+0/96]
autoremove_wake_function+0x0/0x60
Aug 27 16:30:18 gharb kernel:  [autoremove_wake_function+0/96]
autoremove_wake_function+0x0/0x60
Aug 27 16:30:18 gharb kernel:  [need_resched+39/50]
need_resched+0x27/0x32
Aug 27 16:30:18 gharb kernel:  [submit_bio+93/256] submit_bio+0x5d/0x100
Aug 27 16:30:18 gharb kernel:  [end_buffer_write_sync+0/112]
end_buffer_write_sync+0x0/0x70
Aug 27 16:30:18 gharb kernel:  [submit_bh+97/336] submit_bh+0x61/0x150
Aug 27 16:30:18 gharb kernel:  [ll_rw_block+109/144]
ll_rw_block+0x6d/0x90
Aug 27 16:30:18 gharb kernel:  [journal_commit_transaction+4078/4688]
journal_commit_transaction+0xfee/0x1250
Aug 27 16:30:18 gharb kernel:  [fbcon_cursor+719/1024]
fbcon_cursor+0x2cf/0x400
Aug 27 16:30:18 gharb kernel:  [kjournald+217/624] kjournald+0xd9/0x270
Aug 27 16:30:18 gharb kernel:  [autoremove_wake_function+0/96]
autoremove_wake_function+0x0/0x60
Aug 27 16:30:18 gharb kernel:  [autoremove_wake_function+0/96]
autoremove_wake_function+0x0/0x60
Aug 27 16:30:18 gharb kernel:  [ret_from_fork+6/20]
ret_from_fork+0x6/0x14
Aug 27 16:30:18 gharb kernel:  [commit_timeout+0/16]
commit_timeout+0x0/0x10
Aug 27 16:30:18 gharb kernel:  [kjournald+0/624] kjournald+0x0/0x270
Aug 27 16:30:18 gharb kernel:  [kernel_thread_helper+5/24]
kernel_thread_helper+0x5/0x18
Aug 27 16:30:18 gharb kernel: Code: 8b 41 04 c1 ed 09 8b 70 38 8b 58 34
0f ac f3 09 c1 fe 09 89
---------------- snip end -----------

2 Disks are around 40 GB, 2 are around 80GB.
All 4 disk are different size and manufacturer, maybe this is the
problem?

Please help!!!
I already search the web(google, groups), but without success!
Thanks a lot.
sebastian


more info about my system:
raidtab:
raiddev /dev/md0
        raid-level      5
        nr-raid-disks   4
        nr-spare-disks  0
        persistent-superblock 1
        parity-algorithm        left-symmetric
        chunk-size      32
        device          /dev/hde1
        raid-disk       0
        device          /dev/hdg1
        raid-disk       1
        device          /dev/hdi1
        raid-disk       2
        device          /dev/hdk1
        raid-disk       3

gharb:~# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda3             7.9G  1.6G  6.0G  21% /
/dev/sda1              47M   20M   25M  46% /boot
/dev/md0              114G   31G   78G  29% /data


complete dmesg output at start:
---------- dmesg start --------------
Linux version 2.6.8.1 (root@xukay) (gcc version 3.3.4 (Debian
1:3.3.4-3)) #1 Fri Aug 27 14:50:18 CEST 2004
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
 BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000011ffd000 (usable)
 BIOS-e820: 0000000011ffd000 - 0000000011fff000 (ACPI data)
 BIOS-e820: 0000000011fff000 - 0000000012000000 (ACPI NVS)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
287MB LOWMEM available.
On node 0 totalpages: 73725
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 69629 pages, LIFO batch:16
  HighMem zone: 0 pages, LIFO batch:1
DMI 2.0 present.
ACPI: RSDP (v000 ASUS                                      ) @
0x000f8030
ACPI: RSDT (v001 ASUS   P2B-S    0x42302e31 MSFT 0x31313031) @
0x11ffd000
ACPI: FADT (v001 ASUS   P2B-S    0x42302e31 MSFT 0x31313031) @
0x11ffd080
ACPI: BOOT (v001 ASUS   P2B-S    0x42302e31 MSFT 0x31313031) @
0x11ffd040
ACPI: DSDT (v001   ASUS P2B-S    0x00001000 MSFT 0x01000001) @
0x00000000
ACPI: Vendor "  ASUS" System "P2B-S   " Revision 0x0 has a known ACPI
BIOS problem.
ACPI: Reason: Bogus PCI routing. This is a non-recoverable error
ACPI: BIOS listed in blacklist, disabling ACPI support
Built 1 zonelists
Kernel command line: auto BOOT_IMAGE=Linux ro root=803
Local APIC disabled by BIOS -- reenabling.
Found and enabled local APIC!
Initializing CPU#0
PID hash table entries: 2048 (order 11: 16384 bytes)
Detected 400.936 MHz processor.
Using tsc for high-res timesource
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 286472k/294900k available (3141k kernel code, 7664k reserved,
1313k data, 204k init, 0k highmem)
Checking if this processor honours the WP bit even in supervisor mode...
Ok.
Calibrating delay loop... 790.52 BogoMIPS
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU: After generic identify, caps: 0183fbff 00000000 00000000 00000000
CPU: After vendor identify, caps:  0183fbff 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
CPU: After all inits, caps:        0183fbff 00000000 00000000 00000040
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel Pentium II (Deschutes) stepping 02
Enabling fast FPU save and restore... done.
Checking 'hlt' instruction... OK.
enabled ExtINT on CPU#0
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Using local APIC timer interrupts.
calibrating APIC timer ...
..... CPU clock speed is 400.0847 MHz.
..... host bus clock speed is 100.0211 MHz.
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xf0720, last bus=1
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20040326
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:04.0
vesafb: probe of vesafb0 failed with error -6
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
fb0: VGA16 VGA frame buffer device
Simple Boot Flag at 0x46 set to 0x1
Machine check exception polling timer started.
audit: initializing netlink socket (disabled)
audit(1093626961.4294966132:0): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
udf: registering filesystem
Initializing Cryptographic API
Limiting direct PCI/PCI transfers.
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Console: switching to colour frame buffer device 80x30
lp: driver loaded but no devices found
Linux agpgart interface v0.100 (c) Dave Jones
agpgart: Detected an Intel 440BX Chipset.
agpgart: Maximum main memory to use for agp memory: 232M
agpgart: AGP aperture is 64M @ 0xe4000000
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing
disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
parport0: PC-style at 0x378 (0x778) [PCSPP(,...)]
parport0: irq 7 detected
lp0: using parport0 (polling).
Using anticipatory io scheduler
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
PCI: Found IRQ 10 for device 0000:00:0b.0
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:00:0b.0: 3Com PCI 3c905C Tornado at 0x7400. Vers LK1.1.19
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with
idebus=xx
PIIX4: IDE controller at PCI slot 0000:00:04.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xb800-0xb807, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xb808-0xb80f, BIOS settings: hdc:DMA, hdd:pio
hdc: HITACHI DVD-ROM GD-2500, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
PDC20268: IDE controller at PCI slot 0000:00:09.0
PCI: Found IRQ 5 for device 0000:00:09.0
PCI: Sharing IRQ 5 with 0000:00:04.2
PCI: Sharing IRQ 5 with 0000:00:06.0
PDC20268: chipset revision 1
PDC20268: 100% native mode on irq 5
    ide2: BM-DMA at 0x9400-0x9407, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0x9408-0x940f, BIOS settings: hdg:pio, hdh:pio
hde: IBM-DTLA-307045, ATA DISK drive
ide2 at 0xa800-0xa807,0xa402 on irq 5
hdg: IC35L060AVV207-0, ATA DISK drive
ide3 at 0xa000-0xa007,0x9802 on irq 5
PDC20268: IDE controller at PCI slot 0000:00:0a.0
PCI: Found IRQ 12 for device 0000:00:0a.0
PDC20268: chipset revision 1
PDC20268: 100% native mode on irq 12
    ide4: BM-DMA at 0x7800-0x7807, BIOS settings: hdi:pio, hdj:pio
    ide5: BM-DMA at 0x7808-0x780f, BIOS settings: hdk:pio, hdl:pio
hdi: SAMSUNG SP0812N, ATA DISK drive
ide4 at 0x9000-0x9007,0x8802 on irq 12
hdk: IC35L080AVVA07-0, ATA DISK drive
ide5 at 0x8400-0x8407,0x8002 on irq 12
hde: max request size: 128KiB
hde: 90069840 sectors (46115 MB) w/1916KiB Cache, CHS=65535/16/63,
UDMA(100)
 hde: hde1
hdg: max request size: 1024KiB
hdg: 80418240 sectors (41174 MB) w/1821KiB Cache, CHS=16383/255/63,
UDMA(100)
 hdg: hdg1
hdi: max request size: 1024KiB
hdi: 156368016 sectors (80060 MB) w/8192KiB Cache, CHS=16383/255/63,
UDMA(100)
 hdi: hdi1
hdk: max request size: 128KiB
hdk: 160836480 sectors (82348 MB) w/1863KiB Cache, CHS=65535/16/63,
UDMA(100)
 hdk: hdk1
hdc: ATAPI 24X DVD-ROM drive, 512kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
PCI: Found IRQ 5 for device 0000:00:06.0
PCI: Sharing IRQ 5 with 0000:00:04.2
PCI: Sharing IRQ 5 with 0000:00:09.0
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7890/91 Ultra2 SCSI adapter>
        aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs

(scsi0:A:0): 80.000MB/s transfers (40.000MHz, offset 30, 16bit)
  Vendor: IBM       Model: DNES-309170W      Rev: SAH0
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
SCSI device sda: 17916240 512-byte hdwr sectors (9173 MB)
SCSI device sda: drive cache: write through
 sda: sda1 sda2 sda3
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
ieee1394: raw1394: /dev/raw1394 device initialized
sbp2: $Rev: 1219 $ Ben Collins <bcollins@debian.org>
USB Universal Host Controller Interface driver v2.2
PCI: Found IRQ 5 for device 0000:00:04.2
PCI: Sharing IRQ 5 with 0000:00:06.0
PCI: Sharing IRQ 5 with 0000:00:09.0
uhci_hcd 0000:00:04.2: Intel Corp. 82371AB/EB/MB PIIX4 USB
uhci_hcd 0000:00:04.2: irq 5, io base 0000b400
uhci_hcd 0000:00:04.2: new USB bus registered, assigned bus number 1
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usbcore: registered new driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Initializing USB Mass Storage driver...
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.0:USB HID core driver
mice: PS/2 mouse device common for all mice
input: PC Speaker
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
md: linear personality registered as nr 1
md: raid0 personality registered as nr 2
md: raid1 personality registered as nr 3
md: raid5 personality registered as nr 4
raid5: measuring checksumming speed
   8regs     :   732.000 MB/sec
   8regs_prefetch:   612.000 MB/sec
   32regs    :   364.000 MB/sec
   32regs_prefetch:   348.000 MB/sec
   pII_mmx   :   996.000 MB/sec
   p5_mmx    :  1044.000 MB/sec
raid5: using function: p5_mmx (1044.000 MB/sec)
raid6: int32x1    105 MB/s
raid6: int32x2    113 MB/s
raid6: int32x4     97 MB/s
raid6: int32x8     97 MB/s
raid6: mmxx1      234 MB/s
raid6: mmxx2      292 MB/s
raid6: using algorithm mmxx2 (292 MB/s)
md: raid6 personality registered as nr 8
md: multipath personality registered as nr 7
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
Advanced Linux Sound Architecture Driver Version 1.0.4 (Mon May 17
14:31:44 2004 UTC).
ALSA device list:
  No soundcards found.
NET: Registered protocol family 2
IP: routing cache hash table of 2048 buckets, 16Kbytes
TCP: Hash tables configured (established 32768 bind 65536)
ip_tables: (C) 2000-2002 Netfilter core team
ipt_recent v0.3.1: Stephen Frost <sfrost@snowman.net>. 
http://snowman.net/projects/ipt_recent/
arp_tables: (C) 2002 David S. Miller
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hdk1 ...
md:  adding hdk1 ...
md:  adding hdi1 ...
md:  adding hdg1 ...
md:  adding hde1 ...
md: created md0
md: bind<hde1>
md: bind<hdg1>
md: bind<hdi1>
md: bind<hdk1>
md: running: <hdk1><hdi1><hdg1><hde1>
md: md0: raid array is not clean -- starting background reconstruction
raid5: device hdk1 operational as raid disk 3
raid5: device hdi1 operational as raid disk 2
raid5: device hdg1 operational as raid disk 1
raid5: device hde1 operational as raid disk 0
raid5: allocated 4201kB for md0
raid5: raid level 5 set md0 active with 4 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:4 fd:0
 disk 0, o:1, dev:hde1
 disk 1, o:1, dev:hdg1
 disk 2, o:1, dev:hdi1
 disk 3, o:1, dev:hdk1
md: ... autorun DONE.
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 200000
KB/sec) for reconstruction.
md: using 128k window, over a total of 40202560 blocks.
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
spurious 8259A interrupt: IRQ7.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 204k freed
Adding 499704k swap on /dev/sda2.  Priority:-1 extents:1
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
CAPI Subsystem Rev 1.1.2.8
capifs: Rev 1.1.2.3
capi20: Rev 1.1.2.7: started up with major 68 (middleware+capifs)
b1: revision 1.1.2.2
b1dma: revision 1.1.2.3
PCI: Found IRQ 11 for device 0000:00:0c.0
b1pci: PCI BIOS reports AVM-B1 at i/o 0x6800, irq 11
kcapi: Controller 1: b1pci-6800 attached
b1pci: AVM B1 PCI at i/o 0x6800, irq 11, revision 2
b1pci: revision 1.1.2.2
b1pci-6800: card 1 "B1" ready.
b1pci-6800: card 1 Protocol: DSS1
b1pci-6800: card 1 Linetype: point to multipoint
b1pci-6800: B1-card (3.10-02) now active
kcapi: card 1 "b1pci-6800" ready.
----------- dmesg output end ----------

