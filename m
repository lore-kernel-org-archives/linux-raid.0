From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] drivers: md: use ktime_get_real_seconds()
Date: Wed, 16 Dec 2015 15:18:38 +1100
Message-ID: <87k2of9gbl.fsf@notabene.neil.brown.name>
References: <1447384577-30866-1-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447384577-30866-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13 2015, Deepa Dinamani wrote:

> get_seconds() API is not y2038 safe on 32 bit systems and the API
> is deprecated. Replace it with calls to ktime_get_real_seconds()
> API instead. Change mddev structure types to time64_t accordingly.
>
> 32 bit signed timestamps will overflow in the year 2038.
>
> Change the user interface mdu_array_info_s structure timestamps:
> ctime and utime values used in ioctls GET_ARRAY_INFO and
> SET_ARRAY_INFO to unsigned int. This will extend the field to last
> until the year 2106.
> The long term plan is to get rid of ctime and utime values in
> this structure as this information can be read from the on-disk
> meta data directly.
>
> Clamp the tim64_t timestamps to positive values with a max of U32_MAX
> when returning from GET_ARRAY_INFO ioctl to accommodate above changes
> in the data type of timestamps to unsigned int.
>
> v0.90 on disk meta data uses u32 for maintaining time stamps.
> So this will also last until year 2106.
> Assumption is that the usage of v0.90 will be deprecated by
> year 2106.
>
> Timestamp fields in the on disk meta data for v1.0 version already
> use 64 bit data types. Remove the truncation of the bits while
> writing to or reading from these from the disk.
>
> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> ---
>
> Adding the maintainer lists for md.
>
> Notes:
>     A separate patch will update mdadm to obtain times from the metadata,
>     and to give a deprecation warning for use of v0.90 arrays
>
>  drivers/md/md.c                | 18 +++++++++---------
>  drivers/md/md.h                |  2 +-
>  include/uapi/linux/raid/md_u.h |  4 ++--
>  3 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7ab9ed9..20763ea 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1196,13 +1196,13 @@ static void super_90_sync(struct mddev *mddev, st=
ruct md_rdev *rdev)
>  	memcpy(&sb->set_uuid2, mddev->uuid+8, 4);
>  	memcpy(&sb->set_uuid3, mddev->uuid+12,4);
>=20=20
> -	sb->ctime =3D mddev->ctime;
> +	sb->ctime =3D clamp_t(time64_t, mddev->ctime, 0, U32_MAX);
>  	sb->level =3D mddev->level;
>  	sb->size =3D mddev->dev_sectors / 2;
>  	sb->raid_disks =3D mddev->raid_disks;
>  	sb->md_minor =3D mddev->md_minor;
>  	sb->not_persistent =3D 0;
> -	sb->utime =3D mddev->utime;
> +	sb->utime =3D clamp_t(time64_t, mddev->utime, 0, U32_MAX);
>  	sb->state =3D 0;
>  	sb->events_hi =3D (mddev->events>>32);
>  	sb->events_lo =3D (u32)mddev->events;
> @@ -1542,8 +1542,8 @@ static int super_1_validate(struct mddev *mddev, st=
ruct md_rdev *rdev)
>  		mddev->patch_version =3D 0;
>  		mddev->external =3D 0;
>  		mddev->chunk_sectors =3D le32_to_cpu(sb->chunksize);
> -		mddev->ctime =3D le64_to_cpu(sb->ctime) & ((1ULL << 32)-1);
> -		mddev->utime =3D le64_to_cpu(sb->utime) & ((1ULL << 32)-1);
> +		mddev->ctime =3D le64_to_cpu(sb->ctime);
> +		mddev->utime =3D le64_to_cpu(sb->utime);
>  		mddev->level =3D le32_to_cpu(sb->level);
>  		mddev->clevel[0] =3D 0;
>  		mddev->layout =3D le32_to_cpu(sb->layout);
> @@ -2331,7 +2331,7 @@ repeat:
>=20=20
>  	spin_lock(&mddev->lock);
>=20=20
> -	mddev->utime =3D get_seconds();
> +	mddev->utime =3D ktime_get_real_seconds();
>=20=20
>  	if (test_and_clear_bit(MD_CHANGE_DEVS, &mddev->flags))
>  		force_change =3D 1;
> @@ -5828,7 +5828,7 @@ static int get_array_info(struct mddev *mddev, void=
 __user *arg)
>  	info.major_version =3D mddev->major_version;
>  	info.minor_version =3D mddev->minor_version;
>  	info.patch_version =3D MD_PATCHLEVEL_VERSION;
> -	info.ctime         =3D mddev->ctime;
> +	info.ctime         =3D clamp_t(time64_t, mddev->ctime, 0, U32_MAX);
>  	info.level         =3D mddev->level;
>  	info.size          =3D mddev->dev_sectors / 2;
>  	if (info.size !=3D mddev->dev_sectors / 2) /* overflow */
> @@ -5838,7 +5838,7 @@ static int get_array_info(struct mddev *mddev, void=
 __user *arg)
