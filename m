From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid5 trouble
Date: Wed, 17 Oct 2007 18:07:37 +0200
Message-ID: <47163349.8090109@systella.fr>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr> <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090100070606060800080109"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090100070606060800080109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Dan Williams wrote:
> On 10/17/07, BERTRAND Joël <joel.bertrand@systella.fr> wrote:
>> BERTRAND Joël wrote:
>>>     Hello,
>>>
>>>     I run 2.6.23 linux kernel on two T1000 (sparc64) servers. Each
>>> server has a partitionable raid5 array (/dev/md/d0) and I have to
>>> synchronize both raid5 volumes by raid1. Thus, I have tried to build a
>>> raid1 volume between /dev/md/d0p1 and /dev/sdi1 (exported by iscsi from
>>> the second server) and I obtain a BUG :
>>>
>>> Root gershwin:[/usr/scripts] > mdadm -C /dev/md7 -l1 -n2 /dev/md/d0p1
>>> /dev/sdi1
>>> ...
>>         Hello,
>>
>>         I have fixed iscsi-target, and I have tested it. It works now without
>> any trouble. Patches were posted on iscsi-target mailing list. When I
>> use iSCSI to access to foreign raid5 volume, it works fine. I can format
>> foreign volume, copy large files on it... But when I tried to create a
>> new raid1 volume with a local raid5 volume and a foreign raid5 volume, I
>> receive my well known Oops. You can find my dmesg after Oops :
>>

	Your patch does not work for me. It was applied, new kernel was built, 
and I obtain the same Oops.

> Can you send your .config and your bootup dmesg?

	Yes, of course ;-) Both files are attached. My new Oops is :

kernel BUG at drivers/md/raid5.c:380!
               \|/ ____ \|/
               "@'/ .. \`@"
               /_| \__/ |_\
                  \__U_/
md7_resync(4258): Kernel bad sw trap 5 [#1]
TSTATE: 0000000080001606 TPC: 00000000005ed50c TNPC: 00000000005ed510 Y: 
00000000    Not tainted
TPC: <get_stripe_work+0x1f4/0x200>

(exactly the same than the old one ;-) ). I have patched iscsi-target to 
avoid alignement bug on sparc64. Do you think a bug in ietd can produced 
this kind of bug ? Patch I have written for iscsi-target (against SVN) 
is attached too.

	Regards,

	JKB

--------------090100070606060800080109
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg"

PROMLIB: Sun IEEE Boot Prom 'OBP 4.23.4 2006/08/04 20:45'
PROMLIB: Root node compatible: sun4v
Linux version 2.6.23 (root@gershwin) (gcc version 4.1.3 20070831 (prerelease) (Debian 4.1.2-16)) #7 SMP Wed Oct 17 17:52:22 CEST 2007
ARCH: SUN4V
Ethernet address: 00:14:4f:6f:59:fe
OF stdout device is: /virtual-devices@100/console@1
PROM: Built device tree with 74930 bytes of memory.
MDESC: Size is 32560 bytes.
PLATFORM: banner-name [Sun Fire(TM) T1000]
PLATFORM: name [SUNW,Sun-Fire-T1000]
PLATFORM: hostid [846f59fe]
PLATFORM: serial# [00ab4130]
PLATFORM: stick-frequency [3b9aca00]
PLATFORM: mac-address [144f6f59fe]
PLATFORM: watchdog-resolution [1000 ms]
PLATFORM: watchdog-max-timeout [31536000000 ms]
On node 0 totalpages: 522246
  Normal zone: 3583 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 518663 pages, LIFO batch:15
  Movable zone: 0 pages used for memmap
Built 1 zonelists in Zone order.  Total pages: 518663
Kernel command line: root=/dev/md0 ro md=0,/dev/sda4,/dev/sdb4 raid=noautodetect
md: Will configure md0 (super-block) from /dev/sda4,/dev/sdb4, below.
PID hash table entries: 4096 (order: 12, 32768 bytes)
clocksource: mult[10000] shift[16]
clockevent: mult[80000000] shift[31]
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
Memory: 4138072k available (2608k kernel code, 960k data, 144k init) [fffff80000000000,00000000fffc8000]
SLUB: Genslabs=23, HWalign=32, Order=0-2, MinObjects=8, CPUs=32, Nodes=1
Calibrating delay using timer specific routine.. 1995.16 BogoMIPS (lpj=3990330)
Mount-cache hash table entries: 512
Brought up 24 CPUs
xor: automatically using best checksumming function: Niagara
   Niagara   :   240.000 MB/sec
