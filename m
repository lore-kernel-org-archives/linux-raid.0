From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 2/2 v3]raid5: create multiple threads to handle stripes
Date: Wed, 26 Sep 2012 11:26:51 +1000
Message-ID: <20120926112651.728e8452@notabene.brown>
References: <20120809085808.GB30111@kernel.org>
	<201208111645321254409@gmail.com>
	<CANejiEVNPv6qVJ1nsvt21VMF8Py=3L8sABh9wab9eCQfdRAGeA@mail.gmail.com>
	<201208130906432967842@gmail.com>
	<20120813021324.GB447@kernel.org>
	<CANejiEUoguBD8PRAAuj=ATk+gd0RAqCTNjV12odSChejX-+R6Q@mail.gmail.com>
	<201208141839308288603@gmail.com>
	<CANejiEUjxR1Rt=2APf+kGXmzKYbcg_ZOztR3LirKbDERj7FG0A@mail.gmail.com>
	<2012081514211356241613@gmail.com>
	<CANejiEU_JeNGEeMO+u8_8pXt6jVfb5SBfnLUJSsSCrfr9bgi0A@mail.gmail.com>
	<201209241914270784655@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zJH/014L=d_dQNt/zkG7.3X"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201209241914270784655@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: shli <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/zJH/014L=d_dQNt/zkG7.3X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Sep 2012 19:15:12 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wro=
te:

> Sorry for using this title to send this.

It isn't hard to change the Subject line for the Email, is it?

> This code maybe error,so it should correct(If multiple-thread dosen't ena=
ble,it maybe also error,but no obviously).
> In func handle_parity_checks5:
> >>conf->mddev->resync_mismatches +=3D STRIPE_SECTORS;
> If multi-thread handle stripe on different cpu, there will be raced on re=
sync_mismatches.
>=20
> So the patch is:
>=20
> Subject: [PATCH] md:change resync_mismatches to atomic64_t to avoid races

I doubt this is really necessary, as resync_mismatches doesn't need to be
precise.
But it doesn't really hurt either, so I've applied it.

Thanks,
NeilBrown



