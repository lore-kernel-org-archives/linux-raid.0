From: "Jonathan Vardy" <jonathanv@explainerdc.com>
Subject: Re: RAID 5 performance problems
Date: Fri, 4 Apr 2003 00:16:37 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00d901c2fa2e$b1d4d430$2e77c23e@pentium4>
References: <Pine.GSO.4.30.0304031334070.20118-100000@multivac.sdsc.edu> <00bf01c2fa2d$afafedd0$2e77c23e@pentium4>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Jonathan Vardy <jonathanv@explainerdc.com>, "Peter L. Ashford" <ashford@sdsc.edu>, Stephan van Hienen <raid@a2000.nu>
Cc: Jonathan Vardy <jonathan@explainerdc.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

All info regarding the drive part:

ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller on PCI bus 00 dev 21
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xd800-0xd807, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xd808-0xd80f, BIOS settings: hdc:DMA, hdd:pio
PDC20270: IDE controller on PCI bus 02 dev 08
PDC20270: chipset revision 2
PDC20270: not 100% native mode: will probe irqs later
PDC20270: (U)DMA Burst Bit ENABLED Primary MASTER Mode Secondary MASTER
Mode.
    ide2: BM-DMA at 0x9040-0x9047, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0x9048-0x904f, BIOS settings: hdg:pio, hdh:pio
PDC20270: IDE controller on PCI bus 02 dev 10
PDC20270: chipset revision 2
PDC20270: not 100% native mode: will probe irqs later
PDC20270: ROM enabled at 0x000dc000
PDC20270: (U)DMA Burst Bit ENABLED Primary MASTER Mode Secondary MASTER
Mode.
    ide4: BM-DMA at 0x90c0-0x90c7, BIOS settings: hdi:pio, hdj:pio
    ide5: BM-DMA at 0x90c8-0x90cf, BIOS settings: hdk:pio, hdl:pio
hda: Maxtor 2B020H1, ATA DISK drive
hdc: WDC WD1200BB-00CAA1, ATA DISK drive
hde: WDC WD1200BB-60CJA1, ATA DISK drive
hdg: WDC WD1200BB-60CJA1, ATA DISK drive
hdi: WDC WD1200BB-60CJA1, ATA DISK drive
hdk: WDC WD1200BB-60CJA1, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide2 at 0x9000-0x9007,0x9012 on irq 19
ide3 at 0x9020-0x9027,0x9032 on irq 19
ide4 at 0x9080-0x9087,0x9092 on irq 19
ide5 at 0x90a0-0x90a7,0x90b2 on irq 19
blk: queue c0393144, I/O limit 4095Mb (mask 0xffffffff)
hda: 39062500 sectors (20000 MB) w/2048KiB Cache, CHS=2431/255/63, UDMA(33)
blk: queue c03934a8, I/O limit 4095Mb (mask 0xffffffff)
hdc: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=232581/16/63,
UDMA(33)
blk: queue c039380c, I/O limit 4095Mb (mask 0xffffffff)
hde: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=232581/16/63,
UDMA(33)
blk: queue c0393b70, I/O limit 4095Mb (mask 0xffffffff)
hdg: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=232581/16/63,
UDMA(33)
blk: queue c0393ed4, I/O limit 4095Mb (mask 0xffffffff)
hdi: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=232581/16/63,
UDMA(33)
blk: queue c0394238, I/O limit 4095Mb (mask 0xffffffff)
hdk: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=232581/16/63,
UDMA(33)

