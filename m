From: Andre Noll <maan@systemlinux.org>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Wed, 1 Apr 2009 19:47:29 +0200
Message-ID: <20090401174729.GW17185@skl-net.de>
References: <87ljr4hsk9.fsf@frosties.localdomain> <20090318121825.GL32416@skl-net.de> <49D39169.2050705@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gsAOdWNCzgDntp8s"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49D39169.2050705@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--gsAOdWNCzgDntp8s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09:08, H. Peter Anvin wrote:
> Andre Noll wrote:
> >=20
> >> So back to my original question: Why does the kernel require 4 disks
> >> for a raid6 instead of allowing 3?
> >=20
> > Dunno. Maybe Dan, Neil or HPA can tell the reason for imposing this
> > limitation.
> >=20
>=20
> It's very simple: it avoids an ugly corner case in the RAID-6
> computation code.  Rather than inserting special code (and verifying it,
> etc.) to deal with the 3-disk RAID-6 degenerate case, it was easier to
> just not permit it.

Out of curiosity, why is any special-casing needed for the 3-disk case?

As

	P =3D D_0 + ... + D_{n-1}

coincides with

	Q =3D g^0D_0 + ... + g^{n-1}D_{n-1}

in the case n=3D1 (because only the first addend is present), we have

	D_0 =3D P =3D Q

i.e. raid6 with three disks is the same as raid1. If we lose D_0 and P,
the general formula for reconstruction, i.e.

	D_x =3D g^{-x}(Q + Q_x)

still works for n=3D1: It reduces to D_0 =3D Q since x=3D0 and Q_0 =3D 0.
So I don't see why special-casing the n=3D1 case is necessary.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--gsAOdWNCzgDntp8s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJ06ixWto1QDEAkw8RAoScAJ4vwnflNaUdt2wCtYzBhFLlCBTt5ACggNjX
XXMWp02B/DVEgn7mh/8os1s=
=zCon
-----END PGP SIGNATURE-----

--gsAOdWNCzgDntp8s--
