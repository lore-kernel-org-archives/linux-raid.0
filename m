From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH] raid5: Correct some failed-stripe which because the
 badsector.
Date: Wed, 26 Sep 2012 11:20:10 +1000
Message-ID: <20120926112010.0d27c892@notabene.brown>
References: <2012092211144517180514@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7_O/zx9IcOulIO.4Yl696nU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012092211144517180514@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, "=?gb2312?Q?=D6=DC,_=F7=E8?=" <qi.g.zhou@gmail.com>, "=?gb2312?Q?=B1=DF,_=D3=EA?=" <ycbzzjlbyby@gmail.com>
List-Id: linux-raid.ids

--Sig_/7_O/zx9IcOulIO.4Yl696nU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 22 Sep 2012 11:14:47 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wro=
te:

> Because raid5 had implemented badsector feature,some failed-stripe which =
because the
> badsector can try to correct instead of only failing.
>=20
> For example:
> 1:Create a raid5 by four disks missing/sdb/sdc/sdd.
> 2:If readed  data from sdb and met error,so the stripe is failed
> 3:If later write-stripe contains sdb which overwrite.The stripe has a
> chance to correct.

Your patch looks much more complicated that should be necessary, and you
don't provide any explanation for how it works, so it is very hard for me to
review.

I would think you just need to modify analyse_stripe slightly so that it
detects the "overwrite-a-bad-block" case and marks that device as
'in_sync' (if there hasn't been a write error on the device).

Then make sure that handle_stripe_dirtying detects that case and doesn't try
to read, so forces 'rcw'

You patch does seem to do some of those things, but it does a lot more as
well that doesn't seem to be justified.
It also makes pointless changes to formatting which makes the patch harder =
to
read.

Please
 - keep the patch as small as possible.
 - explain what is happening in as much detail as possible.

NeilBrown



> 4:If step3 successed, add a spare disk to raid,the raid can be active
> from degraded.
>=20
> There are two methods to compute raid5 parity,rcw and rmw.
> In this situation,it only used rcw.
> The purpose is only change state of stripe from failed to degraded or
> active.
>=20
> NOTE:
> The patch looks ugly. It is post out mainly to make sure it is=20
> going in the correct direction and hope to get some helpful comments from=
 other guys.
>=20
> Tested-by: Qi Zhou <qi.g.zhou@gmail.com>
> Signed-off-by: Yu Bian <ycbzzjlbyby@gmail.com>
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |  152 +++++++++++++++++++++++++++++++++++++++++++---=
------
>  drivers/md/raid5.h |    8 +++
>  2 files changed, 135 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index adda94d..d085fa4 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -220,6 +220,7 @@ static void do_release_stripe(struct r5conf *conf, st=
ruct stripe_head *sh)
>  			    < IO_THRESHOLD)
>  				md_wakeup_thread(conf->mddev->thread);
>  		atomic_dec(&conf->active_stripes);
> +		clear_bit(STRIPE_FAILED_REREAD, &sh->state);
>  		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
>  			list_add_tail(&sh->lru, &conf->inactive_list);
>  			wake_up(&conf->wait_for_stripe);
> @@ -548,9 +549,9 @@ static void ops_run_io(struct stripe_head *sh, struct=
 stripe_head_state *s)
>  			else
>  				rw =3D WRITE;
>  		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
> -			rw =3D READ;
> +				rw =3D READ;
>  		else if (test_and_clear_bit(R5_WantReplace,
> -					    &sh->dev[i].flags)) {
> +				&sh->dev[i].flags)) {
>  			rw =3D WRITE;
>  			replace_only =3D 1;
>  		} else
> @@ -1737,6 +1738,7 @@ static void raid5_end_read_request(struct bio * bi,=
 int error)
>  		s =3D sh->sector + rdev->new_data_offset;
>  	else
>  		s =3D sh->sector + rdev->data_offset;
> +
>  	if (uptodate) {
>  		set_bit(R5_UPTODATE, &sh->dev[i].flags);
>  		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
> @@ -1754,6 +1756,7 @@ static void raid5_end_read_request(struct bio * bi,=
 int error)
>  			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
> +			clear_bit(R5_FailedReread, &sh->dev[i].flags);
>  		} else if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
>  			clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
> =20
> @@ -1809,6 +1812,7 @@ static void raid5_end_read_request(struct bio * bi,=
 int error)
