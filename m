From: VanTo <vanto@ynet.sk>
Subject: mdrecoveryd oops
Date: Thu, 30 May 2002 03:54:44 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CF58664.8010803@ynet.sk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040503090405080706080903"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040503090405080706080903
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
when i use my raid5 array during background parity resync mdrecoveryd 
oopses. (sometimes it oopses even when nothing is going on).
Few times kswapd oopsed at the same point in [raid5]__find_stripe even 
when /dev/md0 shutdown cleanly.

My system is AMD athlon, Abit KT7raid, Promise 20267 ide controller.
I have reiserfs on LVM on /dev/md0 (raid5)
oops and more info in attachment.

Oh, btw
i noticed some kind of data corruption. Some blocks in file get shifted 
by 4 bytes when copied across filesystems on raid. It looks like only 
data written to one disk is corrupted (it can also be some ide problem i 
think). See h++p://shadow.host.sk/trouble/ and attachment for more info. 
(it's the same system). Can this be raid related or is it something 
under raid?

Thanks for anything

VanTo

--------------040503090405080706080903
Content-Type: text/plain; charset=us-ascii;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg"

LE=/boot/vmlinuz-2.4.19-pre8-ac2 console=ttyS0,19200 console=tty0
Local APIC disabled by BIOS -- reenabling.
Found and enabled local APIC!
Initializing CPU#0
Detected 1131.492 MHz processor.
Console: colour dummy device 80x25
Calibrating delay loop... 2254.43 BogoMIPS
Memory: 774032k/786368k available (1048k kernel code, 11952k reserved, 293k data, 252k init, 0k highmem)
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount cache hash table entries: 16384 (order: 5, 131072 bytes)
Buffer cache hash table entries: 65536 (order: 6, 262144 bytes)
Page-cache hash table entries: 262144 (order: 8, 1048576 bytes)
CPU: Before vendor init, caps: 0183fbff c1c7fbff 00000000, vendor = 2
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After vendor init, caps: 0183fbff c1c7fbff 00000000 00000000
CPU:     After generic, caps: 0183fbff c1c7fbff 00000000 00000000
CPU:             Common caps: 0183fbff c1c7fbff 00000000 00000000
CPU: AMD Athlon(tm) Processor stepping 02
Enabling fast FPU save and restore... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
enabled ExtINT on CPU#0
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Using local APIC timer interrupts.
calibrating APIC timer ...
..... CPU clock speed is 1131.4764 MHz.
..... host bus clock speed is 266.2296 MHz.
cpu: 0, clocks: 2662296, slice: 1331148
CPU0<T0:2662288,T1:1331136,D:4,S:1331148,C:2662296>
mtrr: v1.40 (20010327) Richard Gooch (rgooch@atnf.csiro.au)
mtrr: detected mtrr type: Intel
PCI: PCI BIOS revision 2.10 entry at 0xfb430, last bus=1
PCI: Using configuration type 1
PCI: Probing PCI hardware
Unknown bridge resource 0: assuming transparent
Unknown bridge resource 2: assuming transparent
PCI: Using IRQ router VIA [1106/0686] at 00:07.0
Applying VIA southbridge workaround.
PCI: Disabling Via external APIC routing
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16)
Starting kswapd
VFS: Diskquotas version dquot_6.5.0 initialized
Journalled Block Device driver loaded
vesafb: framebuffer at 0xd4000000, mapped to 0xf0800000, size 4096k
vesafb: mode is 800x600x8, linelength=800, pages=15
vesafb: protected mode interface info at c000:5b8f
vesafb: scrolling: redraw
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
Detected PS/2 Mouse Port.
pty: 2048 Unix98 ptys configured
Serial driver version 5.05c (2001-07-08) with MANY_PORTS MULTIPORT SHARE_IRQ SERIAL_PCI ISAPNP enabled
ttyS00 at 0x03f8 (irq = 4) is a 16550A
ttyS01 at 0x02f8 (irq = 3) is a 16550A
Real Time Clock Driver v1.10e
block: 1024 slots per queue, batch=256
Uniform Multi-Platform E-IDE driver Revision: 6.31
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller on PCI bus 00 dev 39
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci00:07.1
    ide0: BM-DMA at 0xc000-0xc007, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xc008-0xc00f, BIOS settings: hdc:DMA, hdd:pio
