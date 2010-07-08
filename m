From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Thu, 8 Jul 2010 12:26:27 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1007081214590.23489@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se> <87wrt7ijp3.fsf@rimspace.net> <alpine.DEB.1.10.1007071749320.23489@uplift.swm.pp.se> <4C35A2FC.5080402@buttersideup.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C35A2FC.5080402@buttersideup.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@buttersideup.com>
Cc: Daniel Pittman <daniel@rimspace.net>, linux-raid@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 8 Jul 2010, Tim Small wrote:

> Whilst SCSI drives have the ability to blink the activity light, I don't 
> think SATA drives have this (BICBW).  Are these links any use to you:

Well, I still wouldn't know what drive to blink right, because the tool 
would unlikely accept "ata14.00" for sending commands to?

> root@ermintrude:~# ls
> '/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block'
> sda

It seems the driver doesn't implement that, I can see it for the 
ICH10R-controller, but not for the SiL-based one this drive is on:

[    1.289345] ahci 0000:08:00.0: setting latency timer to 64
[    1.289436] scsi12 : ahci
[    1.289501] scsi13 : ahci
[    1.289542] ata13: SATA max UDMA/133 abar m2048@0xfbeff000 port 0xfbeff100 irq 40
[    1.289546] ata14: SATA max UDMA/133 irq_stat 0x80400040 irq 40, connection status changed
[    1.638532] ata13: SATA link down (SStatus 0 SControl 370)
[    2.218075] ata14: SATA link up 3.0 Gbps (SStatus 123 SControl 370)
[    2.223478] ata14.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    2.223483] ata14.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.228491] ata14.00: configured for UDMA/133

From lspci:

03:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
04:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)

/sys/devices/pci0000:00# ls
0000:00:00.0  0000:00:16.0  0000:00:1b.0  0000:00:1c.4  0000:00:1c.6 
0000:00:1d.0  0000:00:1f.0  0000:00:1f.3   pci_bus  uevent
0000:00:02.0  0000:00:1a.0  0000:00:1c.0  0000:00:1c.5  0000:00:1c.7 
0000:00:1e.0  0000:00:1f.2  firmware_node  power

Shouldn't the SiL controller show up here? There are only 0000:00: nodes.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
