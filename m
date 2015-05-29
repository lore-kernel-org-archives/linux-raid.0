From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/4] raid5: ignore released_stripes check
Date: Fri, 29 May 2015 15:16:58 +1000
Message-ID: <20150529151658.4f5ac5a0@notabene.brown>
References: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
	<a1dc1deca50ae3e6cf45b94e75df3a0271a43ecd.1432859513.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6zg20lH0TFKdPGBTh_cXj1p"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a1dc1deca50ae3e6cf45b94e75df3a0271a43ecd.1432859513.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6zg20lH0TFKdPGBTh_cXj1p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 May 2015 17:33:47 -0700 Shaohua Li <shli@fb.com> wrote:

> conf->released_stripes list ins't always related if there is free
> stripes pending. active stripes can be in the list too.
>=20
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0cceb71..67626f3 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -673,8 +673,8 @@ get_active_stripe(struct r5conf *conf, sector_t secto=
r,
>  		if (!sh) {
>  			if (!test_bit(R5_INACTIVE_BLOCKED, &conf->cache_state)) {
>  				sh =3D get_free_stripe(conf, hash);
> -				if (!sh && llist_empty(&conf->released_stripes) &&
> -				    !test_bit(R5_DID_ALLOC, &conf->cache_state)) {
> +				if (!sh && !test_bit(R5_DID_ALLOC,
> +				    &conf->cache_state)) {
>  					set_bit(R5_ALLOC_MORE,
>  						&conf->cache_state);
>  					md_wakeup_thread(conf->mddev->thread);

Yes, I think I agree with this.=20
I don't clearly remember why I put that test in, but it is certainly hard to
justify it.
Even if there are free stripes in ->released_stripes, they were in use very
recently, so counting them as still in use is easily justified.

BTW, is an open parenthesis (or bracket or brace) is not the last character
in the line, then everything from there until the close must be to the right
of the open.  So I indented the "&conf->cache_state)) {" line some more.

Thanks,
NeilBrown

--Sig_/6zg20lH0TFKdPGBTh_cXj1p
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWf2Sznsnt1WYoG5AQK2hBAAjT6C9e1xe9IidoQoJlUHIOx8NKh1ocOd
gl15cDNeFM8q2Vktd0H5+XnVM6ex2zwsSU6J9V1tWNC4wLfjFHnOpBDOEF/YQuVl
a6PyFVVCvl6Ano9MomU8/chnSXONW6mHeiQrUlIdQRf16eySOOYg27+kz/VDoI4o
4dlShNi1Vy81PtgTaCRsqicS3IGhutw6WCd1li6IdNTsTb7/OPfo68BtZkwRbdQc
VqsIVEjIU+4DUgPoZYahr2bVrl9OoMChqVBbE1yVNLadvcLmXZnbEpyzB2DAkH58
JXRttsc0nPJMMjWRfjpOW6c9WiQrjs6QIfW0FL0XlZNLctMzVuOnbW4iwfEs2oRo
IXEx0kXJ5rLSp/yss4SAKJfcFo/tDRl5CHpTgbpXIG6KPiQbZ0IgIOmAO7fkhlcS
PgIp6/1nueuJ2c9wJAXmJbT9bUs183ls7SxX4sYj20VFIA+yfxLKkRlEO/Ngq4Rq
BVQ4ly8+OsKpYeu8kXtKOdryiLxlixOHuWNM/5dMsIbpnI9QMVvDiEwOnhhzAk0b
xTfR0zagWcuRuF+LViq8yg/qdb5o/+BWKLnmGyRi1a5fQa1uCG0WQnxJK05P3YPq
RUdKk5ToZCLjvC3n3KZL+B4TUVRKwfnCoKNu9C1uH1WJbhlqIZqve0Kk3+nXZDsY
XXftb9+ErgA=
=PeXb
-----END PGP SIGNATURE-----

--Sig_/6zg20lH0TFKdPGBTh_cXj1p--
