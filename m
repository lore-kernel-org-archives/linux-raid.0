From: NeilBrown <neilb@suse.de>
Subject: Re: /sys/block/md126 still exists even after stopping the array
Date: Wed, 25 Jun 2014 11:03:48 +1000
Message-ID: <20140625110348.48ab2d7a@notabene.brown>
References: <53A99B76.3020603@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TSsMTu9C3_y8c0osXLamK9B"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53A99B76.3020603@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/TSsMTu9C3_y8c0osXLamK9B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Jun 2014 17:38:30 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hello,
>=20
> I'm having the folloing behaviour with kernel 3.14.5 and mdadm v3.3.1.
>=20
> After stopping all arrays, I still can see one of them in /sys/block/:
>=20
> # cat /proc/mdstat
> Personalities : [raid1]
> md125 : active raid1 sdb3[1] sda3[0]
>       483688448 blocks super 1.2 [2/2] [UU]
>       [=3D=3D=3D=3D=3D=3D>..............]  resync =3D 34.9% (169161280/48=
3688448)
> finish=3D44.0min speed=3D118852K/sec
>       bitmap: 3/4 pages [12KB], 65536KB chunk
>=20
> md126 : active raid1 sdb2[1] sda2[0]
>       4038656 blocks super 1.2 [2/2] [UU]
>=20
> md127 : active raid1 sdb1[1] sda1[0]
>       524224 blocks super 1.0 [2/2] [UU]
>=20
> unused devices: <none>
>=20
> # mdadm --stop /dev/md12[567]
> mdadm: stopped /dev/md125
> mdadm: stopped /dev/md126
> mdadm: stopped /dev/md127
>=20
> # cat /proc/mdstat
> Personalities : [raid1]
> unused devices: <none>
>=20
> # ls /sys/block/
> md126  sda  sdb  sdc  sr0
>=20
> # ls /sys/block/md126/md/
> array_size  array_state  bitmap  chunk_size  component_size  layout
> level  max_read_errors  metadata_version  new_dev  raid_disks
> reshape_direction  reshape_position  resync_start  safe_mode_delay
>=20
> # dmesg
> ....
> [ 1573.715476] md125: detected capacity change from 495296970752 to 0
> [ 1573.715626] md: md125 stopped.
> [ 1573.715633] md: unbind<sdb3>
> [ 1573.740681] md: export_rdev(sdb3)
> [ 1573.740694] md: unbind<sda3>
> [ 1573.754008] md: export_rdev(sda3)
> [ 1573.773398] md126: detected capacity change from 4135583744 to 0
> [ 1573.773403] md: md126 stopped.
> [ 1573.773410] md: unbind<sdb2>
> [ 1573.820652] md: export_rdev(sdb2)
> [ 1573.820664] md: unbind<sda2>
> [ 1573.873974] md: export_rdev(sda2)
> [ 1573.889904] md127: detected capacity change from 536805376 to 0
> [ 1573.889910] md: md127 stopped.
> [ 1573.889917] md: unbind<sdb1>
> [ 1573.913978] md: export_rdev(sdb1)
> [ 1573.914033] md: unbind<sda1>
> [ 1573.940627] md: export_rdev(sda1)
>=20
> After waiting a couple of min, stopping again md126 worked:
>=20
> [ 1835.755661] md: md126 stopped.
>=20
> Is this expected ?

No overly surprising.

This is probably caused by udev, or something udev runs, opening /dev/md126
after it has been stopped.  This has the effect of creating an empty inacti=
ve
array.
e.g.

 mknod /dev/test b 9 57
 < /dev/test

will make /sys/block/md57 appear.

It is a bit untidy, but shouldn't cause problems.

NeilBrown

--Sig_/TSsMTu9C3_y8c0osXLamK9B
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU6of9Dnsnt1WYoG5AQITjg//Xso22pjPCXFGfpjlGx+Ni16m2l4aWcSj
wAZdFYxFFsxnd+l1orAeR4glTSxUr1EPoi06imIUUn5PX2x4Axv9ZQJen+lahAS+
WOXyV7sBlC7IuQncTFARG02tdVfwVwTVe0f4D357Ltj6B9GXmBCfqSsZwh/iM/UL
U0RFf49wmBMmZx0d9OscAxcKK4pXC58fhAtmYMM4jYGznVPxz3B9c6t4zca6/bSb
VGsABcje/n0RQ/bg7z5Z67t+uBTSOuZgXPa7UZI70EL1hoBu2TcU5x+T5EOsmrFw
r62A+zftXQhydnb5ue1ZmIe5ROlkX4mG7ckOBoWgg4vvWz5fYqOhk5nTtyoz2+PI
9M5kW8h3RT745yKl3kIlICTpg2+tS4k2Ni1el+3mmfQcPfbrvQe+bdQ+UUGbr+nE
DmRPwtTDCahPK87fs5bW3TkcwMdlvXteZ5qLQV90xv7nrBiaoLDk50S/Vq/akHge
8Bx1BXMvdE5xsPGwA5DwMwq2esyNWPN+tayiTWRAbrVag9S+RDhmbWI61C/+NIBa
WAK/GABdoiulvguxd3hWBwPlV+XkDXj0K1vDbIhVlP/HB+DoT3u4kZmZM4eWEWA5
lsgVJyiMeYREP4q6OV+bU7HBZgpD+55ilV2qfFLFf7SBrRjuaBWczKxqa+dVE8Qg
ucvCAZ8m/nY=
=fjw6
-----END PGP SIGNATURE-----

--Sig_/TSsMTu9C3_y8c0osXLamK9B--
