From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md/raid5: split wait_for_stripe and introduce
 wait_for_quiesce
Date: Mon, 27 Apr 2015 12:24:24 +1000
Message-ID: <20150427122424.62df3753@notabene.brown>
References: <1429882744-22655-1-git-send-email-yuanhan.liu@linux.intel.com>
	<20150427101024.2ae8edc1@notabene.brown>
	<20150427021249.GG17176@yliu-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/.OiIBU1TyHSy/FYkAsgSo4r"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150427021249.GG17176@yliu-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.OiIBU1TyHSy/FYkAsgSo4r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Apr 2015 10:12:49 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> On Mon, Apr 27, 2015 at 10:10:24AM +1000, NeilBrown wrote:
> > On Fri, 24 Apr 2015 21:39:03 +0800 Yuanhan Liu <yuanhan.liu@linux.intel=
.com>
> > wrote:
> >=20
> > > If I read code correctly, current wait_for_stripe actually has 2 usag=
e:
> > >=20
> > > - wait for there is enough free stripe cache, triggered when
> > >   get_free_stripe() failed. This is what wait_for_stripe intend
> > >   for literally.
> > >=20
> > > - wait for quiesce =3D=3D 0 or
> > >            active_aligned_reads =3D=3D 0 && active_stripes =3D=3D 0
> > >=20
> > >   It has nothing to do with wait_for_stripe literally, and releasing
> > >   an active stripe won't actually wake them up. On the contrary, wake=
_up
> > >   from under this case won't actually wake up the process waiting for
> > >   an free stripe being available.
> >=20
> > I disagree.  Releasing an active stripe *will* (or *can*) wake up that =
third
> > case, as it decrements "active_stripes" which will eventually reach zer=
o.
> >=20
> > I don't think your new code will properly wake up a process which is wa=
iting
> > for "active_stripes =3D=3D 0".
>=20
> Right, and thanks for pointing it out. So, is this enough?
>=20
> ---
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 2d8fcc1..3f23035 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -383,6 +383,9 @@ static void release_inactive_stripe_list(struct
> r5conf *conf,
>                         }
>                 }
>         }
> +
> +       if (!atomic_read(&conf->active_stripes))
> +               wake_up(&conf->wait_for_quiesce);
>  }
>=20
>  /* should hold conf->device_lock already */
>=20
>=20
> Or, should I put it a bit ahead, trying to invoke wake_up(&conf->wait_for=
_quiesce)
> after each atomic_dec(&conf->active_stripes)?
>=20
> 	if (atomic_dec_return(&conf->active_stripes) =3D=3D 0)
> 		wake_up(&conf->wait_for_quiesce);

I think the first version is fine.  While waiting for active_stripes to be
zero, ->quiesce is set to 2, and so no new stripes should get used.

>=20
> >=20
> > >=20
> > > Hence, we'd better split wait_for_stripe, and here I introduce
> > > wait_for_quiesce for the second usage. The name may not well taken, or
> > > even taken wrongly. Feel free to correct me then.
> > >=20
> > > This is also a prepare patch for next patch: make wait_for_stripe
> > > exclusive.
> >=20
> > I think you have this commit description upside down :-)
> >=20
> > The real motivation is that you are seeing contention on some spinlock =
and so
> > you want to split 'wait_for_stripe' up in to multiple wait_queues so th=
at you
> > can use exclusive wakeup.  As this is the main motivation, it should be
> > stated first.
> >=20
> > Then explain that 'wait_for_stripe' is used to wait for the array to en=
ter or
> > leave the quiescent state, and also to wait for an available stripe in =
each
> > of the hash lists.
> >=20
> > So this patch splits the first usage off into a separate wait_queue, an=
d the
> > next patch will split the second usage into one waitqueue for each hash=
 value.
> >=20
> > Then explain just is what is needed for that first step.
> >=20
> > When you put it that way around, the patch makes lots of sense.
>=20
> It does, and thanks!
>=20
> >=20
> > So: could you please resubmit with the description the right way around=
, and
>=20
> To make sure I followed you correctly, my patch order is correct(I mean,
> split lock first, and make wait_for_stripe per lock hash and exclusive
> second), and what I need to do is re-writing the commit log as you sugges=
ted,
> and fixing all issues you pointed out. Right?

Correct.

Thanks,
NeilBrown


