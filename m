From: Duke Ionescu <duke@mastre.com>
Subject: speed_limit_min probs, thoughts
Date: Sun, 12 Oct 2003 13:24:59 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F898E6B.4080109@mastre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been playing around with linux Software RAID it for a day or so and 
have been testing all types of scenarios, like simulating disk failures, 
rebuilds, etc.  And I've run into some problems.  On top of this, I have 
some thoughts on the subject (imagine that! ;) that I will post here. 
So, here we go:

The test system I am running this on is:
Supermicro P4SCE-based server
Pentium 4 2.4GHz 800MHz FSB
  - HyperThreading Enabled
  - RedHat Linux 9, stock 2.4.20-8smp kernel
1GB PC3200 ECC RAM (2x512)
2 x Maxtor 5A250J0 250GB 5400RPM HD
  - connected to sep channels, in UDMA5 mode
  - one is hda, the other hdd (CD-ROM is hdc)

The only software RAID array is /dev/md0, made up of /dev/hda1 and 
/dev/hdd1.  I simulated the failure of hdd by removing its partition 
then recreating it via fdisk.  Then I issued the following commands:

# echo 100000 > /proc/sys/dev/raid/speed_limit_min
# echo 200000 > /proc/sys/dev/raid/speed_limit_max
# raidhotadd /dev/md0 /dev/hdd1

Last line produced is (also available via dmesg):
md: using 124k window, over a total of 243537216 blocks.

Now when I cat /proc/mdstat, I get this:

Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 hdd1[2] hda1[1]
       243537216 blocks [2/1] [_U]
       [=>...................]  recovery =  6.6% (16304448/243537216) 
finish=308.6min speed=12266K/sec
unused devices: <none>

Now, besides the fact that I _know_ the hardware is much faster than a 
measly 12MB/s, when I monitor mdrecoveryd and raid1d via top, 
mdrecoveryd occasionally goes over 2.0% to 3.1%, but usually lingers at 
1.9%.  raid1d stays at under 1% most of the time.  There is nothing else 
actively running on the system (see ps ax and output at end).  So what 
gives?  Why are my disks only mustering 12MB/s when they should instead 
be maxing out the system to try to achieve my 100MB/s goal?  Does the 
"124k window" have something to do with this?

Apart from this nuisance, there is another impracticality: as hard 
drives grow larger and larger, simply copying all "blocks" blindly 
becomes less and less efficient, especially for systems that are running 
well below full capacity.  For example, the RH9 install on these HDs 
uses up only 1% of capacity (and that may be rounded up ;) - copying 
248GB worth of unused blocks is very inefficient.

---
$ ps ax
   PID TTY      STAT   TIME COMMAND
     1 ?        S      0:04 init
     2 ?        SW     0:00 [migration/0]
     3 ?        SW     0:00 [migration/1]
     4 ?        SW     0:00 [keventd]
     5 ?        SWN    0:00 [ksoftirqd_CPU0]
     6 ?        SWN    0:00 [ksoftirqd_CPU1]
    11 ?        SW     0:00 [bdflush]
     7 ?        SW     0:00 [kswapd]
     8 ?        SW     0:00 [kscand/DMA]
     9 ?        SW     0:00 [kscand/Normal]
    10 ?        SW     0:00 [kscand/HighMem]
    12 ?        SW     0:00 [kupdated]
    13 ?        DW     0:19 [mdrecoveryd]
    19 ?        SW     0:14 [raid1d]
    20 ?        SW     0:00 [kjournald]
  1024 ?        S      0:00 /sbin/dhclient -1 -q -lf 
/var/lib/dhcp/dhclient-eth0.
  1259 ?        S      0:00 syslogd -m 0
  1263 ?        S      0:00 klogd -x
  1281 ?        S      0:00 [portmap]
  1300 ?        S      0:00 [rpc.statd]
  1396 ?        S      0:00 /usr/sbin/sshd
  1410 ?        S      0:00 xinetd -stayalive -reuse -pidfile 
