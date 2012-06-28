From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 01/10 v3] raid5: use wake_up_all for overlap waking
Date: Thu, 28 Jun 2012 17:26:21 +1000
Message-ID: <20120628172621.463d9a84@notabene.brown>
References: <20120625072447.268095276@kernel.org>
	<20120625072553.970838108@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hvCYd09_irsp5D4M6TGQ72p"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120625072553.970838108@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/hvCYd09_irsp5D4M6TGQ72p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jun 2012 15:24:48 +0800 Shaohua Li <shli@kernel.org> wrote:

> It's possible several tasks are waiting for stripe overlap. We clear R5_O=
verlap
> bit and wake_up, but wake_up just wakes one task. So if there are several=
 tasks
> in the wait queue, some tasks will not be woken up even its strip R5_Over=
lap
> clear. The end result is tasks hang in make_request.
>=20
> wake_up_all should not introduce performance issue here, since overlap ca=
se is
> rare.

This is not necessary.
wake_up_all is only different from wake_up if WQ_FLAG_EXCLUSIVE it set, e.g.
by prepare_to_wait_exclusive.
As we don't use an exclusive wait to wait on wait_for_overlap, there is no
point in using wake_up_all, wake_up already wakes everything up.

NeilBrown


>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-06-19 08:11:10.021688417 +0800
> +++ linux/drivers/md/raid5.c	2012-06-19 08:11:29.833439339 +0800
> @@ -1399,7 +1399,7 @@ static void __raid_run_ops(struct stripe
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
>  			if (test_and_clear_bit(R5_Overlap, &dev->flags))
> -				wake_up(&sh->raid_conf->wait_for_overlap);
> +				wake_up_all(&sh->raid_conf->wait_for_overlap);
>  		}
>  	put_cpu();
>  }
> @@ -2436,7 +2436,7 @@ handle_failed_stripe(struct r5conf *conf
>  		}
> =20
>  		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
> -			wake_up(&conf->wait_for_overlap);
> +			wake_up_all(&conf->wait_for_overlap);
> =20
>  		while (bi && bi->bi_sector <
>  			sh->dev[i].sector + STRIPE_SECTORS) {
> @@ -2474,7 +2474,7 @@ handle_failed_stripe(struct r5conf *conf
>  			bi =3D sh->dev[i].toread;
>  			sh->dev[i].toread =3D NULL;
>  			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
> -				wake_up(&conf->wait_for_overlap);
> +				wake_up_all(&conf->wait_for_overlap);
>  			if (bi) s->to_read--;
>  			while (bi && bi->bi_sector <
>  			       sh->dev[i].sector + STRIPE_SECTORS) {
> @@ -3572,7 +3572,7 @@ static void handle_stripe(struct stripe_
>  	} else if (s.expanded && !sh->reconstruct_state && s.locked =3D=3D 0) {
>  		clear_bit(STRIPE_EXPAND_READY, &sh->state);
>  		atomic_dec(&conf->reshape_stripes);
> -		wake_up(&conf->wait_for_overlap);
> +		wake_up_all(&conf->wait_for_overlap);
>  		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
>  	}
> =20
> @@ -4249,7 +4249,7 @@ static sector_t reshape_request(struct m
>  		spin_lock_irq(&conf->device_lock);
>  		conf->reshape_safe =3D mddev->reshape_position;
>  		spin_unlock_irq(&conf->device_lock);
> -		wake_up(&conf->wait_for_overlap);
> +		wake_up_all(&conf->wait_for_overlap);
>  		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
>  	}
> =20
> @@ -4340,7 +4340,7 @@ static sector_t reshape_request(struct m
>  		spin_lock_irq(&conf->device_lock);
>  		conf->reshape_safe =3D mddev->reshape_position;
>  		spin_unlock_irq(&conf->device_lock);
> -		wake_up(&conf->wait_for_overlap);
> +		wake_up_all(&conf->wait_for_overlap);
>  		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
>  	}
>  	return reshape_sectors;
> @@ -5718,7 +5718,7 @@ static void end_reshape(struct r5conf *c
>  		smp_wmb();
>  		conf->reshape_progress =3D MaxSector;
>  		spin_unlock_irq(&conf->device_lock);
> -		wake_up(&conf->wait_for_overlap);
> +		wake_up_all(&conf->wait_for_overlap);
> =20
>  		/* read-ahead size must cover two whole stripes, which is
>  		 * 2 * (datadisks) * chunksize where 'n' is the number of raid devices
> @@ -5776,7 +5776,7 @@ static void raid5_quiesce(struct mddev *
> =20
>  	switch(state) {
>  	case 2: /* resume for a suspend */
> -		wake_up(&conf->wait_for_overlap);
> +		wake_up_all(&conf->wait_for_overlap);
>  		break;
> =20
>  	case 1: /* stop all writes */
> @@ -5792,14 +5792,14 @@ static void raid5_quiesce(struct mddev *
>  		conf->quiesce =3D 1;
>  		spin_unlock_irq(&conf->device_lock);
>  		/* allow reshape to continue */
> -		wake_up(&conf->wait_for_overlap);
> +		wake_up_all(&conf->wait_for_overlap);
>  		break;
> =20
>  	case 0: /* re-enable writes */
>  		spin_lock_irq(&conf->device_lock);
>  		conf->quiesce =3D 0;
>  		wake_up(&conf->wait_for_stripe);
> -		wake_up(&conf->wait_for_overlap);
> +		wake_up_all(&conf->wait_for_overlap);
>  		spin_unlock_irq(&conf->device_lock);
>  		break;
>  	}


--Sig_/hvCYd09_irsp5D4M6TGQ72p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+wHHTnsnt1WYoG5AQJHnhAAjPKz+h37y6TQQfX+x2CHOtiuweT1XpIS
nlD2ru8aYP9CqQ+WTR1xToYCSmbHEALlob5Swu5xmCxk1SZSf65mnP7iCzCVW0dq
swf1DJs2jGz0eCxuU0grGc8eYwc72up7Stjr2C6fP6Kl/M6vCV/pTcGb4nhSODAY
Zw9y8+kF3SqeXj2B5nL91hPgAVcagR3uN3XRoVBReXcXQ5SuTS9UsVgxG/gkrXFd
a2PYFDZhlAh6QYoRhD4psOLgPOr3NhCD2GXbU9HiiFjYEnO9wPwnoBc+/0k0n3aA
ES/I65wTMyxQT1XH0IHZ5oBiDhxvRZypmsL/huZKCAHqbcNW++RbrCM4ma3qUcwg
yAoBTB6GnsRr+6bucHukiWZy/Ts+Ok3TUAS7WdyASSUKXuXAFlQ0pH1wO3P9mdJp
wRz0k0q74UicwX2OzjeMgcr+EMiGO6GeLz9pCDxRE8zIMjOEi+YFpDH2K9StxFR8
MmSEE9eWk3xt0iQkETFRxiBCa2RBI0As3Ad6Qu8MWgggruC93ALbaS2uAtVoOdH2
WSahIS+0/853kgXvUsulWJ48UoX8JlnHrt/xAAtTA87HbDp0M56tDdQZYQ7Z7yN4
U2yV9FvlBzML2VQjn2NmsYRdVcvYIfkD9VZ3+CN0xOhKekMzA/Q2aVfuQsjGya2I
V8iKbhOJTBE=
=l105
-----END PGP SIGNATURE-----

--Sig_/hvCYd09_irsp5D4M6TGQ72p--
