From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: Re: is this raid5 OK ?
Date: Fri, 30 Mar 2007 20:23:39 +0200
Message-ID: <460D55AB.1080309@kaneda.iguw.tuwien.ac.at>
References: <237230840.20070329193857@kaneda.iguw.tuwien.ac.at> <17932.22575.558925.535963@notabene.brown> <460CF7EF.1000203@kaneda.iguw.tuwien.ac.at> <460D3A9F.7010800@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <460D3A9F.7010800@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:

> This still looks odd, why should it behave like this. I have created a 
> lot of arrays (when I was doing the RAID5 speed testing thread), and 
> never had anything like this. I'd like to see dmesg to see if there was 
> an error reported regarding this.
> 
> I think there's more going on, the original post showed the array as up 
> rather than some building status, also indicates some issue, perhaps. 
> What is the partition type of each of these partitions? Perhaps there's 
> a clue there.

partition type is FD (linux raid autodetect) on all disks.

here's some more info:
the hardware is pretty old, an 800MHz ASUS board with AMD cpu and an 
extra onboard promise IDE controller with two channels. the server was 
working well with a 60 GB hda disk (system) and a single 400 GB disk 
(hde) for data. kernel was 2.6.19-1.2288.fc5xen0.

when I added 3 more 400 GB disks (hdf to hdh) and created the raid5, the 
server crashed (rebooted, freezed, ...) as soon as there was more 
activity on the raid (kernel panics indicating trouble with interrupts, 
inpage errors etc.) I then upgraded to a 400W power supply, which didn't 
help.  I went back to two single (non-raid) 400 GB disks - same problem.

finally, I figured out that the non-xen kernel works without problems. 
I'm filling the raid5 since several hours now and the system is still 
stable.

I haven't tried to re-create the raid5 using the non-xen kernel, it was 
created using the xen kernel. maybe xen could be the problem ?

I was wrong in my last post - OS  is actually fedora core 5 (sorry for 
the typo)

current state of the raid5:

[root@alfred ~]# mdadm --detail --scan
ARRAY /dev/md0 level=raid5 num-devices=4 spares=1 
UUID=e96cd8fe:c56c3438:6d9b6c14:9f0eebda
[root@alfred ~]# mdadm --misc --detail /dev/md0
/dev/md0:
         Version : 00.90.03
   Creation Time : Fri Mar 30 15:55:42 2007
      Raid Level : raid5
      Array Size : 1172126208 (1117.83 GiB 1200.26 GB)
     Device Size : 390708736 (372.61 GiB 400.09 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Fri Mar 30 20:22:27 2007
           State : active, degraded, recovering
  Active Devices : 3
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

  Rebuild Status : 12% complete

            UUID : e96cd8fe:c56c3438:6d9b6c14:9f0eebda
          Events : 0.26067

     Number   Major   Minor   RaidDevice State
        0      33        1        0      active sync   /dev/hde1
        1      33       65        1      active sync   /dev/hdf1
        2      34        1        2      active sync   /dev/hdg1
        4      34       65        3      spare rebuilding   /dev/hdh1


here's the dmesg of the last reboot (when the raid was already created, 
but still syncing):

Linux version 2.6.20-1.2307.fc5 
(brewbuilder@hs20-bc1-6.build.redhat.com) (gcc version 4.1.1 20070105 
(Red Hat 4.1.1-51)) #1 Sun Mar 18 20:44:48 EDT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009f000 end: 
000000000009f000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009f000 size: 0000000000001000 end: 
00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001feec000 end: 
000000001ffec000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001ffec000 size: 0000000000003000 end: 
000000001ffef000 type: 3
copy_e820_map() start: 000000001ffef000 size: 0000000000010000 end: 
000000001ffff000 type: 2
copy_e820_map() start: 000000001ffff000 size: 0000000000001000 end: 
0000000020000000 type: 4
copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end: 
0000000100000000 type: 2
  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000001ffec000 (usable)
  BIOS-e820: 000000001ffec000 - 000000001ffef000 (ACPI data)
  BIOS-e820: 000000001ffef000 - 000000001ffff000 (reserved)
  BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
511MB LOWMEM available.
Using x86 segment limits to approximate NX protection
Entering add_active_range(0, 0, 131052) 0 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   131052
   HighMem    131052 ->   131052
early_node_map[1] active PFN ranges
     0:        0 ->   131052
