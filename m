From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: mdadm freezes the system
Date: Wed, 16 Jun 2010 13:16:09 +0600
Message-ID: <20100616131609.477fcca8@natsu>
References: <20100608145913.187a69ca@natsu>
	<20100608222434.3f0fb637@natsu>
	<20100611004316.7d8ad74d@natsu>
	<AANLkTikdknJnRpHrMybjFTFDRHTH9ad4Rne_wyQ_-84s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ned/jN9XpfBrZMl_OR8GPD_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikdknJnRpHrMybjFTFDRHTH9ad4Rne_wyQ_-84s@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ned/jN9XpfBrZMl_OR8GPD_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Jun 2010 00:03:54 -0700
Michael Evans <mjevans1983@gmail.com> wrote:

> Have you exhaustively tested your drives as well?
>=20
> The smartctl -t long test is a good one to start with.

I run that the first thing after buying every new disk. The drives are okay,
even if they weren't, they should absolutely not cause the system lock-up in
the manner I was experiencing.

I believe what I have is either a controller bug, or this:
https://bugzilla.redhat.com/show_bug.cgi?id=3D602457

--=20
With respect,
Roman

--Sig_/ned/jN9XpfBrZMl_OR8GPD_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwYejkACgkQTLKSvz+PZwj8kQCfapHi9LEsHQpdCU8al+mglN1l
qqoAoIdGVqc1xI4ctIrHEHTXDulskrW5
=jDEt
-----END PGP SIGNATURE-----

--Sig_/ned/jN9XpfBrZMl_OR8GPD_--
