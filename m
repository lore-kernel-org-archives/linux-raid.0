From: Andre Noll <maan@systemlinux.org>
Subject: Re: raid-1, oops -- partition type 83
Date: Mon, 26 Jan 2009 17:10:32 +0100
Message-ID: <20090126161032.GD32416@skl-net.de>
References: <6d344ffd0901260637l1d705629l9e23db431a33a9af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6d344ffd0901260637l1d705629l9e23db431a33a9af@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Troy Cauble <troycauble@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09:37, Troy Cauble wrote:
> I have a raid 1 with partition types 83 that I now realize should be 0xDA.
> Is it safe to change this with fdisk live, or should I play it safe and do
>    fail / remove / change-partition-type / add
> on each disk?

It should be safe to change this live.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJfeB4Wto1QDEAkw8RAj7tAJ9n5cbCstFmQDyXO3J/u2MA4vqlZQCfXyOb
go8UKWNzGWKZpse3je00LD8=
=ryO3
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
