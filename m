From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH] MD: md, fix lock imbalance
Date: Mon, 22 Jun 2009 14:25:07 +0200
Message-ID: <20090622122507.GC11504@skl-net.de>
References: <1245621576-27066-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Efge0/SQAHHP+Pr2"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1245621576-27066-1-git-send-email-jirislaby@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


--Efge0/SQAHHP+Pr2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23:59, Jiri Slaby wrote:
> Add unlock and put to one of fail paths in md_alloc.
>=20
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Jup, this patch fixes a leak and a locking bug which hits if a named
array is being added and its name duplicates the name of an already
existing array.

Signed-off-by: Andre Noll <maan@systemlinux.org>
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Efge0/SQAHHP+Pr2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKP3gjWto1QDEAkw8RApoLAJ43SghGXTa8tmdbNLWlfVeV/wxNVQCfa0Nl
ZzLDGnhYUKkbFfdhk7vHgwc=
=DNIf
-----END PGP SIGNATURE-----

--Efge0/SQAHHP+Pr2--
