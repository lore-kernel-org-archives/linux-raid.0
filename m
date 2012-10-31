From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/5] md: Increase the frequency of recording checkpoint
 of recovery.
Date: Wed, 31 Oct 2012 11:37:24 +1100
Message-ID: <20121031113724.567e9441@notabene.brown>
References: <201210271028177376247@gmail.com>
	<20121029084147.2d292bc5@notabene.brown>
	<201210291724062634040@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=01+fU58Sdfzt9/ag6Hk=Fr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201210291724062634040@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/=01+fU58Sdfzt9/ag6Hk=Fr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Oct 2012 17:24:11 +0800 majianpeng <majianpeng@gmail.com> wrote:

> >On Sat, 27 Oct 2012 10:28:20 +0800 majianpeng <majianpeng@gmail.com> wro=
te:
> >
> >> With the hard disk capacity of larger,the entire recovery process
> >> becomes longer.So it should increase the frequency.
> >> Supposed the speed of recovery is 100MB/s(i think for HDD is good).
> >> The total time of recovery 4TB hdd is about 666 minutes.So change the
> >> frequency from 16 to 64 times,it's about 10mins.
> >>=20
> >> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> >> ---
> >>  drivers/md/md.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>=20
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 01e25bd..ba328ee 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -7446,7 +7446,7 @@ void md_do_sync(struct md_thread *thread)
> >>  		if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> >>  		    ((mddev->curr_resync > mddev->curr_resync_completed &&
> >>  		      (mddev->curr_resync - mddev->curr_resync_completed)
> >> -		      > (max_sectors >> 4)) ||
> >> +		      > (max_sectors >> 6)) ||
> >>  		     (j - mddev->curr_resync_completed)*2
> >>  		     >=3D mddev->resync_max - mddev->curr_resync_completed
> >>  			    )) {
> >
> >I don't like this - the number '6' is completely arbitrary.
> >
> >The original '4' was never about number of minutes.  It was a fraction o=
f the
> >total effort needed.
> >I wanted to make sure you only repeated at most 10% of the required effo=
rt
> >(one order of magnitude).  >>4 is about 6% and easy to calculate.
> >
> >If you want it to be about time (which I don't object to), then make it =
about
> >time.  Keep track of the last time we updated curr_resync_completed, and=
 if
> >that is more than a few minutes ago, update it again.
> >This is what I said last time - if you want something to be based on tim=
e,
> >test the time.
> >If 'echo idle > sync_action' doesn't work (Which it seems it doesn't), t=
hen
> >it is OK to just do it in the kernel.
> >
> >NeilBrown
> >
> Ok, I used your suggestions.
>=20
> [PATCH V1] md:Updating checkpoint of resync/recovery based time.
>=20
> With the hard disk capacity of larger,the entire recovery process
> becomes longer.So it should increase the frequency.
> To do so there are a lot of benefits,for example
> 1:avoid doing repeated work when os crashed or suddenly power failure.
> 2:In md drivers, there are many places to be treated differently based
> on recovery_cp.For example, commit a7854487cd7128a30a7f4.
>=20
> It is difficult to judge how long it updated.There i chosed five
> minutes.No impact on performance.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9ab768a..eddb840 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7269,6 +7269,7 @@ EXPORT_SYMBOL_GPL(md_allow_write);
> =20
>  #define SYNC_MARKS	10
>  #define	SYNC_MARK_STEP	(3*HZ)
> +#define UPDATE_FREQUENCY (5*60*HZ)
>  void md_do_sync(struct md_thread *thread)
>  {
>  	struct mddev *mddev =3D thread->mddev;
> @@ -7277,6 +7278,7 @@ void md_do_sync(struct md_thread *thread)
>  		 window;
>  	sector_t max_sectors,j, io_sectors;
>  	unsigned long mark[SYNC_MARKS];
> +	unsigned long update_time;
>  	sector_t mark_cnt[SYNC_MARKS];
>  	int last_mark,m;
>  	struct list_head *tmp;
> @@ -7436,17 +7438,19 @@ void md_do_sync(struct md_thread *thread)
>  	mddev->curr_resync_completed =3D j;
>  	sysfs_notify(&mddev->kobj, NULL, "sync_completed");
>  	md_new_event(mddev);
> +	update_time =3D jiffies;
> =20
>  	blk_start_plug(&plug);
>  	while (j < max_sectors) {
>  		sector_t sectors;
> -
> +
>  		skipped =3D 0;
> =20
>  		if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>  		    ((mddev->curr_resync > mddev->curr_resync_completed &&
>  		      (mddev->curr_resync - mddev->curr_resync_completed)
>  		      > (max_sectors >> 4)) ||
> +		     time_after_eq(jiffies, update_time + UPDATE_FREQUENCY) ||
>  		     (j - mddev->curr_resync_completed)*2
>  		     >=3D mddev->resync_max - mddev->curr_resync_completed
>  			    )) {
> @@ -7454,6 +7458,7 @@ void md_do_sync(struct md_thread *thread)
>  			wait_event(mddev->recovery_wait,
>  				   atomic_read(&mddev->recovery_active) =3D=3D 0);
>  			mddev->curr_resync_completed =3D j;
> +			update_time =3D jiffies;
>  			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
>  			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
>  		}


Applied, thanks.

NeilBrown


--Sig_/=01+fU58Sdfzt9/ag6Hk=Fr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJByxTnsnt1WYoG5AQIwJxAAuIjKWkzSQmA5hQRAJ1t1Eh3NQB5wwnLZ
s4auJgEJJ6WdjvauTD9mJ27s29Ic+vFQStUMSvTLAWQ/0XyYGcy57O9Fb/FcjhNy
J1mufbhAJMx8M87L6OZ2AAHY6J5qhPhyCXIk4w6ylIe7R4T/JS5aqfD5MWMa3m8g
UbMfjYIsEkDQlrfWzSH0JcL9m2KFa1VmTC0W9gZuFqqP6hZ2Zv3X3ZzRBZYZ0aei
a+dl9zrfGBCiRvgqxWY5q6g2ZhbgZhKTY6+isqz9iQBcaq/TexeEL4tSkooP2t2a
S++rp8MlCppnG6NJ920XybwzpCBKVwcoiwbDHazlv+FjVcwSURUwrfgf60Soo+dU
gpmJI0mBut1nTwrPw3Nq8X+veu8wjTni8zsleBOtqh7XT4/ynkcFGxVRRdJqqfYe
2/XEFONAeIoy/0eWJFUjxW8TcdZTNvcr+5yW5pNgu/VY0hbWwhlmik4TT4kfPFCO
vbXciYcQBU7Vds7EjvWqoqAOmLeUcscmq6/oFpl1MtUVu8xufSff3pmXAI1dhp1f
PsXv0I0Y4rgL6QKgjfxQt80cVqZrZwSMS1cTPOPcyNOeIxuffkOY6r8DcDqpILIY
YJXo0EjSCumCkNvM93eE/FferUcSbA5TFBUSUUV7TgOjf/9rYJ967YiXPNhyNQaP
Vxpl5aqRqaQ=
=RMUp
-----END PGP SIGNATURE-----

--Sig_/=01+fU58Sdfzt9/ag6Hk=Fr--
