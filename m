From: NeilBrown <neilb@suse.de>
Subject: Re: question about raid10 near copy info in man mdadm.
Date: Mon, 16 Apr 2012 16:20:04 +1000
Message-ID: <20120416162004.0ec4939c@notabene.brown>
References: <201204161328097657740@gmail.com>
	<20120416154126.2fb059da@notabene.brown>
	<201204161346407034012@gmail.com>
	<201204161410242964436@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3wp.1kG7Van8OU7FXF868=r"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201204161410242964436@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/3wp.1kG7Van8OU7FXF868=r
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Apr 2012 14:10:28 +0800 "kedacomkernel" <kedacomkernel@gmail.com>
wrote:

> Why not use md's description instead of mdadm' content?
> I think this may be better,especially for people who's native language  i=
s not English.
>=20

Send me a patch which you think is an improvement.
If I agree, I'll apply it.

Thanks,
NeilBrown


> ------------------				=20
> kedacomkernel
> 2012-04-16
>=20
> -------------------------------------------------------------
> =B7=A2=BC=FE=C8=CB=A3=BANeilBrown
> =B7=A2=CB=CD=C8=D5=C6=DA=A3=BA2012-04-16 14:01:18
> =CA=D5=BC=FE=C8=CB=A3=BAkedacomkernel
> =B3=AD=CB=CD=A3=BAlinux-raid
> =D6=F7=CC=E2=A3=BARe: question about raid10 near copy info in man mdadm.
>=20
> On Mon, 16 Apr 2012 13:46:46 +0800 "kedacomkernel" <kedacomkernel@gmail.c=
om>
> wrote:
>=20
> > This is the man md about:
> > 		When 'near' replicas are chosen, the multiple copies of a given chunk=
 are laid out consecutively  across
> >        the  stripes  of  the  array,  so the two copies of a datablock =
will likely be at the same offset on two
> >        adjacent devices.
>=20
> "likely" is different from "certainly".  In most cases they are the same
> offset.  In some cases they are different offsets.  I think "likely"
> describes that well enough.
>=20
> >=20
> > I think the word "similar" is the same.=20
>=20
> "similar" is not the same as "same", though it is similar .....
>=20
> "same" means there is no difference.
> "similar" means there might be a difference, but it is not a big differen=
ce.
>=20
> Does that clear it up?
>=20
> NeilBrown
>=20
>=20


--Sig_/3wp.1kG7Van8OU7FXF868=r
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4u6FDnsnt1WYoG5AQKDDQ/+OugAJQvFZkVITfpkiqPft3dnWXmvj6Ru
JBnA4Pxj6PUq2tPT+x/rJ6b2BT65q/F/5evEV5Pg/tboNVY/7xP9ej/iykQw9cuV
X8Yj4IsXl1/QU5tui9kC8v/Cd8inBiF57UF+tI+8BSctSwXB+BHqhfijraoAg2xa
RSnWrrfY2I2RzP6bTcGI/LmShUfxkoF/xe7M3jfEQJC8jORAyF6tOf83qE0q9gtZ
Jilz8vjQzO5JIW8EnffwlOCc/5rVYGUuNW6L8bqAZMTokCfHUh1HQ+CNCq28U2ME
9beS+OQ5eoO1KKV64DCVksunxKWKldJKEMirn5lcFfpYlI6wkpBPBlUQHM26oE05
1v6bsZtADCGyzdXpR9XpUfExYwDS4C9lNzRedy9zKwKwc+Z18NS10iLq2oT0HWVZ
8lo8FkQr89o0tQfaIVuxEDZW9vCnwd9exMI9KHtqDYJJo9viYmPHQ+d7JDTrJ7gh
MNWUWqiT0xNH1P5AML2/gsBBo0Jt0N46Fw7qI2LnBCpsX+dDnfJpl7NO/T4VI1/z
VXtDfyf7JQ9yN3tMW/NZ/r3N8vTlfDJgf6efq1D13lrNNUZoQg/OPw2G+ll6Rz4g
+yx/iLSE3vQtSo34UH3KXUTWsg+zPxKXB5d84UC1vGbbWmJoawLTAS7qtu5ROd9P
SpzWNWMKfpU=
=61Bm
-----END PGP SIGNATURE-----

--Sig_/3wp.1kG7Van8OU7FXF868=r--
