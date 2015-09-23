From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2/2] raid5: update analysis state for failed stripe
Date: Wed, 23 Sep 2015 16:21:58 +1000
Message-ID: <87bncty7sp.fsf@notabene.neil.brown.name>
References: <bda150068cfdb69bf8b632c32dc2a7db17c919f4.1442596586.git.shli@fb.com> <0fc9dd19baf6f214a112b040401a4cf3d6313942.1442596586.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0fc9dd19baf6f214a112b040401a4cf3d6313942.1442596586.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> handle_failed_stripe() makes the stripe fail, eg, all IO will return
> with a failure, but it doesn't update stripe_head_state. Later
> handle_stripe() has special handling for raid6 for handle_stripe_fill().
> That check before handle_stripe_fill() doesn't skip the failed stripe
> and we get a kernel crash in need_this_block.  This patch clear the
> analysis state to make sure no functions wrongly called after
> handle_failed_stripe()
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 394cdf8..8e4fb89a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3155,6 +3155,8 @@ handle_failed_stripe(struct r5conf *conf, struct st=
ripe_head *sh,
>  			spin_unlock_irq(&sh->stripe_lock);
>  			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
>  				wake_up(&conf->wait_for_overlap);
> +			if (bi)
> +				s->to_read--;
>  			while (bi && bi->bi_iter.bi_sector <
>  			       sh->dev[i].sector + STRIPE_SECTORS) {
>  				struct bio *nextbi =3D
> @@ -3173,6 +3175,8 @@ handle_failed_stripe(struct r5conf *conf, struct st=
ripe_head *sh,
>  		 */
>  		clear_bit(R5_LOCKED, &sh->dev[i].flags);
>  	}
> +	s->to_write =3D 0;
> +	s->written =3D 0;
>=20=20
>  	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
>  		if (atomic_dec_and_test(&conf->pending_full_writes))
> --=20
> 1.8.1

Again, this probably is a sensible fix, but I would like to be certain.
Where exactly in need_this_block does the kernel crash?  I cannot see
anything that could cause an invalid address....

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWAkUGAAoJEDnsnt1WYoG5eM4QAKRn3k1K/KXJSytkS0FHPuVj
/qEllUoRjdvgtUX5SswaxkknxgzHFgQpsyfTvCjVsxa2K4i6VEVEUa4qVYddNVmu
avy1+qFTIC0SBOZ/3BO0NVRkReFzRJpI7ajrXmHBJyxroHFI9KA8J/tx/Yjf3sXd
MyDmu2ZAUieWXzLb1VhQkXL3ivkE+opvAsfh0XOzNbxBJf0zUih8naVyCBKGJYTC
6+XSMT2wO5U6WWvCAt+9c3TwwYgkliHI3sdWVXnAzOGSzTDFwA57sCwdUjc3bUMB
Twbv7w0FQfveXTvZrjYNIqDzZdZn6JveSbC+LwzLW89RI19CMXdE4Nx9HzgRwwUz
wfzLTuDpPRrTgVETGUClFfX6upowxLmJ+Xd1pCf9oIPqOwuhWBqN0rhUMbrPi/hD
7n81gbFUMHBRnH4tmQv580V+7IEjA/xM/xGByqCKfGB7+Rj3fqpoZs0i9mhrU6MK
P+It+1tv5P6uv1iR5Xss/8hahrnS+4PMKzXU9/KZxzwkscB7vt5gZMnhjnQ5RJ/H
mXBvxLgqLAjOFMatmraA0EZmOxnTyKB54JWclwWPEEYKZTTDuVHmnGhXGAGDKMVU
9SNpDU22qq149XxRE55L9FXxZh96YJgcroeIJWgaPPqSbSq2818DeK1nKpxuMSuV
mGvhwJQK7B5PooyJhMW0
=k7Kh
-----END PGP SIGNATURE-----
--=-=-=--
