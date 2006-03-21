From: Andre Noll <maan@systemlinux.org>
Subject: Re: raid1+raid0 mdadm
Date: Tue, 21 Mar 2006 19:00:50 +0100
Message-ID: <20060321180050.GC27173@skl-net.de>
References: <44203782.2000505@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FJ0JV+AOCbvjFtNn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44203782.2000505@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dariusz Malec <dariusz.malec@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--FJ0JV+AOCbvjFtNn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18:27, Dariusz Malec wrote:

> I can't configure mdadm. I have created 2 raid1 devices and i wanted to=
=20
> connect  them with raid0. Everything is fine when i use command line,=20
> but after reboot mdadm starts only raid1 devices.

Are you using udev?

IIRC, there was an issue with stacked md devices like yours. Your
problem might be that the device node for the final raid0 is missing.

If your raid1's are md0 and md1, add

	mknod -m 600 /dev/md2 b 9 2

to your init scripts, just before calling mdadm.

Of course, that's only an ugly workaround (that once worked for me).

Andre=20
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--FJ0JV+AOCbvjFtNn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFEID9SWto1QDEAkw8RAgiFAJkBXJUGnURsLWFW3Lz8cSzAUXOlnQCgimxr
14k80tQdPqr7DyMrOhM8Coo=
=kFu5
-----END PGP SIGNATURE-----

--FJ0JV+AOCbvjFtNn--
