From: Maurice Hilarius <maurice@harddata.com>
Subject: How to recover this RAID5?
Date: Sun, 08 Jun 2003 06:31:30 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.1.6.2.20030608061637.03bb34e0@mail.harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

Hi there.

I am a bit stumped on this one, and hope somebody can suggest a way to 
recover it.
The user has no backup, and hopes to recover data from this array.

Assistance would be deeply appreciated.

System has 4 IDE disks on a 3Ware 4 port.
RAID5.

One of the disks  apparently went offline without the user noticing.
Now the array is in a read-only state.
Probable cause is that these are WD 1800GB drives, and they have not had 
the WD patch applied, so probably drives started going to "sleep".

I provide some (hopefully) useful information:

In mdadm --examine I see that somehow the devices 1,2,3, have now been 
renamed to devices 4,5,6

And that 2 devices have become designated as spares.

This really puzzles me.



The data from mdadm --examine /dev/sd[abcd]1:

/dev/sda1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : eab4caa6:0149c628:28005703:5a107112
   Creation Time : Fri Oct 18 13:49:17 2002
      Raid Level : raid5
     Device Size : 175823296 (167.68 GiB 180.04 GB)
    Raid Devices : 4
   Total Devices : 2
Preferred Minor : 0

     Update Time : Fri Jun  6 10:42:12 2003
           State : dirty, no-errors
  Active Devices : 0
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 3
        Checksum : 9e47adf6 - correct
          Events : 0.174

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     4       8        1        4 
/dev/scsi/host0/bus0/target0/lun0/part1
    0     0       0        0        0      faulty removed
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       0        0        3      faulty removed
    4     4       8        1        4 
/dev/scsi/host0/bus0/target0/lun0/part1
    5     5       8       33        5 
/dev/scsi/host0/bus0/target2/lun0/part1
    6     6       8       49        6 
