From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v3 02/14] md: move two macros into md.h
Date: Fri, 24 Mar 2017 16:57:37 +1100
Message-ID: <87tw6j8be6.fsf@notabene.neil.brown.name>
References: <20170316161235.27110-1-tom.leiming@gmail.com> <20170316161235.27110-3-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170316161235.27110-3-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 17 2017, Ming Lei wrote:

> Both raid1 and raid10 share common resync
> block size and page count, so move them into md.h.

I don't think this is necessary.
These are just "magic" numbers.  They don't have any real
meaning and so don't belong in md.h, or and .h file.

Possibly we should find more meaningful numbers, or make them auto-size
or something.  I'm also happy for them to stay as they are for now.
But I don't think we should pretend that they are meaningful.

Thanks,
NeilBrown


>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/md/md.h     | 5 +++++
>  drivers/md/raid1.c  | 2 --
>  drivers/md/raid10.c | 3 ---
>  3 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b8859cbf84b6..1d63239a1be4 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -715,4 +715,9 @@ static inline void mddev_check_writesame(struct mddev=
 *mddev, struct bio *bio)
>  	    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
>  		mddev->queue->limits.max_write_same_sectors =3D 0;
>  }
> +
> +/* Maximum size of each resync request */
> +#define RESYNC_BLOCK_SIZE (64*1024)
> +#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
> +
>  #endif /* _MD_MD_H */
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4a0b2ad5025e..908e2caeb704 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -94,10 +94,8 @@ static void r1bio_pool_free(void *r1_bio, void *data)
>  	kfree(r1_bio);
>  }
>=20=20
> -#define RESYNC_BLOCK_SIZE (64*1024)
>  #define RESYNC_DEPTH 32
>  #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
> -#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
>  #define RESYNC_WINDOW (RESYNC_BLOCK_SIZE * RESYNC_DEPTH)
>  #define RESYNC_WINDOW_SECTORS (RESYNC_WINDOW >> 9)
>  #define CLUSTER_RESYNC_WINDOW (16 * RESYNC_WINDOW)
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b4a56a488668..2b40420299e3 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -125,9 +125,6 @@ static void r10bio_pool_free(void *r10_bio, void *dat=
a)
>  	kfree(r10_bio);
>  }
>=20=20
> -/* Maximum size of each resync request */
> -#define RESYNC_BLOCK_SIZE (64*1024)
> -#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
>  /* amount of memory to reserve for resync requests */
>  #define RESYNC_WINDOW (1024*1024)
>  /* maximum number of concurrent requests, memory permitting */
> --=20
> 2.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljUtVEACgkQOeye3VZi
gbmnvw/+IuR034Uh0nBzSbnOPErPGgN2t3aT2a1izfe0BffPI2Kbsr+i5kjI+Hpp
HHtGpT3mw6Vkbf0LHz7GqmLvEpvHQRkHOmGo+OYTCN4HJi3TBAkKg4h6PTvA0IMl
1ocqD1ap5FzpM+RNZ0m9Ld6OSQ4k2k3WJwQy8CQ47Fc6w5KM+mkbv84BWu2K0i9A
X4nNsG5c1MHFi/uCOLVr2sYVKbVlhvLUJJyowi/RM3XQr1VrFH/1CcGqg715FTfP
Kxrv3A4wmRTxJWUGWzDfrQMNyJQrvfIH46swhiM5tXUf1qUfNJ3aGK7+hEMFcaXg
sT4/elbAACyFE3seSZbmf74WihiavmkGeECH3TZnQKpZhi7UDG1qkgPA655gciPI
1UGfRbt5HcNtFfpiXdF0Tni0Rk65X1EEYp6K5yFvvXHpkJYkdLINMDlk4KwEM5sS
2FG8bCjsstTJfPFJ9Ywm7c3AdzIJFRT5OFbBtI6p06R+uuZ5IogfHRFasbW4Zde+
FTUeEraq6Y1ZFl+nHB7YGKPmFXWn0GR6nBjhF4ELoJP8Ii7NDyTiWrU9ufnH/Xix
+JlX02dpBj6zu06iXW6mQ568WDkEc0zaFzfLNTG5tJrpSp2tQmZ3MY1rwbH2cH7o
6uD5qNWitWlZ5HTuxRDWNFIa22/v6RkFlcnftWK5pTMlXTnpkFI=
=M8Wb
-----END PGP SIGNATURE-----
--=-=-=--
