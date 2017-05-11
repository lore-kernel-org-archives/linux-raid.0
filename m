From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md:raid1/10: avoid unnecessary locking
Date: Fri, 12 May 2017 08:29:56 +1000
Message-ID: <87lgq3kowr.fsf@notabene.neil.brown.name>
References: <1946dca4cbeb08911e4fcc155d1b2ffa8bc6c0a2.1494431492.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1946dca4cbeb08911e4fcc155d1b2ffa8bc6c0a2.1494431492.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, May 10 2017, shli@kernel.org wrote:

> From: Shaohua Li <shli@fb.com>
>
> If we add bios to block plugging list, locking is unnecessry, since the b=
lock
> unplug is guaranteed not to run at that time.

Yes, that make sense.  Thanks

Reviewed-by: NeilBrown <neilb@suse.com>


>
> Cc: NeilBrown <neilb@suse.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid1.c  | 7 +++----
>  drivers/md/raid10.c | 7 +++----
>  2 files changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7c1f73398800..a17ed6218d51 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1529,17 +1529,16 @@ static void raid1_write_request(struct mddev *mdd=
ev, struct bio *bio,
>  			plug =3D container_of(cb, struct raid1_plug_cb, cb);
>  		else
>  			plug =3D NULL;
> -		spin_lock_irqsave(&conf->device_lock, flags);
>  		if (plug) {
>  			bio_list_add(&plug->pending, mbio);
>  			plug->pending_cnt++;
>  		} else {
> +			spin_lock_irqsave(&conf->device_lock, flags);
>  			bio_list_add(&conf->pending_bio_list, mbio);
>  			conf->pending_count++;
> -		}
> -		spin_unlock_irqrestore(&conf->device_lock, flags);
> -		if (!plug)
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
>  			md_wakeup_thread(mddev->thread);
> +		}
>  	}
>=20=20
>  	r1_bio_write_done(r1_bio);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 6b86a0032cf8..4343d7ff9916 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1282,17 +1282,16 @@ static void raid10_write_one_disk(struct mddev *m=
ddev, struct r10bio *r10_bio,
>  		plug =3D container_of(cb, struct raid10_plug_cb, cb);
>  	else
>  		plug =3D NULL;
> -	spin_lock_irqsave(&conf->device_lock, flags);
>  	if (plug) {
>  		bio_list_add(&plug->pending, mbio);
>  		plug->pending_cnt++;
>  	} else {
> +		spin_lock_irqsave(&conf->device_lock, flags);
>  		bio_list_add(&conf->pending_bio_list, mbio);
>  		conf->pending_count++;
> -	}
> -	spin_unlock_irqrestore(&conf->device_lock, flags);
> -	if (!plug)
> +		spin_unlock_irqrestore(&conf->device_lock, flags);
>  		md_wakeup_thread(mddev->thread);
> +	}
>  }
>=20=20
>  static void raid10_write_request(struct mddev *mddev, struct bio *bio,
> --=20
> 2.11.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkU5eQACgkQOeye3VZi
gbkT8w/+JCM/MH6qoJiwxIoINFTVMOcf+KwYRxfoymsxk1zogWG+h2xR8dlpfcRl
crih0lj47DwbSWERtGgb7vmamMLwFjR/KgDngLZs6RIwpkqc1pU1zk/DO5D7hNwU
1Ie/jyBI7JGTTz+lix8vHAXhE0hsiaIOXp/RLroeNC2AexV9dVHGZ7W7xBh0oYt+
CV9gvRC1YQJU+iTiFUTvYKY3TC39hSAu7pzHOVi21VYYrzJkY+23yueKGhFQHIYf
5uEkfYg1hLv074zObr/lHp0CLoreKTZ+TLEibG2I8XVW1wqZA2e4uKT9A6lhkTzn
/p20PWnzqRR1y04kG5E8negbuooaS7LcaAO+ANrPjcuQ3dLBS76iNJ2sgdfL/ncn
NFVazOVS3IG9M/t9XhjEflJawfqPRB5kL3RPN2vy+IJXCna+8nr6kqkx3CZ+FIIi
0PkbpMbavzkltKf190qNZNn3rr2LolCptdAKPD+B6++dZ4Phthgm8pYNdqESMBgJ
bieli+xioX6jkfQV0WN32yh9wiCLJA4+BtFxU00Nu4By5l2DooVHn6J/+WW+U4rm
HSP+T0O9FT2u4Sd3Y62aOVrzNAWVZ/flPNq9XtGmsKJVyMdNc+91M9OmQXXcvnEZ
NPJFbJfeJbW1Vb/2b9OVcVAqDwejfK9W2bVsx04Ay2EwUhYguAM=
=mVWL
-----END PGP SIGNATURE-----
--=-=-=--