PDC20267: IDE controller on PCI bus 00 dev 88
PCI: Found IRQ 11 for device 00:11.0
PDC20267: chipset revision 2
PDC20267: not 100% native mode: will probe irqs later
PDC20267: (U)DMA Burst Bit ENABLED Primary MASTER Mode Secondary MASTER Mode.
    ide2: BM-DMA at 0xe000-0xe007, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0xe008-0xe00f, BIOS settings: hdg:pio, hdh:pio
hda: QUANTUM FIREBALLP AS10.2, ATA DISK drive
hdc: MAXTOR 6L060J3, ATA DISK drive
hde: Maxtor 5T060H6, ATA DISK drive
hdg: Maxtor 5T060H6, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide2 at 0xd000-0xd007,0xd402 on irq 11
ide3 at 0xd800-0xd807,0xdc02 on irq 11
hda: 20066251 sectors (10274 MB) w/1902KiB Cache, CHS=1249/255/63, UDMA(100)
hdc: 117266688 sectors (60041 MB) w/1819KiB Cache, CHS=116336/16/63, UDMA(100)
hde: 120103200 sectors (61493 MB) w/2048KiB Cache, CHS=119150/16/63, UDMA(100)
hdg: 120103200 sectors (61493 MB) w/2048KiB Cache, CHS=119150/16/63, UDMA(100)
ide-floppy driver 0.99.newide
Partition check:
 hda: hda1 hda2 hda3 < hda5 hda6 hda7 >
 hdc: hdc1
 hde: hde1
 hdg: hdg1
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
ide-floppy driver 0.99.newide
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 8192 buckets, 64Kbytes
TCP: Hash tables configured (established 262144 bind 65536)
Linux IP multicast router 0.06 plus PIM-SM
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 252k freed
Adding Swap: 1052216k swap-space (priority -1)
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,2), internal journal
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
 [events: 0000005c]
 [events: 0000005c]
 [events: 0000005c]
md: autorun ...
md: considering hdg1 ...
md:  adding hdg1 ...
md:  adding hde1 ...
md:  adding hdc1 ...
md: created md0
md: bind<hdc1,1>
md: bind<hde1,2>
md: bind<hdg1,3>
md: running: <hdg1><hde1><hdc1>
md: hdg1's event counter: 0000005c
md: hde1's event counter: 0000005c
md: hdc1's event counter: 0000005c
md: md0: raid array is not clean -- starting background reconstruction
raid5: measuring checksumming speed
   8regs     :  1729.600 MB/sec
   32regs    :  1089.600 MB/sec
   pII_mmx   :  2654.000 MB/sec
   p5_mmx    :  3395.600 MB/sec
raid5: using function: p5_mmx (3395.600 MB/sec)
md: raid5 personality registered as nr 4
md0: max total readahead window set to 496k
md0: 2 data-disks, max readahead per data-disk: 248k
raid5: spare disk hdg1
raid5: device hde1 operational as raid disk 2
raid5: device hdc1 operational as raid disk 0
raid5: md0, not all disks are operational -- trying to recover array
raid5: allocated 3291kB for md0
raid5: raid level 5 set md0 active with 2 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hdc1
 disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hde1
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hdc1
 disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hde1
