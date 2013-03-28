From: NeilBrown <neilb@suse.de>
Subject: Re: [patch]raid5: make release_stripe lockless
Date: Thu, 28 Mar 2013 11:45:46 +1100
Message-ID: <20130328114546.207e1d74@notabene.brown>
References: <20130318043146.GA7016@kernel.org>
	<CAA9_cmeNpXtR91z8Ni=WBAZmiERvRTJre9Px47S-mzTOoNYucg@mail.gmail.com>
	<20130320005548.GA1343@kernel.org>
	<20130322063617.GA22668@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/q5RBmMHZHSJf1RmFsTlVfr9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130322063617.GA22668@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Dan Williams <djbw@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/q5RBmMHZHSJf1RmFsTlVfr9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Mar 2013 14:36:17 +0800 Shaohua Li <shli@kernel.org> wrote:

>=20
> Subject: raid5: make release_stripe lockless
>=20
> release_stripe still has big lock contention. We just add the stripe to a=
 llist
> without taking device_lock. We let the raid5d thread to do the real stripe
> release, which must hold device_lock anyway. In this way, release_stripe
> doesn't hold any locks.
>=20
> The side effect is the released stripes order is changed. But sounds not =
a big
> deal, stripes are never handled in order. And I thought block layer can a=
lready
> do nice request merge, which means order isn't that important.
>=20
> I kept the unplug release batch, which is unnecessary with this patch fro=
m lock
> contention avoid point of view, and actually if we delete it, the stripe_=
head
> release_list and lru can share storage. But the unplug release batch is a=
lso
> helpful for request merge. We probably can delay wakeup raid5d till unplu=
g, but
> I'm still afraid of the case which raid5d is running.

Looks good, thanks.

One comment:


