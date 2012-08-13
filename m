From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 2/2 v3]raid5: create multiple threads to handle stripes
Date: Mon, 13 Aug 2012 14:29:47 +1000
Message-ID: <20120813142947.4b161df6@notabene.brown>
References: <20120809085808.GB30111@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aEslx8L=imWMdP2/crEYq5A"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120809085808.GB30111@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

--Sig_/aEslx8L=imWMdP2/crEYq5A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 9 Aug 2012 16:58:08 +0800 Shaohua Li <shli@kernel.org> wrote:

> This is a new tempt to make raid5 handle stripes in multiple threads, as
> suggested by Neil to have maxium flexibility and better numa binding. It
> basically is a combination of my first and second generation patches. By
> default, no multiple thread is enabled (all stripes are handled by raid5d=
).
>=20
> An example to enable multiple threads:
> #echo 3 > /sys/block/md0/md/auxthread_number
> This will create 3 auxiliary threads to handle stripes. The threads can r=
un
> on any cpus and handle stripes produced by any cpus.
>=20
> #echo 1-3 > /sys/block/md0/md/auxth0/cpulist
> This will bind auxiliary thread 0 to cpu 1-3, and this thread will only h=
andle
> stripes produced by cpu 1-3. User tool can further change the thread's
> affinity, but the thread can only handle stripes produced by cpu 1-3 till=
 the
> sysfs entry is changed again.
>=20
> If stripes produced by a CPU aren't handled by any auxiliary thread, such
> stripes will be handled by raid5d. Otherwise, raid5d doesn't handle any
> stripes.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/md.c    |    8 -
>  drivers/md/md.h    |    8 +
>  drivers/md/raid5.c |  406 ++++++++++++++++++++++++++++++++++++++++++++++=
++++---
>  drivers/md/raid5.h |   19 ++
>  4 files changed, 418 insertions(+), 23 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-08-09 10:43:04.800022626 +0800
> +++ linux/drivers/md/raid5.c	2012-08-09 16:44:39.663278511 +0800
> @@ -196,6 +196,21 @@ static int stripe_operations_active(stru
>  	       test_bit(STRIPE_COMPUTE_RUN, &sh->state);
>  }
> =20
> +static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
> +{
> +	struct r5conf *conf =3D sh->raid_conf;
> +	struct raid5_percpu *percpu;
> +	int i, orphaned =3D 1;
> +
> +	percpu =3D per_cpu_ptr(conf->percpu, sh->cpu);
> +	for_each_cpu(i, &percpu->handle_threads) {
> +		md_wakeup_thread(conf->aux_threads[i]->thread);
> +		orphaned =3D 0;
> +	}
> +	if (orphaned)
> +		md_wakeup_thread(conf->mddev->thread);
> +}
> +
>  static void do_release_stripe(struct r5conf *conf, struct stripe_head *s=
h)
>  {
>  	BUG_ON(!list_empty(&sh->lru));
> @@ -208,9 +223,19 @@ static void do_release_stripe(struct r5c
>  			   sh->bm_seq - conf->seq_write > 0)
>  			list_add_tail(&sh->lru, &conf->bitmap_list);
>  		else {
> +			int cpu =3D sh->cpu;
> +			struct raid5_percpu *percpu;
> +			if (!cpu_online(cpu)) {
> +				cpu =3D cpumask_any(cpu_online_mask);
> +				sh->cpu =3D cpu;
> +			}
> +			percpu =3D per_cpu_ptr(conf->percpu, cpu);
> +
>  			clear_bit(STRIPE_DELAYED, &sh->state);
>  			clear_bit(STRIPE_BIT_DELAY, &sh->state);
> -			list_add_tail(&sh->lru, &conf->handle_list);
> +			list_add_tail(&sh->lru, &percpu->handle_list);
> +			raid5_wakeup_stripe_thread(sh);
> +			return;

I confess that I don't know a lot about cpu hotplug, but this looks like it
should have some locking.  In particular,  "get_online_cpus()" before we
check "cpu_online()", and "put_online_cpus()" after we have added to the
per_cpu->handle_list().

Maybe that isn't needed, but if it isn't  I'd like to understand why.


>  		}
>  		md_wakeup_thread(conf->mddev->thread);
>  	} else {
> @@ -355,6 +380,7 @@ static void init_stripe(struct stripe_he
>  		raid5_build_block(sh, i, previous);
>  	}
>  	insert_hash(conf, sh);
> +	sh->cpu =3D smp_processor_id();
>  }
> =20
>  static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t s=
ector,
> @@ -3689,12 +3715,19 @@ static void raid5_activate_delayed(struc
>  		while (!list_empty(&conf->delayed_list)) {
>  			struct list_head *l =3D conf->delayed_list.next;
>  			struct stripe_head *sh;
> +			int cpu;
>  			sh =3D list_entry(l, struct stripe_head, lru);
>  			list_del_init(l);
>  			clear_bit(STRIPE_DELAYED, &sh->state);
>  			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  				atomic_inc(&conf->preread_active_stripes);
>  			list_add_tail(&sh->lru, &conf->hold_list);
> +			cpu =3D sh->cpu;
> +			if (!cpu_online(cpu)) {
> +				cpu =3D cpumask_any(cpu_online_mask);
> +				sh->cpu =3D cpu;
> +			}
> +			raid5_wakeup_stripe_thread(sh);

Similarly here??
And anywhere  that 'cpu_online_mask' or 'cpu_online' are used.

I'll apply this to my for-next branch so it is easier to test but I won't
promise to submit for 3.6 just yet.


Thanks,
NeilBrown


--Sig_/aEslx8L=imWMdP2/crEYq5A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCiCuznsnt1WYoG5AQKfHA//S55bLDkXJ+v/Xm4v4m6Nmo0TDXq/vjIk
G9JV7MhryZ2kYVXDcSYThx+dHp//U9WmoT2qgq3ppz1TGJixNkyhnOA4l5Jete9c
Lpqu5ukq+LqbBNivUShacAvLb9iqTfEHRwSF6HPle2qv/5ml7jK7GchtAW62v40c
92tKo5XI/G4hi01lct2Om5dCVv4GadSXVv39oe1gxfwZy3Xb3ASRDAsza5239MJw
Ulo/XibMkix0C/4QThPcgbKHLag+MygiWrCTCxkI3UaK13PHS7a+QU136p1/0l7W
PPQYtnzLBf4MRdM74xWgNKSsRPnhhcJzZbw+EJRGiF2aiF3D7MeQoPk9rEsAg5e7
wAvPflLQewYuz2GmQpbPU/S2qPT8YfSAXu1xtTa1u4deWJHzGTQ6pz+ovutMoGjq
tR/5TdImxZbB2616XwxQ8KByjjqPkcixCWe43ouUYawSZT23YhNn67vUBKg3RUEO
Zb0zloLMmaGDcvd2gPVK6mAbiTSQ4G8gPGSI6lWQnEPQ4wuGe0zoRavkaCVBIUpV
BAm8sz5VLcl1OENHOPKUoxIFPlujlTpqgfVZioIVtcWIdI79Ah5xeDris0io+nR2
T4g78adxaWpVGmou2RUfVpg8rHYsjusUjj12Az6TJYnMMiOR3dvy4RXE/Rvu0PE1
t78o/ovf3/M=
=zlhL
-----END PGP SIGNATURE-----

--Sig_/aEslx8L=imWMdP2/crEYq5A--