xor: using function: Niagara (240.000 MB/sec)
NET: Registered protocol family 16
PCI: Probing for controllers.
SUN4V_PCI: Registered hvapi major[1] minor[0]
/pci@780: SUN4V PCI Bus Module
/pci@780: PCI IO[e810000000] MEM[ea00000000]
/pci@7c0: SUN4V PCI Bus Module
/pci@7c0: PCI IO[f010000000] MEM[f200000000]
PCI: Scanning PBM /pci@7c0
PCI: Scanning PBM /pci@780
ebus: No EBus's found.
SCSI subsystem initialized
NET: Registered protocol family 2
Time: stick clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 20
Switched to high resolution mode on CPU 8
Switched to high resolution mode on CPU 21
Switched to high resolution mode on CPU 9
Switched to high resolution mode on CPU 22
Switched to high resolution mode on CPU 10
Switched to high resolution mode on CPU 23
Switched to high resolution mode on CPU 11
Switched to high resolution mode on CPU 12
Switched to high resolution mode on CPU 13
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 14
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 15
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 16
Switched to high resolution mode on CPU 4
Switched to high resolution mode on CPU 17
Switched to high resolution mode on CPU 5
Switched to high resolution mode on CPU 18
Switched to high resolution mode on CPU 6
Switched to high resolution mode on CPU 19
Switched to high resolution mode on CPU 7
IP route cache hash table entries: 131072 (order: 7, 1048576 bytes)
TCP established hash table entries: 262144 (order: 9, 6291456 bytes)
TCP bind hash table entries: 65536 (order: 7, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Mini RTC Driver
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 8192 bytes)
async_tx: api initialized (async)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
f026e2b0: ttyS0 at I/O 0x0 (irq = 1) is a SUN4V HCONS
console [ttyHV0] enabled
tg3.c:v3.81 (September 5, 2007)
PCI: Enabling device: (0001:03:04.0), cmd 2
eth0: Tigon3 [partno(BCM95714) rev 9001 PHY(5714)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:14:4f:6f:59:fe
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76148000] dma_mask[32-bit]
PCI: Enabling device: (0001:03:04.1), cmd 2
eth1: Tigon3 [partno(BCM95714) rev 9001 PHY(5714)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:14:4f:6f:59:ff
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[76148000] dma_mask[32-bit]
PCI: Enabling device: (0001:04:01.0), cmd 2
eth2: Tigon3 [partno(BCM95704) rev 2100 PHY(5704)] (PCIX:100MHz:64-bit) 10/100/1000Base-T Ethernet 00:14:4f:6f:5a:00
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth2: dma_rwctrl[769f8000] dma_mask[32-bit]
PCI: Enabling device: (0001:04:01.1), cmd 2
eth3: Tigon3 [partno(BCM95704) rev 2100 PHY(5704)] (PCIX:100MHz:64-bit) 10/100/1000Base-T Ethernet 00:14:4f:6f:5a:01
eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth3: dma_rwctrl[769f8000] dma_mask[32-bit]
Fusion MPT base driver 3.04.05
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SAS Host driver 3.04.05
PCI: Enabling device: (0001:04:02.0), cmd 17
mptbase: Initiating ioc0 bringup
ioc0: LSISAS1064 A3: Capabilities={Initiator}
scsi0 : ioc0: LSISAS1064 A3, FwRev=010a0000h, Ports=1, MaxQ=511, IRQ=22
scsi 0:0:0:0: Direct-Access     FUJITSU  MAY2073RCSUN72G  0501 PQ: 0 ANSI: 4
sd 0:0:0:0: [sda] 143374738 512-byte hardware sectors (73408 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: d3 00 00 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 143374738 512-byte hardware sectors (73408 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: d3 00 00 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 0:0:1:0: Direct-Access     FUJITSU  MAY2073RCSUN72G  0501 PQ: 0 ANSI: 4
sd 0:0:1:0: [sdb] 143374738 512-byte hardware sectors (73408 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: d3 00 00 08
sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:1:0: [sdb] 143374738 512-byte hardware sectors (73408 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: d3 00 00 08
sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8
sd 0:0:1:0: [sdb] Attached SCSI disk
Fusion MPT misc device (ioctl) driver 3.04.05
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
mice: PS/2 mouse device common for all mice
Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 sec (nowayout= 0)
md: raid1 personality registered for level 1
raid6: int64x1    185 MB/s
raid6: int64x2    266 MB/s
raid6: int64x4    261 MB/s
raid6: int64x8    125 MB/s
raid6: using algorithm int64x2 (266 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
NET: Registered protocol family 1
NET: Registered protocol family 17
md: Skipping autodetection of RAID arrays. (raid=noautodetect)
md: Loading md0: /dev/sda4
md: bind<sda4>
md: bind<sdb4>
raid1: raid set md0 active with 2 out of 2 mirrors
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Fusion MPT SPI Host driver 3.04.05
PCI: Enabling device: (0000:03:08.0), cmd 3
mptbase: Initiating ioc1 bringup
ioc1: LSI53C1030 C0: Capabilities={Initiator,Target}
scsi1 : ioc1: LSI53C1030 C0, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=14
PCI: Enabling device: (0000:03:08.1), cmd 3
mptbase: Initiating ioc2 bringup
ioc2: LSI53C1030 C0: Capabilities={Initiator,Target}
scsi2 : ioc2: LSI53C1030 C0, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=15
scsi 2:0:8:0: Direct-Access     FUJITSU  MAW3300NC        0104 PQ: 0 ANSI: 3
 target2:0:8: Beginning Domain Validation
 target2:0:8: Ending Domain Validation
 target2:0:8: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 127)
sd 2:0:8:0: [sdc] 585937500 512-byte hardware sectors (300000 MB)
sd 2:0:8:0: [sdc] Write Protect is off
sd 2:0:8:0: [sdc] Mode Sense: b3 00 00 08
sd 2:0:8:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:8:0: [sdc] 585937500 512-byte hardware sectors (300000 MB)
sd 2:0:8:0: [sdc] Write Protect is off
sd 2:0:8:0: [sdc] Mode Sense: b3 00 00 08
sd 2:0:8:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 2:0:8:0: [sdc] Attached SCSI disk
scsi 2:0:9:0: Direct-Access     FUJITSU  MAW3300NC        0104 PQ: 0 ANSI: 3
 target2:0:9: Beginning Domain Validation
 target2:0:9: Ending Domain Validation
 target2:0:9: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 127)
sd 2:0:9:0: [sdd] 585937500 512-byte hardware sectors (300000 MB)
sd 2:0:9:0: [sdd] Write Protect is off
sd 2:0:9:0: [sdd] Mode Sense: b3 00 00 08
sd 2:0:9:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:9:0: [sdd] 585937500 512-byte hardware sectors (300000 MB)
sd 2:0:9:0: [sdd] Write Protect is off
sd 2:0:9:0: [sdd] Mode Sense: b3 00 00 08
sd 2:0:9:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1
sd 2:0:9:0: [sdd] Attached SCSI disk
scsi 2:0:10:0: Direct-Access     FUJITSU  MAW3300NC        0104 PQ: 0 ANSI: 3
 target2:0:10: Beginning Domain Validation
 target2:0:10: Ending Domain Validation
 target2:0:10: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 127)
sd 2:0:10:0: [sde] 585937500 512-byte hardware sectors (300000 MB)
sd 2:0:10:0: [sde] Write Protect is off
sd 2:0:10:0: [sde] Mode Sense: b3 00 00 08
sd 2:0:10:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:10:0: [sde] 585937500 512-byte hardware sectors (300000 MB)
sd 2:0:10:0: [sde] Write Protect is off
sd 2:0:10:0: [sde] Mode Sense: b3 00 00 08
sd 2:0:10:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1
sd 2:0:10:0: [sde] Attached SCSI disk
scsi 2:0:11:0: Direct-Access     FUJITSU  MAW3300NC        0104 PQ: 0 ANSI: 3
 target2:0:11: Beginning Domain Validation
 target2:0:11: Ending Domain Validation
 target2:0:11: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 127)
sd 2:0:11:0: [sdf] 585937500 512-byte hardware sectors (300000 MB)
sd 2:0:11:0: [sdf] Write Protect is off
sd 2:0:11:0: [sdf] Mode Sense: b3 00 00 08
sd 2:0:11:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:11:0: [sdf] 585937500 512-byte hardware sectors (300000 MB)
sd 2:0:11:0: [sdf] Write Protect is off
sd 2:0:11:0: [sdf] Mode Sense: b3 00 00 08
sd 2:0:11:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdf: sdf1
sd 2:0:11:0: [sdf] Attached SCSI disk
scsi 2:0:12:0: Direct-Access     FUJITSU  MAW3300NC        0104 PQ: 0 ANSI: 3
 target2:0:12: Beginning Domain Validation
 target2:0:12: Ending Domain Validation
 target2:0:12: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 127)
sd 2:0:12:0: [sdg] 585937500 512-byte hardware sectors (300000 MB)
sd 2:0:12:0: [sdg] Write Protect is off
sd 2:0:12:0: [sdg] Mode Sense: b3 00 00 08
sd 2:0:12:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:12:0: [sdg] 585937500 512-byte hardware sectors (300000 MB)
sd 2:0:12:0: [sdg] Write Protect is off
sd 2:0:12:0: [sdg] Mode Sense: b3 00 00 08
sd 2:0:12:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdg: sdg1
sd 2:0:12:0: [sdg] Attached SCSI disk
scsi 2:0:13:0: Direct-Access     FUJITSU  MAW3300NC        0104 PQ: 0 ANSI: 3
 target2:0:13: Beginning Domain Validation
 target2:0:13: Ending Domain Validation
 target2:0:13: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 127)