/dev/scsi/host0/bus0/target3/lun0/part1
/dev/sdb1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : eab4caa6:0149c628:28005703:5a107112
   Creation Time : Fri Oct 18 13:49:17 2002
      Raid Level : raid5
     Device Size : 175823296 (167.68 GiB 180.04 GB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 0

     Update Time : Fri Jun  6 10:39:21 2003
           State : dirty, no-errors
  Active Devices : 0
Working Devices : 1
  Failed Devices : 2
   Spare Devices : 2
        Checksum : 9e47ad58 - correct
          Events : 0.167

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     5       8       17        5 
/dev/scsi/host0/bus0/target1/lun0/part1
    0     0       8        1        0      faulty 
/dev/scsi/host0/bus0/target0/lun0/part1
    1     1       0        0        1      faulty removed
    2     2       8       33        2      faulty 
/dev/scsi/host0/bus0/target2/lun0/part1
    3     3       0        0        3      faulty removed
    4     4       8       49        4 
/dev/scsi/host0/bus0/target3/lun0/part1
    5     5       8       17        5 
/dev/scsi/host0/bus0/target1/lun0/part1
/dev/sdc1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : eab4caa6:0149c628:28005703:5a107112
   Creation Time : Fri Oct 18 13:49:17 2002
      Raid Level : raid5
     Device Size : 175823296 (167.68 GiB 180.04 GB)
    Raid Devices : 4
   Total Devices : 2
Preferred Minor : 0

     Update Time : Tue May 13 09:26:42 2003
           State : clean, no-errors
  Active Devices : 3
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 9e27f82c - correct
          Events : 0.174

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     2       8       33        2      active 
sync   /dev/scsi/host0/bus0/target2/lun0/part1
    0     0       8        1        0      active 
sync   /dev/scsi/host0/bus0/target0/lun0/part1
    1     1       8       17        1      active 
sync   /dev/scsi/host0/bus0/target1/lun0/part1
    2     2       8       33        2      active 
sync   /dev/scsi/host0/bus0/target2/lun0/part1
    3     3       0        0        3      faulty removed
/dev/sdd1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : eab4caa6:0149c628:28005703:5a107112
   Creation Time : Fri Oct 18 13:49:17 2002
      Raid Level : raid5
     Device Size : 175823296 (167.68 GiB 180.04 GB)
    Raid Devices : 4
   Total Devices : 2
Preferred Minor : 0

     Update Time : Fri Jun  6 10:42:12 2003
           State : dirty, no-errors
  Active Devices : 0
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 3
        Checksum : 9e47ae2a - correct
          Events : 0.174

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     6       8       49        6 
/dev/scsi/host0/bus0/target3/lun0/part1
    0     0       0        0        0      faulty removed
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       0        0        3      faulty removed
    4     4       8        1        4 
/dev/scsi/host0/bus0/target0/lun0/part1
    5     5       8       33        5 
/dev/scsi/host0/bus0/target2/lun0/part1
    6     6       8       49        6 
/dev/scsi/host0/bus0/target3/lun0/part1




Here is the contents of mdadm.conf:
DEVICE /dev/sd[abcd]1
ARRAY /dev/md0 level=raid5 num-devices=4 
UUID=eab4caa6:0149c628:28005703:5a107112



Here is the relevant part of dmesg:

.changing IO-APIC physical APIC ID to 9 ... ok.
Setting 10 in the phys_id_present_map
...changing IO-APIC physical APIC ID to 10 ... ok.
Setting 11 in the phys_id_present_map
...changing IO-APIC physical APIC ID to 11 ... ok.
init IO_APIC IRQs
  IO-APIC (apicid-pin) 8-0, 8-5, 8-9, 8-11, 9-0, 9-1, 9-3, 9-4, 9-5, 9-6, 
9-7, 9-8, 9-9, 9-10, 9-11, 9-12, 10-0, 10-1, 10-2, 10-3, 10-4, 10-5, 10-6, 
10-7, 10-8, 10-9, 10-10, 10-11, 10-12, 10-13, 10-14, 10-15, 11-0, 11-1, 
11-2, 11-3, 11-4, 11-5, 11-6, 11-7, 11-8, 11-9, 11-10, 11-11, 11-12, 11-13, 
11-14, 11-15 not connected.
..TIMER: vector=0x31 pin1=2 pin2=0
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found pin 0) ...works.
number of MP IRQ sources: 17.
number of IO-APIC #8 registers: 16.
number of IO-APIC #9 registers: 16.
number of IO-APIC #10 registers: 16.
number of IO-APIC #11 registers: 16.
testing the IO APIC.......................

IO APIC #8......
.... register #00: 08000000
.......    : physical APIC id: 08
.... register #01: 000F0011
.......     : max redirection entries: 000F
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 08000000
.......     : arbitration: 08
.... IRQ redirection table:
  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:
  00 00F 0F  0    0    0   0   0    1    1    31
  01 00F 0F  0    0    0   0   0    1    1    39
  02 000 00  1    0    0   0   0    0    0    00
  03 00F 0F  0    0    0   0   0    1    1    41
  04 00F 0F  0    0    0   0   0    1    1    49
  05 000 00  1    0    0   0   0    0    0    00
  06 00F 0F  0    0    0   0   0    1    1    51
  07 00F 0F  0    0    0   0   0    1    1    59
  08 00F 0F  0    0    0   0   0    1    1    61
  09 000 00  1    0    0   0   0    0    0    00
  0a 00F 0F  1    1    0   1   0    1    1    69
  0b 000 00  1    0    0   0   0    0    0    00
  0c 00F 0F  0    0    0   0   0    1    1    71
  0d 00F 0F  0    0    0   0   0    1    1    79
  0e 00F 0F  0    0    0   0   0    1    1    81
  0f 00F 0F  0    0    0   0   0    1    1    89

