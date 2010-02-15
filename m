From: martin f krafft <madduck@madduck.net>
Subject: Re: Linux mdadm superblock question.
Date: Mon, 15 Feb 2010 22:08:32 +1300
Message-ID: <20100215090832.GA24362@lapse.rw.madduck.net>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
 <20100214193406.GA15722@khazad-dum.debian.net>
 <4B786154.8090103@shiftmail.org>
 <20100214212811.GB15313@twister.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100214212811.GB15313@twister.home>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Asdo <asdo@shiftmail.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Michael Evans <mjevans1983@gmail.com>, Volker Armin Hemmann <volkerarmin@googlemail.com>
List-Id: linux-raid.ids


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Gabor Gombas <gombasg@digikabel.hu> [2010.02.15.1028 +1300]:
> There is no autodetection with 1.1. Once you have mdadm.conf you have
> pretty hard rules about what to look for and how to assemble it - ie.
> there is not much left to "auto" detect. Real autodetection would mean
> there is _no_ such information available, and you figure out everything
> by just looking at the devices you find.

Which, coincidentally, is where we're heading with incremental
assembly. Check the Debian experimental package if you want to try.

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"we should have a volleyballocracy.
 we elect a six-pack of presidents.
 each one serves until they screw up,
 at which point they rotate."
                                                      -- dennis miller
=20
spamtraps: madduck.bogus@madduck.net

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkt5DxAACgkQIgvIgzMMSnX7SACguK02yNNYVQxEtzD2fFtSvV/s
6ycAoNmLN2SnLIk6r8hRhkbd+YiX65gh
=J9H+
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
