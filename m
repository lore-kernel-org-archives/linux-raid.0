From: Pol Hallen <raid1@fuckaround.org>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Mon, 18 Jul 2011 13:52:59 +0200
Message-ID: <201107181352.59893.raid1@fuckaround.org>
References: <201107162140.58883.raid1@fuckaround.org> <ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org> <4E236A2D.3070307@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_b6BJOwgYP3vEmKe"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E236A2D.3070307@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Boundary-00=_b6BJOwgYP3vEmKe
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

> Then you have multiple problems causing poor performance.  Now is the
> time for you to post your  hardware configuration, drive model
> number(s), mdadm config, and filesystem.  You should have done all of
> this in your initial post.

hello and sorry for the late :-(

now is a resync in progress, I can't stop it. Try /usr/share/mdadm/checkarray 
-x md0 but nothing..

fs is ext3 (done less 10 days ago)

> You've been on this list long enough to have known of the WD Green
> sector alignment issue and avoided it, and to know better than to run
> performance tests while an array is still in its initial sync.  Thus I
> initially assumed your problem was merely the insane dd block size.

when I wrote a post there was not resync in progress..

tell me if you need known other things, thanks

Pol

--Boundary-00=_b6BJOwgYP3vEmKe
Content-Type: text/plain;
  charset="UTF-8";
  name="mdadm.conf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mdadm.conf"

# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR pol@yahoo.it

# definitions of existing MD arrays

# This file was auto-generated on Fri, 08 Jul 2011 14:37:51 -0700
# by mkconf 3.1.4-1+8efb9d1


--Boundary-00=_b6BJOwgYP3vEmKe
Content-Type: text/plain;
  charset="UTF-8";
  name="sdb"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sdb"

smartctl 5.40 2010-07-12 r3124 [i686-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.11 family
Device Model:     ST31500341AS
Serial Number:    9VS4PSG9
Firmware Version: CC1H
User Capacity:    1,500,301,910,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Mon Jul 18 13:44:52 2011 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled


--Boundary-00=_b6BJOwgYP3vEmKe
Content-Type: text/plain;
  charset="UTF-8";
  name="mdadm-d"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mdadm-d"

/dev/md0:
        Version : 1.2
  Creation Time : Fri Jul  8 23:52:13 2011
     Raid Level : raid5
     Array Size : 5860538368 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 1465134592 (1397.26 GiB 1500.30 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Mon Jul 18 13:14:04 2011
          State : active, resyncing
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

 Rebuild Status : 33% complete

           Name : smooth:0  (local to host smooth)
           UUID : bfca3ad6:a7df5fa5:20ba4933:55fd4181
         Events : 6212

    Number   Major   Minor   RaidDevice State
       0       8       64        0      active sync   /dev/sde
       1       8       97        1      active sync   /dev/sdg1
       2       8      113        2      active sync   /dev/sdh1
       3       8      129        3      active sync   /dev/sdi1
       5       8       81        4      active sync   /dev/sdf1

--Boundary-00=_b6BJOwgYP3vEmKe
Content-Type: text/plain;
  charset="UTF-8";
  name="sdc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sdc"

smartctl 5.40 2010-07-12 r3124 [i686-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.11 family
Device Model:     ST31500341AS
Serial Number:    9VS3KL49
Firmware Version: CC1H
User Capacity:    1,500,301,910,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Mon Jul 18 13:45:00 2011 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled


--Boundary-00=_b6BJOwgYP3vEmKe
Content-Type: text/plain;
  charset="UTF-8";
  name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci"

00:00.0 Host bridge: Intel Corporation 5520 I/O Hub to ESI Port (rev 22)
	Subsystem: Super Micro Computer Inc Device a880
	Flags: fast devsel
	Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot-), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Access Control Services
	Capabilities: [160] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>

00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 1 (rev 22) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
	Capabilities: [40] Subsystem: Super Micro Computer Inc Device a880
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Access Control Services
	Capabilities: [160] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Kernel driver in use: pcieport

00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 3 (rev 22) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: faf00000-faffffff
	Prefetchable memory behind bridge: 00000000d8000000-00000000dfffffff
	Capabilities: [40] Subsystem: Super Micro Computer Inc Device a880
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Access Control Services
	Capabilities: [160] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Kernel driver in use: pcieport

00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 7 (rev 22) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	Capabilities: [40] Subsystem: Super Micro Computer Inc Device a880
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Access Control Services
	Capabilities: [160] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Kernel driver in use: pcieport

00:0e.0 Host bridge: Intel Corporation Device 341c (rev 22)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [60] #00 [0000]
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=0 Len=0b8 <?>

00:0e.1 Host bridge: Intel Corporation Device 341d (rev 22)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [60] #00 [0000]

00:0e.2 Host bridge: Intel Corporation Device 341e (rev 22)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [60] #00 [0000]

00:13.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller (rev 22) (prog-if 20 [IO(X)-APIC])
	Flags: bus master, fast devsel, latency 0
	Memory at fec8a000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [6c] Power Management version 3

00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management Registers (rev 22) (prog-if 00 [8259])
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers (rev 22) (prog-if 00 [8259])
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers (rev 22) (prog-if 00 [8259])
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers (rev 22) (prog-if 00 [8259])
	Flags: fast devsel

00:16.0 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, fast devsel, latency 0, IRQ 43
	Memory at faaec000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.1 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, fast devsel, latency 0, IRQ 44
	Memory at faae8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.2 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, fast devsel, latency 0, IRQ 45
	Memory at faae4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.3 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, fast devsel, latency 0, IRQ 46
	Memory at faae0000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.4 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, fast devsel, latency 0, IRQ 43
	Memory at faadc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.5 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, fast devsel, latency 0, IRQ 44
	Memory at faad8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.6 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, fast devsel, latency 0, IRQ 45
	Memory at faad4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:16.7 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, fast devsel, latency 0, IRQ 46
	Memory at faad0000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3
	Kernel driver in use: ioatdma

00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at aea0 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at ae80 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at ae20 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2 (prog-if 20 [EHCI])
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, medium devsel, latency 0, IRQ 18
	Memory at faaf4000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio Controller
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, fast devsel, latency 0, IRQ 81
	Memory at faaf0000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Root Complex Link
	Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 1 (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: c0400000-c05fffff
	Prefetchable memory behind bridge: 00000000c0600000-00000000c07fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Super Micro Computer Inc Device a880
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 5 (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fad00000-fadfffff
	Prefetchable memory behind bridge: 00000000c0200000-00000000c03fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Super Micro Computer Inc Device a880
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 6 (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fae00000-faefffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000c01fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Super Micro Computer Inc Device a880
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at af20 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at af00 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at aec0 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1 (prog-if 20 [EHCI])
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at faaf6000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: fab00000-facfffff
	Capabilities: [50] Subsystem: Super Micro Computer Inc Device a880

00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI Controller (prog-if 01 [AHCI 1.0])
	Subsystem: Super Micro Computer Inc Device a880
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 71
	I/O ports at aff0 [size=8]
	I/O ports at afac [size=4]
	I/O ports at afe0 [size=8]
	I/O ports at afa8 [size=4]
	I/O ports at af80 [size=32]
	Memory at faafe000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
	Capabilities: [70] Power Management version 3
	Capabilities: [a8] SATA HBA v1.0
	Capabilities: [b0] PCI Advanced Features
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
	Subsystem: Super Micro Computer Inc Device a880
	Flags: medium devsel, IRQ 18
	Memory at faafc000 (64-bit, non-prefetchable) [size=256]
	I/O ports at 0400 [size=32]
	Kernel driver in use: i801_smbus

01:02.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
	Subsystem: Super Micro Computer Inc Device 1411
	Flags: bus master, medium devsel, latency 64, IRQ 18
	Memory at fabf7800 (32-bit, non-prefetchable) [size=2K]
	Memory at fabf8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: firewire_ohci

01:05.0 RAID bus controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] Serial ATA Controller (rev 02)
	Subsystem: Silicon Image, Inc. Device 7114
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 19
	I/O ports at bb90 [size=8]
	I/O ports at bb88 [size=4]
	I/O ports at bb98 [size=8]
	I/O ports at bb8c [size=4]
	I/O ports at bba0 [size=16]
	Memory at fabffc00 (32-bit, non-prefetchable) [size=1K]
	Expansion ROM at fac00000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 2
	Kernel driver in use: sata_sil

01:06.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado] (rev 78)
	Subsystem: 3Com Corporation 3C905CX-TX/TX-M Fast Etherlink for PC Management NIC
	Flags: bus master, medium devsel, latency 64, IRQ 17
	I/O ports at bc00 [size=128]
	Memory at facdfc00 (32-bit, non-prefetchable) [size=128]
	Expansion ROM at face0000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
	Kernel driver in use: 3c59x

03:00.0 Ethernet controller: Intel Corporation 82573E Gigabit Ethernet Controller (Copper) (rev 03)
	Subsystem: Super Micro Computer Inc Device 108c
	Flags: bus master, fast devsel, latency 0, IRQ 70
	Memory at fade0000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at cf80 [size=32]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [e0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number 00-25-90-ff-ff-24-d1-e4
	Kernel driver in use: e1000e

04:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
	Subsystem: Super Micro Computer Inc Device 109a
	Flags: bus master, fast devsel, latency 0, IRQ 72
	Memory at faee0000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at df80 [size=32]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [e0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number 00-25-90-ff-ff-24-d1-e5
	Kernel driver in use: e1000e

06:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 [Radeon X300 (PCIE)] (prog-if 00 [VGA controller])
	Subsystem: PC Partner Limited Radeon X300 (PCIE)
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at d8000000 (32-bit, prefetchable) [size=128M]
	I/O ports at e000 [size=256]
	Memory at fafd0000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at fafe0000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Express Endpoint, MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [100] Advanced Error Reporting

06:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
	Subsystem: PC Partner Limited Radeon X300SE
	Flags: bus master, fast devsel, latency 0
	Memory at fafc0000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Express Endpoint, MSI 00


--Boundary-00=_b6BJOwgYP3vEmKe
Content-Type: text/plain;
  charset="UTF-8";
  name="sde"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sde"

smartctl 5.40 2010-07-12 r3124 [i686-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green (Adv. Format) family
Device Model:     WDC WD20EARS-00MVWB0
Serial Number:    WD-WCAZA6281995
Firmware Version: 51.0AB51
User Capacity:    2,000,398,934,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Jul 18 13:45:07 2011 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled


--Boundary-00=_b6BJOwgYP3vEmKe
Content-Type: text/plain;
  charset="UTF-8";
  name="sdd"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sdd"

smartctl 5.40 2010-07-12 r3124 [i686-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.12 family
Device Model:     ST3500418AS
Serial Number:    9VM1WK4N
Firmware Version: CC46
User Capacity:    500,107,862,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Mon Jul 18 13:45:03 2011 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled


--Boundary-00=_b6BJOwgYP3vEmKe
Content-Type: text/plain;
  charset="UTF-8";
  name="sdf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sdf"

smartctl 5.40 2010-07-12 r3124 [i686-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green (Adv. Format) family
Device Model:     WDC WD20EARS-00MVWB0
Serial Number:    WD-WCAZA5510079
Firmware Version: 51.0AB51
User Capacity:    2,000,398,934,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Jul 18 13:45:12 2011 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled


--Boundary-00=_b6BJOwgYP3vEmKe--
