From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm expanded 8 disk raid 6 fails in new server, 5 original
 devices show no md superblock
Date: Tue, 14 Jan 2014 08:14:54 -0500
Message-ID: <52D5384E.6030408@turmel.org>
References: <1389422546.11328.15.camel@achilles.aeskuladis.de>	 <52D183B5.3060006@turmel.org>	 <1389632980.11328.104.camel@achilles.aeskuladis.de>	 <52D4337F.4050307@turmel.org> <1389695513.11328.158.camel@achilles.aeskuladis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1389695513.11328.158.camel@achilles.aeskuladis.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?Ikdyb8Ofa3JldXR6LCBKdWxpYW4i?= <Julian.Grosskreutz@med.uni-jena.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids

On 01/14/2014 05:31 AM, Gro=C3=9Fkreutz, Julian wrote:
> Hi Phil,
>=20
> thanks again for bearing with me.

No problem.

>>>>> Model: ATA ST3000DM001-9YN1 (scsi)
>>
>> Aside: This model looks familiar.  I'm pretty sure these drives are
>> desktop models that lack scterc support.  Meaning they are *not*
>> generally suitable for raid duty.  Search the archives for combinati=
ons
>> of "timeout mismatch", "scterc", "URE", and "scrub" for a full
>> explanation.  If I've guessed correctly, you *must* use the driver
>> timeout work-around before proceeding.
>>
>=20
> Yes I did, and smartctl showed no significant problems.

?.  What did "smartctl -l scterc" say?  If it says unsupported, you hav=
e
a problem.  The workaround is to set the driver timeouts to ~180 second=
s
for each such drive.

If scterc is supported, but disabled, you can set 7-second timeouts wit=
h
"smartctl -l scterc,70,70", but you must do so on every power cycle.
Either way, you need boot-time scripting or distro support.

Raid-rated drives power up with a reasonable setting here.

> The 10 year old
> server (supermicro enterprise grade dual Xeon with 8 GB ECC RAM) had
> started to create problems early January which is why I wanted to mov=
e
> the drives to a new server in the first place, to then transfer the d=
ata
> to a new set of enterprise grade disks. I had checked the memory and =
the
> disks in a burn in for several days including time out and power savi=
ng
> before I set up the raid 2012/2013, and did not have any issues then.

Ok.  This makes sense.

> One of the reasons I tend use mdadm is that I am able to utilize
> existing hardware to create bridging solutions until money comes in f=
or
> better hardware, and moving an mdadm raid has so far never created a
> serious problem.

Many people discover the timeout problem the first time they have an
otherwise correctable read error in their array, and the array falls
apart instead.  This list's archives are well-populated with such cases=
=2E

>>> So attached You will find hexdumps of 64k of /sda/sd[a-h]2 at secto=
r 0
>>> and 262144 which shows the superblock 1.2 on sd[fgh]2, not on sd[a-=
e]2,
>>> but may help to identify data_offset; I suspect it is 2048 on sd[a-=
e]2
>>> and 262144 on sd[fgh]2.
>>>
>>
>> Jackpot!  LVM2 embedded backup data at the correct location for mdad=
m
>> data offset =3D=3D 262144.  And on /dev/sda2, which is the only devi=
ce that
>> should have it (first device in the raid).
>>
>> From /dev/sda2 @ 262144:
>>
>>> 00001200  76 67 5f 6e 65 64 69 67  73 30 32 20 5d 0a 69 64  |vg_ned=
igs02 ].id|
>>> 00001210  20 3d 20 22 32 4c 62 48  71 64 2d 72 67 42 9f 6e  | =3D "=
2LbHqd-rgB.n|
>>> 00001220  45 4a 75 31 2d 32 52 36  31 2d 41 35 f5 75 2d 6e  |EJu1-2=
R61-A5.u-n|
>>> 00001230  49 58 53 2d 66 79 4f 36  33 73 22 0a 73 65 3a 01  |IXS-fy=
O63s".se:.|
>>> 00001240  6f 20 3d 20 33 36 0a 66  6f 72 6d 61 ca 24 3d 20  |o =3D =
36.forma.$=3D |
>>> 00001250  22 6c 76 6d 32 22 20 23  20 69 6e 66 6f 72 6b ac  |"lvm2"=
 # infork.|
