From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Veliciraptor HDD 3.0gbps but UDMA/100 on PCI-e controller?
Date: Thu, 3 Jul 2008 04:51:04 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0807030447040.12072@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On the motherboard itself (all drives configured for AHCI)

[    2.360648] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.678244] ata1.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    2.678594] ata1.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.684566] ata1.00: configured for UDMA/133

On the PCI-e cards:

[   16.136568] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[   16.155682] ata11.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   16.156545] ata11.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   16.162949] ata11.00: configured for UDMA/100

How come the PCI-e card configured the drive for UDMA/100 and not UDMA/133?

Perhaps the PCI-e card/driver does not configure/have AHCI functionality, 
or?

The mobo: Intel DG965WH
The card: 03:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial 
ATA Raid II Controller (rev 01)

The hard drives are the same make/model.

Thanks,

Justin.

