From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 08:51:12 +0600
Message-ID: <20100611085112.5f33b06f@natsu>
References: <4C1128C2.4020105@meetinghouse.net>
	<20100611005743.43664e5b@natsu>
	<4C11578B.8010202@meetinghouse.net>
	<20100611034108.6a2cdbc4@natsu>
	<4C1169CB.1030903@meetinghouse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/79edi9wJjQea/6G4RIXO_xj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C1169CB.1030903@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/79edi9wJjQea/6G4RIXO_xj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Jun 2010 18:40:11 -0400
Miles Fidelman <mfidelman@meetinghouse.net> wrote:

> Yes... went with internal.
>=20
> I'll keep an eye on write performance.  Do you happen to know, off hand,=
=20
> a magic incantation to change the bitmap-chunk size? (Do I need to=20
> remove the bitmap I just set up and reinstall one with the larger chunk=20
> size?)

Remove (--bitmap=3Dnone) then add again with new --bitmap-chunk.

--=20
With respect,
Roman

--Sig_/79edi9wJjQea/6G4RIXO_xj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwRpKEACgkQTLKSvz+PZwhuQQCeKKZK+OUD06+0kRVFackHS/C7
o4AAoJWj3LgR7OWRS6sAhJhs/x0qdVqo
=C/Kh
-----END PGP SIGNATURE-----

--Sig_/79edi9wJjQea/6G4RIXO_xj--
