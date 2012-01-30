From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 5/5] imsm: verify maximum supported active volumes in
 assembly
Date: Mon, 30 Jan 2012 12:02:32 +1100
Message-ID: <20120130120232.236c5343@notabene.brown>
References: <F9123E44003394499FDD2B17C60621D4075DE9@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ngGNCIeHGsVj1r8yK/Mm5qx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9123E44003394499FDD2B17C60621D4075DE9@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/ngGNCIeHGsVj1r8yK/Mm5qx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Jan 2012 11:20:27 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> Subject: [PATCH 5/5] imsm: verify maximum supported active volumes in ass=
embly
>=20
> Block assemblation of volumes when the total number of supported
> volumes is exceeded.
>=20
> Signed-off-by: Marcin Labun <marcin.labun@intel.com>

hi,
 I've applied the first four in this series, but I don't like this one.

1/ I don't think there is any need to impose this restriction when
   assembling an array - only when creating a new volume in an array.

2/ The check_volumes_number approach feels clumsy ... there must be a
   a better way (Assuming it is needed at all).

NeilBrown


> ---
>  Assemble.c    |    3 +-
>  Grow.c        |    6 +++-
>  Incremental.c |    3 +-
>  mdadm.h       |    1 +
>  super-intel.c |   73 +++++++++++++++++++++++++++++++++++++++++++--------=
-----
>  util.c        |    1 +
>  6 files changed, 66 insertions(+), 21 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index fd94461..1d2604f 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -438,7 +438,7 @@ int Assemble(struct supertype *st, char *mddev,
>  			if (verbose > 0)
>  				fprintf(stderr, Name ": looking in container %s\n",
>  					devname);
> -
> +			tst->check_volumes_number =3D 1;
>  			for (content =3D tst->ss->container_content(tst, NULL);
>  			     content;
>  			     content =3D content->next) {
> @@ -460,6 +460,7 @@ int Assemble(struct supertype *st, char *mddev,
>  				} else
>  					break;
>  			}
> +			tst->check_volumes_number =3D 0;
>  			if (!content) {
>  				tmpdev->used =3D 2;
>  				goto loop; /* empty container */
> diff --git a/Grow.c b/Grow.c
> index 5dab37c..3a8b5c3 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1493,8 +1493,9 @@ int Grow_reshape(char *devname, int fd, int quiet, =
char *backup_file,
>  		if (st->ss->container_content) {
>  			struct mdinfo *cc =3D NULL;
>  			struct mdinfo *content =3D NULL;
> -
> +			st->check_volumes_number =3D 1;
>  			cc =3D st->ss->container_content(st, subarray);
> +			st->check_volumes_number =3D 0;
>  			for (content =3D cc; content ; content =3D content->next) {
>  				int allow_reshape =3D 1;
> =20
> @@ -3813,8 +3814,9 @@ int Grow_continue_command(char *devname, int fd,
>  			ret_val =3D 1;
>  			goto Grow_continue_command_exit;
>  		}
> -
> +		st->check_volumes_number =3D 1;
>  		cc =3D st->ss->container_content(st, subarray);
> +		st->check_volumes_number =3D 0;
>  		for (content =3D cc; content ; content =3D content->next) {
>  			char *array;
>  			int allow_reshape =3D 1;
> diff --git a/Incremental.c b/Incremental.c
> index 60175af..0e37f98 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -1407,8 +1407,9 @@ static int Incremental_container(struct supertype *=
st, char *devname,
>  		trustworthy =3D LOCAL;
>  	else
>  		trustworthy =3D FOREIGN;
> -
> +	st->check_volumes_number =3D 1;
>  	list =3D st->ss->container_content(st, NULL);
> +	st->check_volumes_number =3D 0;
>  	/* when nothing to activate - quit */
>  	if (list =3D=3D NULL)
>  		return 0;
> diff --git a/mdadm.h b/mdadm.h
> index f274ae7..ac96bc4 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -849,6 +849,7 @@ struct supertype {
>  	int minor_version;
>  	int max_devs;
>  	int container_dev;    /* devnum of container */
> +	int check_volumes_number;
>  	void *sb;
>  	void *info;
>  	int ignore_hw_compat; /* used to inform metadata handlers that it shoul=
d ignore
> diff --git a/super-intel.c b/super-intel.c
> index 51826bc..7fc1841 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -497,6 +497,9 @@ static const char *_sys_dev_type[] =3D {
>  	[SYS_DEV_SAS] =3D "SAS",
>  	[SYS_DEV_SATA] =3D "SATA"
>  };
> +#ifndef MDASSEMBLE
> +static int imsm_find_array_minor_by_subdev(int subdev, int container, in=
t *minor);
> +#endif
> =20
>  const char *get_sys_dev_type(enum sys_dev_type type)
>  {
> @@ -616,6 +619,7 @@ static struct supertype *match_metadata_desc_imsm(cha=
r *arg)
>  	st->ss =3D &super_imsm;
>  	st->max_devs =3D IMSM_MAX_DEVICES;
>  	st->minor_version =3D 0;
> +	st->check_volumes_number =3D 0;
>  	st->sb =3D NULL;
>  	return st;
>  }
> @@ -5658,6 +5662,7 @@ count_volumes_list(struct md_list *devlist, char *h=
omehost,
>  	}
>  	if (*found !=3D 0) {
>  		int err;
> +		st->check_volumes_number =3D 0;
>  		if ((err =3D load_super_imsm_all(st, -1, &st->sb, NULL, devlist, 0)) =
=3D=3D 0) {
>  			struct mdinfo *iter, *head =3D st->ss->container_content(st, NULL);
>  			for (iter =3D head; iter; iter =3D iter->next) {
> @@ -5701,7 +5706,7 @@ count_volumes_list(struct md_list *devlist, char *h=
omehost,
> =20
> =20
>  static int
> -count_volumes(char *hba, int dpa, int verbose)
> +count_volumes(char *hba, int dpa, int active_only, int verbose)
>  {
>  	struct md_list *devlist =3D NULL;
>  	int count =3D 0;
> @@ -5712,10 +5717,14 @@ count_volumes(char *hba, int dpa, int verbose)
>  	if (devlist =3D=3D NULL)
>  		return 0;
>  	 =20
> -	count =3D active_arrays_by_format("imsm", hba, &devlist, dpa, verbose);
> +	count =3D active_arrays_by_format("imsm", hba, &devlist, /*subarray,*/
> +					dpa, verbose);
>  	dprintf(" path: %s active arrays: %d\n", hba, count);
>  	if (devlist =3D=3D NULL)
>  		return 0;
> +	if (active_only)
> +		goto release;
> +
>  	do  {
>  		found =3D 0;
>  		count +=3D count_volumes_list(devlist,
> @@ -5726,7 +5735,8 @@ count_volumes(char *hba, int dpa, int verbose)
>  	} while (found);
>  =09
>  	dprintf("path: %s total number of volumes: %d\n", hba, count);
> -=09
> +
> + release:=09
>  	while(devlist) {
>  		struct md_list *dv =3D devlist;
>  		devlist =3D devlist->next;
> @@ -5815,6 +5825,17 @@ static int validate_geometry_imsm_volume(struct su=
pertype *st, int level,
>  			"Cannot proceed with the action(s).\n");
>  		return 0;
>  	}
> +	if (super->orom) {
> +		int count =3D count_volumes(super->hba->path,
> +					  super->orom->dpa,
> +					  0, /* count all volumes */
> +					  verbose);
> +		if (super->orom->vphba <=3D count) {
> +			pr_vrb(": platform does not support more then %d raid volumes.\n",
> +			       super->orom->vphba);
> +			return 0;
> +		}
> +	}
>  	if (!dev) {
>  		/* General test:  make sure there is space for
>  		 * 'raiddisks' device extents of size 'size' at a given
> @@ -5956,15 +5977,6 @@ static int validate_geometry_imsm_volume(struct su=
pertype *st, int level,
> =20
>  	*freesize =3D maxsize;
>  =09
> -	if (super->orom) {
> -		int count =3D count_volumes(super->hba->path,
> -				      super->orom->dpa, verbose);
> -		if (super->orom->vphba <=3D count) {
> -			pr_vrb(": platform does not support more then %d raid volumes.\n",
> -			       super->orom->vphba);
> -			return 0;
> -		}
> -	}
>  	return 1;
>  }
> =20
> @@ -6091,7 +6103,9 @@ static int validate_geometry_imsm(struct supertype =
*st, int level, int layout,
>  			if (super->orom && freesize) {
>  				int count;
>  				count =3D count_volumes(super->hba->path,
> -						      super->orom->dpa, verbose);
> +						      super->orom->dpa,
> +						      0, /* count all volumes */
> +						      verbose);
>  				if (super->orom->vphba <=3D count) {
>  					pr_vrb(": platform does not support more"
>  					       "then %d raid volumes.\n",
> @@ -6414,7 +6428,9 @@ static struct mdinfo *container_content_imsm(struct=
 supertype *st, char *subarra
>  	int sb_errors =3D 0;
>  	struct dl *d;
>  	int spare_disks =3D 0;
> -
> +#ifndef MDASSEMBLE
> +	int count =3D -1;
> +#endif
>  	/* do not assemble arrays when not all attributes are supported */
>  	if (imsm_check_attributes(mpb->attributes) =3D=3D 0) {
>  		sb_errors =3D 1;
> @@ -6428,8 +6444,6 @@ static struct mdinfo *container_content_imsm(struct=
 supertype *st, char *subarra
>  			"Arrays activation is blocked.\n");
>  		sb_errors =3D 1;
>  	}
> -
> -
>  	/* count spare devices, not used in maps
>  	 */
>  	for (d =3D super->disks; d; d =3D d->next)
> @@ -6444,6 +6458,7 @@ static struct mdinfo *container_content_imsm(struct=
 supertype *st, char *subarra
>  		int slot;
>  #ifndef MDASSEMBLE
>  		int chunk;
> +		int devnum;
>  #endif
>  		char *ep;
> =20
> @@ -6502,7 +6517,31 @@ static struct mdinfo *container_content_imsm(struc=
t supertype *st, char *subarra
>  			this->array.state |=3D
>  			  (1<<MD_SB_BLOCK_CONTAINER_RESHAPE) |
>  			  (1<<MD_SB_BLOCK_VOLUME);
> -
> +#ifndef MDASSEMBLE
> +		/* for inactive arrays check blocking condition */
> +		if ((super->orom) &&
> +		    (st->check_volumes_number) &&
> +		    (imsm_find_array_minor_by_subdev(i,
> +						     st->container_dev,
> +						     &devnum) !=3D 0)) {
> +			/* get volumes number */
> +			if (count =3D=3D -1)
> +				count =3D count_volumes(super->hba->path,
> +						      super->orom->dpa,
> +						      1, /* active only */
> +						      0);
> +			count++;
> +			if (super->orom->vphba < count) {
> +				this->array.state |=3D
> +				  (1<<MD_SB_BLOCK_CONTAINER_RESHAPE) |
> +				  (1<<MD_SB_BLOCK_VOLUME);
> +				fprintf(stderr, Name ": platform does not support more then %d raid =
volumes.\n"
> +					"Array %s activation is blocked.\n\n",
> +					super->orom->vphba,
> +					dev->volume);
> +			}
> +		  }
> +#endif		=09
>  		for (slot =3D 0 ; slot <  map->num_members; slot++) {
>  			unsigned long long recovery_start;
>  			struct mdinfo *info_d;
> diff --git a/util.c b/util.c
> index e95a366..ea18915 100644
> --- a/util.c
> +++ b/util.c
> @@ -1020,6 +1020,7 @@ struct supertype *dup_super(struct supertype *orig)
>  	st->ss =3D orig->ss;
>  	st->max_devs =3D orig->max_devs;
>  	st->minor_version =3D orig->minor_version;
> +	st->check_volumes_number =3D orig->check_volumes_number;
>  	st->sb =3D NULL;
>  	st->info =3D NULL;
>  	return st;


--Sig_/ngGNCIeHGsVj1r8yK/Mm5qx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTyXsKDnsnt1WYoG5AQI0hhAAxALCZHhoRogZ+2cCgyenrd3coXpalwIC
KxQlMNcIb5G9LRTiBhh1tgc+CAdftrkFtO8Zcb4d6S16TuxkRqnsWV+p3p9Zh1+l
JBUaCuABkfOsFlj7UI2Ewl1Zml3mfWZVr4F6Zo4UiLpLlK6iMUCMXmTiLCpp28s6
epHMQGcSVE0OeT5CnSXF5d49Tn8MIIiTu+5K3Yq3qjAYz5PaQG7m/HSBjW0jhY+I
0v5DKegNiSF+HxBl851yHe2Kd/mth/5ZxWXB0fh96GTrMRd6q4zUjcWX/JWjWgE2
dUEdh45A8qWH1vBGSbfOwufkPKTQLnQZtqvmewQolnNC5SJgVJXqLamhi2TdpRuT
1EAFX95Fxpj5shixeTMmhm+BtM0bSLiddxisdLTN+Sf6yr9gHMYZf2cmk9YWiDmg
FYraSp6dU7hlS3rgyrHQrMwaTFY1TpaIhSOfIH/JvSohSda4XXRuwzpkipazLOw2
S+XPP9hbTwFCmoA0JF/VEP5adb+kNjy4mWrBoDqhMozqpHr9OF5J9Y2J+CiYQhp/
vR1Sgdp066rO8C1BvUzK7yqFgfd0Y3+AUMtuswUnA32LEmLVKwDDPJ/nswS3AW+X
L8Q4hHTtHPwzpevCPpJvGvAsPtGr1Np71f//82E3SCftLDMhKNwLYRMO6w+1Pd1D
PMO6uXiyaYE=
=6aVI
-----END PGP SIGNATURE-----

--Sig_/ngGNCIeHGsVj1r8yK/Mm5qx--
