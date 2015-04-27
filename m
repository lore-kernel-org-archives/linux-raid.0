From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md/raid5: split wait_for_stripe and introduce
 wait_for_quiesce
Date: Mon, 27 Apr 2015 10:10:24 +1000
Message-ID: <20150427101024.2ae8edc1@notabene.brown>
References: <1429882744-22655-1-git-send-email-yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ZYTk5RCo12++fE0WKvVT2/7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429882744-22655-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ZYTk5RCo12++fE0WKvVT2/7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Apr 2015 21:39:03 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> If I read code correctly, current wait_for_stripe actually has 2 usage:
>=20
> - wait for there is enough free stripe cache, triggered when
>   get_free_stripe() failed. This is what wait_for_stripe intend
>   for literally.
>=20
> - wait for quiesce =3D=3D 0 or
>            active_aligned_reads =3D=3D 0 && active_stripes =3D=3D 0
>=20
>   It has nothing to do with wait_for_stripe literally, and releasing
>   an active stripe won't actually wake them up. On the contrary, wake_up
>   from under this case won't actually wake up the process waiting for
>   an free stripe being available.

I disagree.  Releasing an active stripe *will* (or *can*) wake up that third
case, as it decrements "active_stripes" which will eventually reach zero.

I don't think your new code will properly wake up a process which is waiting
for "active_stripes =3D=3D 0".

>=20
> Hence, we'd better split wait_for_stripe, and here I introduce
> wait_for_quiesce for the second usage. The name may not well taken, or
> even taken wrongly. Feel free to correct me then.
>=20
> This is also a prepare patch for next patch: make wait_for_stripe
> exclusive.

I think you have this commit description upside down :-)

The real motivation is that you are seeing contention on some spinlock and =
so
you want to split 'wait_for_stripe' up in to multiple wait_queues so that y=
ou
can use exclusive wakeup.  As this is the main motivation, it should be
stated first.

Then explain that 'wait_for_stripe' is used to wait for the array to enter =
or
leave the quiescent state, and also to wait for an available stripe in each
of the hash lists.

So this patch splits the first usage off into a separate wait_queue, and the
next patch will split the second usage into one waitqueue for each hash val=
ue.

Then explain just is what is needed for that first step.

When you put it that way around, the patch makes lots of sense.

So: could you please resubmit with the description the right way around, and
with an appropriate wakeup call to ensure raid5_quiesce is woken up when
active_stripes reaches zero?

Thanks,
NeilBrown


