From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.27.10: ata1.00: HPA detected: current 293044655, native
 293046768
Date: Tue, 30 Dec 2008 07:26:40 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812300657050.11356@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

On one system, two Raptor 150s:

[    0.739402] ata1.00: HPA detected: current 293044655, native 293046768
[    0.739491] ata1.00: ATA-7: WDC WD1500ADFD-00NLR5, 21.07QR5, max UDMA/133
[    0.739577] ata1.00: 293044655 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    0.742454] ata1.00: configured for UDMA/133

[    1.059146] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.061406] ata2.00: ATA-7: WDC WD1500ADFD-00NLR5, 21.07QR5, max UDMA/133
[    1.061494] ata2.00: 293046768 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.064360] ata2.00: configured for UDMA/133

Two disks in a RAID-1 (mdadm) configuration, how come the first one
has an issue w/HPA as the firmware of both disks is the same..?

l1:~# smartctl -a /dev/sda | grep -i bytes
User Capacity:    150,038,863,360 bytes
l1:~# smartctl -a /dev/sdb | grep -i bytes
User Capacity:    150,039,945,216 bytes
l1:~#

Why does this occur?

Justin.
