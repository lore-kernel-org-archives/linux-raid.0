From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 04:25:45 +0100
Message-ID: <BANLkTikXynnt7QYQV-JUN3A+b7hjz7A9Dg@mail.gmail.com>
References: <4DDDC301.7090608@turmel.org>
	<BANLkTiky1L9fisPnxMKsceG19LbhxcF0ag@mail.gmail.com>
	<4DDDC750.6040600@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDDC750.6040600@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

On 26 May 2011 04:21, Phil Turmel <philip@turmel.org> wrote:
> On 05/25/2011 11:10 PM, Mathias Bur=C3=A9n wrote:
>> On 26 May 2011 04:03, Phil Turmel <philip@turmel.org> wrote:
>>> Hi All,
>>>
>>> Last November, I shared a shell script that helped me keep track of=
 the specific hot-swap drives I had in the various slots of my servers.=
 =C2=A0Although encouraged by Roman and John, I declined to make a proj=
ect out of it.
>>>
>>> I've since kicked it around some more, and thought a bit about supp=
orting more than just the SCSI subsystem. =C2=A0The latest and greatest=
 is still built around some standard executables: =C2=A0blkid, lspci, l=
susb, sginfo, and smartctl. =C2=A0The original was similar to "lsscsi",=
 but with controller details and device serial numbers.
>>>
>>> New features:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Supports non-SCSI storage devices
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Describes layered block devices
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MD raid
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LVM
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0generic devi=
ce mapper
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0loop (partia=
l)
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Shows UUIDs
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Shows mountpoints
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Avoids repeating subtrees when enumerati=
ng raid devices
>>>
>>> I struggled with the last item, until I gave up on bash. =C2=A0I ne=
eded to pass data to subroutines by reference, and bash is sorely lacki=
ng in that area. =C2=A0The new script is in python. =C2=A0I'm releasing=
 this one under the GPL version 2.
>>>
>>> Please give it a whirl.
>>>
>>> Phil
>>>
>>
>> Awesome, however:
>>
>> $ ./lsdrv.py
>> =C2=A0 File "./lsdrv.py", line 301
>> =C2=A0 =C2=A0 print "%s =C2=A0=E2=94=94=E2=94=80Volume Group %s (%s)=
 %s free {%s}" % (indent,
>> vg.name, ','.join([dev.name for dev in vg.PVs]), vg.free, vg.uuid)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^
>> SyntaxError: invalid syntax
>>
>> Maybe it's a copy-paste thing from my mail that does it. Could you p=
ut
>> it somewhere, like a pastebin?
>
> Yeah, should have thought of that first.
>
> http://www.turmel.org/other/lsdrv
>
> HTH,
>
> Phil
>

Aha, Archlinux defaults to python3. If I run the script with python2
it works. :)

~/bin $ sudo python2 lsdrv
PCI [ahci] 00:0b.0 SATA controller: nVidia Corporation MCP79 AHCI
Controller (rev b1)
 =E2=94=9C=E2=94=80scsi 0:0:0:0 ATA Corsair CSSD-F60 {10326505580009990=
027}
 =E2=94=82  =E2=94=94=E2=94=80sda: Partitioned (dos) 55.90g
 =E2=94=82     =E2=94=9C=E2=94=80sda1: (ext4) 100.00m 'ssd_boot' {ae879=
f86-73a4-451f-bb6b-e778ad1b57d6}
 =E2=94=82     =E2=94=82  =E2=94=94=E2=94=80Mounted as /dev/sda1 @ /boo=
t
 =E2=94=82     =E2=94=9C=E2=94=80sda2: (swap) 2.00g 'ssd_swap' {a28e32f=
a-628c-419a-9693-ca88166d230f}
 =E2=94=82     =E2=94=94=E2=94=80sda3: (ext4) 53.80g 'ssd_root' {6e812e=
d7-01c4-4a76-ae31-7b3d36d847f5}
 =E2=94=82        =E2=94=94=E2=94=80Mounted as /dev/disk/by-label/ssd_r=
oot @ /
 =E2=94=9C=E2=94=80scsi 1:0:0:0 ATA WDC WD20EARS-00M {WD-WCAZA1022443}
 =E2=94=82  =E2=94=94=E2=94=80sdb: Partitioned (dos) 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sdb1: MD raid6 (1/7) 1.82t md0 clean i=
n_sync 'ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}
 =E2=94=82        =E2=94=94=E2=94=80md0: PV LVM2_member 9.08t/9.08t VG =
lvstorage 9.08t
{YLEUKB-klxF-X3gF-6dG3-DL4R-xebv-6gKQc2}
 =E2=94=82            =E2=94=94=E2=94=80Volume Group lvstorage (md0) 0 =
free {
Xd0HTM-azdN-v9kJ-C7vD-COcU-Cnn8-6AJ6hI}
 =E2=94=82              =E2=94=94=E2=94=80dm-0: (ext4) 9.08t 'storage'
{0ca82f13-680f-4b0d-a5d0-08c246a838e5}
 =E2=94=82                 =E2=94=94=E2=94=80Mounted as /dev/mapper/lvs=
torage-storage @ /raid6volume
 =E2=94=9C=E2=94=80scsi 2:0:0:0 ATA WDC WD20EARS-00M {WD-WMAZ20152590}
 =E2=94=82  =E2=94=94=E2=94=80sdc: Partitioned (dos) 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sdc1: MD raid6 (3/7) 1.82t md0 clean i=
n_sync 'ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}
 =E2=94=9C=E2=94=80scsi 3:0:0:0 ATA WDC WD20EARS-00M {WD-WMAZ20188479}
 =E2=94=82  =E2=94=94=E2=94=80sdd: Partitioned (dos) 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sdd1: MD raid6 (2/7) 1.82t md0 clean i=
n_sync 'ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}
 =E2=94=9C=E2=94=80scsi 4:x:x:x [Empty]
 =E2=94=94=E2=94=80scsi 5:x:x:x [Empty]
PCI [sata_mv] 05:00.0 SCSI storage controller: HighPoint Technologies,
Inc. RocketRAID 230x 4 Port SATA-II Controller (rev 02)
 =E2=94=9C=E2=94=80scsi 6:0:0:0 ATA WDC WD20EARS-00M {WD-WCAZA3609190}
 =E2=94=82  =E2=94=94=E2=94=80sde: Partitioned (dos) 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sde1: MD raid6 (6/7) 1.82t md0 clean i=
n_sync 'ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}
 =E2=94=9C=E2=94=80scsi 7:0:0:0 ATA SAMSUNG HD204UI {S2HGJ1RZ800964}
 =E2=94=82  =E2=94=94=E2=94=80sdf: Partitioned (dos) 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sdf1: MD raid6 (4/7) 1.82t md0 clean i=
n_sync 'ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}
 =E2=94=9C=E2=94=80scsi 8:0:0:0 ATA WDC WD20EARS-00M {WD-WCAZA1000331}
 =E2=94=82  =E2=94=94=E2=94=80sdg: Partitioned (dos) 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sdg1: MD raid6 (0/7) 1.82t md0 clean i=
n_sync 'ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}
 =E2=94=94=E2=94=80scsi 9:0:0:0 ATA SAMSUNG HD204UI {S2HGJ1RZ800850}
    =E2=94=94=E2=94=80sdh: Partitioned (dos) 1.82t
       =E2=94=94=E2=94=80sdh1: MD raid6 (5/7) 1.82t md0 clean in_sync '=
ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}


Sweet.

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
