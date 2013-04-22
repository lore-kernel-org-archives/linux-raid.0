From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5: add support for rmw writes in raid6
Date: Mon, 22 Apr 2013 14:22:11 +1000
Message-ID: <20130422142211.71a1ae8e@notabene.brown>
References: <20130418005609.6782.15041.stgit@dev279.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yR_+B1KGy/VB=slzgUXYVg0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130418005609.6782.15041.stgit@dev279.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: linux-raid@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>
List-Id: linux-raid.ids

--Sig_/yR_+B1KGy/VB=slzgUXYVg0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Apr 2013 17:56:56 -0700 Dan Williams <djbw@fb.com> wrote:

> From: Kumar Sundararajan <kumar@fb.com>
>=20
> Add support for rmw writes in raid6. This improves small write performanc=
e for most workloads.
> Since there may be some configurations and workloads where rcw always out=
performs rmw,
> this feature is disabled by default. It can be enabled via sysfs. For exa=
mple,
>=20
> 	#echo 1 > /sys/block/md0/md/enable_rmw
>=20
> Signed-off-by: Kumar Sundararajan <kumar@fb.com>
> Signed-off-by: Dan Williams <djbw@fb.com>
> ---
> Hi Neil,
>=20
> We decided to leave the enable in for the few cases where forced-rcw
> outperformed rmw and there may be other cases out there.
>=20
> Thoughts?

- More commentary would help.  The text at the top should explain enough so
  when I read the code I am just verifying the text at the top, not trying =
to
  figure out how it is supposed to work.

- If 'enable_rmw' really is a good idea, then it is possibly a good idea for
  RAID5 to and so should be a separate patch and should work for RAID4/5/6.
  The default for each array type may well be different, but the
  functionality would be the same.

- Can you  explain *why* rcw is sometimes better than rmw even on large
  arrays? Even a fairly hand-wavy arguement would help.  And it would go in
  the comment at the top of the patch that adds enable_rmw.

- patch looks fairly sane assuming that it works - but I don't really know =
if
  it does.  You've reported speeds but haven't told me that you ran 'check'
  after doing each test and it reported no mismatches.  I suspect you did b=
ut
  I'd like to be told.  I'd also like to be told what role 'spare2' plays.

There: my complaints are longer than your explanatory text, so I think I
can stop now :-)

Oh, and the stuff below, that should be above so that it gets captured with
the patch and remains in the git logs of posterity.=20

NeilBrown

P.S. a couple of comments further down.

>=20
> Here are some numbers from Kumar's testing with a 12 disk array:
>=20
>                                      with rmw   rcw only
> 4K random write                    887.0 KB/s  94.4 KB/s
> 64k seq write                      291.5 MB/s 283.2 MB/s
> 64k random write                    16.4 MB/s   7.7 MB/s
> 64K mixed read/write                94.4 MB/s  94.0 MB/s
> (70% random reads/30 % seq writes)   1.6 MB/s   1.8 MB/s
>=20
> --
> Dan
>=20
>  drivers/md/raid5.c |  169 ++++++++++++++++++++++++++++++++++++++++++++++=
++----
>  drivers/md/raid5.h |    4 +
>  2 files changed, 161 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e25520e..c9b6112 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1015,6 +1015,40 @@ static int set_syndrome_sources(struct page **srcs=
, struct stripe_head *sh)
>  	return syndrome_disks;
>  }
> =20
> +static int set_rmw_syndrome_sources(struct page **srcs, struct stripe_he=
ad *sh,
> +	 struct raid5_percpu *percpu, int subtract)

Arg.  Bad intending.

I suspect it would look better if this were two separate functions instead =
of
having a 'subtract' arg, but I'm not sure.


