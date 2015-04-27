From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] md/raid5: exclusive wait_for_stripe
Date: Mon, 27 Apr 2015 10:24:05 +1000
Message-ID: <20150427102405.40dc2ada@notabene.brown>
References: <1429882744-22655-1-git-send-email-yuanhan.liu@linux.intel.com>
	<1429882744-22655-2-git-send-email-yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/NDPMbUGQVWMebP=dsXILQkz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429882744-22655-2-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NDPMbUGQVWMebP=dsXILQkz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Apr 2015 21:39:04 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> I noticed heavy spin lock contention at get_active_stripe() with fsmark
> multiple thread write workloads.
>=20
> Here is how this hot contention comes from. We have limited stripes, and
> it's a multiple thread write workload. Hence, those stripes will be taken
> soon, which puts later processes to sleep for waiting free stripes. When
> enough stripes(> 1/4 total stripes) are released, all process are woken,
> trying to get the lock. But there is one only being able to get this lock
> for each hash lock, making other processes spinning out there for acquiri=
ng
> the lock.
>=20
> Thus, it's effectiveless to wakeup all processes and let them battle for
> a lock that permits one to access only each time. Instead, we could make
> it be a exclusive wake up: wake up one process only. That avoids the heavy
> spin lock contention naturally.
>=20
> Here are some test results I have got with this patch applied(all test run
> 3 times):
>=20
> `fsmark.files_per_sec'
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> next-20150317                 this patch
> -------------------------     -------------------------
> metric_value     =C2=B1stddev      metric_value     =C2=B1stddev     chan=
ge      testbox/benchmark/testcase-params
> -------------------------     -------------------------   --------     --=
----------------------------
>       25.600     =C2=B10.0              92.700     =C2=B12.5          262=
.1%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-btrfs-4M-30G-fsyncBeforeClose
>       25.600     =C2=B10.0              77.800     =C2=B10.6          203=
.9%     ivb44/fsmark/1x-64t-9BRD_6G-RAID5-btrfs-4M-30G-fsyncBeforeClose
>       32.000     =C2=B10.0              93.800     =C2=B11.7          193=
.1%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-ext4-4M-30G-fsyncBeforeClose
>       32.000     =C2=B10.0              81.233     =C2=B11.7          153=
.9%     ivb44/fsmark/1x-64t-9BRD_6G-RAID5-ext4-4M-30G-fsyncBeforeClose
>       48.800     =C2=B114.5             99.667     =C2=B12.0          104=
.2%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-xfs-4M-30G-fsyncBeforeClose
>        6.400     =C2=B10.0              12.800     =C2=B10.0          100=
.0%     ivb44/fsmark/1x-64t-3HDD-RAID5-btrfs-4M-40G-fsyncBeforeClose
>       63.133     =C2=B18.2              82.800     =C2=B10.7           31=
.2%     ivb44/fsmark/1x-64t-9BRD_6G-RAID5-xfs-4M-30G-fsyncBeforeClose
>      245.067     =C2=B10.7             306.567     =C2=B17.9           25=
.1%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-f2fs-4M-30G-fsyncBeforeClose
>       17.533     =C2=B10.3              21.000     =C2=B10.8           19=
.8%     ivb44/fsmark/1x-1t-3HDD-RAID5-xfs-4M-40G-fsyncBeforeClose
>      188.167     =C2=B11.9             215.033     =C2=B13.1           14=
.3%     ivb44/fsmark/1x-1t-4BRD_12G-RAID5-btrfs-4M-30G-NoSync
>      254.500     =C2=B11.8             290.733     =C2=B12.4           14=
.2%     ivb44/fsmark/1x-1t-9BRD_6G-RAID5-btrfs-4M-30G-NoSync
>=20
> `time.system_time'
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> next-20150317                 this patch
> -------------------------    -------------------------
> metric_value     =C2=B1stddev     metric_value     =C2=B1stddev     chang=
e       testbox/benchmark/testcase-params
> -------------------------    -------------------------    --------     --=
----------------------------
>     7235.603     =C2=B11.2             185.163     =C2=B11.9          -97=
.4%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-btrfs-4M-30G-fsyncBeforeClose
>     7666.883     =C2=B12.9             202.750     =C2=B11.0          -97=
.4%     ivb44/fsmark/1x-64t-9BRD_6G-RAID5-btrfs-4M-30G-fsyncBeforeClose
>    14567.893     =C2=B10.7             421.230     =C2=B10.4          -97=
.1%     ivb44/fsmark/1x-64t-3HDD-RAID5-btrfs-4M-40G-fsyncBeforeClose
>     3697.667     =C2=B114.0            148.190     =C2=B11.7          -96=
.0%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-xfs-4M-30G-fsyncBeforeClose
>     5572.867     =C2=B13.8             310.717     =C2=B11.4          -94=
.4%     ivb44/fsmark/1x-64t-9BRD_6G-RAID5-ext4-4M-30G-fsyncBeforeClose
>     5565.050     =C2=B10.5             313.277     =C2=B11.5          -94=
.4%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-ext4-4M-30G-fsyncBeforeClose
>     2420.707     =C2=B117.1            171.043     =C2=B12.7          -92=
.9%     ivb44/fsmark/1x-64t-9BRD_6G-RAID5-xfs-4M-30G-fsyncBeforeClose
>     3743.300     =C2=B14.6             379.827     =C2=B13.5          -89=
.9%     ivb44/fsmark/1x-64t-3HDD-RAID5-ext4-4M-40G-fsyncBeforeClose
>     3308.687     =C2=B16.3             363.050     =C2=B12.0          -89=
.0%     ivb44/fsmark/1x-64t-3HDD-RAID5-xfs-4M-40G-fsyncBeforeClose
>=20
> Where,
>=20
>      1x: where 'x' means iterations or loop, corresponding to the 'L' opt=
ion of fsmark
>=20
>      1t, 64t: where 't' means thread
>=20
>      4M: means the single file size, corresponding to the '-s' option of =
fsmark
>      40G, 30G, 120G: means the total test size
>=20
>      4BRD_12G: BRD is the ramdisk, where '4' means 4 ramdisk, and where '=
12G' means
>                the size of one ramdisk. So, it would be 48G in total. And=
 we made a
