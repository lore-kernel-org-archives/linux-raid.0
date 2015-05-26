From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix reversed logic in drivers/md/md.c
Date: Tue, 26 May 2015 14:58:31 +1000
Message-ID: <20150526145831.2663add8@notabene.brown>
References: <20150526043624.GA24890@athena>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6jFtlRSPSt+brBEl18JEUyQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150526043624.GA24890@athena>
Sender: linux-raid-owner@vger.kernel.org
To: Eddie Kovsky <ewk@edkovsky.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6jFtlRSPSt+brBEl18JEUyQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 25 May 2015 22:36:24 -0600 Eddie Kovsky <ewk@edkovsky.org> wrote:

> Fixes the following compiler warning in next-20150525 using gcc 5.1.0:
>=20
> drivers/md/md.c: In function =E2=80=98update_array_info=E2=80=99:
> drivers/md/md.c:6394:26: warning: logical not is only applied to the
> left hand side of comparison [-Wlogical-not-parentheses]
>       !mddev->persistent  !=3D info->not_persistent||
>=20
> Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index eb27b2a74492..b0f98b5b8985 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6391,7 +6391,7 @@ static int update_array_info(struct mddev *mddev, m=
du_array_info_t *info)
>  	    mddev->ctime         !=3D info->ctime         ||
>  	    mddev->level         !=3D info->level         ||
>  /*	    mddev->layout        !=3D info->layout        || */
> -	    !mddev->persistent	 !=3D info->not_persistent||
> +	    mddev->persistent	 =3D=3D info->not_persistent||
>  	    mddev->chunk_sectors !=3D info->chunk_size >> 9 ||
>  	    /* ignore bottom 8 bits of state, and allow SB_BITMAP_PRESENT to ch=
ange */
>  	    ((state^info->state) & 0xfffffe00)

Thanks... but I'd rather gcc was fixed. :-(  There is nothing wrong with the
code and it does not deserve a warning.

I really like the column of "!=3D" and I don't want to change that.

I *might* be able to access
    (!mddev->persistent)   !=3D  info->not_persistent

Thanks,
NeilBrown

--Sig_/6jFtlRSPSt+brBEl18JEUyQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWP9eDnsnt1WYoG5AQIm2w/6AlCoXP0HrHEE1QOFvEn7WOFwpFl8wQFc
BQ1R/ulCT1RAXEvljpFCP88Q8ULw1rFzCSqgVy9ACvhmd6RVtAg0E4OK4xcRkmHV
940wSIhJNJotdxqy96BXvQc+nlC/sO/gCJLWHkG9+FkZX3/Fr0N4SVVPW2mfWK94
hVlSo+1PA9mIpR2Zhq8P9K+eNDugpeLAnkMi+6q4/TvBQcZUrh8SUkd1wEPCmQgH
JfZCwi8OkoT/exuAnp1p1pwcC0W/i1eClk5pxUkec4CCAA+22DfP5MclQPt0m9nr
TVECtiIu4XZE4cbNvRnUxjSBpZsqfp4sm1f17LfNjt0znK1D+a4Q+X+1axpEBFZm
GN3yLpysDVslbShiZTMaW33pezQ+75YEsD06rlT4BQtNj6Nxa2o7Q4sNLhUQ1xOW
3O3P4GgUNqR7LzumuLG1EOiHBydWibIJgecXDB8i9DxpZOPvf3DGRJMlumq93pdw
JpG4rzswYI25Gr5CN32QunrPBm2464XPV+rOJGkj6cqBpwLimFGzI6luOZi7dH7u
KR+BTAYIBbRFHRqkwLZ+164qRPcmxgf6doas1C/lnPABLOdGzCyKE5sgFF0x9GmZ
lOaQbk5HMh28W1kaAWMY+xNfm7iyTQPvAfV4/HDq9F92fKFNA6iZFA65ZKgm5QlW
cOVNQKY2mJs=
=5jdY
-----END PGP SIGNATURE-----

--Sig_/6jFtlRSPSt+brBEl18JEUyQ--