md: updating md0 RAID superblock on device
md: hdg1 [events: 0000005d]<6>(write) hdg1's sb offset: 60051456
md: recovery thread got woken up ...
md0: resyncing spare disk hdg1 to replace failed disk
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hdc1
 disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hde1
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hdc1
 disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hde1
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 100000 KB/sec) for reconstruction.
md: using 124k window, over a total of 58633216 blocks.
md: hde1 [events: 0000005d]<6>(write) hde1's sb offset: 60051456
spurious 8259A interrupt: IRQ7.
md: hdc1 [events: 0000005d]<6>(write) hdc1's sb offset: 58633216
md: ... autorun DONE.
LVM version 1.0.3(19/02/2002) module loaded
raid5: switching cache buffer size, 4096 --> 1024
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: busy buffer
invalidate: dirty buffer
invalidate: busy buffer
invalidate: dirty buffer
invalidate: busy buffer
invalidate: dirty buffer
invalidate: busy buffer
invalidate: dirty buffer
invalidate: busy buffer
invalidate: dirty buffer
invalidate: busy buffer
invalidate: dirty buffer
invalidate: busy buffer
invalidate: dirty buffer
invalidate: busy buffer
invalidate: dirty buffer
invalidate: busy buffer
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,6), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,5), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,7), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
raid5: switching cache buffer size, 1024 --> 4096
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on lvm(58,2), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
reiserfs: Unrecognized mount option usrquota
raid5: switching cache buffer size, 4096 --> 1024
raid5: switching cache buffer size, 1024 --> 4096
reiserfs: checking transaction log (device 3a:01) ...
Using r5 hash to sort names
ReiserFS version 3.6.25
ip_tables: (C) 2000-2002 Netfilter core team
ip_conntrack (6143 buckets, 49144 max)
PCI: Found IRQ 10 for device 00:0d.0
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
00:0d.0: 3Com PCI 3c905C Tornado at 0xcc00. Vers LK1.1.17
phy=0, phyx=24, mii_status=0x7809
i2c-core.o: i2c core module version 2.6.3 (20020322)
i2c-viapro.o version 2.6.3 (20020322)
i2c-viapro.o: Found Via VT82C686A/B device
i2c-viapro.o: Via Pro SMBus detected and initialized
i2c-isa.o version 2.6.3 (20020322)
i2c-isa.o: ISA bus access for i2c modules initialized.
i2c-proc.o version 2.6.3 (20020322)
adm1021.o version 2.6.3 (20020322)
via686a.o version 2.6.3 (20020322)
loop: loaded (max 128 devices)
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 1
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 1
ISO 9660 Extensions: RRIP_1991A
raid5: switching cache buffer size, 4096 --> 1024
raid5: switching cache buffer size, 1024 --> 4096
reiserfs: checking transaction log (device 3a:00) ...
Using r5 hash to sort names
ReiserFS version 3.6.25
eth0: Setting full-duplex based on MII #24 link partner capability of 05e1.
Unable to handle kernel paging request at virtual address bfffc003
 printing eip:
f0c96191
*pde = 2d1ea067
*pte = 00000000
Oops: 0002
CPU:    0
EIP:    0010:[<f0c96191>]    Not tainted
EFLAGS: 00010086
eax: bfffbfff   ebx: ef74e400   ecx: ee3d4000   edx: ee7a0ff8
esi: ee3d4000   edi: ef74e400   ebp: 045c47d8   esp: ee6ffe4c
ds: 0018   es: 0018   ss: 0018
Process mdrecoveryd (pid: 102, stackpage=ee6ff000)
Stack: f0c961e0 ee3d4000 00000000 00000000 f0c96611 ef74e400 00000000 00000000 
       00000000 ee6fe000 00000000 00000000 00000000 00000000 00000000 00000000 
       00000286 00000000 045c47d0 ef74e400 00000010 045c47d8 f0c98712 ef74e400 
Call Trace: [<f0c961e0>] [<f0c96611>] [<f0c98712>] [<f0c880a8>] [<f0c883ad>] 
   [<f0c8aeb0>] [<f0c87427>] [<c0106fa6>] [<f0c87340>] [<f0c8ff28>] 

