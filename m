From: Jose Manuel dos Santos Calhariz <jose.calhariz@netvisao.pt>
Subject: Re: md raid6 deadlock on write
Date: Mon, 9 Jul 2012 12:22:18 +0100
Message-ID: <20120709112218.GA18431@calhariz.com>
References: <20120629194600.GA23859@calhariz.com>
 <20120702221508.GA24801@calhariz.com>
 <20120704113811.180be107@notabene.brown>
 <20120704102411.GG15287@calhariz.com>
 <20120706135524.GI15287@calhariz.com>
 <20120709134653.332102fd@notabene.brown>
Reply-To: jose.spam@netvisao.pt
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120709134653.332102fd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: jose.spam@netvisao.pt, jose.calhariz@netvisao.pt, linux-raid@vger.kernel.org, ns-list@dsi.ist.utl.pt
List-Id: linux-raid.ids


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 09, 2012 at 01:46:53PM +1000, NeilBrown wrote:
> On Fri, 6 Jul 2012 14:55:24 +0100 Jose Manuel dos Santos Calhariz
> <jose.calhariz@netvisao.pt> wrote:
>=20
> > On Wed, Jul 04, 2012 at 11:24:11AM +0100, Jose Manuel dos Santos Calhar=
iz wrote:
> > > On Wed, Jul 04, 2012 at 11:38:11AM +1000, NeilBrown wrote:
> > > > On Mon, 2 Jul 2012 23:15:08 +0100 Jose Manuel dos Santos Calhariz
> > > > <jose.calhariz@netvisao.pt> wrote:
> > > >=20
> > > > >=20
> > > > > We have a group of servers with a LVM over a RAID6 of 16 drives.
> > > > > During normal work loads, sometimes, the md raid enter on deadloc=
k for
> > > > > writes and only a power off/power on allows to recover the machin=
e.
> > > >=20
> > > > This might be fixed by the following commit which was recently incl=
uded in
> > > > 3.5-rc. If could test with that I'd appreciate it.
> > >=20
> > > We will do it, at first opportunity.
> >=20
> > We have two machines that are running fio for 24 hours without
> > problems.  So the bug seams to be fixed, thank you.
>=20
> Thanks for testing and reported.
>=20
>=20
> >=20
> > Any possibility of the fix being ported to kernel 3.2?
>=20
> It seems that I didn't tag that patch for -stable so it won't automatical=
ly
> get included.  I'll send it the old way - maybe it'll get into
> 3.2.23.

That would be great.=20

>=20
> Thanks,
> NeilBrown
>=20

     Jose Calhariz

--=20
--
Pregui=E7a =E9 o habito de descansar antes da fadiga.

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJP+r7pAAoJEDSKd41ohe+PbA4P/3xyZi+iPjpJPpq3f3tPXTXz
+SVhkp9ZN4qlBuiXTZRriwAtj1KL9BHtfLn9RHsHCWlbFggcQAC3/sR0bDcVhCfk
/Z24Jkx9wuZIfleQV8KTcgjRmHbOe0zIX2nw4M9y+3N/+Pl9Jr0MvWSJZzC4XIS8
7tSf4vCrKQAOPTSldSqxyYUoIQplPZMWXtDS1CwNAs2yvf1B9QZxzaBS82byvCqB
Qb/LtgsxpWgfx24JURZn4FKEpKku+Lin0iIOA+8YbP8mizNszcJJ1yF4aMICh08n
rd+cbZJ4ytJ9Tew2BKHmhQS+wG3w8vdjPwn4QAyS5Msejd3GkbFqA6O9fgRBeSiF
GMzmToggchbocY/mjn55GHi8NsXJTRzZ0z8e4chFFYEhkOjjN8esDKExfwclFW9Q
tR0P5gpr78ulzplauuHePNxZ6qNjG/7nnLMv4CC3em/JYE1km7Pf1D/p18oxAQgv
J5IADMMnQaPYqTMWupzShHPgFf0a2C0QmLDnzEeypjOkcdL04envb44RFbNbcfrF
995QKAr9TYWxDwac51EzR+ops9jzAIKvds8BdY6zlARLZ+CdairX/ASyTr6QRmXU
9lvR34fjvEmP2lutg5054dVA+fuO9BnPWuDkgTl7rzkecnL6wEQxXppNMTY791uj
53681Gd00KttxxCptFp1
=YPp7
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
