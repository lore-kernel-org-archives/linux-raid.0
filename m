From: NeilBrown <neilb@suse.de>
Subject: Re: help: re-add needed after each reboot
Date: Tue, 8 May 2012 06:49:14 +1000
Message-ID: <20120508064914.18c39f80@notabene.brown>
References: <5d1b39dd26f138ed494e779218d21346.squirrel@anguish.kchang.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/I+/GRcNu2OvjMuaOzLfBplq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d1b39dd26f138ed494e779218d21346.squirrel@anguish.kchang.net>
Sender: linux-raid-owner@vger.kernel.org
To: "D. Lin" <dlbulk-mllr@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/I+/GRcNu2OvjMuaOzLfBplq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 7 May 2012 09:29:03 -0700 "D. Lin" <dlbulk-mllr@yahoo.com> wrote:

> Hi,
>=20
> I am running 3.2.0 (ubuntu 12.04). My raid5 has 3 disks (sd[cbd]1) and no
> spares. The system boots off a non-raid device and auto discovers and
> mounts the raid device.
>=20
> For some reason, sdc1 is not automatically detected and is always missed
> on each boot. I have to re-add it back. What could be causing this?
>=20
> This did not happen while I was running 2.6.38.

Would it be equally accurate to say that it didn't happen when you were
running ubunutu 11.10??  My point is that maybe the important change is not
in the kernel.

What do you have in /etc/mdadm.conf ? (or maybe /etc/mdadm/mdadm.conf)
If you stop the array, then

  mdadm -Asvvv

what messages are generated, and what is the result?

NeilBrown


>=20
> Thanks,
>=20
> Dong Lin
>=20
>=20
> ; mdadm --misc --detail /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Fri Jul 22 22:39:40 2011
>      Raid Level : raid5
>      Array Size : 3907020800 (3726.03 GiB 4000.79 GB)
>   Used Dev Size : 1953510400 (1863.01 GiB 2000.39 GB)
>    Raid Devices : 3
>   Total Devices : 3
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Mon May  7 09:21:29 2012
>           State : active
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>            Name : disc:0
>            UUID : 4195aaa7:0ebd37ce:d4b9481e:1a68f4a8
>          Events : 230784
>=20
>     Number   Major   Minor   RaidDevice State
>        4       8       33        0      active sync   /dev/sdc1
>        2       8       49        1      active sync   /dev/sdd1
>        3       8       17        2      active sync   /dev/sdb1
>=20
>=20
> ----------------------------
>=20
> here is what happened on boot:
>=20
> ; dmesg |grep md
> [    1.781917] md: linear personality registered for level -1
> [    1.789184] md: multipath personality registered for level -4
> [    1.797121] md: raid0 personality registered for level 0
> [    1.801681] md: raid1 personality registered for level 1
> [    1.820485] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00
> irq 14
> [    1.820547] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08
> irq 15
> [    1.920271] md: bind<sdb1>
> [    1.962482] md: bind<sdd1>
> [    2.300917] md: raid6 personality registered for level 6
> [    2.300980] md: raid5 personality registered for level 5
> [    2.301036] md: raid4 personality registered for level 4
> [    2.306171] md: raid10 personality registered for level 10
> [    2.329393] md/raid:md0: device sdd1 operational as raid disk 1
> [    2.329450] md/raid:md0: device sdb1 operational as raid disk 2
> [    2.329792] md/raid:md0: allocated 3228kB
> [    2.329921] md/raid:md0: raid level 5 active with 2 out of 3 devices,
> algorithm 2
> [    2.330235] created bitmap (15 pages) for device md0
> [    2.330706] md0: bitmap initialized from disk: read 1/1 pages, set 0 of
> 29809 bits
> [    2.362404] md0: detected capacity change from 0 to 4000789299200
> [    2.367990]  md0: unknown partition table
>=20
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> partition tables:
>=20
> ; fdisk -l | egrep '^/dev/sd[cbd]'
> /dev/sdb1              63  3907024064  1953512001   fd  Linux raid autode=
tect
> /dev/sdc1              63  3907024064  1953512001   fd  Linux raid autode=
tect
> /dev/sdd1              63  3907024064  1953512001   fd  Linux raid autode=
tect
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/I+/GRcNu2OvjMuaOzLfBplq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6g1Sjnsnt1WYoG5AQLwWA//bd6y4t+fmqOQ3z/7ird4zP81pZhUwnIg
GCkTQD0TSfmyRHcwx4j3JROj6/dkXkyYFjjZ2P39LMF8nG1TIcqRzEUY/gjHW3is
pl5Jcnu0n5E+SYtT43vOOXofFos+kyKtOpEUGjJb0v2/j9uHTz2htaChsIBX5480
mqsdgjbAUtWhG0VwUbv8o+qfeqG13qexUyYxCOcwTtULzwZfOzrNyglIq0TGwtrm
XIgC8LiIcFp4CnAzUrpdG0EYp7nLTG5KFCJtBoEs51zmSG15Qje4ixSpX73LhSBf
vKn2jrENT5UhaGY1jIp5X7etUwfsZ1/zNadNyu+FoCuJxBytKdYvz0ktDJtmr7wg
4s9NfEs72BZIYrTq7EwifEgdFxZ83GqvvLHAnmUkgFuLQcco9r5WuzlDCe2pVtEb
27jG1AxXZuKTRtc08dZe64RjnMCD+7aUnCSus5xh4G6JuJ5UMws2l0Lfeey0qpXT
rANT7NVmX69ohnDQQK90dUYN6/dewLmNhIiSjECGg2mN2xG5p4e0TVechORDNzjC
tKU99YhDB9wznpz5KfOUqnjom8aa5ZLmf7DGpNxEIStvYCA8K2NO+GzNvTElV4Vy
oGwaXoqDrnyUr7+dRMK7PondzM4kc2FnG5STUvIbs8eix8lxJB9L+YQZpmc8Vl2N
4Ohj9lazQV8=
=9nwg
-----END PGP SIGNATURE-----

--Sig_/I+/GRcNu2OvjMuaOzLfBplq--