Code: 89 50 04 8b 51 04 8b 01 89 02 c7 41 04 00 00 00 00 c3 8d b6 
 <1>Unable to handle kernel paging request at virtual address 6f74639c
 printing eip:
f0c963a0
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<f0c963a0>]    Not tainted
EFLAGS: 00010006
eax: 6f74616c   ebx: 000003fe   ecx: 011c7ff0   edx: 00000000
esi: 00001000   edi: 00000000   ebp: cc5998c0   esp: cc263d70
ds: 0018   es: 0018   ss: 0018
Process pine (pid: 7438, stackpage=cc263000)
Stack: ee7a0000 00001000 f0c965f1 ef74e400 011c7ff0 00000000 00000000 00000000 
       cc262000 00000082 00000003 ef74e400 ee6c3c00 00000010 00000000 ef74e400 
       00000000 ef74e400 00000000 00000000 cc5998c0 f0c985f1 ef74e400 011c7ff0 
Call Trace: [<f0c965f1>] [<f0c985f1>] [<f0c83198>] [<f0c9d8cd>] [<c018f00e>] 
   [<c018f076>] [<c013988c>] [<c012977d>] [<c0129817>] [<f0cbf460>] [<c0129ee7>] 
   [<c012a122>] [<c012a69a>] [<c012a5a0>] [<c0136f65>] [<c0136cf0>] [<c0136dde>] 
   [<c0108763>] 

Code: 39 88 30 02 00 00 74 08 8b 00 85 c0 75 f2 31 c0 59 5b c3 8d 
 <1>Unable to handle kernel paging request at virtual address 6f74639c
 printing eip:
f0c963a0
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<f0c963a0>]    Not tainted
EFLAGS: 00010006
eax: 6f74616c   ebx: 000003fe   ecx: 011c7ff0   edx: 00000000
esi: 00001000   edi: 00000000   ebp: e4f85dc0   esp: cbc53d70
ds: 0018   es: 0018   ss: 0018
Process pine (pid: 7643, stackpage=cbc53000)
Stack: ee7a0000 00001000 f0c965f1 ef74e400 011c7ff0 00000000 00000000 00000000 
       cbc52000 00000000 00000000 00000000 00000000 00000010 00000000 ef74e400 
       00000000 ef74e400 00000000 00000000 e4f85dc0 f0c985f1 ef74e400 011c7ff0 
Call Trace: [<f0c965f1>] [<f0c985f1>] [<f0c83198>] [<f0c9d8cd>] [<c018f00e>] 
   [<c018f076>] [<c013988c>] [<c012977d>] [<c0129817>] [<f0cbf460>] [<c0129ee7>] 
   [<c012a1f2>] [<c01b4b10>] [<c012a69a>] [<c012a5a0>] [<c0136f65>] [<c0136cf0>] 
   [<c0136dde>] [<c0108763>] 

Code: 39 88 30 02 00 00 74 08 8b 00 85 c0 75 f2 31 c0 59 5b c3 8d 
 

--------------040503090405080706080903
Content-Type: text/plain; charset=us-ascii;
 name="ioports"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ioports"

0000-001f : dma1
0020-003f : pic1
0040-005f : timer
0060-006f : keyboard
0070-007f : rtc
0080-008f : dma page reg
00a0-00bf : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : ide1
01f0-01f7 : ide0
02f8-02ff : serial(auto)
0376-0376 : ide1
03c0-03df : vesafb
03f6-03f6 : ide0
03f8-03ff : serial(auto)
0cf8-0cff : PCI conf1
5000-500f : VIA Technologies, Inc. VT82C686 [Apollo Super ACPI]
  5000-5007 : viapro-smbus
6000-607f : VIA Technologies, Inc. VT82C686 [Apollo Super ACPI]
  6000-607f : via686a-sensors
