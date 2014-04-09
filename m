From: NeilBrown <neilb@suse.de>
Subject: Re: [patch]raid5: make_request does less prepare wait
Date: Wed, 9 Apr 2014 15:23:25 +1000
Message-ID: <20140409152325.4c1366a7@notabene.brown>
References: <20140408040507.GA20886@kernel.org>
	<20140409120808.40034647@notabene.brown>
	<20140409032547.GA1891@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Uct=3GXw08gmTOFwK4GB0ka"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140409032547.GA1891@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Uct=3GXw08gmTOFwK4GB0ka
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 9 Apr 2014 11:25:47 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Wed, Apr 09, 2014 at 12:08:08PM +1000, NeilBrown wrote:
> > On Tue, 8 Apr 2014 12:05:07 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > >=20
> > > In NUMA machine, prepare_to_wait/finish_wait in make_request exposes =
a lot of
> > > contention for sequential workload (or big request size workload). Fo=
r such
> > > workload, each bio includes several stripes. So we can just do
> > > prepare_to_wait/finish_wait once for the whold bio instead of every s=
tripe.
> > > This reduces the lock contention completely for such workload. Random=
 workload
> > > might have the similar lock contention too, but I didn't see it yet, =
maybe
> > > because my stroage is still not fast enough.
> > >=20
> > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> >=20
> > Thanks,
> > this looks every sensible, except .....
> >=20
> >=20
> > > ---
> > >  drivers/md/raid5.c |   18 ++++++++++++++----
> > >  1 file changed, 14 insertions(+), 4 deletions(-)
> > >=20
> > > Index: linux/drivers/md/raid5.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- linux.orig/drivers/md/raid5.c	2014-04-08 09:04:20.000000000 +0800
> > > +++ linux/drivers/md/raid5.c	2014-04-08 09:11:08.201533487 +0800
> > > @@ -4552,6 +4552,8 @@ static void make_request(struct mddev *m
> > >  	struct stripe_head *sh;
> > >  	const int rw =3D bio_data_dir(bi);
> > >  	int remaining;
> > > +	DEFINE_WAIT(w);
> > > +	bool do_prepare;
> > > =20
> > >  	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
> > >  		md_flush_request(mddev, bi);
> > > @@ -4575,15 +4577,19 @@ static void make_request(struct mddev *m
> > >  	bi->bi_next =3D NULL;
> > >  	bi->bi_phys_segments =3D 1;	/* over-loaded to count active stripes =
*/
> > > =20
> > > +	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
> > >  	for (;logical_sector < last_sector; logical_sector +=3D STRIPE_SECT=
ORS) {
> > >  		DEFINE_WAIT(w);
> >                 ^^^^^^^^^^^^^^^
> >=20
> > Shouldn't this be removed?  If so, please resubmit with that line delet=
ed and
> > I'll apply the patch.
>=20
> Ah, that's silly, looks I sent wrong patch, sorry! Below is the correct o=
ne and I double
> checked it's the one working for me.
>=20
>=20
> Subject: raid5: make_request does less prepare wait
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
> ---
>  drivers/md/raid5.c |   19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2014-04-08 12:02:54.485630590 +0800
> +++ linux/drivers/md/raid5.c	2014-04-09 11:03:04.276210597 +0800
> @@ -4552,6 +4552,8 @@ static void make_request(struct mddev *m
>  	struct stripe_head *sh;
>  	const int rw =3D bio_data_dir(bi);
>  	int remaining;
> +	DEFINE_WAIT(w);
> +	bool do_prepare;
> =20
>  	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
>  		md_flush_request(mddev, bi);
> @@ -4575,15 +4577,18 @@ static void make_request(struct mddev *m
>  	bi->bi_next =3D NULL;
>  	bi->bi_phys_segments =3D 1;	/* over-loaded to count active stripes */
> =20
> +	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
>  	for (;logical_sector < last_sector; logical_sector +=3D STRIPE_SECTORS)=
 {
> -		DEFINE_WAIT(w);
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
> @@ -4604,6 +4609,7 @@ static void make_request(struct mddev *m
>  				    : logical_sector >=3D conf->reshape_safe) {
>  					spin_unlock_irq(&conf->device_lock);
>  					schedule();
> +					do_prepare =3D true;
>  					goto retry;
>  				}
>  			}
> @@ -4640,6 +4646,7 @@ static void make_request(struct mddev *m
>  				if (must_retry) {
>  					release_stripe(sh);
>  					schedule();
> +					do_prepare =3D true;
>  					goto retry;
>  				}
>  			}
> @@ -4663,8 +4670,10 @@ static void make_request(struct mddev *m
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
> @@ -4677,9 +4686,9 @@ static void make_request(struct mddev *m
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
> @@ -4689,10 +4698,10 @@ static void make_request(struct mddev *m
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


Applied, thanks.

NeilBrown

--Sig_/Uct=3GXw08gmTOFwK4GB0ka
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0TZTTnsnt1WYoG5AQKGLxAAwQ8MFsdYsnfw8OO84xOJ3fVyw9W6QmXC
wLaPDH/yHRlDmGnl7ETllfasJNVgWkI/SFz+0ZWPkI11ghr9vhKyfm2N0cjnJyHr
gM7SZv5GVlZR+LRqN0ZmYZkMTUQGSt1h8tUluAENI2LPY1W3CXb2jzyrvlipPBUU
IJ16XbrFDF1rB4+HHn0oLmssiNvSF4/UtERJf7sXwhf7Bx7QyWxp+vYQk2ccPR8b
1uY3pV8touU8QFyWWPlCoipPLrnLuA/qI8tD0Ef+rL0d49qSTuqpYv0uqvC2xcPT
Yat9+0NdwJBfSAUdNw4QusyR0Cx7Lv2l+H/OkBgMeZqYxxRXRNdaHTBhr8VqawHO
FpBiA2x6sDaFA/Fr1QTtjbuU0e99NiHdLTv7CvHLH8yNp9YLmI91wkvu8SQ+dSgY
QKOfBGhac4LPlYusRiNW5alKFF6FyWBOEWhQdYWS6lkAgk0ECimgQPUMbVCM6LVv
+ZOdfUUr1AXb4hpM7pxPgfhg+9aBJfFuy7EUPlT3+1ks8Gmes4oyMfhMnkYKIP4H
dHySNhPXn3KdS9NJY7E+FTjicADq+n0qG797UGr7DR4Pkhe57XsCf/UrDGW89cWy
DGGD0hwRCmoizTWWdKP4pfD9vqpD/8MEujHzs8SA2FWiGsv2hmCLh6Tn9Rdf21Nw
EDZA0OM97Nw=
=MrF6
-----END PGP SIGNATURE-----

--Sig_/Uct=3GXw08gmTOFwK4GB0ka--
