From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 07/27] DDF: find_vdcr: account for secondary RAID level
Date: Mon, 8 Jul 2013 16:16:52 +1000
Message-ID: <20130708161652.11d1c47f@notabene.brown>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
	<1372883287-8859-8-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Dn/=tEtGHyk=zL8=4MrJApA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-8-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Dn/=tEtGHyk=zL8=4MrJApA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Jul 2013 22:27:47 +0200 mwilck@arcor.de wrote:

> If secondary RAID level is taken into account, translation between
> the md RAID member (raid_disk) and the index of a physical disk
> in a BVD becomes more complex.
>=20
> Also, take into account that the member list can have unused entries
> (this is independent of secondary RAID level).
>=20
> Adapt usage of find_vdcr() accordingly
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  super-ddf.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++--=
------
>  1 files changed, 87 insertions(+), 13 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index ae24bb9..c448bff 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -1441,13 +1441,76 @@ static int match_home_ddf(struct supertype *st, c=
har *homehost)
>  }
> =20
>  #ifndef MDASSEMBLE
> -static struct vd_config *find_vdcr(struct ddf_super *ddf, unsigned int i=
nst)
> +static int find_index_in_bvd(const struct ddf_super *ddf,
> +			     const struct vd_config *conf, unsigned int n,
> +			     unsigned int *n_bvd)
> +{
> +	/*
> +	 * Find the index of the n-th valid physical disk in this BVD
> +	 */
> +	unsigned int i, j;
> +	for (i =3D 0, j =3D 0; i < ddf->mppe &&
> +		     j < __be16_to_cpu(conf->prim_elmnt_count); i++) {
> +		if (conf->phys_refnum[i] !=3D 0xffffffff) {

Should that 0xffffffff be DDF_NOTFOUND?

(I glazed over reading the rest of this patch .. sorry.  Maybe I'll try aga=
in
another day)

NeilBrown


> +			if (n =3D=3D j) {
> +				*n_bvd =3D i;
> +				return 1;
> +			}
> +			j++;
> +		}
> +	}
> +	dprintf("%s: couldn't find BVD member %u (total %u)\n",
> +		__func__, n, __be16_to_cpu(conf->prim_elmnt_count));
> +	return 0;
> +}
> +
> +static struct vd_config *find_vdcr(struct ddf_super *ddf, unsigned int i=
nst,
> +				   unsigned int n,
> +				   unsigned int *n_bvd, struct vcl **vcl)
>  {
>  	struct vcl *v;
> =20
> -	for (v =3D ddf->conflist; v; v =3D v->next)
> -		if (inst =3D=3D v->vcnum)
> -			return &v->conf;
> +	for (v =3D ddf->conflist; v; v =3D v->next) {
> +		unsigned int nsec, ibvd;
> +		struct vd_config *conf;
> +		if (inst !=3D v->vcnum)
> +			continue;
> +		conf =3D &v->conf;
> +		if (conf->sec_elmnt_count =3D=3D 1) {
> +			if (find_index_in_bvd(ddf, conf, n, n_bvd)) {
> +				*vcl =3D v;
> +				return conf;
> +			} else
> +				goto bad;
> +		}
> +		if (v->other_bvds =3D=3D NULL) {
> +			pr_err("%s: BUG: other_bvds is NULL, nsec=3D%u\n",
> +			       __func__, conf->sec_elmnt_count);
> +			goto bad;
> +		}
> +		nsec =3D n / __be16_to_cpu(conf->prim_elmnt_count);
> +		if (conf->sec_elmnt_seq !=3D nsec) {
> +			for (ibvd =3D 1; ibvd < conf->sec_elmnt_count; ibvd++) {
> +				if (v->other_bvds[ibvd-1] =3D=3D NULL)
> +					continue;
> +				if (v->other_bvds[ibvd-1]->sec_elmnt_seq
> +				    =3D=3D nsec)
> +					break;
> +			}
> +			if (ibvd =3D=3D conf->sec_elmnt_count)
> +				goto bad;
> +			conf =3D v->other_bvds[ibvd-1];
> +		}
> +		if (!find_index_in_bvd(ddf, conf,
> +				       n - nsec*conf->sec_elmnt_count, n_bvd))
> +			goto bad;
> +		dprintf("%s: found disk %u as member %u in bvd %d of array %u\n"
> +			, __func__, n, *n_bvd, ibvd-1, inst);
> +		*vcl =3D v;
> +		return conf;
> +	}
> +bad:
> +	pr_err("%s: Could't find disk %d in array %u\n", __func__, n, inst);
>  	return NULL;
>  }
>  #endif
> @@ -3769,9 +3832,11 @@ static int ddf_set_array_state(struct active_array=
 *a, int consistent)
