From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/4] raid1: change the code layout of
 raid1_mergeable_bvec() to make it look a bit nicer
Date: Mon, 4 Jun 2012 13:42:56 +1000
Message-ID: <20120604134256.7c26f15b@notabene.brown>
References: <1338459528-24490-1-git-send-email-yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w0QIs9n5bFnTBE9/zyDUnYx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1338459528-24490-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/w0QIs9n5bFnTBE9/zyDUnYx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 May 2012 18:18:45 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> This don't fix anything but just make function raid1_mergeable_bvec
> look a bit nicer.
>=20
> Minro note: this make 2 lines exceed 80 a bit(81).

Thanks, but no thanks.

"nicer" is very subjective and others might not agree.

If you are proposing functional changes or fixing bugs then feel free to
reformat or tidy up surrounding code in preparatory patches.
However I'm not really interested in patches that do nothing except make the
code look nicer to you.

Thanks,
NeilBrown


>=20
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  drivers/md/raid1.c |   32 +++++++++++++++-----------------
>  1 files changed, 15 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 835de71..5829f46 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -623,27 +623,25 @@ static int raid1_mergeable_bvec(struct request_queu=
e *q,
>  	struct r1conf *conf =3D mddev->private;
>  	sector_t sector =3D bvm->bi_sector + get_start_sect(bvm->bi_bdev);
>  	int max =3D biovec->bv_len;
> +	int disk;
> =20
> -	if (mddev->merge_check_needed) {
> -		int disk;
> -		rcu_read_lock();
> -		for (disk =3D 0; disk < conf->raid_disks * 2; disk++) {
> -			struct md_rdev *rdev =3D rcu_dereference(
> -				conf->mirrors[disk].rdev);
> -			if (rdev && !test_bit(Faulty, &rdev->flags)) {
> -				struct request_queue *q =3D
> -					bdev_get_queue(rdev->bdev);
> -				if (q->merge_bvec_fn) {
> -					bvm->bi_sector =3D sector +
> -						rdev->data_offset;
> -					bvm->bi_bdev =3D rdev->bdev;
> -					max =3D min(max, q->merge_bvec_fn(
> -							  q, bvm, biovec));
> -				}
> +	if (!mddev->merge_check_needed)
> +		return max;
> +
> +	rcu_read_lock();
> +	for (disk =3D 0; disk < conf->raid_disks * 2; disk++) {
> +		struct md_rdev *rdev =3D rcu_dereference(conf->mirrors[disk].rdev);
> +		if (rdev && !test_bit(Faulty, &rdev->flags)) {
> +			struct request_queue *q =3D bdev_get_queue(rdev->bdev);
> +			if (q->merge_bvec_fn) {
> +				bvm->bi_sector =3D sector + rdev->data_offset;
> +				bvm->bi_bdev =3D rdev->bdev;
> +				max =3D min(max, q->merge_bvec_fn(q, bvm, biovec));
>  			}
>  		}
> -		rcu_read_unlock();
>  	}
> +	rcu_read_unlock();
> +
>  	return max;
> =20
>  }


--Sig_/w0QIs9n5bFnTBE9/zyDUnYx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8wuwDnsnt1WYoG5AQLm6g/+N2jDrB8Wc7Ovu3EtF5kJmw1UY+2gm22l
nbzkSn+PyjcgxyAdRToN0iMgQHeHIEHxOWbAYpKkqogV4o/pDYD8aB1+UmHFm+h6
lFC2VLWAC93Oy66JAyizyd5NRUQwHCPG45Zj5tVDYzuET89/G5FFIn8cdImy5zYi
d7rkWqRIy6i8M2wDSbetel0a4skBoAO3pt2M/zaeaRMau6pjIE7lHKaMV/REGReB
sOWcoy56k+EDm+C3TI1nqtnw7v+C09zvdfMzraKwv/+1fWqg6GsRzed5GRA4JTQw
xPEEQqlacc1cfMJVjYgNiUyC+z+AIzSVjxf5oRWo75JzQdXlHiKMIlrmFQSSgTva
JxMg1S9pldKKcSByTDYJspQd3hKhS9Lxxw3XAW3oq4M7Labfnnr3JTuOmvTetYSU
CMU/31szcHPHPHLSDDHimiXJO/T8xgf90XywmupY94Y2ZipizlzfHqpuvsjqju2u
iVBYE4xAcMtR9M7Ht7uET9pWj0KYlYErWD/h/moqJWSJ+KT1XMX5SqDcMjZNGG7m
Ueja7FCEh02vYV/8/M0JTrW06a932rQf2iHlo4og/b/2ewHODAXZRAP6RkLdq89S
egAqvmi/j8z8Ik+KlTzBxIUkaHsUf+RCMHumkkp9/7q5G6Zzs1pigaHUX6lgPJUi
ZqA2/iFuoNE=
=73Bo
-----END PGP SIGNATURE-----

--Sig_/w0QIs9n5bFnTBE9/zyDUnYx--
