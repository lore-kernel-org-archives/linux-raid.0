Received: from va-2-52.ptr.blmpb.com (va-2-52.ptr.blmpb.com [209.127.231.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCCC32B9BB
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 20:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785443203; cv=none; b=lfBUa/JHUswzBf+AeUs5/zTlXc7Dp6Pq/dQrpg9133lhym6XJ7U93R8QxvcmevYVdSdbVD83Jy7TsXt7xZdo2Mz3Di5HLefEboiI5FiKt/q1oyawwa0qUmFd3SFDfz++IXJaveTyDi+qk5cfgvE7t/f6SZIXHxU8yc8YBLEG824=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785443203; c=relaxed/simple;
	bh=K3UQNVXGvyIGO+QGy/ooDsInQ0BM5H7YPf3jionnrfM=;
	h=Subject:Date:Content-Type:In-Reply-To:To:Cc:From:Message-Id:
	 Mime-Version:References; b=k/smt4cM0vIjgB/+/KLdl4fJcV7XYQEeqPRG7JpqtqH0+AnnUCFA/gSVOQ0EvPuC9F+C3iBK8NXb3fik7FUwwWnHcR6oFkGLJMKd+ohmnYZSxqJw3P/JOP2FfFgOjjQKA/4a9YER2q4SMyw7otiJ6slCxwTgfj62g2PujpDy/qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=R98mOjDO; arc=none smtp.client-ip=209.127.231.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="R98mOjDO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785443194;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=QKkzyDu4kUhnd5XQaRbofsBlavyZM6679M1Tz5+J91A=;
 b=R98mOjDOPrEv962nROZaKBY2dVDRNUgDpsT8pPLCYV6nYJIlMYnMwBLeSj4HQdJ7EyJO/O
 7RPPbPumQIp0pWwK5bMuhMbcBij4/JWoNXy0sAHU64V84DWTkDO/jlD+K5sEI0YIT8Gn7o
 MHe3HYLqbTEC7QhYSBinH8AcOqh82t+UzvGlvU6Y4A7q2s568AKBYZP2PABUu3SbL22rO1
 dpTw1nK+cwxuiM2kPOfR6Dihkp5ckFyYbqnrLAaqykfCKnBgQVNx/8DdjIb437MSfUq1Ua
 VkXNZVuFRF6buwd4DpTCmz9AphpzHniWvfP9wu2mwBsksF6gIHNLyX/kIAo4LA==
Subject: Re: [PATCH 2/6] md/raid5: size stripe-cache hash locks from the CPU count
Date: Fri, 31 Jul 2026 04:26:29 +0800
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 20:26:32 +0000
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260710132346.7295-3-nishidafmly@gmail.com>
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a6bb379+637903+vger.kernel.org+yukuai@fygo.io>
To: "Hiroshi Nishida" <nishidafmly@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <a5a5f23e-8617-4b2a-a541-54e89cafd589@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260710132346.7295-1-nishidafmly@gmail.com> <20260710132346.7295-3-nishidafmly@gmail.com>

Hi,

=E5=9C=A8 2026/7/10 21:23, Hiroshi Nishida =E5=86=99=E9=81=93:
> The stripe cache hash is striped across NR_STRIPE_HASH_LOCKS spinlocks
> (see stripe_hash_locks_hash()).  The count has been a fixed 8 since the
> per-hash locking was introduced.  On many-core servers 8 buckets is
> small: stripe cache lookup and allocation contend on the same few locks
> once the CPU count greatly exceeds the bucket count.  Simply raising the
> compile-time constant, however, would grow three per-array arrays in
> struct r5conf (hash_locks, inactive_list, temp_inactive_list) for every
> array unconditionally, spending memory on small systems that see no
> benefit from the extra buckets.
>
> Make the count a per-array value, sized when the array is created and
> selected by a new nr_stripe_hash_locks module parameter:
>
>    - 0 (the default) auto-sizes the count from the online CPU count,
>      rounded up to a power of two and clamped to the range
>      [NR_STRIPE_HASH_LOCKS_DEFAULT (8), NR_STRIPE_HASH_LOCKS_MAX (32)].
>      A machine with 8 or fewer CPUs therefore keeps the historical 8 and
>      the historical memory footprint; wider machines stripe the locks
>      further with no user action and no recompile.

Please leave the default value unchanged.

>
>    - A non-zero value overrides the heuristic (still rounded up to a
>      power of two and capped at 32), for administrators who want to pin
>      it.
>
>    - The maximum is 32 because raid5_quiesce() takes every hash lock plus
>      device_lock at once via lock_all_device_hash_locks_irq(); that holds
>      nr_hash_locks + 1 locks simultaneously, which must stay below
>      MAX_LOCK_DEPTH (48) so the held-lock array does not overflow when
>      lockdep is enabled.
>
>    - The three per-array arrays are now sized with kcalloc(nr_hash_locks)
>      when the array is created, so a system that ends up with 8 locks use=
s
>      no more memory than before.  The embedded and on-stack
>      temp_inactive_list arrays (r5worker, raid5_plug_cb) are sized to the
>      NR_STRIPE_HASH_LOCKS_MAX upper bound; only nr_hash_locks entries are
>      ever initialised or used.
>
> The value is resolved when an array is created, so existing arrays keep
> their lock count and a value written later applies only to arrays
> created afterwards.
>
> Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
> ---
>   drivers/md/raid5-cache.c |  2 +-
>   drivers/md/raid5.c       | 84 +++++++++++++++++++++++++++++-----------
>   drivers/md/raid5.h       | 31 ++++++++++-----
>   3 files changed, 84 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 7b7546bfa21f..9cf58a13250a 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -38,7 +38,7 @@
>   /* start flush with these full stripes */
>   #define R5C_FULL_STRIPE_FLUSH_BATCH(conf) (conf->max_nr_stripes / 4)
>   /* reclaim stripes in groups */
> -#define R5C_RECLAIM_STRIPE_GROUP (NR_STRIPE_HASH_LOCKS * 2)
> +#define R5C_RECLAIM_STRIPE_GROUP (NR_STRIPE_HASH_LOCKS_DEFAULT * 2)
>  =20
>   /*
>    * We only need 2 bios per I/O unit to make progress, but ensure we
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d8807114a693..7f72981121fd 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -67,6 +67,11 @@
>  =20
>   #define RAID5_MAX_REQ_STRIPES 256
>  =20
> +static unsigned int nr_stripe_hash_locks;
> +module_param(nr_stripe_hash_locks, uint, 0644);
> +MODULE_PARM_DESC(nr_stripe_hash_locks,
> +		 "Number of spinlocks the stripe cache hash is striped across, rounded=
 up to a power of two and capped at 32.  0 (the default) auto-sizes it from=
 the online CPU count (never below 8); a non-zero value overrides that.  La=
rger values reduce lock contention on many-core systems at a small per-arra=
y memory cost.  Read when an array is created");

This is not a per array value, instead this is a global value for all array=
, and
I don't like it. Please consider a new sysfs API for stripe hash locks, and=
 update
mdadm to set the value while creating new array. You can leave the auto-siz=
es logical
to user space.

> +
>   static bool devices_handle_discard_safely =3D false;
>   module_param(devices_handle_discard_safely, bool, 0644);
>   MODULE_PARM_DESC(devices_handle_discard_safely,
> @@ -83,7 +88,7 @@ static inline struct hlist_head *stripe_hash(struct r5c=
onf *conf, sector_t sect)
>  =20
>   static inline int stripe_hash_locks_hash(struct r5conf *conf, sector_t =
sect)
>   {
> -	return (sect >> RAID5_STRIPE_SHIFT(conf)) & STRIPE_HASH_LOCKS_MASK;
> +	return (sect >> RAID5_STRIPE_SHIFT(conf)) & conf->hash_locks_mask;
>   }
>  =20
>   static inline void lock_device_hash_lock(struct r5conf *conf, int hash)
> @@ -105,7 +110,7 @@ static inline void lock_all_device_hash_locks_irq(str=
uct r5conf *conf)
>   {
>   	int i;
>   	spin_lock_irq(conf->hash_locks);
> -	for (i =3D 1; i < NR_STRIPE_HASH_LOCKS; i++)
> +	for (i =3D 1; i < conf->nr_hash_locks; i++)
>   		spin_lock_nest_lock(conf->hash_locks + i, conf->hash_locks);
>   	spin_lock(&conf->device_lock);
>   }
> @@ -115,7 +120,7 @@ static inline void unlock_all_device_hash_locks_irq(s=
truct r5conf *conf)
>   {
>   	int i;
>   	spin_unlock(&conf->device_lock);
> -	for (i =3D NR_STRIPE_HASH_LOCKS - 1; i; i--)
> +	for (i =3D conf->nr_hash_locks - 1; i; i--)
>   		spin_unlock(conf->hash_locks + i);
>   	spin_unlock_irq(conf->hash_locks);
>   }
> @@ -317,7 +322,7 @@ static void __release_stripe(struct r5conf *conf, str=
uct stripe_head *sh,
>   }
>  =20
>   /*
> - * @hash could be NR_STRIPE_HASH_LOCKS, then we have a list of inactive_=
list
> + * @hash could be conf->nr_hash_locks, then we have a list of inactive_l=
ist
>    *
>    * Be careful: Only one task can add/delete stripes from temp_inactive_=
list at
>    * given time. Adding stripes only takes device lock, while deleting st=
ripes
> @@ -331,9 +336,9 @@ static void release_inactive_stripe_list(struct r5con=
f *conf,
>   	bool do_wakeup =3D false;
>   	unsigned long flags;
>  =20
> -	if (hash =3D=3D NR_STRIPE_HASH_LOCKS) {
> -		size =3D NR_STRIPE_HASH_LOCKS;
> -		hash =3D NR_STRIPE_HASH_LOCKS - 1;
> +	if (hash =3D=3D conf->nr_hash_locks) {
> +		size =3D conf->nr_hash_locks;
> +		hash =3D conf->nr_hash_locks - 1;
>   	} else
>   		size =3D 1;
>   	while (size) {
> @@ -2408,7 +2413,7 @@ static int grow_one_stripe(struct r5conf *conf, gfp=
_t gfp)
>   		return 0;
>   	}
>   	sh->hash_lock_index =3D
> -		conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS;
> +		conf->max_nr_stripes % conf->nr_hash_locks;
>   	/* we just created an active stripe so... */
>   	atomic_inc(&conf->active_stripes);
>  =20
> @@ -2612,8 +2617,8 @@ static int resize_stripes(struct r5conf *conf, int =
newsize)
>   		nsh->hash_lock_index =3D hash;
>   		free_stripe(conf->slab_cache, osh);
>   		cnt++;
> -		if (cnt >=3D conf->max_nr_stripes / NR_STRIPE_HASH_LOCKS +
> -		    !!((conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS) > hash)) {
> +		if (cnt >=3D conf->max_nr_stripes / conf->nr_hash_locks +
> +		    !!((conf->max_nr_stripes % conf->nr_hash_locks) > hash)) {
>   			hash++;
>   			cnt =3D 0;
>   		}
> @@ -2697,7 +2702,7 @@ static int resize_stripes(struct r5conf *conf, int =
newsize)
>   static int drop_one_stripe(struct r5conf *conf)
>   {
>   	struct stripe_head *sh;
> -	int hash =3D (conf->max_nr_stripes - 1) & STRIPE_HASH_LOCKS_MASK;
> +	int hash =3D (conf->max_nr_stripes - 1) & conf->hash_locks_mask;
>  =20
>   	spin_lock_irq(conf->hash_locks + hash);
>   	sh =3D get_free_stripe(conf, hash);
> @@ -5638,7 +5643,7 @@ static struct stripe_head *__get_priority_stripe(st=
ruct r5conf *conf, int group)
>   struct raid5_plug_cb {
>   	struct blk_plug_cb	cb;
>   	struct list_head	list;
> -	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
> +	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS_MAX];
>   };
>  =20
>   static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule=
)
> @@ -5674,7 +5679,7 @@ static void raid5_unplug(struct blk_plug_cb *blk_cb=
, bool from_schedule)
>   		spin_unlock_irq(&conf->device_lock);
>   	}
>   	release_inactive_stripe_list(conf, cb->temp_inactive_list,
> -				     NR_STRIPE_HASH_LOCKS);
> +				     conf->nr_hash_locks);
>   	if (!mddev_is_dm(mddev))
>   		trace_block_unplug(mddev->gendisk->queue, cnt, !from_schedule);
>   	kfree(cb);
> @@ -5698,7 +5703,7 @@ static void release_stripe_plug(struct mddev *mddev=
,
>   	if (cb->list.next =3D=3D NULL) {
>   		int i;
>   		INIT_LIST_HEAD(&cb->list);
> -		for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> +		for (i =3D 0; i < NR_STRIPE_HASH_LOCKS_MAX; i++)
>   			INIT_LIST_HEAD(cb->temp_inactive_list + i);
>   	}
>  =20
> @@ -6732,10 +6737,10 @@ static int handle_active_stripes(struct r5conf *c=
onf, int group,
>   		batch[batch_size++] =3D sh;
>  =20
>   	if (batch_size =3D=3D 0) {
> -		for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> +		for (i =3D 0; i < conf->nr_hash_locks; i++)
>   			if (!list_empty(temp_inactive_list + i))
>   				break;
> -		if (i =3D=3D NR_STRIPE_HASH_LOCKS) {
> +		if (i =3D=3D conf->nr_hash_locks) {
>   			spin_unlock_irq(&conf->device_lock);
>   			log_flush_stripe_to_raid(conf);
>   			spin_lock_irq(&conf->device_lock);
> @@ -6746,7 +6751,7 @@ static int handle_active_stripes(struct r5conf *con=
f, int group,
>   	spin_unlock_irq(&conf->device_lock);
>  =20
>   	release_inactive_stripe_list(conf, temp_inactive_list,
> -				     NR_STRIPE_HASH_LOCKS);
> +				     conf->nr_hash_locks);
>  =20
>   	r5l_flush_stripe_to_raid(conf->log);
>   	if (release_inactive) {
> @@ -7353,7 +7358,7 @@ static int alloc_thread_groups(struct r5conf *conf,=
 int cnt, int *group_cnt,
>   			worker->group =3D group;
>   			INIT_WORK(&worker->work, raid5_do_work);
>  =20
> -			for (k =3D 0; k < NR_STRIPE_HASH_LOCKS; k++)
> +			for (k =3D 0; k < conf->nr_hash_locks; k++)
>   				INIT_LIST_HEAD(worker->temp_inactive_list + k);
>   		}
>   	}
> @@ -7448,6 +7453,9 @@ static void free_conf(struct r5conf *conf)
>   	kfree(conf->disks);
>   	bioset_exit(&conf->bio_split);
>   	kfree(conf->stripe_hashtbl);
> +	kfree(conf->hash_locks);
> +	kfree(conf->inactive_list);
> +	kfree(conf->temp_inactive_list);
>   	kfree(conf->pending_data);
>  =20
>   	mempool_destroy(conf->ctx_pool);
> @@ -7565,6 +7573,38 @@ static struct r5conf *setup_conf(struct mddev *mdd=
ev)
>   	if (conf =3D=3D NULL)
>   		goto abort;
>  =20
> +	/*
> +	 * Size the stripe cache hash-lock striping per array.  The
> +	 * nr_stripe_hash_locks module parameter selects the count: 0 (the
> +	 * default) auto-sizes it from the online CPU count so busier machines
> +	 * stripe the locks wider, while a non-zero value overrides that.  The
> +	 * result is rounded up to a power of two (the hash uses it as a
> +	 * bitmask) and capped at NR_STRIPE_HASH_LOCKS_MAX; the auto path also
> +	 * keeps at least the historical NR_STRIPE_HASH_LOCKS_DEFAULT so small
> +	 * systems are unchanged.  Allocating per array means an untuned system
> +	 * uses no more memory than before.
> +	 */
> +	if (nr_stripe_hash_locks =3D=3D 0)
> +		conf->nr_hash_locks =3D clamp_t(unsigned int,
> +				roundup_pow_of_two(num_online_cpus()),
> +				NR_STRIPE_HASH_LOCKS_DEFAULT,
> +				NR_STRIPE_HASH_LOCKS_MAX);
> +	else
> +		conf->nr_hash_locks =3D roundup_pow_of_two(
> +				min_t(unsigned int, nr_stripe_hash_locks,
> +				      NR_STRIPE_HASH_LOCKS_MAX));
> +	conf->hash_locks_mask =3D conf->nr_hash_locks - 1;
> +	conf->hash_locks =3D kcalloc(conf->nr_hash_locks,
> +				   sizeof(*conf->hash_locks), GFP_KERNEL);
> +	conf->inactive_list =3D kcalloc(conf->nr_hash_locks,
> +				      sizeof(*conf->inactive_list), GFP_KERNEL);
> +	conf->temp_inactive_list =3D kcalloc(conf->nr_hash_locks,
> +					   sizeof(*conf->temp_inactive_list),
> +					   GFP_KERNEL);
> +	if (!conf->hash_locks || !conf->inactive_list ||
> +	    !conf->temp_inactive_list)
> +		goto abort;
> +
>   #if PAGE_SIZE !=3D DEFAULT_STRIPE_SIZE
>   	conf->stripe_size =3D DEFAULT_STRIPE_SIZE;
>   	conf->stripe_shift =3D ilog2(DEFAULT_STRIPE_SIZE) - 9;
> @@ -7646,13 +7686,13 @@ static struct r5conf *setup_conf(struct mddev *md=
dev)
>   	 * lockdep that we know what we are doing.
>   	 */
>   	spin_lock_init(conf->hash_locks);
> -	for (i =3D 1; i < NR_STRIPE_HASH_LOCKS; i++)
> +	for (i =3D 1; i < conf->nr_hash_locks; i++)
>   		spin_lock_init(conf->hash_locks + i);
>  =20
> -	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> +	for (i =3D 0; i < conf->nr_hash_locks; i++)
>   		INIT_LIST_HEAD(conf->inactive_list + i);
>  =20
> -	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> +	for (i =3D 0; i < conf->nr_hash_locks; i++)
>   		INIT_LIST_HEAD(conf->temp_inactive_list + i);
>  =20
>   	atomic_set(&conf->r5c_cached_full_stripes, 0);
> @@ -7729,7 +7769,7 @@ static struct r5conf *setup_conf(struct mddev *mdde=
v)
>   	}
>   	memory =3D conf->min_nr_stripes * (sizeof(struct stripe_head) +
>   		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
> -	atomic_set(&conf->empty_inactive_list_nr, NR_STRIPE_HASH_LOCKS);
> +	atomic_set(&conf->empty_inactive_list_nr, conf->nr_hash_locks);
>   	if (grow_stripes(conf, conf->min_nr_stripes)) {
>   		pr_warn("md/raid:%s: couldn't allocate %dkB for buffers\n",
>   			mdname(mddev), memory);
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index cb5feae04db2..10c45fa22955 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -492,18 +492,27 @@ struct disk_info {
>   #define HASH_MASK		(NR_HASH - 1)
>   #define MAX_STRIPE_BATCH	8
>  =20
> -/* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
> - * This is because we sometimes take all the spinlocks
> - * and creating that much locking depth can cause
> - * problems.
> +/*
> + * The stripe cache hash is striped across a power-of-two number of spin=
locks,
> + * chosen per array from the nr_stripe_hash_locks module parameter and s=
tored
> + * in r5conf->nr_hash_locks (with the mask in r5conf->hash_locks_mask). =
 Sizing
> + * the locks per array means systems that do not tune it pay no extra me=
mory
> + * beyond the historical default.
> + *
> + * NR_STRIPE_HASH_LOCKS_DEFAULT is that historical value, used when the =
module
> + * parameter is left alone.  NR_STRIPE_HASH_LOCKS_MAX bounds the count: =
taking
> + * all the hash locks at once in lock_all_device_hash_locks_irq(), plus
> + * device_lock, must keep the held lock count below MAX_LOCK_DEPTH (48) =
with
> + * lockdep enabled, and it also sizes the embedded/on-stack temp_inactiv=
e_list
> + * arrays.
>    */
> -#define NR_STRIPE_HASH_LOCKS 8
> -#define STRIPE_HASH_LOCKS_MASK (NR_STRIPE_HASH_LOCKS - 1)
> +#define NR_STRIPE_HASH_LOCKS_DEFAULT	8
> +#define NR_STRIPE_HASH_LOCKS_MAX	32
>  =20
>   struct r5worker {
>   	struct work_struct work;
>   	struct r5worker_group *group;
> -	struct list_head temp_inactive_list[NR_STRIPE_HASH_LOCKS];
> +	struct list_head temp_inactive_list[NR_STRIPE_HASH_LOCKS_MAX];
>   	bool working;
>   };
>  =20
> @@ -570,7 +579,9 @@ struct raid5_percpu {
>   struct r5conf {
>   	struct hlist_head	*stripe_hashtbl;
>   	/* only protect corresponding hash list and inactive_list */
> -	spinlock_t		hash_locks[NR_STRIPE_HASH_LOCKS];
> +	spinlock_t		*hash_locks;
> +	int			nr_hash_locks;	 /* power of two, <=3D NR_STRIPE_HASH_LOCKS_MAX */
> +	int			hash_locks_mask; /* nr_hash_locks - 1 */
>   	struct mddev		*mddev;
>   	int			chunk_sectors;
>   	int			level, algorithm, rmw_level;
> @@ -650,7 +661,7 @@ struct r5conf {
>   	 * Free stripes pool
>   	 */
>   	atomic_t		active_stripes;
> -	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
> +	struct list_head	*inactive_list;
>  =20
>   	atomic_t		r5c_cached_full_stripes;
>   	struct list_head	r5c_full_stripe_list;
> @@ -675,7 +686,7 @@ struct r5conf {
>   	 * the new thread here until we fully activate the array.
>   	 */
>   	struct md_thread __rcu	*thread;
> -	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
> +	struct list_head	*temp_inactive_list;
>   	struct r5worker_group	*worker_groups;
>   	int			group_cnt;
>   	int			worker_cnt_per_group;

--=20
Thanks,
Kuai