> +{
> +	int disks =3D sh->disks;
> +	int syndrome_disks =3D sh->ddf_layout ? disks : (disks - 2);
> +	int d0_idx =3D raid6_d0(sh);
> +	int count;
> +	int i;
> +
> +	for (i =3D 0; i < disks; i++)
> +		srcs[i] =3D NULL;
> +
> +	count =3D 0;
> +	i =3D d0_idx;
> +	do {
> +		int slot =3D raid6_idx_to_slot(i, sh, &count, syndrome_disks);
> +
> +		if (subtract) {
> +			if (test_bit(R5_Wantdrain, &sh->dev[i].flags))
> +				srcs[slot] =3D sh->dev[i].page;
> +			else if (i =3D=3D sh->pd_idx)
> +				srcs[slot] =3D percpu->spare_page;
> +			else if (i =3D=3D sh->qd_idx)
> +				srcs[slot] =3D percpu->spare_page2;
> +		} else if (sh->dev[i].written || i =3D=3D sh->pd_idx ||
> +			    i =3D=3D sh->qd_idx)
> +			srcs[slot] =3D sh->dev[i].page;
> +
> +		i =3D raid6_next_disk(i, disks);
> +	} while (i !=3D d0_idx);
> +
> +	return syndrome_disks;
> +}
> +
>  static struct dma_async_tx_descriptor *
>  ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
>  {
> @@ -1401,6 +1435,50 @@ ops_run_reconstruct6(struct stripe_head *sh, struc=
t raid5_percpu *percpu,
>  	async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
>  }
> =20
> +static struct dma_async_tx_descriptor *
> +ops_run_rmw(struct stripe_head *sh, struct raid5_percpu *percpu,
> +	    struct dma_async_tx_descriptor *tx, int subtract)
> +{
> +	int pd_idx =3D sh->pd_idx;
> +	int qd_idx =3D sh->qd_idx;
> +	struct page **blocks =3D percpu->scribble;
> +	struct page *xor_dest;
> +	struct r5dev *dev;
> +	struct async_submit_ctl submit;
> +	int count;
> +
> +	pr_debug("%s: stripe %llu\n", __func__,
> +		(unsigned long long)sh->sector);
> +
> +	count =3D set_rmw_syndrome_sources(blocks, sh, percpu, subtract);
> +
> +	init_async_submit(&submit, ASYNC_TX_ACK, tx, NULL, NULL,
> +			  to_addr_conv(sh, percpu));
> +	tx =3D async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submit);
> +
> +	dev =3D &sh->dev[pd_idx];
> +	xor_dest =3D blocks[0] =3D subtract ? percpu->spare_page : dev->page;
> +	blocks[1] =3D subtract ? dev->page : percpu->spare_page;
> +
> +	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
> +			  NULL, sh, to_addr_conv(sh, percpu));
> +	tx =3D async_xor(xor_dest, blocks, 0, 2, STRIPE_SIZE, &submit);
> +
> +	dev =3D &sh->dev[qd_idx];
> +	xor_dest =3D blocks[0] =3D subtract ? percpu->spare_page2 : dev->page;
> +	blocks[1] =3D subtract ? dev->page : percpu->spare_page2;
> +
> +	if (!subtract)
> +		atomic_inc(&sh->count);
> +
> +	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
> +			  subtract ? NULL : ops_complete_reconstruct, sh,
> +			  to_addr_conv(sh, percpu));
> +	tx =3D async_xor(xor_dest, blocks, 0, 2, STRIPE_SIZE, &submit);
> +
> +	return tx;

The continual switching on 'subtract' make this hard to read too.  It is
probably a bit big to duplication ... Is there anything you can do to make =
it
easier to read?


