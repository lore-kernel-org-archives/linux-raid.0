From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V4 1/2] RAID1: a new I/O barrier implementation to remove resync window
Date: Mon, 20 Feb 2017 11:31:59 +1100
Message-ID: <87mvdhsnwg.fsf@notabene.neil.brown.name>
References: <1487358357-123924-1-git-send-email-colyli@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1487358357-123924-1-git-send-email-colyli@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 18 2017, colyli@suse.de wrote:

> @@ -1447,36 +1497,26 @@ static void raid1_write_request(struct mddev *mdd=
ev, struct bio *bio,
>=20=20
>  static void raid1_make_request(struct mddev *mddev, struct bio *bio)
>  {
> -	struct r1conf *conf =3D mddev->private;
> -	struct r1bio *r1_bio;
> +	void (*make_request_fn)(struct mddev *mddev, struct bio *bio);
> +	struct bio *split;
> +	sector_t sectors;
>=20=20
> -	/*
> -	 * make_request() can abort the operation when read-ahead is being
> -	 * used and no empty request is available.
> -	 *
> -	 */
> -	r1_bio =3D mempool_alloc(conf->r1bio_pool, GFP_NOIO);
> +	make_request_fn =3D (bio_data_dir(bio) =3D=3D READ) ?
> +			  raid1_read_request : raid1_write_request;
>=20=20
....
>=20=20
> -	if (bio_data_dir(bio) =3D=3D READ)
> -		raid1_read_request(mddev, bio, r1_bio);
> -	else
> -		raid1_write_request(mddev, bio, r1_bio);
> +		make_request_fn(mddev, split);
> +	} while (split !=3D bio);
>  }

I don't think the use of make_request_fn() makes the code more readable
or more efficient, and it quite possibly has a cost.
If you left it as

	if (bio_data_dir(bio) =3D=3D READ)
		raid1_read_request(mddev, bio, r1_bio);
	else
		raid1_write_request(mddev, bio, r1_bio);

then gcc would notice that both raid1_read_request and
raid1_write_request are static functions that are only used once, and
will normally inline them.  This will reduce the total stack depth,
which you expressed some concern about in a previous email.
Using a function pointer like this makes it harder for gcc to perform
that optimization.


NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliqOP8ACgkQOeye3VZi
gblDsA/9ETg+H+MFU6R9NK/qYTg79kzTcN/hhuNFUviLSQn1KuWWAnM0Fb0gOVA7
oOUX2lLogXUYBzpM4W50SLkIQzPwMkvTkUAvimpqXip7jaPK5CWqBxTDrZFMaf+B
l9Sdf7F2QqxJczNBJ9Ihu1Fm2PKeFHpHeUzyI22/cMV4ytxytIahX8fCuaKk64JJ
d3mTiIi11B7jlTwQnR/IeBMWASmmrxvQRzy9Y/JonUbz4wn3m168y11RoYouqM1J
6dc7qfiDoG98aEFmiHOQVIMif1QLZBGSJYk5ZtIMWvwrUk9k8tFul4WLBXj5X4BR
JZU1oRAFM9nonN11W2um2VNyhlOgfc5/9R39JVhn1ys9lMbEzBqGjPzTxbfU0Dpw
ffGocReCXYjuHKZWfBN+ukyLC7fK3XcLj6VkvZyxuJA6EiuXxe0L+3mRqq1k59Ge
NdJ52czQfCnLtGL5jn8xSjeuDpRlh7i5zJEbbbotjUUBsU7ZW98vbfydJbt4rnFg
+lu9h7oJK2Xo4M3wIp2Zdtb2nSZK+XNcIf/hYbRBM3nSczFE13Jk5fvZVOgZoVLh
fgu7/u9rHHv5ZpFYblRRB3YpHdlR9JVot2xHsCL+fSWqZ3/XPjk2/Dm2BirvPkrW
7JmUIYnp4qX+utFd8oY76Axp8Cj95kUQk+OywtrTUkUpa+hpki4=
=fphU
-----END PGP SIGNATURE-----
--=-=-=--
