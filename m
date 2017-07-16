From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 3/3] md: raid1-10: move raid1/raid10 common code into raid1-10.c
Date: Mon, 17 Jul 2017 08:40:18 +1000
Message-ID: <87mv84ypil.fsf@notabene.neil.brown.name>
References: <20170714081444.32645-1-ming.lei@redhat.com> <20170714081444.32645-4-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170714081444.32645-4-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 14 2017, Ming Lei wrote:

> No function change, just move 'struct resync_pages' and related
> helpers into raid1-10.c
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Thanks for doing this!
I'm quite happy with this approach - and with all patches in this
series.

Thanks,
NeilBrown


> ---
>  drivers/md/md.h       | 53 -------------------------------------------
>  drivers/md/raid1-10.c | 62 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  drivers/md/raid1.c    |  9 --------
>  drivers/md/raid10.c   |  9 --------
>  4 files changed, 62 insertions(+), 71 deletions(-)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 2c780aa8d07f..004a21c214e8 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -729,57 +729,4 @@ static inline void mddev_check_write_zeroes(struct m=
ddev *mddev, struct bio *bio
>  	    !bdev_get_queue(bio->bi_bdev)->limits.max_write_zeroes_sectors)
>  		mddev->queue->limits.max_write_zeroes_sectors =3D 0;
>  }
> -
> -/* Maximum size of each resync request */
> -#define RESYNC_BLOCK_SIZE (64*1024)
> -#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
> -
> -/* for managing resync I/O pages */
> -struct resync_pages {
> -	void		*raid_bio;
> -	struct page	*pages[RESYNC_PAGES];
> -};
> -
> -static inline int resync_alloc_pages(struct resync_pages *rp,
> -				     gfp_t gfp_flags)
> -{
> -	int i;
> -
> -	for (i =3D 0; i < RESYNC_PAGES; i++) {
> -		rp->pages[i] =3D alloc_page(gfp_flags);
> -		if (!rp->pages[i])
> -			goto out_free;
> -	}
> -
> -	return 0;
> -
> -out_free:
> -	while (--i >=3D 0)
> -		put_page(rp->pages[i]);
> -	return -ENOMEM;
> -}
> -
> -static inline void resync_free_pages(struct resync_pages *rp)
> -{
> -	int i;
> -
> -	for (i =3D 0; i < RESYNC_PAGES; i++)
> -		put_page(rp->pages[i]);
> -}
> -
> -static inline void resync_get_all_pages(struct resync_pages *rp)
> -{
> -	int i;
> -
> -	for (i =3D 0; i < RESYNC_PAGES; i++)
> -		get_page(rp->pages[i]);
> -}
> -
> -static inline struct page *resync_fetch_page(struct resync_pages *rp,
> -					     unsigned idx)
> -{
> -	if (WARN_ON_ONCE(idx >=3D RESYNC_PAGES))
> -		return NULL;
> -	return rp->pages[idx];
> -}
>  #endif /* _MD_MD_H */
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 3adb5b9dc4b4..9f2670b45f31 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -1,3 +1,65 @@
> +/* Maximum size of each resync request */
> +#define RESYNC_BLOCK_SIZE (64*1024)
> +#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
> +
> +/* for managing resync I/O pages */
> +struct resync_pages {
> +	void		*raid_bio;
> +	struct page	*pages[RESYNC_PAGES];
> +};
> +
> +static inline int resync_alloc_pages(struct resync_pages *rp,
> +				     gfp_t gfp_flags)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < RESYNC_PAGES; i++) {
> +		rp->pages[i] =3D alloc_page(gfp_flags);
> +		if (!rp->pages[i])
> +			goto out_free;
> +	}
> +
> +	return 0;
> +
> +out_free:
> +	while (--i >=3D 0)
> +		put_page(rp->pages[i]);
> +	return -ENOMEM;
> +}
> +
> +static inline void resync_free_pages(struct resync_pages *rp)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < RESYNC_PAGES; i++)
> +		put_page(rp->pages[i]);
> +}
> +
> +static inline void resync_get_all_pages(struct resync_pages *rp)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < RESYNC_PAGES; i++)
> +		get_page(rp->pages[i]);
> +}
> +
> +static inline struct page *resync_fetch_page(struct resync_pages *rp,
> +					     unsigned idx)
> +{
> +	if (WARN_ON_ONCE(idx >=3D RESYNC_PAGES))
> +		return NULL;
> +	return rp->pages[idx];
> +}
> +
> +/*
> + * 'strct resync_pages' stores actual pages used for doing the resync
> + *  IO, and it is per-bio, so make .bi_private points to it.
> + */
> +static inline struct resync_pages *get_resync_pages(struct bio *bio)
> +{
> +	return bio->bi_private;
> +}
> +
>  /* generally called after bio_reset() for reseting bvec */
>  static void md_bio_reset_resync_pages(struct bio *bio, struct resync_pag=
es *rp,
>  			       int size)
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index fe86ab18961b..8387eb1540cd 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -84,15 +84,6 @@ static void lower_barrier(struct r1conf *conf, sector_=
t sector_nr);
>  #include "raid1-10.c"
>=20=20
>  /*
> - * 'strct resync_pages' stores actual pages used for doing the resync
> - *  IO, and it is per-bio, so make .bi_private points to it.
> - */
> -static inline struct resync_pages *get_resync_pages(struct bio *bio)
> -{
> -	return bio->bi_private;
> -}
> -
> -/*
>   * for resync bio, r1bio pointer can be retrieved from the per-bio
>   * 'struct resync_pages'.
>   */
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 9952721e1cde..e2617d0f37dc 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -113,15 +113,6 @@ static void end_reshape(struct r10conf *conf);
>  #include "raid1-10.c"
>=20=20
>  /*
> - * 'strct resync_pages' stores actual pages used for doing the resync
> - *  IO, and it is per-bio, so make .bi_private points to it.
> - */
> -static inline struct resync_pages *get_resync_pages(struct bio *bio)
> -{
> -	return bio->bi_private;
> -}
> -
> -/*
>   * for resync bio, r10bio pointer can be retrieved from the per-bio
>   * 'struct resync_pages'.
>   */
> --=20
> 2.9.4

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllr61MACgkQOeye3VZi
gbnvag//YJBLLDUBYQqIFu2H4+ABypSZiAskJB0z5Qd9HuZgoVeyrRGtkJg2jfKs
vzL4ArBQqBWQDtZzHzNypGDKD6IECErFW4gJZg1K65qO363Hlwq1OYTjpJ7+ct5A
CItLD0tSRjZPGoCfmRs3DdrQTQUmC1X+GBzRHQFpO7VeASxEYtf9kpq7m0chrMnY
ac5mk8vUgVk9ys+I0GT7pp3ereHGvlF0xCUe5+UJ/twL/jB50sB/KovRA8I0aLlj
TIhgqDrlpvRJCoaaokqtH3bwU2volMFfYebkI0gGh9LZpVuO21ijC/O5vONjEeR/
M8VeelHp5aN9K0IQM1SQtnatE5ECM6LlYHK6MCwFODwifJu1C4kxe24yRx04QVEi
u+lfNjlMNScf8WOR9IX+kvWCJ+Es7K28RE+vteSeK8Kun+3C1MnT6kb6vcNLCbHU
91TZevVmtEkd0MlaEh3Tyr+x3bMn6bNQkZOojFik5Gk/CfXHq5PvwMsKBbk6pyts
DJ+taT4ZNi2yUqFidAxCDDFTCm4IXTM14WDDc0vN0PrG0AFqZBc5LRpFxzOr7FHO
GJLJ1wBHJAl97gtm/Rec4mEneAcAC9hupmoUB3Bxu+oAwEfxWfYtCVebLFkCk3Z3
l63vPHt1iY/5ipNLMwse9gOvSfDuCMD46RnhQnz0MAtQTZjebZs=
=CHy7
-----END PGP SIGNATURE-----
--=-=-=--
