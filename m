From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix race between removing raid1 device and I/O error
 handling on underlying device
Date: Tue, 9 Oct 2012 11:58:22 +1100
Message-ID: <20121009115822.50e5f305@notabene.brown>
References: <1349704634-18904-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/v1+9ANY/8QqAnoOxe8P2T3r"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1349704634-18904-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, pyu@redhat.com
List-Id: linux-raid.ids

--Sig_/v1+9ANY/8QqAnoOxe8P2T3r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon,  8 Oct 2012 15:57:14 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Avoid calling rdev_set_badblocks() if the underlying device has been
> removed by raid1d() prior to calling fix_read_error().
>=20
> This should be applicable to the 3.x stable kernel series as well.
>=20
> Original bug analysis from Peng Yu:
>=20
> Assume this condition:
>=20
> We have a software raid1 device /dev/md0, it has two underlying
> devices, they are /dev/sda and /dev/sdb. Assign an IO to sda,
> rdev->pending add 1, an IO error occur on sda, rdev->pending dec 1,
> then wakeup the raid1d thread. At the same time, a user run such a
> command:
>=20
> Kernel will set Faulty bit to rdev->flags, then wakeup raid1d
> thread. The raid1d thread will call md_check_recovery function, this
> function will call raid1_remove_disk function if it see the Faulty
> flag is set. In raid1_remove_disk function, the rdev->nr_pending is
> zero, so it will set rdev to NULL. Then raid1d thread return from
> md_check_recovery function, continue call handle_read_error to hand
> the read error, handle_read_error function will call fix_read_error
> function, in fix_read_error function, see these lines:
>=20
> 		if (!success) {
> 			/* Cannot read from anywhere - mark it bad */
> 			struct md_rdev *rdev =3D conf->mirrors[read_disk].rdev;
> 			if (!rdev_set_badblocks(rdev, sect, s, 0))
> 				md_error(mddev, rdev);
> 			break;
> 		}
>=20
> It doesn't check whether the rdev is NULL, just pass it to
> rdev_set_badblocks function, and it maybe a NULL pointer, so the
> kernel crash.
>=20
> Reported-by: Peng Yu <pyu@redhat.com>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  drivers/md/raid1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 611b5f7..ffdad74 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2005,7 +2005,7 @@ static void fix_read_error(struct r1conf *conf, int=
 read_disk,
>  		if (!success) {
>  			/* Cannot read from anywhere - mark it bad */
>  			struct md_rdev *rdev =3D conf->mirrors[read_disk].rdev;
> -			if (!rdev_set_badblocks(rdev, sect, s, 0))
> +			if (rdev && !rdev_set_badblocks(rdev, sect, s, 0))
>  				md_error(mddev, rdev);
>  			break;
>  		}


Hi Jes,
this was already reported on linux-raid and I said I didn't like that fix
because I think it is wrong that the rdev could be removed while we are
trying to fix a read error on it.
So I've applied this following which is in -next.

NeilBrown


=46rom c809064145d88b873c6acdced5a412aabbe8b8e5 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 27 Sep 2012 12:37:27 +1000
Subject: [PATCH] md/raid1: Don't release reference to device while handling
 read error.

When we get a read error, we arrange for raid1d to handle it.
Currently we release the reference on the device.  This can result
in
   conf->mirrors[read_disk].rdev
being NULL in fix_read_error, if the device happens to get removed
before the read error is handled.

So instead keep the reference until the read error has been fully
handled.

Reported-by: hank <pyu@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3092afe..d705f9e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -333,9 +333,10 @@ static void raid1_end_read_request(struct bio *bio, in=
t error)
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
=20
-	if (uptodate)
+	if (uptodate) {
 		raid_end_bio_io(r1_bio);
-	else {
+		rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
+	} else {
 		/*
 		 * oops, read error:
 		 */
@@ -349,9 +350,8 @@ static void raid1_end_read_request(struct bio *bio, int=
 error)
 			(unsigned long long)r1_bio->sector);
 		set_bit(R1BIO_ReadError, &r1_bio->state);
 		reschedule_retry(r1_bio);
+		/* don't drop the reference on read_disk yet */
 	}
-
-	rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
 }
=20
 static void close_write(struct r1bio *r1_bio)
@@ -2228,6 +2228,7 @@ static void handle_read_error(struct r1conf *conf, st=
ruct r1bio *r1_bio)
 		unfreeze_array(conf);
 	} else
 		md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
+	rdev_dec_pending(conf->mirrors[r1_bio->read_disk].rdev, conf->mddev);
=20
 	bio =3D r1_bio->bios[r1_bio->read_disk];
 	bdevname(bio->bi_bdev, b);

--Sig_/v1+9ANY/8QqAnoOxe8P2T3r
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUHN2rjnsnt1WYoG5AQInuxAAgKGSAH1LDnTY2XX/ifO3BFmZZ6Mq+6Jf
xldGh9G8oumgXluDqHOjI1gueJUJEj2dQ0oJqh1cT7m/BASDzOq/x38RBYCLSE6Q
OZ1bIIPgxP7/ctfz1zMGKNA92oG7/VO38e+HeH10A1ziWRou+/11iWAsMYWdjz+P
lvM4Ni14fh+7jGfFl7HVtK+/fOrDJ62UwVq/rpMtIXFAMiNj8jp2bzqxzqCjVveE
+EifJ+Cy/iwcPf7ACqmAK9iUJbMSUxY0gR4AJxl3Piecv7DazBXGY4KWilLfU1wL
Mt6ezO1GicUgIzNKqFk1omRcJM0Ar0GokJCfuTtoarYIh+LE5jWwgH48V3pfIzGw
RnH/dWJxEaa4+RCiVjSzdnIWBGsR8BYLa4lgBZidCw//fiyhXXmhDk/+3Ks4scpV
kAIYTvCAChs4Rr/WYeDLDmEtoV2LlijZoyRhS6MxuAbqCQ7UdHEU1NsDgN1G8DrP
6KKyWziagIOc+OCCdQmnlcH7PFnAoOVhC/ZR1siDdKQpjNQuCHX1yPByxorg/H0E
ASHg5g7ZbiCCVfYu61PgJ1VywtY7H6KB0rUYG5F9EA5mDTqUzB3Yy/Fv9aif7co3
a9MuQKh4bPg07uFrh6nwyOvIsNMN8NsSHeYpBRODiDYaK7JYfwEwHuKZRaWi21e3
v/uakakuYPQ=
=vao3
-----END PGP SIGNATURE-----

--Sig_/v1+9ANY/8QqAnoOxe8P2T3r--
