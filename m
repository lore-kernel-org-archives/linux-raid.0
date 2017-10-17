From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] [RFC] md raid10: use rcu to avoid NULL dereference in raid10d()
Date: Wed, 18 Oct 2017 07:03:04 +1100
Message-ID: <87efq1k0ef.fsf@notabene.neil.brown.name>
References: <20171017163637.17132-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171017163637.17132-1-colyli@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, linux-raid@vger.kernel.org
Cc: Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18 2017, Coly Li wrote:

> We have a bug report about NULL dereference in md raid10 code. The
> operations are,
>  - Create a raid10 device
>  - add a spare disk
>  - disconnect one of the online disks from the raid10 device
>  - wait to the recovery happens on the spare disk
>  - remove the spare disk which is recovering
> And sometimes a kernel oops of NULL dereference in md raid10 module can
> be observed, and crash tool reports the following information:
>> (gdb) list *(raid10d+0xad6)
>> 0x5de6 is in raid10d (../drivers/md/raid10.c:2300).
>> 2295		 * the latter is free to free wbio2.
>> 2296		 */
>> 2297		if (wbio2 && !wbio2->bi_end_io)
>> 2298			wbio2 =3D NULL;
>> 2299		if (wbio->bi_end_io) {
>> 2300			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
>> 2301			md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
>> 2302			generic_make_request(wbio);
>> 2303		}
>> 2304		if (wbio2) {
> At line 2300, conf->mirrors[d].rdev is NULL, this causes a NULL pointer
> dereference to conf->mirrors[d].rdev->nr_pending. After reading previous
> raid10 patches, I find conf->mirrors[d].rdev can be NULL at any point
> unless,
>  - a counted reference is held
>  - ->reconfig_mutex is held, or
>  - rcu_read_lock() is held

There is one other condition: MD_RECOVERY_RUNNING is set (without
MD_RECOVERY_DONE).
mirrors[d].rdev is only set to NULL by ->hot_remove_disk() which is only
called from remove_and_add_spares(), and that is never called while
resync/recovery/reshape is happening.
So there is no need for RCU protection here.

Only ... remove_and_add_spares() *can* sometimes be called during
resync -
Commit: 8430e7e0af9a ("md: disconnect device from personality before trying=
 to remove it.")
added a called to remove_and_add_spares() when "remove" is written to
the device/state attribute.  That was wrong.
This:

 	} else if (cmd_match(buf, "remove")) {
=2D		if (rdev->mddev->pers) {
+		if (rdev->mddev->pers &&
+		    !test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
 			clear_bit(Blocked, &rdev->flags);
 			remove_and_add_spares(rdev->mddev, rdev);

should fix it.

Thanks,
NeilBrown


> In context of kernel thread raid10d, non of the above conditions happens,
> therefore using rcu to protect the access to conf->mirrors[].rdev and
> conf->mirrors[].replacement pointers is necessary.
>
> This patch is an effort to add rcu protection in raid10d() code path,
> which including the following sub-routines,
>  - handle_write_completed()
>  - reshape_request_write()
>  - sync_request_write()
>  - recovery_request_write()=20
>
> Because the reported issue can not be always reproduced, I am still
> working on verification. This RFC patch is sent out for early feedback
> in case there is something I missed in the fix.
>
> Thanks in advance for the review and comments.
>
> Signed-off-by: Coly Li <colyli@suse.de>
> Reported-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  drivers/md/raid10.c | 99 +++++++++++++++++++++++++++++++++++++++++++----=
------
>  1 file changed, 80 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 374df5796649..fe9ce25ffc08 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2041,13 +2041,25 @@ static void sync_request_write(struct mddev *mdde=
v, struct r10bio *r10_bio)
>=20=20
>  		tpages =3D get_resync_pages(tbio)->pages;
>  		d =3D r10_bio->devs[i].devnum;
> -		rdev =3D conf->mirrors[d].rdev;
> +		rcu_read_lock();
> +		rdev =3D rcu_dereference(conf->mirrors[d].rdev);
> +		if (rdev =3D=3D NULL) {
> +			rcu_read_unlock();
> +			continue;
> +		}
> +
>  		if (!r10_bio->devs[i].bio->bi_status) {
>  			/* We know that the bi_io_vec layout is the same for
>  			 * both 'first' and 'i', so we just compare them.
>  			 * All vec entries are PAGE_SIZE;
>  			 */
>  			int sectors =3D r10_bio->sectors;
> +
> +			/*
> +			 * rdev is not referenced here, don't need rcu lock
> +			 * any more.
> +			 */
> +			rcu_read_unlock();
>  			for (j =3D 0; j < vcnt; j++) {
>  				int len =3D PAGE_SIZE;
>  				if (sectors < (len / 512))
> @@ -2067,8 +2079,10 @@ static void sync_request_write(struct mddev *mddev=
, struct r10bio *r10_bio)
>  		} else if (test_bit(FailFast, &rdev->flags)) {
>  			/* Just give up on this device */
>  			md_error(rdev->mddev, rdev);
> +			rcu_read_unlock();
>  			continue;
>  		}
> +		rcu_read_unlock();
>  		/* Ok, we need to write this bio, either to correct an
>  		 * inconsistency or to correct an unreadable block.
>  		 * First we need to fixup bv_offset, bv_len and
> @@ -2087,14 +2101,21 @@ static void sync_request_write(struct mddev *mdde=
v, struct r10bio *r10_bio)
>=20=20
>  		bio_copy_data(tbio, fbio);
>=20=20
> -		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
> +		rcu_read_lock();
> +		rdev =3D rcu_dereference(conf->mirrors[d].rdev);
> +		if (rdev =3D=3D NULL) {
> +			rcu_read_unlock();
> +			continue;
> +		}
> +		atomic_inc(&rdev->nr_pending);
>  		atomic_inc(&r10_bio->remaining);
> -		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(tbio));
> +		md_sync_acct(rdev->bdev, bio_sectors(tbio));
>=20=20
> -		if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
> +		if (test_bit(FailFast, &rdev->flags))
>  			tbio->bi_opf |=3D MD_FAILFAST;
> -		tbio->bi_iter.bi_sector +=3D conf->mirrors[d].rdev->data_offset;
> -		bio_set_dev(tbio, conf->mirrors[d].rdev->bdev);
> +		tbio->bi_iter.bi_sector +=3D rdev->data_offset;
> +		bio_set_dev(tbio, rdev->bdev);
> +		rcu_read_unlock();
>  		generic_make_request(tbio);
>  	}
>=20=20
> @@ -2222,6 +2243,7 @@ static void recovery_request_write(struct mddev *md=
dev, struct r10bio *r10_bio)
>  	struct r10conf *conf =3D mddev->private;
>  	int d;
>  	struct bio *wbio, *wbio2;
> +	struct md_rdev *rdev, *replacement;
>=20=20
>  	if (!test_bit(R10BIO_Uptodate, &r10_bio->state)) {
>  		fix_recovery_read_error(r10_bio);
> @@ -2236,6 +2258,8 @@ static void recovery_request_write(struct mddev *md=
dev, struct r10bio *r10_bio)
>  	d =3D r10_bio->devs[1].devnum;
>  	wbio =3D r10_bio->devs[1].bio;
>  	wbio2 =3D r10_bio->devs[1].repl_bio;
> +
> +
>  	/* Need to test wbio2->bi_end_io before we call
>  	 * generic_make_request as if the former is NULL,
>  	 * the latter is free to free wbio2.
> @@ -2243,15 +2267,25 @@ static void recovery_request_write(struct mddev *=
mddev, struct r10bio *r10_bio)
>  	if (wbio2 && !wbio2->bi_end_io)
>  		wbio2 =3D NULL;
>  	if (wbio->bi_end_io) {
> -		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
> -		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
> -		generic_make_request(wbio);
> +		rcu_read_lock();
> +		rdev =3D rcu_dereference(conf->mirrors[d].rdev);
> +		if (rdev) {
> +			atomic_inc(&rdev->nr_pending);
> +			md_sync_acct(rdev->bdev, bio_sectors(wbio));
> +			generic_make_request(wbio);
> +		}
> +		rcu_read_unlock();
>  	}
>  	if (wbio2) {
> -		atomic_inc(&conf->mirrors[d].replacement->nr_pending);
> -		md_sync_acct(conf->mirrors[d].replacement->bdev,
> +		rcu_read_lock();
> +		replacement =3D rcu_dereference(conf->mirrors[d].replacement);
> +		if (replacement) {
> +			atomic_inc(&replacement->nr_pending);
> +			md_sync_acct(replacement->bdev,
>  			     bio_sectors(wbio2));
> -		generic_make_request(wbio2);
> +			generic_make_request(wbio2);
> +		}
> +		rcu_read_unlock();
>  	}
>  }
>=20=20
> @@ -2620,9 +2654,17 @@ static void handle_write_completed(struct r10conf =
*conf, struct r10bio *r10_bio)
>  	    test_bit(R10BIO_IsRecover, &r10_bio->state)) {
>  		for (m =3D 0; m < conf->copies; m++) {
>  			int dev =3D r10_bio->devs[m].devnum;
> -			rdev =3D conf->mirrors[dev].rdev;
> -			if (r10_bio->devs[m].bio =3D=3D NULL)
> +
> +			rcu_read_lock();
> +			rdev =3D rcu_dereference(conf->mirrors[dev].rdev);
> +			if (rdev =3D=3D NULL) {
> +				rcu_read_unlock();
> +				continue;
> +			}
> +			if (r10_bio->devs[m].bio =3D=3D NULL) {
> +				rcu_read_unlock();
>  				continue;
> +			}
>  			if (!r10_bio->devs[m].bio->bi_status) {
>  				rdev_clear_badblocks(
>  					rdev,
> @@ -2635,9 +2677,16 @@ static void handle_write_completed(struct r10conf =
*conf, struct r10bio *r10_bio)
>  					    r10_bio->sectors, 0))
>  					md_error(conf->mddev, rdev);
>  			}
> -			rdev =3D conf->mirrors[dev].replacement;
> -			if (r10_bio->devs[m].repl_bio =3D=3D NULL)
> +
> +			rdev =3D rcu_dereference(conf->mirrors[dev].replacement);
> +			if (rdev =3D=3D NULL) {
> +				rcu_read_unlock();
>  				continue;
> +			}
> +			if (r10_bio->devs[m].repl_bio =3D=3D NULL) {
> +				rcu_read_unlock();
> +				continue;
> +			}
>=20=20
>  			if (!r10_bio->devs[m].repl_bio->bi_status) {
>  				rdev_clear_badblocks(
> @@ -2651,6 +2700,7 @@ static void handle_write_completed(struct r10conf *=
conf, struct r10bio *r10_bio)
>  					    r10_bio->sectors, 0))
>  					md_error(conf->mddev, rdev);
>  			}
> +			rcu_read_unlock();
>  		}
>  		put_buf(r10_bio);
>  	} else {
> @@ -2658,7 +2708,13 @@ static void handle_write_completed(struct r10conf =
*conf, struct r10bio *r10_bio)
>  		for (m =3D 0; m < conf->copies; m++) {
>  			int dev =3D r10_bio->devs[m].devnum;
>  			struct bio *bio =3D r10_bio->devs[m].bio;
> -			rdev =3D conf->mirrors[dev].rdev;
> +
> +			rcu_read_lock();
> +			rdev =3D rcu_dereference(conf->mirrors[dev].rdev);
> +			if (rdev =3D=3D NULL) {
> +				rcu_read_unlock();
> +				continue;
> +			}
>  			if (bio =3D=3D IO_MADE_GOOD) {
>  				rdev_clear_badblocks(
>  					rdev,
> @@ -2675,14 +2731,19 @@ static void handle_write_completed(struct r10conf=
 *conf, struct r10bio *r10_bio)
>  				rdev_dec_pending(rdev, conf->mddev);
>  			}
>  			bio =3D r10_bio->devs[m].repl_bio;
> -			rdev =3D conf->mirrors[dev].replacement;
> -			if (rdev && bio =3D=3D IO_MADE_GOOD) {
> +			rdev =3D rcu_dereference(conf->mirrors[dev].replacement);
> +			if (rdev =3D=3D NULL) {
> +				rcu_read_unlock();
> +				continue;
> +			}
> +			if (bio =3D=3D IO_MADE_GOOD) {
>  				rdev_clear_badblocks(
>  					rdev,
>  					r10_bio->devs[m].addr,
>  					r10_bio->sectors, 0);
>  				rdev_dec_pending(rdev, conf->mddev);
>  			}
> +			rcu_read_unlock();
>  		}
>  		if (fail) {
>  			spin_lock_irq(&conf->device_lock);
> --=20
> 2.13.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnmYfoACgkQOeye3VZi
gbmiIQ//V0sux51rLTHuuSYyZUK4dSLf/DbaqFZqEIrWm6KFeUg5WlAoY7DqthUn
NI+zWdIlpLedTDudYc1AX0sMTxhYSLGsX4SyNbXGmgFr2ACCqf9wKcN4D5kbVT3C
s1RyZyy4Xi77snHmUH0IgSpoj8Mwm3vHs8iCyeIQyTv/t6Yt1NxdbDhmJ9XOd3HM
jce25ihhUS5Ph/WE6YXuX4b2cg4MWFsWb/pTYym0x8ep7CZsRRCfEJDfPxzMq44w
utpXUWhv9T7fvxeYOW4QgAA1u7gN4MxUW0sw8tGkjxoQOQ9f0iAiwckcU40TppBg
XuMBHi0fsPc0FeJEG5K0yO7Wsp7sPF9Z+2kbj3EWgpgiuQCwWqpeB4RyvAo5V7Op
HxhCwfiys9ohiDauPAaBJOcfSY3kmrYuU2GEQnp1gGMrQUvSJjK7zBzzYFz4nhuH
gRH7MCHoSPPeSFjBLOEMXAv0fA2eybD1hFVt4dbQOZz5FIngZELOmpi+oGzCmHnx
JtZsbmXqCwuAQC5l1r48qGlHYc50q1mcKLrDb/SyGRu9B63tkbgJ70TReKfoNQdw
jB0DPRNnY5mg+l5pcjjjqll3rBJKfR4ouYCafZTsRxJEFnJnOI1RFuAQFA265oVK
HUqXZ6u8ARUhw8FP1QmOh8fSeUkmGx3uNjq/EnvU81uJWjs2ePY=
=IQvL
-----END PGP SIGNATURE-----
--=-=-=--