IO APIC #9......
.... register #00: 09000000
.......    : physical APIC id: 09
.... register #01: 000F0011
.......     : max redirection entries: 000F
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 09000000
.......     : arbitration: 09
.... IRQ redirection table:
  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:
  00 000 00  1    0    0   0   0    0    0    00
  01 000 00  1    0    0   0   0    0    0    00
  02 00F 0F  1    1    0   1   0    1    1    91
  03 000 00  1    0    0   0   0    0    0    00
  04 000 00  1    0    0   0   0    0    0    00
  05 000 00  1    0    0   0   0    0    0    00
  06 000 00  1    0    0   0   0    0    0    00
  07 000 00  1    0    0   0   0    0    0    00
  08 000 00  1    0    0   0   0    0    0    00
  09 000 00  1    0    0   0   0    0    0    00
  0a 000 00  1    0    0   0   0    0    0    00
  0b 000 00  1    0    0   0   0    0    0    00
  0c 000 00  1    0    0   0   0    0    0    00
  0d 00F 0F  1    1    0   1   0    1    1    99
  0e 00F 0F  1    1    0   1   0    1    1    A1
  0f 00F 0F  1    1    0   1   0    1    1    A9

IO APIC #10......
.... register #00: 0A000000
.......    : physical APIC id: 0A
.... register #01: 000F0011
.......     : max redirection entries: 000F
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 0A000000
.......     : arbitration: 0A
.... IRQ redirection table:
  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:
  00 000 00  1    0    0   0   0    0    0    00
  01 000 00  1    0    0   0   0    0    0    00
  02 000 00  1    0    0   0   0    0    0    00
  03 000 00  1    0    0   0   0    0    0    00
  04 000 00  1    0    0   0   0    0    0    00
  05 000 00  1    0    0   0   0    0    0    00
  06 000 00  1    0    0   0   0    0    0    00
  07 000 00  1    0    0   0   0    0    0    00
  08 000 00  1    0    0   0   0    0    0    00
  09 000 00  1    0    0   0   0    0    0    00
  0a 000 00  1    0    0   0   0    0    0    00
  0b 000 00  1    0    0   0   0    0    0    00
  0c 000 00  1    0    0   0   0    0    0    00
  0d 000 00  1    0    0   0   0    0    0    00
  0e 000 00  1    0    0   0   0    0    0    00
  0f 000 00  1    0    0   0   0    0    0    00

IO APIC #11......
.... register #00: 0B000000
.......    : physical APIC id: 0B
.... register #01: 000F0011
.......     : max redirection entries: 000F
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 0B000000
.......     : arbitration: 0B
.... IRQ redirection table:
  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:
  00 000 00  1    0    0   0   0    0    0    00
  01 000 00  1    0    0   0   0    0    0    00
  02 000 00  1    0    0   0   0    0    0    00
  03 000 00  1    0    0   0   0    0    0    00
  04 000 00  1    0    0   0   0    0    0    00
  05 000 00  1    0    0   0   0    0    0    00
  06 000 00  1    0    0   0   0    0    0    00
  07 000 00  1    0    0   0   0    0    0    00
  08 000 00  1    0    0   0   0    0    0    00
  09 000 00  1    0    0   0   0    0    0    00
  0a 000 00  1    0    0   0   0    0    0    00
  0b 000 00  1    0    0   0   0    0    0    00
  0c 000 00  1    0    0   0   0    0    0    00
  0d 000 00  1    0    0   0   0    0    0    00
  0e 000 00  1    0    0   0   0    0    0    00
  0f 000 00  1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ10 -> 0:10
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
IRQ18 -> 1:2
IRQ29 -> 1:13
IRQ30 -> 1:14
IRQ31 -> 1:15
.................................... done.
Using local APIC timer interrupts.
calibrating APIC timer ...
..... CPU clock speed is 1999.8335 MHz.
..... host bus clock speed is 99.9915 MHz.
cpu: 0, clocks: 999915, slice: 199983
CPU0<T0:999904,T1:799920,D:1,S:199983,C:999915>
cpu: 2, clocks: 999915, slice: 199983
cpu: 3, clocks: 999915, slice: 199983
cpu: 1, clocks: 999915, slice: 199983
CPU1<T0:999904,T1:599936,D:2,S:199983,C:999915>
CPU2<T0:999904,T1:399952,D:3,S:199983,C:999915>
CPU3<T0:999904,T1:199968,D:4,S:199983,C:999915>
checking TSC synchronization across CPUs: passed.
Waiting on wait_init_idle (map = 0xe)
All processors have done init_idle
PCI: PCI BIOS revision 2.10 entry at 0xfdba1, last bus=4
PCI: Using configuration type 1
PCI: Probing PCI hardware
PCI: Discovered primary peer bus 01 [IRQ]
PCI: Discovered primary peer bus 02 [IRQ]
PCI: Discovered primary peer bus 03 [IRQ]
PCI: Discovered primary peer bus 04 [IRQ]
PCI->APIC IRQ transform: (B0,I2,P0) -> 29
PCI->APIC IRQ transform: (B0,I4,P0) -> 30
PCI->APIC IRQ transform: (B0,I15,P0) -> 10
PCI->APIC IRQ transform: (B1,I3,P0) -> 31
PCI->APIC IRQ transform: (B3,I2,P0) -> 18
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16)
apm: disabled - APM is not SMP safe.
Starting kswapd
allocated 32 pages and 32 bhs reserved for the highmem bounces
VFS: Diskquotas version dquot_6.5.0 initialized
devfs: v1.12a (20020514) Richard Gooch (rgooch@atnf.csiro.au)
devfs: boot_options: 0x1
pty: 256 Unix98 ptys configured
Serial driver version 5.05c (2001-07-08) with HUB-6 MANY_PORTS MULTIPORT 
SHARE_IRQ SERIAL_PCI ISAPNP enabled
ttyS00 at 0x03f8 (irq = 4) is a 16550A
ttyS01 at 0x02f8 (irq = 3) is a 16550A
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ServerWorks CSB5: IDE controller on PCI bus 00 dev 79
ServerWorks CSB5: chipset revision 147
ServerWorks CSB5: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
     ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
