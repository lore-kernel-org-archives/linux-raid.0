From: Jay Strauss <me@heyjay.com>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Tue, 17 May 2005 22:28:59 -0500
Message-ID: <428AB67B.4040402@heyjay.com>
References: <428A09A3.9000802@heyjay.com> <Pine.LNX.4.56.0505171649090.32621@lion.drogon.net> <428A1924.8030801@heyjay.com> <Pine.LNX.4.56.0505171720070.32621@lion.drogon.net> <428A2133.4080202@h3c.com> <428A594E.5080207@heyjay.com> <428A59F9.5050908@h3c.com> <428A6D27.7070703@medien.uni-weimar.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428A6D27.7070703@medien.uni-weimar.de>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tobias Hofmann wrote:
> On 17.05.2005 22:54, Mike Hardy wrote:
> 
> [...]
> 
>> That's fine-grained tuning mostly though, and not really on topic for
>> you as it appears you have something entirely different going on. What
>> exactly is going on, I must admit, I don't know. :-/
> 
> 
> <delurk>
> Well, let's find out then, no? ;)
> 
> Jay, you said it yourself - Knoppix seems to be setting something 
> different than Sarge. I am not very familiar with both, but doing a 
> lspci on both (just in case they "see" something different) and 
> comparing, like Gordon suggested, the output of dmesg | less (or a less 
> /var/log/dmesg) on both systems might give you an idea where things 
> start to go differently.
> 
> I would look for differences in the discovery of (the) 
> ide-controller(s), and how the HDs are discovered/treated.
> 
> For completeness' sake, the kernel version of each try could give the 
> experts an idea of differences I am not aware of.
> 
> I am sure to have forgotten something here, but for starters, it might 
> work.
> 
> Just my 2c, good luck, tobi... ;)

Unfortunately, nothing is sticking out at me.  I can't say I know much 
about this stuff (obviously).  I'm new on the list, has this thread 
drifted too much off the charter of this list, such that I should take 
it somewhere else?

For the sake of completeness, below are the tests I was asked to run

jstrauss@hydrogen:~$ cat knoppix.uname
Linux Knoppix 2.4.27 #2 SMP Mo Aug 9 00:39:37 CEST 2004 i686 GNU/Linux
jstrauss@hydrogen:~$ cat sarge.uname
Linux sandy 2.6.8-2-686 #1 Mon Jan 24 03:58:38 EST 2005 i686 GNU/Linux

and diff sarge.dmesg knoppix.dmesg1c1

< Linux version 2.6.8-2-686 (dilinger@toaster.hq.voxel.net) (gcc version 
3.3.5 (Debian 1:3.3.5-6)) #1 Mon Jan 24 03:58:38 EST 2005
---
 > Linux version 2.4.27 (root@Koffer) (gcc version 2.95.4 20011002 
(Debian prerelease)) #2 SMP Mo Aug 9 00:39:37 CEST 2004
12,15c12,14
<   DMA zone: 4096 pages, LIFO batch:1
<   Normal zone: 10240 pages, LIFO batch:2
<   HighMem zone: 0 pages, LIFO batch:1
< DMI 2.2 present.
---
 > zone(0): 4096 pages.
 > zone(1): 10240 pages.
 > zone(2): 0 pages.
18,19c17
< Built 1 zonelists
< Kernel command line: root=/dev/hda1 ro
---
 > Kernel command line: ramdisk_size=100000 init=/etc/init lang=us 
apm=power-off vga=791 initrd=minirt24.gz nomce quiet BOOT_IMAGE=knoppix 
BOOT_IMAGE=linux24 desktop=twm
23,35c21,29
< PID hash table entries: 256 (order 8: 2048 bytes)
< Detected 467.789 MHz processor.
< Using tsc for high-res timesource
< Console: colour VGA+ 80x25
< Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
< Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
< Memory: 49220k/57344k available (1550k kernel code, 7668k reserved, 
688k data, 148k init, 0k highmem)
< Checking if this processor honours the WP bit even in supervisor 
mode... Ok.
< Calibrating delay loop... 919.55 BogoMIPS
< Security Scaffold v1.0.0 initialized
< Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
< CPU: After generic identify, caps: 0183fbff 00000000 00000000 00000000
< CPU: After vendor identify, caps:  0183fbff 00000000 00000000 00000000
---
 > Detected 467.722 MHz processor.
 > Console: colour dummy device 80x25
 > Calibrating delay loop... 930.61 BogoMIPS
 > Memory: 52904k/57344k available (1406k kernel code, 4052k reserved, 
574k data, 144k init, 0k highmem)
 > Dentry cache hash table entries: 8192 (order: 4, 65536 bytes)
 > Inode cache hash table entries: 4096 (order: 3, 32768 bytes)
 > Mount cache hash table entries: 512 (order: 0, 4096 bytes)
 > Buffer cache hash table entries: 1024 (order: 0, 4096 bytes)
 > Page-cache hash table entries: 16384 (order: 4, 65536 bytes)
