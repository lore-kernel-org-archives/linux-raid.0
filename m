From: Troels Bang Jensen <marvin@fnuck.dk>
Subject: Re: RAID 5 array keeps dropping drive on boot
Date: Tue, 8 Nov 2005 02:34:04 +0100
Message-ID: <4E521E9D-FDA7-4F7B-9E30-6DE568050214@fnuck.dk>
References: <2A807893-B5A6-4EF1-B862-1D6F22D71B60@fnuck.dk> <17263.57266.902113.362087@cse.unsw.edu.au> <5DD8751D-7FE2-4179-9887-853A704DE0D6@fnuck.dk> <17263.59743.163989.959271@cse.unsw.edu.au> <D8682F09-5A4D-4356-8FA6-825880F93AE4@fnuck.dk> <17263.61561.506974.198576@cse.unsw.edu.au>
Mime-Version: 1.0 (Apple Message framework v734)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17263.61561.506974.198576@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Nov 8, 2005, at 01:25 , Neil Brown wrote:

> On Tuesday November 8, marvin@fnuck.dk wrote:
>
>>
>> All in all I have made 4 or 5 syncs now, each taking about 9 hours.
>> And I've made sure to shut down the computer cleanly afterwards.
>>
>>
>
> Ok.  Can you give me a complete boot log, rather than the edited
> version.  There might be something important in there.
>
>

Okay. This log starts with a sync, after which I reboot to see if the  
disk will stay in the RAID.

Note that hdc at this point is placed on a PCI IDE controller, so  
it's called hde, i.e. we have hda3, hde3 and hdg2 as disks in md1.  
compare with md0, which is hda1 and hde1 and gets detected properly.