sd 2:0:13:0: [sdh] 585937500 512-byte hardware sectors (300000 MB)
sd 2:0:13:0: [sdh] Write Protect is off
sd 2:0:13:0: [sdh] Mode Sense: b3 00 00 08
sd 2:0:13:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:13:0: [sdh] 585937500 512-byte hardware sectors (300000 MB)
sd 2:0:13:0: [sdh] Write Protect is off
sd 2:0:13:0: [sdh] Mode Sense: b3 00 00 08
sd 2:0:13:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdh: sdh1
sd 2:0:13:0: [sdh] Attached SCSI disk
EXT3 FS on md0, internal journal
loop: module loaded
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
md: md1 stopped.
md: bind<sdb2>
md: bind<sda2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: md2 stopped.
md: bind<sdb5>
md: bind<sda5>
raid1: raid set md2 active with 2 out of 2 mirrors
md: md3 stopped.
md: bind<sdb6>
md: bind<sda6>
raid1: raid set md3 active with 2 out of 2 mirrors
md: md4 stopped.
md: bind<sdb7>
md: bind<sda7>
raid1: raid set md4 active with 2 out of 2 mirrors
md: md5 stopped.
md: bind<sdb8>
md: bind<sda8>
raid1: raid set md5 active with 2 out of 2 mirrors
md: md6 stopped.
md: bind<sdb1>
md: bind<sda1>
raid1: raid set md6 active with 2 out of 2 mirrors
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 7815536k swap on /dev/md6.  Priority:-1 extents:1 across:7815536k
tg3: eth1: Link is up at 1000 Mbps, full duplex.
tg3: eth1: Flow control is on for TX and on for RX.
u32 classifier
    Performance counters on
    input device check on 
    Actions configured 
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Loading iSCSI transport class v2.0-724.
iscsi: registered transport (tcp)
ip_tables: (C) 2000-2006 Netfilter Core Team
md: md_d0 stopped.
md: bind<sdd1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sdg1>
md: bind<sdh1>
md: bind<sdc1>
raid5: device sdc1 operational as raid disk 0
raid5: device sdh1 operational as raid disk 5
raid5: device sdg1 operational as raid disk 4
raid5: device sdf1 operational as raid disk 3
raid5: device sde1 operational as raid disk 2
raid5: device sdd1 operational as raid disk 1
raid5: allocated 12518kB for md_d0
raid5: raid level 5 set md_d0 active with 6 out of 6 devices, algorithm 2
RAID5 conf printout:
 --- rd:6 wd:6
 disk 0, o:1, dev:sdc1
 disk 1, o:1, dev:sdd1
 disk 2, o:1, dev:sde1
 disk 3, o:1, dev:sdf1
 disk 4, o:1, dev:sdg1
 disk 5, o:1, dev:sdh1
 md_d0: p1
