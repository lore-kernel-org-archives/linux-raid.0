From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm named array (metadata 1.2) and udev when assembling an
 array in initramfs
Date: Mon, 3 Nov 2014 16:43:25 +1100
Message-ID: <20141103164325.221a0c3b@notabene.brown>
References: <20141103125020.19308fd5@notabene.brown>
	<CAC45b7=H2kFg2VdFq2xdaQ=z4MebV3QC-aA1X5TO0ra=749puA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/03jiBBRiD/vd5go2awo/_vr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC45b7=H2kFg2VdFq2xdaQ=z4MebV3QC-aA1X5TO0ra=749puA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stephen Kent <smkent@smkent.net>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/03jiBBRiD/vd5go2awo/_vr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 2 Nov 2014 20:16:34 -0800 Stephen Kent <smkent@smkent.net> wrote:

> On Sun, Nov 2, 2014 at 5:50 PM, NeilBrown <neilb@suse.de> wrote:
> >
> > Hi Stephen,
> >  thanks for the bug report.
> > This patch should fix it.
> >
> > NeilBrown
> >
> > From 628cdf19ea35daad22e409e51c0abc7ffb19d6aa Mon Sep 17 00:00:00 2001
> > From: NeilBrown <neilb@suse.de>
> > Date: Mon, 3 Nov 2014 12:49:05 +1100
> > Subject: [PATCH] Rebuildmap: strip local host name from device name.
> >
> > When /run/mdadm/map is being rebuilt, e.g. by "mdadm -Ir",
> > if the device doesn't exist in /dev, we have to choose
> > a name.
> > Currently we don't strip the hostname which is wrong if
> > it is the local host.
> >
> > Reported-by: Stephen Kent <smkent@smkent.net>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >
> > diff --git a/mapfile.c b/mapfile.c
> > index 4e7f24214b8a..41599df05f97 100644
> > --- a/mapfile.c
> > +++ b/mapfile.c
> > @@ -455,12 +455,19 @@ void RebuildMap(void)
> >                                                         sep =3D "";
> >                                                 }
> >                                         }
> > -                                       if (strchr(name, ':'))
> > -                                               /* probably a uniquifyi=
ng
> > +                                       if (strchr(name, ':')) {
> > +                                               /* Probably a uniquifyi=
ng
> >                                                  * hostname prefix.  Al=
low
> > -                                                * without a suffix
> > +                                                * without a suffix, an=
d strip
> > +                                                * hostname if it is us.
> >                                                  */
> > +                                               if (homehost && unum =
=3D=3D -1 &&
> > +                                                   strncmp(name, homeh=
ost,
> > +                                                           strlen(home=
host)) =3D=3D 0 &&
> > +                                                   name[strlen(homehos=
t)] =3D=3D ':')
> > +                                                       name +=3D strle=
n(homehost)+1;
> >                                                 unum =3D -1;
> > +                                       }
> >
> >                                         while (conflict) {
> >                                                 if (unum >=3D 0)
>=20
>=20
> Your patch works for me! Thanks so much for taking a look.
>=20


Great - thanks for the confirmation.  It will be in the next release.

NeilBrown

--Sig_/03jiBBRiD/vd5go2awo/_vr
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFcV/Tnsnt1WYoG5AQItYRAAuw40qEceDem/dJpeEz6yoki6/OucY3ya
oMwxq/hMfVfwXKQFxA+mEtCB6AozG2+WdBg2hlOZtPNAB7ur6kD9qK9uoC5kN142
qIeaMJ9PXQgwm/bs8Zr5TngwI5lKwRxBS1iatN55CXaETTLPXF7CUutKfw7ltRKh
Xfkh0xKqGRWf5hKzU24+KqEjo52PeMmCmdp7jIaHfzyyd/KDCp5Tj9UfA5eNqHi3
B3Dg5Aw6tzCnYPHJOqkVWfN8bvOX5xrmz84IAPiXu9vSaB3aH/RRQBgE99eKhfXZ
mkJdIeTUWkUDe5Sb6dE3vOpY03nVoRJ48fEWzn9qL0n3jVMbG0JnmNPuZ0JrUNbK
CQUbXjh6jpvAxr8k4wGi5w6k0pRrJwljW5CZNlNL22I7QMnNsHkU0ySk/aYvqwUw
nvctn8hIWrsnByEcwHyMqZ8FRMXp08BLXSAW9D9XbreWGwJBiuPdUe4zgctW5brQ
XPCFC20CAJSAMJBdtCGDSM0gyGJ2FQ2+Kp1D3qMQ2898uaLztcXKx7mGl6Sr6HfB
71jHnq66SmXDP6o0yYAzx19nG/YHxTxsb39GbEpJEqkPFnxXINAxMvrB2FCzsMNu
k2oL0ehVTgaORcN++8/qmls553iyibiwr236LAr4cjdc1ZC2+Zb8jG04IOCnvnw5
f6DMHvwFEs4=
=wNsd
-----END PGP SIGNATURE-----

--Sig_/03jiBBRiD/vd5go2awo/_vr--
