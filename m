From: Andre Noll <maan@systemlinux.org>
Subject: Re: [md PATCH 04/22] md: support barrier requests on all personalities.
Date: Tue, 8 Dec 2009 14:54:42 +0100
Message-ID: <20091208135442.GR5174@skl-net.de>
References: <20091204064559.10264.37619.stgit@notabene.brown> <20091204064802.10264.60521.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HSfddtAs2KjjielS"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091204064802.10264.60521.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--HSfddtAs2KjjielS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:48, NeilBrown wrote:
> When a barrier arrives, we send a zero-length barrier to every active
> device.  When that completes - and if the original request was not
> empty -  we submit the barrier request itself (with the barrier flag
> cleared) and the submit a fresh load of zero length barriers.

s/the/then

> +/*
> + * Generic barrier handling for md
> + */
> +
> +static void md_end_barrier(struct bio *bio, int err)
> +{
> +	mdk_rdev_t *rdev =3D bio->bi_private;
> +	mddev_t *mddev =3D rdev->mddev;
> +	if (err =3D=3D -EOPNOTSUPP && mddev->barrier !=3D (void*)1)

How about

	#define POST_REQUEST_BARRIER ((void*)1)

?

> +		rcu_read_lock();
> +		list_for_each_entry_rcu(rdev, &mddev->disks, same_set)
> +			if (rdev->raid_disk >=3D 0 &&
> +			    !test_bit(Faulty, &rdev->flags)) {
> +				/* Take two references, one is dropped
> +				 * when request finishes, one after
> +				 * we reclaim rcu_read_lock
> +				 */
> +				struct bio *bi;
> +				atomic_inc(&rdev->nr_pending);
> +				atomic_inc(&rdev->nr_pending);
> +				rcu_read_unlock();
> +				bi =3D bio_alloc(GFP_KERNEL, 0);
> +				bi->bi_end_io =3D md_end_barrier;
> +				bi->bi_private =3D rdev;
> +				bi->bi_bdev =3D rdev->bdev;
> +				atomic_inc(&mddev->flush_pending);
> +				submit_bio(WRITE_BARRIER, bi);
> +				rcu_read_lock();
> +				rdev_dec_pending(rdev, mddev);
> +			}
> +		rcu_read_unlock();

Calling atomic_inc() twice isn't an atomic operation any more. If
this doesn't matter (because all modifications of rdev->nr_pending
are supposed to happen within RCU read-side critical sections) then
why is rdev->nr_pending an atomic_t at all?

> +void md_barrier_request(mddev_t *mddev, struct bio *bio)
> +{
> +	mdk_rdev_t *rdev;
> +
> +	spin_lock_irq(&mddev->write_lock);
> +	wait_event_lock_irq(mddev->sb_wait,
> +			    !mddev->barrier,
> +			    mddev->write_lock, /*nothing*/);
> +	mddev->barrier =3D bio;
> +	spin_unlock_irq(&mddev->write_lock);
> +
> +	atomic_set(&mddev->flush_pending, 1);
> +	INIT_WORK(&mddev->barrier_work, md_submit_barrier);
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(rdev, &mddev->disks, same_set)
> +		if (rdev->raid_disk >=3D 0 &&
> +		    !test_bit(Faulty, &rdev->flags)) {
> +			struct bio *bi;
> +
> +			atomic_inc(&rdev->nr_pending);
> +			atomic_inc(&rdev->nr_pending);
> +			rcu_read_unlock();
> +			bi =3D bio_alloc(GFP_KERNEL, 0);
> +			bi->bi_end_io =3D md_end_barrier;
> +			bi->bi_private =3D rdev;
> +			bi->bi_bdev =3D rdev->bdev;
> +			atomic_inc(&mddev->flush_pending);
> +			submit_bio(WRITE_BARRIER, bi);
> +			rcu_read_lock();
> +			rdev_dec_pending(rdev, mddev);
> +		}
> +	rcu_read_unlock();

This loop is identical to the one above, so it might make sense
to put it into a separate function.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--HSfddtAs2KjjielS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLHlqiWto1QDEAkw8RAq2uAKCqbTOJz/wxyddT+SDyV4r7nEto5wCgqpUD
tHWptThGcdwXhUEi/9eVbMg=
=iZCz
-----END PGP SIGNATURE-----

--HSfddtAs2KjjielS--
