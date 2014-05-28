From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/3]raid5: adjust order of some operations in
 handle_stripe
Date: Wed, 28 May 2014 12:59:37 +1000
Message-ID: <20140528125937.5555437e@notabene.brown>
References: <20140522112431.GA10509@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9hK7Xz40_j_.86a1hxFNgz8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140522112431.GA10509@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/9hK7Xz40_j_.86a1hxFNgz8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 May 2014 19:24:31 +0800 Shaohua Li <shli@kernel.org> wrote:

>=20
> This is to revert ef5b7c69b7a1b8b8744a6168b6f. handle_stripe_clean_event()
> handles finished stripes, which really should be the first thing to do. T=
he
> original changelog says checking reconstruct_state should be the first as
> handle_stripe_clean_event can clear some dev->flags and impact checking
> reconstruct_state code path. It's unclear to me why this happens, because=
 I
> thought written finish and reconstruct_state equals to *_result can't hap=
pen in
> the same time.

"unclear to me" "I thought" are sufficient to justify a change, though they
are certainly sufficient to ask a question.

Are you asking a question or submitting a change?

You may well be correct that if reconstruct_state is not
reconstruct_state_idle, then handle_stripe_clean_event cannot possible be
called.  In that case, maybe we should change the code flow to make that mo=
re
obvious, but certainly the changelog comment should be clear about exactly
why.


>=20
> I also moved checking reconstruct_state code path after handle_stripe_dir=
tying.
> If that code sets reconstruct_state to reconstruct_state_idle, the order =
change
> will make us miss one handle_stripe_dirtying. But the stripe will be even=
tually
> handled again when written is finished.

You haven't said here why this patch is a good thing, only why it isn't
obviously bad.  I really need some justification to make a change and you
haven't provided any, at least not in this changelog comment.

Maybe we need a completely different approach.
Instead of repeatedly shuffling code inside handle_stripe(), how about we p=
ut
all of handle_stripe inside a loop which runs as long as STRIPE_HANDLE is s=
et
and sh->count =3D=3D 1.
ie.

	if (test_and_set_bit_lock(STRIPE_ACTIVE, &sh->state)) {
		/* already being handled, ensure it gets handled
		 * again when current action finishes */
		set_bit(STRIPE_HANDLE, &sh->state);
		return;
	}

        do {
	        clear_bit(STRIPE_HANDLE, &sh->state);
                __handle_stripe(sh);
        } while (test_bit(STRIPE_HANDLE, &sh->state)
                 && atomic_read(&sh->count) =3D=3D 1);
	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);


where the rest of the current handle_stripe() goes in to __handle_stripe().

Would that address your performance concerns, or is there still too much
overhead?

It's not that I think your code is wrong, but I want the result to be
"obviously correct" as much as possible, and currently I don't think it is.

Thanks,
NeilBrown