c000-c00f : VIA Technologies, Inc. Bus Master IDE
  c000-c007 : ide0
  c008-c00f : ide1
cc00-cc7f : 3Com Corporation 3c905C-TX/TX-M [Tornado]
  cc00-cc7f : 00:0d.0
d000-d007 : Promise Technology, Inc. 20267
  d000-d007 : ide2
d400-d403 : Promise Technology, Inc. 20267
  d402-d402 : ide2
d800-d807 : Promise Technology, Inc. 20267
  d800-d807 : ide3
dc00-dc03 : Promise Technology, Inc. 20267
  dc02-dc02 : ide3
e000-e03f : Promise Technology, Inc. 20267
  e000-e007 : ide2
  e008-e00f : ide3
  e010-e03f : PDC20267

--------------040503090405080706080903
Content-Type: text/plain; charset=us-ascii;
 name="lsmod"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lsmod"

Module                  Size  Used by    Not tainted
nls_iso8859-1           2880  13  (autoclean)
isofs                  24928  14  (autoclean)
zlib_inflate           18912   0  (autoclean) [isofs]
loop                    8208  42  (autoclean)
via686a                 8004   0  (unused)
adm1021                 5248   0  (unused)
i2c-proc                6368   0  [via686a adm1021]
i2c-isa                 1252   0  (unused)
i2c-viapro              3912   0  (unused)
i2c-core               14048   0  [via686a adm1021 i2c-proc i2c-isa i2c-viapro]
3c59x                  24968   1  (autoclean)
ipt_REJECT              2816   1  (autoclean)
ipt_state                576   1  (autoclean)
ip_conntrack           13804   1  (autoclean) [ipt_state]
ipt_LOG                 3360   1  (autoclean)
iptable_filter          1696   1  (autoclean)
ip_tables              10880   4  [ipt_REJECT ipt_state ipt_LOG iptable_filter]
reiserfs              164960   2  (autoclean)
lvm-mod                59360   7 
raid5                  17472   1  (autoclean)
xor                     8804   0  (autoclean) [raid5]
md                     57216   2  [raid5]

--------------040503090405080706080903
Content-Type: text/plain; charset=us-ascii;
 name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci"

00:00.0 Host bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133] (rev 03)
	Subsystem: ABIT Computer Corp.: Unknown device a401
	Flags: bus master, medium devsel, latency 0
	Memory at d0000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [a0] AGP version 2.0
	Capabilities: [c0] Power Management version 2

00:01.0 PCI bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133 AGP] (prog-if 00 [Normal decode])
	Flags: bus master, 66Mhz, medium devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	Memory behind bridge: d4000000-dbffffff

00:07.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super South] (rev 40)
	Subsystem: VIA Technologies, Inc. VT82C686/A PCI to ISA Bridge
	Flags: bus master, stepping, medium devsel, latency 0
	Capabilities: [c0] Power Management version 2

00:07.1 IDE interface: VIA Technologies, Inc. Bus Master IDE (rev 06) (prog-if 8a [Master SecP PriP])
	Flags: bus master, medium devsel, latency 32
	I/O ports at c000 [size=16]
	Capabilities: [c0] Power Management version 2

00:07.4 Host bridge: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 40)
	Flags: medium devsel, IRQ 12
	Capabilities: [68] Power Management version 2