>  	info.md_minor      =3D mddev->md_minor;
>  	info.not_persistent=3D !mddev->persistent;
>=20=20
> -	info.utime         =3D mddev->utime;
> +	info.utime         =3D clamp_t(time64_t, mddev->utime, 0, U32_MAX);
>  	info.state         =3D 0;
>  	if (mddev->in_sync)
>  		info.state =3D (1<<MD_SB_CLEAN);
> @@ -6338,13 +6338,13 @@ static int set_array_info(struct mddev *mddev, md=
u_array_info_t *info)
>  		/* ensure mddev_put doesn't delete this now that there
>  		 * is some minimal configuration.
>  		 */
> -		mddev->ctime         =3D get_seconds();
> +		mddev->ctime         =3D ktime_get_real_seconds();
>  		return 0;
>  	}
>  	mddev->major_version =3D MD_MAJOR_VERSION;
>  	mddev->minor_version =3D MD_MINOR_VERSION;
>  	mddev->patch_version =3D MD_PATCHLEVEL_VERSION;
> -	mddev->ctime         =3D get_seconds();
> +	mddev->ctime         =3D ktime_get_real_seconds();
>=20=20
>  	mddev->level         =3D info->level;
>  	mddev->clevel[0]     =3D 0;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index f5b9aad..237b507 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -261,7 +261,7 @@ struct mddev {
>  							 * managed externally */
>  	char				metadata_type[17]; /* externally set*/
>  	int				chunk_sectors;
> -	time_t				ctime, utime;
> +	time64_t			ctime, utime;
>  	int				level, layout;
>  	char				clevel[16];
>  	int				raid_disks;
> diff --git a/include/uapi/linux/raid/md_u.h b/include/uapi/linux/raid/md_=
u.h
> index 1cb8aa6..36cd821 100644
> --- a/include/uapi/linux/raid/md_u.h
> +++ b/include/uapi/linux/raid/md_u.h
> @@ -80,7 +80,7 @@ typedef struct mdu_array_info_s {
>  	int major_version;
>  	int minor_version;
>  	int patch_version;
> -	int ctime;
> +	unsigned int ctime;
>  	int level;
>  	int size;
>  	int nr_disks;
> @@ -91,7 +91,7 @@ typedef struct mdu_array_info_s {
>  	/*
>  	 * Generic state information
>  	 */
> -	int utime;		/*  0 Superblock update time		      */
> +	unsigned int utime;	/*  0 Superblock update time		      */
>  	int state;		/*  1 State bits (clean, ...)		      */
>  	int active_disks;	/*  2 Number of currently active disks	      */
>  	int working_disks;	/*  3 Number of working disks		      */
> --=20
> 1.9.1


Applied, thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWcOYeAAoJEDnsnt1WYoG5EzAQALGYUseyejOyFXTYT8vIaNeP
BStpufmY69Gv+mJMbuOhS/2OF1hRy2m5Y9tAfzbHQGWrMJPMvhm+kFLCoxWx3BJK
FMiCY/VH81N4tRVj+PquoqjC0de9pvsenI3et0sjQzLlze81W+vwDteVV6rO1dup
T1kX9rJNw3Abb+3JrdSfEvxtaQPYyws1QwZ+aNH6rQPC5pGqS8y/StyF19V5TeNU
AjSqm0wsAjmQmKcMSLdWt+bJd9XPx4INDwd4LLZuk4NzMLReQmTJnZuCqRF2c9z2
7sFj19Nt3PJh7a4hoZlxJ1WuEcqqG1++KwXruIO9kj7GJt3qI8leqD+44OSADkwI
lV7bMBVlRnxUIvikPCcJgQNsMbLji+NJqeGTjUaIujazH9kVbLe+5PvCI/SpDJtw
/7+RKpEvvE/ImVyjbTfZqS66ZpCeEmNVAcQkWAuItwfOydOZ55z/X3q7LTHGY0ng
4HFhvOgBCLjUNOLx5vR9lkNL9aTNEwqxZ+QGqDrOEdnnpPdYyze9h41BB/9mUf6Z
9gtZhlw+Mgsn81PSJtuTWLWCKuxpGHeC9xttSRz/aC+Iai5yU64jNwPjZIXUJRO+
PPwVucghKRxaFGmj3nmmeRZRIJDtQoFwT+M9VRozKEJA7Z0rLL679VLFlXIfsSsI
NM0CygcaBf36CTs27Erc
=OvK2
-----END PGP SIGNATURE-----
--=-=-=--