>=20
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  drivers/md/raid5.c | 13 +++++++------
>  drivers/md/raid5.h |  1 +
>  2 files changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 9716319..b7e385f 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -667,7 +667,7 @@ get_active_stripe(struct r5conf *conf, sector_t secto=
r,
>  	spin_lock_irq(conf->hash_locks + hash);
> =20
>  	do {
> -		wait_event_lock_irq(conf->wait_for_stripe,
> +		wait_event_lock_irq(conf->wait_for_quiesce,
>  				    conf->quiesce =3D=3D 0 || noquiesce,
>  				    *(conf->hash_locks + hash));
>  		sh =3D __find_stripe(conf, sector, conf->generation - previous);
> @@ -4725,7 +4725,7 @@ static void raid5_align_endio(struct bio *bi, int e=
rror)
>  					 raid_bi, 0);
>  		bio_endio(raid_bi, 0);
>  		if (atomic_dec_and_test(&conf->active_aligned_reads))
> -			wake_up(&conf->wait_for_stripe);
> +			wake_up(&conf->wait_for_quiesce);
>  		return;
>  	}
> =20
> @@ -4820,7 +4820,7 @@ static int chunk_aligned_read(struct mddev *mddev, =
struct bio * raid_bio)
>  		align_bi->bi_iter.bi_sector +=3D rdev->data_offset;
> =20
>  		spin_lock_irq(&conf->device_lock);
> -		wait_event_lock_irq(conf->wait_for_stripe,
> +		wait_event_lock_irq(conf->wait_for_quiesce,
>  				    conf->quiesce =3D=3D 0,
>  				    conf->device_lock);
>  		atomic_inc(&conf->active_aligned_reads);
> @@ -5659,7 +5659,7 @@ static int  retry_aligned_read(struct r5conf *conf,=
 struct bio *raid_bio)
>  		bio_endio(raid_bio, 0);
>  	}
>  	if (atomic_dec_and_test(&conf->active_aligned_reads))
> -		wake_up(&conf->wait_for_stripe);
> +		wake_up(&conf->wait_for_quiesce);
>  	return handled;
>  }
> =20
> @@ -6390,6 +6390,7 @@ static struct r5conf *setup_conf(struct mddev *mdde=
v)
>  		goto abort;
>  	spin_lock_init(&conf->device_lock);
>  	seqcount_init(&conf->gen_lock);
> +	init_waitqueue_head(&conf->wait_for_quiesce);
>  	init_waitqueue_head(&conf->wait_for_stripe);
>  	init_waitqueue_head(&conf->wait_for_overlap);
>  	INIT_LIST_HEAD(&conf->handle_list);
> @@ -7413,7 +7414,7 @@ static void raid5_quiesce(struct mddev *mddev, int =
state)
>  		 * active stripes can drain
>  		 */
>  		conf->quiesce =3D 2;
> -		wait_event_cmd(conf->wait_for_stripe,
> +		wait_event_cmd(conf->wait_for_quiesce,
>  				    atomic_read(&conf->active_stripes) =3D=3D 0 &&
>  				    atomic_read(&conf->active_aligned_reads) =3D=3D 0,
>  				    unlock_all_device_hash_locks_irq(conf),
> @@ -7427,7 +7428,7 @@ static void raid5_quiesce(struct mddev *mddev, int =
state)
>  	case 0: /* re-enable writes */
>  		lock_all_device_hash_locks_irq(conf);
>  		conf->quiesce =3D 0;
> -		wake_up(&conf->wait_for_stripe);
> +		wake_up(&conf->wait_for_quiesce);
>  		wake_up(&conf->wait_for_overlap);
>  		unlock_all_device_hash_locks_irq(conf);
>  		break;
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 7dc0dd8..fab53a3 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -508,6 +508,7 @@ struct r5conf {
>  	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
>  	atomic_t		empty_inactive_list_nr;
>  	struct llist_head	released_stripes;
> +	wait_queue_head_t	wait_for_quiesce;
>  	wait_queue_head_t	wait_for_stripe;
>  	wait_queue_head_t	wait_for_overlap;
>  	unsigned long		cache_state;


--Sig_/ZYTk5RCo12++fE0WKvVT2/7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVT1+cDnsnt1WYoG5AQKV8xAAwzjwW4GEqRwrgSyPrh+QFVzwZ8G6/kyG
hfg+H2pGbhg0oSJ9XIjfr52b+y4H46z0wwF72QGoSdumMIOI2IiCE9MsNfEbozLu
T973rS/AQ1odkNlvpsim6uM38Zw4G6MfMnmauRiOvD6n3qTtfr3w7FbX5eXD9STf
PXr7n87G9v9cmhJ72l3Hca2FdNWhb5DhI88HaFSlE5LOB9h2TZOTKDWUbR9Jbk8m
iI5DtLn64hwdyqBOjvFRtp25cNXE5U3Wx9Xb74LrlQddpcb+O/YuUEeA/R/WymjJ
Yf4JVGC7QJP4nNLc5GxIYZ2gtb59M51QVAZB/94irleqXj7uI9di2QqxosVzASa2
4v+aRMM6OqbdYJq91e/FOTwoioWSh7t9YJX0WMRAvesOGuBz5js2KYKx2KfZI2Wl
iCRBjKyZl4rauTlfWFh8erbdlWH3T+galxDictMPCKnHkPO+4LqDBzmheb1mtPPp
sbyVCdvCMcAId1XFiJdD0cMzcjwnTgvDkB2IiFMCAWab0X794a4ijzg+Etl5WhDL
JJkfOD8jwHNgv9z3U/Stk7BpcZEa0RB4k42qBBPpt6NbsV/eG8wM1xe1c5elICmT
03CIppNspR2XNTWfsRB/Kk99cHbew+IxQU57Rd4+0pcnSRWbzVKhP9Xks3qI7qnb
RftxmW4QeCI=
=5TB5
-----END PGP SIGNATURE-----

--Sig_/ZYTk5RCo12++fE0WKvVT2/7--
