From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Veliciraptor HDD 3.0gbps but UDMA/100 on PCI-e controller?
Date: Thu, 03 Jul 2008 08:50:26 -0400
Message-ID: <486CCB12.7040205@garzik.org>
References: <alpine.DEB.1.10.0807030447040.12072@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760955AbYGCMun@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0807030447040.12072@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> On the motherboard itself (all drives configured for AHCI)
> 
> [    2.360648] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.678244] ata1.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max 
> UDMA/133
> [    2.678594] ata1.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    2.684566] ata1.00: configured for UDMA/133
> 
> On the PCI-e cards:
> 
> [   16.136568] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   16.155682] ata11.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max 
> UDMA/133
> [   16.156545] ata11.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 
> 31/32)
> [   16.162949] ata11.00: configured for UDMA/100
> 
> How come the PCI-e card configured the drive for UDMA/100 and not UDMA/133?
> 
> Perhaps the PCI-e card/driver does not configure/have AHCI 
> functionality, or?
> 
> The mobo: Intel DG965WH
> The card: 03:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 
> Serial ATA Raid II Controller (rev 01)

You need to show us the full dmesg.  We cannot see which controller is 
applying limits here.

You need to look at the controller's maximum, as that controls the drive 
maximum (pasted from my personal workstation):

scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0x90404000 port 0x90404100 irq 507
ata2: SATA max UDMA/133 abar m1024@0x90404000 port 0x90404180 irq 507
ata3: SATA max UDMA/133 abar m1024@0x90404000 port 0x90404200 irq 507
ata4: SATA max UDMA/133 abar m1024@0x90404000 port 0x90404280 irq 507


scsi4 : sata_sil
scsi5 : sata_sil
scsi6 : sata_sil
scsi7 : sata_sil
ata5: SATA max UDMA/100 mmio m1024@0x9000c800 tf 0x9000c880 irq 17
ata6: SATA max UDMA/100 mmio m1024@0x9000c800 tf 0x9000c8c0 irq 17
ata7: SATA max UDMA/100 mmio m1024@0x9000c800 tf 0x9000ca80 irq 17
ata8: SATA max UDMA/100 mmio m1024@0x9000c800 tf 0x9000cac0 irq 17


See the UDMA difference?

	Jeff
