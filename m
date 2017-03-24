From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v3 03/14] md: prepare for managing resync I/O pages in clean way
Date: Fri, 24 Mar 2017 17:00:00 +1100
Message-ID: <87r31n8ba7.fsf@notabene.neil.brown.name>
References: <20170316161235.27110-1-tom.leiming@gmail.com> <20170316161235.27110-4-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170316161235.27110-4-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 17 2017, Ming Lei wrote:

> Now resync I/O use bio's bec table to manage pages,
> this way is very hacky, and may not work any more
> once multipage bvec is introduced.
>
> So introduce helpers and new data structure for
> managing resync I/O pages more cleanly.
>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/md/md.h | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)

I don't think this should go in md.h

Maybe create a "raid1-10.h" or similar if you really want to.

NeilBrown

>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1d63239a1be4..20c48032493b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -720,4 +720,54 @@ static inline void mddev_check_writesame(struct mdde=
v *mddev, struct bio *bio)
>  #define RESYNC_BLOCK_SIZE (64*1024)
>  #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
>=20=20
> +/* for managing resync I/O pages */
> +struct resync_pages {
> +	unsigned	idx;	/* for get/put page from the pool */
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
> + out_free:
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
>  #endif /* _MD_MD_H */
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

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljUteAACgkQOeye3VZi
gble+xAAihiLo5WaKz0cEyOtblxUr/beKmzAsAEo8TGXSCBbRpI8wFaL1MYLiGpB
YbR2DErnasD8cgzWAXdT+2AVhRgeUhmWyNTPpko83O3uChcKWv7Q248FJyQCS5nP
v9Oe6rII0chWdLxqSVaOG+l+N0TOzEtFY9TSbZPVaG0JlvG+49nwX7NNIY3eJv9o
z+JkMqFC3dlRMpatpKvHLXNh+YbHEBd0dBf2NmX4hFEaXpXv/0cTGkeQJv2sRT+9
DH7ubSfyVWssJEhR1ZILGR82S/TIeA0jxRyrP5J0TNlaNBFSojKHcvyDXALj46hH
gASKtbZzIrMUw4LHFxC8bpBmROyFLCGQX3aqMJ+9AezrR/h5dnawPF/z0V9XYqDE
Rq6lDkzPSMnFM9NaDIMUeRUbX4svK2g7xw0tHy1T7oCNScl6EA/RFkbrBzfRQbaD
9vau/QIQ6Dtw9urEqvc4hqfeVTrWGU/tLVBjm2gc8m1LCNP9tXooOeRe1jdE2Ghm
UQktz7Usz7XtCrZGhBi05aZdLOFeiKtt2CeoEuitxeeA7BJGJxpetZ7+POFNC6IR
eFxBj+0SYSdmosx1ahF7T6Gn7fK2RDFqIM97hZGB5G4fKYkx6Ej8QTdIlTBXzOpR
lXtBxGO6oxHksPccC/xH4g8WIlf/klUGeutHZAzBFPcFKq9u6fg=
=uM4u
-----END PGP SIGNATURE-----
--=-=-=--
