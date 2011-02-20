From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Possible HDD error, how do I find which HDD it is?
Date: Sun, 20 Feb 2011 09:52:39 +0000
Message-ID: <AANLkTinhP1dDp7ACPh5CgMy-iEDCzNF=_9G5KJ3YDT1N@mail.gmail.com>
References: <AANLkTimV8-mciW_9z_=U_-uYLvKp7Rbh0V1N0mr7rh8v@mail.gmail.com>
	<4D5FE3D6.8070006@anonymous.org.uk>
	<4D5FF386.6070003@turmel.org>
	<AANLkTinw8hSks5kopU9ju1cNCQu11kUgPzRbC8L2h_ed@mail.gmail.com>
	<4D60429E.1090501@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D60429E.1090501@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, John Robinson <john.robinson@anonymous.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Phil,
Results as follows:
proxmox:/home/simon# ./lsdrv2.sh
Controller device @ pci0000:00/0000:00:01.0/0000:01:00.0 [mvsas]
  SCSI storage controller: Marvell Technology Group Ltd.
MV64460/64461/64462 System Controller, Revision B (rev 01)
    host0 0:0:0 sdf ATA Hitachi HDS72101 {SN: GTA000PAGABXRA}
    host0 0:1:0 sdg ATA Hitachi HDS72101 {SN: GTA000PAGAA5DA}
    host0 0:2:0 sdh ATA Hitachi HDS72101 {SN: GTA000PAG9NL9A}
    host0 0:3:0 sdi ATA Hitachi HDS72101 {SN: GTA000PAGA8V4A}
    host0 0:4:0 sdj ATA Hitachi HDS72101 {SN: GTD000PAGMT9GD}
    host0 0:5:0 sdk ATA Hitachi HDS72101 {SN: GTG000PAG18BJC}
    host0 0:6:0 sdl ATA Hitachi HDS72101 {SN: GTG000PAG1DPLC}
    host0 0:7:0 sdm ATA Hitachi HDS72101 {SN: GTA000PAG7WMEA}
Controller device @
pci0000:00/0000:00:1a.7/usb1/1-6/1-6.1/1-6.1.1/1-6.1.1:1.0
[usb-storage]
  Bus 001 Device 095: ID 0424:2228 Standard Microsystems Corp. 9-in-2
Card Reader {SN: 08050920003A}
    host21 0:0:0 sdo Generic Flash HS-CF
    host21 0:0:1 sdp Generic Flash HS-COMBO
Controller device @ pci0000:00/0000:00:1c.4/0000:04:00.0 [ahci]
  SATA controller: JMicron Technology Corp. JMB362/JMB363 Serial ATA
Controller (rev 03)
    host9 [Empty]
    host10 [Empty]
Controller device @ pci0000:00/0000:00:1c.4/0000:04:00.1 [pata_jmicron]
  IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial ATA
Controller (rev 03)
    host1 [Empty]
    host2 [Empty]
Controller device @ pci0000:00/0000:00:1f.2 [ahci]
  SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI C=
ontroller
    host3 0:0:0 sda ATA STM3500418AS {SN: 9VM3QJ5C}
    host4 0:0:0 sr0 Optiarc DVD RW AD-5240S
    host5 0:0:0 sds ATA SAMSUNG HD203WI {SN: S1UYJ1CZ404245 }
    host6 0:0:0 sdr ATA SAMSUNG HD203WI {SN: S1UYJ1CZ404242 }
    host7 0:0:0 sdd ATA Hitachi HDS72101 {SN: GTD000PAGMT8DD}
    host8 0:0:0 sde ATA Hitachi HDS72101 {SN: GTG000PAG04V0C}

I can't test the empty ports and/or specific ports assigned to
specific LUNS until I've done the data recovery task.  Happy to do it
afterwards once I know the state of my data.
cheers
Simon

On 19 February 2011 22:22, Phil Turmel <philip@turmel.org> wrote:
> On 02/19/2011 03:09 PM, Mathias Bur=E9n wrote:
>> The script works for me:
>>
>> =A0$ sudo ./lsdrv.sh
>> Password:
>> Controller device @ pci0000:00/0000:00:0b.0 [ahci]
>> =A0 SATA controller: nVidia Corporation MCP79 AHCI Controller (rev b=
1)
>> =A0 =A0 host0: /dev/sda ATA Corsair CSSD-F60 {SN: 103265055800099900=
27}
>> =A0 =A0 host1: /dev/sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA1022443}
>> =A0 =A0 host2: /dev/sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20152590}
>> =A0 =A0 host3: /dev/sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ20188479}
>> =A0 =A0 host4: [Empty]
>> =A0 =A0 host5: [Empty]
>> Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
>> =A0 SCSI storage controller: HighPoint Technologies, Inc. RocketRAID
>> 230x 4 Port SATA-II Controller (rev 02)
>> =A0 =A0 host6: [Empty]
>> =A0 =A0 host7: /dev/sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800964 }
>> =A0 =A0 host8: /dev/sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA1000331}
>> =A0 =A0 host9: /dev/sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800850 }
>>
>> So ata3 is the same as host3 then? How come no errors are logged on =
the drive:
>
> No, generally not. =A0ATA numbering starts from #1. =A0Host numbering=
 starts from #0, but includes non-ATA SCSI devices.
>
> I've attached a version of the script that shows the LUN in addition =
to the host number, and includes John's adjustment. =A0It might be usef=
ul to people with port multipliers, and controllers that show all ports=
 under a single host.
>
> Simon, I'm very curious what this latest script shows for the Supermi=
cro when one or more ports are empty, and whether those LUNs are consis=
tently assigned to specific ports.
>
> Phil
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
