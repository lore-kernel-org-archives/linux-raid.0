From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5:Choose to replacing or recoverying when  raid
 degraded and had a want_replacement disk at the same time.
Date: Wed, 6 Jun 2012 11:28:03 +1000
Message-ID: <20120606112803.359c62cc@notabene.brown>
References: <201206051532527348313@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/op5J7GCYI/hSHEcst4sTY=_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206051532527348313@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/op5J7GCYI/hSHEcst4sTY=_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Jun 2012 15:32:56 +0800 majianpeng <majianpeng@gmail.com> wrote:

> In Commit 7bfec5f35c68121e7b1849f3f4166dd96c8da5b3:
> "if there is a spare and a want_replacement device, start replacement."
> But it did not consider the raid was degraded at the same time.
> When we add spare disk in order to recovery, unless raid was ok and then
> started replacement or vice versa.
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |   48 +++++++++++++++++++++++++++++-----------------=
--
>  1 files changed, 29 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d267672..f74c9a5 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5447,6 +5447,8 @@ static int raid5_add_disk(struct mddev *mddev, stru=
ct md_rdev *rdev)
>  	struct disk_info *p;
>  	int first =3D 0;
>  	int last =3D conf->raid_disks - 1;
> +	int null_disk =3D -1;
> +	int wantreplace_disk =3D -1;
> =20
>  	if (mddev->recovery_disabled =3D=3D conf->recovery_disabled)
>  		return -EBUSY;
> @@ -5468,27 +5470,35 @@ static int raid5_add_disk(struct mddev *mddev, st=
ruct md_rdev *rdev)
>  		disk =3D rdev->saved_raid_disk;
>  	else
>  		disk =3D first;
> -	for ( ; disk <=3D last ; disk++) {
> +	for ( ; disk <=3D last; disk++) {
>  		p =3D conf->disks + disk;
> -		if (p->rdev =3D=3D NULL) {
> -			clear_bit(In_sync, &rdev->flags);
> -			rdev->raid_disk =3D disk;
> -			err =3D 0;
> -			if (rdev->saved_raid_disk !=3D disk)
> -				conf->fullsync =3D 1;
> -			rcu_assign_pointer(p->rdev, rdev);
> -			break;
> -		}
> -		if (test_bit(WantReplacement, &p->rdev->flags) &&
> -		    p->replacement =3D=3D NULL) {
> -			clear_bit(In_sync, &rdev->flags);
> -			set_bit(Replacement, &rdev->flags);
> -			rdev->raid_disk =3D disk;
> -			err =3D 0;
> +		if (p->rdev =3D=3D NULL && null_disk =3D=3D -1)
> +			null_disk =3D disk;
> +		else if (p->rdev !=3D NULL &&
> +			test_bit(WantReplacement, &p->rdev->flags) &&
> +			p->replacement =3D=3D NULL &&
> +			wantreplace_disk =3D=3D -1)
> +			wantreplace_disk =3D disk;
> +	}
> +
> +	if (null_disk !=3D -1 && (rdev->raid_disk < 0 ||
> +			wantreplace_disk =3D=3D -1)) {
> +		p =3D conf->disks + null_disk;
> +		clear_bit(In_sync, &rdev->flags);
> +		rdev->raid_disk =3D null_disk;
> +		err =3D 0;
> +		if (rdev->saved_raid_disk !=3D null_disk)
>  			conf->fullsync =3D 1;
> -			rcu_assign_pointer(p->replacement, rdev);
> -			break;
> -		}
> +		rcu_assign_pointer(p->rdev, rdev);
> +	} else if (wantreplace_disk !=3D -1 && (rdev->raid_disk >=3D 0 ||
> +				null_disk =3D=3D -1)) {
> +		p =3D conf->disks + wantreplace_disk;
> +		clear_bit(In_sync, &rdev->flags);
> +		set_bit(Replacement, &rdev->flags);
> +		rdev->raid_disk =3D wantreplace_disk;
> +		err =3D 0;
> +		conf->fullsync =3D 1;
> +		rcu_assign_pointer(p->replacement, rdev);
>  	}
>  	print_raid5_conf(conf);
>  	return err;

Good point, but the code feels a little ... clumsy.

How about this?

NeilBrown


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d267672..4f0861e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5465,10 +5465,9 @@ static int raid5_add_disk(struct mddev *mddev, struc=
t md_rdev *rdev)
 	if (rdev->saved_raid_disk >=3D 0 &&
 	    rdev->saved_raid_disk >=3D first &&
 	    conf->disks[rdev->saved_raid_disk].rdev =3D=3D NULL)
-		disk =3D rdev->saved_raid_disk;
-	else
-		disk =3D first;
-	for ( ; disk <=3D last ; disk++) {
+		first =3D rdev->saved_raid_disk;
+
+	for (disk =3D first; disk <=3D last; disk++) {
 		p =3D conf->disks + disk;
 		if (p->rdev =3D=3D NULL) {
 			clear_bit(In_sync, &rdev->flags);
@@ -5477,8 +5476,10 @@ static int raid5_add_disk(struct mddev *mddev, struc=
t md_rdev *rdev)
 			if (rdev->saved_raid_disk !=3D disk)
 				conf->fullsync =3D 1;
 			rcu_assign_pointer(p->rdev, rdev);
-			break;
+			goto out;
 		}
+	}
+	for (disk =3D first; disk <=3D last; disk++) {
 		if (test_bit(WantReplacement, &p->rdev->flags) &&
 		    p->replacement =3D=3D NULL) {
 			clear_bit(In_sync, &rdev->flags);
@@ -5490,6 +5491,7 @@ static int raid5_add_disk(struct mddev *mddev, struct=
 md_rdev *rdev)
 			break;
 		}
 	}
+out:
 	print_raid5_conf(conf);
 	return err;
 }


--Sig_/op5J7GCYI/hSHEcst4sTY=_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT86yJDnsnt1WYoG5AQIyxA//eh65266vg/wNkM2MiskLIoTMMb+0r24N
VH0JTPv2j+E7JhVi6i9GvgW+259pTErms2xg2TwNsJomZCNco4KIvFLlXLlGBj/D
32JCewp9cRrzEyafuSNjs0glOQjFS9aO80cmf9EM9PfuwJdnQHsihupjkYq8ygX8
RzGrJHoh5yOoMY50JfRWHxCBmnrbIHKLOTlfrnw3F6fewQQHBkJ6K5M4ZXHAxf3Q
eeWrgVm2B4P99agcc2GQZL30B/L+W4X4TNYHYiHqf3FP20U+v2fZP0jY75D0nELI
fBoPvbspoUmjpT620YEWLWTeTNlmPKU5CzLawb8ZCsikxTQID2CMRS70/h80HdRF
bEFALED1KYuNlZDWYZIx7S34b0VAnH/YNqnSDaBTLLT9d7DeAD01V/8Qj1XFLexi
P03ZiqkT32gBpWnw+5IOd20W/HlSavIwW2uWPGD9kENeHKteeIlMsXw1a8ecyjRX
lhj7hTEAO/tzH+/VqYM4CRUMQZLG5kaQAHXsBQ2SbgjN7++m9bVj2ANG9kQlDVcJ
t9Kp98WH+FDj9VMp3kSHoGHEtRbn8dxxElK1BJ9HNouCxsIauHJKgOS4sbWx2fzr
mNYYW+1K6VnoLL7pzE0zM/BxI3KbyQbDX1B3XZ6CQWit9yhy82SrBYTKCO6yuEry
QZ1nxDh7480=
=k/I2
-----END PGP SIGNATURE-----

--Sig_/op5J7GCYI/hSHEcst4sTY=_--
