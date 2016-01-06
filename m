From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/4] raid5-cache: avoid write failure for journal hotadd
Date: Wed, 06 Jan 2016 12:03:13 +1100
Message-ID: <87io37y0xa.fsf@notabene.neil.brown.name>
References: <cover.1452028077.git.shli@fb.com> <1eb31e4a94d3bb5d723164cdcb30a76d1feac7ef.1452028077.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1eb31e4a94d3bb5d723164cdcb30a76d1feac7ef.1452028077.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 06 2016, Shaohua Li wrote:

> r5l_log_disk_error() will make write request fail if there is no log,
> but MD_HAS_JOURNAL is set. When we hotadd journal, MD_HAS_JOURNAL is set
> but the r5l_log isn't fully initialized yet. Adding a new flag to
> indicate the situation and let r5l_log_disk_error() handle the
> situation.
>
> Based on Song Liu's original patch
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c          | 10 +++++++++-
>  drivers/md/md.h          |  2 ++
>  drivers/md/raid5-cache.c | 16 +++++++++++++---
>  3 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c0c3e6d..9f1d609 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6899,8 +6899,16 @@ static int md_ioctl(struct block_device *bdev, fmo=
de_t mode,
>  			else if (!(info.state & (1<<MD_DISK_SYNC)))
>  				/* Need to clear read-only for this */
>  				break;
> -			else
> +			else {
> +				if ((info.state & (1<<MD_DISK_JOURNAL)) &&
> +				    !test_bit(MD_HAS_JOURNAL, &mddev->flags))
> +					set_bit(MD_JOURNAL_NOT_INITIALIZED,
> +						&mddev->flags);
>  				err =3D add_new_disk(mddev, &info);
> +				if (err)
> +					clear_bit(MD_JOURNAL_NOT_INITIALIZED,
> +						&mddev->flags);
> +			}
>  			goto unlock;
>  		}
>  		break;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index e16a17c..d18e0d4 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -238,6 +238,8 @@ struct mddev {
>  #define MD_RELOAD_SB	7	/* Reload the superblock because another node
>  				 * updated it.
>  				 */
> +#define MD_JOURNAL_NOT_INITIALIZED 8 /* hot add a journal, and journal i=
sn't
> +				      * ready to use yet */
>=20=20
>  	int				suspended;
>  	atomic_t			active_io;
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 31e0fad..5a0f680 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -859,9 +859,17 @@ bool r5l_log_disk_error(struct r5conf *conf)
>  	rcu_read_lock();
>  	log =3D rcu_dereference(conf->log);
>=20=20
> -	if (!log)
> -		ret =3D test_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
> -	else
> +	if (!log) {
> +		ret =3D test_bit(MD_HAS_JOURNAL, &conf->mddev->flags) &&
> +		      !test_bit(MD_JOURNAL_NOT_INITIALIZED, &conf->mddev->flags);
> +		smp_mb__after_atomic();
> +		/*
> +		 * r5l_init_log sets ->log first and then clear INITIALIZED, we
> +		 * check in reverse order to avoid race condition.
> +		 */
> +		log =3D rcu_dereference(conf->log);
> +	}
> +	if (log)
>  		ret =3D test_bit(Faulty, &log->rdev->flags);
>  	rcu_read_unlock();
>  	return ret;
> @@ -1242,6 +1250,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rde=
v *rdev)
>  		goto error;
>=20=20
>  	rcu_assign_pointer(conf->log, log);
> +	smp_mb__before_atomic();
> +	clear_bit(MD_JOURNAL_NOT_INITIALIZED, &conf->mddev->flags);
>  	return 0;
>=20=20
>  error:
> --=20
> 2.4.6

I don't feel at all comfortable about this.
Having one flag saying "there is a journal" and another saying
"actually, no there isn't" just isn't very clean.

So I wondered "why is MD_HAS_JOURNAL set so early", and discovered it
being set in super_1_validate() - but in the wrong place.

super_1_validate should only make changes the mddev when
mddev->raid_disks is zero.  In that case all the array details are
initialised from the metadata.
Other calls to super_1_validate should validate that the new metadata
matches mddev, and may set some details in 'rdev'.
So:
			if (mddev->recovery_cp =3D=3D MaxSector)
				set_bit(MD_JOURNAL_CLEAN, &mddev->flags);
and
		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL)
			set_bit(MD_HAS_JOURNAL, &mddev->flags);

don't fit the pattern.

These should be moved to the "mddev->raid_disks =3D=3D 0" section of
super_1_validate.

Then when a journal is hot-added, the MD_HAS_JOURNAL flag should be set
once the journal is actually active.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWjGfRAAoJEDnsnt1WYoG5wMgP+gNpMAmv9PpG+8ccxwPKJzur
zcH+E9m5NqqTtG96mA2Y3o4d1BDR/72T22mYIilqhcXOZV6/XLVWnW6idnJLMkLY
kVlWnRf/I+k5+AVq48JHAeoBEaiyMvsa5+JC4HVrVLIaaD5rJsSgI6iJeZAJUQpV
QGe/qrd08ffbea89AF6TJzNBzfoVtITACKNZ744P5y00ua2KnRnAXqr7lLzIxOBH
ZuV6mDGE/UbTGGpQrvkl5Ijk4PwA8HhHMrEvSwgQM2HlrAYOsVUgiaeWCFrifHan
FUfUcr0kxwBc9fV636HHmCW9GgymXJsD7K3UmrrTEFZtCwhNSendYGhhyCXgzwld
DXwzI8FqtlgQZwzVNWog1xWrz5htouP9YNO9/zwH6Tumke3V/t+rmDF5xL9u+gNN
1hVKZCHn+vppecC/RlaZ3TIFep6dGi8Lm/Wc76Ekx7CpvwTamkzPuMT5Y9Jinpc/
uLX8c7pYK90evgAmTmwhhRWiM0HdlJo4oAqMX1UnAER3ejQwSyY6Bc6e9gWHZq5y
wH1KHPJc+sNuuWd0CBC2pJGQPBms/YHmwuzFmTgfyQDgRev4cJlGZAMLEw5QMdKc
fr7xvPIJ++76wjyK2ofijBLF45RwQ9ykVIZmXfndTsOdkoOVD6x7k1KrbhCvGKCo
W7ZIyGQwAUHQcEL0rZI4
=zlW4
-----END PGP SIGNATURE-----
--=-=-=--
