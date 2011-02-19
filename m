From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: Possible HDD error, how do I find which HDD it is?
Date: Sat, 19 Feb 2011 14:09:33 +0000
Message-ID: <4D5FCF1D.1090708@gmail.com>
References: <AANLkTimV8-mciW_9z_=U_-uYLvKp7Rbh0V1N0mr7rh8v@mail.gmail.com>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimV8-mciW_9z_=U_-uYLvKp7Rbh0V1N0mr7rh8v@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

does this help:
http://www.linux-archive.org/centos/316405-how-map-ata-numbers-dev-sd-n=
umbers.html

?
Simon

On 19/02/2011 11:52, Mathias Bur=C3=A9n wrote:
> Hi, apologies in advance for the long email due to the log below. Thi=
s
> is the second time I've run a consistency check on the RAID (6 HDDs,
> RAID5) that this error has occured. If you look on the ata3 entries i=
n
> the log below:
>
> dmesg:
>
> ata1: SATA max UDMA/133 abar m8192@0xfae76000 port 0xfae76100 irq 40
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: ATA-8: Corsair CSSD-F60GB2, 1.1, max UDMA/133
> ata1.00: 117231408 sectors, multi 1: LBA48 NCQ (depth 31/32)
> ata1.00: configured for UDMA/133
>
> ata2: SATA max UDMA/133 abar m8192@0xfae76000 port 0xfae76180 irq 40
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
> ata2.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata2.00: configured for UDMA/133
>
> ata3: SATA max UDMA/133 abar m8192@0xfae76000 port 0xfae76200 irq 40
> ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata3.00: ATA-8: WDC WD20EARS-00MVWB0, 50.0AB50, max UDMA/133
> ata3.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata3.00: configured for UDMA/133
> ata3.00: exception Emask 0x0 SAct 0x800801 SErr 0x0 action 0x6 frozen
> ata3.00: failed command: READ FPDMA QUEUED
> ata3.00: cmd 60/b0:00:50:31:7b/02:00:8b:00:00/40 tag 0 ncq 352256 in
> ata3.00: status: { DRDY }
> ata3.00: failed command: READ FPDMA QUEUED
> ata3.00: cmd 60/00:58:50:29:7b/04:00:8b:00:00/40 tag 11 ncq 524288 in
> ata3.00: status: { DRDY }
> ata3.00: failed command: READ FPDMA QUEUED
> ata3.00: cmd 60/00:b8:50:2d:7b/04:00:8b:00:00/40 tag 23 ncq 524288 in
> ata3.00: status: { DRDY }
> ata3: hard resetting link
> ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata3.00: configured for UDMA/133
> ata3.00: device reported invalid CHS sector 0
> ata3.00: device reported invalid CHS sector 0
> ata3.00: device reported invalid CHS sector 0
> ata3: EH complete
>
> ata4: SATA max UDMA/133 abar m8192@0xfae76000 port 0xfae76280 irq 40
> ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata4.00: ATA-8: WDC WD20EARS-00MVWB0, 50.0AB50, max UDMA/133
> ata4.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata4.00: configured for UDMA/133
>
> ata5: SATA max UDMA/133 abar m8192@0xfae76000 port 0xfae76300 irq 40
> ata5: SATA link down (SStatus 0 SControl 300)
>
> ata6: SATA max UDMA/133 abar m8192@0xfae76000 port 0xfae76380 irq 40
> ata6: SATA link down (SStatus 0 SControl 300)
>
> ata7: SATA max UDMA/133 mmio m1048576@0xfeb00000 port 0xfeb22000 irq =
19
> ata7: SATA link down (SStatus 0 SControl 300)
>
> ata8: SATA max UDMA/133 mmio m1048576@0xfeb00000 port 0xfeb24000 irq =
19
> ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata8.00: ATA-8: SAMSUNG HD204UI, 1AQ10003, max UDMA/133
> ata8.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata8.00: configured for UDMA/133
>
> ata9: SATA max UDMA/133 mmio m1048576@0xfeb00000 port 0xfeb26000 irq =
19
> ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata9.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
> ata9.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata9.00: configured for UDMA/133
>
> ata10: SATA max UDMA/133 mmio m1048576@0xfeb00000 port 0xfeb28000 irq=
 19
> ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata10.00: ATA-8: SAMSUNG HD204UI, 1AQ10003, max UDMA/133
> ata10.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata10.00: configured for UDMA/133
>
> hdparm -I /dev/sdc:
>
> ATA device, with non-removable media
>          Model Number:       WDC WD20EARS-00MVWB0
>          Serial Number:      WD-WMAZ20152590
>          Firmware Revision:  50.0AB50
>
> What I wonder is, how do I know what device is ata3? I do have 4
> devices of that model (WD20EARS). I've tried searching in /sys but
> there's nothing of value there (or I've missed it). If dmesg only
> showed the S/N...
> I posted the smartctl --all output of all devices here in case someon=
e
> has time to take a look:
> http://stuff.dyndns.org/logs/smart-sd[a,b,c,d,e,f,g].log
>
> Thanks,
> // Mathias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
