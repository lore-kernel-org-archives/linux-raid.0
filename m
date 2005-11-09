From: Spencer Tuttle <rodeojones+Postfix@fastmail.fm>
Subject: Re: New raid5 took 5 days for initial build on spare drive
Date: Wed, 09 Nov 2005 16:48:38 -0700
Message-ID: <43728AD6.2080002@fastmail.fm>
References: <1131577030.27623.247169656@webmail.messagingengine.com> <43728312.5010701@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43728312.5010701@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: berk walker <berk@panix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

berk walker wrote:
> Just a couple of things to think about before the board explodes. :-)
> 
> Are your drives doing DMA?  Important.

Unfortunately no, these are serial ata drives and I saw this in the 
dmesg output:

libata version 1.12 loaded.
sata_mv version 0.12
ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 27 (level, low) -> IRQ 18
ata1: SATA max PIO4 cmd 0x0 ctl 0xF88A2120 bmdma 0x0 irq 18
ata2: SATA max PIO4 cmd 0x0 ctl 0xF88A4120 bmdma 0x0 irq 18
ata3: SATA max PIO4 cmd 0x0 ctl 0xF88A6120 bmdma 0x0 irq 18
ata4: SATA max PIO4 cmd 0x0 ctl 0xF88A8120 bmdma 0x0 irq 18
ata1: dev 0 cfg 49:2f00 82:7869 83:7d09 84:4003 85:7869 86:3c01 87:4003 
88:203f
ata1: dev 0 ATA, max UDMA/100, 156301488 sectors: lba48
ata1: dev 0 configured for PIO4
scsi0 : sata_mv
ata2: dev 0 cfg 49:2f00 82:7869 83:7d09 84:4003 85:7869 86:3c01 87:4003 
88:203f
ata2: dev 0 ATA, max UDMA/100, 156301488 sectors: lba48
ata2: dev 0 configured for PIO4
scsi1 : sata_mv
ata3: dev 0 cfg 49:2f00 82:7869 83:7d09 84:4003 85:7869 86:3c01 87:4003 
88:203f
ata3: dev 0 ATA, max UDMA/100, 156301488 sectors: lba48
ata3: dev 0 configured for PIO4
scsi2 : sata_mv
ata4: dev 0 cfg 49:2f00 82:7869 83:7d09 84:4003 85:7869 86:3c01 87:4003 
88:203f
ata4: dev 0 ATA, max UDMA/100, 156301488 sectors: lba48
ata4: dev 0 configured for PIO4
scsi3 : sata_mv
blk_queue_max_hw_segments: set to minimum 1
   Vendor: ATA       Model: Maxtor 6Y080M0    Rev: YAR5
   Type:   Direct-Access                      ANSI SCSI revision: 05
blk_queue_max_hw_segments: set to minimum 1
blk_queue_max_hw_segments: set to minimum 1
blk_queue_max_hw_segments: set to minimum 1
blk_queue_max_hw_segments: set to minimum 1
blk_queue_max_hw_segments: set to minimum 1
blk_queue_max_hw_segments: set to minimum 1
blk_queue_max_hw_segments: set to minimum 1


I think that I am in PI04 mode, but this is an issue with the driver.

> 
> Are you using mdadm, or the compubox's firmware... (?)

The firmware for the controller is set to JBOD.
> 
> when you are (re)syncing, you can echo a min speed command, also.

I set the min to 1000

orion raid # cat /proc/sys/dev/raid/speed_limit_min
1000

It seems to me this might be more of a driver issue, can anyone elaborate?

Spencer
