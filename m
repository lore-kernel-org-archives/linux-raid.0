From: Jose Manuel dos Santos Calhariz <jose.calhariz@netvisao.pt>
Subject: Re: md raid6 deadlock on write
Date: Fri, 6 Jul 2012 14:55:24 +0100
Message-ID: <20120706135524.GI15287@calhariz.com>
References: <20120629194600.GA23859@calhariz.com>
 <20120702221508.GA24801@calhariz.com>
 <20120704113811.180be107@notabene.brown>
 <20120704102411.GG15287@calhariz.com>
Reply-To: jose.spam@netvisao.pt
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="um2V5WpqCyd73IVb"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120704102411.GG15287@calhariz.com>
Sender: linux-raid-owner@vger.kernel.org
To: jose.spam@netvisao.pt
Cc: NeilBrown <neilb@suse.de>, jose.calhariz@netvisao.pt, linux-raid@vger.kernel.org, ns-list@dsi.ist.utl.pt
List-Id: linux-raid.ids


--um2V5WpqCyd73IVb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 04, 2012 at 11:24:11AM +0100, Jose Manuel dos Santos Calhariz w=
rote:
> On Wed, Jul 04, 2012 at 11:38:11AM +1000, NeilBrown wrote:
> > On Mon, 2 Jul 2012 23:15:08 +0100 Jose Manuel dos Santos Calhariz
> > <jose.calhariz@netvisao.pt> wrote:
> >=20
> > >=20
> > > We have a group of servers with a LVM over a RAID6 of 16 drives.
> > > During normal work loads, sometimes, the md raid enter on deadlock for
> > > writes and only a power off/power on allows to recover the machine.
> >=20
> > This might be fixed by the following commit which was recently included=
 in
> > 3.5-rc. If could test with that I'd appreciate it.
>=20
> We will do it, at first opportunity.

We have two machines that are running fio for 24 hours without
problems.  So the bug seams to be fixed, thank you.

Any possibility of the fix being ported to kernel 3.2?

>=20
> >=20
> > >=20
> > >   - there is information from "SysRq : Show State", not attached
> > >     because is too big,
> >=20
> > How big is too big?  It is very hard to see if there is anything useful=
 in
> > there if I cannot see it....
>=20
> Big enough to be blocked by the mailing list ;-)
>=20
> I am attaching now, so you can see it.
>=20
> >=20
> > NeilBrown
> >=20
>=20
>=20
>         Jose Calhariz
>=20

      Jose Calhariz





--=20
--
"Existem 3 poderes soberanos:
Deus no c=E9u, o Papa no Vaticano e Dad=E1 Maravilha na grande =E1rea."
--Dad=E1 Maravilha

--um2V5WpqCyd73IVb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJP9u5LAAoJEDSKd41ohe+PxkcP/11cOkDXaWNjxfJ8i6TY1Pkf
SLFgC/F55MNrnkaAzyO/4iKdfjHNiRdrP4mtlCsdL3oD9OGvCl1U4gpbpXMld0KR
mH+UzcZiYuYdtifrD4X/QYa4Cwi9nqPns9sji3OA0hSXHTJ7+z2wb0A31y46hu6x
ZLm5zPJx1wxSeZvu8CJzBucmuTM2BqZuLmCXOU4QG1+NcPKKvbk5IfO2Rnypy5gS
itnkzc5WJQZnLeDDIsExEpbBOOEryVwyWdb9WoxMygiVUZ6h0a1hw+fMrzBczSLt
VOpmmZ7VPgKmG9Blib3DeANfyywTo4qgkAklhuPRZRZE1HI+1AE372nO/t3saSiD
gZVAmJhMIniRuA+hVNYY4hnWmlC9pFvLsFfcaG1BEHTqSFVnU8QCmHT/cI9opGiD
YtS+2LEAegt36SZCfJ1dVMZXUDkU6HerjOmKxhfXzPD8x/ZhdcEzxqv/+oGurQrS
3a4JPB4aFDE632KoKwBeSWIYD3RqhK/0aOuUUPO/dWni71z7iJcVKV1mzuLXGLgi
r+bnNAIUY3b5i2FIPDShgV08/iW4hAaf3z9HJ8UD2pDE9sLS1/QW+gIDoXdZVnh6
u2UqXkxv4CLcRcrbtiSY0VtZ/3pSVHDm62lDk0GH1ST8Eb5krXIE3VSv3yqMaAi/
dOv4yTjN1PVdlcqss1c2
=KgEN
-----END PGP SIGNATURE-----

--um2V5WpqCyd73IVb--
