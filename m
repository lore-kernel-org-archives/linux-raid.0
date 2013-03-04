From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/4] md: Don't do normal-write on unresync area of
 replacement-disk.
Date: Mon, 4 Mar 2013 13:04:35 +1100
Message-ID: <20130304130435.4113d2a4@notabene.brown>
References: <201302281550356268273@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pIqKab8OR5orSL1IrDdAniX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201302281550356268273@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/pIqKab8OR5orSL1IrDdAniX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Feb 2013 15:50:37 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Replacement is a fullsync which don't depent on bitmap.So regardless of
> the presence and absence of bitmap, it do full resync.
> If offset of normal io is larger than offset of resync,it will write
> again when resync arrived this offset.

This might be OK for RAID1 and RAID10 as recover is paused when writes
happen, but that is not the case for RAID5, so it isn't safe to test against
curr_resync - it gets updated a bit too later.

Also you messed up the formatting in raid10.c

I'm not convinced this optimisation is really worth it.

NeilBrown


>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c  |    4 +++-
>  drivers/md/raid10.c |    4 +++-
>  drivers/md/raid5.c  |    3 ++-
>  3 files changed, 8 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d5bddfc..142a5fa 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1173,7 +1173,9 @@ read_again:
>  				set_bit(R1BIO_Degraded, &r1_bio->state);
>  			continue;
>  		}
> -
> +		if (test_bit(Replacement, &rdev->flags) &&
> +			conf->mddev->curr_resync < r1_bio->sector)
> +			continue;
>  		atomic_inc(&rdev->nr_pending);
>  		if (test_bit(WriteErrorSeen, &rdev->flags)) {
>  			sector_t first_bad;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 64d4824..bb11cfb 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1337,7 +1337,9 @@ retry_write:
>  			     || test_bit(Unmerged, &rdev->flags)))
>  			rdev =3D NULL;
>  		if (rrdev && (test_bit(Faulty, &rrdev->flags)
> -			      || test_bit(Unmerged, &rrdev->flags)))
> +			|| test_bit(Unmerged, &rrdev->flags) ||=20
> +			(test_bit(Replacement, &rrdev->flags) &&
> +			conf->mddev->curr_resync < r10_bio->sector)))
>  			rrdev =3D NULL;
> =20
>  		r10_bio->devs[i].bio =3D NULL;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index bd49623..e0a2a39 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -602,7 +602,8 @@ static void ops_run_io(struct stripe_head *sh, struct=
 stripe_head_state *s)
>  			rdev =3D NULL;
>  		if (rdev)
>  			atomic_inc(&rdev->nr_pending);
> -		if (rrdev && test_bit(Faulty, &rrdev->flags))
> +		if (rrdev && (test_bit(Faulty, &rrdev->flags) ||
> +			conf->mddev->curr_resync < sh->sector))
>  			rrdev =3D NULL;
>  		if (rrdev)
>  			atomic_inc(&rrdev->nr_pending);


--Sig_/pIqKab8OR5orSL1IrDdAniX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTQBMznsnt1WYoG5AQL0RA//WIMKIGvrLk3iQw98bWAefrVj0PyCP8w2
kvOEXUPe+ex65YICKnxGPCuvkKmU2F1hQiqXaPa3eBKQAzuMq+lK9m6h4NrOK48s
9G9PoCBtegG8xiJo0Q2HpAK8tSHEGGBFRqE9BhnXMAy9j5R+A6Q8yqhrCxvaEs64
TaFC95ndlgw09FTHOPQJqvkfhUVA2K81InHj0h67dssCIWISwZ2sT37wqbfrIQEG
ZYMPO3VIZVYP3CzvR3Ha3jBRyVkY4P9iQ7ezfpb7v26di9itcbbSikSVnx9lp1fP
y8HJEJ1jIXx6dBDpr6vJ30Vn/xghyuZywOlc24BvAtskQ97ut3xMEua1D9Er3NYX
C+CZNd9pC2VWsBnqGn60xBAhs1dmTjnRsHX83Ggmya6AJuH/GleK5vBvVwsGFlyJ
0UDw4avN1wiXvGwyHjznftdnmZO3I5icnxDvJL1wbE5qzZM/4ODLSe3Z2Ot8i84+
YPKnh6FBqyXmti3oH1zgklai530+OsuYvnCMCI/LckYdX46v/GZBQSSnMDy9rInH
r3LZVgtuk1M1aGuDSu6blbHBhvAIow7OGF48aCRruhiUfKs2HwP3ZpUoms/qX+zI
RIYDq4RHxw4tBh90bTcQXSc33CkFS/90Z3lPoNKvCNKy99zzDenHacrB0G1HGwja
OpATOtaGxno=
=RIux
-----END PGP SIGNATURE-----

--Sig_/pIqKab8OR5orSL1IrDdAniX--
