From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/3] imsm: FIX: 'UT 09imsm-assemble' fails
Date: Thu, 15 Dec 2011 22:07:43 +1100
Message-ID: <20111215220743.1c072d0d@notabene.brown>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
	<20111214150712.21483.48715.stgit@gklab-128-013.igk.intel.com>
	<20111215150114.68ee8522@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A060FAC@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/b4eSB_ufHWjkcUqGDMoRb4d"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A060FAC@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/b4eSB_ufHWjkcUqGDMoRb4d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Dec 2011 10:28:08 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

>=20
>=20
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Thursday, December 15, 2011 5:01 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Willia=
ms,
> > Dan J
> > Subject: Re: [PATCH 2/3] imsm: FIX: 'UT 09imsm-assemble' fails
> >=20
> > On Wed, 14 Dec 2011 16:07:12 +0100 Adam Kwolek
> > <adam.kwolek@intel.com> wrote:
> >=20
> > > Problem was introduced by patch (2011-06-08):
> > >    getinfo_super now clears the 'info' structure before filling it in.
> > >
> > > Field update private is not managed here and pointer associated
> > > outside is cleaned up.
> > > Add code for field update_private cleaning preservation.
> > > In places where in patch
> > >   'getinfo_super now clears the 'info' structure before filling it in=
.'
> > > cleaning structure was removed, cleaning update_private field was
> > > added as getinfo_super() cannot be responsible for this pointer
> > management.
> > >
> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > ---
> > >
> > >  Assemble.c    |    2 ++
> > >  Incremental.c |    3 +++
> > >  super-intel.c |    9 +++++++++
> > >  3 files changed, 14 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/Assemble.c b/Assemble.c
> > > index fac2bad..c8b538f 100644
> > > --- a/Assemble.c
> > > +++ b/Assemble.c
> > > @@ -422,6 +422,7 @@ int Assemble(struct supertype *st, char *mddev,
> > >  					int uuid[4];
> > >
> > >  					content =3D &info;
> > > +					info.update_private =3D NULL
> > >  					tst->ss->getinfo_super(tst, content,
> > NULL);
> > >
> > >  					if (!parse_uuid(ident->container,
> > uuid) || @@ -485,6 +486,7 @@
> > > int Assemble(struct supertype *st, char *mddev,
> > >  		} else {
> > >
> > >  			content =3D &info;
> > > +			info.update_private =3D NULL
> > >  			tst->ss->getinfo_super(tst, content, NULL);
> > >
> > >  			if (!ident_matches(ident, content, tst, diff --git
> > a/Incremental.c
> > > b/Incremental.c index d3724a4..112a1ec 100644
> > > --- a/Incremental.c
> > > +++ b/Incremental.c
> > > @@ -205,6 +205,7 @@ int Incremental(char *devname, int verbose, int
> > runstop,
> > >  	}
> > >  	close (dfd); dfd =3D -1;
> > >
> > > +	info.update_private =3D NULL
> > >  	st->ss->getinfo_super(st, &info, NULL);
> > >
> > >  	/* 3/ Check if there is a match in mdadm.conf */ @@ -404,6 +405,7
> > @@
> > > int Incremental(char *devname, int verbose, int runstop,
> > >  				goto out_unlock;
> > >  			}
> > >  			close(dfd2);
> > > +			info.update_private =3D NULL
> > >  			st2->ss->getinfo_super(st2, &info2, NULL);
> > >  			st2->ss->free_super(st2);
> > >  			if (info.array.level !=3D info2.array.level || @@ -1382,6
> > +1384,7 @@
> > > static int Incremental_container(struct supertype *st, char *devname,
> > >  	int ra_blocked =3D 0;
> > >  	int ra_all =3D 0;
> > >
> > > +	info.update_private =3D NULL
> > >  	st->ss->getinfo_super(st, &info, NULL);
> > >
> > >  	if ((runstop > 0 && info.container_enough >=3D 0) || diff --git
> > > a/super-intel.c b/super-intel.c index e1073ef..5e1d278 100644
> > > --- a/super-intel.c
> > > +++ b/super-intel.c
> > > @@ -2365,8 +2365,13 @@ static void getinfo_super_imsm_volume(struct
> > supertype *st, struct mdinfo *info,
> > >  	char *devname;
> > >  	unsigned int component_size_alligment;
> > >  	int map_disks =3D info->array.raid_disks;
> > > +	void *update_private_saver =3D info->update_private;
> > >
> > >  	memset(info, 0, sizeof(*info));
> > > +	/* preserve pointer cleanup, as someone elese is pointer owner
> > > +	 */
> > > +	info->update_private =3D update_private_saver;
> > > +
> > >  	if (prev_map)
> > >  		map_to_analyse =3D prev_map;
> > >
> > > @@ -2601,12 +2606,16 @@ static void getinfo_super_imsm(struct
> > supertype *st, struct mdinfo *info, char *
> > >  	int max_enough =3D -1;
> > >  	int i;
> > >  	struct imsm_super *mpb;
> > > +	void *update_private_saver =3D info->update_private;
> > >
> > >  	if (super->current_vol >=3D 0) {
> > >  		getinfo_super_imsm_volume(st, info, map);
> > >  		return;
> > >  	}
> > >  	memset(info, 0, sizeof(*info));
> > > +	/* preserve pointer cleanup, as someone elese is pointer owner
> > > +	 */
> > > +	info->update_private =3D update_private_saver;
> > >
> > >  	/* Set raid_disks to zero so that Assemble will always pull in valid
> > >  	 * spares
> > >
> >=20
> > You didn't really think I'd let that through, did you :-)
> >=20
> > I've written an alternate which gets rid of update_private.
> >=20
> > Could you and Dan please review and check it performs as required.
> >=20
> > Thanks,
> > NeilBrown
>=20
>=20
>=20
> Don't you think that condition should set rv variable in opposite way? E.=
g.:
>  +		} else {
>  +			if (info->uuid[0] !=3D info->uuid[1] ||
>  +			    info->uuid[1] !=3D info->uuid[2] ||
>  +			    info->uuid[2] !=3D info->uuid[3])
>  +				rv =3D 0;
>  +			else
>  +				rv =3D -1;
>   		}
>=20
> I think that when condition is true, this means "random" value and update=
 should be performed.

If all 4 numbers are the same, then it is almost certain that uuid_set was
true the first time through and so we made them all the same.
In that case we want to succeed and used the first number as the family.
If the number are not all the same, then uuid_set was never true so the uuid
was given on the command line and we cannot handle that case so we give an
error.

So I think the original code is correct.

Thanks,
NeilBrown



>=20
> BR
> Adam
>=20
>=20
> >=20
> >=20
> > commit 8606be19835abaf888d0fbd1729dcda82a8b2815
> > Author: NeilBrown <neilb@suse.de>
> > Date:   Thu Dec 15 14:59:12 2011 +1100
> >=20
> >     Remove update_private
> >=20
> >     This fields doesn't work any more as ->getinfo_super clears the info
> >     structure at an awkward time.  So get rid of it and do it different=
ly.
> >=20
> >     The issue is that the metadata handler cannot tell if the uuid it h=
as
> >     was randomly generated or explicitly requested, except on the first
> >     call.
> >     And we don't want to accept explicit requests for IMSM.
> >     So when it was auto-generated, make it look distinctive by having t=
he
> >     same int copied in all 4 positions.  If someone requests a uuid like
> >     that, I guess they get away with it.
> >=20
> >     Reported-by: Adam Kwolek <adam.kwolek@intel.com>
> >     Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > diff --git a/Assemble.c b/Assemble.c
> > index fac2bad..74fb6a3 100644
> > --- a/Assemble.c
> > +++ b/Assemble.c
> > @@ -706,7 +706,6 @@ int Assemble(struct supertype *st, char *mddev,
> >  	bitmap_done =3D 0;
> >  #endif
> >  	/* Ok, no bad inconsistancy, we can try updating etc */
> > -	content->update_private =3D NULL;
> >  	devices =3D malloc(num_devs * sizeof(*devices));
> >  	devmap =3D calloc(num_devs * content->array.raid_disks, 1);
> >  	for (tmpdev =3D devlist; tmpdev; tmpdev=3Dtmpdev->next) if (tmpdev-
> > >used =3D=3D 1) { @@ -891,8 +890,6 @@ int Assemble(struct supertype *st=
, char
> > *mddev,
> >  		}
> >  		devcnt++;
> >  	}
> > -	free(content->update_private);
> > -	content->update_private =3D NULL;
> >=20
> >  	if (devcnt =3D=3D 0) {
> >  		fprintf(stderr, Name ": no devices found for %s\n", diff --git
> > a/mdadm.h b/mdadm.h index 1351d42..4f3533f 100644
> > --- a/mdadm.h
> > +++ b/mdadm.h
> > @@ -217,11 +217,6 @@ struct mdinfo {
> >  	unsigned long		cache_size; /* size of raid456 stripe cache*/
> >  	int			mismatch_cnt;
> >  	char			text_version[50];
> > -	void 			*update_private; /* for passing metadata-
> > format
> > -						  * specific update data
> > -						  * between successive calls
> > to
> > -						  * update_super()
> > -						  */
> >=20
> >  	int container_member; /* for assembling external-metatdata arrays
> >  			       * This is to be used internally by metadata diff --
> > git a/super-intel.c b/super-intel.c index e1073ef..78781c7 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -2791,25 +2791,30 @@ static int update_super_imsm(struct supertype
> > *st, struct mdinfo *info,
> >=20
> >  	mpb =3D super->anchor;
> >=20
> > -	if (strcmp(update, "uuid") =3D=3D 0 && uuid_set && !info-
> > >update_private)
> > -		rv =3D -1;
> > -	else if (strcmp(update, "uuid") =3D=3D 0 && uuid_set && info-
> > >update_private) {
> > -		mpb->orig_family_num =3D *((__u32 *) info-
> > >update_private);
> > -		rv =3D 0;
> > -	} else if (strcmp(update, "uuid") =3D=3D 0) {
> > -		__u32 *new_family =3D malloc(sizeof(*new_family));
> > -
> > -		/* update orig_family_number with the incoming random
> > -		 * data, report the new effective uuid, and store the
> > -		 * new orig_family_num for future updates.
> > +	if (strcmp(update, "uuid") =3D=3D 0) {
> > +		/* We take this to mean that the family_num should be
> > updated.
> > +		 * However that is much smaller than the uuid so we cannot
> > really
> > +		 * allow an explicit uuid to be given.  And it is hard to reliably
> > +		 * know if one was.
> > +		 * So if !uuid_set we know the current uuid is random and
> > just used
> > +		 * the first 'int' and copy it to the other 3 positions.
> > +		 * Otherwise we require the 4 'int's to be the same as would
> > be the
> > +		 * case if we are using a random uuid.  So an explicit uuid will
> > be
> > +		 * accepted as long as all for ints are the same... which
> > shouldn't
> > +hurt
> >  		 */
> > -		if (new_family) {
> > -			memcpy(&mpb->orig_family_num, info->uuid,
> > sizeof(__u32));
> > -			uuid_from_super_imsm(st, info->uuid);
> > -			*new_family =3D mpb->orig_family_num;
> > -			info->update_private =3D new_family;
> > +		if (uuid_set) {
> > +			info->uuid[1] =3D info->uuid[2] =3D info->uuid[3] =3D info-
> > >uuid[0];
> >  			rv =3D 0;
> > +		} else {
> > +			if (info->uuid[0] !=3D info->uuid[1] ||
> > +			    info->uuid[1] !=3D info->uuid[2] ||
> > +			    info->uuid[2] !=3D info->uuid[3])
> > +				rv =3D -1;
> > +			else
> > +				rv =3D 0;
> >  		}
> > +		if (rv =3D=3D 0)
> > +			mpb->orig_family_num =3D info->uuid[0];
> >  	} else if (strcmp(update, "assemble") =3D=3D 0)
> >  		rv =3D 0;
> >  	else


--Sig_/b4eSB_ufHWjkcUqGDMoRb4d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTunU/znsnt1WYoG5AQJBQw/9FCvthqSxeiJlvQzo0RPJAkHcOnvvyU/D
y12qjw/A28B2znQGtzJWDNx+tP29rR0Wk4Wp9OUOawHIlURHy9Olz7OyojpuYXhL
Ja7Wg5dhiUbYK8+9Zpoyhulroj3UP+ZtFU+zxvYoUAyam6F6JO3rBeb5sE+DAe6n
skWKotWNfSJNFSa6ZC2Pmq/kuEcuWaTvb8Zhwt2CvSln8Dv8H0YGOzeBOwfchZ0Q
CZKgX4ydSxXTlVVwKTz731dNDAqIz4FnW4xUbOGNXq7WLT+YvDGweVS0Nt3GE9Vo
Ge/zD9CC6hz4/Me1z8qULI6z2Nz6aSrVBbKwYNowtm7a8VwDP18OuIECH9LZ0gy2
84GC5Lpx9rzAT1VNMJQl65HGWG8SrJUOf6f5KUkpWL0ofV9Sg8u1IbMjWT2Ar4Ez
1Nj9vCYIrv6juHHduwDPj0ofKck/LmAOzYgQo9M9EFxfeKAcO24bZnSTCPI0Trhm
GgaE2Hd1xXMjZ7ZXVZeMGeEN6jWgfCMHZ35PMRYMlJcX2mTcQaKyyZj0Cu2+lFhP
QHaZvjBLcqiAfCPWhtwM9uA0UdQBq1HxBj1g7enof/4oAiwqt6FQSAFJe6N5fLwl
bnLUAcmF9nNcy7tpYXBfsMrcZDHODdRVF6mfUoA8iICvLVxNumRtNrIsxVZFQO4X
UCHz2XZHvCM=
=L5Si
-----END PGP SIGNATURE-----

--Sig_/b4eSB_ufHWjkcUqGDMoRb4d--
