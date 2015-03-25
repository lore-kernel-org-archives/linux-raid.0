From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix bitmap offset calculations
Date: Wed, 25 Mar 2015 13:15:02 +1100
Message-ID: <20150325131502.1a947967@notabene.brown>
References: <20150324162905.GA16104@shrek.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/hKTVTUPDGT7aUlpRtHi6KM6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150324162905.GA16104@shrek.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hKTVTUPDGT7aUlpRtHi6KM6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Mar 2015 11:29:05 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wro=
te:

> The calculations of bitmap offset is incorrect with respect to bits to by=
tes
> conversion.
>=20
> Also, remove an irrelevant duplicate message.
>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index ac79fef..e98db04 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -575,7 +575,9 @@ re_read:
> =20
>  		sector_div(bm_blocks,
>  			   bitmap->mddev->bitmap_info.chunksize >> 9);
> -		bm_blocks =3D bm_blocks << 3;
> +		/* bits to bytes */
> +		bm_blocks =3D ((bm_blocks+7) >> 3) + sizeof(bitmap_super_t);
> +		/* to 4k blocks */
>  		bm_blocks =3D DIV_ROUND_UP_SECTOR_T(bm_blocks, 4096);
>  		bitmap->mddev->bitmap_info.offset +=3D bitmap->cluster_slot * (bm_bloc=
ks << 3);
>  		pr_info("%s:%d bm slot: %d offset: %llu\n", __func__, __LINE__,
> @@ -672,9 +674,6 @@ out:
>  			goto out_no_sb;
>  		}
>  		bitmap->cluster_slot =3D md_cluster_ops->slot_number(bitmap->mddev);
> -		pr_info("%s:%d bm slot: %d offset: %llu\n", __func__, __LINE__,
> -			bitmap->cluster_slot,
> -			(unsigned long long)bitmap->mddev->bitmap_info.offset);
>  		goto re_read;
>  	}
> =20

Applied, thanks.

NeilBrown

--Sig_/hKTVTUPDGT7aUlpRtHi6KM6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVRIaJjnsnt1WYoG5AQImyw/9HMtypnmKdnskHOf8w0xcHcZRK5K0vtDf
q4kDKpew37SDSTmppmuqty54qyAccDK96394nJfoMSKvnsmUJ7NwjUZYnk6/qF6O
KbrU1Dudg6V2AHlr4aVkub2QHy1ajFPJbdExBZMVgOUx4u3uqZ1AG3yjaeQP6B36
16vkLvWlcuMvP3vl7J1TKE/MO+jC7P0EsUHrxEHPOJAU5NlTZPaY9TfXfGwF7J/B
sKmfyXJbq4/PM+h7uZEIGmJf4FXQUl/kO+RB0c8CmIQIhF7uLpj8sxO+gW7Kz4yX
3ovjPKCSXAjnnGRAuNQbNMzcCfn5VhN5pAZGhullmETxLc1sfgk1wGvXhqSBwORK
wm76jccEBgv2+oyhZOsBWD7cci6V8MD38cuZTTUx4VKpAO/16R26OBHg/UrMm97i
C5QvhpbZWe3oynx9edJ52XVr5jZXQvBgIEYMSs6mmab1NOvIMfCf4y5QDjw2INXi
ZtVQZiXyOkFPKCMMGa2XRIrfvp/OUC9WVn+p/5nS3mjqaHG0ud5ChBh13xEXY6JC
xw3AXm8AbKqxgtCXaHWY4e5/tDRF3K0cRXYI4aLP6RKbKnvMGVAZ2LCX4g+XpiVe
BUIEaQl8iDBsOPzuhodD23scVeViim103GpRWXjM2XtwmMfHJTHbuFlfaLwZupNW
Nl//1iPIG3k=
=fB8G
-----END PGP SIGNATURE-----

--Sig_/hKTVTUPDGT7aUlpRtHi6KM6--
