From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] md: remove 'idx' from 'struct resync_pages'
Date: Thu, 13 Jul 2017 09:58:41 +1000
Message-ID: <8737a1437y.fsf@notabene.neil.brown.name>
References: <20170712082845.436-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170712082845.436-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 12 2017, Ming Lei wrote:

> bio_add_page() won't fail for resync bio, and the page index for each
> bio is same, so remove it.
>
> More importantly the 'idx' of 'struct resync_pages' is initialized in
> mempool allocator function, this way is wrong since mempool is only
> responsible for allocation, we can't use that for initialization.
>
> Suggested-by: NeilBrown <neilb@suse.com>
> Reported-by: NeilBrown <neilb@suse.com>
> Fixes: f0250618361d(md: raid10: don't use bio's vec table to manage resyn=
c pages)
> Fixes: 98d30c5812c3(md: raid1: don't use bio's vec table to manage resync=
 pages)
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/md.h     | 1 -
>  drivers/md/raid1.c  | 6 +++---
>  drivers/md/raid10.c | 6 +++---
>  3 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 991f0fe2dcc6..2c780aa8d07f 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -736,7 +736,6 @@ static inline void mddev_check_write_zeroes(struct md=
dev *mddev, struct bio *bio
>=20=20
>  /* for managing resync I/O pages */
>  struct resync_pages {
> -	unsigned	idx;	/* for get/put page from the pool */
>  	void		*raid_bio;
>  	struct page	*pages[RESYNC_PAGES];
>  };
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 3febfc8391fb..7901ddc3362f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -170,7 +170,6 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void =
*data)
>  			resync_get_all_pages(rp);
>  		}
>=20=20
> -		rp->idx =3D 0;
>  		rp->raid_bio =3D r1_bio;
>  		bio->bi_private =3D rp;
>  	}
> @@ -2619,6 +2618,7 @@ static sector_t raid1_sync_request(struct mddev *md=
dev, sector_t sector_nr,
>  	int good_sectors =3D RESYNC_SECTORS;
>  	int min_bad =3D 0; /* number of sectors that are bad in all devices */
>  	int idx =3D sector_to_idx(sector_nr);
> +	int page_idx =3D 0;
>=20=20
>  	if (!conf->r1buf_pool)
>  		if (init_resync(conf))
> @@ -2846,7 +2846,7 @@ static sector_t raid1_sync_request(struct mddev *md=
dev, sector_t sector_nr,
>  			bio =3D r1_bio->bios[i];
>  			rp =3D get_resync_pages(bio);
>  			if (bio->bi_end_io) {
> -				page =3D resync_fetch_page(rp, rp->idx++);
> +				page =3D resync_fetch_page(rp, page_idx);
>=20=20
>  				/*
>  				 * won't fail because the vec table is big
> @@ -2858,7 +2858,7 @@ static sector_t raid1_sync_request(struct mddev *md=
dev, sector_t sector_nr,
>  		nr_sectors +=3D len>>9;
>  		sector_nr +=3D len>>9;
>  		sync_blocks -=3D (len>>9);
> -	} while (get_resync_pages(r1_bio->bios[disk]->bi_private)->idx < RESYNC=
_PAGES);
> +	} while (page_idx++ < RESYNC_PAGES);

I think you want ++page_idx < RESYNC_PAGES, otherwise there will be
one pass through the loop where page_idx =3D=3D RESYNC_PAGES

>=20=20
>  	r1_bio->sectors =3D nr_sectors;
>=20=20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 5026e7ad51d3..e594ca610f27 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -221,7 +221,6 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void=
 *data)
>  			resync_get_all_pages(rp);
>  		}
>=20=20
> -		rp->idx =3D 0;
>  		rp->raid_bio =3D r10_bio;
>  		bio->bi_private =3D rp;
>  		if (rbio) {
> @@ -2853,6 +2852,7 @@ static sector_t raid10_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>  	sector_t sectors_skipped =3D 0;
>  	int chunks_skipped =3D 0;
>  	sector_t chunk_mask =3D conf->geo.chunk_mask;
> +	int page_idx =3D 0;
>=20=20
>  	if (!conf->r10buf_pool)
>  		if (init_resync(conf))
> @@ -3355,7 +3355,7 @@ static sector_t raid10_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>  			break;
>  		for (bio=3D biolist ; bio ; bio=3Dbio->bi_next) {
>  			struct resync_pages *rp =3D get_resync_pages(bio);
> -			page =3D resync_fetch_page(rp, rp->idx++);
> +			page =3D resync_fetch_page(rp, page_idx);
>  			/*
>  			 * won't fail because the vec table is big enough
>  			 * to hold all these pages
> @@ -3364,7 +3364,7 @@ static sector_t raid10_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>  		}
>  		nr_sectors +=3D len>>9;
>  		sector_nr +=3D len>>9;
> -	} while (get_resync_pages(biolist)->idx < RESYNC_PAGES);
> +	} while (page_idx++ < RESYNC_PAGES);

Same problem here.

Otherwise, the patch looks good.

NeilBrown

>  	r10_bio->sectors =3D nr_sectors;
>=20=20
>  	while (biolist) {
> --=20
> 2.9.4

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllmt7MACgkQOeye3VZi
gbnwORAAidoa3WyN+XF+ije2Og8hnP77R3wldMgzRKFu3HZlvLd2Eo44K3PwmPhe
RXi8smc+ztKWuPSivfn4BOiXpq7rbT0iTkOdbeVNN7qlxAvbRpcQogev6ssD/lCg
Jxe/3JB0kAimhoxNbKgOZVQ/s63ww58P9pcjrHPIxLGkWUubwwyKWGLGuzergHWf
DOWJbQVpM+7l/+VrtzjK6ES8709Yy82exsNXFzPSDYsDBGbokum5bGPKVPyP6ml9
xv3xF59PlD4+lDX0l7c4p5B1pBIKbaa0u4T3FVY19G80CYZlwp+SLP8RfJ/XdsF4
QrISbXPp2FWZSWR/TO2OmuLRYVSkhtvpp8mRj3sEHoor4NVx2z0OPnAkbyFYWUHK
8vkRel7WxgwFaMAlMuTfQyZzQbRfEFj02ZuJGz7F6rh1tuF87qeh4r00tj6vNx4M
x2Jcjh++GuA8P4oT95wpUdBLiiyTBT1Ynr1Rz0LmFsl5W8WDrKp325QIV+IugPEE
vWVaU1nL1N0MmTiCc3qoSe6TfXfKL3O3Fa8bKnkxY/316Ha64IFDemjT72ePN1iy
1HU/Mm2nR1NoRSsr2PNPMqYXqxsDTtr46t6QI5urDH39/I4gfzwVj4alI0vM4BkL
iG2p/q9N/jSpBfxSeGBiSHx5I2tTF9prosWc8cXrMxEFdCKh2rY=
=Xx9+
-----END PGP SIGNATURE-----
--=-=-=--
