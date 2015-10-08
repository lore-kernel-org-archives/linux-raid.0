From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 3/6] raid5-cache: add trim support for log
Date: Thu, 08 Oct 2015 12:53:47 +1100
Message-ID: <87si5m6s7o.fsf@notabene.neil.brown.name>
References: <cover.1443973492.git.shli@fb.com> <581084e9c46ee200f8fedf2dcfec4e897517c0ed.1443973492.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <581084e9c46ee200f8fedf2dcfec4e897517c0ed.1443973492.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> Since superblock is updated infrequently, we do a simple trim of log
> disk (a synchronous trim)
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5-cache.c | 38 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 93097a8..6c52168 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -654,6 +654,42 @@ static void r5l_kick_io_unit(struct r5l_log *log)
>  }
>=20=20
>  static void r5l_write_super(struct r5l_log *log, sector_t cp);
> +static void r5l_write_super_and_discard_space(struct r5l_log *log,
> +	sector_t end)
> +{
> +	struct block_device *bdev =3D log->rdev->bdev;
> +	struct mddev *mddev;
> +
> +	r5l_write_super(log, end);
> +
> +	if (!blk_queue_discard(bdev_get_queue(bdev)))
> +		return;
> +
> +	mddev =3D log->rdev->mddev;
> +	if (!mddev_is_locked(mddev)) {
> +		set_bit(MD_CHANGE_PENDING, &mddev->flags);
> +		md_wakeup_thread(mddev->thread);
> +		wait_event(mddev->sb_wait,
> +			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
> +	} else { /* we are stopping the array, already take reconfig_mutex */
> +		md_update_sb(mddev, 1);
> +	}

No.

Just because mddev is locked, that doesn't mean that this thread owns
the lock.  Some other thread might just happen to have it locked for a
moment, and may unlock it long before we get to md_update_sb().

If you cannot block here, then you need to find a way to schedule the
discard after the md_update_sb() has happened.
Maybe set some flag, and in raid5d(), after md_check_recovery(), see if
the superblock has been written and if the discard is still pending, and
then do the discard. Maybe.

Or pass a flag into r5l_do_reclaim() to say whether this thread holds
the lock or not.

NeilBrown

> +
> +	if (log->last_checkpoint < end) {
> +		blkdev_issue_discard(bdev,
> +				log->last_checkpoint + log->rdev->data_offset,
> +				end - log->last_checkpoint, GFP_NOIO, 0);
> +	} else {
> +		blkdev_issue_discard(bdev,
> +				log->last_checkpoint + log->rdev->data_offset,
> +				log->device_size - log->last_checkpoint,
> +				GFP_NOIO, 0);
> +		blkdev_issue_discard(bdev, log->rdev->data_offset, end,
> +				GFP_NOIO, 0);
> +	}
> +}
> +
> +
>  static void r5l_do_reclaim(struct r5l_log *log)
>  {
>  	struct r5l_io_unit *io, *last;
> @@ -709,7 +745,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
>  	 * here, because the log area might be reused soon and we don't want to
>  	 * confuse recovery
>  	 */
> -	r5l_write_super(log, last->log_start);
> +	r5l_write_super_and_discard_space(log, last->log_start);
>=20=20
>  	mutex_lock(&log->io_mutex);
>  	log->last_checkpoint =3D last->log_start;
> --=20
> 2.4.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWFcyrAAoJEDnsnt1WYoG51i0P/1jh4OP9rWbJ5rsxfHIBD4Zb
ycLANRD+9uTwdOFE8eNcf1X6hr/tgfyCzVZPjkPeALbTK02W9gJloo/VLVI2OMnj
5ScX9FGLCWfmIymqHOQF/mMRkNf7PxduuFoBUBUyoejjkisXEtTXJ322ht0cBMId
tvcru8XarMUKQy+r5ObS+Kwce24kMRi+bFCcDlsgXKEjfy1mPUoN+y7Q0r3JtN+c
dc+OdoVQmwpHdwsflLUiFBE7Wnu7hOz7e7LfyravHZj/5XNZ9BMac5qpvmumKaTm
T3FESfBHMHyW3ki1K7Ups5XQNp/21OO01OpuNvomyT8Kk/sw0YYgmfzL+lG3+j2J
RzTLsk7K//H3HMx58tXQPgbanOkVJNWwR9JqWVSjz8OIb31/+fuZ1Xy5sXBTnYky
mTvj7nzPgwIMzq6K+rJwlJmH/PIu3g9dfGvPGfwsS+qG/LchyxEcxDn04fCg8V/F
NsYawvUBvkQw31hZKnYEY9VNur+UdFyQzujKjmIfPbqVQymdGvsswySiFUk3BNYF
ZT65FLUEoo6G5NnbNgPkc0ZGG+lW/fxyZrWlJe4hV2Blua4/rubrJZEICxrLxPax
TEwrlHowLr0mxG84zcVcVgcU7VbK4sxS3HdoBQC4ErII7u9CHniIFhdiViLgWaCN
0r1RJLg3gxpw+81aBoqb
=19ck
-----END PGP SIGNATURE-----
--=-=-=--
