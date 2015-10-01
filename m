From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/3] raid5-cache: add trim support for log
Date: Thu, 01 Oct 2015 14:41:09 +1000
Message-ID: <87pp0zjj4q.fsf@notabene.neil.brown.name>
References: <cover.1443653794.git.shli@fb.com> <9ee5464d20a78732ba4dda9c0601ea10d47f0e03.1443653794.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9ee5464d20a78732ba4dda9c0601ea10d47f0e03.1443653794.git.shli@fb.com>
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
>  drivers/md/raid5-cache.c | 44 ++++++++++++++++++++++++++++++++++++++++++=
+-
>  1 file changed, 43 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index a02f9ce..afc3b6b 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -654,6 +654,48 @@ static void r5l_kick_io_unit(struct r5l_log *log)
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
> +	/* discard destroy old data in log, so force a super update */
> +	mddev =3D log->rdev->mddev;
> +	/*
> +	 * mddev->thread could be shut down already in raid array stop. At that
> +	 * time, we should already lock reconfig_mutex
> +	 * */
> +	if (!mddev->thread) {
> +		WARN_ON(!mddev_is_locked(mddev));
> +		md_update_sb(mddev, 1);
> +	} else {
> +		set_bit(MD_CHANGE_PENDING, &mddev->flags);
> +		md_wakeup_thread(mddev->thread);
> +		wait_event(mddev->sb_wait,
> +			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
> +	}

I didn't like this.  It looks clumsy to me.

So I went to have a look at the code to understand why it was needed.
I found that r5l_exit_log() was being called from free_conf().
I didn't notice that before.

=2D>free() is only supposed to free, not write anything.  It could be too
late to write anything.

You need to get the raid5_quiesce(1) call to stablise the array.  It can
do the final r5l_do_reclaim().

So it is OK for free_conf to call r5l_exit_log as long as it only
deregisters the thread and frees the data structures.
The "r5l_do_reclaim" needs to be moved out.

I wonder where the md_update_sb() should go...

We currently calls "stop_writes" and then "mddev_detach".
So we shouldn't be writing anything by the time we get to mddev_detach,
but in there we wait for writes to complete.  That looks wrong.

I might move some of that stuff from mddev_detach to __md_stop_writes.
Then md_stop_writes can call ->quiesce and then md_update_sb().  That is
enough for raid5-cache to just call r5l_do_reclaim in raid5_quiesce, and
have the md_update_sb() called at the right time.

I'll see if i can make that work.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWDLlmAAoJEDnsnt1WYoG5icIP/RwtV4P38A6+zQim9ZoKd0Dn
lMMUwQJi0e21mlRlMG8mGrde3hFTe7Zbe+ViuQUB7r0eVqsaDRzwpOuSnFZgLgwt
vDDSh09+PrSxRms9v94XUr/IgrsTkhNrs60/6VvaXUZ8ThX6hH5qZR030/dQGHQK
8cxosFgGmbhepdMZYvbBLMPEmix0r6SLCtvCCP3El2iZEJlZ+K5zBf/g2sFEbVhQ
uyDsbA8LvCmLEJYDB18juIUYB2k7jPK7p20a+29OndG6AzBHczcPqok/Ov3++VzX
PYsext9VMGLZ4fagIHSGnE1o0OyhDtk7kQYHgjxjFo4XnxcCc6rwxVwPZaEosQO+
AO8Kx60e6G+vr3X/ZuBWCn6rgUXR37z/AJ8P6XdWQ7IgvIvbBYJ+vF/nqodRL34L
pgxjAicKFfNzThgdTi4umfz5f1jNLEavImf8kV5ENILhkHrCO6O0hQonJngxWUjp
07vILj7ZBsApQ/wMIT2mC+zuEkqchqZKeIHp8H99V60dTlzeq0Se8nfqLUwqL3b0
t5BeqRjjAU1yXwUiBrdSAEshrLexEWDglISbqb1wTHHolmcuYzR4XUJY2xDIOwos
P7kaqhiLafNduaL3lDJQJBEXw65m3HJe06Nkf5r4feIpfce6uUaHJc6nqMylxW/K
IFFGhNn8BD3/w7CnIXWH
=3x/X
-----END PGP SIGNATURE-----
--=-=-=--
