From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm -add doesn't start rebuilding array
Date: Tue, 21 Aug 2012 08:30:40 +1000
Message-ID: <20120821083040.0d466ceb@notabene.brown>
References: <5032050A.4000801@supersystem.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EO64ts6ngjRO5wj_b0+X606"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5032050A.4000801@supersystem.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Sergiusz =?UTF-8?Q?Brzezi=C5=84ski?= <Sergiusz.Brzezinski@supersystem.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/EO64ts6ngjRO5wj_b0+X606
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Aug 2012 11:36:10 +0200 Sergiusz Brzezi=C5=84ski
<Sergiusz.Brzezinski@supersystem.pl> wrote:

> Hi,
>=20
> My system is Ubuntu 12.04, kernel 3.2.0-27. mdadm: 3.2.3
>=20
> If I do:
>=20
> # mdadm /dev/md0 -a /dev/sdc3
>=20
> then nothing happen! No message on command line, no info in logs!
>=20
> Man mdadm says:
>=20
> -a, --add
> hot-add listed devices.  If a device appears to have recently been part o=
f the=20
> array (possibly it failed or was removed) the device is  re-added  as  de=
scribe=20
>   in  the  next point.   If  that  fails  or the device was never part of=
 the=20
> array, the device is added as a hot-spare.  If the array is degraded, it =
will=20
> immediately start to rebuild data onto that spare.
>=20
> But array doesn't wont to rebuild.
>=20
> But not exactly. The bad info is, that sometimes it works and sometimes i=
t doesn't.
>=20
> And if I restart the system, the array SOMETIMES start rebuilding and som=
ethimes=20
> doesn't!
>=20
> There is no information what's up (comnand line or logs) so I don't know =
what to do.
>=20
>=20
>=20
> I describe bellow the whole procedure:
>=20
> 1.
> There ist a working Raid1 array:
>=20
> # cat /proc/mdstat
>=20
> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [rai=
d4]=20
> [raid10]
> md0 : active raid1 sda3[2] sdb3[3]
>        115999672 blocks super 1.0 [2/2] [UU]
>        bitmap: 0/1 pages [0KB], 65536KB chunk
>=20
> # mdadm --detail /dev/md0
>=20
> /dev/md0:
>          Version : 1.0
>    Creation Time : Wed Aug  1 15:45:56 2012
>       Raid Level : raid1
>       Array Size : 115999672 (110.63 GiB 118.78 GB)
>    Used Dev Size : 115999672 (110.63 GiB 118.78 GB)
>     Raid Devices : 2
>    Total Devices : 2
>      Persistence : Superblock is persistent
>=20
>    Intent Bitmap : Internal
>=20
>      Update Time : Mon Aug 20 11:10:00 2012
>            State : active
>   Active Devices : 2
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 0
>=20
>             Name : linux:0
>             UUID : b7407176:2e88c73d:2c85e940:05ff7e06
>           Events : 5897
>=20
>      Number   Major   Minor   RaidDevice State
>         3       8       19        0      active sync   /dev/sdb3
>         2       8        3        1      active sync   /dev/sda3
>=20
>=20
> 2.
> I remove (phisicaly) the "/dev/sdb" drive of the box (hot-swap)
>=20
> # cat /proc/mdstat
>=20
> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [rai=
d4]=20
> [raid10]
> md0 : active raid1 sda3[2] sdb3[3](F)
>        115999672 blocks super 1.0 [2/1] [_U]
>        bitmap: 1/1 pages [4KB], 65536KB chunk
>=20
> # mdadm --detail /dev/md0
> /dev/md0:
>          Version : 1.0
>    Creation Time : Wed Aug  1 15:45:56 2012
>       Raid Level : raid1
>       Array Size : 115999672 (110.63 GiB 118.78 GB)
>    Used Dev Size : 115999672 (110.63 GiB 118.78 GB)
>     Raid Devices : 2
>    Total Devices : 2
>      Persistence : Superblock is persistent
>=20
>    Intent Bitmap : Internal
>=20
>      Update Time : Mon Aug 20 11:11:58 2012
>            State : active, degraded
>   Active Devices : 1
> Working Devices : 1
>   Failed Devices : 1
>    Spare Devices : 0
>=20
>             Name : linux:0
>             UUID : b7407176:2e88c73d:2c85e940:05ff7e06
>           Events : 5908
>=20
>      Number   Major   Minor   RaidDevice State
>         0       0        0        0      removed
>         2       8        3        1      active sync   /dev/sda3
>=20
>         3       8       19        -      faulty spare
>=20
>=20
> 3.
> I insert the drive again - it become "/dev/sdc" instead of "/dev/sdb"
>=20
> 4.
> And now I do the following to rebuild the array:
>=20
> # mdadm /dev/md0 -a /dev/sdc3
>=20
> mdadm: /dev/sdc3 reports being an active member for /dev/md0, but a --re-=
add fails.
> mdadm: not performing --add as that would convert /dev/sdc3 in to a spare.
> mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdc3" firs=
t.
>=20
> I have never seen this messages before (on another systems). But this is =
not a=20
> problem. I do, what they suggest:
>=20
> # mdadm --zero-superblock /dev/sdc3
>=20
> # mdadm --examine /dev/sdc3
> mdadm: No md superblock detected on /dev/sdc3.
>=20
> 5.
> And now I try again rebuild the array:
>=20
> # mdadm /dev/md0 -a /dev/sdc3
>=20
> ... and nothing happen! No message, no info. I repeat some times the comm=
and.
>=20
> I also try this:
>=20
> # mdadm /dev/md0 -a -vv --force /dev/sdc3
>=20
> ... also nothing. Somethimes, if I repeat the command one by one, in logs=
 appear=20
