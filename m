From: Andre Noll <maan@systemlinux.org>
Subject: Re: raid5: degraded after reboot
Date: Fri, 12 Oct 2007 17:47:55 +0200
Message-ID: <20071012154755.GE21133@skl-net.de>
References: <cccedfc60710120838nd2bb38pf57f03faa803b6c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="19uQFt6ulqmgNgg1"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60710120838nd2bb38pf57f03faa803b6c6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--19uQFt6ulqmgNgg1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:38, Jon Nelson wrote:
> <4>md: kicking non-fresh sda4 from array!
>=20
> what does that mean?

sda4 was not included because the array has been assembled previously
using only sdb4 and sdc4. So the data on sda4 is out of date.

> I also have this:
>=20
> raid5: raid level 5 set md0 active with 2 out of 3 devices, algorithm 2
> RAID5 conf printout:
>  --- rd:3 wd:2 fd:1
>  disk 1, o:1, dev:sdb4
>  disk 2, o:1, dev:sdc4

This looks normal. The array is up with two working disks.

> Why was /dev/sda4 kicked?

Because it was non-fresh ;)

> md0 : active raid5 sda4[3] sdb4[1] sdc4[2]
>       613409664 blocks level 5, 64k chunk, algorithm 2 [3/2] [_UU]
>       [=3D=3D>..................]  recovery =3D 13.1% (40423368/306704832)
> finish=3D68.8min speed=3D64463K/sec

Seems like your init scripts re-added sda4.

> 65-70KB/s is about what these drives can do so the rebuild speed is just =
peachy.

If the rebuild completes successfully, you're ok again.  There's
nothing you have to do.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--19uQFt6ulqmgNgg1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHD5crWto1QDEAkw8RAv7MAKCSD3t2e4aswok8N3xFChJJMOx75gCeMSzX
Qe8GGMBOMKFv60sn28OZS/E=
=LFXm
-----END PGP SIGNATURE-----

--19uQFt6ulqmgNgg1--
