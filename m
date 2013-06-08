From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: SSD + Rust as raid1
Date: Sat, 8 Jun 2013 16:22:35 +0600
Message-ID: <20130608162235.7ca32f4d@natsu>
References: <51A7C36F.4030605@timedicer.co.uk>
	<20130531133018.77cd9285@natsu>
	<51A85574.8080709@timedicer.co.uk>
	<20130531135434.5b6bdddb@natsu>
	<51A864E1.9070903@timedicer.co.uk>
	<51ADA1AF.6040405@timedicer.co.uk>
	<51B25D7C.4090403@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2Gvy+H.4MZ7GEDeqk+_xZNP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B25D7C.4090403@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Dominic Raferd <dominic@timedicer.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2Gvy+H.4MZ7GEDeqk+_xZNP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 07 Jun 2013 18:23:56 -0400
Bill Davidsen <davidsen@tmr.com> wrote:

> > If I have to have a bitmap file, it is=20
> > presumably faster to have a larger chunk size
>=20
> If you want performance I think a too big chunk size will hurt you.

You are confusing the general array chunk sizes, and the bitmap chunk size.=
 In
the latter, a larger size will universally give better performance (up to s=
ome
value, where it will perhaps start to flat out).

--=20
With respect,
Roman

--Sig_/2Gvy+H.4MZ7GEDeqk+_xZNP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGzBesACgkQTLKSvz+PZwjThQCeNf1evF1yNaro6L0imFS++iUh
Ur0AoI1bJlxEk+sN2+nTLNa7Wl04igxv
=5cJt
-----END PGP SIGNATURE-----

--Sig_/2Gvy+H.4MZ7GEDeqk+_xZNP--
