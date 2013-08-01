From: NeilBrown <neilb@suse.de>
Subject: Re: Bugreport: mdmon will not start with latest git version when
 using ddf container
Date: Thu, 1 Aug 2013 16:50:52 +1000
Message-ID: <20130801165052.3285cacc@notabene.brown>
References: <51F953FA.5000400@gmail.com>
	<20130801104433.1e7b41a5@notabene.brown>
	<CAGkViCGM5-ztFSh3d-yh=P0HNfvcPYr6p7g3rDfkmx2+8YaqEw@mail.gmail.com>
	<20130801152818.27cf61a5@notabene.brown>
	<CAGkViCGbxJofuBbU41QvfQbBdaAEQKe3BhrSXmKZv17rGC4jzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/89tlFud6zM0wUJsGE2UsG4T"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGkViCGbxJofuBbU41QvfQbBdaAEQKe3BhrSXmKZv17rGC4jzQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/89tlFud6zM0wUJsGE2UsG4T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Aug 2013 08:15:36 +0200 Albert Pauw <albert.pauw@gmail.com> wrote:

> Hi Neil,
>=20
> used /var/run/mdadm, and yes it is working now.
>=20
> Thanks,
>=20
> Albert
>=20
> P.S. Should this variable not set default to something like /var/run/mdadm
> or /dev?
>=20

I believe that most distros are moving towards /run so I think that is the
best default.
I guess I could get the Makefile to check that the chosen directory exists.=
..

NeilBrown

--Sig_/89tlFud6zM0wUJsGE2UsG4T
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfoFTTnsnt1WYoG5AQLfyxAAm/6zBH1x5lSvsRD2ekIzxE6llezHi66h
+BengiJpuKo/Qw93YgiaGrlPdri/5NladsGdHyAnP6poKouBvXOi50Oy+X6CoJmW
MpS/SU1J3Iss/94RUDNpmYKeR8B2VKXGI66ZyMFL8IiHImyutzXbBmQiX16DbkAv
+SCL3OcujBl4Kr60YTIH06w0W9eXEggNlaiXRfbodp0iVedDq1Kt4QYoIoJZl2jq
l+e2AxXXWZbjnu81wHvF01vDB3ICkJ59J7VwToLDA+GzhmUk5RR7W2N1biUr4k/B
JTl4xf48WnAHUo8JT7xcLbyiolitnAcp/bgR4tau3mvT50KibWP+HOmKYQIwWP9w
SKYwXmfvXUR4YV5eMqnN/fybTDFY96rgJbDFA6PS0lxYY1W9XFiuWNEYAvxpg3F7
7WrTtp9cmKhcZ+sV5106jgznkcPtPTk6FFZ0N61N+kXP+X1f2Vi69wAH4VBNOGtY
Rm/gMUQn/NkDWYg4S0qmJUMaO30/8QPJl3ir+xaTw6zT+mAj1REJl13b2SUa4AiI
eCWoPn58MncOKOIY/ckTZ2Vkw9LuGNOK+Pb9pbscBo0KR2devRTIBG6IRXWQJDLa
p8dPI3mBlQogKcyjwV9RXEW6ugXKano3nLWDe4SVNa2jVbhyq6V8tCVI5Lc0jK6s
Cg73LCZOcR8=
=fYXy
-----END PGP SIGNATURE-----

--Sig_/89tlFud6zM0wUJsGE2UsG4T--