>> ...
>>> 00001a70  20 31 33 37 35 32 38 37  39 37 39 09 23 20 d2 32  | 13752=
87979.# .2|
>>> 00001a80  64 20 4a 75 6c 20 33 31  20 31 38 3a af 37 3a 31  |d Jul =
31 18:.7:1|
>>> 00001a90  39 20 32 30 31 33 0a 0a  00 00 00 00 00 00 ee 12  |9 2013=
=2E.........|
>>
>> Note the creation date/time at the end (with a corrupted byte):
>>
>> Jul 31 18:?7:19 2013
>>
>> There are other corrupted bytes scattered around.  I'd be worried ab=
out
>> the RAM in this machine.  Since you are using non-enterprise drives,=
 I'm
>> going to go out on a limb here and guess that the server doesn't hav=
e
>> ECC ram...
> see above

Understood.  With really old memory, double-faults in the ECC could hav=
e
panic'd the server, leaving scattered data unwritten.

>> Consider performing an extended memcheck run to see what's going on.
>> Maybe move the entire stack of disks to another server.
>>
> Thats what I did initially, moved it back because it failed, now will
> move again into the new server before proceeding.

Ok.

>> Based on the signature discovered above, we should be able to --crea=
te
>> --assume-clean with the modern default data offset.  We know the
>> following device roles:
>>
>> /dev/sda2 =3D=3D 0
>> /dev/sdf2 =3D=3D 5
>> /dev/sdg2 =3D=3D 6
>> /dev/sdh2 =3D=3D spare
>>
>> So /dev/sdh2 should be left out until the array is working.
>>
>> Please re-execute the "mdadm -E" reports for /dev/sd[fgh]2 and show =
them
>> uncut.  (Use the lasted mdadm.)  That should fill in the likely devi=
ce
>> order of the remaining drives.

Hmmm.  Typo on my part: s/lasted/latest/  Newer mdadm will give more
information.  In particular, I wanted the tail of each report where eac=
h
device lists what it last knew about all of the other devices' roles.

