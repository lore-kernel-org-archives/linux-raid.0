From: NeilBrown <neilb@suse.de>
Subject: Re: [patch]raid5: get_active_stripe avoids device_lock
Date: Wed, 9 Apr 2014 15:24:25 +1000
Message-ID: <20140409152425.4c00fb2e@notabene.brown>
References: <20140408040553.GB20886@kernel.org>
	<20140409121729.18955461@notabene.brown>
	<20140409032742.GA16051@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3Lakf0n+M4Bvz1CbUhzET2/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140409032742.GA16051@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3Lakf0n+M4Bvz1CbUhzET2/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 9 Apr 2014 11:27:42 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Wed, Apr 09, 2014 at 12:17:29PM +1000, NeilBrown wrote:
> > On Tue, 8 Apr 2014 12:05:53 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > >=20
> > > For sequential workload (or request size big workload), get_active_st=
ripe can
> > > find cached stripe. In this case, we always hold device_lock, which e=
xposes a
> > > lot of lock contention for such workload. If stripe count isn't 0, we=
 don't
> > > need hold the lock actually, since we just increase its count. And th=
is is the
> > > hot code path for such workload. Unfortunately we must delete the BUG=
_ON.
> > >=20
> > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > > ---
> > >  drivers/md/raid5.c |    9 ++-------
> > >  1 file changed, 2 insertions(+), 7 deletions(-)
> > >=20
> > > Index: linux/drivers/md/raid5.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- linux.orig/drivers/md/raid5.c	2014-04-08 09:16:39.377536607 +0800
> > > +++ linux/drivers/md/raid5.c	2014-04-08 09:16:39.369536607 +0800
> > > @@ -679,14 +679,9 @@ get_active_stripe(struct r5conf *conf, s
> > >  				init_stripe(sh, sector, previous);
> > >  				atomic_inc(&sh->count);
> > >  			}
> > > -		} else {
> > > +		} else if (!atomic_add_unless(&sh->count, 1, 0)) {
> >=20
> > Can I be really fussy and ask you to use "atomic_inc_not_zero" rather t=
han
> > "atomic_add_unless" ??
> > I feel it makes the code a bit clearer.
>=20
> Missed this API. Yes, it's better.
>=20
>=20
> Subject: raid5: get_active_stripe avoids device_lock
>=20
> For sequential workload (or request size big workload), get_active_stripe=
 can
> find cached stripe. In this case, we always hold device_lock, which expos=
es a
> lot of lock contention for such workload. If stripe count isn't 0, we don=
't
> need hold the lock actually, since we just increase its count. And this i=
s the
> hot code path for such workload. Unfortunately we must delete the BUG_ON.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |    9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2014-04-09 11:07:01.165231305 +0800
> +++ linux/drivers/md/raid5.c	2014-04-09 11:07:26.492913067 +0800
> @@ -679,14 +679,9 @@ get_active_stripe(struct r5conf *conf, s
>  				init_stripe(sh, sector, previous);
>  				atomic_inc(&sh->count);
>  			}
> -		} else {
> +		} else if (!atomic_inc_not_zero(&sh->count)) {
>  			spin_lock(&conf->device_lock);
> -			if (atomic_read(&sh->count)) {
> -				BUG_ON(!list_empty(&sh->lru)
> -				    && !test_bit(STRIPE_EXPANDING, &sh->state)
> -				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state)
> -					);
> -			} else {
> +			if (!atomic_read(&sh->count)) {
>  				if (!test_bit(STRIPE_HANDLE, &sh->state))
>  					atomic_inc(&conf->active_stripes);
>  				BUG_ON(list_empty(&sh->lru) &&


Applied, thanks.

NeilBrown


--Sig_/3Lakf0n+M4Bvz1CbUhzET2/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0TZiTnsnt1WYoG5AQKYAA//SLW4FgZKWXVE20OVstaTF3O12Zs7NmNq
GzVHK1Md19NSDkZoB2nfZUZ9BJ0E6Vaxc/Mdq22HqLWwXLR9XF/32qIT+ypcCpSk
TvV7bPwiT5zTNCYBsieG8uYvO/XTZkwJsEtNFCt6UGDYCCbyLR9exWc976Vr3YFj
8SuyEN43QWB69ZbgWequwKqyKFsHN5cEWiJroPY20VkLzHqt04CZO0WGVFi1DK1b
YWhGPAmR13LCo/ZGUinLiWLUeSLUb/kSjyoKcDgvhVjdv+fvIBopcS3TooLwi/5L
WWmZ8s2ZBc11+92XbUdCkGVLN0fl1X0p+FdQphDF2O7aAuPn2q9xfDgwdaC1b3vl
2aeRxFXmGiG8b3O++5MRh4SLb38URb9cmr8ouFRMOsSjjwKiduKuVylxsAjgxBOx
ARd4I1jOg7NS3MA24IDH/h3eZoe5y3LYAOfZaXpNm/UqFTKY1rbGDU4614Lg7nt5
VsOC7dqusPYhYdN91zby2a2adPtREEbA15hJ2aLOggf1sAkDWPpvHZM+eXUw34Hw
Jb3tXYQ2BbT26mahF0EBDchWp88pDJRiYGW/HZf3sI9yPeM1CTIFaenKCnKPZ/bj
fWh2vYFjgKlC6TgtjjzCdMYaQo4aYgS3xHjKdbm2TwTbwKwz8GcLYOEKivV9XHs+
lH1gHQLVsTM=
=FXQt
-----END PGP SIGNATURE-----

--Sig_/3Lakf0n+M4Bvz1CbUhzET2/--