/var/run/xinetd.pid
  1428 ?        S      0:00 crond
  1446 ?        S      0:00 [atd]
  1459 ?        S      0:00 login -- root
  1460 tty2     S      0:00 /sbin/mingetty tty2
  1461 tty3     S      0:00 /sbin/mingetty tty3
  1462 tty4     S      0:00 /sbin/mingetty tty4
  1463 tty5     S      0:00 /sbin/mingetty tty5
  1464 tty6     S      0:00 /sbin/mingetty tty6
  1465 tty1     S      0:00 -bash
  1575 tty1     S      0:00 watch -n 10 cat /proc/mdstat
  1650 ?        S      0:00 sshd: duke [priv]
  1653 ?        S      0:00 [sshd]
  1654 pts/0    S      0:00 -bash
  1806 pts/0    R      0:00 ps ax


$ cat /proc/ide/piix

Controller: 0

                                 Intel PIIX4 Ultra 100 Chipset.
--------------- Primary Channel ---------------- Secondary Channel 
-------------
                  enabled                          enabled
--------------- drive0 --------- drive1 -------- drive0 ---------- 
drive1 ------
DMA enabled:    yes              no              yes               yes
UDMA enabled:   yes              no              yes               yes
UDMA enabled:   5                X               4                 5
UDMA
DMA
PIO


$ uname -a
Linux localhost.localdomain 2.4.20-8smp #1 SMP Thu Mar 13 17:45:54 EST 
2003 i686 i686 i386 GNU/Linux


$ dmesg
ype: Intel
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Intel machine check reporting enabled on CPU#0.
CPU:     After generic, caps: bfebfbff 00000000 00000000 00000000
CPU:             Common caps: bfebfbff 00000000 00000000 00000000
CPU0: Intel(R) Pentium(R) 4 CPU 2.40GHz stepping 09
per-CPU timeslice cutoff: 1462.93 usecs.
task migration cache decay timeout: 10 msecs.
enabled ExtINT on CPU#0
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Booting processor 1/1 eip 2000
Initializing CPU#1
masked ExtINT on CPU#1
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Calibrating delay loop... 4784.12 BogoMIPS
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Intel machine check reporting enabled on CPU#1.
CPU:     After generic, caps: bfebfbff 00000000 00000000 00000000
CPU:             Common caps: bfebfbff 00000000 00000000 00000000
CPU1: Intel(R) Pentium(R) 4 CPU 2.40GHz stepping 09
Total of 2 processors activated (9568.25 BogoMIPS).
cpu_sibling_map[0] = 1
cpu_sibling_map[1] = 0
ENABLING IO-APIC IRQs
Setting 2 in the phys_id_present_map
...changing IO-APIC physical APIC ID to 2 ... ok.
init IO_APIC IRQs
  IO-APIC (apicid-pin) 2-0, 2-10, 2-11, 2-12, 2-18, 2-19, 2-20, 2-21 not 
