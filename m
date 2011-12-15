From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] imsm: FIX: UT '08imsm-overlap' fails
Date: Thu, 15 Dec 2011 15:03:14 +1100
Message-ID: <20111215150314.7e5694c7@notabene.brown>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
	<20111214150720.21483.27249.stgit@gklab-128-013.igk.intel.com>
	<CABE8wwt44LbrKEGJjoUyjOt5zDP2=uO60hVPYfWpxMHi+EuQwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3v1UVpnOAJAepk3hY4LkVYR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwt44LbrKEGJjoUyjOt5zDP2=uO60hVPYfWpxMHi+EuQwg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Adam Kwolek <adam.kwolek@intel.com>, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

--Sig_/3v1UVpnOAJAepk3hY4LkVYR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Dec 2011 10:21:07 -0800 "Williams, Dan J"
<dan.j.williams@intel.com> wrote:

> On Wed, Dec 14, 2011 at 7:07 AM, Adam Kwolek <adam.kwolek@intel.com> wrot=
e:
> > Problem was introduced by patch (2011-09-19):
> > =C2=A0 Create: Allow to create two volumes of different sizes within on=
e container
> >
> > To resolve problem check requested disks number not against all disks
> > recorded in metadata, but against disks number set in array map structu=
re.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> > =C2=A0super-intel.c | =C2=A0 24 ++++++++++++++++++++----
> > =C2=A01 files changed, 20 insertions(+), 4 deletions(-)
> >
> > diff --git a/super-intel.c b/super-intel.c
> > index 5e1d278..3c10d29 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -5318,10 +5318,26 @@ static int validate_geometry_imsm_volume(struct=
 supertype *st, int level,
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0mpb =3D super->anchor;
> >
> > - =C2=A0 =C2=A0 =C2=A0 if (mpb->num_raid_devs > 0 && mpb->num_disks !=
=3D raiddisks) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, Name=
 ": the option-rom requires all "
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "member disks to be a member of all volumes.\n");
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> > + =C2=A0 =C2=A0 =C2=A0 /* check if currently verified volume spans the =
same disks number
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* as all other arrays that belongs to meta=
data.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Do not allow to create volume with diffe=
rent disks number
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* than curently is used.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < mpb->num_raid_devs; i++) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* There is any alre=
ady existing array in metadata
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct imsm_dev *dev=
 =3D get_imsm_dev(super, i);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct imsm_map *map=
 =3D NULL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dev)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 map =3D get_imsm_map(dev, MAP_0);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (map) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (raiddisks !=3D map->num_members) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, Name ": the option-rom =
requires"
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " all membe=
r disks to be a member of "
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "all volume=
s.\n");
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>=20
> I'd prefer to move this check back to the other 'orom' checks in
> validate_geometry_imsm_volume(), and make it dependent on the presence
> of the orom.
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 07d47b5..9885b98 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5122,12 +5122,6 @@ static int validate_geometry_imsm_volume(struct
> supertype *st, int level,
>  	if (!super)
>  		return 0;
>=20
> -	if (mpb->num_raid_devs > 0 && mpb->num_disks !=3D raiddisks) {
> -		fprintf(stderr, Name ": the option-rom requires all "
> -			"member disks to be a member of all volumes.\n");
> -		return 0;
> -	}
> -
>  	if (!validate_geometry_imsm_orom(super, level, layout, raiddisks,
> chunk, verbose)) {
>  		fprintf(stderr, Name ": RAID gemetry validation failed. "
>  			"Cannot proceed with the action(s).\n");
> @@ -5206,6 +5200,11 @@ static int validate_geometry_imsm_volume(struct
> supertype *st, int level,
>  		fprintf(stderr, Name ": The option-rom requires all member"
>  			" disks to be a member of all volumes\n");
>  		return 0;
> +	} else if (super->orom && mpb->num_raid_devs > 0 &&
> +		   mpb->num_disks !=3D raiddisks) {
> +		fprintf(stderr, Name ": The option-rom requires all member"
> +			" disks to be a member of all volumes\n");
> +		return 0;
>  	}
>=20
>  	/* retrieve the largest free space block */


Hi Dan,
 I think you are presenting this as an alternate - is that correct?
It seems a lit simpler - does it do enough?

Or is it just a precursor, and then we apply Adam's patch changing the same
code but in a different location?

Slightly confused...

NeilBrown


--Sig_/3v1UVpnOAJAepk3hY4LkVYR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTulxgjnsnt1WYoG5AQK9TQ/+M2Z92DihA30NjCKzus4YUvaeIWT+N2EM
8C/nobXA5B6bFooqXuuzvYFFGiKnA9LLUEgymguxf+ryY0KVhBHAyqCp2ACeEm3H
v4A1DWuZcgc8yPSWXh9SnuPstO3XUoeV/rn0txp2XMWIprzwlx4CpAVX1k/WhR5h
DfIRNqs5n5cwSv3/5jxRuGbsdwTsFWos4Di7LSsxxX9e+gBh1tLowLkeWZ6t1z7z
bShslErJ4tDJ7yJd1IeYchzxfSEWG8Sc4v+tlw6QdH39Yt4zo7v17ZGkDbFQHZqQ
0Y8M89rjq0NEYRShqsj/N/IaFH4XfXM9TOnYDkfbOG9o0gbKCfg8fRzGhHV8B/eL
lOGYnQxJjfdfq4ZwCx7wpi7jM6hRzWiNhJzxdK2iRqpwRdrjG2SyDmuO8IfrXPND
elNuZTamDM8XBb0zXjQsk/7dnAUxO8TL8L0UjHNbjqANaWj6L613NO59yZS08F6G
IIPlj4bwRZe5uHKlYGjt0MGb3rK3HG8K9HVPPT2fbsDUzzY8yo2pgpxYwlRtnwoC
Dt+RyjRTmxM+J6TApJF46K+AWGwjDGHgd+f4u9m4VUXsVH5a0ONexQD5TXd0NExs
mbXAgPTRXdQY/WzY2Z9OZR1un2bCq/Y66E++qoCDjab2d+2e3t8tAp7PfG2jGdaD
zkXQ6TkGygM=
=Irzb
-----END PGP SIGNATURE-----

--Sig_/3v1UVpnOAJAepk3hY4LkVYR--