hda: WDC WD200BB-75CAA0, ATA DISK drive
hdc: ATAPI-CD ROM-DRIVE-52MAX, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: setmax LBA 39063024, native  39062500
hda: 39062500 sectors (20000 MB) w/2048KiB Cache, CHS=2431/255/63, UDMA(33)
hdc: ATAPI 52X CD-ROM drive, 128kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.12
ide-floppy driver 0.99b
Partition check:
  /dev/ide/host0/bus0/target0/lun0: p1 p2 p3 p4 < p5 p6 p7 >
RAMDISK driver initialized: 16 RAM disks of 32000K size 1024 blocksize
ide-floppy driver 0.99b
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 8192 buckets, 64Kbytes
TCP: Hash tables configured (established 262144 bind 65536)
Linux IP multicast router 0.06 plus PIM-SM
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
RAMDISK: Compressed image found at block 0
Freeing initrd memory: 202k freed
EXT2-fs warning: checktime reached, running e2fsck is recommended
VFS: Mounted root (ext2 filesystem).
Mounted devfs on /dev
SCSI subsystem driver Revision: 1.00
3ware Storage Controller device driver for Linux v1.02.00.025.
scsi0 : Found a 3ware Storage Controller at 0xdfa0, IRQ: 18, P-chip: 1.3
scsi0 : 3ware Storage Controller
   Vendor: 3ware     Model: 3w-xxxx           Rev: 1.0
   Type:   Direct-Access                      ANSI SCSI revision: 00
   Vendor: 3ware     Model: 3w-xxxx           Rev: 1.0
   Type:   Direct-Access                      ANSI SCSI revision: 00
   Vendor: 3ware     Model: 3w-xxxx           Rev: 1.0
   Type:   Direct-Access                      ANSI SCSI revision: 00
   Vendor: 3ware     Model: 3w-xxxx           Rev: 1.0
   Type:   Direct-Access                      ANSI SCSI revision: 00
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
Attached scsi disk sdc at scsi0, channel 0, id 2, lun 0
Attached scsi disk sdd at scsi0, channel 0, id 3, lun 0
SCSI device sda: 351651888 512-byte hdwr sectors (180046 MB)
  /dev/scsi/host0/bus0/target0/lun0: p1
SCSI device sdb: 351651888 512-byte hdwr sectors (180046 MB)
  /dev/scsi/host0/bus0/target1/lun0: p1
SCSI device sdc: 351651888 512-byte hdwr sectors (180046 MB)
  /dev/scsi/host0/bus0/target2/lun0: p1
SCSI device sdd: 351651888 512-byte hdwr sectors (180046 MB)
  /dev/scsi/host0/bus0/target3/lun0: p1
