From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V1] raid5: Correct some failed-stripe because the
 badsector.
Date: Thu, 7 Feb 2013 13:05:47 +1100
Message-ID: <20130207130547.1a00745e@notabene.brown>
References: <201301141644459529478@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/faL_OxL5sGYE.FwSIj.zk1d"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301141644459529478@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, "=?gb2312?Q?=B1=DF,_=D3=EA?=" <ycbzzjlbyby@gmail.com>, "=?gb2312?Q?=D6=DC,_=F7=E8?=" <qi.g.zhou@gmail.com>
List-Id: linux-raid.ids

--Sig_/faL_OxL5sGYE.FwSIj.zk1d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Jan 2013 16:44:49 +0800 majianpeng <majianpeng@gmail.com> wrote:

> At present for failed-stripes,the write/read operations will only return =
error.But there
> are some failed-stripes which can correct by write operation.
>=20
> For example:
> 1:Create a raid5 by four disks missing/sdb/sdc/sdd.
> 2:If readed  data from sdb and met error,so the stripe is failed.Because
> the stripe was degraded,there is no chance to correct the read-error.
> 3:If later write-stripe contains sdb which overwrite.The stripe has a
> chance to correct.
> 4:If step3 successed, add a spare disk to raid,the raid can be active
> from degraded.
>=20
> There are two methods to compute raid5 parity,rcw and rmw.
> In this situation,it only used rcw.
> There are some conditions for correcting failed-stripe
> A: in a stripe there are only one or two baddisks(maybe faulty/removed/re=
ad-error/write-error).
> B: in a stripe for baddisks exclude parity disks,they must overwrite.
> C:After writing data,for read-error disks it must reread to check.
>=20
>=20
> Tested-by: Qi Zhou <qi.g.zhou@gmail.com>
> Signed-off-by: Yu Bian <ycbzzjlbyby@gmail.com>
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |  133 +++++++++++++++++++++++++++++++++++++++++++++-=
------
>  drivers/md/raid5.h |    9 ++++
>  2 files changed, 125 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 19d77a0..fd8fe58 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -224,6 +224,7 @@ static void do_release_stripe(struct r5conf *conf, st=
ruct stripe_head *sh)
>  			    < IO_THRESHOLD)
>  				md_wakeup_thread(conf->mddev->thread);
>  		atomic_dec(&conf->active_stripes);
> +		clear_bit(STRIPE_FAILED_REREAD, &sh->state);
>  		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
>  			list_add_tail(&sh->lru, &conf->inactive_list);
>  			wake_up(&conf->wait_for_stripe);
> @@ -1800,6 +1801,7 @@ static void raid5_end_read_request(struct bio * bi,=
 int error)
>  			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
> +			clear_bit(R5_FailedReread, &sh->dev[i].flags);
>  		} else if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
>  			clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
> =20
> @@ -1855,6 +1857,7 @@ static void raid5_end_read_request(struct bio * bi,=
 int error)