38,41c32,33
< CPU: After all inits, caps:        0183fbff 00000000 00000000 00000040
< Intel machine check architecture supported.
< Intel machine check reporting enabled on CPU#0.
< CPU: Intel Celeron (Mendocino) stepping 05
---
 > CPU:     After generic, caps: 0183fbff 00000000 00000000 00000000
 > CPU:             Common caps: 0183fbff 00000000 00000000 00000000
43a36,46
 > Checking for popad bug... OK.
 > POSIX conformance testing by UNIFIX
 > mtrr: v1.40 (20010327) Richard Gooch (rgooch@atnf.csiro.au)
 > mtrr: detected mtrr type: Intel
 > CPU: L1 I cache: 16K, L1 D cache: 16K
 > CPU: L2 cache: 128K
 > CPU:     After generic, caps: 0183fbff 00000000 00000000 00000000
 > CPU:             Common caps: 0183fbff 00000000 00000000 00000000
 > CPU0: Intel Celeron (Mendocino) stepping 05
 > per-CPU timeslice cutoff: 365.67 usecs.
 > SMP motherboard not detected.
49,56c52,57
< ..... CPU clock speed is 467.0630 MHz.
< ..... host bus clock speed is 66.0804 MHz.
< checking if image is initramfs...it isn't (ungzip failed); looks like 
an initrd
< Freeing initrd memory: 4544k freed
< NET: Registered protocol family 16
< PCI: PCI BIOS revision 2.10 entry at 0xfdb81, last bus=1
< PCI: Using configuration type 1
< mtrr: v2.0 (20020519)
---
 > ..... CPU clock speed is 467.7528 MHz.
 > ..... host bus clock speed is 66.8216 MHz.
 > cpu: 0, clocks: 668216, slice: 334108
 > CPU0<T0:668208,T1:334096,D:4,S:334108,C:668216>
 > Waiting on wait_init_idle (map = 0x0)
 > All processors have done init_idle
59,63c60,61
< Linux Plug and Play Support v0.97 (c) Adam Belay
< PnPBIOS: Scanning system for PnP BIOS support...
< PnPBIOS: Found PnP BIOS installation structure at 0xc00f7030
< PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0x6584, dseg 0xf0000
< PnPBIOS: 13 nodes reported by PnP BIOS; 13 recorded by driver
---
 > PCI: PCI BIOS revision 2.10 entry at 0xfdb81, last bus=1
 > PCI: Using configuration type 1
66,71c64
< PCI: Using IRQ router SIS [1039/0008] at 0000:00:01.0
< VFS: Disk quotas dquot_6.5.1
< Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
< devfs: 2004-01-31 Richard Gooch (rgooch@atnf.csiro.au)
< devfs: boot_options: 0x0
< Initializing Cryptographic API
---
 > PCI: Using IRQ router SIS5595 [1039/0008] at 00:01.0
74,91c67,83
< Serial: 8250/16550 driver $Revision: 1.90 $ 48 ports, IRQ sharing enabled
< ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
< RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
< serio: i8042 AUX port at 0x60,0x64 irq 12
< serio: i8042 KBD port at 0x60,0x64 irq 1
< input: AT Translated Set 2 keyboard on isa0060/serio0
< NET: Registered protocol family 2
< IP: routing cache hash table of 512 buckets, 4Kbytes
< TCP: Hash tables configured (established 4096 bind 8192)
< NET: Registered protocol family 8
< NET: Registered protocol family 20
< RAMDISK: cramfs filesystem found at block 0
< RAMDISK: Loading 4544 blocks [1 disk] into ram disk... |/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\done.
< VFS: Mounted root (cramfs filesystem) readonly.
< Freeing unused kernel memory: 148k freed
< vesafb: probe of vesafb0 failed with error -6
< NET: Registered protocol family 1
< Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
---
 > Linux NET4.0 for Linux 2.4
 > Based upon Swansea University Computer Society NET3.039
 > Initializing RT netlink socket
 > Starting kswapd
 > VFS: Disk quotas vdquot_6.5.1
 > vesafb: framebuffer at 0xe7000000, mapped to 0xc400d000, size 3072k
 > vesafb: mode is 1024x768x16, linelength=2048, pages=4
 > vesafb: protected mode interface info at c7c3:0000
 > vesafb: scrolling: redraw
 > vesafb: directcolor: size=0:5:6:5, shift=0:11:5:0
 > Console: switching to colour frame buffer device 128x48
 > fb0: VESA VGA frame buffer device
 > pty: 256 Unix98 ptys configured
 > Floppy drive(s): fd0 is 1.44M
 > FDC 0 is a post-1991 82077
 > RAMDISK driver initialized: 16 RAM disks of 100000K size 1024 blocksize
 > Uniform Multi-Platform E-IDE driver Revision: 7.00beta4-2.4
