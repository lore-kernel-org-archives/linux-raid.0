From: Andre Noll <maan@systemlinux.org>
Subject: Re: md devices disappearing on system reboot
Date: Mon, 7 Jul 2008 11:30:04 +0200
Message-ID: <20080707093004.GQ23944@skl-net.de>
References: <8CAA9B1F81B8E21-614-D2D@webmail-nc09.sysops.aol.com> <20080702162108.GF4981@skl-net.de> <8CAAD37CC87F1BD-FD8-4A21@webmail-stg-d08.sysops.aol.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UK1lfQXsnwKrySH9"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8CAAD37CC87F1BD-FD8-4A21@webmail-stg-d08.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--UK1lfQXsnwKrySH9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 00:27, thomas62186218@aol.com wrote:

> Thank you for responding. I created md0 with 4 hard drives, RAID 0.=20
> Here is the /etc/mdadm.conf
> DEVICE  /dev/sd*
> ARRAY /dev/md0 level=3Draid0 num-devices=3D4=20
> UUID=3Dd58a686f:20aa9ffe:e0d5f27e:e17216ec
>=20
> Here is the output of mdadm -E -scan
> ARRAY /dev/md0 level=3Draid0 num-devices=3D4=20
> UUID=3Dd58a686f:20aa9ffe:e0d5f27e:e17216ec

Looks good.

> However, cat /proc/mdstat shows nothing:
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> unused devices: <none>

What happens if you try to assemble the array by executing

	mdadm -A /dev/md0

?

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--UK1lfQXsnwKrySH9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIceIbWto1QDEAkw8RAhp8AKCCjrBmUu7VChawcCQB6LBxKyMSTwCfdFmK
pPJEVFVbJfPleP5Px3CmWCU=
=8X9x
-----END PGP SIGNATURE-----

--UK1lfQXsnwKrySH9--
