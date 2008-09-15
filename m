From: Andre Noll <maan@systemlinux.org>
Subject: Re: Raid6 array crashed-- 4-disk failure...(?)
Date: Mon, 15 Sep 2008 14:59:51 +0200
Message-ID: <20080915125951.GA17966@skl-net.de>
References: <48CE250C.8000603@ultratux.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48CE250C.8000603@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Maarten <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:04, Maarten wrote:
>=20
> This weekend I promoted my new 6-disk raid6 array to production use and=
=20
> was busy copying data to it overnight. The next morning the machine had=
=20
> crashed, and the array is down with an (apparent?) 4-disk failure, as=20
> witnessed by this info:

Believe it or not: The same thing (6-disk raid6, 4 disks failed)
happened also to me during this weekend.

> 4) If it was only a one-drive failure, why did it kill the array ?

As others have already pointed out, this was not a one-drive
failure. In my case, the two SATA disks which are still functional
are connected to a 3ware controller while the four failed disks use
the onboard SATA controller [1]. Therefore I'm confident that this
is just a problem with the onboard SATA chip and that the array can
be assembled again after a reboot. I'll have to wait until the end
of the week to reboot that machine though.

Are you also using an Intel-based SATA chip (please send the output
of lspci -v)?  Also, which kernel version are you using?

> 5) Any insight as to how this happened / can be prevented in future ?

Don't use cheap hardware (Fast, cheap, good. Pick two) ;)

Andre

[1] 00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA
Storage Controller AHCI (rev 09)
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIzlxHWto1QDEAkw8RAin/AKCZ6BtL823kFB+eMXWSRtGwxpfiCgCcDEpE
h9Y7f0O+R8By1bQR/YEGXWk=
=HzUs
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