> +/* should hold conf->device_lock already */
> +static int release_stripe_list(struct r5conf *conf)
> +{
> +	struct stripe_head *sh;
> +	struct llist_node *node;
> +	int count =3D 0;
> +
> +	while (1) {
> +		node =3D llist_del_first(&conf->released_stripes);
> +		if (!node)
> +			break;

Why not:
 llist_for_each_entry(sh, llist_delete_all(&conf->released_stripes), releas=
e_list) {
      clear_bit()
      __release_stripe(conf, sh);
      count++;
 }

??

NeilBrown

> +		sh =3D llist_entry(node, struct stripe_head, release_list);
> +		/*
> +		 * llist_del_first() uses cmpxchg, so implies a memory fence.
> +		 * It's guaranteed the stripe isn't in released_stripes list
> +		 * now, clearing STRIPE_ON_RELEASE_LIST is safe.
> +		 */
> +		clear_bit(STRIPE_ON_RELEASE_LIST, &sh->state);
> +		/*
> +		 * Don't worry the bit is set here, because if the bit is set
> +		 * again, the count is always > 1. This is true for
> +		 * STRIPE_ON_UNPLUG_LIST bit too.
> +		 */
> +		__release_stripe(conf, sh);
> +		count++;
> +	}
> +	return count;
> +}
> +
>  static void release_stripe(struct stripe_head *sh)
>  {
>  	struct r5conf *conf =3D sh->raid_conf;
>  	unsigned long flags;
> +	bool wakeup;
> =20
> +	if (test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
> +		goto slow_path;
> +	wakeup =3D llist_add(&sh->release_list, &conf->released_stripes);
> +	if (wakeup)
> +		md_wakeup_thread(conf->mddev->thread);
> +	return;
> +slow_path:
>  	local_irq_save(flags);
> +	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
>  	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
>  		do_release_stripe(conf, sh);
>  		spin_unlock(&conf->device_lock);
> @@ -515,7 +553,8 @@ get_active_stripe(struct r5conf *conf, s
>  			if (atomic_read(&sh->count)) {
>  				BUG_ON(!list_empty(&sh->lru)
>  				    && !test_bit(STRIPE_EXPANDING, &sh->state)
> -				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state));
> +				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state)
> +				    && !test_bit(STRIPE_ON_RELEASE_LIST, &sh->state));
>  			} else {
>  				if (!test_bit(STRIPE_HANDLE, &sh->state))
>  					atomic_inc(&conf->active_stripes);
> @@ -4128,6 +4167,10 @@ static void raid5_unplug(struct blk_plug
>  			 */
>  			smp_mb__before_clear_bit();
>  			clear_bit(STRIPE_ON_UNPLUG_LIST, &sh->state);
> +			/*
> +			 * STRIPE_ON_RELEASE_LIST could be set here. In that
> +			 * case, the count is always > 1 here
> +			 */
>  			__release_stripe(conf, sh);
>  			cnt++;
>  		}
> @@ -4813,10 +4856,12 @@ static void raid5auxd(struct md_thread *
>  	handled =3D 0;
>  	spin_lock_irq(&conf->device_lock);
>  	while (1) {
> -		int batch_size;
> +		int batch_size, released;
> +
> +		released =3D release_stripe_list(conf);
> =20
>  		batch_size =3D handle_active_stripes(conf, &auxth->work_mask);
> -		if (!batch_size)
> +		if (!batch_size && !released)
>  			break;
>  		handled +=3D batch_size;
>  	}
> @@ -4851,7 +4896,9 @@ static void raid5d(struct md_thread *thr
>  	spin_lock_irq(&conf->device_lock);
>  	while (1) {
>  		struct bio *bio;
> -		int batch_size;
> +		int batch_size, released;
> +
> +		released =3D release_stripe_list(conf);
> =20
>  		if (
>  		    !list_empty(&conf->bitmap_list)) {
> @@ -4876,7 +4923,7 @@ static void raid5d(struct md_thread *thr
>  		}
> =20
>  		batch_size =3D handle_active_stripes(conf, &conf->work_mask);
> -		if (!batch_size)
> +		if (!batch_size && !released)
>  			break;
>  		handled +=3D batch_size;
> =20
> @@ -5471,6 +5518,7 @@ static struct r5conf *setup_conf(struct
>  	INIT_LIST_HEAD(&conf->delayed_list);
>  	INIT_LIST_HEAD(&conf->bitmap_list);
>  	INIT_LIST_HEAD(&conf->inactive_list);
> +	init_llist_head(&conf->released_stripes);
>  	atomic_set(&conf->active_stripes, 0);
>  	atomic_set(&conf->preread_active_stripes, 0);
>  	atomic_set(&conf->active_aligned_reads, 0);
> Index: linux/drivers/md/raid5.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.h	2013-03-21 10:34:56.452256640 +0800
> +++ linux/drivers/md/raid5.h	2013-03-21 10:34:57.256246529 +0800
> @@ -197,6 +197,7 @@ enum reconstruct_states {
>  struct stripe_head {
>  	struct hlist_node	hash;
>  	struct list_head	lru;	      /* inactive_list or handle_list */
> +	struct llist_node	release_list;
>  	struct r5conf		*raid_conf;
>  	short			generation;	/* increments with every
>  						 * reshape */
> @@ -324,6 +325,7 @@ enum {
>  	STRIPE_COMPUTE_RUN,
>  	STRIPE_OPS_REQ_PENDING,
>  	STRIPE_ON_UNPLUG_LIST,
> +	STRIPE_ON_RELEASE_LIST,
>  };
> =20
>  /*
> @@ -462,6 +464,7 @@ struct r5conf {
>  	 */
>  	atomic_t		active_stripes;
>  	struct list_head	inactive_list;
> +	struct llist_head	released_stripes;
>  	wait_queue_head_t	wait_for_stripe;
>  	wait_queue_head_t	wait_for_overlap;
>  	int			inactive_blocked;	/* release of inactive stripes blocked,


--Sig_/q5RBmMHZHSJf1RmFsTlVfr9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUVOSujnsnt1WYoG5AQIPmA//cCNbSiN6l+DIwXypG9FWUVHiJ0kEL7Qy
o7MFlE6JvHcKqm/9rtCl6Bs28P0evty7jrKvaqrgTtIsf7tFwh5vgFi4ywe6ThuW
/oYZlJpeebcrJwQOqrGqZkhWFprvGACxYyWRC7DcqOxwFQBdYu6WarajCqPEJSoC
SpGZoHjHLqP2evD5LEHmO8WhAXEUc1lXqcJRB4maL591248Z1raKqxztwxt1aLiK
ZtlSIupdGHFcQcBi067VcCCmbxflxAb6uheEI8jOVwSs7ElR74/GBCKLFa28i6uK
W73bZAIAdnhrgnf4objhHCPdVGdJWdo0ojoo+VL1ne9ObNXd1/tJbwMa9C0m8+J/
UOncmb3lOgmvil7TZKFzsmFPdER6zTQg7BfmRBkr/EviQKUERhQYh+E8NXB7+tW7
DOKU22/8Iblw/Ygu2bKpSKHXDbMl6/Oadw6UZllyPxXgAIcsKPil/Vd7po57jmV9
/w87BVfQLsQnCS6zVoyfRgCoxgI4DMR2E1ufaMN4HSodXc6b6nUygtqGsg7eCExj
DCiVC15AuxFxGiOy8HOfRAZ+JaCFjLk5sD+yDcRfwaRLXkhIcJtRkT6vXx9+q8qy
HGCvtZcePuFoyOeeYTTP0o9gn7GW1aAxn8n1ru7ULA5h/0j4MLJ/Kh1EI92j5+cP
oTSOdm7O9RU=
=QVa5
-----END PGP SIGNATURE-----

--Sig_/q5RBmMHZHSJf1RmFsTlVfr9--
