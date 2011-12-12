From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: FIX: Limit migration record operation by disk
 slot not by index
Date: Mon, 12 Dec 2011 16:17:05 +1100
Message-ID: <20111212161705.1a13cdbc@notabene.brown>
References: <20111208084655.7455.66462.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3sOHRehgDKA.8PsAz2KiPS0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111208084655.7455.66462.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/3sOHRehgDKA.8PsAz2KiPS0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 08 Dec 2011 09:46:56 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> imsm should store migration record in to 2 first disks in array.
> This should be evaluated based on disk slots, not on disks index.
> It is not guaranteed that indexes are equal to slots.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
...

> @@ -2200,11 +2245,37 @@ static int write_imsm_migr_rec(struct supertype *=
st)
>  	struct dl *sd;
>  	int len;
>  	struct imsm_update_general_migration_checkpoint *u;
> +	struct imsm_dev *dev;
> +	struct imsm_map *map =3D NULL;
> +
> +	/* find map under migration */
> +	dev =3D imsm_get_device_during_migration(super);
> +	/* if no migration, write buffer anyway to clear migr_record
> +	 * on disk based on first available device
> +	*/
> +	if (dev =3D=3D NULL) {
> +		int vol;
> +
> +		if (super->current_vol >=3D 0)
> +			vol =3D super->current_vol;
> +		else
> +			vol =3D 0;
> +		dev =3D get_imsm_dev(super, super->current_vol);
> +	}

'vol' is unused here.  Should it be:
                dev =3D get_imsm_dev(super, vol);
??

NeilBrown



--Sig_/3sOHRehgDKA.8PsAz2KiPS0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuWOUTnsnt1WYoG5AQLjiBAAnWjXzLg6ldAcnWXEDqZNWM3Js9201Rud
6Xn5a5+pwUliPtl6HfKYw6+3M1QkmBrTFeP4qek9r9aM34yXtFc11HzKt6wC0J3H
uZpLMTdaqd9zH2FinhxkHFUiwK9EL+XIIrFT7r0GwPKyxlrrSHizNku7XuHdVejM
VkqveL2S1NJyiookERaccVVKto8A8X5iVwS97EFgJsJPD876H4B8Gqt7gu1XPhke
r/cYeHVGtN9dI7Q+0eu7v2CLevTFT7KffsQjqLqCt7ataTwx2XssxCWdmQqNHIfM
IDhuLPPW3ISrN8eAQVjIakUE2WNBTEdeOgBD7kgOMcXT5T4avUkuMabXeH0hQEgY
LdnIDKeAcGLWDL/E35YwU9y/1FFCrDFbwlqGfwPsXCQin2M8RPHzKMv5JTCDJTHG
pJyQIYX5KQBWzffcyikIf3h4WQuLQ4THIq67hXwo+PiX1cs5PBmoWaoiVSJ2W/h9
ScEf+94X1gJc4d764CQ8UFlIKhSahmV0HjKobpXZec5Dd8q+YfwAXTfPl5AHLnjX
OhouHwWHCa6qOcn6TIvQ77XJmvenH5SgpNzZFxthFoTcMYAWGkgcQMWpjiQErvNS
jYT5p+Bn+D52SROPB05UmAjF1jisyE9mkibMM2bcwRW0LTP7Khbbmbtd6zmubjnf
/tEI//8jyG4=
=SSz2
-----END PGP SIGNATURE-----

--Sig_/3sOHRehgDKA.8PsAz2KiPS0--
