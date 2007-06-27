From: "Johny Mail list" <maillist.johny@gmail.com>
Subject: Re: Linux Software RAID is really RAID?
Date: Wed, 27 Jun 2007 13:54:56 +0200
Message-ID: <cd98e0260706270454x2c8a6ebbh408ff7a8e98e2ecd@mail.gmail.com>
References: <cd98e0260706261043t32fe6609ye1e4e252c722358c@mail.gmail.com>
	 <46815C3F.6090204@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46815C3F.6090204@wasp.net.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

2007/6/26, Brad Campbell <brad@wasp.net.au>:
> Johny Mail list wrote:
> > Hello list,
> > I have a little question about software RAID on Linux.
> > I have installed Software Raid on all my SC1425 servers DELL by
> > believing that the md raid was a strong driver.
> > And recently i make some test on a server and try to view if the RAID
> > hard drive power failure work fine, so i power up my server and after
> > booting and the prompt appear I disconnected the power cable of my
> > SATA hard drive. Normaly the MD should eleminate the failure hard
> > drive of the logical drive it build, and the server continue to work
> > fine like nothing happen. Oddly the server stop to respond and i get
> > this messages :
> > ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> > ata4.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
> >              res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> > ata4: port is slow to respond, please be patient (Status 0xd0)
> > ata4: port failed to respond (30sec, Status 0xd0)
> > ata4: soft resetting port
> >
> > After that my system is frozen. Normaly in a basic RAID the device is
> > "disable" in the logical RAID device (md0) and it only use the last
> > disk.
>
> cc to linux-ide added.
>
> Unfortunately this is not an artifact of the linux raid driver, rather it appears to be an issue
> with the SATA driver and related error recovery. Some information about what kernel, configuration,
> drives, controller cards and other relevant system information would be good.
>
> See the information at this URL for the sort of extra information that would be handy.
>
> http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html
>
>
> Regards,
> Brad
> --
> "Human beings, who are almost unique in having the ability
> to learn from the experience of others, are also remarkable
> for their apparent disinclination to do so." -- Douglas Adams
>

Ok no problem.
I have a DELL SC1425 with a no card controler, only chipset for SATA
and FakeRAID (Intel Chipset and Adaptec for FakeRAID but i have
disable this function) :
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev 02)
Specs of the server here :
http://www.dell.com/downloads/global/products/pedge/en/sc1425_specs.pdf

Hard Drivers are 2 S-ATA Model=WDC WD800JD-75LSA0.

I use , in my kernel configuration 2.6.21.5 :
- "ATA device support" (CONFIG_ATA)
-- "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support" Driver (CONFIG_ATA_PIIX)

And get this messages during my boot :
[   30.961007] libata version 2.20 loaded.
[   31.867977] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   31.868037] ide: Assuming 33MHz system bus speed for PIO modes;
override with idebus=xx
[   31.868369] Probing IDE interface ide0...
[   32.432715] Probing IDE interface ide1...
[   32.995829] ata_piix 0000:00:1f.1: version 2.10ac1
[   32.995843] PCI: Enabling device 0000:00:1f.1 (0000 -> 0003)
[   32.995905] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level,
low) -> IRQ 18
[   32.996027] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   32.996094] ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl
0x00000000000103f6 bmdma 0x000000000001fc00 irq 14
[   32.996213] ata2: PATA max UDMA/133 cmd 0x0000000000010170 ctl
0x0000000000010376 bmdma 0x000000000001fc08 irq 15
[   32.996305] scsi0 : ata_piix
[   32.996443] ata1: port disabled. ignoring.
[   32.996467] scsi1 : ata_piix
[   32.996582] ata2: port disabled. ignoring.
[   32.996613] ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
[   32.996858] ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level,
low) -> IRQ 18
[   32.996977] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   32.997014] ata3: SATA max UDMA/133 cmd 0x000000000001ccb8 ctl
0x000000000001ccb2 bmdma 0x000000000001cc80 irq 18
[   32.997125] ata4: SATA max UDMA/133 cmd 0x000000000001cca0 ctl
0x000000000001cc9a bmdma 0x000000000001cc88 irq 18
[   32.997210] scsi2 : ata_piix
[   33.167491] ata3.00: ATA-7: WDC WD800JD-75LSA0, 09.01D09, max UDMA/133
[   33.167551] ata3.00: 156250000 sectors, multi 8: LBA48
[   33.179467] ata3.00: configured for UDMA/133
[   33.179527] scsi3 : ata_piix
[   33.351130] ata4.00: ATA-7: WDC WD800JD-75LSA0, 09.01D09, max UDMA/133
[   33.351190] ata4.00: 156250000 sectors, multi 8: LBA48
[   33.363112] ata4.00: configured for UDMA/133
[   33.363277] scsi 2:0:0:0: Direct-Access     ATA      WDC
WD800JD-75LS 09.0 PQ: 0 ANSI: 5
[   33.363476] SCSI device sda: 156250000 512-byte hdwr sectors (80000 MB)
[   33.363550] sda: Write Protect is off
[   33.363606] sda: Mode Sense: 00 3a 00 00
[   33.363635] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   33.363770] SCSI device sda: 156250000 512-byte hdwr sectors (80000 MB)
[   33.363843] sda: Write Protect is off
[   33.363899] sda: Mode Sense: 00 3a 00 00
[   33.363928] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   33.364002]  sda: sda1 sda2 sda3
[   33.369982] sd 2:0:0:0: Attached scsi disk sda
[   33.370118] sd 2:0:0:0: Attached scsi generic sg0 type 0
[   33.370262] scsi 3:0:0:0: Direct-Access     ATA      WDC
WD800JD-75LS 09.0 PQ: 0 ANSI: 5
[   33.370450] SCSI device sdb: 156250000 512-byte hdwr sectors (80000 MB)
[   33.370524] sdb: Write Protect is off
[   33.370580] sdb: Mode Sense: 00 3a 00 00
[   33.370609] SCSI device sdb: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   33.370729] SCSI device sdb: 156250000 512-byte hdwr sectors (80000 MB)
[   33.370802] sdb: Write Protect is off
[   33.370858] sdb: Mode Sense: 00 3a 00 00
[   33.370886] SCSI device sdb: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   33.370967]  sdb: sdb1 sdb2
[   33.375935] sd 3:0:0:0: Attached scsi disk sdb
[   33.376068] sd 3:0:0:0: Attached scsi generic sg1 type 0


If you want all my .config, i can post it.