>=20
> 	--yliu
>=20
> > with an appropriate wakeup call to ensure raid5_quiesce is woken up when
> > active_stripes reaches zero?
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
> > >=20
> > > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > > ---
> > >  drivers/md/raid5.c | 13 +++++++------
> > >  drivers/md/raid5.h |  1 +
> > >  2 files changed, 8 insertions(+), 6 deletions(-)
> > >=20
> > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > index 9716319..b7e385f 100644
> > > --- a/drivers/md/raid5.c
> > > +++ b/drivers/md/raid5.c
> > > @@ -667,7 +667,7 @@ get_active_stripe(struct r5conf *conf, sector_t s=
ector,
> > >  	spin_lock_irq(conf->hash_locks + hash);
> > > =20
> > >  	do {
> > > -		wait_event_lock_irq(conf->wait_for_stripe,
> > > +		wait_event_lock_irq(conf->wait_for_quiesce,
> > >  				    conf->quiesce =3D=3D 0 || noquiesce,
> > >  				    *(conf->hash_locks + hash));
> > >  		sh =3D __find_stripe(conf, sector, conf->generation - previous);
> > > @@ -4725,7 +4725,7 @@ static void raid5_align_endio(struct bio *bi, i=
nt error)
> > >  					 raid_bi, 0);
> > >  		bio_endio(raid_bi, 0);
> > >  		if (atomic_dec_and_test(&conf->active_aligned_reads))
> > > -			wake_up(&conf->wait_for_stripe);
> > > +			wake_up(&conf->wait_for_quiesce);
> > >  		return;
> > >  	}
> > > =20
> > > @@ -4820,7 +4820,7 @@ static int chunk_aligned_read(struct mddev *mdd=
ev, struct bio * raid_bio)
> > >  		align_bi->bi_iter.bi_sector +=3D rdev->data_offset;
> > > =20
> > >  		spin_lock_irq(&conf->device_lock);
> > > -		wait_event_lock_irq(conf->wait_for_stripe,
> > > +		wait_event_lock_irq(conf->wait_for_quiesce,
> > >  				    conf->quiesce =3D=3D 0,
> > >  				    conf->device_lock);
> > >  		atomic_inc(&conf->active_aligned_reads);
> > > @@ -5659,7 +5659,7 @@ static int  retry_aligned_read(struct r5conf *c=
onf, struct bio *raid_bio)
> > >  		bio_endio(raid_bio, 0);
> > >  	}
> > >  	if (atomic_dec_and_test(&conf->active_aligned_reads))
> > > -		wake_up(&conf->wait_for_stripe);
> > > +		wake_up(&conf->wait_for_quiesce);
> > >  	return handled;
> > >  }
> > > =20
> > > @@ -6390,6 +6390,7 @@ static struct r5conf *setup_conf(struct mddev *=
mddev)
> > >  		goto abort;
> > >  	spin_lock_init(&conf->device_lock);
> > >  	seqcount_init(&conf->gen_lock);
> > > +	init_waitqueue_head(&conf->wait_for_quiesce);
> > >  	init_waitqueue_head(&conf->wait_for_stripe);
> > >  	init_waitqueue_head(&conf->wait_for_overlap);
> > >  	INIT_LIST_HEAD(&conf->handle_list);
> > > @@ -7413,7 +7414,7 @@ static void raid5_quiesce(struct mddev *mddev, =
int state)
> > >  		 * active stripes can drain
> > >  		 */
> > >  		conf->quiesce =3D 2;
> > > -		wait_event_cmd(conf->wait_for_stripe,
> > > +		wait_event_cmd(conf->wait_for_quiesce,
> > >  				    atomic_read(&conf->active_stripes) =3D=3D 0 &&
> > >  				    atomic_read(&conf->active_aligned_reads) =3D=3D 0,
> > >  				    unlock_all_device_hash_locks_irq(conf),
> > > @@ -7427,7 +7428,7 @@ static void raid5_quiesce(struct mddev *mddev, =
int state)
> > >  	case 0: /* re-enable writes */
> > >  		lock_all_device_hash_locks_irq(conf);
> > >  		conf->quiesce =3D 0;
> > > -		wake_up(&conf->wait_for_stripe);
> > > +		wake_up(&conf->wait_for_quiesce);
> > >  		wake_up(&conf->wait_for_overlap);
> > >  		unlock_all_device_hash_locks_irq(conf);
> > >  		break;
> > > diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> > > index 7dc0dd8..fab53a3 100644
> > > --- a/drivers/md/raid5.h
> > > +++ b/drivers/md/raid5.h
> > > @@ -508,6 +508,7 @@ struct r5conf {
> > >  	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
> > >  	atomic_t		empty_inactive_list_nr;
> > >  	struct llist_head	released_stripes;
> > > +	wait_queue_head_t	wait_for_quiesce;
> > >  	wait_queue_head_t	wait_for_stripe;
> > >  	wait_queue_head_t	wait_for_overlap;
> > >  	unsigned long		cache_state;
> >=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--Sig_/.OiIBU1TyHSy/FYkAsgSo4r
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVT2d2Dnsnt1WYoG5AQLPThAAhGcobh476yn2Koz4L0oQ9mWhkWJXeYSm
gxoSdMOMDfadxbFt95q0vntvjwMfZ+Sa8vaeA8Kl9UrVJt8mSbdGXMA52PYfrL3+
gIbKwQ8bLibf4UrGSacAWyfob0eq9t1yH0TdTevRl8jqqj2LLktifeiDvpTVYnhT
xRiKzRZzA3U/cAYhpuG/JEKUHBifvh5XxTDwhGkNXlT//eMeWhf4WxwsBYGQEK0v
NcmU7H8ZWFEmSLrKv3bKQ1pLmOAmQC679i8bz6stAPjZa+VahKVHFKmZIgXEA1CF
VBriH4PvwgR3fjDygigg06pTFrybUvKa3/e9jN5j8DT7kkpStObBwu3OmgsvGUqT
/OpLXocn3V3VlOVu33hpFQvAUnailOjuiBDoCoCTzNnvpHYNUL3c8ikXaxK5GD5i
QiyJ2cKL1lXtZO8mbvpvmGg2aXXUP+JTMSqivM4OvsRNRMgnHXOd26YP9058jDZv
6sqhwaeFRaNpr+OJQXPGngKr1po4bOaEGICmk+woVwUW2dnti6bnFXXF/rAviqMK
RBvzxxyOAIC//rkRhzZhQwDWKCJDxzCeyMUjsg6oaE0z2qSgw9pbecPaMBDBuN6k
Hr0ls+q+RpTKS6tyoGNkpb6NXhTZmqxDj+CewPzW4cEp3uHe2VDuIC7nGreY3id/
pIfKBK02p24=
=Aj7q
-----END PGP SIGNATURE-----

--Sig_/.OiIBU1TyHSy/FYkAsgSo4r--
