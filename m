From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] mdadm: handle super == NULL case in avail_size1
Date: Fri, 01 Sep 2017 09:36:23 +1000
Message-ID: <87ziafe2dk.fsf@notabene.neil.brown.name>
References: <20170831173751.2910909-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170831173751.2910909-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 31 2017, Song Liu wrote:

> Summary:
>
> Handling super =3D=3D NULL case in avail_size1() was removed a while
> back. However, it is still useful in the following stack:
>
> avail_size1() with st->sb =3D=3D NULL
> array_try_spare() with st =3D=3D NULL
> try_spare() with st =3D=3D NULL
> Incremental() with st =3D=3D NULL

I assume you mean "st->sb =3D=3D NULL" in each case here?  What you have
written doesn't make sense.


>
> This patch adds the handling of super =3D=3D NULL back to avail_size1().

I doubt this is the best thing to do.
If we don't have st->sb, calling avail_size doesn't make any sense.
Maybe we should be calling validate_geometry.

NeilBrown


>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  super1.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/super1.c b/super1.c
> index f6a1045..5e8d967 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2340,7 +2340,9 @@ static __u64 avail_size1(struct supertype *st, __u6=
4 devsize,
>  	if (devsize < 24)
>  		return 0;
>=20=20
> -	if (__le32_to_cpu(super->feature_map) & MD_FEATURE_BITMAP_OFFSET) {
> +	if (!super)
> +		bmspace =3D choose_bm_space(devsize);
> +	else if (__le32_to_cpu(super->feature_map) & MD_FEATURE_BITMAP_OFFSET) {
>  		/* hot-add. allow for actual size of bitmap */
>  		struct bitmap_super_s *bsb;
>  		bsb =3D (struct bitmap_super_s *)(((char*)super)+MAX_SB_SIZE);
> @@ -2350,7 +2352,7 @@ static __u64 avail_size1(struct supertype *st, __u6=
4 devsize,
>  	}
>=20=20
>  	/* Allow space for bad block log */
> -	if (super->bblog_size)
> +	if (super && super->bblog_size)
>  		bbspace =3D __le16_to_cpu(super->bblog_size);
>=20=20
>  	if (st->minor_version < 0)
> --=20
> 2.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmonXgACgkQOeye3VZi
gblI2Q//Scu1V1ElHY+MdU0UESqB3f3letMbJKDIazey1obYNwDk0myx3N1KZcLs
4iwPSP0IOsERHwtlr/4wpQx64QMsFWXYGofsmHYFCb3KjisxdS+gV64Dgfr9LOkB
yH7kLT2NDwXFC7u4XxVRSCJCeO9WwzTQPE4bcNRoykgXdjhYOiANvmaJ/gmHPEBf
5c/dxTcyvP07dKvsZytp8mMXBW9gLRphPMNJRTTnVhUFTYTs2a+Luc2ds+QslCrW
/hB//z65/2Br7wdsTIGXDr+fv2vs/3jMmusUzLiW+T/vfeIIK4YQ0x441W74YfMn
MKLWoD3xkT1eTEJkzdokDKRVWC5EEvdJsV78vPPZA6UZlIfNpv0MT4GGbItpPnfM
CT90vrzIIwq10X+yvNWlwkyNTkLbQyKutCcLjIId8OfSjHIuHzNmn9vjlra9jWwc
xWGFVNQTkTgR7NSZlJoRiqBB/iwglk/aPGwYLPe83No/OZm4fbKnEgG3BMl8aJWA
E4nZ8fNCadWZk75u6goOOp4o/Sw8dyZ28oEMXSKjhApMXVDq1v3i9IzBRSHQyWYk
+kXCC/SkfupfRj83vUOtz85jimnd0do7+0D+BWcR0dZ/6PFNx7U+dJFSiaDt/dYl
9mwjsox/vxf9+4vhtX56v5LlfPykSfRrBPdd2RxuSoETG1q4BmQ=
=WbN5
-----END PGP SIGNATURE-----
--=-=-=--