>                raid on those ramdisk
>=20
> As you can see, though there are no much performance gain for hard disk
> workload, the system time is dropped heavily, up to 97%. And as expected,
> the performance increased a lot, up to 260%, for fast device(ram disk).
>=20
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  drivers/md/raid5.c | 46 +++++++++++++++++++++++++++++++++++-----------
>  drivers/md/raid5.h |  2 +-
>  2 files changed, 36 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b7e385f..2d8fcc1 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -344,7 +344,8 @@ static void release_inactive_stripe_list(struct r5con=
f *conf,
>  					 int hash)
>  {
>  	int size;
> -	bool do_wakeup =3D false;
> +	bool do_wakeup[NR_STRIPE_HASH_LOCKS] =3D { false, };

I think I'd rather use an 'unsigned long' and set bits.

> +	int i =3D 0;
>  	unsigned long flags;
> =20
>  	if (hash =3D=3D NR_STRIPE_HASH_LOCKS) {
> @@ -365,17 +366,22 @@ static void release_inactive_stripe_list(struct r5c=
onf *conf,
>  			    !list_empty(list))
>  				atomic_dec(&conf->empty_inactive_list_nr);
>  			list_splice_tail_init(list, conf->inactive_list + hash);
> -			do_wakeup =3D true;
> +			do_wakeup[size - 1] =3D true;

... so this becomes
	do_wakeup |=3D 1 << (size - 1);

>  			spin_unlock_irqrestore(conf->hash_locks + hash, flags);
>  		}
>  		size--;
>  		hash--;
>  	}
> =20
> -	if (do_wakeup) {
> -		wake_up(&conf->wait_for_stripe);
> -		if (conf->retry_read_aligned)
> -			md_wakeup_thread(conf->mddev->thread);
> +	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++) {
> +		bool waked_thread =3D false;
> +		if (do_wakeup[i]) {
> +			wake_up(&conf->wait_for_stripe[i]);
> +			if (!waked_thread) {
> +				waked_thread =3D true;
> +				md_wakeup_thread(conf->mddev->thread);
> +			}
> +		}

I don't think you want waked_thread to be local to this loop.
As it is, the "if (!waked_thread)" test *always* succeeds.

You can discard it if do_wakeup becomes and unsigned long, and just do

 if (do_wakeup && conf->retry_read_aligned)
	md_wakeup_thread(conf->mddev->thread);

And why have you removed the test on conf->retry_read_aligned??

>  	}
>  }
> =20
> @@ -655,6 +661,18 @@ static int has_failed(struct r5conf *conf)
>  	return 0;
>  }
> =20
> +/* XXX: might put it to linux/wait.h to be a public API? */

Yes, definitely put it in linux/wait.h


Thanks,
NeilBrown




