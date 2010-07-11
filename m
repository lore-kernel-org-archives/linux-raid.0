From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Sun, 11 Jul 2010 15:01:20 -0400
Message-ID: <AANLkTiluwfd9LTH7Tb0J9N3NBvp1FbZdoJYUYj1g8BJz@mail.gmail.com>
References: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se>
	<87wrt7ijp3.fsf@rimspace.net> <alpine.DEB.1.10.1007071749320.23489@uplift.swm.pp.se>
	<4C35A2FC.5080402@buttersideup.com> <alpine.DEB.1.10.1007081214590.23489@uplift.swm.pp.se>
	<20100708104422.GA32564@cthulhu.home.robinhill.me.uk> <alpine.DEB.1.10.1007081259560.23489@uplift.swm.pp.se>
	<20100708232631.014a5ade@atak.bl.pg.gda.pl> <alpine.DEB.1.10.1007082348190.23489@uplift.swm.pp.se>
	<4C37FA32.8020008@wasp.net.au> <4C381BC4.9040903@grumpydevil.homelinux.org>
	<4C38C8BD.4050604@garzik.org> <4C390703.80703@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C390703.80703@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Jeff Garzik <jeff@garzik.org>, Brad Campbell <brad@wasp.net.au>, Mikael Abrahamsson <swmike@swm.pp.se>, Janek Kozicki <janek_listy@wp.>
List-Id: linux-raid.ids

I find it rather confusing in my log, and there are situation when you
hotplug the disk which does not make it show up right after the ataX
line, also if the logs overflow, then you can't know anyway. (I know
there's syslog too)

There doesn't seem to be any mapping in /sys I though lshw would show
it but it isn't.

[    1.378503] loop: module loaded
[    1.382075] ata_piix 0000:00:1f.2: version 2.13
[    1.382100] ata_piix 0000:00:1f.2: PCI INT A -> GSI 18 (level, low) =
-> IRQ 18
[    1.389566] ata_piix 0000:00:1f.2: MAP [ IDE IDE P0 P1 ]
[    1.395265] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.395349] scsi0 : ata_piix
[    1.398516] scsi1 : ata_piix
[    1.401647] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00=
 irq 14
[    1.408880] ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08=
 irq 15
[    1.416308] sata_mv 0000:01:00.0: version 1.28
[    1.420999] sata_mv 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -=
> IRQ 16
[    1.428614] sata_mv 0000:01:00.0: Gen-IIE 32 slots 4 ports ? mode
IRQ via INTx
[    1.436133] sata_mv 0000:01:00.0: setting latency timer to 64
[    1.436591] scsi2 : sata_mv
[    1.436751] scsi3 : sata_mv
[    1.436889] scsi4 : sata_mv
[    1.437024] scsi5 : sata_mv
[    1.437141] ata3: SATA max UDMA/133 mmio m1048576@0xfc800000 port
0xfc822000 irq 16
[    1.437146] ata4: SATA max UDMA/133 mmio m1048576@0xfc800000 port
0xfc824000 irq 16
[    1.437150] ata5: SATA max UDMA/133 mmio m1048576@0xfc800000 port
0xfc826000 irq 16
[    1.437154] ata6: SATA max UDMA/133 mmio m1048576@0xfc800000 port
0xfc828000 irq 16
[    1.442237] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21=
-k6-NAPI
[    1.442241] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.442278] e1000 0000:03:03.0: PCI INT A -> GSI 26 (level, low) -> =
IRQ 26
[    1.506175] ata1.00: ATAPI: HL-DT-ST DVDRAM GSA-4167B, DL12, max UDM=
A/33
[    1.506433] ata2.01: ATA-8: OCZ-ONYX, 1.6, max UDMA/133
[    1.506437] ata2.01: 62533296 sectors, multi 1: LBA48 NCQ (depth 0/3=
2)
[    1.546986] ata2.01: configured for UDMA/133
[    1.559278] ata1.00: configured for UDMA/33
[    1.576801] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM
GSA-4167B DL12 PQ: 0 ANSI: 5
[    1.605506] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw
xa/form2 cdda tray
[    1.621572] Uniform CD-ROM driver Revision: 3.20
[    1.635283] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.635478] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.649870] scsi 1:0:1:0: Direct-Access     ATA      OCZ-ONYX
  1.6  PQ: 0 ANSI: 5
[    1.667596] sd 1:0:1:0: [sda] 62533296 512-byte logical blocks:
(32.0 GB/29.8 GiB)
[    1.667672] sd 1:0:1:0: Attached scsi generic sg1 type 0
[    1.699875] sd 1:0:1:0: [sda] Write Protect is off
[    1.714493] sd 1:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    1.714527] sd 1:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.734022]  sda: sda1 sda2 sda3 sda4
[    1.758945] e1000 0000:03:03.0: eth0: (PCI:66MHz:32-bit)
[    1.759032] sd 1:0:1:0: [sda] Attached SCSI disk
[    1.790414] e1000 0000:03:03.0: eth0: 00:30:48:58:1d:82
[    1.806615] e1000 0000:03:03.0: eth0: Intel(R) PRO/1000 Network Conn=
ection
[    1.824685] e1000 0000:03:04.0: PCI INT A -> GSI 27 (level, low) -> =
IRQ 27
[    1.946696] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.003382] ata3.00: ATA-8: ST3320613AS, CC2H, max UDMA/133
[    2.021065] ata3.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31=
/32)
[    2.100074] ata3.00: configured for UDMA/133
[    2.116753] scsi 2:0:0:0: Direct-Access     ATA      ST3320613AS
  CC2H PQ: 0 ANSI: 5


On Sat, Jul 10, 2010 at 7:49 PM, Rudy Zijlstra
<rudy@grumpydevil.homelinux.org> wrote:
> Jeff Garzik wrote:
>>
>> On 07/10/2010 03:05 AM, Rudy Zijlstra wrote:
>>>
>>> Judging from my dmesg and lsscsi on a system with both scsi and SAT=
A,
>>> ataX translates into scsi X:0:0:0
>>
>>
>> There is no translation.
>>
>> It is random, based on driver load order.
>
> This then begs the question whether it can be dependingly derived fro=
m dmesg
> messages. Like messages
>
> [ =A0 =A02.268315] ata7.00: configured for UDMA/133
> [ =A0 =A02.277452] scsi 7:0:0:0: Direct-Access =A0 =A0 ATA =A0 =A0 =A0=
WDC WD7500AAKS-0
> 30.0 PQ: 0 ANSI: 5
>
> always following each other, thus making identification possible.
>
>
> Cheers,
>
>
> Rudy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