>  		else {
>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
> +			clear_bit(R5_FailedReread, &sh->dev[i].flags);
>  			if (!(set_bad
>  			      && test_bit(In_sync, &rdev->flags)
>  			      && rdev_set_badblocks(
> @@ -1916,6 +1919,7 @@ static void raid5_end_write_request(struct bio *bi,=
 int error)
>  		if (!uptodate) {
>  			set_bit(WriteErrorSeen, &rdev->flags);
>  			set_bit(R5_WriteError, &sh->dev[i].flags);
> +			clear_bit(R5_FailedOverwrite, &sh->dev[i].flags);
>  			if (!test_and_set_bit(WantReplacement, &rdev->flags))
>  				set_bit(MD_RECOVERY_NEEDED,
>  					&rdev->mddev->recovery);
> @@ -2523,6 +2527,10 @@ handle_failed_stripe(struct r5conf *conf, struct s=
tripe_head *sh,
>  		if (bi)
>  			bitmap_end =3D 1;
> =20
> +		if (test_and_clear_bit(R5_FailedOverwrite, &sh->dev[i].flags))
> +			s->failed_overwrite--;
> +		clear_bit(R5_BadParity, &sh->dev[i].flags);
> +
>  		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
>  			wake_up(&conf->wait_for_overlap);
> =20
> @@ -2838,6 +2846,10 @@ static void handle_stripe_dirtying(struct r5conf *=
conf,
>  		pr_debug("force RCW max_degraded=3D%u, recovery_cp=3D%llu sh->sector=
=3D%llu\n",
>  			 conf->max_degraded, (unsigned long long)recovery_cp,
>  			 (unsigned long long)sh->sector);
> +	} else if (s->failed > conf->max_degraded) {
> +		/*For write failed-stripe, only use rcw */
> +		rcw =3D 1;
> +		rmw =3D 2;
>  	} else for (i =3D disks; i--; ) {
>  		/* would I have to read this buffer for read_modify_write */
>  		struct r5dev *dev =3D &sh->dev[i];
> @@ -2900,8 +2912,13 @@ static void handle_stripe_dirtying(struct r5conf *=
conf,
>  			    !(test_bit(R5_UPTODATE, &dev->flags) ||
>  			      test_bit(R5_Wantcompute, &dev->flags))) {
>  				rcw++;
> -				if (!test_bit(R5_Insync, &dev->flags))
> +				if (!test_bit(R5_Insync, &dev->flags)) {
> +				 /* Only for all data-disks !R5_Insync */
> +					if (s->failed > conf->max_degraded &&
> +						!test_bit(STRIPE_FAILED_WRITE, &sh->state))
> +						set_bit(STRIPE_DELAYED, &sh->state);
>  					continue; /* it's a failed drive */
> +				}
>  				if (
>  				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
>  					pr_debug("Read_old block "
> @@ -3347,9 +3364,14 @@ static void analyse_stripe(struct stripe_head *sh,=
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
> @@ -3359,6 +3381,13 @@ static void analyse_stripe(struct stripe_head *sh,=
 struct stripe_head_state *s)
>  				set_bit(R5_Insync, &dev->flags);
>  				set_bit(R5_ReadError, &dev->flags);
>  			}
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
> @@ -3410,14 +3439,36 @@ static void analyse_stripe(struct stripe_head *sh=
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
> +			struct md_rdev *rdev2 =3D rcu_dereference(conf->disks[i].rdev);
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
> +
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
> +
>  		}
>  	}
>  	if (test_bit(STRIPE_SYNCING, &sh->state)) {
> @@ -3492,19 +3543,46 @@ static void handle_stripe(struct stripe_head *sh)
>  	}
> =20
>  	pr_debug("locked=3D%d uptodate=3D%d to_read=3D%d"
> -	       " to_write=3D%d failed=3D%d failed_num=3D%d,%d\n",
> +		" to_write=3D%d failed=3D%d failed_num=3D%d,%d"
> +		" failed_overwrite=3D%d p_failed=3D%d q_failed=3D%d\n",
>  	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
> -	       s.failed_num[0], s.failed_num[1]);
> +	       s.failed_num[0], s.failed_num[1], s.failed_overwrite,
> +	       s.p_failed, s.q_failed);
> +
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
> +		 if (s.noworked <=3D conf->max_degraded &&
> +			((conf->level < 6 &&
> +			(s.failed - s.failed_overwrite <=3D s.p_failed)) ||
> +			 (conf->level =3D=3D 6 &&
> +			(s.failed - s.failed_overwrite <=3D s.p_failed + s.q_failed)))) {
> +			set_bit(STRIPE_FAILED_WRITE, &sh->state);
> +			pr_debug("stripe(%llu) failed, try to recorrect\n",
> +				(unsigned long long)sh->sector);
> +		} else if ((s.noworked <=3D conf->max_degraded &&
> +			s.failed_overwrite > 0 &&
> +			!test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)))
> +			pr_debug("stripe(%lld) delay for failed-write\n",
> +			(unsigned long long)sh->sector);
> +		 else {
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
> +				 handle_failed_sync(conf, sh, &s);
> +		}
> +
>  	}
> =20
>  	/* Now we check to see if any write operations have recently
> @@ -3525,6 +3603,7 @@ static void handle_stripe(struct stripe_head *sh)
>  		BUG_ON(sh->qd_idx >=3D 0 &&
>  		       !test_bit(R5_UPTODATE, &sh->dev[sh->qd_idx].flags) &&
>  		       !test_bit(R5_Discard, &sh->dev[sh->qd_idx].flags));
> +		clear_bit(STRIPE_FAILED_WRITE, &sh->state);
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
>  			if (test_bit(R5_LOCKED, &dev->flags) &&
> @@ -3620,10 +3699,30 @@ static void handle_stripe(struct stripe_head *sh)
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
> +				&& !test_bit(R5_LOCKED, &dev->flags)
> +				&& test_bit(R5_UPTODATE, &dev->flags)) {
> +				/* it just wrote and sucessed,so not
> +				 * necessary to rewrite,only set flag
> +				 */
> +				set_bit(R5_ReWrite, &dev->flags);
> +				set_bit(R5_Wantread, &dev->flags);
> +				set_bit(R5_LOCKED, &dev->flags);
> +				s.locked++;
> +				}
> +		}
> +	} else if (s.failed <=3D conf->max_degraded && !conf->mddev->ro)
> +		/* If the failed drives are just a ReadError, then we might need
> +		 * to progress the repair/check process
> +		 */
>  		for (i =3D 0; i < s.failed; i++) {
>  			struct r5dev *dev =3D &sh->dev[s.failed_num[i]];
>  			if (test_bit(R5_ReadError, &dev->flags)
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 18b2c4a..72fd934 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -251,6 +251,10 @@ struct stripe_head_state {
>  	 */
>  	int syncing, expanding, expanded, replacing;
>  	int locked, uptodate, to_read, to_write, failed, written;
> +	/* Overwrite disks which faulty or removed or contained badsector */
> +	int failed_overwrite;
> +	int noworked; /*disk faulty or removed*/
> +
>  	int to_fill, compute, req_compute, non_overwrite;
>  	int failed_num[2];
>  	int p_failed, q_failed;
> @@ -299,6 +303,9 @@ enum r5dev_flags {
>  			 * data in, and now is a good time to write it out.
>  			 */
>  	R5_Discard,	/* Discard the stripe */
> +	R5_FailedOverwrite, /*overwrite on disk which removed or faulty or had =
badsectors*/
> +	R5_FailedReread,
> +	R5_BadParity,
>  };
> =20
>  /*
> @@ -323,6 +330,8 @@ enum {
>  	STRIPE_COMPUTE_RUN,
>  	STRIPE_OPS_REQ_PENDING,
>  	STRIPE_ON_UNPLUG_LIST,
> +	STRIPE_FAILED_WRITE,
> +	STRIPE_FAILED_REREAD,
>  };
> =20
>  /*


Thanks for resending with the irrelevant bits removed.

Unfortunately I'm having a hard time following the logic, which means that =
if
I apply the patch it will make the code (even more) unmaintainable.

What I need is :
 - a clear description of what each flag really means
 - a clear description of what each new field in stripe_head_state means.
 - a clear description of the sequencing of operations - when and why it
   decided to take a new path to fix things, how it might decide that it
   cannot after all and fail, etc.

I find some constructs rather odd.  e.g.

+		if (!rdev) {
+			s->noworked++;
+			if ((dev->towrite && test_bit(R5_OVERWRITE, &dev->flags)) ||
+			    test_bit(R5_FailedOverwrite, &dev->flags)) {
+				s->failed_overwrite++;
+				set_bit(R5_FailedOverwrite, &dev->flags);
+			}

I don't follow why the "test_bit(xxx)" is in the if clause.  when would it =
be
set, but ->towrite and R5_OVERWRITE aren't set?

Maybe I'll try again another week, but for the moment, I'm just not making
any headway in understanding you code - sorry.

NeilBrown


--Sig_/faL_OxL5sGYE.FwSIj.zk1d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBURML+znsnt1WYoG5AQL+Ig//WXQuxHTHfBAOt2vD2AKFMAap4EmnYf9/
cGYpkzwlmcshpj6csGMo7tZSFpRcKv+8V6zv8OFQaP8tW2Wn7+7VAECPfXHh94Z1
XJWkXMvCEgx9fle7IK91j5VRn5/NyiyoZ1ItClpqpTD+s+3bTINWBfXSRImiwAfC
UYfv42zMH3ys1LXGeIpE4UFOo6BVOxTN33bnxdL28Vc5QWxFLdDj+IAjXrkQbWWR
vlXe8ngo2lHEjyb1QluzlW/NCFbSu5C8yvzzQ1gs/Mpb7G8fhhyJhOkMSslJXxgR
uAkTiS9lSVf5JTjjRuDj4jpToEogaz9tEDbDMXLymITYYpg/XndjYeB9rWgJ8Dtk
HMNM7jfUOA+rBqxicmlG5j/CwX6orAhL2MwK/BoKvEILAIvdSgLlVSLVO2KsA1/m
PgBTyrqZ3y2TaeYiBLnz+ahhrUhYfr/5J1XWC88omMwZUpt/5c2sCQhnHW+7jWlW
APixe2xCO0Iwkg14WlCNk69se+t1cuoOmyhz2heJ/SqMIijmgYvLncoQwxJNaJ0a
3OYZkhuWCmzLOnlZGl+Uau89BnIbmsGMhu4htHnIHQjJhTrp27Mydg/Faujmi1n3
JcnpwMJ8aONVUhsDj6wNcN1DQ6kMGyMTzE5YfBi84BfY9lnbk1/3tvOJ81C2hdSS
JgkBLMbkwAI=
=C58Q
-----END PGP SIGNATURE-----

--Sig_/faL_OxL5sGYE.FwSIj.zk1d--