93c85
< SIS5513: IDE controller at PCI slot 0000:00:00.1
---
 > SIS5513: IDE controller at PCI slot 00:00.1
100,104d91
< Using anticipatory io scheduler
< ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
< hda: max request size: 1024KiB
< hda: 312581808 sectors (160041 MB) w/2048KiB Cache, CHS=19457/255/63, 
UDMA(66)
<  /dev/ide/host0/bus0/target0/lun0: p1 p2
105a93
 > ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
107,118c95,168
< kjournald starting.  Commit interval 5 seconds
< EXT3-fs: mounted filesystem with ordered data mode.
< Adding 979956k swap on /dev/hda2.  Priority:-1 extents:1
< EXT3 FS on hda1, internal journal
< Generic RTC Driver v1.07
< hdc: ATAPI 40X CD-ROM drive, 128kB Cache, UDMA(33)
< Uniform CD-ROM driver Revision: 3.20
< input: ImPS/2 Generic Wheel Mouse on isa0060/serio1
< Capability LSM initialized
< mice: PS/2 mouse device common for all mice
< ts: Compaq touchscreen protocol output
< Linux agpgart interface v0.100 (c) Dave Jones
---
 > hda: attached ide-disk driver.
 > hda: host protected area => 1
 > hda: 312581808 sectors (160042 MB) w/2048KiB Cache, CHS=19457/255/63
 > Partition check:
 >  hda: hda1 hda2
 > ide: late registration of driver.
 > SCSI subsystem driver Revision: 1.00
 > libata version 1.02 loaded.
 > kmod: failed to exec /sbin/modprobe -s -k scsi_hostadapter, errno = 2
 > kmod: failed to exec /sbin/modprobe -s -k scsi_hostadapter, errno = 2
 > Initializing Cryptographic API
 > NET4: Linux TCP/IP 1.0 for NET4.0
 > IP Protocols: ICMP, UDP, TCP, IGMP
 > IP: routing cache hash table of 512 buckets, 4Kbytes
 > TCP: Hash tables configured (established 4096 bind 4096)
 > NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
 > RAMDISK: Compressed image found at block 0
 > Freeing initrd memory: 781k freed
 > EXT2-fs warning: checktime reached, running e2fsck is recommended
 > VFS: Mounted root (ext2 filesystem).
 > hdc: attached ide-scsi driver.
 > scsi0 : SCSI host adapter emulation for IDE ATAPI devices
 >   Vendor: BCD       Model: E520C             Rev: 0.40
 >   Type:   CD-ROM                             ANSI SCSI revision: 02
 > Attached scsi CD-ROM sr0 at scsi0, channel 0, id 0, lun 0
 > sr0: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
 > Uniform CD-ROM driver Revision: 3.12
 > NCR53c406a: no available ports found
 > aec671x_detect:
 > scsi: <fdomain> Detection failed (no card)
 > GDT: Storage RAID Controller Driver. Version: 2.05
 > GDT: Found 0 PCI Storage RAID Controllers
 > megaraid: v1.18k (Release Date: Thu Aug 28 10:05:11 EDT 2003)
 > megaraid: no BIOS enabled.
 > DC390: 0 adapters found
 > Failed initialization of WD-7000 SCSI card!
 > Guestimating sector 312560384 for superblock
 > driver for Silicon Image(tm) Medley(tm) hardware version 0.0.1: No 
