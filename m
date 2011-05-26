From: Phil Turmel <philip@turmel.org>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 07:49:52 -0400
Message-ID: <4DDE3E60.3010408@turmel.org>
References: <4DDDC301.7090608@turmel.org> <1306403130.9437.109.camel@torbjorn> <4DDE249C.7080004@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDE249C.7080004@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: =?UTF-8?B?VG9yYmrDuHJuIFNrYWdlc3RhZA==?= <torbjorn@itpas.no>, linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>
List-Id: linux-raid.ids

On 05/26/2011 05:59 AM, John Robinson wrote:
> On 26/05/2011 10:45, Torbj=C3=B8rn Skagestad wrote:
>> Hi,
>>
>> Great tool, thanks for sharing.
>>
>> I had to add some error handling to get it to work properly.
>> Currently it runs on Ubuntu 10.04, 10.10 and 11.04.
>>
>> Added the check John Robinson asked for as well.
>>
>> Attached patch for those interested.
>=20
> Thanks, Torbj=C3=B8rn!
>=20
> Getting there:
>=20
> [root@beast lsdrv]# python2.6 lsdrv
> PCI [pata_marvell] 03:00.0 IDE interface: Marvell Technology Group Lt=
d. 88SE6121 SATA II Controller (rev b2)
>  =E2=94=94=E2=94=80scsi 0:0:0:0 HL-DT-ST DVD-RAM GH22NP20
>     =E2=94=94=E2=94=80sr0: Empty/Unknown 1.00g
> PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 =
=46amily) SATA AHCI Controller
>  =E2=94=9C=E2=94=80scsi 2:0:0:0 ATA Hitachi HDS72101
>  =E2=94=82  =E2=94=94=E2=94=80sda: Empty/Unknown 931.51g
> Traceback (most recent call last):
>   File "lsdrv", line 387, in <module>
>     show_blocks(" %s " % branch[0], [phy.block])
>   File "lsdrv", line 339, in show_blocks
>     show_blocks("%s %s " % (indent, branch[0]), [blockbyname[x] for x=
 in subs])
> KeyError: 'sda1'
>=20
> Now, something's not getting picked up about sda. Looking at Mathias'=
 "sweet" output, it's not coping with the (DOS) partition table. Anothe=
r variation on my kernel's /sys or still to old a Python or ...?

Hmmm.  I'll set up another CentOS VM.  If I recall correctly, that kern=
el has the original block devices in folders named '.../block:sda1' ins=
tead of '.../block/sda1'.  I'll have to identify this in the initial sw=
eep through sysfs.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