connected.
..TIMER: vector=0x31 pin1=2 pin2=0
number of MP IRQ sources: 18.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 02000000
.......    : physical APIC id: 02
.... register #01: 00178020
.......     : max redirection entries: 0017
.......     : PRQ implemented: 1
.......     : IO APIC version: 0020
.... register #02: 00178020
.......     : arbitration: 00
An unexpected IO-APIC was found. If this kernel release is less than
three months old please report this to linux-smp@vger.kernel.org
.... IRQ redirection table:
  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:
  00 000 00  1    0    0   0   0    0    0    00
  01 0FF 0F  0    0    0   0   0    1    1    39
  02 0FF 0F  0    0    0   0   0    1    1    31
  03 0FF 0F  0    0    0   0   0    1    1    41
  04 0FF 0F  0    0    0   0   0    1    1    49
  05 0FF 0F  0    0    0   0   0    1    1    51
  06 0FF 0F  0    0    0   0   0    1    1    59
  07 0FF 0F  0    0    0   0   0    1    1    61
  08 0FF 0F  0    0    0   0   0    1    1    69
  09 0FF 0F  0    0    0   0   0    1    1    71
  0a 000 00  1    0    0   0   0    0    0    00
  0b 000 00  1    0    0   0   0    0    0    00
  0c 000 00  1    0    0   0   0    0    0    00
  0d 0FF 0F  0    0    0   0   0    1    1    79
  0e 0FF 0F  0    0    0   0   0    1    1    81
  0f 0FF 0F  0    0    0   0   0    1    1    89
  10 0FF 0F  1    1    0   1   0    1    1    91
  11 0FF 0F  1    1    0   1   0    1    1    99
  12 000 00  1    0    0   0   0    0    0    00
  13 000 00  1    0    0   0   0    0    0    00
  14 000 00  1    0    0   0   0    0    0    00
  15 000 00  1    0    0   0   0    0    0    00
  16 0FF 0F  1    1    0   1   0    1    1    A1
  17 0FF 0F  1    1    0   1   0    1    1    A9
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
IRQ16 -> 0:16
IRQ17 -> 0:17
IRQ22 -> 0:22
IRQ23 -> 0:23
.................................... done.
Using local APIC timer interrupts.
calibrating APIC timer ...
..... CPU clock speed is 2395.8356 MHz.
..... host bus clock speed is 199.6526 MHz.
cpu: 0, clocks: 1996526, slice: 665508
CPU0<T0:1996512,T1:1330992,D:12,S:665508,C:1996526>
cpu: 1, clocks: 1996526, slice: 665508
CPU1<T0:1996512,T1:665488,D:8,S:665508,C:1996526>
checking TSC synchronization across CPUs: passed.
Starting migration thread for cpu 0
smp_num_cpus: 2.
Starting migration thread for cpu 1
PCI: PCI BIOS revision 2.10 entry at 0xfb1b0, last bus=2
PCI: Using configuration type 1
PCI: Probing PCI hardware
PCI: Ignoring BAR0-3 of IDE controller 00:1f.1
Transparent bridge - Intel Corp. 82801BA/CA/DB PCI Bridge
PCI: Using IRQ router PIIX [8086/24d0] at 00:1f.0
PCI->APIC IRQ transform: (B0,I31,P0) -> 16
PCI->APIC IRQ transform: (B0,I31,P1) -> 17
PCI->APIC IRQ transform: (B2,I9,P0) -> 16
PCI->APIC IRQ transform: (B2,I10,P0) -> 22
PCI->APIC IRQ transform: (B2,I11,P0) -> 23
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16)
apm: disabled - APM is not SMP safe.
Starting kswapd
allocated 32 pages and 32 bhs reserved for the highmem bounces
VFS: Disk quotas vdquot_6.5.1
Detected PS/2 Mouse Port.
pty: 2048 Unix98 ptys configured
Serial driver version 5.05c (2001-07-08) with MANY_PORTS MULTIPORT 
SHARE_IRQ SERIAL_PCI ISAPNP enabled
ttyS0 at 0x03f8 (irq = 4) is a 16550A
ttyS1 at 0x02f8 (irq = 3) is a 16550A
Real Time Clock Driver v1.10e
FDC 0 is a post-1991 82077
NET4: Frame Diverter 0.46
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00beta-2.4
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH5: IDE controller at PCI slot 00:1f.1
ICH5: chipset revision 2
ICH5: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:pio
     ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
hda: Maxtor 5A250J0, ATA DISK drive
blk: queue c0453420, I/O limit 4095Mb (mask 0xffffffff)
hdc: MATSHITA CR-177, ATAPI CD/DVD-ROM drive
hdd: Maxtor 5A250J0, ATA DISK drive
blk: queue c04539f4, I/O limit 4095Mb (mask 0xffffffff)
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: host protected area => 1
hda: 490234752 sectors (251000 MB) w/2048KiB Cache, CHS=30515/255/63, 
UDMA(100)
hdd: host protected area => 1
hdd: 490234752 sectors (251000 MB) w/2048KiB Cache, CHS=30515/255/63, 
UDMA(100)
ide-floppy driver 0.99.newide
Partition check:
  hda: hda1 hda2
  hdd: hdd1 hdd2
ide-floppy driver 0.99.newide
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
  [events: 00000044]
  [events: 00000042]
md: autorun ...
md: considering hdd1 ...
md:  adding hdd1 ...
md:  adding hda1 ...
md: created md0
md: bind<hda1,1>
md: bind<hdd1,2>
md: running: <hdd1><hda1>
md: hdd1's event counter: 00000042
md: hda1's event counter: 00000044
md: superblock update time inconsistency -- using the most recent one
md: freshest: hda1
md: kicking non-fresh hdd1 from array!
md: unbind<hdd1,1>
md: export_rdev(hdd1)
md: RAID level 1 does not need chunksize! Continuing anyway.
kmod: failed to exec /sbin/modprobe -s -k md-personality-3, errno = 2
md: personality 3 is not loaded!
md :do_md_run() returned -22
md: md0 stopped.
md: unbind<hda1,0>
md: export_rdev(hda1)
md: ... autorun DONE.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 8192 buckets, 64Kbytes
TCP: Hash tables configured (established 262144 bind 65536)
Linux IP multicast router 0.06 plus PIM-SM
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
RAMDISK: Compressed image found at block 0
Freeing initrd memory: 157k freed
VFS: Mounted root (ext2 filesystem).
md: raid1 personality registered as nr 3
Journalled Block Device driver loaded
md: Autodetecting RAID arrays.
  [events: 00000042]
  [events: 00000044]
