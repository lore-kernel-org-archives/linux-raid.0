From: NeilBrown <neilb@suse.de>
Subject: Re: About RAID1/10 io barrier between normal io and resync/recovery
 io.
Date: Thu, 1 Nov 2012 19:24:44 +1100
Message-ID: <20121101192444.2ac1050a@notabene.brown>
References: <2012110115580062797811@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tRfRlUtpI=UrPdoH3q_r7vK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012110115580062797811@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/tRfRlUtpI=UrPdoH3q_r7vK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Nov 2012 15:58:04 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Hi Neil:
> 	At present, there are barriers in raid1/10.About barrier,you described:	=
"Sometimes we need to suspend IO while we do something else,  either some r=
esync/recovery, or reconfigure the array"
>    So when do normal request in func make_request, it call wait_barrier.A=
nd in sync_request it call raise_barrier.
> Of course,there are some place to call raise_barrier to do other things.
> But there, i only wanted to talk about normal io and resync/recovery.
>=20
> 1:I think you add io barrier is because raid1/10 didn't stripe like raid4=
56.So it only for the situation which normal io and sync io had same conten=
t. Is that right?

Same sector, yes.

> 2: If normal ios outside the resync/recovery window, i think there is no =
necessary to use io barrier.

correct.

> I wanted to find the reason by reviewing the git log.But at present, git =
log of kernel is only after kernel 2.6.12.
> So i looked into the code about kernel 2.4.And found something like i tho=
ught. There were resync window.
> But why did you remove or modify ?

I didn't.  Ingo Molnar did.

http://git.kernel.org/?p=3Dlinux/kernel/git/tglx/history.git;a=3Dcommitdiff=
;h=3D0925bad356699684440720f2a908030f98bc3284

It wouldn't have generalised to raid10 very well (because resync and recove=
ry
are handled very differently in raid10).

> 3: I think using resync window to control normal io is perfect but compli=
cated.So i only used one positon which before mddev->curr_resync_completed.

Looks good, though I'll have a proper look next week when I have a bit more
time.

You only need the barrier for write operations, but I think we raise it for
read operations too.  We can probably skip that.

Thanks,
NeilBrown


