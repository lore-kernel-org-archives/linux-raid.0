From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA Performance
Date: Fri, 08 Oct 2004 10:48:30 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4166A8BE.4060902@pobox.com>
References: <200410081335.37325.sebastian@sslota.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200410081335.37325.sebastian@sslota.de>
To: Sebastian Slota <sebastian@sslota.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sebastian Slota wrote:
> libata version 1.02 loaded.
> sata_sil version 0.54
> ACPI: PCI interrupt 0000:03:03.0[A] -> GSI 19 (level, low) -> IRQ 19
> ata1: SATA max UDMA/100 cmd 0xF8B09080 ctl 0xF8B0908A bmdma 0xF8B09000 irq 19
> ata2: SATA max UDMA/100 cmd 0xF8B090C0 ctl 0xF8B090CA bmdma 0xF8B09008 irq 19
> ata3: SATA max UDMA/100 cmd 0xF8B09280 ctl 0xF8B0928A bmdma 0xF8B09200 irq 19
> ata4: SATA max UDMA/100 cmd 0xF8B092C0 ctl 0xF8B092CA bmdma 0xF8B09208 irq 19
> ata1: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 
> 88:207f
> ata1: dev 0 ATA, max UDMA/133, 312581808 sectors: lba48
> ata1(0): applying Seagate errata fix
> ata1: dev 0 configured for UDMA/100
> scsi0 : sata_sil
> ata2: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 
> 88:207f
> ata2: dev 0 ATA, max UDMA/133, 312581808 sectors: lba48
> ata2(0): applying Seagate errata fix
> ata2: dev 0 configured for UDMA/100
> scsi1 : sata_sil
> ata3: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 
> 88:207f
> ata3: dev 0 ATA, max UDMA/133, 312581808 sectors: lba48
> ata3(0): applying Seagate errata fix
> ata3: dev 0 configured for UDMA/100
> scsi2 : sata_sil
> ata4: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 
> 88:207f
> ata4: dev 0 ATA, max UDMA/133, 312581808 sectors: lba48
> ata4(0): applying Seagate errata fix
> ata4: dev 0 configured for UDMA/100


The "applying Seagate errata fix" locks each request to a small size, 
which kills performance basically.

	Jeff


