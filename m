From: NeilBrown <neilb@suse.de>
Subject: Re: Unable to reduce raid size.
Date: Fri, 18 Jul 2014 19:40:43 +1000
Message-ID: <20140718194043.1c938b2c@notabene.brown>
References: <53C8DFEE.7000000@megasoft.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/A.ZcT1q3FW2tzpOfpCY=W+P"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53C8DFEE.7000000@megasoft.be>
Sender: linux-raid-owner@vger.kernel.org
To: Killian De Volder <killian.de.volder@megasoft.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/A.ZcT1q3FW2tzpOfpCY=W+P
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Jul 2014 10:50:54 +0200 Killian De Volder
<killian.de.volder@megasoft.be> wrote:

> Hello,
>=20
> I have a strange issue, I cannot reduce the size of a degraded raid 5:
>=20
> strace mdadm -vv --grow /dev/md125 --size=3D2778726400
>=20
> Fails with:
> Stace:
>     open("/sys/block/md125/md/dev-sdb4/size", O_WRONLY) =3D 4
>     write(4, "2778726400", 10)              =3D -1 EBUSY (Device or resou=
rce busy)
>     close(4)

This condition isn't treated as an error by mdadm, so it isn't the cause.

Could you post the entire strace (really, bytes a cheap, alway provide more
detail than you think is needed.... though you did provide quite a bit)

Any kernel messages (dmesg output) ??

NeilBrown


> Stdout:
>     component size of /dev/md125 unchanged at 2858285568K
> Stderr:
>     <nothing>
>=20
>=20
> Any suggestions ?
> Note: I can work around this bug, by moving partitions around a bit, and =
not requiring the size reduction.
> However I suspect a bug/undocumented border case that should be resolved?
>=20
>=20
> Things I tried:
> ---------------
> - Disable bcache udev rules (as it was appearing in each attempt, maybe i=
t got triggered during resize, seems not to be the case).
> - I have tried the same with loop files -> this works fine even with bcac=
he (and the udev rules disabled)
> - Removed the internal write bitmap
> - Opend the file os.open("md125",os.O_EXCL,os.O_RDWR) in Python to test i=
f it's in use somewhere (command worked fine)
> - Set array-size to the less then the desired new size (while still not d=
estroying the FS below it).
>=20
> =20
> Information:
> ------------
> Kernel version: 3.15.5
> mdadm tools: 3.3-r2
>=20
> mdadm --detail:
> /dev/md125:
>         Version : 1.2
>   Creation Time : Wed Apr 16 20:58:09 2014
>      Raid Level : raid5
>      Array Size : 8283750400 (7900.00 GiB 8482.56 GB)
>   Used Dev Size : 2858285568 (2725.87 GiB 2926.88 GB)
>    Raid Devices : 4
>   Total Devices : 3
>     Persistence : Superblock is persistent
>=20
>     Update Time : Fri Jul 18 09:53:08 2014
>           State : clean, degraded
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>            UUID : 885c588b:c3503d9d:c67b86db:2887f8f7
>          Events : 6440
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       36        0      active sync   /dev/sdc4
>        2       0        0        2      removed
>        2       8       20        2      active sync   /dev/sdb4
>        4       8       52        3      active sync   /dev/sdd4
>=20


--Sig_/A.ZcT1q3FW2tzpOfpCY=W+P
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8jrnDnsnt1WYoG5AQI/iQ//apYzAlaNIitduCgzClcCgPRAnRLr6YZZ
Y4hn581pIBTXG/9nIO28EdB65xsbPreUrgAqqD3JYgA5rCg83+5ePtexOgZ53EvR
IiTmcXJDrNZDBVYjcvED+9gk5CZTQHbQIoALYy5vq1QuuXSooT+vokYpT+8CEft5
JUypdALkkAH57ooIkuUVie49Al6KZpGQQ5FwszMJ+/pcr6fPADm6ou0Tednc3c5Q
lsK/JW3I3YI88TsstnRqXXBdZ9tPuiOnrUNIW62W41FQV+6Ae5IErgwuX2d83QJI
t9BrGcFQROegOMZjarmwpK5TS22w7sJz37sQbIZP6F1VSaOKI/NFKzC3H41e5mU1
NRHPj7zcabPQvlTTi2IGFkz/lPps+z7axrl1m7jWHdkQfOiJYmm+Zwjy4/Qjowl9
dz7yJxY1G+eNoMZyZmhg3HNAyVGZQTk0lmCuNvG6rwXObvGmaOrlJBxJcjcFuACR
FinGzccY7PRqQkXu9ClIfaROpZUKTM84IVfElDA/RWBDDo76Qj6uGcKSiJqT0Wsi
NLFVsMkyO8mbNlaS+MU5SuGmSfencdBoYXx/iqs+Yz+l9+b+3LL7+ibEtKo/SpT0
zt7nGT5aZNfo8WnDOMq5qlAGsiVUVQ2667DjDPs1SPf3PSVD2pABZKrwMLZu3oJ7
m2eohDjb0cU=
=l7gI
-----END PGP SIGNATURE-----

--Sig_/A.ZcT1q3FW2tzpOfpCY=W+P--