raid array found
 > Medley RAID: No usable RAID sets found
 > Promise Fasttrak(tm) Softwareraid driver 0.03beta: No raid array found
 > usb.c: registered new driver usbdevfs
 > usb.c: registered new driver hub
 > usb-uhci.c: $Revision: 1.275 $ time 00:50:50 Aug  9 2004
 > usb-uhci.c: High bandwidth mode enabled
 > usb-uhci.c: v1.275:USB Universal Host Controller Interface driver
 > usb-ohci.c: USB OHCI at membase 0xc432d000, IRQ 3
 > usb-ohci.c: usb-00:01.2, Silicon Integrated Systems [SiS] USB 1.0 
Controller
 > usb.c: new USB bus registered, assigned bus number 1
 > hub.c: USB hub found
 > hub.c: 2 ports detected
 > Initializing USB Mass Storage driver...
 > usb.c: registered new driver usb-storage
 > USB Mass Storage support registered.
 > blk: queue c03661a0, I/O limit 4095Mb (mask 0xffffffff)
 > ISO 9660 Extensions: Microsoft Joliet Level 3
 > ISO 9660 Extensions: RRIP_1991A
 > cloop: Initializing cloop v2.01
 > cloop: loaded (max 8 devices)
 > cloop: /cdrom/KNOPPIX/KNOPPIX: 30369 blocks, 65536 bytes/block, 
largest block is 65552 bytes.
 > ISO 9660 Extensions: RRIP_1991A
 > Freeing unused kernel memory: 144k freed
 > Real Time Clock Driver v1.10f
 > apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16)
 > Linux Kernel Card Services 3.1.22
 >   options:  [pci] [cardbus] [pm]
 > Intel ISA PCIC probe: not found.
 > Databook TCIC-2 PCMCIA probe: not found.
 > usb-uhci.c: $Revision: 1.275 $ time 00:50:50 Aug  9 2004
 > usb-uhci.c: High bandwidth mode enabled
 > usb-uhci.c: v1.275:USB Universal Host Controller Interface driver
 > usbdevfs: remount parameter error
 > Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ 
SERIAL_PCI ISAPNP enabled
 > ttyS00 at 0x03f8 (irq = 4) is a 16550A
 > parport0: PC-style at 0x378 [PCSPP,TRISTATE]
120,124c170,173
< PCI: Found IRQ 10 for device 0000:00:0b.0
< eth0: Davicom DM9102 at pci0000:00:0b.0, 00:d0:09:1e:b2:08, irq 10.
< cmpci: version $Revision: 6.82 $ time 04:15:48 Jan 24 2005
< PCI: Found IRQ 9 for device 0000:00:0f.0
< cmpci:
---
 > PCI: Found IRQ 10 for device 00:0b.0
 > eth0: Davicom DM9102 at pci00:0b.0, 00:d0:09:1e:b2:08, irq 10.
 > cmpci: version $Revision: 6.16 $ time 00:49:29 Aug  9 2004
 > PCI: Found IRQ 9 for device 00:0f.0
127,136c176
< usbcore: registered new driver usbfs
< usbcore: registered new driver hub
< ohci_hcd: 2004 Feb 02 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
< ohci_hcd: block sizes: ed 64 td 64
< ohci_hcd 0000:00:01.2: Silicon Integrated Systems [SiS] USB 1.0 Controller
< ohci_hcd 0000:00:01.2: irq 3, pci mem c4032000
< ohci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
< hub 1-0:1.0: USB hub found
< hub 1-0:1.0: 2 ports detected
< agpgart: Detected SiS 620 chipset
---
 > Linux agpgart interface v0.99 (c) Jeff Hartmann
137a178
 > agpgart: Detected SiS 620 chipset
139,154c180
< cpci_hotplug: CompactPCI Hot Plug Core version: 0.2
< pci_hotplug: PCI Hot Plug PCI Core version: 0.5
< pciehp: acpi_pciehprm:get_device PCI ROOT HID fail=0x1001
< shpchp: acpi_shpchprm:get_device PCI ROOT HID fail=0x1001
< Linux Tulip driver version 1.1.13 (May 11, 2002)
< input: PC Speaker
< parport: PnPBIOS parport detected.
< parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
< inserting floppy driver for 2.6.8-2-686
< Floppy drive(s): fd0 is 1.44M
< FDC 0 is a post-1991 82077
< NET: Registered protocol family 17
< NET: Registered protocol family 10
< Disabled Privacy Extensions on device c02ff020(lo)
< IPv6 over IPv4 tunneling driver
< eth0: no IPv6 routers present
---
 > Adding Swap: 979956k swap-space (priority -1)