On node 0 totalpages: 131052
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 4064 pages, LIFO batch:0
   Normal zone: 991 pages used for memmap
   Normal zone: 125965 pages, LIFO batch:31
   HighMem zone: 0 pages used for memmap
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP (v000 ASUS                                  ) @ 0x000f6a90
ACPI: RSDT (v001 ASUS   A7V      0x30303031 MSFT 0x31313031) @ 0x1ffec000
ACPI: FADT (v001 ASUS   A7V      0x30303031 MSFT 0x31313031) @ 0x1ffec080
ACPI: BOOT (v001 ASUS   A7V      0x30303031 MSFT 0x31313031) @ 0x1ffec040
ACPI: DSDT (v001   ASUS A7V      0x00001000 MSFT 0x0100000b) @ 0x00000000
ACPI: PM-Timer IO Port: 0xe408
Allocating PCI resources starting at 30000000 (gap: 20000000:dfff0000)
Detected 807.219 MHz processor.
Built 1 zonelists.  Total pages: 130029
Kernel command line: ro root=/dev/hda1
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (01404000)
Enabling fast FPU save and restore... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0720000 soft=c071f000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 514564k/524208k available (2090k kernel code, 9120k reserved, 
847k data, 232k init, 0k highmem)
virtual kernel memory layout:
     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
     vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
     lowmem  : 0xc0000000 - 0xdffec000   ( 511 MB)
       .init : 0xc06e0000 - 0xc071a000   ( 232 kB)
       .data : 0xc060a8c5 - 0xc06de614   ( 847 kB)
       .text : 0xc0400000 - 0xc060a8c5   (2090 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1615.43 BogoMIPS 
(lpj=807719)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0183f9ff c1c7f9ff 00000000 00000000 
00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 64K (64 bytes/line)
CPU: After all inits, caps: 0183f1ff c1c7f9ff 00000000 00000420 00000000 
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: AMD Duron(tm) Processor stepping 01
Checking 'hlt' instruction... OK.
ACPI: Core revision 20060707
ACPI: setting ELCR to 0200 (from 1c00)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf1180, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
0000:00:04.1: cannot adjust BAR0 (not I/O)
0000:00:04.1: cannot adjust BAR1 (not I/O)
0000:00:04.1: cannot adjust BAR2 (not I/O)
0000:00:04.1: cannot adjust BAR3 (not I/O)
PCI quirk: region e400-e4ff claimed by vt82c586 ACPI
PCI quirk: region e200-e27f claimed by vt82c686 HW-mon
PCI quirk: region e800-e80f claimed by vt82c686 SMB
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:03: ioport range 0xe400-0xe47f could not be reserved
pnp: 00:03: ioport range 0xe800-0xe80f has been reserved
PCI: Bridge: 0000:00:01.0
   IO window: d000-dfff
   MEM window: df000000-dfdfffff
   PREFETCH window: dff00000-e5ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 6, 262144 bytes)
TCP bind hash table entries: 8192 (order: 5, 163840 bytes)
TCP: Hash tables configured (established 16384 bind 8192)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 958k freed
Simple Boot Flag at 0x3a set to 0x1
apm: BIOS version 1.2 Flags 0x0b (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
audit(1175274274.755:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key D81E1D1A80E5E114
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Disabling Via external APIC routing
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 16 throttling states)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected VIA Twister-K/KT133x/KM133 chipset
agpgart: AGP aperture is 32M @ 0xe6000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:04.1
VP_IDE: chipset revision 16
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c686a (rev 22) IDE UDMA66 controller on pci0000:00:04.1
     ide0: BM-DMA at 0xb800-0xb807, BIOS settings: hda:DMA, hdb:pio
     ide1: BM-DMA at 0xb808-0xb80f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: IC35L060AVVA07-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
PDC20265: IDE controller at PCI slot 0000:00:11.0
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKB] -> GSI 10 (level, 
low) -> IRQ 10
PDC20265: chipset revision 2
PDC20265: ROM enabled at 0x30020000
PDC20265: 100% native mode on irq 10
PDC20265: (U)DMA Burst Bit ENABLED Primary PCI Mode Secondary PCI Mode.
     ide2: BM-DMA at 0x7800-0x7807, BIOS settings: hde:pio, hdf:pio
     ide3: BM-DMA at 0x7808-0x780f, BIOS settings: hdg:pio, hdh:pio
Probing IDE interface ide2...
hde: ST3400832A, ATA DISK drive
hdf: ST3400620A, ATA DISK drive
ide2 at 0x9000-0x9007,0x8802 on irq 10
Probing IDE interface ide3...
hdg: ST3400620A, ATA DISK drive
hdh: ST3400620A, ATA DISK drive
ide3 at 0x8400-0x8407,0x8002 on irq 10
Probing IDE interface ide1...
hda: max request size: 128KiB
hda: 120103200 sectors (61492 MB) w/1863KiB Cache, CHS=65535/16/63, UDMA(33)
hda: cache flushes supported
  hda: hda1 hda2 hda3
hde: max request size: 128KiB
hde: 781422768 sectors (400088 MB) w/8192KiB Cache, CHS=48641/255/63, 
UDMA(100)
hde: cache flushes supported
  hde: hde1
