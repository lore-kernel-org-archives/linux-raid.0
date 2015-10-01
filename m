From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 3/3] raid5-cache: IO error handling
Date: Thu, 01 Oct 2015 14:50:20 +1000
Message-ID: <87k2r7jipf.fsf@notabene.neil.brown.name>
References: <cover.1443653794.git.shli@fb.com> <e9c915cf18d81f76e122a2533baeb68c56186d8f.1443653794.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c915cf18d81f76e122a2533baeb68c56186d8f.1443653794.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> There are 3 places the raid5-cache dispatches IO. The discard IO error
> doesn't matter, so we ignore it. The superblock write IO error can be
> handled in MD core. The remaining are log write and flush. When the IO
> error happens, we simply fail all raid disks and continue the stripe
> state machine. The MD/raid5 core can handle it (for example, mark all
> disks faulty, report bio error and so on).
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5-cache.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index afc3b6b..430ce5c 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -223,7 +223,16 @@ static void __r5l_set_io_unit_state(struct r5l_io_un=
it *io,
>  	io->state =3D state;
>  }
>=20=20
> -/* XXX: totally ignores I/O errors */
> +static void r5l_log_io_error(struct r5l_log *log)
> +{
> +	struct md_rdev *rdev;
> +
> +	rcu_read_lock();
> +	rdev_for_each_rcu(rdev, log->rdev->mddev)
> +		md_error(log->rdev->mddev, rdev);
> +	rcu_read_unlock();
> +}

This fails spare devices too... seems a bit heavy handed.

If the journal device fails we should still be able to read from the
array, just not write.

So can we just enhance the
	if (s.failed > conf->max_degraded) {
test in handle_stripe(), and probably improve has_failed() too??

Thanks,
NeilBrown


> +
>  static void r5l_log_endio(struct bio *bio)
>  {
>  	struct r5l_io_unit *io =3D bio->bi_private;
> @@ -232,6 +241,9 @@ static void r5l_log_endio(struct bio *bio)
>=20=20
>  	bio_put(bio);
>=20=20
> +	if (bio->bi_error)
> +		r5l_log_io_error(log);
> +
>  	if (!atomic_dec_and_test(&io->pending_io))
>  		return;
>=20=20
> @@ -594,6 +606,9 @@ static void r5l_log_flush_endio(struct bio *bio)
>  	struct r5l_io_unit *io;
>  	struct stripe_head *sh;
>=20=20
> +	if (bio->bi_error)
> +		r5l_log_io_error(log);
> +
>  	spin_lock_irqsave(&log->io_list_lock, flags);
>  	list_for_each_entry(io, &log->flushing_ios, log_sibling) {
>  		while (!list_empty(&io->stripe_list)) {
> @@ -681,6 +696,7 @@ static void r5l_write_super_and_discard_space(struct =
r5l_log *log,
>  			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
>  	}
>=20=20
> +	/* discard IO error really doesn't matter, ignore it */
>  	if (log->last_checkpoint < end) {
>  		blkdev_issue_discard(bdev,
>  				log->last_checkpoint + log->rdev->data_offset,
> --=20
> 2.4.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWDLuMAAoJEDnsnt1WYoG5NBgQAJ9GeVUzVsp0bS8rZKKXSOCz
wdylzteQmrInk8SKU+rdaPYe6ntjOAbtNgALsV560+NI4hqBDP7RaFPjEu7RmgcX
bcBm0m2LJokkfMWKUgPHkKmJnyEZlFo0pDNuQbAF8RLWLMmWEEHZKNR9vkf2B0O4
1VgLsgrUTMlmEivsj3Lb/VmwXWwKWv7cMG9XCJXl11H+knGTbTkHohWJuFoNggbd
JE3YUKPEW61/LnuOecwSA0GVmmaNa4sM4MFGG0VTGXvxeJ7rMFrABtmBW15ZZrP3
cJGPSa8tgCMc1Mfc/VkVWv0zRDROz3p8fP5+xQPsNQJJe+P/7ETDJq12rX1+CZor
DRxsBGb9CAM/56qVHiXlAvEkdO8muOOeX/RDqWMyKQCJ5/TFYmZljcNiWZVVz4cb
fb5df5XEeUUWHeHdbNhohst4nzneFvIMPPBoRrXssNzIzsMZg/OAZID1mmAOAgSe
gDWdufbf+U1rsJikys4+KHDPMFzeOMWsVgMEo01E0YKMwQ/+dqNEWaLW0/lFyYv6
JrztWlPuKUOnaDln688ICFlXc/z23dyUU1XRewRWXpu9nyqaRgb0hBVfyV75ZepX
AtQ/bL8KNbDY9chNpvTTk947OgdBorsm6+ps80mUXJbkBB/0BEEAIt/Xd/q+DrV1
YeNoxhZtchfZA8m9JU8D
=4dDu
-----END PGP SIGNATURE-----
--=-=-=--
