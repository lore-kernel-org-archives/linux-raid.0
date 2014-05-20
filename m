From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC]raid5: adjust operation order of handle_stripe
Date: Tue, 20 May 2014 17:21:37 +1000
Message-ID: <20140520172137.0f72c113@notabene.brown>
References: <20140512011659.GA13135@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9Tk87pfSPY+32k464jK7VxX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140512011659.GA13135@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/9Tk87pfSPY+32k464jK7VxX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 May 2014 09:16:59 +0800 Shaohua Li <shli@kernel.org> wrote:

>=20
> For a full stripe write, the ideal operation order is handle_stripe_dirty=
ing(),
> raid_run_ops(), set R5_Wantwrite bit, and ops_run_io(). In this way, one
> handle_stripe() will dispatch IO for the stripe, otherwise there are more=
 extra
> rounds of handle_stripe(). In a high speed raid5 array, handle_stripe()
> consumes considered cpu time. Reducing its overhead has around 10% perfor=
mance
> boost.
>=20
> This patch makes handle_stripe() operations follow the ideal order. It al=
so
> moves handle_stripe_clean_event() up, as it handles completed stripe. And=
 if I
> don't change handle_stripe_clean_event() order, I saw some states confuse=
d with
> other changes.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>

handle_stripe() now calls raid_run_ops twice, which is quite a change.
I would need a clear statement of why that is OK.
If the xor etc operations are being performed asynchronously you will get
very different behaviour than if they are synchronous.  That might all work
perfectly, but again I'd like to be sure that question has been considered
and answered.

Also you seem to have about 3 changes in this patch.

- change raid_run_ops to be passed ops_request by reference instead of by
  value.  This would be easier to review in a separate patch.
- move handle_stripe_clean_event(), as you mention above.  Having this
  in a separate patch and explaining why it makes sense would be good.
- the main change that you want to make would be then a simple small patch
  with few distractions and so easier to review.

It might be a good idea to take this opportunity to split handle_stripe() up
a bit.  As you say, some of the code handles completed stripes, some flags
desired changes, and some executes those changes.  Having those pieces in
different functions would improve the code a lot.

Would you like to make that change (please) ?

Thanks,
NeilBrown


