From: NeilBrown <neilb@suse.de>
Subject: Re: On URE and RAID rebuild - again!
Date: Sun, 3 Aug 2014 13:48:34 +1000
Message-ID: <20140803134834.7773b0ab@notabene.brown>
References: <53D8ACF0.1070202@assyoma.it>
	<alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>
	<53D8ED99.90606@assyoma.it>
	<20140731073121.38cd1773@notabene.brown>
	<53D9ED48.9000307@assyoma.it>
	<1370eb7a35b628323646a86094a26912@assyoma.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/inOeWZBF0SvK.56/ynMJ5be"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1370eb7a35b628323646a86094a26912@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/inOeWZBF0SvK.56/ynMJ5be
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 02 Aug 2014 18:21:07 +0200 Gionatan Danti <g.danti@assyoma.it> wrot=
e:

> Hi again,
> I started a little experiment regarding BER/UREs and I wish to have an=20
> informed feedback.
>=20
> As I had a spare 500 GB Seagate Barracuda 7200.12 (BER 10^14 max:=20
> http://www.seagate.com/staticfiles/support/disc/manuals/desktop/Barracuda=
%207200.12/100529369e.pdf),=20
> I started to read it continuously with the following shell command: dd=20
> if=3D/dev/sdb of=3D/dev/null bs=3D8M iflag=3Ddirect
>=20
> The drive was used as a member of a RAID10 set on one of my test=20
> machines, so I assume its platters are full of pseudo-random data. At=20
> 100 MB/s, I am now at about 15 TB read from it and I don't see any=20
> problem reported by the kernel.
>=20
> Some questions:
> 1) I should try in different / harder mode to generate UREs? Maybe using=
=20
> some pre-determined pseudo-random string and then comparing the results=20
> (I think this is more appropriate to catch silent data corruption, by=20
> the way)?

You are very unlikely to see UREs just be reading the drive over and over a
again.  You easily do that for years and not get an error.  Or maybe you got
one just then.


> 2) how UREs should be visible? Via error reporting through dmesg?

If you want to see how the system responds when it hits a URE, you can use =
the
hdparm command and the "--make-bad-sector" option.  There is also a
"--repair-sector" option which will (hopefully) repair the sector when you
are done.

NeilBrown


>=20
> Thanks.
>=20
> Il 2014-07-31 09:16 Gionatan Danti ha scritto:
> >> Yes, you can usually get your data back with mdadm.
> >>=20
> >> With latest code, a URE during recovery will cause a bad-block to be=20
> >> recorded
> >> on the recovered device, and recovery will continue.  You end up with=
=20
> >> a
> >> working array that has a few unreadable blocks on it.
> >>=20
> >> NeilBrown
> >=20
> > This is very good news :)
> > I case of parity RAID I assume the entire stripe is marked as bad, but
> > with mirror (eg: RAID10) only a single block (often 512B) is marked
> > bad on the recovered device, right?
> >=20
> > From what mdadm/kernel version the new behavior is implemented? Maybe
> > the software RAID on my CentOS 6.5 is stronger then expected ;)
> >=20
> > Regards.
>=20


--Sig_/inOeWZBF0SvK.56/ynMJ5be
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU92xEjnsnt1WYoG5AQKNjA//bNcqPuJoT+ZIf0fapnpl2x3wnAU2RK/a
79xtSoJy+z5mCj3FzAq3B0wtaFdeC0PYh5h7NaIN0DXti4LX693GLWYcuaNFON2I
VNcY6VIgilKSkWWMrdABiSCirhf8aXl4Hj1/cjuY/m8roKuWoEVk3P5CCQeamPgG
tcNjljMD4s4nZOwur7CJo4OxwUU7xefV1a/M/W6knw7TuUHV9yhCC7J1j0AiuYDQ
juwZ3ncM+UWV4GTmgmTkAzMB1Blv8X1kfrWwXwuBc9+2WhQbYN6Hpqjwp473mdiz
l7Bu9eCsvSWcEXhothxpOSkV/8urBCHjxrSie1vT3BKp4p4MRenvcb7VcPR4iUe9
9/oE+g4ifbBY3Ez8z/zwgNeILGBb0Mnu3v2JieM2dOEsymGVyjwu+sxarwQzC5RU
eiZ7PS38/y0L3/igp+E9QwPRwiWJPXQgqc3PBB2/Y8vG6RBkRLhY1SNhnc7DWvc8
67AM4B4CloTKx98BgaAePU2iZoHcM7wQ3Fu82xmIfV+zTD4Y4z6OIIkphV6vNd+g
TeSI+/mZG96EyLvFz5pU8277d1mcpzrxKBmvNWddP+x2+Kl71hrvJ5fUAlD9wpjj
gy8SEFslXwRcPGBUJiPNF6J5qiU6H0ufQXnGDWqdwYzL1ZxHlg6cvjeYzwzEH0oV
sa6h5J3mvec=
=HZdc
-----END PGP SIGNATURE-----

--Sig_/inOeWZBF0SvK.56/ynMJ5be--
