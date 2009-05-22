From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH v2 08/11] async_tx: add support for asynchronous GF multiplication
Date: Fri, 22 May 2009 10:29:01 +0200
Message-ID: <20090522082901.GM11504@skl-net.de>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com> <20090519010006.4104.70181.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iUV/lbBrmPtUT9dM"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090519010006.4104.70181.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--iUV/lbBrmPtUT9dM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2009 at 06:00:07PM -0700, Dan Williams wrote:
> +/* the struct page *blocks[] parameter passed to async_gen_syndrome()
> + * and async_syndrome_val() contains the 'P' destination address at
> + * blocks[disks-2] and the 'Q' destination address at blocks[disks-1]
> + *
> + * note: these are macros as they are used a lvalues
> + */
> +#define P(b, d) (b[d-2])
> +#define Q(b, d) (b[d-1])

s/a lvalues/as lvalues

> +	/* convert source addresses being careful to collapse 'empty'
> +	 * sources and update the coefficients accordingly
> +	 */
> +	for (i =3D 0, idx =3D 0; i < src_cnt; i++) {
> +		if (is_raid6_zero_block(blocks[i]))
> +			continue;
> +		dma_src[idx] =3D dma_map_page(dma->dev, blocks[i], offset, len,
> +					    DMA_TO_DEVICE);
> +		coefs[idx] =3D scfs[i];
> +		idx++;
> +	}
> +	src_cnt =3D idx;

If P is disabled, we could further collapse this loop by also skipping
sources where the coefficient is zero. Not sure if this would be a win
though.

> +
> +	while (src_cnt > 0) {
> +		submit->flags =3D flags_orig;
> +		pq_src_cnt =3D min(src_cnt, dma_maxpq(dma, dma_flags));
> +		/* if we are submitting additional pqs, leave the chain open,
> +		 * clear the callback parameters, and leave the destination
> +		 * buffers mapped
> +		 */
> +		if (src_cnt > pq_src_cnt) {
> +			submit->flags &=3D ~ASYNC_TX_ACK;
> +			dma_flags |=3D DMA_COMPL_SKIP_DEST_UNMAP;
> +			submit->cb_fn =3D NULL;
> +			submit->cb_param =3D NULL;
> +		} else {
> +			dma_flags &=3D ~DMA_COMPL_SKIP_DEST_UNMAP;
> +			submit->cb_fn =3D cb_fn_orig;
> +			submit->cb_param =3D cb_param_orig;
> +		}
> +		if (submit->cb_fn)
> +			dma_flags |=3D DMA_PREP_INTERRUPT;

The last if() can go to the else branch.

> +/**
> + * do_sync_gen_syndrome - synchronously calculate a raid6 syndrome
> + */
> +static void
> +do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disk=
s,
> +		     size_t len, struct async_submit_ctl *submit)
> +{
> +	void **srcs;
> +	int i;
> +
> +	if (submit->scribble)
> +		srcs =3D (void **) submit->scribble;

Unnecessary cast.

> +	else
> +		srcs =3D (void **) blocks;
> +
> +	for (i =3D 0; i < disks; i++) {
> +		if (is_raid6_zero_block(blocks[i])) {
> +			BUG_ON(i > disks - 3); /* P or Q can't be zero */
> +			srcs[i] =3D (void *) blocks[i];

Another Unnecessary cast.

Otherwise, this patch looks also very nice.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--iUV/lbBrmPtUT9dM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKFmJNWto1QDEAkw8RAthoAJ9l1Epo92w8I4GCpUHWLxA+5dD/VQCghZ8A
cOu+9OISH7AdPzl6sx93o9k=
=Tcy7
-----END PGP SIGNATURE-----

--iUV/lbBrmPtUT9dM--