> [root@livecd mnt]# mdadm -E /dev/sd[fgh]2
>=20
> /dev/sdf2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 32d82f84:fe30ac2e:f589aaef:bdd3e4c7
>            Name : 1
>   Creation Time : Wed Jul 31 18:24:38 2013
>      Raid Level : raid6
>    Raid Devices : 7
>=20
>  Avail Dev Size : 5858314240 (2793.46 GiB 2999.46 GB)
>      Array Size : 29285793280 (13964.55 GiB 14994.33 GB)
>   Used Dev Size : 5857158656 (2792.91 GiB 2998.87 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : d5a16cb2:ff41b9a5:cbbf12b7:3750026d
>=20
>     Update Time : Mon Dec 16 01:16:26 2013
>        Checksum : ee921c43 - correct
>          Events : 327
>=20
>          Layout : left-symmetric
>      Chunk Size : 256K
>=20
>    Device Role : Active device 5
>    Array State : A.AAAAA ('A' =3D=3D active, '.' =3D=3D missing)

I was expecting more info after this.

> /dev/sdg2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 32d82f84:fe30ac2e:f589aaef:bdd3e4c7
>            Name : 1
>   Creation Time : Wed Jul 31 18:24:38 2013
>      Raid Level : raid6
>    Raid Devices : 7
>=20
>  Avail Dev Size : 5858314240 (2793.46 GiB 2999.46 GB)
>      Array Size : 29285793280 (13964.55 GiB 14994.33 GB)
>   Used Dev Size : 5857158656 (2792.91 GiB 2998.87 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : a1e1e51b:d8912985:e51207a9:1d718292
>=20
>     Update Time : Mon Dec 16 01:16:26 2013
>        Checksum : 4ef01fe9 - correct
>          Events : 327
>=20
>          Layout : left-symmetric
>      Chunk Size : 256K
>=20
>    Device Role : Active device 6
>    Array State : A.AAAAA ('A' =3D=3D active, '.' =3D=3D missing)

And here.

> /dev/sdh2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 32d82f84:fe30ac2e:f589aaef:bdd3e4c7
>            Name : 1
>   Creation Time : Wed Jul 31 18:24:38 2013
>      Raid Level : raid6
>    Raid Devices : 7
>=20
>  Avail Dev Size : 5858314240 (2793.46 GiB 2999.46 GB)
>      Array Size : 29285793280 (13964.55 GiB 14994.33 GB)
>   Used Dev Size : 5857158656 (2792.91 GiB 2998.87 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 030cb9a7:76a48b3c:b3448369:fcf013e1
>=20
>     Update Time : Mon Dec 16 01:16:26 2013
>        Checksum : a1330e97 - correct
>          Events : 327
>=20
>          Layout : left-symmetric
>      Chunk Size : 256K
>=20
>    Device Role : spare
>    Array State : A.AAAAA ('A' =3D=3D active, '.' =3D=3D missing)

And here.

>> Also, it is important that you document which drive serial numbers a=
re
>> currently occupying the different device names.  An excerpt from "ls=
 -l
>> /dev/disk/by-id/" would do.
>=20
> scsi-SATA_ST3000DM001-9YN_S1F026VJ -> ../../sda
> scsi-SATA_ST3000DM001-9YN_W1F0TB3C -> ../../sdb
> scsi-SATA_ST3000DM001-9YN_S1F04KAK -> ../../sdc
> scsi-SATA_ST3000DM001-9YN_W1F0RWJY -> ../../sdd
> scsi-SATA_ST3000DM001-9YN_S1F08N7Q -> ../../sde
> scsi-SATA_ST3000DM001-9YN_Z1F1F3TC -> ../../sdf
> scsi-SATA_ST3000DM001-9YN_W1F1ZZ9T -> ../../sdg
> scsi-SATA_ST3000DM001-9YN_Z1F1X0AC -> ../../sdh

Ok.  Be sure to recheck this list any time you boot, since the device
order matters.

> I am a bit more relaxed now because I found that a scheduled transfer=
 of
> the data to the university tape robot had completed before christmas.=
 So
> this local archive mirror is (luckily) not critical. I still want to
> understand whether all this is just a result of shaky hardware, or an
> mdadm (misuse) issue. Losing (all superblocks on) five drives in a la=
rge
> software raid 6 instead of bytes is not something I would like to rep=
eat
> any time soon by ie. mishandling mdadm.

I think you skated over the edge due to a flaky motherboard.  mdadm
can't fix that.  In fact, since you have a backup, I personally wouldn'=
t
bother further reconstruction efforts.  If you have a recent
vgcfgbackup, it's doable, but I have little confidence in the device
order: [a????fg], probably [abcdefg].  There's 4! =3D=3D 24 permutation=
s
there, each of which will require a vgcfgrestore before you can check
the reconstruction with "fsck -n".

> We have then
>=20
> Wed Jul 31 18:24:38 2013 on sdf-h2 for creation of the raid6 and
> wed Jul 31 18:?7:19 2013 for creation of the lvm group
>=20
> could well be.

I don't see any way to get such a timestamp except "certainly was".

> So I will move the disks to the new server, make 1:1 copies to new
> drives and then attempt an assembly using --assume-clean in which
> order ?

All permutations of [a????fg] with b, c, d, and e.

Try likely combinations gleaned from "mdadm -E" reports first to
shortcut the process.

> Thanks so much, I have learned a lot already.

You are welcome, and good luck.

Regards,

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
