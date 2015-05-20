From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5: fix broken async operation chain
Date: Wed, 20 May 2015 16:14:38 +1000
Message-ID: <20150520161438.7d982d16@notabene.brown>
References: <abe8bcda859c8d2a11544a273c117c190fe736a4.1431464773.git.shli@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/tLJ4ZvBxX/U_1dcP8SmvUDR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <abe8bcda859c8d2a11544a273c117c190fe736a4.1431464773.git.shli@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, maxime.ripard@free-electrons.com
List-Id: linux-raid.ids

--Sig_/tLJ4ZvBxX/U_1dcP8SmvUDR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 May 2015 09:30:08 -0700 Shaohua Li <shli@kernel.org> wrote:

> ops_run_reconstruct6() doesn't correctly chain asyn operations. The tx re=
turned
> by async_gen_syndrome should be added as the dependent tx of next stripe.
>=20
> The issue is introduced by commit 59fc630b8b5f9f21c8ce3ba153341c107dce1b0c
>     RAID5: batch adjacent full stripe write
>=20
> Reported-and-tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 1ba97fd..b9f2b9c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1822,7 +1822,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct=
 raid5_percpu *percpu,
>  	} else
>  		init_async_submit(&submit, 0, tx, NULL, NULL,
>  				  to_addr_conv(sh, percpu, j));
> -	async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
> +	tx =3D async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
>  	if (!last_stripe) {
>  		j++;
>  		sh =3D list_first_entry(&sh->batch_list, struct stripe_head,


applied, thanks.

NeilBrown

--Sig_/tLJ4ZvBxX/U_1dcP8SmvUDR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVwmTznsnt1WYoG5AQI+9xAAhD7E67Ak0N4i+Ux5CTXWGtEwcDrC/IMo
7VBlyVaPH08FWvfcduh+QJBCs09ne9UnwTk7cFaZYyieu8ko1kIotgeuHt9jM34l
41IWJpNIYVkApQl2lUzgt5NCxpoIAWaNVS3FauQNGIblFsdYlymL9E/E75+qnyAN
KESDKwVzf08Sa5zrAc3XKB4UtotxQiFogA4YwoGWsptCNhsZtlPQV+kNv2vbgkse
WuRXIFEZIYHj6Hq9IuD+JkJajLwOJ/Ju7Ro+0Glgvabt7Q+dnwzxRbq5iD+ZXUf5
13mNstuv9n7NzMXsBPO/BUa2X2NJJ7JJkXmNVTl9yiqdljDBGeP1sd4oUAcP+5pk
tdZzrAltp7ZxBVrbx/bf9uvsvE0QBrY4s+XnGzAAEkaKkGeFC7GV4zTxrj5b8BRE
6u/aSFWciIP2JFi4nUT1SaHP0fIqVuRLbQA6vgNLnwXyHFcL0RJQzlHNKHh8ZZpj
LW58y6rI5i2XXbzGff4GweCfXgbFty1jH7vVjIpOmGlWNojos/1INfdHQgd1qG7I
D9hX780mwXJbRy1E4XzrfnMCjMw4R4gvINrkH4GjF+YjYxQ2nZuMYyKvu2dc9tzN
Rq8NOf3zCv0UJrET+75930addZ0Ip86loTB7HV2OSHgeNSWm837yDoysW2Fp9gA3
WIWtRIgOZzM=
=beT3
-----END PGP SIGNATURE-----

--Sig_/tLJ4ZvBxX/U_1dcP8SmvUDR--
