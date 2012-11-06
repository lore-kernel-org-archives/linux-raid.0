From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md:Avoid write invalid address if read_seqretry
 returned true.
Date: Tue, 6 Nov 2012 21:14:55 +1100
Message-ID: <20121106211455.417b35f1@notabene.brown>
References: <201211061712569914353@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hGG83FWbdaHyUJalTjTuIyc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201211061712569914353@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, zhuwenfeng <zhuwenfeng@kedacom.com>
List-Id: linux-raid.ids

--Sig_/hGG83FWbdaHyUJalTjTuIyc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Nov 2012 17:13:00 +0800 majianpeng <majianpeng@gmail.com> wrote:

> If read_seqretry returned true and bbp was changed, it will write
> invalid address which can cause some serious problem.
>=20
> This bug was introduced by commit v3.0-rc7-130-g2699b67.
> So fix is suitable for 3.0.y thru 3.6.y.
>=20
> Reported-by: zhuwenfeng@kedacom.com
> Tested-by: zhuwenfeng@kedacom.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9ab768a..d63aa78 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1805,15 +1805,15 @@ static void super_1_sync(struct mddev *mddev, str=
uct md_rdev *rdev)
>  		md_error(mddev, rdev);
>  	else {
>  		struct badblocks *bb =3D &rdev->badblocks;
> -		u64 *bbp =3D (u64 *)page_address(rdev->bb_page);
>  		u64 *p =3D bb->page;
>  		sb->feature_map |=3D cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
>  		if (bb->changed) {
>  			unsigned seq;
> +			u64 *bbp;
> =20
>  retry:
> +			bbp =3D (u64 *)page_address(rdev->bb_page);
>  			seq =3D read_seqbegin(&bb->lock);
> -
>  			memset(bbp, 0xff, PAGE_SIZE);
> =20
>  			for (i =3D 0 ; i < bb->count ; i++) {


No.
The contents of the page might change, but it is always the same page, so it
always has the same address, so "bbp" is guaranteed to be stable.

NeilBrown

--Sig_/hGG83FWbdaHyUJalTjTuIyc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJjjHznsnt1WYoG5AQLcDg//eGW0an3zQrYH7r61A7zcZvD5e59lySLg
I9FfKeM+WT5NnWAzXgplk69it1aEdJaUvltOmS4F0uOKSZrEjlne/EmGf30ZDMv0
YnOMD9z5H++uVhQ1aY4u9W2WbAuK6Vg+QQ6Al2THyYqFSVvjCIh/RuDW/LL14Onb
NcU0nlHxYnlphNNj9Tk3I8LjQvNlIBbDG+Gd30LUUEjczyXxurzsC4D5LRM7fhRc
DH/ioj/W860lXND/9WBgBOZI4vU1sysOIUtWf6EghT92/IQTsqLytbdaYYxs6OK/
hdpc21AtpofcyDnJXORHCafLQlQ6WxpG9+X4J11OK8qb2r76LKM4o9ssEUkD9hXr
/PKvQxL9A2Z8bfk/Soey6ngB/Q+Mmlt4UVfoj8jndkd31Jvw5onB5UzK6fxgx1bh
iBjPWzJJAtYDeiwbf8vt1MxVwstbKqecuNwouL1kYpjWoVLPb4IgitV14cxdr6+f
FB6XlV1ousyOAScf1dUSG7MdsCzSnz2SaUZYBGV1FS3YcCpangSb/L4tHd0Kawd2
Ujwy43AX5UPsBgAvS4ldnnZ1+Jcn1zL8NlLmyCJWzOAchIERqEBKPgAGxDwGm0QS
gxGnpjRGWVWWq8lmtFBjEUntvLoO3MvK/D8e/VH4C+s3uR8GyhOAURLsHKfjvcZV
dVu3Ze1x+MY=
=CX5j
-----END PGP SIGNATURE-----

--Sig_/hGG83FWbdaHyUJalTjTuIyc--
