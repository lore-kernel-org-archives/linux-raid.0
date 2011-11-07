From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5: STRIPE_ACTIVE has lock semantics, add
 barriers
Date: Mon, 7 Nov 2011 12:39:01 +1100
Message-ID: <20111107123901.252eaab8@notabene.brown>
References: <20110804003016.30281.26038.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.LIldSZt.R8LKKX9aIWqPx1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110804003016.30281.26038.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.LIldSZt.R8LKKX9aIWqPx1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 03 Aug 2011 17:31:23 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> All updates that occur under STRIPE_ACTIVE should be globally visible
> when STRIPE_ACTIVE clears.  test_and_set_bit() implies a barrier, but
> clear_bit() does not.
>=20
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>=20
> This at least was the guarantee we had with sh->lock...
>=20
>  drivers/md/raid5.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dbae459..bd95123 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3116,7 +3116,7 @@ static void handle_stripe(struct stripe_head *sh)
>  	struct r5dev *pdev, *qdev;
> =20
>  	clear_bit(STRIPE_HANDLE, &sh->state);
> -	if (test_and_set_bit(STRIPE_ACTIVE, &sh->state)) {
> +	if (test_and_set_bit_lock(STRIPE_ACTIVE, &sh->state)) {
>  		/* already being handled, ensure it gets handled
>  		 * again when current action finishes */
>  		set_bit(STRIPE_HANDLE, &sh->state);
> @@ -3377,7 +3377,7 @@ finish:
> =20
>  	return_io(s.return_bi);
> =20
> -	clear_bit(STRIPE_ACTIVE, &sh->state);
> +	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
>  }
> =20
>  static void raid5_activate_delayed(raid5_conf_t *conf)
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


sorry for missing this before...
I makes perfect sense.  I've applied it and should send it upstream shortly.

Thanks,
NeilBrown


--Sig_/.LIldSZt.R8LKKX9aIWqPx1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrc2tTnsnt1WYoG5AQIUtBAAwd5qvGVFc+qO9tM/PEHbQTLAME5X6W4C
awrZi5fdbLPF/T2lbdBLVn6k6xEVHZ/o6L6dAUy8N/ZDeegtJKYeP0n59p56dvo7
rLbRP6CCBKd+cpcZYWCQsD2wb0x4AxAUP6zRNi+2+Ar5wKMwIsp3EaD7Ppt+NHE7
vTOQtaUtRAgqZ4KvCXN4QQSHsujf2983pDNEp8BERpbdhEUBn+ve6l1F1vxJ6XoS
HQ0isq3IAh92qjBAUA/4ZXNExs2U0xqTYgPPZdyxoqilBf654PWlL2PNos9odjgF
fr1c+s28EdR74mClPkae2kVgOs+7htxdGNHf7X1yBPBVyFJWEthqPXPufxoV/c8t
nNW4RYahVsaeYBsAypRJlRcDJODNE09vZIsTu9OGx9+yc+jwtj1L4SZ289linjiE
/i0Mtn9FbCPOsNlGk0UrMQX9zSe8bC8IL0yZkctb9gS8GA8/Qhl2ASleRc+NRRXu
ljj3uAbCLK0TodsqAVw3T0D5ptN40xhTJYSZ8Vsv6g4l5EQVJRSWp5ZYHVyj++RX
51pOBzOnViL0qlns/QdrYCQ/4NnLcaeo9JzNYr47GQDHfr9BwH8JsHI0gW6JjPoQ
GwWlfprjLqvaZkDSNYU9UN/c4RH5d00ENm00x+XIA1bsvASsv7cJnK3ZhqbP0AU4
dl9x7VuSQ7A=
=KeoB
-----END PGP SIGNATURE-----

--Sig_/.LIldSZt.R8LKKX9aIWqPx1--
