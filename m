From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 7/8] md: skip resync for raid array with journal
Date: Wed, 30 Sep 2015 14:24:31 +1000
Message-ID: <871tdgmt4w.fsf@notabene.neil.brown.name>
References: <cover.1441221530.git.shli@fb.com> <7c5622ab3335f31a27f807d8fee27f8bb60675ae.1441221530.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7c5622ab3335f31a27f807d8fee27f8bb60675ae.1441221530.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> If a raid array has journal, the journal can guarantee the consistency,
> we can skip resync after a unclean shutdown. The exception is raid
> creation or user initiated resync, which we still do a raid resync.
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c | 4 ++++
>  drivers/md/md.h | 1 +
>  2 files changed, 5 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b3f9eed..95824fb 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1669,6 +1669,8 @@ static int super_1_validate(struct mddev *mddev, st=
ruct md_rdev *rdev)
>  			}
>  			set_bit(Journal, &rdev->flags);
>  			rdev->journal_tail =3D le64_to_cpu(sb->journal_tail);
> +			if (mddev->recovery_cp =3D=3D MaxSector)
> +				set_bit(MD_JOURNAL_CLEAN, &mddev->flags);
>  			break;
>  		default:
>  			rdev->saved_raid_disk =3D role;
> @@ -1711,6 +1713,8 @@ static void super_1_sync(struct mddev *mddev, struc=
t md_rdev *rdev)
>  	sb->events =3D cpu_to_le64(mddev->events);
>  	if (mddev->in_sync)
>  		sb->resync_offset =3D cpu_to_le64(mddev->recovery_cp);
> +	else if (test_bit(MD_JOURNAL_CLEAN, &mddev->flags))
> +		sb->resync_offset =3D cpu_to_le64(MaxSector);
>  	else
>  		sb->resync_offset =3D cpu_to_le64(0);
>=20=20
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 226f4ba..0288a0b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -236,6 +236,7 @@ struct mddev {
>  #define MD_STILL_CLOSED	4	/* If set, then array has not been opened since
>  				 * md_ioctl checked on it.
>  				 */
> +#define MD_JOURNAL_CLEAN 5	/* A raid with journal is already clean */
>=20=20
>  	int				suspended;
>  	atomic_t			active_io;
> --=20
> 1.8.1

This looks right as far as it goes, but I don't think it goes far
enough.
The particular scenario that bothers me is if the array is started
without the journal being present.
I cannot see anything to prevent that - is there?

In that case we need to assume that the array is not in-sync,
and we need to clear MD_FEATURE_JOURNAL so if it gets stopped and then
assembled again with the stale journal doesn't get used.

One unfortunate side effect of that is that you couldn't stop the array
cleanly (leaving the journal effectively empty) and then restart with no
journal and no resync.  Is that a problem I wonder?

I'm not sure what the best solution is here, but we need a clear
understanding of what happens if you try to assemble an array without
the journal where previously it had one, and I don't think the current
code gets it right.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWC2P/AAoJEDnsnt1WYoG556wP/jG2Aqicof5jPRkr7YOpCWLQ
Wn0R53NIqkczQ7O3EguqG/5b65y/maKeIrnAg9zVu0XlYa8cwmm4N7ZvQfSRv1i4
i9cCUgekuDWjsD5pPlOB3zTjgn1lRYzyIa451uw8V9gVow6RAna9UYI7LV3V6I9c
4WJWfMhDDMzHkilrbJ8B0u+QFhLU0cglN+8hcP6oPgYitLA9zkjVHrGXy3lWZvm0
v7nLJHxhoQUJBRC1icZhOaz4iNIl8YFCrQpGFxeuva78wu9mP2l3rvr6db/5vvfz
mgRmSgEwHmwAOFYeMFQaet9qRacwtk9k8+eeXy10pNw784Rpa/+hIbeOv6Gqs/rn
LZ1KgVgdQcuoKdOZYqFAp6pI+9yUEZ8K8kYWz22K/7MViZN8U27sw8ea29c8w1kt
3cphoKpA2lkrdvlR0ucxNK3koHEPhQrN0oiwyVIYD/HD1ZQ8g0mNcYQwSn6P9gnd
VJohNrwpbzfyblN7M848uJJ/csqWOF36Id5taiRjPGiPL07Ej7rPlpduxGequ+Pe
34DWtjKiKp5Fvd+/ppAbz4uHPst3csgdOcmGJ3mRapgFKhjsAANk8eqx3gue/Iw8
RCbKVPH4p1EvfL6NrSYh5fJ70bOsV70qcknrWQFRxkGaDIvBtsvzumf08+jVrNHs
m1v9Wgd7qS7nha1iIeMY
=RZ2N
-----END PGP SIGNATURE-----
--=-=-=--
