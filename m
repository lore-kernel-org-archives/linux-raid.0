From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v3 9/9] raid5-ppl: runtime PPL enabling or disabling
Date: Mon, 27 Mar 2017 16:08:39 +1100
Message-ID: <878tnr8fxk.fsf@notabene.neil.brown.name>
References: <20170130185953.30428-1-artur.paszkiewicz@intel.com> <20170130185953.30428-10-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170130185953.30428-10-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, jes.sorensen@gmail.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30 2017, Artur Paszkiewicz wrote:

>=20=20
> +static void raid5_reset_stripe_cache(struct mddev *mddev)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +
> +	mutex_lock(&conf->cache_size_mutex);
> +	while (conf->max_nr_stripes &&
> +	       drop_one_stripe(conf))
> +		;
> +	while (conf->min_nr_stripes > conf->max_nr_stripes &&
> +	       grow_one_stripe(conf, GFP_KERNEL))
> +		;
> +	mutex_unlock(&conf->cache_size_mutex);
> +}

This is called with the raid array suspended, so any writeout to the
array will block.
A GFP_KERNEL allocation can block waiting for writeout.
So this can deadlock.
At the very least, this should use GFP_NOIO.

It would be better to do something like resize_stripes() does, or maybe
even just use resize_stripes().
It allocates the new stripes first before suspending IO.  Then it
cleans out the old stripes, and inserts the pre-allocated stripes.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljYnlcACgkQOeye3VZi
gbnh9Q/+OVIx7EWNxPDEzBEcND1DV7kwuXxjCjBwoCmePI+LvRuzcLZm1rsRoW/x
0UvyVbk7JMG4r6vi+8LWAJmaj0XYLupX/YDh3benjS+WEGceD8EcEHpC7nTJjU8j
kZmsXC/Y2bYl7dHYZ7v/h8pUDcyzeA64MmcdcZVEM3Jnf4kSzwCou2WCofgk6EAN
ueYfrx+xp+u6RlfGFBqCL4cAIlWRAmnFS8dpG5Nex7MI5IQQSpk+aJJ9GEWu0rh4
zw9B8L7kKGClsYMxBy1KHnymrbfaUoSFiXwTWM9S0pVxO2S64L6P2jGQV9p7aEyJ
FkjyR2fC5APPt9aPDJO985Z47ZagtMe1bK4BK91Zms+5aOQUPDGwiUWmbY5GL43N
Dni1VeqpMpJXFK0Mhof2tgifkq9ta99ioAn8lXbDR6/S8/QnHuNl32ZbuEgGnczE
iY7t54QbgzS3WfXzJ4WgFUJ2sCQHxVdJN9jG/mfRUnHTthLa3JsBul13SGdWvdaM
vmh62C1HrtVokaq2BOsyxTzeiFEELbEc4aoTIqATl+Qpw2IHKggGjXyRcTYPBKNJ
FhR3KfRqXO5XYMucI6TXK7JtISu7Ik6ApRiIfjgqZBzHc+ouqDxQR2HsvWt5I878
46oNnm7rTtNVpGh/wz7H9xd2t8mubAt5N32cJIYNp0Jn+V8/Gew=
=Ew+3
-----END PGP SIGNATURE-----
--=-=-=--
