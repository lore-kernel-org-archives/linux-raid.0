From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH md] recover_bitmaps() can be static
Date: Wed, 4 Mar 2015 13:41:44 +1100
Message-ID: <20150304134144.3d2687dc@notabene.brown>
References: <201502280727.kOhvF4kI%fengguang.wu@intel.com>
	<20150227230437.GA47128@snb>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/kA/LNMIwtbbZqZl+D6h3nkk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150227230437.GA47128@snb>
Sender: linux-raid-owner@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>, kbuild-all@01.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kA/LNMIwtbbZqZl+D6h3nkk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 28 Feb 2015 07:04:37 +0800 kbuild test robot <fengguang.wu@intel.co=
m>
wrote:

> drivers/md/md-cluster.c:190:6: sparse: symbol 'recover_bitmaps' was not d=
eclared. Should it be static?
>=20
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  md-cluster.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 1f82d0d..c71217a 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -187,7 +187,7 @@ out:
>  	return s;
>  }
> =20
> -void recover_bitmaps(struct md_thread *thread)
> +static void recover_bitmaps(struct md_thread *thread)
>  {
>  	struct mddev *mddev =3D thread->mddev;
>  	struct md_cluster_info *cinfo =3D mddev->cluster_info;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Applied, thanks!

NeilBrown

--Sig_/kA/LNMIwtbbZqZl+D6h3nkk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVPZw6Dnsnt1WYoG5AQLBYw//bgHB1kZiG02f7K/T/jrBESuARAFNpcC1
ViKblGsHvU2tycvsQBJjPzXEVfWK1sci1QwFX2/ZIAkUw69C/e7S8+t8qz9mCUdu
UN6yUJ3/nLmwps/fDcbl/y7IU09Y760u98nql5u8GTfN5mTEXcqrcU/SmSZwxD4W
ZuG2EnTDx7PR21EI+hJ4Wj1DtQXrDoA3lYrYsxDodORoEURxOS9jK27c/forgfJw
QrYmsOd8UnAXpv2NwWjvNWm+5XQQjUZTTuU7Pa/ZvcowIW7SdnRr4ff5l1QKhF28
wef3SGdMTMLX6iitwihIIEkga6GneXfdXsbTvtq5mkk4BvGrb8qMpihUCpvcGfDw
d6YocWU4bEdLvYT9sUW4yz6pLvrza+aYuKsJUr1Y4I+hqDj/WBgTSlKyFOe23JzC
K1fRSZYq9ZhT0iMGG7nX2QoSU0YEgqhgS/86DrQTh5ga0bo7PPBvqmtr8o+c8cfZ
YHMw1rSQDcZMjMoQFO9eiAxd1Q5jM7geGsQlNsy1Sw81vQF3TSEB9nqMNvIi/mYL
hnFEzEvuh4vno5yq0E4X+GefFNCHWcv3IZQ0fRSgqYO17+HctcCF9ApxK7qmBRG2
xMb/EG2UC765PP/ZC/ot+ThiMKjbNTMaqEM21f9AO+MytncjEuRBfBihRe+B68fz
e1bbR4P/3DY=
=B+Kr
-----END PGP SIGNATURE-----

--Sig_/kA/LNMIwtbbZqZl+D6h3nkk--