md: autorun ...
md: considering hda1 ...
md:  adding hda1 ...
md:  adding hdd1 ...
md: created md0
md: bind<hdd1,1>
md: bind<hda1,2>
md: running: <hda1><hdd1>
md: hda1's event counter: 00000044
md: hdd1's event counter: 00000042
md: superblock update time inconsistency -- using the most recent one
md: freshest: hda1
md: kicking non-fresh hdd1 from array!
md: unbind<hdd1,1>
md: export_rdev(hdd1)
md: RAID level 1 does not need chunksize! Continuing anyway.
md0: max total readahead window set to 124k
md0: 1 data-disks, max readahead per data-disk: 124k
raid1: device hda1 operational as mirror 1
raid1: md0, not all disks are operational -- trying to recover array
raid1: raid set md0 active with 1 out of 2 mirrors
md: updating md0 RAID superblock on device
md: hda1 [events: 00000045]<6>(write) hda1's sb offset: 243537216
md: recovery thread got woken up ...
md0: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Freeing unused kernel memory: 156k freed
EXT3 FS 2.4-0.9.19, 19 August 2002 on md(9,0), internal journal
Adding Swap: 1574360k swap-space (priority -1)
Adding Swap: 1574360k swap-space (priority -2)
parport0: PC-style at 0x378 [PCSPP,TRISTATE]
ip_tables: (C) 2000-2002 Netfilter core team
Intel(R) PRO/1000 Network Driver - version 5.2.16
Copyright (c) 1999-2003 Intel Corporation.
divert: allocating divert_blk for eth0
eth0: Intel(R) PRO/1000 Network Connection
divert: allocating divert_blk for eth1
eth1: Intel(R) PRO/1000 Network Connection
e1000: eth0 NIC Link is Up 100 Mbps Full Duplex
md: trying to hot-add hdd1 to md0 ...
md: bind<hdd1,2>
RAID1 conf printout:
  --- wd:1 rd:2 nd:1
  disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 00:00]
  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hda1
  disk 2, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 4, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 5, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 6, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 7, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 8, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 9, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 10, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 11, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 12, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 13, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 14, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 15, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 16, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 17, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 18, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 19, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 20, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 21, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 22, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 23, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 24, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 25, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 26, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
RAID1 conf printout:
  --- wd:1 rd:2 nd:2
  disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 00:00]
  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hda1
  disk 2, s:1, o:0, n:2 rd:2 us:1 dev:hdd1
  disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 4, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 5, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 6, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 7, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 8, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 9, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 10, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 11, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 12, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 13, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 14, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 15, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 16, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 17, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 18, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 19, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 20, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 21, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 22, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 23, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 24, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 25, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 26, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
md: updating md0 RAID superblock on device
md: hdd1 [events: 00000046]<6>(write) hdd1's sb offset: 243537216
md: hda1 [events: 00000046]<6>(write) hda1's sb offset: 243537216
md: recovery thread got woken up ...
md0: resyncing spare disk hdd1 to replace failed disk
RAID1 conf printout:
  --- wd:1 rd:2 nd:2
  disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 00:00]
  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hda1
  disk 2, s:1, o:0, n:2 rd:2 us:1 dev:hdd1
  disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 4, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 5, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 6, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 7, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 8, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 9, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 10, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 11, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 12, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 13, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 14, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 15, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 16, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 17, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 18, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 19, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 20, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 21, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 22, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 23, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 24, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 25, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 26, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
RAID1 conf printout:
  --- wd:1 rd:2 nd:2
  disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 00:00]
  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hda1
  disk 2, s:1, o:1, n:2 rd:2 us:1 dev:hdd1
  disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 4, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 5, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 6, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 7, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 8, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 9, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 10, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 11, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 12, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 13, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 14, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 15, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 16, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 17, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 18, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 19, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 20, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 21, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 22, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 23, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 24, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 25, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
  disk 26, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 100000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 200000 
KB/sec) for reconstruction.
md: using 124k window, over a total of 243537216 blocks.


