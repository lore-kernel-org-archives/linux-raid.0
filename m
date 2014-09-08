From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Create.c: Try few more times to stop array after failed
 creation
Date: Mon, 8 Sep 2014 16:33:37 +1000
Message-ID: <20140908163337.6129ef3e@notabene.brown>
References: <20140905142612.10761.82358.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/yYsXR1Cp9imhglrzMjtFS9W"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140905142612.10761.82358.stgit@gklab-154-222.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

--Sig_/yYsXR1Cp9imhglrzMjtFS9W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 05 Sep 2014 16:26:13 +0200 Pawel Baldysiak
<pawel.baldysiak@intel.com> wrote:

> Sometimes after failure in creation (exp. due to duplicate devices
> in create command) newly created empty md array will not be stopped
> due to openers>1 (create_mddev will not manage to drop lock).
> In this case ioctl() will return error - this needs to be checked
> and if occurs - sending STOP_ARRAY should be repeat after delay
> to make sure that mddev is stopped correctly.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  Create.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/Create.c b/Create.c
> index 330c5b4..7c8e53e 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -904,7 +904,12 @@ int Create(struct supertype *st, char *mddev,
>  				if (st->ss->add_to_super(st, &inf->disk,
>  							 fd, dv->devname,
>  							 dv->data_offset)) {
> -					ioctl(mdfd, STOP_ARRAY, NULL);
> +					int count =3D 5;
> +					while (count &&
> +					       (ioctl(mdfd, STOP_ARRAY, NULL) < 0)) {
> +						usleep(100000);
> +						count--;
> +					}
>  					goto abort_locked;
>  				}
>  				st->ss->getinfo_super(st, inf, NULL);

I don't like this.  I don't really like any of the other loops like this th=
at
are already in the code either.  I wonder if we can avoid the need for it.

Given that the array hasn't been started yet, no other process can actually
be *using* the array.  And given that we have an O_EXCL open at this point,
no other process can be trying to stop/start the array.
So it should be safe to change the kernel to not fail in this situation.

If you apply this kernel patch:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1294238610df..1bf3fe1ecc79 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5362,7 +5362,7 @@ static int do_md_stop(struct mddev * mddev, int mode,
 	mddev_lock_nointr(mddev);
=20
 	mutex_lock(&mddev->open_mutex);
-	if (atomic_read(&mddev->openers) > !!bdev ||
+	if ((mddev->pers && atomic_read(&mddev->openers) > !!bdev) ||
 	    mddev->sysfs_active ||
 	    mddev->sync_thread ||
 	    (bdev && !test_bit(MD_STILL_CLOSED, &mddev->flags))) {


does that fir your problem?  Can you see any reason not to allow STOP_ARRAY
to succeed in this situation?

Thanks,
NeilBrown

--Sig_/yYsXR1Cp9imhglrzMjtFS9W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVA1NwTnsnt1WYoG5AQIAyA//ZOpEtT8w0A5MvJMeqoCULHZuCxPcm7MQ
+jaNPN1X4aLsfPN2Yz0k0qAu0ZMtQjVCbvZ7Z2pHiWlq/kPe1fBr6I1N6r3mAggT
6eFSXU3iOW88WR9V4YQuynqrIEvPtOvqEX5vNyfzM8qhnrwpg0fvyJeM/wY4VYAD
1x8q1pxcxIccsR7yI1KFKy89itmUj3116RsKXCT08te/gIxsDRDUu5aj1N2jhILj
rR02ZKBTot+X6cER2wTfOQ+EWOhAQI4pMIL0hYYpaHa7VTImFdSDak+zL42rbtN6
RA55bsEInESjPxTxVdu2gnEnu+3DyCR521J4gnWmsR4New0S82xKFtS2srhgLiWj
ECsRvGt/7wpFqzKD32Cd3hiKVT2xlDeQmG2AyDAsrznFLHUCPveMpWen3At4N7z3
HDIXajUhwD+8HosYwsjpGOWT+KUXd1mxyAOwc5e3qE9oD0tnD/UzQlxqjBl/LsB5
iaVtTM5NMCrvGb7ihAxp1pZhdpC0CI96UdxYc2GOcIdQEgPKQIVkvqEjg4cYFWPN
aDeubyBLXZqhPbbV/ZYWC05rC7qGNhF9Yz4XBQRuTJT323QJMVXqRbEhxAhknJK9
I2c/6zEzjqY4V90FN1It1Hzcqu3q0Km8QXTxbC/J990qC/z3KquOcr+o0E3exUyZ
x/M5q8i+v4Q=
=ghYi
-----END PGP SIGNATURE-----

--Sig_/yYsXR1Cp9imhglrzMjtFS9W--