> the line:
>=20
> Aug 20 11:30:52 serwer-linmot kernel: [ 1978.111282] md: export_rdev(sdc3)
>=20
> ... and nothing else
>=20
>=20
> # mdadm --examine /dev/sdc3
> /dev/sdc3:
>            Magic : a92b4efc
>          Version : 1.0
>      Feature Map : 0x1
>       Array UUID : b7407176:2e88c73d:2c85e940:05ff7e06
>             Name : linux:0
>    Creation Time : Wed Aug  1 15:45:56 2012
>       Raid Level : raid1
>     Raid Devices : 2
>=20
>   Avail Dev Size : 231999344 (110.63 GiB 118.78 GB)
>       Array Size : 231999344 (110.63 GiB 118.78 GB)
>     Super Offset : 231999472 sectors
>            State : clean
>      Device UUID : f1a1f291:e10d85cc:b574c6d2:45fc0c5d
>=20
> Internal Bitmap : -8 sectors from superblock
>      Update Time : Mon Aug 20 11:17:07 2012
>         Checksum : 71bcac04 - correct
>           Events : 0
>=20
>=20
>     Device Role : spare
>     Array State : .A ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>=20
> # mdadm --detail /dev/md0
>=20
> /dev/md0:
>          Version : 1.0
>    Creation Time : Wed Aug  1 15:45:56 2012
>       Raid Level : raid1
>       Array Size : 115999672 (110.63 GiB 118.78 GB)
>    Used Dev Size : 115999672 (110.63 GiB 118.78 GB)
>     Raid Devices : 2
>    Total Devices : 2
>      Persistence : Superblock is persistent
>=20
>    Intent Bitmap : Internal
>=20
>      Update Time : Mon Aug 20 11:18:43 2012
>            State : active, degraded
>   Active Devices : 1
> Working Devices : 1
>   Failed Devices : 1
>    Spare Devices : 0
>=20
>             Name : linux:0
>             UUID : b7407176:2e88c73d:2c85e940:05ff7e06
>           Events : 5946
>=20
>      Number   Major   Minor   RaidDevice State
>         0       0        0        0      removed
>         2       8        3        1      active sync   /dev/sda3
>=20
>         3       8       19        -      faulty spare
>=20
>=20
> Can anyone help?
>=20

I cannot see why that would happen.
It seems to be failing somewhere in bind_rdev_to_array, but I don't know
where.
Can you run
  strace -o /tmp/strace mdadm /dev/md0 --add /dev/sdc3
and post the output ... or at last the tail end of the output.  There should
be an ioctl which fails and I need to know what the error was (EEXIST,
EINVAL, ENOSPC are the likely ones).  But don't just post that line, include
at least the last 100 lines.

NeilBrown

--Sig_/EO64ts6ngjRO5wj_b0+X606
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUDK6ojnsnt1WYoG5AQIgyw/+OWFi/gz43gnNwo/Xx19qKaMImuLEJiIP
/DSDlSw4HHt1q706uhW5abvaaoJl3L8RDWuC+WXaM5VvFxdfXL4XHe+UBA6i9IZ/
qvlY0cuB3cKpTMGXkOaft01GjMn+kyjX4f36qbIcTOROB8NOiZik/DRNCTjjIqoQ
SFZ99JWPCUqWrs61mRZ//rmPjhNBj0i1u+aIxXLf67lRilVagpjbW80GIIkqa7dE
Rqsd8BSwg55TKUsZDExCkDAS6WrwSBhuu3YHm4JNV1HUMqi3cRXCiZJJ0K4HmMLZ
12dTVC/kirlAqfQ1Hb44DwTmhCnuww5kYUAwnd+aCmm+W1u/T68PmDNU6aTDMN5p
BCyNWZAetfXxJXoAKMBSUNMl/x8wtVHl7sj8mlXaf5Jo1oStutvRNiYn1ha8WIh2
vc0PBqOgz1cqaL5Hvmnk3Xlm+aQXB1aAgkYifCp+NbTtwGsXfGeQIztxzzET3Sqm
lUUOupZyFTzFVbwc9zzEeze37CrXuu+mk+jl6ZW6LMgW6zWv9oVnaw4i4oXf39ZN
hg2J0/6gZR7ajoYlBgsfMlrOPwR+HrLZRhTIoU2KZOK+BM21Td5GZM29xqjEf9TK
BJTZ8IMTvx1L8Dl97r/64VuL6sYNRtToNPXcWmZq6IcOlBs7H3HoltX3jWkdnb8U
yTN5y2Rqh40=
=dKcn
-----END PGP SIGNATURE-----

--Sig_/EO64ts6ngjRO5wj_b0+X606--