> ---
>  drivers/md/raid5.c |   39 +++++++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 18 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2014-05-06 17:19:13.868225752 +0800
> +++ linux/drivers/md/raid5.c	2014-05-06 17:20:25.367326852 +0800
> @@ -1633,7 +1633,7 @@ static void ops_run_check_pq(struct stri
>  			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
>  }
> =20
> -static void raid_run_ops(struct stripe_head *sh, unsigned long ops_reque=
st)
> +static void raid_run_ops(struct stripe_head *sh, unsigned long *ops_requ=
est)
>  {
>  	int overlap_clear =3D 0, i, disks =3D sh->disks;
>  	struct dma_async_tx_descriptor *tx =3D NULL;
> @@ -1644,12 +1644,12 @@ static void raid_run_ops(struct stripe_h
> =20
>  	cpu =3D get_cpu();
>  	percpu =3D per_cpu_ptr(conf->percpu, cpu);
> -	if (test_bit(STRIPE_OP_BIOFILL, &ops_request)) {
> +	if (test_and_clear_bit(STRIPE_OP_BIOFILL, ops_request)) {
>  		ops_run_biofill(sh);
>  		overlap_clear++;
>  	}
> =20
> -	if (test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request)) {
> +	if (test_and_clear_bit(STRIPE_OP_COMPUTE_BLK, ops_request)) {
>  		if (level < 6)
>  			tx =3D ops_run_compute5(sh, percpu);
>  		else {
> @@ -1659,26 +1659,26 @@ static void raid_run_ops(struct stripe_h
>  				tx =3D ops_run_compute6_2(sh, percpu);
>  		}
>  		/* terminate the chain if reconstruct is not set to be run */
> -		if (tx && !test_bit(STRIPE_OP_RECONSTRUCT, &ops_request))
> +		if (tx && !test_and_clear_bit(STRIPE_OP_RECONSTRUCT, ops_request))
>  			async_tx_ack(tx);
>  	}
> =20
> -	if (test_bit(STRIPE_OP_PREXOR, &ops_request))
> +	if (test_and_clear_bit(STRIPE_OP_PREXOR, ops_request))
>  		tx =3D ops_run_prexor(sh, percpu, tx);
> =20
> -	if (test_bit(STRIPE_OP_BIODRAIN, &ops_request)) {
> +	if (test_and_clear_bit(STRIPE_OP_BIODRAIN, ops_request)) {
>  		tx =3D ops_run_biodrain(sh, tx);
>  		overlap_clear++;
>  	}
> =20
> -	if (test_bit(STRIPE_OP_RECONSTRUCT, &ops_request)) {
> +	if (test_and_clear_bit(STRIPE_OP_RECONSTRUCT, ops_request)) {
>  		if (level < 6)
>  			ops_run_reconstruct5(sh, percpu, tx);
>  		else
>  			ops_run_reconstruct6(sh, percpu, tx);
>  	}
> =20
> -	if (test_bit(STRIPE_OP_CHECK, &ops_request)) {
> +	if (test_and_clear_bit(STRIPE_OP_CHECK, ops_request)) {
>  		if (sh->check_state =3D=3D check_state_run)
>  			ops_run_check_p(sh, percpu);
>  		else if (sh->check_state =3D=3D check_state_run_q)
> @@ -3780,6 +3780,41 @@ static void handle_stripe(struct stripe_
>  			handle_failed_sync(conf, sh, &s);
>  	}
> =20
> +	/*
> +	 * might be able to return some write requests if the parity blocks
> +	 * are safe, or on a failed drive
> +	 */
> +	pdev =3D &sh->dev[sh->pd_idx];
> +	s.p_failed =3D (s.failed >=3D 1 && s.failed_num[0] =3D=3D sh->pd_idx)
> +		|| (s.failed >=3D 2 && s.failed_num[1] =3D=3D sh->pd_idx);
> +	qdev =3D &sh->dev[sh->qd_idx];
> +	s.q_failed =3D (s.failed >=3D 1 && s.failed_num[0] =3D=3D sh->qd_idx)
> +		|| (s.failed >=3D 2 && s.failed_num[1] =3D=3D sh->qd_idx)
> +		|| conf->level < 6;
> +
> +	if (s.written &&
> +	    (s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
> +			     && !test_bit(R5_LOCKED, &pdev->flags)
> +			     && (test_bit(R5_UPTODATE, &pdev->flags) ||
> +				 test_bit(R5_Discard, &pdev->flags))))) &&
> +	    (s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
> +			     && !test_bit(R5_LOCKED, &qdev->flags)
> +			     && (test_bit(R5_UPTODATE, &qdev->flags) ||
> +				 test_bit(R5_Discard, &qdev->flags))))))
> +		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
> +
> +	/* Now to consider new write requests and what else, if anything
> +	 * should be read.  We do not handle new writes when:
> +	 * 1/ A 'write' operation (copy+xor) is already in flight.
> +	 * 2/ A 'check' operation is in flight, as it may clobber the parity
> +	 *    block.
> +	 */
> +	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
> +		handle_stripe_dirtying(conf, sh, &s, disks);
> +
> +	if (s.ops_request)
> +		raid_run_ops(sh, &s.ops_request);
> +
>  	/* Now we check to see if any write operations have recently
>  	 * completed
>  	 */
> @@ -3817,29 +3852,6 @@ static void handle_stripe(struct stripe_
>  			s.dec_preread_active =3D 1;
>  	}
> =20
> -	/*
> -	 * might be able to return some write requests if the parity blocks
> -	 * are safe, or on a failed drive
> -	 */
> -	pdev =3D &sh->dev[sh->pd_idx];
> -	s.p_failed =3D (s.failed >=3D 1 && s.failed_num[0] =3D=3D sh->pd_idx)
> -		|| (s.failed >=3D 2 && s.failed_num[1] =3D=3D sh->pd_idx);
> -	qdev =3D &sh->dev[sh->qd_idx];
> -	s.q_failed =3D (s.failed >=3D 1 && s.failed_num[0] =3D=3D sh->qd_idx)
> -		|| (s.failed >=3D 2 && s.failed_num[1] =3D=3D sh->qd_idx)
> -		|| conf->level < 6;
> -
> -	if (s.written &&
> -	    (s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
> -			     && !test_bit(R5_LOCKED, &pdev->flags)
> -			     && (test_bit(R5_UPTODATE, &pdev->flags) ||
> -				 test_bit(R5_Discard, &pdev->flags))))) &&
> -	    (s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
> -			     && !test_bit(R5_LOCKED, &qdev->flags)
> -			     && (test_bit(R5_UPTODATE, &qdev->flags) ||
> -				 test_bit(R5_Discard, &qdev->flags))))))
> -		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
> -
>  	/* Now we might consider reading some blocks, either to check/generate
>  	 * parity, or to satisfy requests
>  	 * or to load a block that is being partially written.
> @@ -3851,15 +3863,6 @@ static void handle_stripe(struct stripe_
>  	    || s.expanding)
>  		handle_stripe_fill(sh, &s, disks);
> =20
> -	/* Now to consider new write requests and what else, if anything
> -	 * should be read.  We do not handle new writes when:
> -	 * 1/ A 'write' operation (copy+xor) is already in flight.
> -	 * 2/ A 'check' operation is in flight, as it may clobber the parity
> -	 *    block.
> -	 */
> -	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
> -		handle_stripe_dirtying(conf, sh, &s, disks);
> -
>  	/* maybe we need to check and possibly fix the parity for this stripe
>  	 * Any reads will already have been scheduled, so we just see if enough
>  	 * data is available.  The parity check is held off while parity
> @@ -4014,7 +4017,7 @@ finish:
>  		}
> =20
>  	if (s.ops_request)
> -		raid_run_ops(sh, s.ops_request);
> +		raid_run_ops(sh, &s.ops_request);
> =20
>  	ops_run_io(sh, &s);
> =20


--Sig_/9Tk87pfSPY+32k464jK7VxX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU3sCgTnsnt1WYoG5AQJTcxAAnbKo/YJCar3garZ5cQwSxjSRK1rGkyhs
l4BNUQ0/CHY+eIzUlx+jQPUSFfvtnen/VncdiCXMH0dhTKCC8urrxv2ZnVbWRnFN
v2DT3n+GirSEmm2PfJUFB7H+l6gYy9VS1UbZCUST+q6FDVnzgtqkLQL+RTAqInlW
uceIDmzFdLyRvesGftZUIiW0x+T4Op0IH25e4FTB4U2XR2fAxYgoUOKSRCUHNtrj
k9b7BThRrAEsscIP+6kYN9c9VwWkNIAILzWmb/oQsKi21qce+nxs797WnifpkVz1
klH7RfpZKBrLxEo9Yo5Aj2FIaJRFv+cmGQhmQtxmr+6sCMW/sFlRlK6FZd39ju30
GXGWsrRgCOTY5CcDhQLrWmPi0bwgt7KUiG3yeTC8fXPVtTiKcEmgbVa64ZGK5yPM
sFFVQCsec4LJsUxsoo4tVNoTVhB7KRctBWyiEjIdO058srfl8nwSyoJ1qbQIjwjW
U8XwiRAZeUIkKbXp1VXV6rsOP9sdTK7k+VFrvvgjiGx0DA2DQWkH+x6HBBIVx5Ls
hBsbsZ7vlazbeJQawjy3OErkmTuakzjcNXKBQVsT20Y7MXT8OV2dILUPHf+oMhxJ
J4o2CdTC4HzBdFTcK9Rlva0Y8Jf9TC7sjNQXEyNuBR/0vb8Pu2PZKd2A2IC58RdN
kgVpJe+ikJw=
=BC3K
-----END PGP SIGNATURE-----

--Sig_/9Tk87pfSPY+32k464jK7VxX--
