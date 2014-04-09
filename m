From: NeilBrown <neilb@suse.de>
Subject: Re: [patch]raid5: make_request does less prepare wait
Date: Wed, 9 Apr 2014 12:08:08 +1000
Message-ID: <20140409120808.40034647@notabene.brown>
References: <20140408040507.GA20886@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ryb6O5zOyNC5rnt1SLQY6Ke"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140408040507.GA20886@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Ryb6O5zOyNC5rnt1SLQY6Ke
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Apr 2014 12:05:07 +0800 Shaohua Li <shli@kernel.org> wrote:

>=20
> In NUMA machine, prepare_to_wait/finish_wait in make_request exposes a lo=
t of
> contention for sequential workload (or big request size workload). For su=
ch
> workload, each bio includes several stripes. So we can just do
> prepare_to_wait/finish_wait once for the whold bio instead of every strip=
e.
> This reduces the lock contention completely for such workload. Random wor=
kload
> might have the similar lock contention too, but I didn't see it yet, maybe
> because my stroage is still not fast enough.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>

Thanks,
this looks every sensible, except .....


> ---
>  drivers/md/raid5.c |   18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2014-04-08 09:04:20.000000000 +0800
> +++ linux/drivers/md/raid5.c	2014-04-08 09:11:08.201533487 +0800
> @@ -4552,6 +4552,8 @@ static void make_request(struct mddev *m
>  	struct stripe_head *sh;
>  	const int rw =3D bio_data_dir(bi);
>  	int remaining;
> +	DEFINE_WAIT(w);
> +	bool do_prepare;
> =20
>  	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
>  		md_flush_request(mddev, bi);
> @@ -4575,15 +4577,19 @@ static void make_request(struct mddev *m
>  	bi->bi_next =3D NULL;
>  	bi->bi_phys_segments =3D 1;	/* over-loaded to count active stripes */
> =20
> +	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
>  	for (;logical_sector < last_sector; logical_sector +=3D STRIPE_SECTORS)=
 {
>  		DEFINE_WAIT(w);
                ^^^^^^^^^^^^^^^

Shouldn't this be removed?  If so, please resubmit with that line deleted a=
nd
I'll apply the patch.

Thanks,
NeilBrown








>  		int previous;
>  		int seq;
> =20
> +		do_prepare =3D false;
>  	retry:
>  		seq =3D read_seqcount_begin(&conf->gen_lock);
>  		previous =3D 0;
> -		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
> +		if (do_prepare)
> +			prepare_to_wait(&conf->wait_for_overlap, &w,
> +				TASK_UNINTERRUPTIBLE);
>  		if (unlikely(conf->reshape_progress !=3D MaxSector)) {
>  			/* spinlock is needed as reshape_progress may be
>  			 * 64bit on a 32bit platform, and so it might be
> @@ -4604,6 +4610,7 @@ static void make_request(struct mddev *m
>  				    : logical_sector >=3D conf->reshape_safe) {
>  					spin_unlock_irq(&conf->device_lock);
>  					schedule();
> +					do_prepare =3D true;
>  					goto retry;
>  				}
>  			}
> @@ -4640,6 +4647,7 @@ static void make_request(struct mddev *m
>  				if (must_retry) {
>  					release_stripe(sh);
>  					schedule();
> +					do_prepare =3D true;
>  					goto retry;
>  				}
>  			}
> @@ -4663,8 +4671,10 @@ static void make_request(struct mddev *m
>  				prepare_to_wait(&conf->wait_for_overlap,
>  						&w, TASK_INTERRUPTIBLE);
>  				if (logical_sector >=3D mddev->suspend_lo &&
> -				    logical_sector < mddev->suspend_hi)
> +				    logical_sector < mddev->suspend_hi) {
>  					schedule();
> +					do_prepare =3D true;
> +				}
>  				goto retry;
>  			}
> =20
> @@ -4677,9 +4687,9 @@ static void make_request(struct mddev *m
>  				md_wakeup_thread(mddev->thread);
>  				release_stripe(sh);
>  				schedule();
> +				do_prepare =3D true;
>  				goto retry;
>  			}
> -			finish_wait(&conf->wait_for_overlap, &w);
>  			set_bit(STRIPE_HANDLE, &sh->state);
>  			clear_bit(STRIPE_DELAYED, &sh->state);
>  			if ((bi->bi_rw & REQ_SYNC) &&
> @@ -4689,10 +4699,10 @@ static void make_request(struct mddev *m
>  		} else {
>  			/* cannot get stripe for read-ahead, just give-up */
>  			clear_bit(BIO_UPTODATE, &bi->bi_flags);
> -			finish_wait(&conf->wait_for_overlap, &w);
>  			break;
>  		}
>  	}
> +	finish_wait(&conf->wait_for_overlap, &w);
> =20
>  	remaining =3D raid5_dec_bi_active_stripes(bi);
>  	if (remaining =3D=3D 0) {


--Sig_/Ryb6O5zOyNC5rnt1SLQY6Ke
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0SriDnsnt1WYoG5AQK2ohAAmVwSvKn+epLfUdsljwq0dsIBlDt4EJ75
x5dgSumFYFadY04sXdvDFsIXmsPP3dOLdlV5rTvaxOsQjb1ssGCuctlIQZNvzJnh
3mhluATGDqBl/XREuyK3GNY55vfxZmzOJbh3/kltdPwow0FdSWSWjLZGA1jzH7YG
AwPNMOHfF+YL/N4op+ZbUUWAURn+YCCBk3V1zJbT888cdjz5PYpVhtCIARoATvT6
YyBI0K5cAOHAWAfIFelwWIgHpI6nftSUzyQDh8iubM9Z6UdqtM+OcRd1HkX/ryDN
YYr+TQu9nMzGfbsMlJJm3dZzupOzRo3Z+lMK10XKVmBQJz54dOFVQp6G5Nu1ZdaX
UI8erH9axX3Dd3xDv8RTtHGrJVFpdxyU6AGtmJH4B/aYWoU0Y5Aq0nqDzYUC7XbF
V59/JMzmjR9p2VZKm/ZgLYzh9CPyVJ4tbXbmfMTaZLlUWHWwjZt/x3sptm3W9tTk
dffQ5XBZWmSJ7XrHCftdDybbDHP7y4w42EJdHYxvzRUCXcYhvNSDlThRfEMvvFVw
DXKapq8dJeS2f6jYLWRnuU6AHKDiBPLKY6RIzwuBNHXz4Xeu2QDFTbu+VOJ615mc
QzWmi+9Csgq8tcp0rbRtMtOXYFyH1i2VLd46+Say1Lap5F90jt3VRTfl7zs7QCgL
g5wxisyhMFg=
=B6IN
-----END PGP SIGNATURE-----

--Sig_/Ryb6O5zOyNC5rnt1SLQY6Ke--
