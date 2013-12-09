From: NeilBrown <neilb@suse.de>
Subject: Re: How to assemble 4-disk raid5 with one broken disk and one
 marked as spare by operator error?
Date: Mon, 9 Dec 2013 14:46:45 +1100
Message-ID: <20131209144645.70e01149@notabene.brown>
References: <Pine.LNX.4.61.1312082056110.13787@envy.nxs.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/teAYh927ZcZu=2YfxlnKxub"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.1312082056110.13787@envy.nxs.se>
Sender: linux-raid-owner@vger.kernel.org
To: Tomas Agartz <tlund@nxs.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/teAYh927ZcZu=2YfxlnKxub
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Dec 2013 21:04:42 +0100 (CET) Tomas Agartz <tlund@nxs.se> wrote:

> After booting a server that had been powered off for some time, the 4-dis=
k=20
> raid5 device was up and running in read-only mode with one disk missing.=
=20
> After a, in hindsight, hasty decision, "mdadm --manage --add /dev/md0=20
> /dev/sdd" was executed to re-add the missing device to the array.
>=20
> At this time, all hell broke loose :) The first thing that happened was=20
> that sdd was added as a spare instead of re-added as expected. The second=
=20
> thing was that a different disk, sdb, was kicked from the array because o=
f=20
> read/sata-bus errors. The root disk also bailed and the system had to be=
=20
> powercycled.

If you want to re-add, it is safest to ask mdadm to --re-add, not to --add.

>=20
> The real problem, from the start, was probably that sdb was bad all along=
,=20
> but from some reason sdd was the device missing from the array after the=
=20
> initial boot.
>=20
> Trying to read data from sdb gives read errors and timeouts, but I was=20
> able to do "mdadm --examine" after resetting the sata port.
>=20
> The current state is that, out of 4 disks two are good (sde and sdf), one=
=20
> is (in error) marked as a spare (sdd), and the fourth device is unusable=
=20
> (sdb).
>=20
> What is the correct method do change the spare disk back to a data disk=20
> and try to restart the array with 3 out of 4 devices (sdd, sde and sdf)?
>=20

The only real option at this point is to --create the array.  There isn't
enough information for mdadm to be able  to do anything clever.

> The device has never had a spare, so I think that sdd used to be "Active=
=20
> device 0" before this happened?
>=20
> Possibly relevant data from mdadm --examine on the four devices:
>=20
> sdb          State : clean
> sdb         Events : 333560
> sdb   Device Role : Active device 3
> sdb   Array State : .AAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> sdd          State : clean
> sdd         Events : 333562
> sdd   Device Role : spare
> sdd   Array State : .AA. ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> sde          State : clean
> sde         Events : 333562
> sde   Device Role : Active device 1
> sde   Array State : .AA. ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> sdf          State : clean
> sdf         Events : 333562
> sdf   Device Role : Active device 2
> sdf   Array State : .AA. ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> If no one else has any better suggestions, my best guess would be to:=20
> "mdadm --create /dev/md0 --level=3D5 --raid-devices=3D4 --assume-clean=20
> /dev/sdd /dev/sde /dev/sdf missing" (the device was created with default=
=20
> values, metadata 1.2, chunk size 512K, layout left-symmetric).

Check the "Data Offset" of the devices and make sure the newly created array
gets the same "Data Offset" (it can explicitly be set with the latest mdadm=
).

NeilBrown


>=20
> (Other crazy ideas involve editing the superblock of sdd and making it=20
> device 0 and then trying to start the array after that).
>=20
> Best regards,
> Tomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/teAYh927ZcZu=2YfxlnKxub
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqU9JTnsnt1WYoG5AQIFRQ//emJ4CtQgi2dGO2iUkjl2/NyOz4KS/+Jn
lJ0gkB55Nq7x43ikHR2SGNEkz9tppGMEiCTVML1Cp2TfXKQsbHx4M6dbjiBq8938
J4JcM4ruj7dMBHbkIiPTYJIwDjhem+UGSIEO4q5Ie6w0gFJYscgG/j3inKis6YlM
YoamGIcCOLQ2U2sQBOJ1+SxByyFnI74Gr1ftqmZ+jCOxEMrvOSXjdx23jVTA0Bgy
XZN1YIJ2og9JUa5iemPj5yIL/tl1IlC03/rAa8Y/gQeqxvbBe/Cdhbs9RncmrIUo
ecxQC+1cCETdYMssp04iLxKRc74TWSPze9E5BQwtUkutIjfYigo/0ziQgOKNbg9t
7CqmP5UTenG6Xl9yUqXS4+/RE636YK4Z1JOFriUHlu/m8pvORvQmAxB5dSJ81Ybd
vlwio/g0NIlVVlAtM2an/Mcupx3hqhqM08ZFNjzHBEmitfO24DMtvzgaYyzCMKSN
3x2F/sErOO8iQwkXfR/YTf6D/tgxN22uziSYOb0NN0qGqEhHpuzP71eFoH++ZkaN
Tqmz7Na7Yhhh9Ni2wFvProakPGnYfYmjW/eXc3wMkzbp4W23A4n21mrbBqPar2DT
Ppm/pgJQKk9+Uzp5E+8XTrHd0gBPuwY6UXWLwsT3uThDJVRkyUPuQa3jbiBZqkCI
AHOqnVe1O1w=
=UwUE
-----END PGP SIGNATURE-----

--Sig_/teAYh927ZcZu=2YfxlnKxub--