>  static void ddf_set_disk(struct active_array *a, int n, int state)
>  {
>  	struct ddf_super *ddf =3D a->container->sb;
> -	unsigned int inst =3D a->info.container_member;
> -	struct vd_config *vc =3D find_vdcr(ddf, inst);
> -	int pd =3D find_phys(ddf, vc->phys_refnum[n]);
> +	unsigned int inst =3D a->info.container_member, n_bvd;
> +	struct vcl *vcl;
> +	struct vd_config *vc =3D find_vdcr(ddf, inst, (unsigned int)n,
> +					 &n_bvd, &vcl);
> +	int pd;
>  	int i, st, working;
>  	struct mdinfo *mdi;
>  	struct dl *dl;
> @@ -3796,15 +3861,21 @@ static void ddf_set_disk(struct active_array *a, =
int n, int state)
>  	if (!dl)
>  		return;
> =20
> +	pd =3D find_phys(ddf, vc->phys_refnum[n_bvd]);
>  	if (pd < 0 || pd !=3D dl->pdnum) {
>  		/* disk doesn't currently exist or has changed.
>  		 * If it is now in_sync, insert it. */
> +		dprintf("%s: phys disk not found for %d: %d/%d ref %08x\n",
> +			__func__, dl->pdnum, dl->major, dl->minor,
> +			dl->disk.refnum);
> +		dprintf("%s: array %u disk %u ref %08x pd %d\n",
> +			__func__, inst, n_bvd, vc->phys_refnum[n_bvd], pd);
>  		if ((state & DS_INSYNC) && ! (state & DS_FAULTY)) {
> -			struct vcl *vcl;
> -			pd =3D dl->pdnum;
> -			vc->phys_refnum[n] =3D dl->disk.refnum;
> -			vcl =3D container_of(vc, struct vcl, conf);
> -			vcl->lba_offset[n] =3D mdi->data_offset;
> +			__u64 *lba_offset;
> +			pd =3D dl->pdnum; /* FIXME: is this really correct ? */
> +			vc->phys_refnum[n_bvd] =3D dl->disk.refnum;
> +			lba_offset =3D (__u64 *)&vc->phys_refnum[ddf->mppe];
> +			lba_offset[n_bvd] =3D mdi->data_offset;
>  			ddf->phys->entries[pd].type &=3D
>  				~__cpu_to_be16(DDF_Global_Spare);
>  			ddf->phys->entries[pd].type |=3D
> @@ -4187,8 +4258,10 @@ static struct mdinfo *ddf_activate_spare(struct ac=
tive_array *a,
>  	struct metadata_update *mu;
>  	struct dl *dl;
>  	int i;
> +	struct vcl *vcl;
>  	struct vd_config *vc;
>  	__u64 *lba;
> +	unsigned int n_bvd;
> =20
>  	for (d =3D a->info.devs ; d ; d =3D d->next) {
>  		if ((d->curr_state & DS_FAULTY) &&
> @@ -4353,7 +4426,8 @@ static struct mdinfo *ddf_activate_spare(struct act=
ive_array *a,
>  	mu->space =3D NULL;
>  	mu->space_list =3D NULL;
>  	mu->next =3D *updates;
> -	vc =3D find_vdcr(ddf, a->info.container_member);
> +	vc =3D find_vdcr(ddf, a->info.container_member, di->disk.raid_disk,
> +		       &n_bvd, &vcl);
>  	memcpy(mu->buf, vc, ddf->conf_rec_len * 512);
> =20
>  	vc =3D (struct vd_config*)mu->buf;


--Sig_/Dn/=tEtGHyk=zL8=4MrJApA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdpZVDnsnt1WYoG5AQIW8A//QVNWRvBZqT8+Gkmy5mxn9eW3XZExh0M1
VnuPwbV98E4kiYwDASN6NMiM4EO5ad54SCpTltKISdPJ1ly4tcee7R+QPsRNN9+6
ayLf9QdeD0t2rDnFaUyIkVdSMqIJddKQhPAQw7rXXuDGHbf/d4iyhQqLcw84N2gn
lh17bungUnaOiUQbzXy54oGDV+kHwTfRiomUEA9DvBwayFctNm8cZC+H2bELB4rG
MBJyIsY2ouu9SsNDQZvwvurJAqfsQVuMBAZeE08csvY8tg6bVwhk7jOfzzO7Ml9P
KPCxflf7ehf+qMJLs9i9Qioi3Z9aXgGOg7h8barOXS5rRWZ0wtYJUfb/ekYLnBNR
IRe++lKpuvM8ahogdI2BneC0piDCC6CoT2qQx3JCEEgHVCCS4cbpJKYQaY/2/x7n
pvjQQKIi262V1dBnKvriwEJO/FfxduMapm09tNZJLrveUcVcuRoHem5Sxo7Gvigq
txE4zBLJkWjCjQE7xbA9bV91kuvhVpCQ+scKXaDu+yRJ3hD8I0zdIaS/+dEMGfuF
//KDlnhlYDfGqM8VEYKNaZuiDnxPEWgTvHIP9ePYyGeH+lbtejgNt/xl6u5HjuCU
MRSB61lvQ+SqBCosUDM6OKwc4Zc5MWEp7zOdwr4dpj0J354FwdZ7MtPCAUUXwW71
eVMAaw6c1bE=
=9Vsf
-----END PGP SIGNATURE-----

--Sig_/Dn/=tEtGHyk=zL8=4MrJApA--
