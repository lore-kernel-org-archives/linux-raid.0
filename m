From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v3 07/11] md/raid5: split bio for chunk_aligned_read
Date: Fri, 8 May 2015 14:14:35 +1000
Message-ID: <20150508141435.17666f2a@notabene.brown>
References: <1430980461-5235-1-git-send-email-mlin@kernel.org>
	<1430980461-5235-8-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ILm4G.1GLKg41JRwN=0.ZlE"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430980461-5235-8-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ILm4G.1GLKg41JRwN=0.ZlE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  6 May 2015 23:34:17 -0700 Ming Lin <mlin@kernel.org> wrote:

> If a read request fits entirely in a chunk, it will be passed directly to=
 the
> underlying device (providing it hasn't failed of course).  If it doesn't =
fit,
> the slightly less efficient path that uses the stripe_cache is used.
> Requests that get to the stripe cache are always completely split up as
> necessary.
>=20
> So with RAID5, ripping out the merge_bvec_fn doesn't cause it to stop wor=
k,
> but could cause it to take the less efficient path more often.
>=20
> All that is needed to manage this is for 'chunk_aligned_read' do some bio
> splitting, much like the RAID0 code does.
>=20
> Cc: Neil Brown <neilb@suse.de>
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Ming Lin <mlin@kernel.org>
> ---
>  drivers/md/raid5.c | 42 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 37 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7f4a717..b18f548 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4738,7 +4738,7 @@ static void raid5_align_endio(struct bio *bi, int e=
rror)
>  	add_bio_to_retry(raid_bi, conf);
>  }
> =20
> -static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
> +static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bi=
o)
>  {
>  	struct r5conf *conf =3D mddev->private;
>  	int dd_idx;
> @@ -4747,7 +4747,7 @@ static int chunk_aligned_read(struct mddev *mddev, =
struct bio * raid_bio)
>  	sector_t end_sector;
> =20
>  	if (!in_chunk_boundary(mddev, raid_bio)) {
> -		pr_debug("chunk_aligned_read : non aligned\n");
> +		pr_debug("%s: non aligned\n", __func__);
>  		return 0;
>  	}
>  	/*
> @@ -4822,6 +4822,36 @@ static int chunk_aligned_read(struct mddev *mddev,=
 struct bio * raid_bio)
>  	}
>  }
> =20
> +static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *r=
aid_bio)
> +{
> +	struct bio *split;
> +
> +	do {
> +		sector_t sector =3D raid_bio->bi_iter.bi_sector;
> +		unsigned chunk_sects =3D mddev->chunk_sectors;
> +		unsigned sectors;
> +
> +		if (likely(is_power_of_2(chunk_sects)))
> +			sectors =3D chunk_sects - (sector & (chunk_sects-1));
> +		else
> +			sectors =3D chunk_sects - sector_div(sector, chunk_sects);

RAID5 doesn't currently allow non-power-of-2 chunks.  So this test is
pointless, but not really harmful.  Maybe someday we will.

I'm equally happy for it to stay or go.

Acked-by: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown


> +
> +		if (sectors < bio_sectors(raid_bio)) {
> +			split =3D bio_split(raid_bio, sectors, GFP_NOIO, fs_bio_set);
> +			bio_chain(split, raid_bio);
> +		} else
> +			split =3D raid_bio;
> +
> +		if (!raid5_read_one_chunk(mddev, split)) {
> +			if (split !=3D raid_bio)
> +				generic_make_request(raid_bio);
> +			return split;
> +		}
> +	} while (split !=3D raid_bio);
> +
> +	return NULL;
> +}
> +
>  /* __get_priority_stripe - get the next stripe to process
>   *
>   * Full stripe writes are allowed to pass preread active stripes up until
> @@ -5099,9 +5129,11 @@ static void make_request(struct mddev *mddev, stru=
ct bio * bi)
>  	 * data on failed drives.
>  	 */
>  	if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> -	     mddev->reshape_position =3D=3D MaxSector &&
> -	     chunk_aligned_read(mddev,bi))
> -		return;
> +	    mddev->reshape_position =3D=3D MaxSector) {
> +		bi =3D chunk_aligned_read(mddev, bi);
> +		if (!bi)
> +			return;
> +	}
> =20
>  	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
>  		make_discard_request(mddev, bi);


--Sig_/ILm4G.1GLKg41JRwN=0.ZlE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUw4Kznsnt1WYoG5AQLZ9Q/7Bs5VffbatLrkBSF5xUtvr/VhjGl1Shyi
enX9gSc0FN59m18H6DsbAhb4BpOF1k9yLKGNcjEc+RfBKFgBYrn7cL4mqsB051cg
LZ54yj4SPva+1xW8YipxNCTETE2mkx2rqvDcD+pMIJNkdx1wkU9C8EJ/qJ1PpKy6
dkV+Umbi7FWNJCDu48snHMgZ/tSMyN7ENMtlTBJ2BENvkReHeZo3lm3woH5yIUlq
RczanuI+nms44OPfDP8BY9/HNf2Ky2KrGj0xZoa0iyziCjT2aJqx3j7w2Q+oQzg5
82yq8m1wEDgnaYl8E3MXkvHwu8xsGDJEsJ6ALBvmFKwIlMf8Y08UeMSz1hHTUtmS
DZ2DepluNz3YQk+xCEQP9u3FJJjLwYTHjeH+mXS7ZTNdo5WO0CLM6tJH9DaeC24t
wneSNuudcD9x0QmaGrty2dCYQ9vhblbq192k/66kqeIeT+olWECoREnVjNZ2/91j
JY7dkz4juC/Ee38BfPyH01OWM3RKPhi5UTWe8aAelZ69OZsoeGcxSH93BIUk3M2h
AiMhlvKPWrO+xdFh0Zcetillb6f8igxmwK9eO64u/JW3zc3I3W+zt7P9lDRX+tJY
XOPAubGapfGmUO2RKxPUUSE3/XkgJT7p4oqqLlnKYZRrJv8yCIAJc/sDcVa174ju
r58Jc2uocOE=
=Ssz6
-----END PGP SIGNATURE-----

--Sig_/ILm4G.1GLKg41JRwN=0.ZlE--
