From: Phil Turmel <philip@turmel.org>
Subject: Re: Possible HDD error, how do I find which HDD it is?
Date: Sat, 19 Feb 2011 17:40:21 -0500
Message-ID: <4D6046D5.4020005@turmel.org>
References: <AANLkTimV8-mciW_9z_=U_-uYLvKp7Rbh0V1N0mr7rh8v@mail.gmail.com>	<4D5FE3D6.8070006@anonymous.org.uk>	<4D5FF386.6070003@turmel.org>	<AANLkTinw8hSks5kopU9ju1cNCQu11kUgPzRbC8L2h_ed@mail.gmail.com>	<4D60429E.1090501@turmel.org> <AANLkTi=k7BwKbkK+TL_CevezhcRyUszHpOBZY2Dt5TiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=k7BwKbkK+TL_CevezhcRyUszHpOBZY2Dt5TiQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>, Simon Mcnair <simonmcnair@gmail.com>
List-Id: linux-raid.ids

On 02/19/2011 05:30 PM, Mathias Bur=C3=A9n wrote:
> On 19 February 2011 22:22, Phil Turmel <philip@turmel.org> wrote:
>> On 02/19/2011 03:09 PM, Mathias Bur=C3=A9n wrote:
>>> The script works for me:
>>>
>>>  $ sudo ./lsdrv.sh
>>> Password:
>>> Controller device @ pci0000:00/0000:00:0b.0 [ahci]
>>>   SATA controller: nVidia Corporation MCP79 AHCI Controller (rev b1=
)
>>>     host0: /dev/sda ATA Corsair CSSD-F60 {SN: 10326505580009990027}
>>>     host1: /dev/sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA1022443}
>>>     host2: /dev/sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20152590}
>>>     host3: /dev/sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ20188479}
>>>     host4: [Empty]
>>>     host5: [Empty]
>>> Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
>>>   SCSI storage controller: HighPoint Technologies, Inc. RocketRAID
>>> 230x 4 Port SATA-II Controller (rev 02)
>>>     host6: [Empty]
>>>     host7: /dev/sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800964 }
>>>     host8: /dev/sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA1000331}
>>>     host9: /dev/sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800850 }
>>>
>>> So ata3 is the same as host3 then? How come no errors are logged on=
 the drive:
>>
>> No, generally not.  ATA numbering starts from #1.  Host numbering st=
arts from #0, but includes non-ATA SCSI devices.
>>
>> I've attached a version of the script that shows the LUN in addition=
 to the host number, and includes John's adjustment.  It might be usefu=
l to people with port multipliers, and controllers that show all ports =
under a single host.
>>
>> Simon, I'm very curious what this latest script shows for the Superm=
icro when one or more ports are empty, and whether those LUNs are consi=
stently assigned to specific ports.
>>
>> Phil
>>
>=20
> $ sudo ./lsdrv-2.sh
> Controller device @ pci0000:00/0000:00:0b.0 [ahci]
>   SATA controller: nVidia Corporation MCP79 AHCI Controller (rev b1)
>     host0 0:0:0 sda ATA Corsair CSSD-F60 {SN: 10326505580009990027}
>     host1 0:0:0 sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA1022443}
>     host2 0:0:0 sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20152590}
>     host3 0:0:0 sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ20188479}
>     host4 [Empty]
>     host5 [Empty]
> Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
>   SCSI storage controller: HighPoint Technologies, Inc. RocketRAID
> 230x 4 Port SATA-II Controller (rev 02)
>     host6 [Empty]
>     host7 0:0:0 sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800964 }
>     host8 0:0:0 sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA1000331}
>     host9 0:0:0 sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800850 }
>=20
> This is the output of your latest script on my machine. The "0:0:0" i=
s
> supposed to be the LUN, which would be ata[1, 2, 3..], no?

No.  You have to look in your dmesg to match the 'ata' initialization r=
eports with the corresponding 'scsi' initialization reports.

dmesg |grep 'ata[0-9]\|scsi[0-9]'

Unless I missed something in sysfs that would make it easy to report it=
 in the script?

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
