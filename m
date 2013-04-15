From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: MD does not wait for drives on start-up with kernels 3.8+
Date: Mon, 15 Apr 2013 19:11:57 +0600
Message-ID: <20130415191157.72b630c3@natsu>
References: <20130330190538.4e3c1771@natsu>
	<CAGqmV7qmPHYpm1rinfsh5W-mgqo+Va2RvQtZoy-5AazYFAHYdg@mail.gmail.com>
	<20130415144530.183d7b31@natsu>
	<20130415203449.4d121b32@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/I/kPHFb8Pj.jwuA21+yvqyS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130415203449.4d121b32@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: CoolCold <coolthecold@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/I/kPHFb8Pj.jwuA21+yvqyS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Apr 2013 20:34:49 +1000
NeilBrown <neilb@suse.de> wrote:

> > This was NOT required on any of the previous kernels, so I wonder why a=
ll of
> > sudden with the 3.8+ kernels my system needs an extra "crutch" just to =
keep
> > starting up properly.
>=20
> This is almost certainly not directly related to the kernel.  It seems cl=
ear
> that some change in the kernel has resulted in the difference, but it is
> probably indirect and really a bug elsewhere.
>=20
> What distro are you using?  Is systemd in use?

Debian Testing, no systemd.

--=20
With respect,
Roman

--Sig_/I/kPHFb8Pj.jwuA21+yvqyS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFr/J0ACgkQTLKSvz+PZwjiDwCglsWxrs6UIaOF6CXqefQZGnzT
uFwAoIB2qZW7LOY69buSpsBWIbwYwEyi
=G0ro
-----END PGP SIGNATURE-----

--Sig_/I/kPHFb8Pj.jwuA21+yvqyS--