>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |   74 ++++++++++++++++++++++++++--------------------=
-------
>  1 file changed, 37 insertions(+), 37 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2014-05-22 13:27:21.000000000 +0800
> +++ linux/drivers/md/raid5.c	2014-05-22 14:41:05.603276379 +0800
> @@ -3747,43 +3747,6 @@ static void handle_stripe(struct stripe_
>  			handle_failed_sync(conf, sh, &s);
>  	}
> =20
> -	/* Now we check to see if any write operations have recently
> -	 * completed
> -	 */
> -	prexor =3D 0;
> -	if (sh->reconstruct_state =3D=3D reconstruct_state_prexor_drain_result)
> -		prexor =3D 1;
> -	if (sh->reconstruct_state =3D=3D reconstruct_state_drain_result ||
> -	    sh->reconstruct_state =3D=3D reconstruct_state_prexor_drain_result)=
 {
> -		sh->reconstruct_state =3D reconstruct_state_idle;
> -
> -		/* All the 'written' buffers and the parity block are ready to
> -		 * be written back to disk
> -		 */
> -		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags) &&
> -		       !test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags));
> -		BUG_ON(sh->qd_idx >=3D 0 &&
> -		       !test_bit(R5_UPTODATE, &sh->dev[sh->qd_idx].flags) &&
> -		       !test_bit(R5_Discard, &sh->dev[sh->qd_idx].flags));
> -		for (i =3D disks; i--; ) {
> -			struct r5dev *dev =3D &sh->dev[i];
> -			if (test_bit(R5_LOCKED, &dev->flags) &&
> -				(i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx ||
> -				 dev->written)) {
> -				pr_debug("Writing block %d\n", i);
> -				set_bit(R5_Wantwrite, &dev->flags);
> -				if (prexor)
> -					continue;
> -				if (!test_bit(R5_Insync, &dev->flags) ||
> -				    ((i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx)  &&
> -				     s.failed =3D=3D 0))
> -					set_bit(STRIPE_INSYNC, &sh->state);
> -			}
> -		}
> -		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> -			s.dec_preread_active =3D 1;
> -	}
> -
>  	/*
>  	 * might be able to return some write requests if the parity blocks
>  	 * are safe, or on a failed drive
> @@ -3827,6 +3790,43 @@ static void handle_stripe(struct stripe_
>  	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
>  		handle_stripe_dirtying(conf, sh, &s, disks);
> =20
> +	/* Now we check to see if any write operations have recently
> +	 * completed
> +	 */
> +	prexor =3D 0;
> +	if (sh->reconstruct_state =3D=3D reconstruct_state_prexor_drain_result)
> +		prexor =3D 1;
> +	if (sh->reconstruct_state =3D=3D reconstruct_state_drain_result ||
> +	    sh->reconstruct_state =3D=3D reconstruct_state_prexor_drain_result)=
 {
> +		sh->reconstruct_state =3D reconstruct_state_idle;
> +
> +		/* All the 'written' buffers and the parity block are ready to
> +		 * be written back to disk
> +		 */
> +		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags) &&
> +		       !test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags));
> +		BUG_ON(sh->qd_idx >=3D 0 &&
> +		       !test_bit(R5_UPTODATE, &sh->dev[sh->qd_idx].flags) &&
> +		       !test_bit(R5_Discard, &sh->dev[sh->qd_idx].flags));
> +		for (i =3D disks; i--; ) {
> +			struct r5dev *dev =3D &sh->dev[i];
> +			if (test_bit(R5_LOCKED, &dev->flags) &&
> +				(i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx ||
> +				 dev->written)) {
> +				pr_debug("Writing block %d\n", i);
> +				set_bit(R5_Wantwrite, &dev->flags);
> +				if (prexor)
> +					continue;
> +				if (!test_bit(R5_Insync, &dev->flags) ||
> +				    ((i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx)  &&
> +				     s.failed =3D=3D 0))
> +					set_bit(STRIPE_INSYNC, &sh->state);
> +			}
> +		}
> +		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> +			s.dec_preread_active =3D 1;
> +	}
> +
>  	/* maybe we need to check and possibly fix the parity for this stripe
>  	 * Any reads will already have been scheduled, so we just see if enough
>  	 * data is available.  The parity check is held off while parity


--Sig_/9hK7Xz40_j_.86a1hxFNgz8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4VRGTnsnt1WYoG5AQKfcw/+M+j4xc5mjFero4Lx7y4faWShPnfGOqXy
1661cULeHYeC/FDg0bkv6v0uzJEyigdl3iwYf/VTOKZONADIp+W0n4FqU321Jkv/
Y04GGt6RKxgf51LYUadV54HrfN60v4ZZg9b6jtSUVwrkVrzB7JVM4EDYducDUYmr
1maxl51j79dnlzNuz11CJks3pvQ0lJGT90GAUV+3LZiY8Mg10EONitHtQwGM6nbt
/JjEuKTL+EiNOrdHJfNoQF3HEX/Ra2+PZaAwKxdftf5B4i0GLay2C4px9OZfJFOW
B1XXVxaiJ6cG8tLLcHmIUUQW7T6DsqWNNztTG7rxtBYDYjJzmXJ0qheyrvTDH1HU
Z8g0PJ08I86gpMRfOf13XOrnukC8j5uYOaab4uioXglKS75HYf4V/wpKwNvJ1Gep
KUsTyAOz7jBQzYfNjQVZCJ5X5z6bqVKLyRGNf/8plZ/ava7rB+UpsfJgLnt4uIgc
uIc7kGbPKq2FSJlS0U196fX0pxrOJUY258njOqDzUG8FS6LdrNMx4iDwDLIDtRm6
4dTpwAD/2leXcMCWM5Px1nTox0Z3C6Kh7wcH0WOEuRGly6Q0+8LxOk3BEpOrS3wt
wE9++Kg5KCd7LmrFhMEohf7DOqt+seL0dwonEF6HYW9yeohuYnXemK6LyUIj77NM
CSmk6aOV9sI=
=3h9O
-----END PGP SIGNATURE-----

--Sig_/9hK7Xz40_j_.86a1hxFNgz8--