>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c     |    7 ++++---
>  drivers/md/md.h     |    2 +-
>  drivers/md/raid1.c  |    2 +-
>  drivers/md/raid10.c |    2 +-
>  drivers/md/raid5.c  |    4 ++--
>  5 files changed, 9 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 308e87b..b0b9474 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4278,7 +4278,8 @@ static ssize_t
>  mismatch_cnt_show(struct mddev *mddev, char *page)
>  {
>  	return sprintf(page, "%llu\n",
> -		       (unsigned long long) mddev->resync_mismatches);
> +		       (unsigned long long)
> +		       atomic64_read(&mddev->resync_mismatches));
>  }
> =20
>  static struct md_sysfs_entry md_scan_mode =3D
> @@ -5245,7 +5246,7 @@ static void md_clean(struct mddev *mddev)
>  	mddev->new_layout =3D 0;
>  	mddev->new_chunk_sectors =3D 0;
>  	mddev->curr_resync =3D 0;
> -	mddev->resync_mismatches =3D 0;
> +	atomic64_set(&mddev->resync_mismatches, 0);
>  	mddev->suspend_lo =3D mddev->suspend_hi =3D 0;
>  	mddev->sync_speed_min =3D mddev->sync_speed_max =3D 0;
>  	mddev->recovery =3D 0;
> @@ -7349,7 +7350,7 @@ void md_do_sync(struct mddev *mddev)
>  		 * which defaults to physical size, but can be virtual size
>  		 */
>  		max_sectors =3D mddev->resync_max_sectors;
> -		mddev->resync_mismatches =3D 0;
> +		atomic64_set(&mddev->resync_mismatches, 0);
>  		/* we don't use the checkpoint if there's a bitmap */
>  		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
>  			j =3D mddev->resync_min;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index f385b03..8f341d8 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -282,7 +282,7 @@ struct mddev {
> =20
>  	sector_t			resync_max_sectors; /* may be set by personality */
> =20
> -	sector_t			resync_mismatches; /* count of sectors where
> +	atomic64_t			resync_mismatches; /* count of sectors where
>  							    * parity/replica mismatch found
>  							    */
> =20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 611b5f7..ebceb98 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1867,7 +1867,7 @@ static int process_checks(struct r1bio *r1_bio)
>  		} else
>  			j =3D 0;
>  		if (j >=3D 0)
> -			mddev->resync_mismatches +=3D r1_bio->sectors;
> +			atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
>  		if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
>  			      && test_bit(BIO_UPTODATE, &sbio->bi_flags))) {
>  			/* No need to write to this device. */
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 1c2eb38..ad0a8b7 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1950,7 +1950,7 @@ static void sync_request_write(struct mddev *mddev,=
 struct r10bio *r10_bio)
>  					break;
>  			if (j =3D=3D vcnt)
>  				continue;
> -			mddev->resync_mismatches +=3D r10_bio->sectors;
> +			atomic64_add(r10_bio->sectors, &mddev->resync_mismatches);
>  			if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
>  				/* Don't fix anything. */
>  				continue;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7031b86..0a2702f 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2931,7 +2931,7 @@ static void handle_parity_checks5(struct r5conf *co=
nf, struct stripe_head *sh,
>  			 */
>  			set_bit(STRIPE_INSYNC, &sh->state);
>  		else {
> -			conf->mddev->resync_mismatches +=3D STRIPE_SECTORS;
> +			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
>  			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
>  				/* don't try to repair!! */
>  				set_bit(STRIPE_INSYNC, &sh->state);
> @@ -3083,7 +3083,7 @@ static void handle_parity_checks6(struct r5conf *co=
nf, struct stripe_head *sh,
>  				 */
>  			}
>  		} else {
> -			conf->mddev->resync_mismatches +=3D STRIPE_SECTORS;
> +			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
>  			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
>  				/* don't try to repair!! */
>  				set_bit(STRIPE_INSYNC, &sh->state);


--Sig_/zJH/014L=d_dQNt/zkG7.3X
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGJZ2znsnt1WYoG5AQLrZw/+PhYG0KIsqtCUA7tyFJcJt6gBmre7sf5d
xRgVqC5z1s5Z1GMgmSBm6AWMz27dOz/eKzmBC3FCyF2xKZNUQgrcbtujbzivGaYg
C8t/nTzflsbepJYBePk+a4keerOkieSeVsBrt7bBSGMZD+6HTDiYfpQZdo4ETcqh
6RWoIy/0reofk45bkgCVKg+FyvVUOp7J2jH8wuz8TGzBmC97oIa4DwsHeu7K3Ywr
x/Dc1oP5ybK4+TTHy/in+wpiAS3r46ysyOqfzC0RxVhBsjjuBygpn0GuDLQ559Rt
sUuDEAZxb+smg8lQwe9IpEAqFTWPVj1PEsxe6VEUaKpE89FEIvLMgmk9nOSiSC4f
TmJL+RRpz434bMBXBEr3MkOqIJsO9DmIjVtnI9l9KNmcLPm8ep4rWsbXH4sYoFlv
/L5BBSU0cnivne3u1Q86FCFQcEQIpea/qoBEm5DWsUStss7w8TTvcexsQHGinXJC
Y3TiBf59Mr44gVCADLm5eznl5MzvprUvvdMl3nVx+0tnVYHuqqoiwhlT5qtUseT7
n6Blp2O9cDKNVmignD8cyJmr3XVdCjZ/zgdDyto1QPUYR8n0VTrz121zyYwfmlq2
SYZSc7o1hHJKKs6jhUHrfi1Gc6dS4HW1uYgHpx1SnuODN8OwXjCdJUSIxx8kdpqx
1FAjSdZpajM=
=9Ix0
-----END PGP SIGNATURE-----

--Sig_/zJH/014L=d_dQNt/zkG7.3X--
