From: Nix <nix@go-nix.ca>
Subject: pdc20276 /dev/ataraid/disc2 problem
Date: 19 Aug 2003 02:08:17 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1061280497.26030.5.camel@tux.go-nix.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi !

I have emailed the ATARAID maintainer about this but alas - no response.

I have a pdc20276 controller with a MBFastTrak133 "Lite" BIOS Version
2.00.0.20 (as reported on bootup).  I have created a RAID0 array using
my primary master and secondary master drives.  The other two are set
via RAID0 where only one drive is involved, because the stupid
controller wouldn't let me created another striped array consisting of
the primary slave and the secondary slave.  However, I would like to use
software RAID (via mkraid/raidstart/raidstop) to create a RAID0 array. 
Unfortunately, for some reason, Linux doesn't "see" one of the slave
drives, because under /dev/ataraid (with devfs on) I only have
/dev/ataraid/disc0 (which is the proper RAID0 consisting of the master
drives), and /dev/ataraid/disc1 (one of the slave drives).

Where is the other slave drive ? Shouldn't there be a /dev/ataraid/disc2
?  dmesg doesn't seem to think so.  Could it have something to do with
that star next to ID = 3 in the BIOS output (please see below) ?

Anyway, the relevant information follows:

From the bootup process:

MBFastTrak (tm) "Lite" BIOS Version 2.00.0.20
Some copyright message

===================================================
ID    Mode        Size    Track-Mapping  Status
1     2+0 Stripe  40839M  4965/255/63    Functional
2     1+0 Stripe  39999M  4862/255/63    Functional
3 *   1+0 Stripe  39999M  4862/255/63    Functional

From dmesg:

Linux version 2.4.21 (root@(none)) (gcc version 3.2.3 20030422 (Gentoo
Linux 1.4 3.2.3-r1, propolice)) #5 SMP Sat Aug 2 09:17:07 MDT 2003
...
PDC20276: IDE controller at PCI slot 02:0c.0
PCI: Found IRQ 11 for device 02:0c.0
PCI: Sharing IRQ 11 with 02:04.0
PDC20276: chipset revision 1
PDC20276: not 100% native mode: will probe irqs later
    ide2: BM-DMA at 0xb000-0xb007, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0xb008-0xb00f, BIOS settings: hdg:pio, hdh:pio
...
hde: Maxtor 52049H4, ATA DISK drive
hdf: WDC WD400BB-75CAA0, ATA DISK drive
blk: queue c0323148, I/O limit 4095Mb (mask 0xffffffff)
blk: queue c0323294, I/O limit 4095Mb (mask 0xffffffff)
hdg: Maxtor 52049H4, ATA DISK drive
hdh: WDC WD400BB-75CAA0, ATA DISK drive
blk: queue c03235bc, I/O limit 4095Mb (mask 0xffffffff)
blk: queue c0323708, I/O limit 4095Mb (mask 0xffffffff)
...
ide2 at 0xa000-0xa007,0xa402 on irq 11
ide3 at 0xa800-0xa807,0xac02 on irq 11
...
hde: attached ide-disk driver.
hde: host protected area => 1
hde: 39882528 sectors (20420 MB) w/2048KiB Cache, CHS=39566/16/63,
UDMA(100)
hdf: attached ide-disk driver.
hdf: host protected area => 1
hdf: setmax LBA 78125040, native  78125000
hdf: 78125000 sectors (40000 MB) w/2048KiB Cache, CHS=77504/16/63,
UDMA(100)
hdg: attached ide-disk driver.
hdg: host protected area => 1
hdg: 39882528 sectors (20420 MB) w/2048KiB Cache, CHS=39566/16/63,
UDMA(100)
hdh: attached ide-disk driver.
hdh: host protected area => 1
hdh: setmax LBA 78125040, native  78125000
hdh: 78125000 sectors (40000 MB) w/2048KiB Cache, CHS=77504/16/63,
UDMA(100)
Partition check:
 /dev/ide/host0/bus0/target0/lun0: p1
 /dev/ide/host2/bus0/target0/lun0: p1 p2
 /dev/ide/host2/bus0/target1/lun0: unknown partition table
 /dev/ide/host2/bus1/target0/lun0: unknown partition table
 /dev/ide/host2/bus1/target1/lun0:
 ataraid/d0: p1 p2
Drive 0 is 19473 Mb (33 / 0)
Drive 1 is 19473 Mb (34 / 0)
Raid0 array consists of 2 drives.
 ataraid/d1:
Drive 0 is 38146 Mb (34 / 64)
Raid0 array consists of 1 drives.
Promise Fasttrak(tm) Softwareraid driver for linux version 0.03beta

From lspci -vv:

02:0c.0 RAID bus controller: Promise Technology, Inc. PDC20276 IDE (rev
01) (prog-if 85)
        Subsystem: Promise Technology, Inc.: Unknown device 1275
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (1000ns min, 4500ns max), cache line size 08
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at a000 [size=8]
        Region 1: I/O ports at a400 [size=4]
        Region 2: I/O ports at a800 [size=8]
        Region 3: I/O ports at ac00 [size=4]
        Region 4: I/O ports at b000 [size=16]
        Region 5: Memory at eb020000 (32-bit, non-prefetchable)
[size=16K]
        Capabilities: [60] Power Management version 1
                Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Alternatively, is there some way to circumvent the BIOS and create a
proper ataraid-based RAID0 out of the two slave drives ?



TIA