Journalled Block Device driver loaded
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Mounted devfs on /dev
Freeing unused kernel memory: 148k freed
Real Time Clock Driver v1.10e
usb.c: registered new driver usbdevfs
usb.c: registered new driver hub
usb-ohci.c: USB OHCI at membase 0xf8867000, IRQ 10
usb-ohci.c: usb-00:0f.2, ServerWorks OSB4/CSB5 USB Controller
usb.c: new USB bus registered, assigned bus number 1
hub.c: USB hub found
hub.c: 4 ports detected
usbdevfs: remount parameter error
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,2), internal journal
Adding Swap: 1028152k swap-space (priority -1)
  [events: 000000ae]
  [events: 000000ae]
  [events: 000000ae]
md: autorun ...
md: considering scsi/host0/bus0/target3/lun0/part1 ...
md:  adding scsi/host0/bus0/target3/lun0/part1 ...
md:  adding scsi/host0/bus0/target2/lun0/part1 ...
md:  adding scsi/host0/bus0/target0/lun0/part1 ...
md: created md0
md: bind<scsi/host0/bus0/target0/lun0/part1,1>
md: bind<scsi/host0/bus0/target2/lun0/part1,2>
md: bind<scsi/host0/bus0/target3/lun0/part1,3>
md: running: 
<scsi/host0/bus0/target3/lun0/part1><scsi/host0/bus0/target2/lun0/part1><scsi/host0/bus0/target0/lun0/part1>
md: scsi/host0/bus0/target3/lun0/part1's event counter: 000000ae
md: scsi/host0/bus0/target2/lun0/part1's event counter: 000000ae
md: scsi/host0/bus0/target0/lun0/part1's event counter: 000000ae
md0: kicking faulty scsi/host0/bus0/target2/lun0/part1!
md: unbind<scsi/host0/bus0/target2/lun0/part1,2>
md: export_rdev(scsi/host0/bus0/target2/lun0/part1)
md0: former device scsi/host0/bus0/target2/lun0/part1 is unavailable, 
removing from array!
md: md0: raid array is not clean -- starting background reconstruction
raid5: measuring checksumming speed
    8regs     :  2390.400 MB/sec
    32regs    :  1439.600 MB/sec
    pII_mmx   :  2298.000 MB/sec
    p5_mmx    :  2352.000 MB/sec
raid5: using function: 8regs (2390.400 MB/sec)
md: raid5 personality registered as nr 4
md0: max total readahead window set to 768k
md0: 3 data-disks, max readahead per data-disk: 256k
raid5: spare disk scsi/host0/bus0/target3/lun0/part1
raid5: spare disk scsi/host0/bus0/target0/lun0/part1
raid5: not enough operational devices for md0 (4/4 failed)
RAID5 conf printout:
  --- rd:4 wd:0 fd:4
  disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 00:00]
  disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev 00:00]
  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:[dev 00:00]
raid5: failed to run raid set md0
md: pers->run() failed ...
md :do_md_run() returned -22
md: md0 stopped.
md: unbind<scsi/host0/bus0/target3/lun0/part1,1>
md: export_rdev(scsi/host0/bus0/target3/lun0/part1)
md: unbind<scsi/host0/bus0/target0/lun0/part1,0>
md: export_rdev(scsi/host0/bus0/target0/lun0/part1)
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,1), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,6), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,7), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,5), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
tg3.c:v0.99 (Jun 11, 2002)
eth0: Tigon3 [partno(BCM95700A6) rev 0105 PHY(5701)] (PCIX:100MHz:64-bit) 
10/100/1000BaseT Ethernet 00:30:48:51:4f:e5
eepro100.c:v1.09j-t 9/29/99 Donald Becker 
http://www.scyld.com/network/eepro100.html
eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V. Savochkin 
<saw@saw.sw.com.sg> and others
eth1: OEM i82557/i82558 10/100 Ethernet, 00:30:48:51:50:B5, IRQ 30.
   Board assembly 000000-000, Physical connectors present: RJ45
   Primary interface chip i82555 PHY #1.
   General self-test: passed.
   Serial sub-system self-test: passed.
   Internal registers self-test: passed.
   ROM checksum self-test: passed (0xb874c1d3).
IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
IPVS: Each connection entry needs 120 bytes at least
IPVS: ipvs loaded.
ip_tables: (C) 2000-2002 Netfilter core team
ip_conntrack version 2.1 (8191 buckets, 65528 max) - 300 bytes per conntrack
eth0: Link is up at 100 Mbps, full duplex.
eth0: Flow control is on for TX and on for RX.
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
parport0: irq 7 detected
lp0: using parport0 (polling).
  [events: 000000ae]
md: bind<scsi/host0/bus0/target0/lun0/part1,1>
  [events: 000000a7]
md: bind<scsi/host0/bus0/target1/lun0/part1,2>
  [events: 000000ae]
md: bind<scsi/host0/bus0/target3/lun0/part1,3>
  [events: 000000ae]
md: bind<scsi/host0/bus0/target2/lun0/part1,4>


Snippet from /var/log/messages when attempting to start the array:

Jun  6 16:41:12 afhe-shared  -- root[2057]: ROOT LOGIN ON vc/2
Jun  6 16:41:43 afhe-shared kernel:  [events: 000000ae]
Jun  6 16:41:43 afhe-shared kernel: md: 
bind<scsi/host0/bus0/target0/lun0/part1,1>
Jun  6 16:41:43 afhe-shared kernel:  [events: 000000a7]
Jun  6 16:41:43 afhe-shared kernel: md: 
bind<scsi/host0/bus0/target1/lun0/part1,2>
Jun  6 16:41:43 afhe-shared kernel:  [events: 000000ae]
Jun  6 16:41:43 afhe-shared kernel: md: 
bind<scsi/host0/bus0/target3/lun0/part1,3>
Jun  6 16:41:43 afhe-shared kernel:  [events: 000000ae]
Jun  6 16:41:43 afhe-shared kernel: md: 
bind<scsi/host0/bus0/target2/lun0/part1,4>
Jun  6 16:42:14 afhe-shared ntpd[1494]: kernel time discipline status change 41
Jun  6 16:44:24 afhe-shared kernel: md: md0 stopped.
Jun  6 16:44:24 afhe-shared kernel: md: 
unbind<scsi/host0/bus0/target2/lun0/part1,3>
Jun  6 16:44:24 afhe-shared kernel: md: 
export_rdev(scsi/host0/bus0/target2/lun0/part1)
Jun  6 16:44:24 afhe-shared kernel: md: 
unbind<scsi/host0/bus0/target3/lun0/part1,2>
Jun  6 16:44:24 afhe-shared kernel: md: 
export_rdev(scsi/host0/bus0/target3/lun0/part1)
Jun  6 16:44:24 afhe-shared kernel: md: 
unbind<scsi/host0/bus0/target1/lun0/part1,1>
Jun  6 16:44:24 afhe-shared kernel: md: 
export_rdev(scsi/host0/bus0/target1/lun0/part1)
Jun  6 16:44:24 afhe-shared kernel: md: 
unbind<scsi/host0/bus0/target0/lun0/part1,0>
Jun  6 16:44:24 afhe-shared kernel: md: 
export_rdev(scsi/host0/bus0/target0/lun0/part1)
Jun  6 16:44:24 afhe-shared kernel:  [events: 000000ae]
Jun  6 16:44:24 afhe-shared kernel: md: 
bind<scsi/host0/bus0/target0/lun0/part1,1>
Jun  6 16:44:24 afhe-shared kernel:  [events: 000000a7]
Jun  6 16:44:24 afhe-shared kernel: md: 
bind<scsi/host0/bus0/target1/lun0/part1,2>
Jun  6 16:44:24 afhe-shared kernel:  [events: 000000ae]
Jun  6 16:44:24 afhe-shared kernel: md: 
bind<scsi/host0/bus0/target3/lun0/part1,3>
Jun  6 16:44:24 afhe-shared kernel:  [events: 000000ae]
Jun  6 16:44:24 afhe-shared kernel: md: 
bind<scsi/host0/bus0/target2/lun0/part1,4>


With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

