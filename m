From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 12/27] DDF: layout_md2ddf: new md->DDF layout conversion
Date: Mon, 8 Jul 2013 16:28:00 +1000
Message-ID: <20130708162800.11ddbc84@notabene.brown>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
	<1372883287-8859-13-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Asj7==5Jq05koh.ZXFSp8Jd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-13-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Asj7==5Jq05koh.ZXFSp8Jd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Jul 2013 22:27:52 +0200 mwilck@arcor.de wrote:

> Support for RAID 10 makes it necessary to rewrite the algorithm
> for deriving DDF layout from MD layout. The functions level_to_prl
> and layout_to_rlq are combined in a single function that takes
> md layout parameters and converts them to DDF.
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  super-ddf.c |  178 ++++++++++++++++++++++++++++++++++++++---------------=
------
>  1 files changed, 114 insertions(+), 64 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index a43401e..933485d 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -484,6 +484,107 @@ static unsigned int calc_crc(void *buf, int len)
>  	return __cpu_to_be32(newcrc);
>  }
> =20
> +#define DDF_INVALID_LEVEL 0xff
> +#define DDF_NO_SECONDARY 0xff
> +static int err_bad_md_layout(const mdu_array_info_t *array)
> +{
> +	pr_err("RAID%d layout %x with %d disks is unsupported for DDF\n",
> +	       array->level, array->layout, array->raid_disks);
> +	return DDF_INVALID_LEVEL;
> +}
> +
> +static int layout_md2ddf(const mdu_array_info_t *array,
> +			 struct vd_config *conf)
> +{
> +	__u16 prim_elmnt_count =3D __cpu_to_be16(array->raid_disks);
> +	__u8 prl =3D DDF_INVALID_LEVEL, rlq =3D 0;
> +	__u8 sec_elmnt_count =3D 1;
> +	__u8 srl =3D DDF_NO_SECONDARY;
> +
> +	switch (array->level) {
> +	case LEVEL_LINEAR:
> +		prl =3D DDF_CONCAT;
> +		break;
> +	case 0:
> +		rlq =3D DDF_RAID0_SIMPLE;
> +		prl =3D DDF_RAID0;
> +		break;
> +	case 1:
> +		switch (array->raid_disks) {
> +		case 2:
> +			rlq =3D DDF_RAID1_SIMPLE;
> +			break;
> +		case 3:
> +			rlq =3D DDF_RAID1_MULTI;
> +			break;
> +		default:
> +			return err_bad_md_layout(array);
> +		}
> +		prl =3D DDF_RAID1;
> +		break;
> +	case 4:
> +		if (array->layout !=3D 0)
> +			return err_bad_md_layout(array);
> +		rlq =3D DDF_RAID4_N;
> +		prl =3D DDF_RAID4;
> +		break;
> +	case 5:
> +		switch (array->layout) {
> +		case ALGORITHM_LEFT_ASYMMETRIC:
> +			rlq =3D DDF_RAID5_N_RESTART;
> +			break;
> +		case ALGORITHM_RIGHT_ASYMMETRIC:
> +			rlq =3D DDF_RAID5_0_RESTART;
> +			break;
> +		case ALGORITHM_LEFT_SYMMETRIC:
> +			rlq =3D DDF_RAID5_N_CONTINUE;
> +			break;
> +		case ALGORITHM_RIGHT_SYMMETRIC:
> +			/* not mentioned in standard */
> +			return err_bad_md_layout(array);

You need a 'default:' case here to throw an error.

> +		}
> +		prl =3D DDF_RAID5;
> +		break;
> +	case 6:
> +		switch (array->layout) {
> +		case ALGORITHM_ROTATING_N_RESTART:
> +			rlq =3D DDF_RAID5_N_RESTART;
> +			break;
> +		case ALGORITHM_ROTATING_ZERO_RESTART:
> +			rlq =3D DDF_RAID6_0_RESTART;
> +			break;
> +		case ALGORITHM_ROTATING_N_CONTINUE:
> +			rlq =3D DDF_RAID5_N_CONTINUE;
> +			break;
> +		}

Ditto here.

I've made those two changes to the patch.

NeilBrown


> +		prl =3D DDF_RAID6;
> +		break;
> +	case 10:
> +		if (array->raid_disks % 2 =3D=3D 0 && array->layout =3D=3D 0x102) {
> +			rlq =3D DDF_RAID1_SIMPLE;
> +			prim_elmnt_count =3D  __cpu_to_be16(2);
> +			sec_elmnt_count =3D array->raid_disks / 2;
> +		} else if (array->raid_disks % 3 =3D=3D 0
> +			   && array->layout =3D=3D 0x103) {
> +			rlq =3D DDF_RAID1_MULTI;
> +			prim_elmnt_count =3D  __cpu_to_be16(3);
> +			sec_elmnt_count =3D array->raid_disks / 3;
> +		} else
> +			return err_bad_md_layout(array);
> +		srl =3D DDF_2SPANNED;
> +		prl =3D DDF_RAID1;
> +		break;
> +	default:
> +		return err_bad_md_layout(array);
> +	}
> +	conf->prl =3D prl;
> +	conf->prim_elmnt_count =3D prim_elmnt_count;
> +	conf->rlq =3D rlq;
> +	conf->srl =3D srl;
> +	conf->sec_elmnt_count =3D sec_elmnt_count;
> +	return 0;
> +}
> +
>  static int err_bad_ddf_layout(const struct vd_config *conf)
>  {
>  	pr_err("DDF RAID %u qualifier %u with %u disks is unsupported\n",
> @@ -2150,59 +2251,6 @@ static int chunk_to_shift(int chunksize)
>  	return ffs(chunksize/512)-1;
>  }
> =20
> -static int level_to_prl(int level)
> -{
> -	switch (level) {
> -	case LEVEL_LINEAR: return DDF_CONCAT;
> -	case 0: return DDF_RAID0;
> -	case 1: return DDF_RAID1;
> -	case 4: return DDF_RAID4;
> -	case 5: return DDF_RAID5;
> -	case 6: return DDF_RAID6;
> -	default: return -1;
> -	}
> -}
> -
> -static int layout_to_rlq(int level, int layout, int raiddisks)
> -{
> -	switch(level) {
> -	case 0:
> -		return DDF_RAID0_SIMPLE;
> -	case 1:
> -		switch(raiddisks) {
> -		case 2: return DDF_RAID1_SIMPLE;
> -		case 3: return DDF_RAID1_MULTI;
> -		default: return -1;
> -		}
> -	case 4:
> -		switch(layout) {
> -		case 0: return DDF_RAID4_N;
> -		}
> -		break;
> -	case 5:
> -		switch(layout) {
> -		case ALGORITHM_LEFT_ASYMMETRIC:
> -			return DDF_RAID5_N_RESTART;
> -		case ALGORITHM_RIGHT_ASYMMETRIC:
> -			return DDF_RAID5_0_RESTART;
> -		case ALGORITHM_LEFT_SYMMETRIC:
> -			return DDF_RAID5_N_CONTINUE;
> -		case ALGORITHM_RIGHT_SYMMETRIC:
> -			return -1; /* not mentioned in standard */
> -		}
> -	case 6:
> -		switch(layout) {
> -		case ALGORITHM_ROTATING_N_RESTART:
> -			return DDF_RAID5_N_RESTART;
> -		case ALGORITHM_ROTATING_ZERO_RESTART:
> -			return DDF_RAID6_0_RESTART;
> -		case ALGORITHM_ROTATING_N_CONTINUE:
> -			return DDF_RAID5_N_CONTINUE;
> -		}
> -	}
> -	return -1;
> -}
> -
>  #ifndef MDASSEMBLE
>  struct extent {
>  	unsigned long long start, size;
> @@ -2320,13 +2368,15 @@ static int init_super_ddf_bvd(struct supertype *s=
t,
>  	vc->timestamp =3D __cpu_to_be32(time(0)-DECADE);
>  	vc->seqnum =3D __cpu_to_be32(1);
>  	memset(vc->pad0, 0xff, 24);
> -	vc->prim_elmnt_count =3D __cpu_to_be16(info->raid_disks);
>  	vc->chunk_shift =3D chunk_to_shift(info->chunk_size);
> -	vc->prl =3D level_to_prl(info->level);
> -	vc->rlq =3D layout_to_rlq(info->level, info->layout, info->raid_disks);
> -	vc->sec_elmnt_count =3D 1;
> +	if (layout_md2ddf(info, vc) =3D=3D -1 ||
> +		__be16_to_cpu(vc->prim_elmnt_count) > ddf->mppe) {
> +		pr_err("%s: unsupported RAID level/layout %d/%d with %d disks\n",
> +		       __func__, info->level, info->layout, info->raid_disks);
> +		free(vcl);
> +		return 0;
> +	}
>  	vc->sec_elmnt_seq =3D 0;
> -	vc->srl =3D 0;
>  	vc->blocks =3D __cpu_to_be64(info->size * 2);
>  	vc->array_blocks =3D __cpu_to_be64(
>  		calc_array_size(info->level, info->raid_disks, info->layout,
> @@ -2990,12 +3040,12 @@ static int validate_geometry_ddf(struct supertype=
 *st,
>  	}
> =20
>  	if (!dev) {
> -		/* Initial sanity check.  Exclude illegal levels. */
> -		int i;
> -		for (i=3D0; ddf_level_num[i].num1 !=3D MAXINT; i++)
> -			if (ddf_level_num[i].num2 =3D=3D level)
> -				break;
> -		if (ddf_level_num[i].num1 =3D=3D MAXINT) {
> +		mdu_array_info_t array =3D {
> +			.level =3D level, .layout =3D layout,
> +			.raid_disks =3D raiddisks
> +		};
> +		struct vd_config conf;
> +		if (layout_md2ddf(&array, &conf) =3D=3D -1) {
>  			if (verbose)
>  				pr_err("DDF does not support level %d arrays\n",
>  				       level);


--Sig_/Asj7==5Jq05koh.ZXFSp8Jd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdpb8Dnsnt1WYoG5AQKz9hAAmBo6Z1Sc9Exff5QiqwamWiZmwdx58mOe
Pt1tuDvM61npHjHMw9lX/kO6l5iLcll4hSimzQYjR9pX/EgZrzCt6qP8PkCRU5qw
bUZnUoTx5kXKHljlc0vldTlBO49TERiiUz/yvNDGu96/aefBsWcc7DDFa5iVmjaY
18wr/Jr//TNefLviANCnCosdDvrh18xs8/gZGDn5ZKqk753gEYBX8IDKAHZ55hR6
D07uMfyGuq9S6RQ9hxKpJCkV5ZkejlxCzdS0PHJhPE6/SDiUP958IuPTfg7FCmXt
PLmjYvUW0e7e7zANHwSAaYm5MjkOkg9//FuA6osnO6kQSLmOp/PGg2zCSPwXN2sE
M9ng6veinbxW6UUaLewv3KJwsK4iLE2XllJED2okVD6fKcg0g6vSZFqGtuG+YDmc
TWDACva0rRZzCMFB5CgkA9nyPc/9Zofk9NeC9pUOx2DfmFy10XkgsVAfTZBLXggc
PTVdqQ4oYVlIyz8UofcpAjNeAbLptzc3XPF57H0YxvzE7MD7NnEFPrLlzxYK061d
+CZxYaRs3tym+kmYd13CjASYz2yiXGN4dBr2zszPfJI5p1UEo3YF8zu/wDuvKRI5
Tkz6u4Fu3adOKK4YhAVKFBrtR5lHmV5LezTTbVllcXYSG6Ie+m65Fo7yom4KWeig
P+DxLIv8LlM=
=17Px
-----END PGP SIGNATURE-----

--Sig_/Asj7==5Jq05koh.ZXFSp8Jd--