scsi3 : iSCSI Initiator over TCP/IP
scsi 3:0:0:0: Direct-Access     IET      VIRTUAL-DISK     0    PQ: 0 ANSI: 4
sd 3:0:0:0: [sdi] 2929451520 512-byte hardware sectors (1499879 MB)
sd 3:0:0:0: [sdi] Write Protect is off
sd 3:0:0:0: [sdi] Mode Sense: 77 00 00 08
sd 3:0:0:0: [sdi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdi] 2929451520 512-byte hardware sectors (1499879 MB)
sd 3:0:0:0: [sdi] Write Protect is off
sd 3:0:0:0: [sdi] Mode Sense: 77 00 00 08
sd 3:0:0:0: [sdi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdi: sdi1
sd 3:0:0:0: [sdi] Attached SCSI disk
md: bind<md_d0p1>
md: bind<sdi1>
md: md7: raid array is not clean -- starting background reconstruction
raid1: raid set md7 active with 2 out of 2 mirrors
md: resync of RAID array md7
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
md: using 256k window, over a total of 1464725632 blocks.
kernel BUG at drivers/md/raid5.c:380!
              \|/ ____ \|/
              "@'/ .. \`@"
              /_| \__/ |_\
                 \__U_/
md7_resync(4258): Kernel bad sw trap 5 [#1]
TSTATE: 0000000080001606 TPC: 00000000005ed50c TNPC: 00000000005ed510 Y: 00000000    Not tainted
TPC: <get_stripe_work+0x1f4/0x200>
g0: 0000000000000005 g1: 00000000007c0400 g2: 0000000000000001 g3: 0000000000748400
g4: fffff800f904db00 g5: fffff80002088000 g6: fffff800ea784000 g7: 0000000000748528
o0: 0000000000000029 o1: 0000000000715798 o2: 000000000000017c o3: 0000000000000005
o4: 0000000000000006 o5: fffff800e9e6a990 sp: fffff800ea786d81 ret_pc: 00000000005ed504
RPC: <get_stripe_work+0x1ec/0x200>
l0: 0000000000000002 l1: ffffffffffffffff l2: fffff800e9e6aa78 l3: fffff800e9e6a918
l4: fffff800e9e6a9b8 l5: fffffffffffffff8 l6: 0000000000000005 l7: fffff800fde02800
i0: fffff800e9e6a958 i1: 0000000000000000 i2: 0000000000000004 i3: fffff800ea787720
i4: 0000000000000080 i5: 0000000000000080 i6: fffff800ea786e51 i7: 00000000005f0274
I7: <handle_stripe5+0x4fc/0x1340>
Caller[00000000005f0274]: handle_stripe5+0x4fc/0x1340
Caller[00000000005f211c]: handle_stripe+0x24/0x13e0
Caller[00000000005f4450]: make_request+0x358/0x600
Caller[0000000000542890]: generic_make_request+0x198/0x220
Caller[00000000005eb240]: sync_request+0x608/0x640
Caller[00000000005fef7c]: md_do_sync+0x384/0x920
Caller[00000000005ff8f0]: md_thread+0x38/0x140
Caller[0000000000478b40]: kthread+0x48/0x80
Caller[00000000004273d0]: kernel_thread+0x38/0x60
Caller[0000000000478de0]: kthreadd+0x148/0x1c0
Instruction DUMP: 9210217c  7ff8f57f  90122398 <91d02005> 30680004  01000000  01000000  01000000  9de3bf00 

--------------090100070606060800080109
Content-Type: application/gzip;
 name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config.gz"

H4sIALZtFEcCA4xcX5PjprJ/z6dwbW7VPafqJDu2Z7wzqdoHhJBNLAkGkP/kReXMeDe+mfXM
sT3nZL/9bZBsgQRyUpUdq38NNNB0Ny3Qjz/8OEDvp9dvm9PuafPy8n3wdbvfHjan7fPg2+bP
7eDpdf9l9/WXwfPr/n9Pg+3z7gQl0t3+/a/Bn9vDfvsy+M/2cNy97n8ZjH6e/DwaA6zetwP2
dBoMJ4Obh1/uRr+MRoPRzc2nH378AbM8odNSciTw5+/O4+S2IUxJTgTFpaIZ6VJxxmRZ8Bgp
H5gyPCcLkivZgJPbiKrmMcuK5uGxoHieUmnhUiE8VwJhUsqCcyYsTFcfE94FoAuzMkPrcoYW
pOS4TGLdxR8HNj5DsqQpm47KYjwa7I6D/etpcNyewmyTW5vtzFTEVBnWVvs5KxdUqFKxMiqs
AWBJZ7RLjqbQP/obKe/nkS1pl2FyO4+80nZZ74ajv817mwU4CcYs415s9ls5vLnxjAkAo7sb
ux9AGbusrVr81XyGaixOpnhaTEvMCw93TJKzXmgN+vDxZff7x2+vz+8v2+PH/ylylJFSkJQg
ST7+XK2lDz/AOvhxMDXr7EVX9v7WrAyy4qDGGagvSl2lK+dE5MQi0hx0gOQLmHndfAYaPh5Z
JVC6IEJSln/+8KHpjw2AHinm6ZVcIm7py1ouKMcdgv6LlSUQZ5KuyuyxIIW1MCMZl1wwTKQs
EcYqjJSLsT19Csk5rEQlvTNYSCLK3I+Z5eHpF51XP6wxnJ9lBzns8QbpiqSUM5qoz8O7Mx2U
QBLbsMAQJBK0gAuCwRzFtvww72jtlS9K51BmYWZQxF4WjEvGwfzpZZIwYdaLb6bOU3ApSLKI
xDGJPcwFjYcTR3Yoa/6g1JrGOTzJdSbtWs800E+wi7CEpfStnWqtWBohaK7m1ozbIEmTEjNh
qwoskzIpbGGSQpGVZeRy0Fqas5hYk0A4s4tIOs1RmsQWg3YHNkHOMpI1j4usYgFxilzB2rA4
0yKCuaoEbwxUiiLfbACzy8Z8bGCfM90t4gyxovm6EsxTxIyMzPQ83Vy8GIuL1B6HilAWecpQ
3CGDFmEvWBuDbkVS4IuhcBQEcNtZMg5+D89obk+lNll29y46z0rjWXsXRiSnNm4MJmUD+fTH
VpvWw7ExmJRJPCMxeD5m2awzFckuLSYoTh1hzwhOHm2RwbijIgU/67cyZ/hcn989GJZAxVrm
nlK1WJ8/PH3594e28dUOEqlu/DNDIqbiUffb8TPfNk9/7Pbbtr9REPyULCcS1m5TGYQR4Acv
jzM6nYE5kyYec1ZHZo15Lox91E6oMWO8KBNBHn2rYClJVq7wbIpimKh0ygRVs6zbo4TmML1g
eEoniLt0eElAPA8AVo1GAqwyDChY4lakJMErg8uB5cbEWmu87VorDohXQEQQkuQoSkkQrufL
GhZv3ZdBSVKkdLkM5QVK/bpFJfxSdOrnsyKqSoSKxY3xDGJNog5La5HAXUmwdx5+HfuCTthI
CmEGVyYEMfN7e5lBIlkBRkW24+vfQKHKOEO6p9PGYIGCmGD78/BSuROk6icM+mtRCh2jrChz
Sea5sbJASWOW+TwSx9TyRpiWwIeobes0seMCqwmuInxZZpLa7ekSQPLNB0jCOMkhmMgS+fmb
E3GPR501236OaJ5kSjvG8cixnRUdsUK5uwazwslf26f30+b3l+3gy07/83qA7ZxlIptqO01l
oGcgZzOWLEWCgpvPCq/CGTMpM1tzDCnDttMnJOPauhkb24xbTV+wFLwsEv7YqObyzWVdPpo7
qwlnxvqWEWNpZ2zy7em/r4c/d/uvzXDkRJ2NYwMPXt9OsIu1Ro3DHpBYHa2eYe9ox8ZFTq3o
ZJWIzBZNP5tA1dtTg0oILyB8oXgd5snoVJsxLwN0BjYGa1+wm9vSU/DRYKMoRtKloniBcgxT
KEC7iLX2IPrWeEIjvR2d2f2qyUpQn9NzC7Xa5xBXKG1NpYOZxmsOpGYeDCKRiEniIDznLbGA
UsYz7N861jgoiuJ+uTUskHBq1SNMOeXB4ad8KgLjkBnZXZlpJrNyMfQRR7YF4naMtc7BWLA5
dYZNN45mjZkxBCJ5iwLRAtiZFtEolipyvaN0ES+x0kNwZDp4y6XJfAQ5+iuICGmXjSm4iZYU
mLfImgI/pxeNbUbiAkUUewrgwk9fEqmWDGLZLjSDXz6yDNDXUYo89AWZIumha3djQooulHJv
PTnzkNfEnv4LmaZgEBmVtmE/x5QwEr3BrBmrXg49NL0MptO9HOeB74l9he7x9zb13MXPHw7b
/auV1dBAFt/B1i+08hcygCwmfgC0cGIvkx6uLkNjHpZMzHVCK0PC2ggDkNC0sre2MamI1YbT
tw0UNJ4Sp7TxY/j1sNXODPz/aXuAR51oej9stEtzHF9dP/wCFZk3utOByiqL08OQMmtx5nor
n+d6Zzevw+XYj7pU1UoJOfW0hsyGugPqCNBK/1YtQVSmWAm2ui1CBUisuB8pYh0Dk0BvEcTe
MQqASbvOCzIbj8YBiAocQGDsI9gVlrkMMHAebFCiPNQFSUOFVNIdlB7lWdWu3QuB3xdTMO04
RVLSZH2FC2QwU9zLFUvbHvs4rteRJ0Fdt5lcffexsLaCe5hM7qOf5azbV4fnbzGCZcxkaEYy
pGCjA+GBTjhf4cnzaK2IvMpVZaKvcfUI3jD1jWfFFePg/NcM8gqDEy958BlJORjaPpaU5FM1
62e5OigZwlfwKwNW7SL66zDxtRO7+SqarWVMFv08c6XWnPTyPBZMoV4OQVCa9XK0jLKHQSFF
rnJQqSi+wiVoPu1l+RsrqYB9e68ywZ7orApVUpP/8jf8tuMc+OI2ZPwF6+YFIfQBppaFq4iU
t811Ra9kpRwi/Snxg4oFSgmCHVNiYwTnfsDZxNitqNQPsGVur0mnrjgWrmpWaB0wtai1kRTk
V4JVAHQMv4MU7RgoR6r9DGpAYnuz4tSQIQlTI1BMgpLFVIRlAx3T+Qg/KFFGOuLIPOP6dQLF
HcgfIGmkHQVoWjtK0TTlY/QESKY17uHtREVGZMq7c51P09CYeZSzRjwaeC7TVbVLuFJI0Jyu
DAIt2yTYtfuXFAB+BQSg6YwxCdFh9/x1+zfMwnkzkJQkardaYwDAT5OD8EGqsyoc0NFmC7m/
GZVjL4IyZhtRGxHcS6d+cstfWojrBy2g45IsTCp/M4sU5SFxBeHp2gvGoYHRspV+qLuObfFC
FTr2xaLXhsfe3+pIKLT31V7Ui0E04N/sI5UFt5+NRHr4tDYMH91UAwaz5Cmepk6uGR5HAYlX
AaFQOvenSUd3XnqKuP+ECYG/rowXaAl9qnKhnWzy46scbPbPH18Pgy+b3WHw7/ft+7adW64y
4s5WX5NgqSXsvF9/rAt+rN9o+uoocfToBBOGOFORh5hI3KVyQVmXKoSH5mzWa6JMPM0r8ph6
qFHSJU69tcayE8gaOvwlWZcMMZkgJuiq8hwvm+Nx92X31M1sgJ2W7qADoePoarLCNI/JqguY
ib8N0LvVJ8suqxMD1oQSthDWy5cztZMTqtqSC+6RAKgTl0xMxONWQC5BL+ycmuNAFoQz7qum
NNs7L9KOas/0jLTi+zOgyEp1e4CcRI/OXesMi961tJrV9CmybeUUVcmYqFtBRkVH0TQdgtsu
kYMV9pAlNWPiZPW1xJVw/ryeYQAtar1KGpy2x1O1nJ3qwDtNSe4/i4YyCAAp89tCESP/UQm/
9UIQl6yEa9XPr51pVIr6xIgRb7k7bF+2x6MtK06m2qAP/aaR6rNs0pwC8jLAJjZcmhJCwqhI
5jRNgy9ZHnjHGsfb/+yetoP4sPtPdSKkOe+we6rJA9Z+rQcrA6LRlNnnP8DXm+M/CRXZEglS
RgVNLROeLEt9asYESs2r0rUsZxBwiAWVzP+GT2/NwOcH0Ez5EuAs0Sdg9JqwX51CPALbdp9L
rk7M+E7aJHHwjA3mjyWmMJEh5aqriBF+mNz0shStA0sdBsyWJsPE8rD4MLzMWYGXwmLNFUv9
52TOTHkU+8rK1X1PIYEsd2MRqzNgn4cTH6ZP4QE0vr/1oebMU8VyM7q11CAWLNMWAMeLOBTZ
lGxBREnUzK8rVOJaLwLvMWLSWSASSzp4rlbJ8f3t7fVwataBQDSGdpWwzylgSe03+5LqUxwt
ipoq5/SFptUpYe+JAYBNYiK52B0jVy3Q4PT9bTv4x/Pu+Oe/BqfN2/ZfAxz/BOP1T2ujc55Q
a0nimahoyp76M5VJqXqVUgqPrJc6raD7QsOzcxAiX79t7bE9Dv6x/fnrzyD34P/e/9z+/vrX
Py+9+/b+ctq9vWwHaZHbRkiPisnGlQC0Bhh+ayPlHDPVdIj5pzpH1R58iSFiRXKd49D4LxFV
hu3SBS29Omz2Ry1lWzDJaa0Z7aYSXAGhhqj516NVpUTyUmebntJIom5jDRR8H1aPyzIF+22f
jK4UFXtNynhZruA/swD8p891YeB6AK4wA8JI9JRHCPc3gCj+1N9AxVCy9EotD1dqebjtZRA4
kwEHRabImImcLEPBy4UnhR+BQywXHhl4L2wEmXFFGQ/jcbYaDx+GPYORFKoA510d8QqzUd4j
hT6SHQjFzjgaBi4VVFoLwW8Pus7uxvgepnUUZnqElU5xORzd31xjgjHrY0GwYvtxs1TCLCnv
qyDG44e7v/rxG9WDt5d1a7CKnMgejZCCh7ypx1ZksX06ubIFNi0DHaY5Qdb+GEhab286lKFT
zFC6TLd3kw7bnT40OUOcOEhz7smuwxx5WHeDlDhzsi1Z0DoCZOKnpgqgyBxxc9jXJupNFBMO
6TcimMvTFdKmwt4PBxDYwrhQdR639kXJu74+NtBn/kKxSlKYayzf3Wftp+yRqKmJd+9Tl7DP
g9e0DK3A45PPtzctwLnbUtMaH1y9voEtzWA4frgd/COBzZTeUP3TEr8RDTZOevMU3BeZOrzg
iPn3n3Uw2Do/UlOrwTcvfXwH0xIrhxQXWWYrGcvj6kWYvanTiT5PReSxQCnEu5bmqCK3y4J3
CeXZTL5AzfSlJhXsorml5dyiwyQPHVBKR/7sIGlf9Wq6thbUHDv2Syjvx/ejm9CmXV958GJr
kkJMkgR8kLgfTh78Ro3K4UPA5M+nJACsA55k/nCfBkRYUFRCwMQwVb6To4pOWe5cxYrylb8V
cCHjUBSDVDoMzfx5av29Vd3U6zlXMQBNtFfWUqegYf/ek7Q4J6mHoXSvl57EsX92Z5RzP8J5
wFmlPadHQ/5VOwkRKqW3CCwNngjW96GCDWpQ7zGUgB+BJqiM/aPCZyzvbjTp/u39FLTeNOeF
s2U0hDJJ9G0EnU4KnKzTTFpY0JVOi8Vxe3jZ7J8Hu/1pe/iygV1Yq8EyY4UkrdSIi5RcomLl
PTrtsEksCMnLVbWt7+VZf/40uW+39ytbt/rQYlCyHyeLa3grALBmpZMla5Wdk3XEQlsZq5M9
OPRPn6+Y9/VQv59UfQyswLNqEMMToi8rfHdp5mqF5HMnNVdBhfnTGZbZ5vD8381hO6Af2eC8
/bWuHotA+D9FGWkn4aqSf2wOmyf9orbOBzSauLAy3gtzaEsvW+tOztKiNeZZWYC+qaE9cuCi
tKAo1TctqrSmO43VVn972G1eBs9uljR/3f90P7q7AT4Dm2RFZ+XW1UMcXt/TbDcMyG/6nnqf
cMAji2sM/uuUF3y2sC9XGap7c9Qi+ka0hn+Vvrea+g7Hw33J1doKDqvtbJBYZwlHdxP7tWUG
u1iYhpZVvTgahWcxc/I3ZxrM4BKtmUdbl5vT0x/Pr1+76/hyYydR/XVjPgy56AtPS+lN0xzT
n37fHLfPjRAY1o6zXICH43Mt/iZiBUy+y8JL2BHlsFl37kyPHyb+QBhxnlLM/LnmWPjpAi0B
o4uAm1MY/ueZ9xj6ov66gxWJ4+7i4tQX7stAgKATaxmSKiDO0h+hcLYkwtxGS/35ldmylVw3
smQ69fjlff+kX4CcnfNz1w1kib7RdXcz9Nfwbfu821iWzQoiY8LKkGOKF5FZjX7QXe7Ve5vD
5u2P3dOxa4UipL/PMZ2pMsWx9d2N5i0/kM2h4jpD7r0/fa7DZjxvQePd8e1l870bwdj3MTns
Wc+t+6PqKTKnEQMhtx4tWOHaM9XRlz/u7A4Nft0fX19g8s5iVq+2PGLqi4elJzi093qWfazT
2e/7Z0d7wbTFgdA37h2BQka9eJbhQFi6BNsahwJB2EnRCAVkEgpXc9p9P5ihAdl/NZee2zql
L6eSfFrdAr9w45fddm+nw83lJPMG5MITd1cCzRVJS8qQ0gy+UPX4BhGqDjjsYoXH5ma741P1
eZ2PJrKxFqznjql9L5ZFXF+3lTPnHSUwR4FdSRThtk1rdsz5AisRvJqsl8InSbohZ7L7HQIr
CIj2+stAvkQIvvUUAt0+fj+ett+cYSUrNSoT37sGQMbV+ySXUK70K4YuufowCcJpF5IEFwK2
wc4nNFbq1rxA9bX9a+R85AMeg/k3qD6LMMIz4n4WhEI4Alji1/dfO1BTnd0R645osK5pIkch
jOEeMIMltwqB5nazX0aaM6WvdnxvEcwtWPubS/poePOoryIvhk0WqSKMWgWchFx8acn67Iti
IcEq7LZMZCtlSPz8548IVGNdqaV5L/lRv8PVKuvRWCrZw2RyExq3Ik5aUGVVmPyYIPUxV6F6
Mwk8oVoXiT6gG8hgqc54VKHdcfv+/GquizfNWV/CcRaXIczdeNvQ2t//MR/DsW5lZrzz6Nfg
WTElKo0CnahR890o33ckUJY4adDqj7/j2r5uX142++3r+7HV/0aP4vCKQkkYm/VCPC2CcETC
RaMw1FMKm2HxK0yPwZjxMPaYr27DqP4uSVDx/ZNxPjJlHIBs62FuCtmHwWX1gSjnua1Khurf
QWioOoRLvTn1RDpXFmUMFsh1GhVx3CF4hIhbUtiIfjHtfk+uadc8QlnbU+l4qj0S0OIlFHaA
6qiN870MwXErKACKySuM/SMFMPjFcgqB8lxEd9d4JJ9nY79SZFFQQWnIZmEeLMNiFF6Yfku3
OZx2Zgekvr9tnc87CKVf9eb2fXLrNQMTecPjd6AyucKBMjpF13gUEvQKT4awn8PxDxcOJ3MP
+gYR2zxFUeAKc+XqZRH1y3D+MsjqfnJFWp1PMafo+ttN4+xKRXJ6bWCKVAkQvm9sdAjsHZk5
Etm1ySHJNQm02Zvc+5kqI7c5QQQ/SDf7r++br2Dn2luR3Dm3nMrL54Q+7I6v9/d3Dz8NP9gw
LAJiPqF4O/5kLX0b+RRGPt0FkPu7myAyCiLh2kIS3E+C7UyGQSQowWQcRG6DSFDqySSIPASQ
h//v4wxyW4WBMHyVXgFSUlgaxxQLEygGpekGpVGlRk8vlVCy6O3rAdLYzLiLKMpnDOOxY2A8
/le+OonXo8nK157k0Xed+GnRHvOwCaOjjz0VgtB7fVO0cDXTXEr6/AGNQxqvaOyxPaLxmsZP
NE48dntMCTy2BAtjikrGfUOwzmVdm8VWIOkynN6vIJ+rvo7/HsrD2fzpByeUpEpiqcbUu/7/
OF/GjQ3WJGGHdjKpfAsBBSTHC3z7KyaN3s/D0dVAmsRtZfMCCl2aCqpN0o2j4psnRABLOn3Z
6bY3b7ie1Z+SQSaTmSSbF8+9AtbPIC0qrZRPNMS8XXufVwWkZes/LJiqT9qpntXZm8JjT95A
piLzuSsQzQsrx+twunxbylH37hB77VO2HcMNxHVeq2bOILY1mPZbvljqmFgpSl7vl9Scw0qR
HXOnl79BaY/VEuNUFVzWuZ3MMRf5S/Ip3uTCkm3NJEMc7Gxxn+ErTzHcggQoOu3mkWARaojO
WYAONDCM1hSOghDhXU3R9rkJEoyfsyCMyw4bLHiKGNXamoKq2eHK8LVBeGNv/JxZtkj8+u1J
yEsh+qzdVX/x21sF8p9oame7920wESaB8lhEUtwvrWD4nA3HA6DI2RvDLmHbLpWa8BRILwo8
jCTPmVDwTTidr0KORhlnpVBKMsL0RUr6PPh3aG5Wp/fhMHw/DF/Xy+n84Qj2tbAjpdGOqWYi
4LJ1nM2DtXuEbLvePcLZjdZw6x6qZLps3JthEHB3vTRS5DvY5KWFq0F+Z31hbzOzeFqSONMW
r1059lENvVqIWQJyBdiBTcH6H8brk07WXgAA
--------------090100070606060800080109
Content-Type: text/x-diff;
 name="iscsi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iscsi.patch"

--- kernel/iscsi.old.c  2007-10-17 12:44:09.000000000 +0200
+++ kernel/iscsi.c      2007-10-17 11:19:14.000000000 +0200
@@ -726,13 +726,26 @@
        case READ_10:
        case WRITE_10:
        case WRITE_VERIFY:
-               *off = be32_to_cpu(*(u32 *)&cmd[2]);
+               *off = be32_to_cpu((((u32) cmd[2]) << 24) |
+                       (((u32) cmd[3]) << 16) |
+                       (((u32) cmd[4]) << 8) |
+                       cmd[5]);
                *len = (cmd[7] << 8) + cmd[8];
                break;
        case READ_16:
        case WRITE_16:
-               *off = be64_to_cpu(*(u64 *)&cmd[2]);
-               *len = be32_to_cpu(*(u32 *)&cmd[10]);
+               *off = be32_to_cpu((((u64) cmd[2]) << 56) |
+                       (((u64) cmd[3]) << 48) |
+                       (((u64) cmd[4]) << 40) |
+                       (((u64) cmd[5]) << 32) |
+                       (((u64) cmd[6]) << 24) |
+                       (((u64) cmd[7]) << 16) |
+                       (((u64) cmd[8]) << 8) |
+                       cmd[9]);
+               *len = be32_to_cpu((((u32) cmd[10]) << 24) |
+                       (((u32) cmd[11]) << 16) |
+                       (((u32) cmd[12]) << 8) |
+                       cmd[13]);
                break;
        default:
                BUG();
--- kernel/target_disk.old.c    2007-10-17 11:10:19.000000000 +0200
+++ kernel/target_disk.c        2007-10-17 16:04:06.000000000 +0200
@@ -66,13 +66,15 @@
        unsigned char geo_m_pg[] = {0x04, 0x16, 0x00, 0x00, 0x00, 0x40, 0x00,
0x00,
                                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00,
                                    0x00, 0x00, 0x00, 0x00, 0x3a, 0x98, 0x00,
0x00};
-       u32 ncyl, *p;
+       u32 ncyl;
+       u32 n;
        /* assume 0xff heads, 15krpm. */
        memcpy(ptr, geo_m_pg, sizeof(geo_m_pg));
        ncyl = sec >> 14; /* 256 * 64 */
-       p = (u32 *)(ptr + 1);
-       *p = *p | cpu_to_be32(ncyl);
+       memcpy(&n,ptr+1,sizeof(u32));
+       n = n | cpu_to_be32(ncyl);
+       memcpy(ptr+1, &n, sizeof(u32));
        return sizeof(geo_m_pg);
 }
 
@@ -249,7 +251,10 @@
        struct iet_volume *lun;
        int rest, idx = 0;
 
-       size = be32_to_cpu(*(u32 *)&req->scb[6]);
+       size = be32_to_cpu((((u32) req->scb[6]) << 24) |
+                       (((u32) req->scb[7]) << 16) |
+                       (((u32) req->scb[8]) << 8) |
+                       req->scb[9]);
        if (size < 16)
                return -1;


--------------090100070606060800080109--
