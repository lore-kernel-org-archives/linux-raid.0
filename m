From: Andre Noll <maan@systemlinux.org>
Subject: Re: question about mdadm
Date: Sat, 26 Jan 2008 18:10:25 +0100
Message-ID: <20080126171025.GG29126@skl-net.de>
References: <4cfdde050801252038o3cd7ffddkd425dac6cf82099d@mail.gmail.com> <4cfdde050801252046j57617db3s1619a6f4d3d9e8f0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L1c6L/cjZjI9d0Eq"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4cfdde050801252046j57617db3s1619a6f4d3d9e8f0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Hourigan <ehourigan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--L1c6L/cjZjI9d0Eq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23:46, Edward Hourigan wrote:

> mdadm --add /dev/md0 /dev/sdd
> mdadm --add /dev/md0 /dev/sde
> mdadm --grow --raid-devices=3D5
>=20
> I forgot about the partitions, sdd1 and sde1, I'm wondering if this is
> going to be a problem, or if sdd and sde will work?
> It is currently reshaping the array.  Please advise if possible.
> A response would be much appreciated!

mdadm and the linux raid code don't care whether a component device
of a raid array is a full disk or a partition of a disk. So your
setup won't cause any problems.

However, tools like fdisk which expect a partition table might get
confused. You also might get some error messages at boot time about
invalid partition tables. These are usually harmless though.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--L1c6L/cjZjI9d0Eq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHm2mBWto1QDEAkw8RArIWAJ9ZvYS/+ywd3YANY2askTgluRiV0QCggZCb
ObXcc4+5VllBpPD3bMf0RlY=
=2DAq
-----END PGP SIGNATURE-----

--L1c6L/cjZjI9d0Eq--