> The code is:
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 8034fbd..c45a769 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -234,6 +234,7 @@ static void call_bio_endio(struct r1bio *r1_bio)
>  {
>         struct bio *bio =3D r1_bio->master_bio;
>         int done;
> +       int skip_barrier =3D test_bit(R1BIO_SKIP_BARRIER, &r1_bio->state);
>         struct r1conf *conf =3D r1_bio->mddev->private;
> =20
>         if (bio->bi_phys_segments) {
> @@ -253,7 +254,8 @@ static void call_bio_endio(struct r1bio *r1_bio)
>                  * Wake up any possible resync thread that waits for the =
device
>                  * to go idle.
>                  */
> -               allow_barrier(conf);
> +               if (!skip_barrier)
> +                       allow_barrier(conf);
>         }
>  }
> =20
> @@ -1007,6 +1009,7 @@ static void make_request(struct mddev *mddev, struc=
t bio * bio)
>         int first_clone;
>         int sectors_handled;
>         int max_sectors;
> +       int skip_barrier =3D 0;
> =20
>         /*
>          * Register the new request and wait if the reconstruction
> @@ -1036,7 +1039,13 @@ static void make_request(struct mddev *mddev, stru=
ct bio * bio)
>                 finish_wait(&conf->wait_barrier, &w);
>         }
> =20
> -       wait_barrier(conf);
> +       if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
> +               (bio->bi_sector + bio->bi_size/512 <=3D=20
> +                mddev->curr_resync_completed))
> +               skip_barrier =3D 1;
> +
> +       if (!skip_barrier)
> +               wait_barrier(conf);
> =20
>         bitmap =3D mddev->bitmap;
> =20
> @@ -1053,6 +1062,8 @@ static void make_request(struct mddev *mddev, struc=
t bio * bio)
>         r1_bio->mddev =3D mddev;
>         r1_bio->sector =3D bio->bi_sector;
> =20
> +       if (skip_barrier)
> +               set_bit(R1BIO_SKIP_BARRIER, &r1_bio->state);
>         /* We might need to issue multiple reads to different
>          * devices if there are bad blocks around, so we keep
>          * track of the number of reads in bio->bi_phys_segments.
> @@ -1229,10 +1240,15 @@ read_again:
>                 for (j =3D 0; j < i; j++)
>                         if (r1_bio->bios[j])
>                                 rdev_dec_pending(conf->mirrors[j].rdev, m=
ddev);
> -               r1_bio->state =3D 0;
> -               allow_barrier(conf);
> +               if (!skip_barrier)
> +                       r1_bio->state =3D 0;
> +               else
> +                       set_bit(R1BIO_SKIP_BARRIER, &r1_bio->state);
> +               if (!skip_barrier)
> +                       allow_barrier(conf);
>                 md_wait_for_blocked_rdev(blocked_rdev, mddev);
> -               wait_barrier(conf);
> +               if (!skip_barrier)
> +                       wait_barrier(conf);
>                 goto retry_write;
>         }
> =20
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index 0ff3715..fab9fda 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -158,6 +158,8 @@ struct r1bio {
>  #define        R1BIO_MadeGood 7
>  #define        R1BIO_WriteError 8
> =20
> +#define R1BIO_SKIP_BARRIER 9
> +
>  extern int md_raid1_congested(struct mddev *mddev, int bits);
> =20
>  #endif
>=20
> At present, the code only for normal io and sync io.But etc stop/remove d=
isk /add disk/fix_read_error also used io barrier.
> I used fio to test.
> The fio script is:
> [global]
> filename=3D/dev/md0
> direct=3D1
> bs=3D512K
>=20
> [write]
> rw=3Dwrite
> runtime=3D600
>=20
> [read]
> stonewall
> rw=3Dread
> runtime=3D600
>=20
> I firstly started resync/recovery for some times in order to normal io po=
sition is before curr_resync_completed.
> And i also keep the resync/recovery speed is about 30MB/s throught sys_sp=
eed_min.
> The result is:
> w/ above code:
> 	write  recovery/resync 30MB/S; fio 70MB/s
> 	read   recovery/resync 30MB/s;  fio 90MB/s
>=20
> w/o above code:
> 	write recovery/resync 30MB/s; fio 29MB/s
>     read  recovery/resync  30MB/s; fio  31MB/s
>=20
> The result is remarkable.
>=20
>=20
> Jianpeng

--Sig_/tRfRlUtpI=UrPdoH3q_r7vK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJIxzDnsnt1WYoG5AQLZHBAAmGuCMoKLKYMgRhE4eXGTIAltpxfgH0L2
E2Z6YpwQ9q7kK/a8TvOdA8ZlXlwEE2gSXrTyvN04v3S6E6i2RbuWqsJ8KNRKBBS2
obi8yQEQYuii+VoX7d9OyreNELOfPXM1FDljD17s+Vsd1qGfjcsAbVfXcfL6VRnt
eHw6Doxw+tI06vivJXJ7GJv5bveZBhOok4iU6WsCCnaS06ptJNApsYa69Jdi14wp
SWgdSkCB/WXKIJ47ISOBbP/tzfISy8WuM+3x2nBe7N2P0LYhmwGEltHttyYzrRUJ
WmSsRbAxoQZY7R+xXtfi4Am2Rhx1v7L7969M0cUDTGcuwwmrnUCdNy51MuaXXXoj
xABuXzq56vr/0C0xMLFuy4BnBETmvBqbqKouzh7CzebmBn1GpvxJlo2ebXpjFBYE
VfWjX6yTZlc+784RL1okv8eZzJlHw82Z+t41zxKjYviI9H1+6JCh1AoF+teQKzfQ
wsR0D9JiHjBRus20baBk4GHL/oZ9FiYTyHLi5vlJMXjmC3TeGFhyQoM/hy0mJrfL
Fw2GFoyJD7qDrKr8BQeUOQfDAuADM9Om6yGVX09ndzuJ2T3FY4X8b7xHbiyQ18Nw
fcnXMnGcRs4WHOVdUmMtCfvnHR2GJvmQYQ/VonZfx8VWLGMGJ2sFca29YtI9tycO
GObsllf5sS0=
=SgsQ
-----END PGP SIGNATURE-----

--Sig_/tRfRlUtpI=UrPdoH3q_r7vK--
