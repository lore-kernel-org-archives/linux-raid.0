From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix: thunderdome may drop 2tb attribute
Date: Mon, 30 Apr 2012 09:58:13 +1000
Message-ID: <20120430095813.084aeca6@notabene.brown>
References: <3F8F31A3BFD1664EAB894D1BD6AF32B918A212E6@IRSMSX102.ger.corp.intel.com>
	<3F8F31A3BFD1664EAB894D1BD6AF32B918A390A8@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vrkV1hnMFdvsXyDmBerkPgE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F8F31A3BFD1664EAB894D1BD6AF32B918A390A8@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/vrkV1hnMFdvsXyDmBerkPgE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Apr 2012 08:58:14 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> Hi Neil,
> this patch is quite important. It seems to have been overlooked

Yes I had over-looked it.  Thanks for the reminder.  It is applied now.

NeilBrown



> Regards
> Anna
>=20
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Czarnowska, Anna
> > Sent: Monday, April 02, 2012 10:59 PM
> > To: NeilBrown
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Grabowski, Grzegorz
> > Subject: [PATCH] imsm: fix: thunderdome may drop 2tb attribute
> >=20
> > Spare superblock doesn't depend on other spares in container.
> > When loading container metadata thunderdome
> > may pick a small disk for the champion. This will result in incorrect
> > interpretation of sizes of other disks in container when joint
> > superblock
> > is returned. If any disk in container has the 2TB attribute set, the
> > result
> > must have it set too.
> >=20
> > Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> > ---
> >  super-intel.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/super-intel.c b/super-intel.c
> > index ed13542..869a39c 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -4079,6 +4079,8 @@ imsm_thunderdome(struct intel_super **super_list,
> > int len)
> >  		if (s =3D=3D champion)
> >  			continue;
> >=20
> > +		mpb->attributes |=3D s->anchor->attributes &
> > MPB_ATTRIB_2TB_DISK;
> > +
> >  		for (i =3D 0; i < mpb->num_disks; i++) {
> >  			struct imsm_disk *disk;
> >=20
> > --
> > 1.6.4.2
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/vrkV1hnMFdvsXyDmBerkPgE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT53VlTnsnt1WYoG5AQI78Q/9GY7N4KxudgxiGWAMMTypOtn1HstRj8yC
6aWLmeVh5jklqgvnnAwKy6nQ95pXTuuHv++GAug7sIw0qxpuZOR11O3uX3oEBxV5
ip02SdX4I5GewwGIqt4e8Dc0B+znmy4uarsQVEcCWUwJmjzIQOYmtzSB8XBUOGIR
hrR0WIai4xLXUGjofl7BKGMxsrQ8a7yBcz14Sfk8lW1cXrIg3CqW3Wc7mvoEec5c
oLBfGpRlLdMddajLMJnK5Oz1P9zPZrWz/dU+Dfi2L6KZQQ5lwpki4rbFhlZ5BAkX
TpdKDoepuIvAZBC9rzuG7WOqlW2baHR31wQn3CGQMVkm296kdU6qkHAcg9hCkp5o
f9ooVRDcBG0gZM8BFFPWAkyh8uqDc7+KGogNWAG96zvmb3ohDBKey29HDbndEj1p
TaScRZMg2vnfk/d9C+ZsGqmDNRQHVZfDCTAKwH64vbFdf63xftFtv1Q0oAftORLF
8JTQzaNu0/fiBuRG0uJUSmYTCbFaqZYOEY3758yUY6D10o5sPf/i9ABNyFm6bZ9i
TUPP9k9gaiSt3DNTU1rSaz1EZPyMQLo9UhFXlVJNYIDzt/sciNzF8bzoGrtIGodv
Ghvwh3wKIRt212l0X35B5dDdVD/EEEWUTvoHEcC4UsUCeqkaUdJoFhThmROrAvrZ
NeUb6bt+8j8=
=nCZf
-----END PGP SIGNATURE-----

--Sig_/vrkV1hnMFdvsXyDmBerkPgE--