>  		else {
>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
> +			clear_bit(R5_FailedReread, &sh->dev[i].flags);
>  			if (!(set_bad
>  			      && test_bit(In_sync, &rdev->flags)
>  			      && rdev_set_badblocks(
> @@ -1852,8 +1856,8 @@ static void raid5_end_write_request(struct bio *bi,=
 int error)
>  		}
>  	}
>  	pr_debug("end_write_request %llu/%d, count %d, uptodate: %d.\n",
> -		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
> -		uptodate);
> +		(unsigned long long)sh->sector, i,
> +		atomic_read(&sh->count), uptodate);
>  	if (i =3D=3D disks) {
>  		BUG();
>  		return;
> @@ -1870,6 +1874,7 @@ static void raid5_end_write_request(struct bio *bi,=
 int error)
>  		if (!uptodate) {
>  			set_bit(WriteErrorSeen, &rdev->flags);
>  			set_bit(R5_WriteError, &sh->dev[i].flags);
> +			clear_bit(R5_FailedOverwrite, &sh->dev[i].flags);
>  			if (!test_and_set_bit(WantReplacement, &rdev->flags))
>  				set_bit(MD_RECOVERY_NEEDED,
>  					&rdev->mddev->recovery);
> @@ -2479,6 +2484,9 @@ handle_failed_stripe(struct r5conf *conf, struct st=
ripe_head *sh,
>  			bitmap_end =3D 1;
>  		}
> =20
> +		if (test_and_clear_bit(R5_FailedOverwrite, &sh->dev[i].flags))
> +			s->failed_overwrite--;;
> +		clear_bit(R5_BadParity,	&sh->dev[i].flags);
>  		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
>  			wake_up(&conf->wait_for_overlap);
> =20
> @@ -2776,6 +2784,10 @@ static void handle_stripe_dirtying(struct r5conf *=
conf,
>  		 * look like rcw is cheaper
>  		 */
>  		rcw =3D 1; rmw =3D 2;
> +	} else if (s->failed > conf->max_degraded) {
> +		/*For write failed-stripe, only use rcw */
> +		rcw =3D 1;
> +		rmw =3D 2;
>  	} else for (i =3D disks; i--; ) {
>  		/* would I have to read this buffer for read_modify_write */
>  		struct r5dev *dev =3D &sh->dev[i];
> @@ -2826,6 +2838,7 @@ static void handle_stripe_dirtying(struct r5conf *c=
onf,
>  	if (rcw <=3D rmw && rcw > 0) {
>  		/* want reconstruct write, but need to get some data */
>  		rcw =3D 0;
> +
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
>  			if (!test_bit(R5_OVERWRITE, &dev->flags) &&
> @@ -2834,8 +2847,13 @@ static void handle_stripe_dirtying(struct r5conf *=
conf,
>  			    !(test_bit(R5_UPTODATE, &dev->flags) ||
>  			      test_bit(R5_Wantcompute, &dev->flags))) {
>  				rcw++;
> -				if (!test_bit(R5_Insync, &dev->flags))
> +				if (!test_bit(R5_Insync, &dev->flags)) {
> +					/* Only for all data-disks !R5_Insync */
> +					if (s->failed > conf->max_degraded &&
> +						!test_bit(STRIPE_FAILED_WRITE, &sh->state))
> +						set_bit(STRIPE_DELAYED, &sh->state);
>  					continue; /* it's a failed drive */
> +				}
>  				if (
>  				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
>  					pr_debug("Read_old block "
> @@ -3268,6 +3286,7 @@ static void analyse_stripe(struct stripe_head *sh, =
struct stripe_head_state *s)
>  		if (rdev) {
>  			is_bad =3D is_badblock(rdev, sh->sector, STRIPE_SECTORS,
>  					     &first_bad, &bad_sectors);
> +
>  			if (s->blocked_rdev =3D=3D NULL
>  			    && (test_bit(Blocked, &rdev->flags)
>  				|| is_bad < 0)) {
> @@ -3279,9 +3298,14 @@ static void analyse_stripe(struct stripe_head *sh,=
 struct stripe_head_state *s)
>  			}
>  		}
>  		clear_bit(R5_Insync, &dev->flags);
> -		if (!rdev)
> -			/* Not in-sync */;
> -		else if (is_bad) {
> +		if (!rdev) {
> +			s->noworked++;
> +			if ((dev->towrite && test_bit(R5_OVERWRITE, &dev->flags)) ||
> +				test_bit(R5_FailedOverwrite, &dev->flags)) {
> +				s->failed_overwrite++;
> +				set_bit(R5_FailedOverwrite, &dev->flags);
> +			}
> +		} else if (is_bad) {
>  			/* also not in-sync */
>  			if (!test_bit(WriteErrorSeen, &rdev->flags) &&
>  			    test_bit(R5_UPTODATE, &dev->flags)) {
> @@ -3291,6 +3315,14 @@ static void analyse_stripe(struct stripe_head *sh,=
 struct stripe_head_state *s)
>  				set_bit(R5_Insync, &dev->flags);
>  				set_bit(R5_ReadError, &dev->flags);
>  			}
> +
> +			if (!test_bit(WriteErrorSeen, &rdev->flags) &&
> +				((dev->towrite && test_bit(R5_OVERWRITE, &dev->flags)) ||
> +				test_bit(R5_FailedOverwrite, &dev->flags))) {
> +				s->failed_overwrite++;
> +				set_bit(R5_FailedOverwrite, &dev->flags);
> +			} else if (i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx)
> +				set_bit(R5_BadParity, &dev->flags);
>  		} else if (test_bit(In_sync, &rdev->flags))
>  			set_bit(R5_Insync, &dev->flags);
>  		else if (sh->sector + STRIPE_SECTORS <=3D rdev->recovery_offset)
> @@ -3342,14 +3374,35 @@ static void analyse_stripe(struct stripe_head *sh=
, struct stripe_head_state *s)
>  			clear_bit(R5_ReadError, &dev->flags);
>  			clear_bit(R5_ReWrite, &dev->flags);
>  		}
> -		if (test_bit(R5_ReadError, &dev->flags))
> -			clear_bit(R5_Insync, &dev->flags);
> +		if (test_bit(R5_ReadError, &dev->flags)) {
> +			/*
> +			 * For failed-stripe which contained badsectors,after writing
> +			 * it should reread to check.
> +			 */
> +			struct md_rdev *rdev2 =3D rcu_dereference(
> +				conf->disks[i].rdev);
> +			if (!is_bad && rdev2 && !test_bit(Faulty, &rdev2->flags) &&
> +				test_bit(R5_UPTODATE, &dev->flags) &&
> +				(test_bit(R5_FailedOverwrite, &dev->flags) ||
> +				 test_bit(R5_BadParity, &dev->flags) ||
> +				 test_bit(R5_FailedReread, &dev->flags))) {
> +				set_bit(STRIPE_FAILED_REREAD, &sh->state);
> +				set_bit(R5_FailedReread, &dev->flags);
> +				clear_bit(R5_FailedOverwrite, &dev->flags);
> +				clear_bit(R5_BadParity, &dev->flags);
> +			} else
> +				clear_bit(R5_Insync, &dev->flags);
> +		}
>  		if (!test_bit(R5_Insync, &dev->flags)) {
>  			if (s->failed < 2)
>  				s->failed_num[s->failed] =3D i;
>  			s->failed++;
>  			if (rdev && !test_bit(Faulty, &rdev->flags))
>  				do_recovery =3D 1;
> +			if (i =3D=3D sh->pd_idx)
> +				s->p_failed =3D 1;
> +			else if (i =3D=3D sh->qd_idx)
> +				s->q_failed =3D 1;
>  		}
>  	}
>  	if (test_bit(STRIPE_SYNCING, &sh->state)) {
> @@ -3424,19 +3477,43 @@ static void handle_stripe(struct stripe_head *sh)
>  	}
> =20
>  	pr_debug("locked=3D%d uptodate=3D%d to_read=3D%d"
> -	       " to_write=3D%d failed=3D%d failed_num=3D%d,%d\n",
> +	       " to_write=3D%d failed=3D%d failed_num=3D%d,%d"
> +	       " failed_overwrite=3D%d p_failed=3D%d q_failed=3D%d\n",
>  	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
> -	       s.failed_num[0], s.failed_num[1]);
> +	       s.failed_num[0], s.failed_num[1], s.failed_overwrite,
> +	       s.p_failed, s.q_failed);
>  	/* check if the array has lost more than max_degraded devices and,
>  	 * if so, some requests might need to be failed.
>  	 */
>  	if (s.failed > conf->max_degraded) {
> -		sh->check_state =3D 0;
> -		sh->reconstruct_state =3D 0;
> -		if (s.to_read+s.to_write+s.written)
> -			handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
> -		if (s.syncing + s.replacing)
> -			handle_failed_sync(conf, sh, &s);
> +		/*
> +		 *Disks which removed or faulty must less or equal max_degraded
> +		 */
> +		if (s.noworked <=3D conf->max_degraded &&
> +			((conf->level < 6 &&
> +			(s.failed - s.failed_overwrite <=3D s.p_failed)) ||
> +			(conf->level =3D=3D 6 &&
> +			(s.failed - s.failed_overwrite <=3D s.p_failed + s.q_failed)))) {
> +			set_bit(STRIPE_FAILED_WRITE, &sh->state);
> +			pr_debug("stripe(%llu) failed, try to recorrect\n",
> +				(unsigned long long)sh->sector);
> +		} else if ((s.failed_overwrite > 0 &&
> +			!test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)))
> +			pr_debug("stripe(%lld) delay for failed-write\n",
> +				(unsigned long long)sh->sector);
> +		else {
> +			sh->check_state =3D 0;
> +			sh->reconstruct_state =3D 0;
> +			clear_bit(STRIPE_FAILED_WRITE, &sh->state);
> +			clear_bit(STRIPE_FAILED_REREAD, &sh->state);
> +			if (s.to_read+s.to_write+s.written) {
> +				handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
> +				pr_debug("handle_failed_stripe:%lld\n",
> +					(unsigned long long)sh->sector);
> +			}
> +			if (s.syncing + s.replacing)
> +				handle_failed_sync(conf, sh, &s);
> +		}
>  	}
> =20
>  	/*
> @@ -3487,6 +3564,8 @@ static void handle_stripe(struct stripe_head *sh)
>  		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
>  		BUG_ON(sh->qd_idx >=3D 0 &&
>  		       !test_bit(R5_UPTODATE, &sh->dev[sh->qd_idx].flags));
> +
> +		clear_bit(STRIPE_FAILED_WRITE, &sh->state);
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
>  			if (test_bit(R5_LOCKED, &dev->flags) &&
> @@ -3504,6 +3583,7 @@ static void handle_stripe(struct stripe_head *sh)
>  		}
>  		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  			s.dec_preread_active =3D 1;
> +
>  	}
> =20
>  	/* Now to consider new write requests and what else, if anything
> @@ -3548,10 +3628,30 @@ static void handle_stripe(struct stripe_head *sh)
>  		clear_bit(STRIPE_SYNCING, &sh->state);
>  	}
> =20
> -	/* If the failed drives are just a ReadError, then we might need
> -	 * to progress the repair/check process
> +	/*
> +	 * If stripe failed because badsector and
> +	 * can write to correct the badsector
> +	 * we used readerr routine which rewrite and reread
>  	 */
> -	if (s.failed <=3D conf->max_degraded && !conf->mddev->ro)
> +	if (test_bit(STRIPE_FAILED_REREAD, &sh->state)) {
> +		for (i =3D disks; i--; ) {
> +			struct r5dev *dev =3D &sh->dev[i];
> +			if (test_bit(R5_FailedReread, &dev->flags)
> +			    && !test_bit(R5_LOCKED, &dev->flags)
> +			    && test_bit(R5_UPTODATE, &dev->flags)) {
> +				/* it just wrote and sucessed,so not
> +				 * necessary to rewrite,only set flag
> +				 */
> +				set_bit(R5_ReWrite, &dev->flags);
> +				set_bit(R5_Wantread, &dev->flags);
> +				set_bit(R5_LOCKED, &dev->flags);
> +				s.locked++;
> +			}
> +		}
> +	} else if (s.failed <=3D conf->max_degraded && !conf->mddev->ro)
> +		/* If the failed drives are just a ReadError, then we might need
> +		 * to progress the repair/check process
> +		 */
>  		for (i =3D 0; i < s.failed; i++) {
>  			struct r5dev *dev =3D &sh->dev[s.failed_num[i]];
>  			if (test_bit(R5_ReadError, &dev->flags)
> @@ -3571,7 +3671,10 @@ static void handle_stripe(struct stripe_head *sh)
>  				}
>  			}
>  		}
> +
> =20
> +
> +
> =20
>  	/* Finish reconstruct operations initiated by the expansion process */
>  	if (sh->reconstruct_state =3D=3D reconstruct_state_result) {
> @@ -3648,7 +3751,7 @@ finish:
>  			if (test_and_clear_bit(R5_MadeGood, &dev->flags)) {
>  				rdev =3D conf->disks[i].rdev;
>  				rdev_clear_badblocks(rdev, sh->sector,
> -						     STRIPE_SECTORS, 0);
> +				     STRIPE_SECTORS, 0);
>  				rdev_dec_pending(rdev, conf->mddev);
>  			}
>  			if (test_and_clear_bit(R5_MadeGoodRepl, &dev->flags)) {
> @@ -3853,7 +3956,6 @@ static void raid5_align_endio(struct bio *bi, int e=
rror)
> =20
> =20
>  	pr_debug("raid5_align_endio : io error...handing IO for a retry\n");
> -
>  	add_bio_to_retry(raid_bi, conf);
>  }
> =20
> @@ -4088,7 +4190,6 @@ static void make_request(struct mddev *mddev, struc=
t bio * bi)
>  	     mddev->reshape_position =3D=3D MaxSector &&
>  	     chunk_aligned_read(mddev,bi))
>  		return;
> -
>  	logical_sector =3D bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
>  	last_sector =3D bi->bi_sector + (bi->bi_size>>9);
>  	bi->bi_next =3D NULL;
> @@ -4586,8 +4687,9 @@ static int  retry_aligned_read(struct r5conf *conf,=
 struct bio *raid_bio)
>  		handled++;
>  	}
>  	remaining =3D raid5_dec_bi_active_stripes(raid_bio);
> -	if (remaining =3D=3D 0)
> +	if (remaining =3D=3D 0)
>  		bio_endio(raid_bio, 0);
> +
>  	if (atomic_dec_and_test(&conf->active_aligned_reads))
>  		wake_up(&conf->wait_for_stripe);
>  	return handled;
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index a9fc249..04709d7 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -251,6 +251,9 @@ struct stripe_head_state {
>  	 */
>  	int syncing, expanding, expanded, replacing;
>  	int locked, uptodate, to_read, to_write, failed, written;
> +	/* Overwrite disks which faulty or removed or contained badsector */
> +	int failed_overwrite;
> +	int noworked;	/*disk faulty or removed*/
>  	int to_fill, compute, req_compute, non_overwrite;
>  	int failed_num[2];
>  	int p_failed, q_failed;
> @@ -298,6 +301,9 @@ enum r5dev_flags {
>  	R5_WantReplace, /* We need to update the replacement, we have read
>  			 * data in, and now is a good time to write it out.
>  			 */
> +	R5_FailedOverwrite, /*overwrite on disk which removed or faulty or had =
badsectors*/
> +	R5_FailedReread,
> +	R5_BadParity,
>  };
> =20
>  /*
> @@ -322,6 +328,8 @@ enum {
>  	STRIPE_COMPUTE_RUN,
>  	STRIPE_OPS_REQ_PENDING,
>  	STRIPE_ON_UNPLUG_LIST,
> +	STRIPE_FAILED_WRITE,
> +	STRIPE_FAILED_REREAD,
>  };
> =20
>  /*


--Sig_/7_O/zx9IcOulIO.4Yl696nU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGJYSjnsnt1WYoG5AQLqdw/+NgsqOkImR0xA4UIF8yzpCKdjZ0HtJKCa
FD3CY6IDZNqJNdolQdZ5X4g7ov/aCszH89Zk3OJpfHEQ7KsEAyDBRF2A7Nkimgcm
KQX1gX3ihVQCPFXP+n6JovZNwUVZwD4tnCN+nqsJFa7aCpsSMo52AsNjHdTraNsM
TdwxqwKL7/kUeIuBRTKY88Oqx4cbmIJnkQ8/sEjStftESGmh0WZ1XrRlMKOjQdG8
LdBnWcL7nT54mSeWQGfa302YnD/5//hd0PredkkQkC5w34F7RYzKQcstFx/xW2b9
ZizPMNNs7xadnBHO/ycZlw7Su82V2AbbN1GedZrLSqF16eL8CB4rCy7TEWjd4E9f
xTkp5U2f5rzwILEct2oToQxnd2GgOSeAb5qM5R8Gmu2o2VQxO6pOA60xMx/uYTK3
i8r0Z5FL0gCGdyoo4y+JBY0+kunK+uriYXcI3k5cNWwHJBGVuqkC/65VpOmRSdIO
yL3bN/OnTujxEpTQzDT9iPkKnCc+8cALHOvxPc/p456eo7EfwuH4TdzzNEAlcQqd
3mZUmadYCF4TL8hWldY1+fsCkBGqZHgjUcHXGyfxfUoB/gCb69OScsO7QZnthJV+
xUsp+hGsANs3qHScLK0xqC/pa53pZCyDZxxk644chGDvZOlFWCDNN25whKGOmZhW
gvxSQMDNigE=
=TenV
-----END PGP SIGNATURE-----

--Sig_/7_O/zx9IcOulIO.4Yl696nU--