00:0d.0 Ethernet controller: 3Com Corporation 3c905C-TX [Fast Etherlink] (rev 74)
	Subsystem: 3Com Corporation 3C905C-TX Fast Etherlink for PC Management NIC
	Flags: bus master, medium devsel, latency 32, IRQ 10
	I/O ports at cc00 [size=128]
	Memory at dd020000 (32-bit, non-prefetchable) [size=128]
	Expansion ROM at <unassigned> [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2

00:11.0 RAID bus controller: Promise Technology, Inc. 20267 (rev 02)
	Subsystem: Promise Technology, Inc.: Unknown device 4d39
	Flags: bus master, medium devsel, latency 32, IRQ 11
	I/O ports at d000 [size=8]
	I/O ports at d400 [size=4]
	I/O ports at d800 [size=8]
	I/O ports at dc00 [size=4]
	I/O ports at e000 [size=64]
	Memory at dd000000 (32-bit, non-prefetchable) [size=128K]
	Expansion ROM at <unassigned> [disabled] [size=64K]
	Capabilities: [58] Power Management version 1

01:00.0 VGA compatible controller: S3 Inc. 86c368 [Trio 3D/2X] (rev 02) (prog-if 00 [VGA])
	Subsystem: S3 Inc. Trio3D/2X
	Flags: bus master, medium devsel, latency 32
	Memory at d4000000 (32-bit, non-prefetchable) [size=64M]
	Expansion ROM at <unassigned> [disabled] [size=64K]
	Capabilities: [dc] Power Management version 1
	Capabilities: [80] AGP version 1.0


--------------040503090405080706080903
Content-Type: text/plain; charset=us-ascii;
 name="raidtab"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raidtab"

raiddev /dev/md0
     raid-level			5
     nr-raid-disks		3
     persistent-superblock	1
     chunk-size			8
     parity-algorithm		left-symmetric
     nr-spare-disks		0
     device			/dev/hdc1
     raid-disk			0
     device			/dev/hdg1
     raid-disk			1
     device			/dev/hde1
     raid-disk			2

--------------040503090405080706080903
Content-Type: text/plain; charset=us-ascii;
 name="oops"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oops"

ksymoops 2.4.5 on i686 2.4.19-pre8-ac2.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.4.19-pre8-ac2/ (default)
     -m /boot/System.map-2.4.19-pre8-ac2 (specified)

cpu: 0, clocks: 2662296, slice: 1331148
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
Unable to handle kernel paging request at virtual address bfffc003
f0c96191
*pde = 2d1ea067
Oops: 0002
CPU:    0
EIP:    0010:[<f0c96191>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010086
eax: bfffbfff   ebx: ef74e400   ecx: ee3d4000   edx: ee7a0ff8
esi: ee3d4000   edi: ef74e400   ebp: 045c47d8   esp: ee6ffe4c
ds: 0018   es: 0018   ss: 0018
Process mdrecoveryd (pid: 102, stackpage=ee6ff000)
Stack: f0c961e0 ee3d4000 00000000 00000000 f0c96611 ef74e400 00000000 00000000 
       00000000 ee6fe000 00000000 00000000 00000000 00000000 00000000 00000000 
       00000286 00000000 045c47d0 ef74e400 00000010 045c47d8 f0c98712 ef74e400 
Call Trace: [<f0c961e0>] [<f0c96611>] [<f0c98712>] [<f0c880a8>] [<f0c883ad>] 
   [<f0c8aeb0>] [<f0c87427>] [<c0106fa6>] [<f0c87340>] [<f0c8ff28>] 
Code: 89 50 04 8b 51 04 8b 01 89 02 c7 41 04 00 00 00 00 c3 8d b6 


>>EIP; f0c96191 <[raid5]remove_hash+11/30>   <=====

>>eax; bfffbfff Before first symbol
>>ebx; ef74e400 <_end+2f47222c/309a6e2c>
>>ecx; ee3d4000 <_end+2e0f7e2c/309a6e2c>
>>edx; ee7a0ff8 <_end+2e4c4e24/309a6e2c>
>>esi; ee3d4000 <_end+2e0f7e2c/309a6e2c>
>>edi; ef74e400 <_end+2f47222c/309a6e2c>
>>ebp; 045c47d8 Before first symbol
>>esp; ee6ffe4c <_end+2e423c78/309a6e2c>

Trace; f0c961e0 <[raid5]get_free_stripe+30/40>
Trace; f0c96611 <[raid5]get_active_stripe+251/530>
Trace; f0c98712 <[raid5]raid5_sync_request+42/d0>
Trace; f0c880a8 <[md]md_do_sync+1c8/3e0>
Trace; f0c883ad <[md]md_do_recovery+ed/230>
Trace; f0c8aeb0 <[md]all_mddevs+0/8>
Trace; f0c87427 <[md]md_thread+e7/130>
Trace; c0106fa6 <kernel_thread+26/30>
Trace; f0c87340 <[md]md_thread+0/130>
Trace; f0c8ff28 <[md]pers+8/20>

Code;  f0c96191 <[raid5]remove_hash+11/30>
00000000 <_EIP>:
Code;  f0c96191 <[raid5]remove_hash+11/30>   <=====
   0:   89 50 04                  mov    %edx,0x4(%eax)   <=====
Code;  f0c96194 <[raid5]remove_hash+14/30>
   3:   8b 51 04                  mov    0x4(%ecx),%edx
Code;  f0c96197 <[raid5]remove_hash+17/30>
   6:   8b 01                     mov    (%ecx),%eax
Code;  f0c96199 <[raid5]remove_hash+19/30>
   8:   89 02                     mov    %eax,(%edx)
Code;  f0c9619b <[raid5]remove_hash+1b/30>
   a:   c7 41 04 00 00 00 00      movl   $0x0,0x4(%ecx)
Code;  f0c961a2 <[raid5]remove_hash+22/30>
  11:   c3                        ret    
Code;  f0c961a3 <[raid5]remove_hash+23/30>
  12:   8d b6 00 00 00 00         lea    0x0(%esi),%esi

 <1>Unable to handle kernel paging request at virtual address 6f74639c
f0c963a0
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<f0c963a0>]    Not tainted
EFLAGS: 00010006
eax: 6f74616c   ebx: 000003fe   ecx: 011c7ff0   edx: 00000000
esi: 00001000   edi: 00000000   ebp: cc5998c0   esp: cc263d70
ds: 0018   es: 0018   ss: 0018
Process pine (pid: 7438, stackpage=cc263000)
Stack: ee7a0000 00001000 f0c965f1 ef74e400 011c7ff0 00000000 00000000 00000000 
       cc262000 00000082 00000003 ef74e400 ee6c3c00 00000010 00000000 ef74e400 
       00000000 ef74e400 00000000 00000000 cc5998c0 f0c985f1 ef74e400 011c7ff0 
Call Trace: [<f0c965f1>] [<f0c985f1>] [<f0c83198>] [<f0c9d8cd>] [<c018f00e>] 
   [<c018f076>] [<c013988c>] [<c012977d>] [<c0129817>] [<f0cbf460>] [<c0129ee7>] 
   [<c012a122>] [<c012a69a>] [<c012a5a0>] [<c0136f65>] [<c0136cf0>] [<c0136dde>] 
   [<c0108763>] 
Code: 39 88 30 02 00 00 74 08 8b 00 85 c0 75 f2 31 c0 59 5b c3 8d 


>>EIP; f0c963a0 <[raid5]__find_stripe+40/60>   <=====

>>eax; 6f74616c Before first symbol
>>ecx; 011c7ff0 Before first symbol
>>esi; 00001000 Before first symbol
>>ebp; cc5998c0 <_end+c2bd6ec/309a6e2c>
>>esp; cc263d70 <_end+bf87b9c/309a6e2c>

Trace; f0c965f1 <[raid5]get_active_stripe+231/530>
Trace; f0c985f1 <[raid5]raid5_make_request+51/100>
Trace; f0c83198 <[md]__kstrtab_md_print_devices+7/1b>
Trace; f0c9d8cd <[lvm-mod]lvm_make_request_fn+d/20>
Trace; c018f00e <generic_make_request+13e/160>
Trace; c018f076 <submit_bh+46/60>
Trace; c013988c <block_read_full_page+21c/230>
Trace; c012977d <add_to_page_cache_unique+6d/80>
Trace; c0129817 <page_cache_read+87/b0>
Trace; f0cbf460 <[reiserfs]reiserfs_get_block+0/de0>
Trace; c0129ee7 <generic_file_readahead+117/160>
Trace; c012a122 <do_generic_file_read+1f2/490>
Trace; c012a69a <generic_file_read+7a/130>
Trace; c012a5a0 <file_read_actor+0/80>
Trace; c0136f65 <sys_read+95/f0>
Trace; c0136cf0 <default_llseek+0/80>
Trace; c0136dde <sys_lseek+6e/80>
Trace; c0108763 <system_call+33/38>

Code;  f0c963a0 <[raid5]__find_stripe+40/60>
00000000 <_EIP>:
Code;  f0c963a0 <[raid5]__find_stripe+40/60>   <=====
   0:   39 88 30 02 00 00         cmp    %ecx,0x230(%eax)   <=====
Code;  f0c963a6 <[raid5]__find_stripe+46/60>
   6:   74 08                     je     10 <_EIP+0x10> f0c963b0 <[raid5]__find_stripe+50/60>
Code;  f0c963a8 <[raid5]__find_stripe+48/60>
   8:   8b 00                     mov    (%eax),%eax
Code;  f0c963aa <[raid5]__find_stripe+4a/60>
   a:   85 c0                     test   %eax,%eax
Code;  f0c963ac <[raid5]__find_stripe+4c/60>
   c:   75 f2                     jne    0 <_EIP>
Code;  f0c963ae <[raid5]__find_stripe+4e/60>
   e:   31 c0                     xor    %eax,%eax
Code;  f0c963b0 <[raid5]__find_stripe+50/60>
  10:   59                        pop    %ecx
Code;  f0c963b1 <[raid5]__find_stripe+51/60>
  11:   5b                        pop    %ebx
Code;  f0c963b2 <[raid5]__find_stripe+52/60>
  12:   c3                        ret    
Code;  f0c963b3 <[raid5]__find_stripe+53/60>
  13:   8d 00                     lea    (%eax),%eax


--------------040503090405080706080903
Content-Type: text/plain; charset=us-ascii;
 name="lvmvginfo"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lvmvginfo"

vgdisplay
--- Volume group ---
VG Name               data
VG Access             read/write
VG Status             available/resizable
VG #                  0
MAX LV                256
Cur LV                3
Open LV               3
MAX LV Size           1 TB
Max PV                256
Cur PV                1
Act PV                1
VG Size               111.81 GB
PE Size               64 MB
Total PE              1789
Alloc PE / Size       1789 / 111.81 GB
Free  PE / Size       0 / 0
VG UUID               0dexiG-4TyR-CyJl-KtWx-dfYi-8J8B-3rUmuG

--- Logical volume ---
LV Name                /dev/data/home
VG Name                data
LV Write Access        read/write
LV Status              available
LV #                   1
# open                 1
LV Size                32 GB
Current LE             512
Allocated LE           512
Allocation             next free
Read ahead sectors     120
Block device           58:0

--- Logical volume ---
LV Name                /dev/data/export
VG Name                data
LV Write Access        read/write
LV Status              available
LV #                   2
# open                 1
LV Size                75 GB
Current LE             1200
Allocated LE           1200
Allocation             next free
Read ahead sectors     120
Block device           58:1

--- Logical volume ---
LV Name                /dev/data/opt
VG Name                data
LV Write Access        read/write
LV Status              available
LV #                   3
# open                 1
LV Size                4.81 GB
Current LE             77
Allocated LE           77
Allocation             next free
Read ahead sectors     120
Block device           58:2


--- Physical volumes ---
PV Name (#)           /dev/md0 (1)
PV Status             available / allocatable
Total PE / Free PE    1789 / 0




--------------040503090405080706080903--

