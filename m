From: mjstumpf <mjstumpf@cotse.net>
Subject: interesting.. 3 ultra100's in a single machine.
Date: Tue, 26 Aug 2003 20:03:45 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bWpzdHVtcGY=.254ac9008589697ad5af666673e0a19e@1061942625.cotse.net>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In investigating something else, I discovered today I've been using 3
ultra 100's (all pdc20267, flashed to bios level 2.20.0.14.. though one is
branded Maxtor I think this is irrelevant) successfully with raid 5 & LVM
for quite some time now.  Supposedly, this isn't possible!?

I bounced a question to Promise regarding what the specific limitations
actually are.  Their initial answer was "1 per system", so I escalated. 
Will bounce their answer here.

Here's the bootlog from the machine.  The only difference I see is that
UDMA burst bit is disabled on the third controller.  Not sure what that
would mean in real-world-effect.

-----

Real Time Clock Driver v1.10e
Uniform Multi-Platform E-IDE driver Revision: 6.31
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller on PCI bus 00 dev 21
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xd800-0xd807, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xd808-0xd80f, BIOS settings: hdc:pio, hdd:pio
PDC20267: IDE controller on PCI bus 00 dev 50
PCI: Found IRQ 12 for device 00:0a.0
PDC20267: chipset revision 2
PDC20267: not 100% native mode: will probe irqs later
PDC20267: (U)DMA Burst Bit ENABLED Primary PCI Mode Secondary PCI Mode.
    ide2: BM-DMA at 0xa400-0xa407, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0xa408-0xa40f, BIOS settings: hdg:pio, hdh:pio
PDC20267: IDE controller on PCI bus 00 dev 58
PCI: Found IRQ 10 for device 00:0b.0
PDC20267: chipset revision 2
PDC20267: not 100% native mode: will probe irqs later
PDC20267: (U)DMA Burst Bit ENABLED Primary PCI Mode Secondary PCI Mode.
    ide4: BM-DMA at 0x8800-0x8807, BIOS settings: hdi:pio, hdj:pio
    ide5: BM-DMA at 0x8808-0x880f, BIOS settings: hdk:pio, hdl:pio
PDC20267: IDE controller on PCI bus 00 dev 60
PCI: Found IRQ 11 for device 00:0c.0
PDC20267: chipset revision 2
PDC20267: not 100% native mode: will probe irqs later
PDC20267: (U)DMA Burst Bit DISABLED Primary PCI Mode Secondary PCI Mode.
    ide6: BM-DMA at 0x7000-0x7007, BIOS settings: hdm:pio, hdn:pio
    ide7: BM-DMA at 0x7008-0x700f, BIOS settings: hdo:pio, hdp:pio
hde: WDC WD1000BB-00CAA1, ATA DISK drive
hdg: Maxtor 98196H8, ATA DISK drive
hdh: Maxtor 98196H8, ATA DISK drive
hdi: Maxtor 98196H8, ATA DISK drive
hdk: Maxtor 98196H8, ATA DISK drive
hdl: WDC WD2000JB-00DUA0, ATA DISK drive
hdm: WDC WD1200JB-75CRA0, ATA DISK drive
hdn: WDC WD1200JB-75CRA0, ATA DISK drive
hdo: WDC WD1200JB-75CRA0, ATA DISK drive
hdp: WDC WD1200JB-75CRA0, ATA DISK drive
ide2 at 0xb800-0xb807,0xb402 on irq 12
ide3 at 0xb000-0xb007,0xa802 on irq 12
ide4 at 0xa000-0xa007,0x9802 on irq 10
ide5 at 0x9400-0x9407,0x9002 on irq 10
ide6 at 0x8400-0x8407,0x8002 on irq 11
ide7 at 0x7800-0x7807,0x7402 on irq 11
blk: queue c03ebf0c, I/O limit 4095Mb (mask 0xffffffff)
hde: 195371568 sectors (100030 MB) w/2048KiB Cache, CHS=193821/16/63,
UDMA(100)
blk: queue c03ec250, I/O limit 4095Mb (mask 0xffffffff)
hdg: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=155061/16/63,
UDMA(100)
blk: queue c03ec38c, I/O limit 4095Mb (mask 0xffffffff)
hdh: 156250000 sectors (80000 MB) w/2048KiB Cache, CHS=155009/16/63,
UDMA(100)
blk: queue c03ec594, I/O limit 4095Mb (mask 0xffffffff)
hdi: 156250000 sectors (80000 MB) w/2048KiB Cache, CHS=155009/16/63,
UDMA(100)
blk: queue c03ec8d8, I/O limit 4095Mb (mask 0xffffffff)
hdk: 160086528 sectors (81964 MB) w/2048KiB Cache, CHS=158816/16/63,
UDMA(100)
blk: queue c03eca14, I/O limit 4095Mb (mask 0xffffffff)
hdl: 390721968 sectors (200050 MB) w/8192KiB Cache, CHS=24321/255/63,
UDMA(100)
blk: queue c03ecc1c, I/O limit 4095Mb (mask 0xffffffff)
hdm: setmax LBA 234441648, native  234375000
hdm: 234375000 sectors (120000 MB) w/8192KiB Cache, CHS=232514/16/63,
UDMA(100)
blk: queue c03ecd58, I/O limit 4095Mb (mask 0xffffffff)
hdn: setmax LBA 234441648, native  234375000
hdn: 234375000 sectors (120000 MB) w/8192KiB Cache, CHS=232514/16/63,
UDMA(100)
blk: queue c03ecf60, I/O limit 4095Mb (mask 0xffffffff)
hdo: setmax LBA 234375120, native  234375000
hdo: 234375000 sectors (120000 MB) w/8192KiB Cache, CHS=232514/16/63,
UDMA(100)
blk: queue c03ed09c, I/O limit 4095Mb (mask 0xffffffff)
hdp: setmax LBA 234375120, native  234375000
hdp: 234375000 sectors (120000 MB) w/8192KiB Cache, CHS=232514/16/63,
UDMA(100)
ide-floppy driver 0.99.newide
Partition check:
 hde: hde1 hde2 hde3
 hdg: hdg1
 hdh: hdh1
 hdi: hdi1
 hdk: [PTBL] [9964/255/63] hdk1
 hdl: hdl1 hdl2
 hdm: hdm1
 hdn: hdn1
 hdo: [PTBL] [14589/255/63] hdo1
 hdp: hdp1
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077




