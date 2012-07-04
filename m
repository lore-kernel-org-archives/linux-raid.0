From: NeilBrown <neilb@suse.de>
Subject: Re: md raid6 deadlock on write
Date: Wed, 4 Jul 2012 11:38:11 +1000
Message-ID: <20120704113811.180be107@notabene.brown>
References: <20120629194600.GA23859@calhariz.com>
	<20120702221508.GA24801@calhariz.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JPmYJrmrYb7ZJyB2.MVRMVR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120702221508.GA24801@calhariz.com>
Sender: linux-raid-owner@vger.kernel.org
To: jose.spam@netvisao.pt
Cc: jose.calhariz@netvisao.pt, linux-raid@vger.kernel.org, ns-list@dsi.ist.utl.pt
List-Id: linux-raid.ids

--Sig_/JPmYJrmrYb7ZJyB2.MVRMVR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Jul 2012 23:15:08 +0100 Jose Manuel dos Santos Calhariz
<jose.calhariz@netvisao.pt> wrote:

>=20
> We have a group of servers with a LVM over a RAID6 of 16 drives.
> During normal work loads, sometimes, the md raid enter on deadlock for
> writes and only a power off/power on allows to recover the machine.

This might be fixed by the following commit which was recently included in
3.5-rc. If could test with that I'd appreciate it.

>=20
>   - there is information from "SysRq : Show State", not attached
>     because is too big,

How big is too big?  It is very hard to see if there is anything useful in
there if I cannot see it....

NeilBrown


>=20
>   - in attach the output of "iostat -dx 1",
>=20
>   - the "avgqu-sz" of the logical volume used for fio tests was
>     76280.00,
>=20
>   - in attach the output of "ps ax".
>=20
>=20
>         Jose Calhariz
>=20
>=20
>=20
>=20


--Sig_/JPmYJrmrYb7ZJyB2.MVRMVR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/Oegznsnt1WYoG5AQLuDhAApcmnnQj9FpxF3ZXZoACXlxOdaPfqfmqG
6z6ZR4MAgBgGChvoff6Ifa87wyQUqpZl+Pg8WDDqCQUbSETaey1UCnQiIksULqMw
igJMHYFJmU0101ORDPtgGjcJySgIH3JeAchyv1s+UtqP1XxG2WDnlsJbBnxqfqSx
JFQlaAPgXa0OFzw2oomoIryEsLqmNG9DM2lB9KdAuRVARd0kk79OwaN2B+DXef5x
xaVriJlH2wmLkRAPxuo3es3O/j00L1RO+/b71e+cy4Ch1DNwDo5DeJrvOHV0KtqZ
L9Iho1OWZBqCJP/0wBPcD1pqzd4y8BJ0TQ0HKcay6dFX3zYM/EQI+8eYZ/ZhvFzU
UjX1eu53/FaEtXn1yOCyksQBd9wEeBs7w8foXFwopF754VkquNKI0I6BTYYpaqdw
VWDwybqmSUHWZ5Q7AY8cLtYbY/4frej6UAUudFtu7/Yuli4AcbyS0B/kJsikP6Wl
RcssvsnRA/g3h/JCfNOQifapAfqYB9C4czzUpq0jvLmeyopWer7VR0LibdLISmq1
zN9GvFg02FWgObG2UPjrmQHdAfUgbs8qy3X/37DDPm52CzkMut5s4ND/PEQlXPVS
vLkyOnCPPLkt/jIpoUTOYMhsEfpyvTXnN8Po1FrGCZ8KF6q0eGZDgo6hTPMHrGyd
u29uiR4jKB4=
=ZH+X
-----END PGP SIGNATURE-----

--Sig_/JPmYJrmrYb7ZJyB2.MVRMVR--
