From: "Michael Fritscher" <michael@fritscher.net>
Subject: How can I reassemble a raid1 on a intel fake raid?
Date: Fri, 12 Jan 2018 17:05:14 +0100
Message-ID: <7ea51b30569c6336c261b295bb729ce1.squirrel@mifritscher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

following situation:

I've a degraded raid1 on a Intel fake raid. I could add the new hdd (sdb)
to imsm0, (via mdadm -a /dev/md/imsm0 /dev/sdb). But the members (Volume0
and Volume1) don't recover.

How can I add the new hdd to the Volumes, or start the recovery process?

Best regards,
Michael Fritscher

P.S. Some information:

mdadm --detail-platform
       Platform : Intel(R) Matrix Storage Manager
        Version : 3.8.0.1029
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
    2TB volumes : supported
      2TB disks : supported
      Max Disks : 6
    Max Volumes : 2 per array, 4 per controller
 I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)


 mdadm -D /dev/md/imsm0
/dev/md/imsm0:
        Version : imsm
     Raid Level : container
  Total Devices : 2

Working Devices : 2


           UUID : 0d38713d:240d5ca5:f976eea2:bfef17fd
  Member Arrays : /dev/md/Volume0 /dev/md/Volume1

    Number   Major   Minor   RaidDevice

       0       8        0        -        /dev/sda
       1       8       16        -        /dev/sdb


mdadm -D /dev/md/Volume0
/dev/md/Volume0:
      Container : /dev/md/imsm0, member 0
     Raid Level : raid1
     Array Size : 209715200 (200.00 GiB 214.75 GB)
  Used Dev Size : 209715332 (200.00 GiB 214.75 GB)
   Raid Devices : 2
  Total Devices : 1

          State : active, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0


           UUID : 04a31212:5e0aed99:337daf5d:7490ac15
    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       0       8        0        1      active sync   /dev/sda



 mdadm -D /dev/md/Volume1
/dev/md/Volume1:
      Container : /dev/md/imsm0, member 1
     Raid Level : raid1
     Array Size : 2584526848 (2464.80 GiB 2646.56 GB)
  Used Dev Size : 2584526980 (2464.80 GiB 2646.56 GB)
   Raid Devices : 2
  Total Devices : 1

          State : active, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0


           UUID : 372289a3:a7140a30:5d55f763:838ead57
    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       0       8        0        1      active sync   /dev/sda



mdadm -E /dev/sda
/dev/sda:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.3.00
    Orig Family : f35ec703
         Family : f35ecbf3
     Generation : 01ddd061
     Attributes : All supported
           UUID : 0d38713d:240d5ca5:f976eea2:bfef17fd
       Checksum : 1cf91fa0 correct
    MPB Sectors : 2
          Disks : 2
   RAID Devices : 2

  Disk01 Serial : WD-WCC131047561
          State : active
             Id : 00000003
    Usable Size : 5860526862 (2794.52 GiB 3000.59 GB)

[Volume0]:
           UUID : 04a31212:5e0aed99:337daf5d:7490ac15
     RAID Level : 1
        Members : 2
          Slots : [_U]
    Failed disk : 0
      This Slot : 1
     Array Size : 419430400 (200.00 GiB 214.75 GB)
   Per Dev Size : 419430664 (200.00 GiB 214.75 GB)
  Sector Offset : 0
    Num Stripes : 1638400
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : idle
      Map State : degraded
    Dirty State : dirty

[Volume1]:
           UUID : 372289a3:a7140a30:5d55f763:838ead57
     RAID Level : 1
        Members : 2
          Slots : [_U]
    Failed disk : 0
      This Slot : 1
     Array Size : 5169053696 (2464.80 GiB 2646.56 GB)
   Per Dev Size : 5169053960 (2464.80 GiB 2646.56 GB)
  Sector Offset : 419434760
    Num Stripes : 20191616
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : idle
      Map State : degraded
    Dirty State : dirty

  Disk00 Serial : D-WCC131051461:0
          State : active failed
             Id : ffffffff
    Usable Size : 18446744073709545310



mdadm -E /dev/sdb
/dev/sdb:
   MBR Magic : aa55
Partition[0] :    419426304 sectors at         2048 (type 07)


cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md125 : active raid1 sda[0]
      209715200 blocks super external:/md127/0 [2/1] [_U]

md126 : active raid1 sda[0]
      2584526848 blocks super external:/md127/1 [2/1] [_U]

md127 : inactive sdb[1](S) sda[0](S)
      6306 blocks super external:imsm

unused devices: <none>


lspci
00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v3 Processor DRAM
Controller (rev 06)
00:14.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
Family USB xHCI (rev 04)
00:1a.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
Family USB EHCI #2 (rev 04)
00:1c.0 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family
PCI Express Root Port #1 (rev d4)
00:1c.1 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family
PCI Express Root Port #2 (rev d4)
00:1c.2 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family
PCI Express Root Port #3 (rev d4)
00:1c.3 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family
PCI Express Root Port #4 (rev d4)
00:1c.4 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family
PCI Express Root Port #5 (rev d4)
00:1d.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
Family USB EHCI #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation C222 Series Chipset Family Server
Essential SKU LPC Controller (rev 04)
00:1f.2 RAID bus controller: Intel Corporation C600/X79 series chipset
SATA RAID Controller (rev 04)
00:1f.3 SMBus: Intel Corporation 8 Series/C220 Series Chipset Family SMBus
Controller (rev 04)
00:1f.6 Signal processing controller: Intel Corporation 8 Series Chipset
Family Thermal Management Controller (rev 04)
01:00.0 PCI bridge: ASPEED Technology, Inc. AST1150 PCI-to-PCI Bridge (rev
03)
02:00.0 VGA compatible controller: ASPEED Technology, Inc. ASPEED Graphics
Family (rev 30)
03:00.0 PCI bridge: ASMedia Technology Inc. ASM1083/1085 PCIe to PCI
Bridge (rev 03)
05:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network
Connection (rev 03)
06:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network
Connection (rev 03)
07:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller
(rev 04)


