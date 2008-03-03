From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 001 of 9] md: Fix deadlock in md/raid1 and md/raid10 when handling a read error.
Date: Mon, 3 Mar 2008 16:54:49 +0100
Message-ID: <20080303155449.GA32242@skl-net.de>
References: <20080303111240.23302.patches@notabene> <1080303001705.23577@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1080303001705.23577@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "K.Tanaka" <k-tanaka@ce.jp.nec.com>
List-Id: linux-raid.ids


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:17, NeilBrown wrote:

> So we create a new function 'flush_pending_writes' to give that attention,
> and call it in freeze_array to be sure that we aren't waiting on raid1d.

Two minor remarks:

> +static int flush_pending_writes(conf_t *conf)
> +{
> +	/* Any writes that have been queued but are awaiting
> +	 * bitmap updates get flushed here.
> +	 * We return 1 if any requests were actually submitted.
> +	 */
> +	int rv =3D 0;
> +
> +	spin_lock_irq(&conf->device_lock);
> =20
> +	if (conf->pending_bio_list.head) {
> +		struct bio *bio;
> +		bio =3D bio_list_get(&conf->pending_bio_list);
> +		blk_remove_plug(conf->mddev->queue);
> +		spin_unlock_irq(&conf->device_lock);
> +		/* flush any pending bitmap writes to disk
> +		 * before proceeding w/ I/O */
> +		bitmap_unplug(conf->mddev->bitmap);
> +
> +		while (bio) { /* submit pending writes */
> +			struct bio *next =3D bio->bi_next;
> +			bio->bi_next =3D NULL;
> +			generic_make_request(bio);
> +			bio =3D next;
> +		}
> +		rv =3D 1;
> +	} else
> +		spin_unlock_irq(&conf->device_lock);
> +	return rv;
> +}

Do we really need to take the spin lock in the common case where
conf->pending_bio_list.head is NULL? If not, the above could be
optimized to the slightly faster and better readable

	struct bio *bio;

	if (!conf->pending_bio_list.head)
		return 0;
	spin_lock_irq(&conf->device_lock);
	bio =3D bio_list_get(&conf->pending_bio_list);
	...
	spin_unlock_irq(&conf->device_lock);
	return 1;


> diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
> --- .prev/drivers/md/raid1.c	2008-02-22 15:45:35.000000000 +1100
> +++ ./drivers/md/raid1.c	2008-02-22 15:45:35.000000000 +1100
> @@ -592,6 +592,37 @@ static int raid1_congested(void *data, i
>  }
> =20
> =20
> +static int flush_pending_writes(conf_t *conf)
> +{

[snip]

Any chance to avoid this code duplication?

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHzB9JWto1QDEAkw8RAuE4AKCh82vDzhPVas/TlS7ZMoxnbDfYDQCgiVxu
yPwIJRLu/wHL+VYrUED08cg=
=G+gj
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
