From: Danilo Godec <danci@agenda.si>
Subject: ServerWorks chipset
Date: Mon, 26 Aug 2002 14:45:27 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0208261440170.10850-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I'm using several Intel server boards with ServerWorks CSB5 chipset for
IDE. Even though this chipset is supposed to support ATA100 and it is
supposed to be supported in Linux and I do have CONFIG_BLK_DEV_SVWKS=y in
my .config, I can't set speeds higher than 'hdparm -X66 /dev/hda'!

This is what I get in my dmesg:

Uniform Multi-Platform E-IDE driver Revision: 6.31
ide: Assuming 33MHz system bus speed for PIO modes; override with
idebus=xx
ServerWorks CSB5: IDE controller on PCI bus 00 dev 79
ServerWorks CSB5: chipset revision 147
ServerWorks CSB5: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x2840-0x2847, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x2848-0x284f, BIOS settings: hdc:DMA, hdd:DMA
hda: IC35L060AVER07-0, ATA DISK drive
hdc: IC35L060AVER07-0, ATA DISK drive
hdd: SONY CD-ROM CDU523 1, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: 120103200 sectors (61493 MB) w/1916KiB Cache, CHS=7476/255/63, UDMA(33)
hdc: 120103200 sectors (61493 MB) w/1916KiB Cache, CHS=7476/255/63, UDMA(33)

Is it just me or is someone else having the same problem?

Thanks, D.

