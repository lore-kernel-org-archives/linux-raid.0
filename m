From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD:  Do not increment resync_mismatches unless
 MD_RECOVERY_REQUESTED
Date: Mon, 22 Apr 2013 10:36:26 +1000
Message-ID: <20130422103626.4cdcefae@notabene.brown>
References: <1366402161.18514.1.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/h4q1lr7h600pD6q5pHW3bxc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1366402161.18514.1.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/h4q1lr7h600pD6q5pHW3bxc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Apr 2013 15:09:21 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> MD:  Do not increment resync_mismatches unless MD_RECOVERY_REQUESTED
>=20
> resync_mismatches is used to display the number of differences that
> have been found or repaired during a scrubbing operation.  It is not
> meant to count anything during resync or repair operations.  (How
> much sense does it make to find resync_mismatches populated after an
> initial synchronization of the array?  After cleaning-up an unclean
> shutdown?  After [re]integrating a device into an existing array?)
> The incrementing of the variable must be restricted to when the user
> initiates a scrubbing operation (i.e. "check" or "repair").

How do you know what it is "meant" to do? :-)

While it might not be particularly useful, I see no point in hiding
information, and no desire to change what mismatch_cnt reports.

It may well be useful to somehow report what the real meaning for
mismatch_cnt is.  i.e. to report what the last sync_action was.
Then any use-space tool that reported mismatch_cnt, could adjust according =
to
whether the last operation was check/repair or resync/recovery/reshape. etc.

So if you were to provide a patch which adds "last_sync_action" or similar,
I'd certainly consider that.

Thanks,
NeilBrown

>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/raid1.c
> +++ linux-upstream/drivers/md/raid1.c
> @@ -1878,7 +1878,8 @@ static int process_checks(struct r1bio *
>  			}
>  		} else
>  			j =3D 0;
> -		if (j >=3D 0)
> +		if ((j >=3D 0) &&
> +		    (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)))
>  			atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
>  		if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
>  			      && test_bit(BIO_UPTODATE, &sbio->bi_flags))) {
> Index: linux-upstream/drivers/md/raid10.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/raid10.c
> +++ linux-upstream/drivers/md/raid10.c
> @@ -2071,7 +2071,10 @@ static void sync_request_write(struct md
>  					break;
>  			if (j =3D=3D vcnt)
>  				continue;
> -			atomic64_add(r10_bio->sectors, &mddev->resync_mismatches);
> +
> +			if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
> +				atomic64_add(r10_bio->sectors,
> +					     &mddev->resync_mismatches);
>  			if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
>  				/* Don't fix anything. */
>  				continue;
> Index: linux-upstream/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/raid5.c
> +++ linux-upstream/drivers/md/raid5.c
> @@ -2989,7 +2989,10 @@ static void handle_parity_checks5(struct
>  			 */
>  			set_bit(STRIPE_INSYNC, &sh->state);
>  		else {
> -			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
> +			if (test_bit(MD_RECOVERY_REQUESTED,
> +				     &conf->mddev->recovery))
> +				atomic64_add(STRIPE_SECTORS,
> +					     &conf->mddev->resync_mismatches);
>  			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
>  				/* don't try to repair!! */
>  				set_bit(STRIPE_INSYNC, &sh->state);
> @@ -3141,7 +3144,10 @@ static void handle_parity_checks6(struct
>  				 */
>  			}
>  		} else {
> -			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
> +			if (test_bit(MD_RECOVERY_REQUESTED,
> +				     &conf->mddev->recovery))
> +				atomic64_add(STRIPE_SECTORS,
> +					     &conf->mddev->resync_mismatches);
>  			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
>  				/* don't try to repair!! */
>  				set_bit(STRIPE_INSYNC, &sh->state);
>=20


--Sig_/h4q1lr7h600pD6q5pHW3bxc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXSGCjnsnt1WYoG5AQJWjxAAm7s/k6M2EEKX6zBGxHNKJVhvEfWY0PiQ
dWT7H2O43EAKk8T6P3AbMYT/KPJ5BRLTvSPLUt82IoxzCaOXGg+bdJnM61nrX0fg
VQnx9C/9AeyNbeiZ27D9CXYJsC29z0j5L+XDj6WkuoEUJG+VT6dKchw12BBwTH+Z
u7fZky4IkSGB/Coyf5qkeM90TH5NJ5a/fYCNpGgO6g3koF0D8fYPMBbU/zes+LFx
iOWFP1J3FCXaas61H86yGOwkConzDkn1aVljFDxCBLePfMdNnvk3ftAjz1HCP/C2
NLGX9rgCR+dY08xad1LH4RnKpjF+4REtTez3G0+KyfP4QcLpqZqysJUFgoZuo0YI
SCveARaduUvI5Qcr42+9vpvLPmmSsFfIrrarA5xJ0UIS/thNycwsGGSJcmRYxRaQ
P91E3o7dKr21tBJRk5bpVSCVZu1PcVruGLkA8QhNnG78i9W8e11EJ2ayqKW1uAP3
vvIqSczGneWNxAyWj54kzz+8kl1gWjxouw1bDCe04UQf5YqWFHghTA9QNO8bQ6CG
uAtMJYhRXy2ZZq9ZbXr0/pTGiu2M0u9IvtkOUlxuozIPNQKkVRcnt3yFwpp6PAyb
bnJcPOQNIcBb+0/whlATaRrwmyhL6e1a4gcFJL9HxuSW60VLsi8Yk1xdi9vJmRtB
Qdhwk9ChwEA=
=CIKX
-----END PGP SIGNATURE-----

--Sig_/h4q1lr7h600pD6q5pHW3bxc--
