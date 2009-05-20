From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH v2 04/11] async_xor: permit callers to pass in a 'dma/page scribble' region
Date: Wed, 20 May 2009 10:08:18 +0200
Message-ID: <20090520080818.GT6403@skl-net.de>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com> <20090519005946.4104.28803.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZNotpC0yWfjHZxBL"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090519005946.4104.28803.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ZNotpC0yWfjHZxBL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2009 at 05:59:46PM -0700, Dan Williams wrote:

> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
> index 6290d05..3caecdd 100644
> --- a/crypto/async_tx/async_xor.c
> +++ b/crypto/async_tx/async_xor.c
> @@ -33,11 +33,10 @@
>  /* do_async_xor - dma map the pages and perform the xor with an engine */
>  static __async_inline struct dma_async_tx_descriptor *
>  do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src=
_list,
> -	     unsigned int offset, int src_cnt, size_t len,
> +	     unsigned int offset, int src_cnt, size_t len, dma_addr_t *dma_src,
>  	     struct async_submit_ctl *submit)
>  {
>  	struct dma_device *dma =3D chan->device;
> -	dma_addr_t *dma_src =3D (dma_addr_t *) src_list;
>  	struct dma_async_tx_descriptor *tx =3D NULL;
>  	int src_off =3D 0;
>  	int i;
> @@ -125,9 +124,14 @@ do_sync_xor(struct page *dest, struct page **src_lis=
t, unsigned int offset,
>  	int xor_src_cnt;
>  	int src_off =3D 0;
>  	void *dest_buf;
> -	void **srcs =3D (void **) src_list;
> +	void **srcs;
> =20
> -	/* reuse the 'src_list' array to convert to buffer pointers */
> +	if (submit->scribble)
> +		srcs =3D (void **) submit->scribble;

Unnecessary cast as submit->scribble is void *.

> @@ -171,17 +175,26 @@ async_xor(struct page *dest, struct page **src_list=
, unsigned int offset,
>  	struct dma_chan *chan =3D async_tx_find_channel(submit, DMA_XOR,
>  						      &dest, 1, src_list,
>  						      src_cnt, len);
> +	dma_addr_t *dma_src =3D NULL;
> +
>  	BUG_ON(src_cnt <=3D 1);
> =20
> -	if (chan) {
> +	if (submit->scribble)
> +		dma_src =3D submit->scribble;
> +	else if (sizeof(dma_addr_t) <=3D sizeof(struct page *))
> +		dma_src =3D (dma_addr_t *) src_list;
> +
> +	if (dma_src && chan) {
>  		/* run the xor asynchronously */
>  		pr_debug("%s (async): len: %zu\n", __func__, len);
> =20
>  		return do_async_xor(chan, dest, src_list, offset, src_cnt, len,
> -				    submit);
> +				    dma_src, submit);
>  	} else {

Don't we need to fall back to sync xor if src_cnt exceeds
what the device can handle, i.e. if it is larger than
chan->device->max_xor? async_xor_val() further down has a check for
this condition.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe


--ZNotpC0yWfjHZxBL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKE7pyWto1QDEAkw8RAglsAJ90fHIIYofQkWYyc8HuQup3zDF3EQCgpXIC
6ML5mdegib8zJmjMVD1xTdg=
=7KND
-----END PGP SIGNATURE-----

--ZNotpC0yWfjHZxBL--
