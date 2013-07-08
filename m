From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 11/27] DDF: layout_ddf2md: new DDF->md RAID layout
 conversion
Date: Mon, 8 Jul 2013 16:48:20 +1000
Message-ID: <20130708164820.3a344e28@notabene.brown>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
	<1372883287-8859-12-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eW98UahWYtnC=/2YU_3ea7s"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-12-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/eW98UahWYtnC=/2YU_3ea7s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Jul 2013 22:27:51 +0200 mwilck@arcor.de wrote:

> layout_ddf2md() is a new RAID layout conversion routine.
> It obsoletes the previous separate routines for obtaining
> md level and layout (map_num1, rlq_to_layout).
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  super-ddf.c |  197 ++++++++++++++++++++++++++++++-----------------------=
------
>  1 files changed, 100 insertions(+), 97 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index 0f955be..a43401e 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -484,6 +484,102 @@ static unsigned int calc_crc(void *buf, int len)
>  	return __cpu_to_be32(newcrc);
>  }
> =20
> +static int err_bad_ddf_layout(const struct vd_config *conf)
> +{
> +	pr_err("DDF RAID %u qualifier %u with %u disks is unsupported\n",
> +	       conf->prl, conf->rlq, __be16_to_cpu(conf->prim_elmnt_count));
> +	return -1;
> +}
> +
> +static int layout_ddf2md(const struct vd_config *conf,
> +			 mdu_array_info_t *array)
> +{
> +	int level =3D LEVEL_UNSUPPORTED;
> +	int layout =3D 0;
> +	int raiddisks =3D __be16_to_cpu(conf->prim_elmnt_count);
> +
> +	if (conf->sec_elmnt_count > 1) {
> +		/* see also check_secondary() */
> +		if (conf->prl !=3D DDF_RAID1 ||
> +		    (conf->srl !=3D DDF_2STRIPED && conf->srl !=3D DDF_2SPANNED)) {
> +			pr_err("Unsupported secondary RAID level %u/%u\n",
> +			       conf->prl, conf->srl);
> +			return -1;
> +		}
> +		if (raiddisks =3D=3D 2 && conf->rlq =3D=3D DDF_RAID1_SIMPLE)
> +			layout =3D 0x102;
> +		else if  (raiddisks =3D=3D 3 && conf->rlq =3D=3D DDF_RAID1_MULTI)
> +			layout =3D 0x103;
> +		else
> +			return err_bad_ddf_layout(conf);
> +		raiddisks *=3D conf->sec_elmnt_count;
> +		level =3D 10;
> +		goto good;
> +	}
> +
> +	switch (conf->prl) {
> +	case DDF_CONCAT:
> +		level =3D LEVEL_LINEAR;
> +		break;
> +	case DDF_RAID0:
> +		if (conf->rlq !=3D DDF_RAID0_SIMPLE)
> +			return err_bad_ddf_layout(conf);
> +		level =3D 0;
> +		break;
> +	case DDF_RAID1:
> +		if (!((conf->rlq =3D=3D DDF_RAID1_SIMPLE && raiddisks =3D=3D 2) ||
> +		      (conf->rlq =3D=3D DDF_RAID1_MULTI && raiddisks =3D=3D 3)))
> +			return err_bad_ddf_layout(conf);
> +		level =3D 1;
> +		break;
> +	case DDF_RAID4:
> +		if (conf->rlq !=3D DDF_RAID4_N)
> +			return err_bad_ddf_layout(conf);
> +		level =3D 4;
> +		break;
> +	case DDF_RAID5:
> +		switch (conf->rlq) {
> +		case DDF_RAID5_N_RESTART:
> +			layout =3D ALGORITHM_LEFT_ASYMMETRIC;
> +			break;
> +		case DDF_RAID5_0_RESTART:
> +			layout =3D ALGORITHM_RIGHT_ASYMMETRIC;
> +			break;
> +		case DDF_RAID5_N_CONTINUE:
> +			layout =3D ALGORITHM_LEFT_SYMMETRIC;
> +			break;
> +		default:
> +			return err_bad_ddf_layout(conf);
> +		}
> +		level =3D 5;
> +		break;
> +	case DDF_RAID6:
> +		switch (conf->rlq) {
> +		case DDF_RAID5_N_RESTART:
> +			layout =3D ALGORITHM_ROTATING_N_RESTART;
> +			break;
> +		case DDF_RAID6_0_RESTART:
> +			layout =3D ALGORITHM_ROTATING_ZERO_RESTART;
> +			break;
> +		case DDF_RAID5_N_CONTINUE:
> +			layout =3D ALGORITHM_ROTATING_N_CONTINUE;
> +			break;
> +		default:
> +			return err_bad_ddf_layout(conf);
> +		}
> +		level =3D 6;
> +		break;
> +	default:
> +		return err_bad_ddf_layout(conf);
> +	};
> +
> +good:
> +	array->level =3D level;
> +	array->layout =3D layout;
> +	array->raid_disks =3D raiddisks;
> +	return 0;
> +}
> +
>  static int load_ddf_header(int fd, unsigned long long lba,
>  			   unsigned long long size,
>  			   int type,
> @@ -1032,33 +1128,6 @@ static mapping_t ddf_sec_level[] =3D {
>  };
>  #endif
> =20
> -struct num_mapping {
> -	int num1, num2;
> -};
> -static struct num_mapping ddf_level_num[] =3D {
> -	{ DDF_RAID0, 0 },
> -	{ DDF_RAID1, 1 },
> -	{ DDF_RAID3, LEVEL_UNSUPPORTED },
> -	{ DDF_RAID4, 4 },
> -	{ DDF_RAID5, 5 },
> -	{ DDF_RAID1E, LEVEL_UNSUPPORTED },
> -	{ DDF_JBOD, LEVEL_UNSUPPORTED },
> -	{ DDF_CONCAT, LEVEL_LINEAR },
> -	{ DDF_RAID5E, LEVEL_UNSUPPORTED },
> -	{ DDF_RAID5EE, LEVEL_UNSUPPORTED },
> -	{ DDF_RAID6, 6},
> -	{ MAXINT, MAXINT }
> -};

Ooops.  You removed that while there was still a user.
Code must compile after each patch!
I've delayed the removal of this structure to the next patch, which removes
the last user.

NeilBrown


> -
> -static int map_num1(struct num_mapping *map, int num)
> -{
> -	int i;
> -	for (i=3D0 ; map[i].num1 !=3D MAXINT; i++)
> -		if (map[i].num1 =3D=3D num)
> -			break;
> -	return map[i].num2;
> -}
> -
>  static int all_ff(const char *guid)
>  {
>  	int i;
> @@ -1638,8 +1707,6 @@ static void getinfo_super_ddf(struct supertype *st,=
 struct mdinfo *info, char *m
>  	}
>  }
> =20
> -static int rlq_to_layout(int rlq, int prl, int raiddisks);
> -
>  static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *i=
nfo, char *map)
>  {
>  	struct ddf_super *ddf =3D st->sb;
> @@ -1651,12 +1718,8 @@ static void getinfo_super_ddf_bvd(struct supertype=
 *st, struct mdinfo *info, cha
>  	__u32 *cptr;
> =20
>  	memset(info, 0, sizeof(*info));
> -	/* FIXME this returns BVD info - what if we want SVD ?? */
> -
> -	info->array.raid_disks    =3D __be16_to_cpu(vc->conf.prim_elmnt_count);
> -	info->array.level	  =3D map_num1(ddf_level_num, vc->conf.prl);
> -	info->array.layout	  =3D rlq_to_layout(vc->conf.rlq, vc->conf.prl,
> -						  info->array.raid_disks);
> +	if (layout_ddf2md(&vc->conf, &info->array) =3D=3D -1)
> +		return;
>  	info->array.md_minor	  =3D -1;
>  	cptr =3D (__u32 *)(vc->conf.guid + 16);
>  	info->array.ctime	  =3D DECADE + __be32_to_cpu(*cptr);
> @@ -2140,48 +2203,6 @@ static int layout_to_rlq(int level, int layout, in=
t raiddisks)
>  	return -1;
>  }
> =20
> -static int rlq_to_layout(int rlq, int prl, int raiddisks)
> -{
> -	switch(prl) {
> -	case DDF_RAID0:
> -		return 0; /* hopefully rlq =3D=3D DDF_RAID0_SIMPLE */
> -	case DDF_RAID1:
> -		return 0; /* hopefully rlq =3D=3D SIMPLE or MULTI depending
> -			     on raiddisks*/
> -	case DDF_RAID4:
> -		switch(rlq) {
> -		case DDF_RAID4_N:
> -			return 0;
> -		default:
> -			/* not supported */
> -			return -1; /* FIXME this isn't checked */
> -		}
> -	case DDF_RAID5:
> -		switch(rlq) {
> -		case DDF_RAID5_N_RESTART:
> -			return ALGORITHM_LEFT_ASYMMETRIC;
> -		case DDF_RAID5_0_RESTART:
> -			return ALGORITHM_RIGHT_ASYMMETRIC;
> -		case DDF_RAID5_N_CONTINUE:
> -			return ALGORITHM_LEFT_SYMMETRIC;
> -		default:
> -			return -1;
> -		}
> -	case DDF_RAID6:
> -		switch(rlq) {
> -		case DDF_RAID5_N_RESTART:
> -			return ALGORITHM_ROTATING_N_RESTART;
> -		case DDF_RAID6_0_RESTART:
> -			return ALGORITHM_ROTATING_ZERO_RESTART;
> -		case DDF_RAID5_N_CONTINUE:
> -			return ALGORITHM_ROTATING_N_CONTINUE;
> -		default:
> -			return -1;
> -		}
> -	}
> -	return -1;
> -}
> -
>  #ifndef MDASSEMBLE
>  struct extent {
>  	unsigned long long start, size;
> @@ -3433,26 +3454,8 @@ static struct mdinfo *container_content_ddf(struct=
 supertype *st, char *subarray
>  		this->next =3D rest;
>  		rest =3D this;
> =20
> -		if (vc->conf.sec_elmnt_count =3D=3D 1) {
> -			this->array.level =3D map_num1(ddf_level_num,
> -						     vc->conf.prl);
> -			this->array.raid_disks =3D
> -				__be16_to_cpu(vc->conf.prim_elmnt_count);
> -			this->array.layout =3D
> -				rlq_to_layout(vc->conf.rlq, vc->conf.prl,
> -					      this->array.raid_disks);
> -		} else {
> -			/* The only supported layout is RAID 10.
> -			 * Compatibility has been checked in check_secondary()
> -			 * above.
> -			 */
> -			this->array.level =3D 10;
> -			this->array.raid_disks =3D
> -				__be16_to_cpu(vc->conf.prim_elmnt_count)
> -				* vc->conf.sec_elmnt_count;
> -			this->array.layout =3D 0x100 |
> -				__be16_to_cpu(vc->conf.prim_elmnt_count);
> -		}
> +		if (layout_ddf2md(&vc->conf, &this->array))
> +			continue;
>  		this->array.md_minor      =3D -1;
>  		this->array.major_version =3D -1;
>  		this->array.minor_version =3D -2;


--Sig_/eW98UahWYtnC=/2YU_3ea7s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdpgtDnsnt1WYoG5AQJCKBAAtaGAXaLq7brmXRVLWnWIVxivfn/yFJvx
mQG6B0+PM1haSNekPKeDuzqNSlwZKlS+x61abi85wUhva3PKGTVpENPWD+whju4d
eCAiexxcSlH79Xuk9KqOmtNm7QmWxEkYg/YI8ab0aZMA+9r7XR6wXUXmcZwn/kpa
P8pegsiZr8vFJqwG+Pl17pwyi0h5yk/c6BV2cRo5bsDInDpAaUpwfCWpskJtMMQV
TBzJ2cRU7IcdXgI0V9Dk6otxjrGnCs1MXS97fyo04+VwiDfkFWIphR1HJcLO4tS3
5vNcZptptmc8+gxHXLN7gt/o3N/r/Y0aXmOik2vG3qPFV0aVco/hsehn//yAelj3
+vO8DFgZU6pFdWDFYkyBSKtQ2/rrnNu29pY1GVlvD2DGhaHrRYZ/+RH8Foyw2Gk2
xdZv4sFfG0/FEQ/Rry3oG+Gg122Yae85DJ1QiQLYEdSMdJM8bCuvZj2LY6Alutc+
3tScj79F/CTcOPeH7fA+w/69eC2JbCuqQVuBxuFdB7j0Q63ttKTspmtrTPcY1jLQ
jxaKslK9MTMiqagcT0Usqb2QSd0iReXC8YGhD7t6FSewzu9fXo3wbgRFOivqC55m
3VNIysDFzYG7DMcvGDAB2Asxm8eWM0V0zwJoEwAMadiRP3/vatFJB4hEX1WrJnZ9
6Ekr4S57bvQ=
=DmnB
-----END PGP SIGNATURE-----

--Sig_/eW98UahWYtnC=/2YU_3ea7s--