hdf: max request size: 128KiB
hdf: 781422768 sectors (400088 MB) w/16384KiB Cache, CHS=48641/255/63, 
UDMA(100)
hdf: cache flushes supported
  hdf: hdf1
hdg: max request size: 128KiB
hdg: 781422768 sectors (400088 MB) w/16384KiB Cache, CHS=48641/255/63, 
UDMA(100)
hdg: cache flushes supported
  hdg: hdg1
hdh: max request size: 128KiB
hdh: 781422768 sectors (400088 MB) w/16384KiB Cache, CHS=48641/255/63, 
UDMA(100)
hdh: cache flushes supported
  hdh: hdh1
ide-floppy driver 0.99.newide
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Processor cpuid 631 not supported
Using IPI Shortcut mode
ACPI: (supports S0 S1 S3 S4 S5)
Time: tsc clocksource has been installed.
Freeing unused kernel memory: 232k freed
Write protecting the kernel read-only data: 585k
Time: acpi_pm clocksource has been installed.
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1175274281.550:2): selinux=0 auid=4294967295
input: PC Speaker as /class/input/input2
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKB] -> GSI 10 (level, 
low) -> IRQ 10
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:00:0b.0: 3Com PCI 3c905C Tornado at e0838000.
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
parport_pc: VIA parallel port: io=0x378, irq=7
i2c_adapter i2c-9191: sensors disabled - enable with force_addr=0xe200
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 12
PCI: setting IRQ 12 as level-triggered
ACPI: PCI Interrupt 0000:00:04.2[D] -> Link [LNKD] -> GSI 12 (level, 
low) -> IRQ 12
uhci_hcd 0000:00:04.2: UHCI Host Controller
uhci_hcd 0000:00:04.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:04.2: irq 12, io base 0x0000b400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:04.3[D] -> Link [LNKD] -> GSI 12 (level, 
low) -> IRQ 12
uhci_hcd 0000:00:04.3: UHCI Host Controller
uhci_hcd 0000:00:04.3: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:04.3: irq 12, io base 0x0000b000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb 2-2: new full speed USB device using uhci_hcd and address 2
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 4 ports detected
floppy0: no floppy controllers found
lp0: using parport0 (interrupt-driven).
lp0: console ready
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
No dock devices found.
ibm_acpi: ec object not found
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hdh1 ...
md:  adding hdh1 ...
md:  adding hdg1 ...
md:  adding hdf1 ...
md:  adding hde1 ...
md: created md0
md: bind<hde1>
md: bind<hdf1>
md: bind<hdg1>
md: bind<hdh1>
md: running: <hdh1><hdg1><hdf1><hde1>
raid5: measuring checksumming speed
    8regs     :  1220.000 MB/sec
    8regs_prefetch:  1024.000 MB/sec
    32regs    :   752.000 MB/sec
    32regs_prefetch:   716.000 MB/sec
    pII_mmx   :  2184.000 MB/sec
    p5_mmx    :  2908.000 MB/sec
raid5: using function: p5_mmx (2908.000 MB/sec)
raid6: int32x1    285 MB/s
raid6: int32x2    320 MB/s
raid6: int32x4    281 MB/s
raid6: int32x8    273 MB/s
raid6: mmxx1      656 MB/s
raid6: mmxx2     1039 MB/s
raid6: sse1x1     601 MB/s
raid6: sse1x2     910 MB/s
raid6: using algorithm sse1x2 (910 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: device hdg1 operational as raid disk 2
raid5: device hdf1 operational as raid disk 1
raid5: device hde1 operational as raid disk 0
raid5: allocated 4207kB for md0
raid5: raid level 5 set md0 active with 3 out of 4 devices, algorithm 2
RAID5 conf printout:
  --- rd:4 wd:3
  disk 0, o:1, dev:hde1
  disk 1, o:1, dev:hdf1
  disk 2, o:1, dev:hdg1
md: ... autorun DONE.
RAID5 conf printout:
  --- rd:4 wd:3
  disk 0, o:1, dev:hde1
  disk 1, o:1, dev:hdf1
  disk 2, o:1, dev:hdg1
  disk 3, o:1, dev:hdh1
md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 
KB/sec) for recovery.
md: using 128k window, over a total of 390708736 blocks.
loop: loaded (max 8 devices)
EXT3 FS on hda1, internal journal
SGI XFS with ACLs, security attributes, large block numbers, no debug 
enabled
SGI XFS Quota Management subsystem
Filesystem "md0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem md0
Ending clean XFS mount for filesystem: md0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 500464k swap on /dev/hda2.  Priority:-1 extents:1 across:500464k
eth0:  setting full-duplex.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
eth0: no IPv6 routers present

