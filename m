From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH] md: raid0: Replace hash table lookup by looping over all strip_zones.
Date: Thu, 14 May 2009 14:10:42 +0200
Message-ID: <20090514121042.GH11504@skl-net.de>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org> <1242297833-13908-2-git-send-email-maan@systemlinux.org> <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y9PDtDHaFrXNoMPU"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--y9PDtDHaFrXNoMPU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21:15, NeilBrown wrote:
> > +/* Find the zone which holds a particular offset */
> > +static struct strip_zone *find_zone(struct raid0_private_data *conf,
> > +		sector_t sector)
> > +{
> > +	int i;
> > +
> > +	for (i =3D 0; i < conf->nr_strip_zones; i++) {
> > +		struct strip_zone *z =3D conf->strip_zone + i;
> > +
> > +		if (sector < z->zone_start + z->sectors)
> > +			return z;
> > +	}
>=20
> Maybe I'm being petty, but I really don't like this...
>=20
> I really like
> > -        while (sector >=3D zone->zone_start + zone->sectors)
> > -                zone++;
>=20
> It seems to capture what is really happening.
> But I can see that your code has a defensive aspect to it
> which is hard to argue against.
>=20
> It's probably the fact that there are two loop variables (i and z)
> that bothers me....
> Here is a thought.  How about we extend the stripe_zone array
> by one element and put a sentinal at the end, with ->zone_start being
> the size of the drive ... or maybe even "max sector".
>=20
> Then the loop could be
>    for (i =3D 0; i < conf->nr_strip_zones; i++)
>          if (sector < conf->strip_zone[i+1])
>                return conf->strip_zone[i]
>=20
> Save our selves an 'add' that way :-)

Saving an addition is a good thing as find_zone() is certainly
performance-critical. After all, that's why the original author used
hash tables.

The drawback is of course that we will happily return the last zone
for (invalid) requests beyond the array size. If that happens, data
corruption on the drive(s) of the last zone will likely be the result,
so I feel a bit uncomfortable in doing this.

How about extending stripe_zone as you propose, storing the array
size in ->zone_start of the last element and still call BUG() after
the loop?  That still saves the additional add and avoids the mentioned
data corruption.

> > +	zone =3D find_zone(conf, sector);
> > +	if (!zone)
> > +		return 1;
>=20
> I don't much like those last two lines either.  zone will
> never be NULL because if find_zone doesn't find anything, it
> calls BUG.  And returning from make_request without doing any IO
> is just wrong.  So those two lines can go.

Yup. Do you want me to rework the patches, or should I follow up with
patches on top of the series?

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--y9PDtDHaFrXNoMPU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKDApCWto1QDEAkw8RAqyBAKCL5NiRit/NRlcIvzLlzjzx6W4jcgCdHV+Q
MiEM0nrI2aCUZc6U1Nnw3jY=
=diV7
-----END PGP SIGNATURE-----

--y9PDtDHaFrXNoMPU--