Oct 29 20:15:09 localhost kernel: RAID5 conf printout:
Oct 29 20:15:09 localhost kernel:  --- rd:3 wd:2 fd:1
Oct 29 20:15:09 localhost kernel:  disk 0, o:1, dev:hda3
Oct 29 20:15:09 localhost kernel:  disk 1, o:1, dev:hde3
Oct 29 20:15:09 localhost kernel:  disk 2, o:1, dev:hdg2
Oct 29 20:15:09 localhost kernel: ..<6>md: syncing RAID array md1
Oct 29 20:15:09 localhost kernel: md: minimum _guaranteed_  
reconstruction speed: 1000 KB/sec/disc.
Oct 29 20:15:09 localhost kernel: md: using maximum available idle IO  
bandwith (but not more than 200000 KB/sec) for reconstruction.
Oct 29 20:15:09 localhost kernel: md: using 128k window, over a total  
of 292792576 blocks.
Oct 30 04:03:05 localhost kernel: md: md1: sync done.
Oct 30 04:03:05 localhost kernel: RAID5 conf printout:
Oct 30 04:03:05 localhost kernel:  --- rd:3 wd:3 fd:0
Oct 30 04:03:05 localhost kernel:  disk 0, o:1, dev:hda3
Oct 30 04:03:05 localhost kernel:  disk 1, o:1, dev:hde3
Oct 30 04:03:05 localhost kernel:  disk 2, o:1, dev:hdg2
Oct 30 04:22:42 localhost kernel: Kernel logging (proc) stopped.
Oct 30 04:22:42 localhost kernel: Kernel log daemon terminating.
Oct 30 04:24:44 localhost kernel: klogd 1.4.1#17, log source = /proc/ 
kmsg started.
Oct 30 04:24:44 localhost kernel: Inspecting /boot/ 
System.map-2.6.12-1-k7
Oct 30 04:24:44 localhost kernel: Loaded 27770 symbols from /boot/ 
System.map-2.6.12-1-k7.
Oct 30 04:24:44 localhost kernel: Symbols match kernel version 2.6.12.
Oct 30 04:24:44 localhost kernel: No module symbols loaded - kernel  
modules not enabled.
Oct 30 04:24:44 localhost kernel: Linux version 2.6.12-1-k7  
(horms@tabatha.lab.ultramonkey.org) (gcc version 4.0.2 20050917  
(prerelease) (Debian 4.0.1-8)) #1 Tue Sep 27 13:22:07 JST 2005
Oct 30 04:24:44 localhost kernel: BIOS-provided physical RAM map:
Oct 30 04:24:44 localhost kernel:  BIOS-e820: 0000000000000000 -  
00000000000a0000 (usable)
Oct 30 04:24:44 localhost kernel:  BIOS-e820: 00000000000f0000 -  
0000000000100000 (reserved)
Oct 30 04:24:44 localhost kernel:  BIOS-e820: 0000000000100000 -  
000000001bff0000 (usable)
Oct 30 04:24:44 localhost kernel:  BIOS-e820: 000000001bff0000 -  
000000001bff3000 (ACPI NVS)
Oct 30 04:24:44 localhost kernel:  BIOS-e820: 000000001bff3000 -  
000000001c000000 (ACPI data)
Oct 30 04:24:44 localhost kernel:  BIOS-e820: 00000000ffff0000 -  
0000000100000000 (reserved)
Oct 30 04:24:44 localhost kernel: 0MB HIGHMEM available.
Oct 30 04:24:44 localhost kernel: 447MB LOWMEM available.
Oct 30 04:24:44 localhost kernel: On node 0 totalpages: 114672
Oct 30 04:24:44 localhost kernel:   DMA zone: 4096 pages, LIFO batch:1
Oct 30 04:24:44 localhost kernel:   Normal zone: 110576 pages, LIFO  
batch:31
Oct 30 04:24:44 localhost kernel:   HighMem zone: 0 pages, LIFO batch:1
Oct 30 04:24:44 localhost kernel: DMI 2.2 present.
Oct 30 04:24:44 localhost kernel: ACPI: RSDP (v000  
VIA694                                ) @ 0x000f6bc0
Oct 30 04:24:44 localhost kernel: ACPI: RSDT (v001 VIA694 AWRDACPI  
0x42302e31 AWRD 0x00000000) @ 0x1bff3000
Oct 30 04:24:44 localhost kernel: ACPI: FADT (v001 VIA694 AWRDACPI  
0x42302e31 AWRD 0x00000000) @ 0x1bff3040
Oct 30 04:24:44 localhost kernel: ACPI: DSDT (v001 VIA694 AWRDACPI  
0x00001000 MSFT 0x0100000c) @ 0x00000000
Oct 30 04:24:44 localhost kernel: ACPI: BIOS age (2000) fails cutoff  
(2001), acpi=force is required to enable ACPI
Oct 30 04:24:44 localhost kernel: ACPI: Disabling ACPI support
Oct 30 04:24:44 localhost kernel: Allocating PCI resources starting  
at 1c000000 (gap: 1c000000:e3ff0000)
Oct 30 04:24:44 localhost kernel: Built 1 zonelists
Oct 30 04:24:44 localhost kernel: Kernel command line: root=/dev/md1 ro
Oct 30 04:24:44 localhost kernel: Local APIC disabled by BIOS -- you  
can enable it with "lapic"
Oct 30 04:24:44 localhost kernel: mapped APIC to ffffd000 (01382000)
Oct 30 04:24:44 localhost kernel: Initializing CPU#0
Oct 30 04:24:44 localhost kernel: PID hash table entries: 2048  
(order: 11, 32768 bytes)
Oct 30 04:24:44 localhost kernel: Detected 651.493 MHz processor.
Oct 30 04:24:44 localhost kernel: Using tsc for high-res timesource
Oct 30 04:24:44 localhost kernel: Console: colour VGA+ 80x25
Oct 30 04:24:44 localhost kernel: Dentry cache hash table entries:  
65536 (order: 6, 262144 bytes)
Oct 30 04:24:44 localhost kernel: Inode-cache hash table entries:  
32768 (order: 5, 131072 bytes)
Oct 30 04:24:44 localhost kernel: Memory: 446436k/458688k available  
(1692k kernel code, 11660k reserved, 721k data, 176k init, 0k highmem)
Oct 30 04:24:44 localhost kernel: Checking if this processor honours  
the WP bit even in supervisor mode... Ok.
Oct 30 04:24:44 localhost kernel: Calibrating delay loop... 1282.04  
BogoMIPS (lpj=641024)
Oct 30 04:24:44 localhost kernel: Security Framework v1.0.0 initialized
Oct 30 04:24:44 localhost kernel: SELinux:  Disabled at boot.
Oct 30 04:24:44 localhost kernel: Mount-cache hash table entries: 512
Oct 30 04:24:44 localhost kernel: CPU: After generic identify, caps:  
0183f9ff c1c3f9ff 00000000 00000000 00000000 00000000 00000000
Oct 30 04:24:44 localhost kernel: CPU: After vendor identify, caps:  
0183f9ff c1c3f9ff 00000000 00000000 00000000 00000000 00000000
Oct 30 04:24:44 localhost kernel: CPU: L1 I Cache: 64K (64 bytes/ 
line), D cache 64K (64 bytes/line)
Oct 30 04:24:44 localhost kernel: CPU: L2 Cache: 512K (64 bytes/line)
Oct 30 04:24:44 localhost kernel: CPU: After all inits, caps:  
0183f9ff c1c3f9ff 00000000 00000020 00000000 00000000 00000000
Oct 30 04:24:44 localhost kernel: Intel machine check architecture  
supported.
Oct 30 04:24:44 localhost kernel: Intel machine check reporting  
enabled on CPU#0.
Oct 30 04:24:44 localhost kernel: CPU: AMD Athlon(tm) Processor  
stepping 01
Oct 30 04:24:44 localhost kernel: Enabling fast FPU save and  
restore... done.
Oct 30 04:24:44 localhost kernel: Checking 'hlt' instruction... OK.
Oct 30 04:24:44 localhost kernel: checking if image is initramfs...it  
isn't (bad gzip magic numbers); looks like an initrd
Oct 30 04:24:44 localhost kernel: Freeing initrd memory: 4820k freed
Oct 30 04:24:44 localhost kernel: NET: Registered protocol family 16
Oct 30 04:24:44 localhost kernel: PCI: PCI BIOS revision 2.10 entry  
at 0xfb270, last bus=1
Oct 30 04:24:44 localhost kernel: PCI: Using configuration type 1
Oct 30 04:24:44 localhost kernel: mtrr: v2.0 (20020519)
Oct 30 04:24:44 localhost kernel: ACPI: Subsystem revision 20050309
Oct 30 04:24:44 localhost kernel: ACPI: Interpreter disabled.
Oct 30 04:24:44 localhost kernel: Linux Plug and Play Support v0.97  
(c) Adam Belay
Oct 30 04:24:44 localhost kernel: pnp: PnP ACPI: disabled
Oct 30 04:24:44 localhost kernel: PnPBIOS: Scanning system for PnP  
BIOS support...
Oct 30 04:24:44 localhost kernel: PnPBIOS: Found PnP BIOS  
installation structure at 0xc00fbfa0
Oct 30 04:24:44 localhost kernel: PnPBIOS: PnP BIOS version 1.0,  
entry 0xf0000:0xbfd0, dseg 0xf0000
Oct 30 04:24:44 localhost kernel: PnPBIOS: 10 nodes reported by PnP  
BIOS; 10 recorded by driver
Oct 30 04:24:44 localhost kernel: PCI: Probing PCI hardware
Oct 30 04:24:44 localhost kernel: PCI: Probing PCI hardware (bus 00)
Oct 30 04:24:44 localhost kernel: Boot video device is 0000:01:00.0
Oct 30 04:24:44 localhost kernel: PCI: Using IRQ router VIA  
[1106/0686] at 0000:00:07.0
Oct 30 04:24:44 localhost kernel: VFS: Disk quotas dquot_6.5.1
Oct 30 04:24:44 localhost kernel: Dquot-cache hash table entries:  
1024 (order 0, 4096 bytes)
Oct 30 04:24:44 localhost kernel: devfs: 2004-01-31 Richard Gooch  
(rgooch@atnf.csiro.au)
Oct 30 04:24:44 localhost kernel: devfs: boot_options: 0x0
Oct 30 04:24:44 localhost kernel: Initializing Cryptographic API
Oct 30 04:24:44 localhost kernel: PCI: Disabling Via external APIC  
routing
Oct 30 04:24:44 localhost kernel: isapnp: Scanning for PnP cards...
Oct 30 04:24:44 localhost kernel: isapnp: No Plug & Play device found
Oct 30 04:24:44 localhost kernel: PNP: PS/2 controller doesn't have  
AUX irq; using default 0xc
Oct 30 04:24:44 localhost kernel: PNP: PS/2 Controller [PNP0303] at  
0x60,0x64 irq 112
Oct 30 04:24:44 localhost kernel: serio: i8042 AUX port at 0x60,0x64  
irq 12
Oct 30 04:24:44 localhost kernel: serio: i8042 KBD port at 0x60,0x64  
irq 1
Oct 30 04:24:44 localhost kernel: Serial: 8250/16550 driver  
$Revision: 1.90 $ 48 ports, IRQ sharing enabled
Oct 30 04:24:44 localhost kernel: io scheduler noop registered
Oct 30 04:24:44 localhost kernel: io scheduler anticipatory registered
Oct 30 04:24:44 localhost kernel: io scheduler deadline registered
Oct 30 04:24:44 localhost kernel: io scheduler cfq registered
Oct 30 04:24:44 localhost kernel: RAMDISK driver initialized: 16 RAM  
disks of 8192K size 1024 blocksize
Oct 30 04:24:44 localhost kernel: NET: Registered protocol family 2
Oct 30 04:24:44 localhost kernel: IP: routing cache hash table of  
4096 buckets, 32Kbytes
Oct 30 04:24:44 localhost kernel: TCP established hash table entries:  
16384 (order: 5, 131072 bytes)
Oct 30 04:24:44 localhost kernel: TCP bind hash table entries: 16384  
(order: 4, 65536 bytes)
Oct 30 04:24:44 localhost kernel: TCP: Hash tables configured  
(established 16384 bind 16384)
Oct 30 04:24:44 localhost kernel: RAMDISK: cramfs filesystem found at  
block 0
Oct 30 04:24:44 localhost kernel: RAMDISK: Loading 4820KiB [1 disk]  
into ram disk... |^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/ 
^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H| 
^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H 
\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H- 
^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/ 
^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H| 
^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H 
\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H- 
^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/ 
^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H| 
^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H 
\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H- 
^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/ 
^H-^H\^H|^H/^H-^H\^H|^H/^Hdone.
Oct 30 04:24:44 localhost kernel: VFS: Mounted root (cramfs  
filesystem) readonly.
Oct 30 04:24:44 localhost kernel: Freeing unused kernel memory: 176k  
freed
Oct 30 04:24:44 localhost kernel: Capability LSM initialized
Oct 30 04:24:44 localhost kernel: NET: Registered protocol family 1
Oct 30 04:24:44 localhost kernel: raid5: measuring checksumming speed
Oct 30 04:24:44 localhost kernel:    8regs     :   980.000 MB/sec
Oct 30 04:24:44 localhost kernel:    8regs_prefetch:   824.000 MB/sec
Oct 30 04:24:44 localhost kernel:    32regs    :   668.000 MB/sec
Oct 30 04:24:44 localhost kernel:    32regs_prefetch:   596.000 MB/sec
Oct 30 04:24:44 localhost kernel:    pII_mmx   :  1744.000 MB/sec
Oct 30 04:24:44 localhost kernel:    p5_mmx    :  2328.000 MB/sec
Oct 30 04:24:44 localhost kernel: raid5: using function: p5_mmx  
(2328.000 MB/sec)
Oct 30 04:24:44 localhost kernel: md: md driver 0.90.1  
MAX_MD_DEVS=256, MD_SB_DISKS=27
Oct 30 04:24:44 localhost kernel: md: raid5 personality registered as  
nr 4
Oct 30 04:24:44 localhost kernel: SCSI subsystem initialized
Oct 30 04:24:44 localhost kernel: libata version 1.11 loaded.
Oct 30 04:24:44 localhost kernel: Uniform Multi-Platform E-IDE driver  
Revision: 7.00alpha2
Oct 30 04:24:44 localhost kernel: ide: Assuming 33MHz system bus  
speed for PIO modes; override with idebus=xx
Oct 30 04:24:44 localhost kernel: VP_IDE: IDE controller at PCI slot  
0000:00:07.1
Oct 30 04:24:44 localhost kernel: PCI: Via IRQ fixup for  
0000:00:07.1, from 255 to 0
Oct 30 04:24:44 localhost kernel: VP_IDE: chipset revision 16
Oct 30 04:24:44 localhost kernel: VP_IDE: not 100%% native mode: will  
probe irqs later
Oct 30 04:24:44 localhost kernel: VP_IDE: VIA vt82c686a (rev 22) IDE  
UDMA66 controller on pci0000:00:07.1
Oct 30 04:24:44 localhost kernel:     ide0: BM-DMA at 0xc000-0xc007,  
BIOS settings: hda:DMA, hdb:pio
Oct 30 04:24:44 localhost kernel: Probing IDE interface ide0...
Oct 30 04:24:44 localhost kernel: hda: ST3300831A, ATA DISK drive
Oct 30 04:24:44 localhost kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Oct 30 04:24:44 localhost kernel: PDC20268: IDE controller at PCI  
slot 0000:00:09.0
Oct 30 04:24:44 localhost kernel: PCI: Found IRQ 15 for device  
0000:00:09.0
Oct 30 04:24:44 localhost kernel: PCI: Sharing IRQ 15 with 0000:00:07.2
Oct 30 04:24:44 localhost kernel: PCI: Sharing IRQ 15 with 0000:00:07.3
Oct 30 04:24:44 localhost kernel: PDC20268: chipset revision 2
Oct 30 04:24:44 localhost kernel: PDC20268: 100%% native mode on irq 15
Oct 30 04:24:44 localhost kernel:     ide2: BM-DMA at 0xdc00-0xdc07,  
BIOS settings: hde:pio, hdf:pio
Oct 30 04:24:44 localhost kernel:     ide3: BM-DMA at 0xdc08-0xdc0f,  
BIOS settings: hdg:pio, hdh:pio
Oct 30 04:24:44 localhost kernel: Probing IDE interface ide2...
Oct 30 04:24:44 localhost kernel: hde: ST3300831A, ATA DISK drive
Oct 30 04:24:44 localhost kernel: ide2 at 0xcc00-0xcc07,0xd002 on irq 15
Oct 30 04:24:44 localhost kernel: Probing IDE interface ide3...
Oct 30 04:24:44 localhost kernel: hdg: ST3300831A, ATA DISK drive
Oct 30 04:24:44 localhost kernel: ide3 at 0xd400-0xd407,0xd802 on irq 15
Oct 30 04:24:44 localhost kernel: Probing IDE interface ide1...
Oct 30 04:24:44 localhost kernel: Probing IDE interface ide4...
Oct 30 04:24:44 localhost kernel: Probing IDE interface ide5...
Oct 30 04:24:44 localhost kernel: hda: max request size: 1024KiB
Oct 30 04:24:44 localhost kernel: hda: 586072368 sectors (300069 MB)  
w/8192KiB Cache, CHS=36481/255/63, UDMA(66)
Oct 30 04:24:44 localhost kernel: hda: cache flushes supported
Oct 30 04:24:44 localhost kernel:  /dev/ide/host0/bus0/target0/lun0:  
p1 p2 p3
Oct 30 04:24:44 localhost kernel: hde: max request size: 1024KiB
Oct 30 04:24:44 localhost kernel: hde: 586072368 sectors (300069 MB)  
w/8192KiB Cache, CHS=36481/255/63, UDMA(100)
Oct 30 04:24:44 localhost kernel: hde: cache flushes supported
Oct 30 04:24:44 localhost kernel:  /dev/ide/host2/bus0/target0/lun0:  
p1 p2 p3
Oct 30 04:24:44 localhost kernel: hdg: max request size: 1024KiB
Oct 30 04:24:44 localhost kernel: hdg: 586072368 sectors (300069 MB)  
w/8192KiB Cache, CHS=36481/255/63, UDMA(100)
Oct 30 04:24:44 localhost kernel: hdg: cache flushes supported
Oct 30 04:24:44 localhost kernel:  /dev/ide/host2/bus1/target0/lun0:  
p1 p2
Oct 30 04:24:44 localhost kernel: devfs_mk_dev: could not append to  
parent for md/1
Oct 30 04:24:44 localhost kernel: md: md1 stopped.
Oct 30 04:24:44 localhost kernel: md: bind<hdg2>
Oct 30 04:24:44 localhost kernel: md: bind<hda3>
Oct 30 04:24:44 localhost kernel: raid5: device hda3 operational as  
raid disk 0
Oct 30 04:24:44 localhost kernel: raid5: device hdg2 operational as  
raid disk 2
Oct 30 04:24:44 localhost kernel: raid5: allocated 3164kB for md1
Oct 30 04:24:44 localhost kernel: raid5: raid level 5 set md1 active  
with 2 out of 3 devices, algorithm 2
Oct 30 04:24:44 localhost kernel: RAID5 conf printout:
Oct 30 04:24:44 localhost kernel:  --- rd:3 wd:2 fd:1
Oct 30 04:24:44 localhost kernel:  disk 0, o:1, dev:hda3
Oct 30 04:24:44 localhost kernel:  disk 2, o:1, dev:hdg2
Oct 30 04:24:44 localhost kernel: kjournald starting.  Commit  
interval 5 seconds
Oct 30 04:24:44 localhost kernel: EXT3-fs: mounted filesystem with  
ordered data mode.
Oct 30 04:24:44 localhost kernel: Adding 192772k swap on /dev/hda2.   
Priority:-1 extents:1
Oct 30 04:24:44 localhost kernel: Unable to find swap-space signature
Oct 30 04:24:44 localhost kernel: Adding 240932k swap on /dev/hdg1.   
Priority:-2 extents:1
Oct 30 04:24:44 localhost kernel: EXT3 FS on md1, internal journal
Oct 30 04:24:44 localhost kernel: Generic RTC Driver v1.07
Oct 30 04:24:44 localhost kernel: device-mapper: 4.4.0-ioctl  
(2005-01-12) initialised: dm-devel@redhat.com
Oct 30 04:24:44 localhost kernel: devfs_mk_dev: could not append to  
parent for md/0
Oct 30 04:24:44 localhost kernel: md: md0 stopped.
Oct 30 04:24:44 localhost kernel: md: bind<hde1>
Oct 30 04:24:44 localhost kernel: md: bind<hda1>
Oct 30 04:24:44 localhost kernel: md: raid1 personality registered as  
nr 3
Oct 30 04:24:44 localhost kernel: raid1: raid set md0 active with 2  
out of 2 mirrors
Oct 30 04:24:44 localhost kernel: kjournald starting.  Commit  
interval 5 seconds
Oct 30 04:24:44 localhost kernel: EXT3 FS on md0, internal journal
Oct 30 04:24:44 localhost kernel: EXT3-fs: mounted filesystem with  
ordered data mode.
Oct 30 04:24:44 localhost kernel: Unable to find swap-space signature
Oct 30 04:24:44 localhost kernel: parport_pc: VIA 686A/8231 detected
Oct 30 04:24:44 localhost kernel: parport_pc: probing current  
configuration
Oct 30 04:24:44 localhost kernel: parport_pc: Current parallel port  
base: 0x0
Oct 30 04:24:44 localhost kernel: parport_pc: VIA parallel port  
disabled in BIOS
Oct 30 04:24:44 localhost kernel: PCI: Found IRQ 11 for device  
0000:00:0a.0
Oct 30 04:24:44 localhost kernel: 3c59x: Donald Becker and others.  
www.scyld.com/network/vortex.html
Oct 30 04:24:44 localhost kernel: 0000:00:0a.0: 3Com PCI 3c905B  
Cyclone 100baseTx at 0xe000. Vers LK1.1.19
Oct 30 04:24:44 localhost kernel: Creative EMU10K1 PCI Audio Driver,  
version 0.20a, 13:28:40 Sep 27 2005
Oct 30 04:24:44 localhost kernel: PCI: Found IRQ 10 for device  
0000:00:0c.0
Oct 30 04:24:44 localhost kernel: emu10k1: EMU10K1 rev 7 model 0x8027  
found, IO at 0xe400-0xe41f, IRQ 10
Oct 30 04:24:44 localhost kernel: ac97_codec: AC97  codec, id: TRA35  
(TriTech TR A5)
Oct 30 04:24:44 localhost kernel: usbcore: registered new driver usbfs
Oct 30 04:24:44 localhost kernel: usbcore: registered new driver hub
Oct 30 04:24:44 localhost kernel: USB Universal Host Controller  
Interface driver v2.2
Oct 30 04:24:44 localhost kernel: PCI: Found IRQ 15 for device  
0000:00:07.2
Oct 30 04:24:44 localhost kernel: PCI: Sharing IRQ 15 with 0000:00:07.3
Oct 30 04:24:44 localhost kernel: PCI: Sharing IRQ 15 with 0000:00:09.0
Oct 30 04:24:44 localhost kernel: uhci_hcd 0000:00:07.2: VIA  
Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
Oct 30 04:24:44 localhost kernel: uhci_hcd 0000:00:07.2: new USB bus  
registered, assigned bus number 1
Oct 30 04:24:44 localhost kernel: uhci_hcd 0000:00:07.2: irq 15, io  
base 0x0000c400
Oct 30 04:24:44 localhost kernel: hub 1-0:1.0: USB hub found
Oct 30 04:24:44 localhost kernel: hub 1-0:1.0: 2 ports detected
Oct 30 04:24:44 localhost kernel: PCI: Found IRQ 15 for device  
0000:00:07.3
Oct 30 04:24:44 localhost kernel: PCI: Sharing IRQ 15 with 0000:00:07.2
Oct 30 04:24:44 localhost kernel: PCI: Sharing IRQ 15 with 0000:00:09.0
Oct 30 04:24:44 localhost kernel: uhci_hcd 0000:00:07.3: VIA  
Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (#2)
Oct 30 04:24:44 localhost kernel: uhci_hcd 0000:00:07.3: new USB bus  
registered, assigned bus number 2
Oct 30 04:24:44 localhost kernel: uhci_hcd 0000:00:07.3: irq 15, io  
base 0x0000c800
Oct 30 04:24:44 localhost kernel: hub 2-0:1.0: USB hub found
Oct 30 04:24:44 localhost kernel: hub 2-0:1.0: 2 ports detected
Oct 30 04:24:44 localhost kernel: Linux agpgart interface v0.101 (c)  
Dave Jones
Oct 30 04:24:44 localhost kernel: agpgart: Detected VIA KX133 chipset
Oct 30 04:24:44 localhost kernel: agpgart: AGP aperture is 4M @  
0xdb000000
Oct 30 04:24:44 localhost kernel: pci_hotplug: PCI Hot Plug PCI Core  
version: 0.5
Oct 30 04:24:44 localhost kernel: shpchp: acpi_shpchprm:get_device  
PCI ROOT HID fail=0x1001
Oct 30 04:24:44 localhost kernel: Linux video capture interface: v1.00
Oct 30 04:24:44 localhost kernel: bttv: driver version 0.9.15 loaded
Oct 30 04:24:44 localhost kernel: bttv: using 8 buffers with 2080k  
(520 pages) each for capture
Oct 30 04:24:44 localhost kernel: bttv: Bt8xx card found (0).
Oct 30 04:24:44 localhost kernel: PCI: Found IRQ 12 for device  
0000:00:0b.0
Oct 30 04:24:44 localhost kernel: PCI: Sharing IRQ 12 with 0000:00:0b.1
Oct 30 04:24:44 localhost kernel: bttv0: Bt878 (rev 17) at 0000:00:0b. 
0, irq: 12, latency: 32, mmio: 0xdb405000
Oct 30 04:24:44 localhost kernel: bttv0: using:  *** UNKNOWN/GENERIC  
***  [card=0,autodetected]
Oct 30 04:24:44 localhost kernel: bttv0: gpio: en=00000000,  
out=00000000 in=003fffff [init]
Oct 30 04:24:44 localhost kernel: tveeprom(bttv internal): Huh, no  
eeprom present (err=-121)?
Oct 30 04:24:44 localhost kernel: bttv0: using tuner=-1
Oct 30 04:24:44 localhost kernel: bttv0: i2c: checking for MSP34xx @  
0x80... not found
Oct 30 04:24:44 localhost kernel: bttv0: i2c: checking for TDA9875 @  
0xb0... not found
Oct 30 04:24:44 localhost kernel: bttv0: i2c: checking for TDA7432 @  
0x8a... not found
Oct 30 04:24:44 localhost kernel: bttv0: i2c: checking for TDA9887 @  
0x86... not found
Oct 30 04:24:44 localhost kernel: bttv0: registered device video0
Oct 30 04:24:44 localhost kernel: bttv0: registered device vbi0
Oct 30 04:24:44 localhost kernel: bt878: AUDIO driver version 0.0.0  
loaded
Oct 30 04:24:44 localhost kernel: bt878: Bt878 AUDIO function found (0).
Oct 30 04:24:44 localhost kernel: PCI: Found IRQ 12 for device  
0000:00:0b.1
Oct 30 04:24:44 localhost kernel: PCI: Sharing IRQ 12 with 0000:00:0b.0
Oct 30 04:24:44 localhost kernel: bt878(0): Bt878 (rev 17) at 00:0b. 
1, irq: 12, latency: 32, memory: 0xdb406000
Oct 30 04:24:44 localhost kernel: btaudio: driver version 0.7 loaded  
[digital+analog]
Oct 30 04:24:44 localhost kernel: gameport: EMU10K1 is pci0000:00:0c. 
1/gameport0, io 0xe800, speed 1242kHz
Oct 30 04:24:44 localhost kernel: input: PC Speaker
Oct 30 04:24:44 localhost kernel: PCI: Found IRQ 11 for device  
0000:00:0a.0
Oct 30 04:24:44 localhost kernel: NET: Registered protocol family 17
Oct 30 04:24:44 localhost kernel: NET: Registered protocol family 10
Oct 30 04:24:44 localhost kernel: Disabled Privacy Extensions on  
device c032f880(lo)
Oct 30 04:24:44 localhost kernel: IPv6 over IPv4 tunneling driver
Oct 30 04:24:49 localhost kernel: eth0: no IPv6 routers present

And then I do yet another hotadd:

Oct 30 04:56:42 localhost kernel: md: bind<hde3>
Oct 30 04:56:42 localhost kernel: RAID5 conf printout:
Oct 30 04:56:42 localhost kernel:  --- rd:3 wd:2 fd:1
Oct 30 04:56:42 localhost kernel:  disk 0, o:1, dev:hda3
Oct 30 04:56:42 localhost kernel:  disk 1, o:1, dev:hde3
Oct 30 04:56:42 localhost kernel:  disk 2, o:1, dev:hdg2
Oct 30 04:56:42 localhost kernel: ..<6>md: syncing RAID array md1
Oct 30 04:56:42 localhost kernel: md: minimum _guaranteed_  
reconstruction speed: 1000 KB/sec/disc.
Oct 30 04:56:42 localhost kernel: md: using maximum available idle IO  
bandwith (but not more than 200000 KB/sec) for reconstruction.
Oct 30 04:56:42 localhost kernel: md: using 128k window, over a total  
of 292792576 blocks.

..and then it gets boring :-)


Regards, Troels



