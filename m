From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 8/8] raid5-cache: add trim support for log
Date: Wed, 30 Sep 2015 14:14:58 +1000
Message-ID: <874micmtkt.fsf@notabene.neil.brown.name>
References: <cover.1441221530.git.shli@fb.com> <4ac2b019b16111478c46ea6decb672d5a4de7de3.1441221530.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ac2b019b16111478c46ea6decb672d5a4de7de3.1441221530.git.shli@fb.com>
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
>  drivers/md/raid5-cache.c | 30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 27fb513..410b85b 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -639,6 +639,34 @@ static void r5l_kick_io_unit(struct r5l_log *log)
>  }
>=20=20
>  static void r5l_write_super(struct r5l_log *log, sector_t cp);
> +static void r5l_write_super_and_discard_space(struct r5l_log *log,
> +	sector_t end)
> +{
> +	struct block_device *bdev =3D log->rdev->bdev;
> +
> +	r5l_write_super(log, end);
> +
> +	if (!blk_queue_discard(bdev_get_queue(bdev)))
> +		return;
> +
> +	/* discard destroy old data in log, so force a super update */
> +	md_update_sb(log->rdev->mddev, 1);

I don't think this can go here.

md_update_sb() is currently always called with ->reconfig_mutex held,
and I think that should stay.

Instead you could:
	set_bit(MD_CHANGE_PENDING, &mddev->flags);
	md_wakeup_thread(mddev->thread);
	wait_event(mddev->sb_wait,
		   !test_bit(MD_CHANGE_PENDING, &mddev->flags));

a bit like md_write_start().

Thanks,
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
> @@ -694,7 +722,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
>  	 * here, because the log area might be reused soon and we don't want to
>  	 * confuse recovery
>  	 * */
> -	r5l_write_super(log, last->log_start);
> +	r5l_write_super_and_discard_space(log, last->log_start);
>=20=20
>  	mutex_lock(&log->io_mutex);
>  	log->last_checkpoint =3D last->log_start;
> --=20
> 1.8.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWC2HCAAoJEDnsnt1WYoG5uS8QAIVJnaUu0KLkuPHDDW/BTn5D
LVd/jalPqfkkOq4FvxqBf3bVDlQATGSUnXgAcg/3/ztrFQ2Dyi58drCblrI3Pz/F
z6PGKnUO3pL4XQMSh5oZ1Y8l1xYDUeyf1/otQtXDbl3H8jMy8CsXl//sBIfIQbZ+
zrCVOyBgEgx2srePFZ64GPsde7199kVIWRYJJm3rG7/nrxzWKGSCvyc99WfG9SlP
rY16+4rfMAH+1AkKdjb9Jy4Lf83o2huvLJYBpqo+LiorwKNmc8KRY4mrqEeU3/My
sBENYL1U+oLLqfDdeM7zdg5twctvG52NqRudKT/blwMDmG8UGF3ZJOGcA4t9PGhl
OQiDtDFBCBxvnzErWM92eGHLm42VCDnsOf2x6XJ3mNaFyGgS8DpfkA1PfWNN5AkE
D5wNBBO7APqDXyigWRLDCDfRKW+DO8w1x8N7U5TZbqY74damjKiJhHlJnRZAVU2y
/4HXMD2XlUSgtNQHeQeZWUzWAjloG5iw/Sgfy9Q5QzKuJkYy+ept0MuPxq7v+tUw
qxMMDvpOaz/qSV3cXy6+0iZf7a78ZaFDhDiR8YNp88yjNLCzF4md/XPq+52h6DOl
6NbE7Sw3ZxuLhxwC7CGBIlGkah++I8Ds/HoJUofFgoBNR9e+N8r0SglQS3qrDwbz
DhOvS09XTnoeG3Q9fTkh
=eS2K
-----END PGP SIGNATURE-----
--=-=-=--