> +}
> +
>  static void ops_complete_check(void *stripe_head_ref)
>  {
>  	struct stripe_head *sh =3D stripe_head_ref;
> @@ -1500,6 +1578,9 @@ static void raid_run_ops(struct stripe_head *sh, un=
signed long ops_request)
>  	if (test_bit(STRIPE_OP_PREXOR, &ops_request))
>  		tx =3D ops_run_prexor(sh, percpu, tx);
> =20
> +	if (test_bit(STRIPE_OP_RMW_SUBTRACT, &ops_request))
> +		tx =3D ops_run_rmw(sh, percpu, tx, 1);
> +
>  	if (test_bit(STRIPE_OP_BIODRAIN, &ops_request)) {
>  		tx =3D ops_run_biodrain(sh, tx);
>  		overlap_clear++;
> @@ -1512,6 +1593,9 @@ static void raid_run_ops(struct stripe_head *sh, un=
signed long ops_request)
>  			ops_run_reconstruct6(sh, percpu, tx);
>  	}
> =20
> +	if (test_bit(STRIPE_OP_RMW, &ops_request))
> +		tx =3D ops_run_rmw(sh, percpu, tx, 0);
> +
>  	if (test_bit(STRIPE_OP_CHECK, &ops_request)) {
>  		if (sh->check_state =3D=3D check_state_run)
>  			ops_run_check_p(sh, percpu);
> @@ -2346,7 +2430,7 @@ static void
>  schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state=
 *s,
>  			 int rcw, int expand)
>  {
> -	int i, pd_idx =3D sh->pd_idx, disks =3D sh->disks;
> +	int i, pd_idx =3D sh->pd_idx, qd_idx =3D sh->qd_idx, disks =3D sh->disk=
s;
>  	struct r5conf *conf =3D sh->raid_conf;
>  	int level =3D conf->level;
> =20
> @@ -2382,13 +2466,15 @@ schedule_reconstruction(struct stripe_head *sh, s=
truct stripe_head_state *s,
>  			if (!test_and_set_bit(STRIPE_FULL_WRITE, &sh->state))
>  				atomic_inc(&conf->pending_full_writes);
>  	} else {
> -		BUG_ON(level =3D=3D 6);
>  		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
>  			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
> +		BUG_ON(level =3D=3D 6 &&
> +			(!(test_bit(R5_UPTODATE, &sh->dev[qd_idx].flags) ||
> +			test_bit(R5_Wantcompute, &sh->dev[qd_idx].flags))));
> =20
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
> -			if (i =3D=3D pd_idx)
> +			if (i =3D=3D pd_idx || i =3D=3D qd_idx)
>  				continue;
> =20
>  			if (dev->towrite &&
> @@ -2404,9 +2490,16 @@ schedule_reconstruction(struct stripe_head *sh, st=
ruct stripe_head_state *s,
>  			/* False alarm - nothing to do */
>  			return;
>  		sh->reconstruct_state =3D reconstruct_state_prexor_drain_run;
> -		set_bit(STRIPE_OP_PREXOR, &s->ops_request);
> -		set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
> -		set_bit(STRIPE_OP_RECONSTRUCT, &s->ops_request);
> +
> +		if (level =3D=3D 6) {
> +			set_bit(STRIPE_OP_RMW_SUBTRACT, &s->ops_request);
> +			set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
> +			set_bit(STRIPE_OP_RMW, &s->ops_request);
> +		} else {
> +			set_bit(STRIPE_OP_PREXOR, &s->ops_request);
> +			set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
> +			set_bit(STRIPE_OP_RECONSTRUCT, &s->ops_request);
> +		}
>  	}
> =20
>  	/* keep the parity disk(s) locked while asynchronous operations
> @@ -2876,15 +2969,14 @@ static void handle_stripe_dirtying(struct r5conf =
*conf,
>  	int rmw =3D 0, rcw =3D 0, i;
>  	sector_t recovery_cp =3D conf->mddev->recovery_cp;
> =20
> -	/* RAID6 requires 'rcw' in current implementation.
> -	 * Otherwise, check whether resync is now happening or should start.
> +	/* Check whether resync is now happening or should start.
>  	 * If yes, then the array is dirty (after unclean shutdown or
>  	 * initial creation), so parity in some stripes might be inconsistent.
>  	 * In this case, we need to always do reconstruct-write, to ensure
>  	 * that in case of drive failure or read-error correction, we
>  	 * generate correct data from the parity.
>  	 */
> -	if (conf->max_degraded =3D=3D 2 ||
> +	if ((conf->max_degraded =3D=3D 2 && !conf->enable_rmw) ||
>  	    (recovery_cp < MaxSector && sh->sector >=3D recovery_cp)) {
>  		/* Calculate the real rcw later - for now make it
>  		 * look like rcw is cheaper
> @@ -2896,7 +2988,7 @@ static void handle_stripe_dirtying(struct r5conf *c=
onf,
>  	} else for (i =3D disks; i--; ) {
>  		/* would I have to read this buffer for read_modify_write */
>  		struct r5dev *dev =3D &sh->dev[i];
> -		if ((dev->towrite || i =3D=3D sh->pd_idx) &&
> +		if ((dev->towrite || i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx) &&
>  		    !test_bit(R5_LOCKED, &dev->flags) &&
>  		    !(test_bit(R5_UPTODATE, &dev->flags) ||
>  		      test_bit(R5_Wantcompute, &dev->flags))) {
> @@ -2907,6 +2999,7 @@ static void handle_stripe_dirtying(struct r5conf *c=
onf,
>  		}
>  		/* Would I have to read this buffer for reconstruct_write */
>  		if (!test_bit(R5_OVERWRITE, &dev->flags) && i !=3D sh->pd_idx &&
> +		    i !=3D sh->qd_idx &&
>  		    !test_bit(R5_LOCKED, &dev->flags) &&
>  		    !(test_bit(R5_UPTODATE, &dev->flags) ||
>  		    test_bit(R5_Wantcompute, &dev->flags))) {
> @@ -2926,7 +3019,8 @@ static void handle_stripe_dirtying(struct r5conf *c=
onf,
>  					  (unsigned long long)sh->sector, rmw);
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
> -			if ((dev->towrite || i =3D=3D sh->pd_idx) &&
> +			if ((dev->towrite || i =3D=3D sh->pd_idx ||
> +			    i =3D=3D sh->qd_idx) &&
>  			    !test_bit(R5_LOCKED, &dev->flags) &&
>  			    !(test_bit(R5_UPTODATE, &dev->flags) ||
>  			    test_bit(R5_Wantcompute, &dev->flags)) &&
> @@ -5360,11 +5454,48 @@ raid5_auxthread_number =3D __ATTR(auxthread_numbe=
r, S_IRUGO|S_IWUSR,
>  				raid5_show_auxthread_number,
>  				raid5_store_auxthread_number);
> =20
> +static ssize_t
> +raid5_show_enable_rmw(struct mddev  *mddev, char *page)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +
> +	if (conf->level =3D=3D 6)
> +		return sprintf(page, "%d\n", conf->enable_rmw);
> +	else
> +		return sprintf(page, "%d\n", 1);
> +}
> +
> +static ssize_t
> +raid5_store_enable_rmw(struct mddev  *mddev, const char *page, size_t le=
n)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +	unsigned long new;
> +
> +	if (!conf)
> +		return -ENODEV;
> +	if (conf->level !=3D 6)
> +		return -EINVAL;
> +
> +	if (len >=3D PAGE_SIZE)
> +		return -EINVAL;
> +
> +	if (kstrtoul(page, 10, &new))
> +		return -EINVAL;
> +	conf->enable_rmw =3D !!new;
> +	return len;
> +}
> +
> +static struct md_sysfs_entry
> +raid5_enable_rmw =3D __ATTR(enable_rmw, S_IRUGO | S_IWUSR,
> +				raid5_show_enable_rmw,
> +				raid5_store_enable_rmw);
> +
>  static struct attribute *raid5_attrs[] =3D  {
>  	&raid5_stripecache_size.attr,
>  	&raid5_stripecache_active.attr,
>  	&raid5_preread_bypass_threshold.attr,
>  	&raid5_auxthread_number.attr,
> +	&raid5_enable_rmw.attr,
>  	NULL,
>  };
>  static struct attribute_group raid5_attrs_group =3D {
> @@ -5400,6 +5531,7 @@ static void raid5_free_percpu(struct r5conf *conf)
>  	for_each_possible_cpu(cpu) {
>  		percpu =3D per_cpu_ptr(conf->percpu, cpu);
>  		safe_put_page(percpu->spare_page);
> +		safe_put_page(percpu->spare_page2);
>  		kfree(percpu->scribble);
>  	}
>  #ifdef CONFIG_HOTPLUG_CPU
> @@ -5433,12 +5565,16 @@ static int raid456_cpu_notify(struct notifier_blo=
ck *nfb, unsigned long action,
>  	case CPU_UP_PREPARE_FROZEN:
>  		if (conf->level =3D=3D 6 && !percpu->spare_page)
>  			percpu->spare_page =3D alloc_page(GFP_KERNEL);
> +		if (conf->level =3D=3D 6 && !percpu->spare_page2)
> +			percpu->spare_page2 =3D alloc_page(GFP_KERNEL);
>  		if (!percpu->scribble)
>  			percpu->scribble =3D kmalloc(conf->scribble_len, GFP_KERNEL);
> =20
>  		if (!percpu->scribble ||
> -		    (conf->level =3D=3D 6 && !percpu->spare_page)) {
> +		    (conf->level =3D=3D 6 && !percpu->spare_page) ||
> +		    (conf->level =3D=3D 6 && !percpu->spare_page2)) {
>  			safe_put_page(percpu->spare_page);
> +			safe_put_page(percpu->spare_page2);
>  			kfree(percpu->scribble);
>  			pr_err("%s: failed memory allocation for cpu%ld\n",
>  			       __func__, cpu);
> @@ -5456,8 +5592,10 @@ static int raid456_cpu_notify(struct notifier_bloc=
k *nfb, unsigned long action,
>  		spin_unlock_irq(&conf->device_lock);
> =20
>  		safe_put_page(percpu->spare_page);
> +		safe_put_page(percpu->spare_page2);
>  		kfree(percpu->scribble);
>  		percpu->spare_page =3D NULL;
> +		percpu->spare_page2 =3D NULL;
>  		percpu->scribble =3D NULL;
>  		break;
>  	default:
> @@ -5496,6 +5634,13 @@ static int raid5_alloc_percpu(struct r5conf *conf)
>  				break;
>  			}
>  			percpu->spare_page =3D spare_page;
> +			spare_page =3D alloc_page(GFP_KERNEL);
> +			if (!spare_page) {
> +				err =3D -ENOMEM;
> +				break;
> +			}
> +			per_cpu_ptr(conf->percpu, cpu)->spare_page2 =3D
> +			    spare_page;
>  		}
>  		scribble =3D kmalloc(conf->scribble_len, GFP_KERNEL);
>  		if (!scribble) {
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 217cb19..fd7ed19 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -334,6 +334,8 @@ enum {
>  	STRIPE_OP_PREXOR,
>  	STRIPE_OP_BIODRAIN,
>  	STRIPE_OP_RECONSTRUCT,
> +	STRIPE_OP_RMW_SUBTRACT,
> +	STRIPE_OP_RMW,
>  	STRIPE_OP_CHECK,
>  };
>  /*
> @@ -437,6 +439,7 @@ struct r5conf {
>  	/* per cpu variables */
>  	struct raid5_percpu {
>  		struct page	*spare_page; /* Used when checking P/Q in raid6 */
> +		struct page	*spare_page2; /* Used for rmw writes in raid6 */
>  		void		*scribble;   /* space for constructing buffer
>  					      * lists and performing address
>  					      * conversions
> @@ -479,6 +482,7 @@ struct r5conf {
>  	struct raid5_auxth	**aux_threads;
>  	/* which CPUs should raid5d thread handle stripes from */
>  	cpumask_t		work_mask;
> +	int			enable_rmw; /* 1 if rmw is enabled for raid6 */
>  };
> =20
>  /*


--Sig_/yR_+B1KGy/VB=slzgUXYVg0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXS68znsnt1WYoG5AQLuDhAApBahG6gGkyqR29BO8C1qAHNjPCNvIfNi
zHPS5yBT07GQY189VJKs3+MAR5HSCisPcmK5t+cnIys5100OnhWpYLstCCjDSZKA
0z/WQqRx9/xbWnfGNl8DdPxtjG712/CQpjHoW2SQhgDzhUc5jcxjvcoIKpzpg+VT
oiLZqbls4HWIoHClzGyQb0iL9rBxdeLJTPjrRzzmrMvU82vQZyWeaukN9XKsEIDf
OBvls7+9hmjaubL8DXqrvM+HC6nim3SDkYfAjkz0rHR8xdaHg1PVfPhBtVAdBgpB
2dyoAcpRD8LODVQHC4sPnxPMYfbolhomjtg4Ro4ZGp1kXbGlXyGEV/rCHydqQ3EK
fQ0yftlYOGrnPZex5aK/uCaNjI8RDhYnq3N3LYTP/emTTaB7DB8YVbnm7R0Mmby3
6UaHlb2QdJXK9CNB6yehlwGGF9nIZNAw95sSSXxxXoVVXvpp/NwXJs6CmPeBZ8Lo
YMx61S2XrnQaYaRiH9S3s6gPTu3eAXRPdqzqlDg1BMV9gN2fo0FFjn7S8x2YIcoS
a8cV8cvfS3+Dp8fZPG4G6rypSB+p8UYH6RQBkSV0o1eGkrUYkrJl9nO4M8q3S9hJ
NLtzZnIEFdKk0ufiRBvUbKuI/h/sGs5i/RdcdT48bNdMzAXDbOrmKChr1+8tZ1qq
V3dp7ZKLc2I=
=Erba
-----END PGP SIGNATURE-----

--Sig_/yR_+B1KGy/VB=slzgUXYVg0--
