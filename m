From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: Add two chances to update sync/recovery checkpoint
Date: Thu, 20 Sep 2012 13:36:54 +1000
Message-ID: <20120920133654.1af42dda@notabene.brown>
References: <201209151659317342260@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9izV4hSHPdc58o.dpMwTX0S"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201209151659317342260@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/9izV4hSHPdc58o.dpMwTX0S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 15 Sep 2012 16:59:34 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wro=
te:

> According commit 97e4f42d62badb0f9fbc27c013e89,it has 16 times to update
> checkpoint of sync/recovery in func md_do_sync().
> Because the the size of HDD became larger,the time of sync/recovery may
> taken long times.So the 1/16 of time maybe half hour or more.
> So it should add chance to update checkpoint.
> There are places which can update checkpoint in md_do_sync.
> 1: If call cond_resched and really sched
> 2: If curr_speed is larger than max_sync_spedd
> If above conditions are ok, we can try to update checkpoint.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3f6203a..c7993d6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7496,7 +7496,14 @@ void md_do_sync(struct mddev *mddev)
>  		 * about not overloading the IO subsystem. (things like an
>  		 * e2fsck being done on the RAID array should execute fast)
>  		 */
> -		cond_resched();
> +		if (cond_resched())
> +			if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> +					mddev->curr_resync_completed !=3D j &&
> +					atomic_read(&mddev->recovery_active) =3D=3D 0) {
> +				mddev->curr_resync_completed =3D j;
> +				set_bit(MD_CHANGE_CLEAN, &mddev->flags);
> +				sysfs_notify(&mddev->kobj, NULL, "sync_completed");
> +			}
> =20
>  		currspeed =3D ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
>  			/((jiffies-mddev->resync_mark)/HZ +1) +1;
> @@ -7505,6 +7512,13 @@ void md_do_sync(struct mddev *mddev)
>  			if ((currspeed > speed_max(mddev)) ||
>  					!is_mddev_idle(mddev, 0)) {
>  				msleep(500);
> +				if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> +					mddev->curr_resync_completed !=3D j &&
> +					atomic_read(&mddev->recovery_active) =3D=3D 0) {
> +					mddev->curr_resync_completed =3D j;
> +					set_bit(MD_CHANGE_CLEAN, &mddev->flags);
> +					sysfs_notify(&mddev->kobj, NULL, "sync_completed");
> +				}
>  				goto repeat;
>  			}
>  		}

I don't really like this.  These two conditions seems rather arbitrary.
If we want to do a checkpoint more often, we should use some time based test
to do it.

What results do you get with this change?  How often does a checkpoint happ=
en
on a busy system?  How often on an idle system?

A time-based update could be done in user-space.  Just write 'idle' to
'sync_action' and it should do a checkpoint, then immediately restart from
where it left off.

NeilBrown

--Sig_/9izV4hSHPdc58o.dpMwTX0S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFqPVjnsnt1WYoG5AQJwNA/8D1XHGdkzXEZMhjwtBFmuT5D17Wwr1z1r
V4u9nwmZLeaoSSHJ5osXfuqoJSAxhjeMcwRrdOXS+AfDNpCYv5FME7SlZVjfTfA9
rx0vQwH3masRkwF3Jl8NZCJf9RwOWoPwt1Syr+g6aX3ED/EMBm0QIk0YbvQy0A4G
amdeAZ3ghoOI6PP4pw9HtYg0iEOOwx9Wqf8CKMBVokdtgloVdeB+k+aTPiQsvMGx
XWOa5s5pKTNgcoh0nUx8/AwcLIXNSF84VrI3HLKoPO5cLej1tLXcTToNXTC55iN2
EmWwfr8WOb2yQ7I2jOrTXEQEIOKW8IUCHRp6TTtGYDrshzl2a+MCl5Nun9aELkry
F9+5I52PewQ4PJ2+6rIsAVTGtStI646ntUhH9QkzE0yFvqW+ung9DB87HtXW7Oom
aeKA6f1m9OYqXMy4qQfDDt7qwFkNpe6YdMXO/0VOMRhbYedNvNJZIrKt8du1GH+J
ZQqUBp+u67nhkdyU3Xnwuiuy3GfEBDDYxonzPjYChmRqoaqaSs7cFYxIynIWYP92
R1jRj39Mn3UINWGOfo4SaqTZtN5yWOITRQyZpKRIV+pIdI72hL67VhtYiRgKJk0D
/ZyXILc7K34DoW3F7/scBZsdHLjyBX+N8uPCGuckII/UuIRmI0IqwyfIJlODhlFW
VMdGi3HOHEM=
=H7sg
-----END PGP SIGNATURE-----

--Sig_/9izV4hSHPdc58o.dpMwTX0S--
