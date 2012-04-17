From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid10:Memleak fix if allocate rep1_bio failed in
 function want_replacement().
Date: Tue, 17 Apr 2012 13:09:38 +1000
Message-ID: <20120417130938.248d885a@notabene.brown>
References: <201204161924086710486@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/etbjINL.vfDcjzyU=r3fgmG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201204161924086710486@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/etbjINL.vfDcjzyU=r3fgmG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Apr 2012 19:24:13 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From cb391c87d24a32b211d9f0a9df942987bf8e0ac4 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Mon, 16 Apr 2012 19:19:53 +0800
> Subject: [PATCH] md/raid10:Memleak fix if allocate rep1_bio failed in
>  function want_replacement().
>  Reported by kmemleak.

Please try to make the description a bit easier to read.
The first line should be a brief summary of the problem or fix.

Details come afterwards.

I have change it to the following and applied.

Thanks,
NeilBrown

    md/raid10: Fix memleak in r10buf_pool_alloc
   =20
    If the allocation of rep1_bio fails, we currently don't free the 'bio'
    of the same dev.
   =20
    Reported by kmemleak.
   =20
    Signed-off-by: majianpeng <majianpeng@gmail.com>
    Signed-off-by: NeilBrown <neilb@suse.de>



>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid10.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index c8dbb84..19e9af1 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -165,10 +165,11 @@ out_free_pages:
>  	while (j--)
>  		for (i =3D 0; i < RESYNC_PAGES ; i++)
>  			safe_put_page(r10_bio->devs[j].bio->bi_io_vec[i].bv_page);
> -	j =3D -1;
> +	j =3D 0;
>  out_free_bio:
> -	while (++j < nalloc) {
> -		bio_put(r10_bio->devs[j].bio);
> +	for ( ; j < nalloc; j++) {
> +		if (r10_bio->devs[j].bio)
> +			bio_put(r10_bio->devs[j].bio);
>  		if (r10_bio->devs[j].repl_bio)
>  			bio_put(r10_bio->devs[j].repl_bio);
>  	}


--Sig_/etbjINL.vfDcjzyU=r3fgmG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4ze8jnsnt1WYoG5AQL6Qw/+MbQ5UrSDtuD1klhw+/taL10mtTQdBD80
U3cquHXnae4EbxWnnAj+nV4WkzO9wJ6ppjNM1J4pWW9/400RdesHOdk/TLew2NEI
jgSLYuypQHYoYgbD55DdRyWPuTuDvXcBhXpwHYUoWkQQugOAm0gtrSX7C/X7la47
3ZrOkUTrjsnOOy76r/vQop2pJPPt8TNf2uBMFbnOUg0B6AChXkH4guys5x3CRyfy
U7NcNC0+8yGr6O5OaNCF5KM/pqZMj0BXvydgAnCZM3D8IuBqEldbPd/WA5lOmuAc
Whw7PrGDulSK9foeqUozHstLLj+4JIBs8CC46DPmhl8hHbaEUrJhMLtFYPk1Kizq
F2ByanC9fEVp7Z3DiJTO6Zx9uLIZpHcPB5Www1EFOgCxP+iSNM5JBERPXBKkkAKu
fKX358yUjIBUVdHO9iXlw69IG8OLw0ib2aqt/YGVmpE/zybl10GKlLbzG5dxz7dK
I2bnTjyG3iZhrIjwZbmGRBlTvfSUE/4c4DURSxfb4r/sMKPd7LkvyWyVJpWIQYPE
YWBmPeLMIs40WW9YZyxVSn+rG/kWB74IpCjhntXNrA3fQ9ZAxMuHtrHgTRgA0UL/
o+ak9kLwOzDAMYWeqWhcGt379Wp9xuZaMYNqc7OxMDS30ib6ahyx7bIOkYp6IEmY
9/9kR88jrTo=
=UZPr
-----END PGP SIGNATURE-----

--Sig_/etbjINL.vfDcjzyU=r3fgmG--