> +#define raid_wait_event_exclusive_cmd(wq, condition, cmd1, cmd2)	\
> +do {									\
> +	if (condition)							\
> +		break;							\
> +	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 1, 0,	\
> +			    cmd1;					\
> +			    schedule();					\
> +			    cmd2);					\
> +} while (0)
> +
> +
>  static struct stripe_head *
>  get_active_stripe(struct r5conf *conf, sector_t sector,
>  		  int previous, int noblock, int noquiesce)
> @@ -684,14 +702,15 @@ get_active_stripe(struct r5conf *conf, sector_t sec=
tor,
>  			if (!sh) {
>  				set_bit(R5_INACTIVE_BLOCKED,
>  					&conf->cache_state);
> -				wait_event_lock_irq(
> -					conf->wait_for_stripe,
> +				raid_wait_event_exclusive_cmd(
> +					conf->wait_for_stripe[hash],
>  					!list_empty(conf->inactive_list + hash) &&
>  					(atomic_read(&conf->active_stripes)
>  					 < (conf->max_nr_stripes * 3 / 4)
>  					 || !test_bit(R5_INACTIVE_BLOCKED,
>  						      &conf->cache_state)),
> -					*(conf->hash_locks + hash));
> +					spin_unlock_irq(conf->hash_locks + hash),
> +					spin_lock_irq(conf->hash_locks + hash));
>  				clear_bit(R5_INACTIVE_BLOCKED,
>  					  &conf->cache_state);
>  			} else {
> @@ -716,6 +735,9 @@ get_active_stripe(struct r5conf *conf, sector_t secto=
r,
>  		}
>  	} while (sh =3D=3D NULL);
> =20
> +	if (!list_empty(conf->inactive_list + hash))
> +		wake_up(&conf->wait_for_stripe[hash]);
> +
>  	spin_unlock_irq(conf->hash_locks + hash);
>  	return sh;
>  }
> @@ -2136,7 +2158,7 @@ static int resize_stripes(struct r5conf *conf, int =
newsize)
>  	cnt =3D 0;
>  	list_for_each_entry(nsh, &newstripes, lru) {
>  		lock_device_hash_lock(conf, hash);
> -		wait_event_cmd(conf->wait_for_stripe,
> +		raid_wait_event_exclusive_cmd(conf->wait_for_stripe[hash],
>  				    !list_empty(conf->inactive_list + hash),
>  				    unlock_device_hash_lock(conf, hash),
>  				    lock_device_hash_lock(conf, hash));
> @@ -6391,7 +6413,9 @@ static struct r5conf *setup_conf(struct mddev *mdde=
v)
>  	spin_lock_init(&conf->device_lock);
>  	seqcount_init(&conf->gen_lock);
>  	init_waitqueue_head(&conf->wait_for_quiesce);
> -	init_waitqueue_head(&conf->wait_for_stripe);
> +	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++) {
> +		init_waitqueue_head(&conf->wait_for_stripe[i]);
> +	}
>  	init_waitqueue_head(&conf->wait_for_overlap);
>  	INIT_LIST_HEAD(&conf->handle_list);
>  	INIT_LIST_HEAD(&conf->hold_list);
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index fab53a3..cdad2d2 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -509,7 +509,7 @@ struct r5conf {
>  	atomic_t		empty_inactive_list_nr;
>  	struct llist_head	released_stripes;
>  	wait_queue_head_t	wait_for_quiesce;
> -	wait_queue_head_t	wait_for_stripe;
> +	wait_queue_head_t	wait_for_stripe[NR_STRIPE_HASH_LOCKS];
>  	wait_queue_head_t	wait_for_overlap;
>  	unsigned long		cache_state;
>  #define R5_INACTIVE_BLOCKED	1	/* release of inactive stripes blocked,


--Sig_/NDPMbUGQVWMebP=dsXILQkz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVT2BpTnsnt1WYoG5AQIq/BAAwj97ObsLJvGrnnSvTTu6ueAJ76ytwSuC
wTiDaDKqXhXnYAcs2+Hg68LHkakZW1bvNCq5KxJGT50KZwRsJ81HoMP89Fla67m2
M6iayEoCR+FNX408yJYPA49LoQM/eHbHJECmqUg4Yx+FdJUSCZpeY9nxK4kp/B33
zC5uZcA0Q0JeIZX7g21M9EGeE8XoM0a6PqYiFK53j8p1dTJlsHGZo0Nw04IQk/4s
ldYhPFlsVUP8N08FNNZtPcCeYsqgEcOhdGMEygKOlT9x0w0xPrpTqavKfw1zzbfU
jHfTFY8WlskGX2sBHaaJ5fYut0J6RZvfwQ9oyW17N50NL34JqA/QzIHmjy0HejwE
HP4uYF7poGfBRp++Kg9qSrgEQS0sfpKBNKOC6bfFEC1FPezkiPDPCmlJPkHXlqzB
sF4A2ZlZ239bjJeuPmHsxjiCNaljuJw6ZIZmv1I0eixnyP9v2wzMhRYtFNQ4Vk8+
7ykzP/Yc8cg9inJBGM5OlCkH5I/gCEaUnZliBmQ2MTCV4cRg48UzOw2RAKMKKtS1
NJnBBcpBNyQuLqPBRg3MKsgbCKJufjMeLXDFyc7PesdgAksxd0dQcmuMzdPvzNA2
OWfF/pETTVCBxFnCXIVMa6CpqKQQdNvKxojpJJpzJI4mXQxERKempps8TnlhB3q7
MCycfzUtChE=
=ZK+i
-----END PGP SIGNATURE-----

--Sig_/NDPMbUGQVWMebP=dsXILQkz--
