From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF multiplication
Date: Thu, 19 Mar 2009 21:09:59 +0100
Message-ID: <20090319200959.GB10491@skl-net.de>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com> <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:20, Dan Williams wrote:
> +static __async_inline struct dma_async_tx_descriptor *
> +do_async_pq(struct dma_chan *chan, struct page **blocks, unsigned char *=
scfs,
> +	    unsigned int offset, int src_cnt, size_t len,
> +	    enum async_tx_flags flags,
> +	    struct dma_async_tx_descriptor *depend_tx,
> +	    dma_async_tx_callback cb_fn, void *cb_param)
> +{

Wow, this function takes 10 arguments..

> +	struct dma_device *dma =3D chan->device;
> +	dma_addr_t dma_dest[2], dma_src[src_cnt];
> +	struct dma_async_tx_descriptor *tx =3D NULL;
> +	dma_async_tx_callback _cb_fn;
> +	void *_cb_param;
> +	unsigned char *scf =3D NULL;
> +	int i, src_off =3D 0;
> +	unsigned short pq_src_cnt;
> +	enum async_tx_flags async_flags;
> +	enum dma_ctrl_flags dma_flags =3D 0;
> +	int idx;
> +	u8 coefs[src_cnt];
> +
> +	/* DMAs use destinations as sources, so use BIDIRECTIONAL mapping */
> +	if (blocks[src_cnt])
> +		dma_dest[0] =3D dma_map_page(dma->dev, blocks[src_cnt],
> +					   offset, len, DMA_BIDIRECTIONAL);
> +	else
> +		dma_flags |=3D DMA_PREP_PQ_DISABLE_P;
> +	if (blocks[src_cnt+1])
> +		dma_dest[1] =3D dma_map_page(dma->dev, blocks[src_cnt+1],
> +					   offset, len, DMA_BIDIRECTIONAL);
> +	else
> +		dma_flags |=3D DMA_PREP_PQ_DISABLE_Q;
> +
> +	/* convert source addresses being careful to collapse 'zero'
> +	 * sources and update the coefficients accordingly
> +	 */
> +	for (i =3D 0, idx =3D 0; i < src_cnt; i++) {
> +		if (is_raid6_zero_block(blocks[i]))
> +			continue;
> +		dma_src[idx] =3D dma_map_page(dma->dev, blocks[i],
> +					    offset, len, DMA_TO_DEVICE);
> +		coefs[idx] =3D scfs[i];

coefs[] seems not to be used anywhere. BTW: coefs is an array of u8
while unsigned char is used elswhere for the coefficients troughout
the file.  Any chance to unify this?

> +	while (src_cnt > 0) {
> +		async_flags =3D flags;
> +		pq_src_cnt =3D min(src_cnt, dma_maxpq(dma, flags));
> +		/* if we are submitting additional pqs, leave the chain open,
> +		 * clear the callback parameters, and leave the destination
> +		 * buffers mapped
> +		 */
> +		if (src_cnt > pq_src_cnt) {
> +			async_flags &=3D ~ASYNC_TX_ACK;
> +			dma_flags |=3D DMA_COMPL_SKIP_DEST_UNMAP;
> +			_cb_fn =3D NULL;
> +			_cb_param =3D NULL;
> +		} else {
> +			_cb_fn =3D cb_fn;
> +			_cb_param =3D cb_param;
> +		}
> +		if (_cb_fn)
> +			dma_flags |=3D DMA_PREP_INTERRUPT;
> +		if (scfs)
> +			scf =3D &scfs[src_off];

If scfs is NULL, we have a NULL pointer dereference earlier.

> +
> +		/* Since we have clobbered the src_list we are committed
> +		 * to doing this asynchronously.  Drivers force forward
> +		 * progress in case they can not provide a descriptor
> +		 */
> +		tx =3D dma->device_prep_dma_pq(chan, dma_dest,
> +					     &dma_src[src_off], pq_src_cnt,
> +					     scf, len, dma_flags);
> +		if (unlikely(!tx))
> +			async_tx_quiesce(&depend_tx);
> +
> +		/* spin wait for the preceeding transactions to complete */
> +		while (unlikely(!tx)) {
> +			dma_async_issue_pending(chan);
> +			tx =3D dma->device_prep_dma_pq(chan, dma_dest,
> +					&dma_src[src_off], pq_src_cnt,
> +					scf, len, dma_flags);
> +		}

This can be simplified to

	for (;;) {
		tx =3D dma->device_prep_dma_pq(...);
		if (likely(tx))
			break;
		async_tx_quiesce(&depend_tx);
		dma_async_issue_pending(chan);
	}

which avoids duplicating the device_prep_dma_pq() call. The additional
calls to async_tx_quiesce() will be a no-op and we're spinning anyway.

> +/**
> + * do_sync_pq - synchronously calculate P and Q
> + */
> +static void
> +do_sync_pq(struct page **blocks, unsigned char *scfs, unsigned int offse=
t,
> +	int src_cnt, size_t len, enum async_tx_flags flags,
> +	struct dma_async_tx_descriptor *depend_tx,
> +	dma_async_tx_callback cb_fn, void *cb_param)
> +{
> +	u8 *p =3D NULL;
> +	u8 *q =3D NULL;
> +	u8 *ptrs[src_cnt];
> +	int d, z;
> +	u8 wd, wq, wp;

The scope of wd, wq and wp can be reduced to the for() loop in which they
are used.

> +
> +	/* address convert inputs */
> +	if (blocks[src_cnt])
> +		p =3D (u8 *)(page_address(blocks[src_cnt]) + offset);
> +	if (blocks[src_cnt+1])
> +		q =3D (u8 *)(page_address(blocks[src_cnt+1]) + offset);

Unnecessary casts.

> +			ptrs[z] =3D (u8 *)(page_address(blocks[z]) + offset);

again

> +/**
> + * async_pq - attempt to do XOR and Galois calculations in parallel using
> + *	a dma engine.
> + * @blocks: source block array from 0 to (src_cnt-1) with the p destinat=
ion
> + *	at blocks[src_cnt] and q at blocks[src_cnt + 1]. Only one of two
> + *	destinations may be present (another then has to be set to NULL).
> + *	NOTE: client code must assume the contents of this array are destroyed
> + * @offset: offset in pages to start transaction
> + * @src_cnt: number of source pages
> + * @scfs: array of source coefficients used in GF-multiplication
> + * @len: length in bytes
> + * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK, ASYNC_TX_ASYNC_ONLY
> + * @depend_tx: depends on the result of this transaction.
> + * @cb_fn: function to call when the operation completes
> + * @cb_param: parameter to pass to the callback routine
> + */

General remark: Many of the public functions in this file use a
similar set of parameters. As these functions my grow more users
in the future, it might ease maintainability in the long run if the
common parameter set would be combined to a structure and each of the
public functions would take a pointer to such a structure. Changing
the interface would then be a matter of altering only that structure
at one place while all function declarations could be left unchanged.

> +struct dma_async_tx_descriptor *
> +async_pq(struct page **blocks, unsigned int offset, int src_cnt,
> +	 unsigned char *scfs, size_t len, enum async_tx_flags flags,
> +	 struct dma_async_tx_descriptor *depend_tx,
> +	 dma_async_tx_callback cb_fn, void *cb_param)
> +{
> +	struct dma_chan *chan =3D async_tx_find_channel(depend_tx, DMA_PQ,
> +					&blocks[src_cnt], 2,
> +					blocks, src_cnt, len);
> +	struct dma_device *device =3D chan ? chan->device : NULL;
> +	struct dma_async_tx_descriptor *tx =3D NULL;
> +	bool do_async =3D false;
> +
> +	if (device && (src_cnt <=3D dma_maxpq(device, 0) ||
> +		       dma_maxpq(device, DMA_PREP_CONTINUE) > 0))
> +		do_async =3D true;
> +
> +	if (!device && (flags & ASYNC_TX_ASYNC_ONLY))
> +		return NULL;
> +
> +	if (do_async) {
> +		/* run pq asynchronously */
> +		tx =3D do_async_pq(chan, blocks, scfs, offset, src_cnt, len,
> +				 flags, depend_tx, cb_fn, cb_param);
> +	} else {
> +		/* run pq synchronously */
> +		if (!blocks[src_cnt+1]) { /* only p requested, just xor */
> +			flags |=3D ASYNC_TX_XOR_ZERO_DST;
> +			return async_xor(blocks[src_cnt], blocks, offset,
> +					 src_cnt, len, flags, depend_tx,
> +					 cb_fn, cb_param);
> +		}
> +
> +		/* wait for any prerequisite operations */
> +		async_tx_quiesce(&depend_tx);
> +
> +		do_sync_pq(blocks, scfs, offset, src_cnt, len, flags,
> +			depend_tx, cb_fn, cb_param);

Is it really OK to return NULL here?

> +	}
> +
> +	return tx;
> +}
> +EXPORT_SYMBOL_GPL(async_pq);

This function could be simplified a bit as follows:

	if (!device && (flags & ASYNC_TX_ASYNC_ONLY))
		return NULL;
	if (device && (src_cnt <=3D dma_maxpq(device, 0) ||
			dma_maxpq(device, DMA_PREP_CONTINUE) > 0))
		/* run pq asynchronously */
		return do_async_pq(chan, blocks, scfs, offset, src_cnt, len,
			flags, depend_tx, cb_fn, cb_param);

	/* run pq synchronously */
	if (!blocks[src_cnt+1]) {
		flags |=3D ASYNC_TX_XOR_ZERO_DST;
		return async_xor(blocks[src_cnt], blocks, offset,
			src_cnt, len, flags, depend_tx,cb_fn, cb_param);
	}
	/* wait for any prerequisite operations */
	async_tx_quiesce(&depend_tx);
	do_sync_pq(blocks, scfs, offset, src_cnt, len, flags,
		depend_tx, cb_fn, cb_param);
	return NULL;

This decreases the indent level and gets rid of the local variables
tx and do_async.

> +/**
> + * async_gen_syndrome - attempt to generate P (xor) and Q (Reed-Solomon =
code)
> + *	with a dma engine for a given set of blocks.  This routine assumes a
> + *	field of GF(2^8) with a primitive polynomial of 0x11d and a generator
> + *	of {02}.
> + * @blocks: source block array ordered from 0..src_cnt-1 with the P dest=
ination
> + *	at blocks[src_cnt] and Q at blocks[src_cnt + 1]. Only one of two
> + *	destinations may be present (another then has to be set to NULL).  So=
me

s/another/the other

> + * @src_cnt: number of source pages: 2 < src_cnt <=3D 255

This should be 1 < src_cnt, no? Tangent: Can this restriction be
relaxed to 0 < src_cnt (see current discussion on linux-raid)?

> +struct dma_async_tx_descriptor *
> +async_gen_syndrome(struct page **blocks, unsigned int offset, int src_cn=
t,
> +		   size_t len, enum async_tx_flags flags,
> +		   struct dma_async_tx_descriptor *depend_tx,
> +		   dma_async_tx_callback cb_fn, void *cb_param)
> +{
> +	struct dma_chan *chan =3D async_tx_find_channel(depend_tx, DMA_PQ,
> +						     &blocks[src_cnt], 2,
> +						     blocks, src_cnt, len);
> +	struct dma_device *device =3D chan ? chan->device : NULL;
> +	struct dma_async_tx_descriptor *tx =3D NULL;
> +	bool do_async =3D false;
> +
> +	BUG_ON(src_cnt > 255 || (!blocks[src_cnt] && !blocks[src_cnt+1]));

src_cnt < 2 is also a bug.

> +
> +	if (device && (src_cnt <=3D dma_maxpq(device, 0) ||
> +		       dma_maxpq(device, DMA_PREP_CONTINUE) > 0))
> +		do_async =3D true;
> +
> +	if (!do_async && (flags & ASYNC_TX_ASYNC_ONLY))
> +		return NULL;
> +
> +	if (do_async) {
> +		/* run the p+q asynchronously */
> +		tx =3D do_async_pq(chan, blocks, (uint8_t *)raid6_gfexp,
> +				 offset, src_cnt, len, flags, depend_tx,
> +				 cb_fn, cb_param);
> +	} else {
> +		/* run the pq synchronously */
> +		/* wait for any prerequisite operations */
> +		async_tx_quiesce(&depend_tx);
> +
> +		if (!blocks[src_cnt])
> +			blocks[src_cnt] =3D scribble;
> +		if (!blocks[src_cnt+1])
> +			blocks[src_cnt+1] =3D scribble;
> +		do_sync_gen_syndrome(blocks, offset, src_cnt, len, flags,
> +				     depend_tx, cb_fn, cb_param);
> +	}
> +
> +	return tx;
> +}
> +EXPORT_SYMBOL_GPL(async_gen_syndrome);

Roughly the same comments as to async_pq() apply.

> +/**
> + * async_syndrome_zero_sum - attempt a P (xor) and Q (Reed-Solomon code)
> + *	parities check with a dma engine. This routine assumes a field of
> + *	GF(2^8) with a primitive polynomial of 0x11d and a generator of {02}.

DRY. Honestly, that function is amost identical to async_pq_zero_sum(),
the only difference being that async_pq_zero_sum() is more general
as it works for arbitrary coefficient vectors due to its additional
scfs parameter. So async_syndrome_zero_sum() should really call
async_pq_zero_sum() rather than duplicating its logic.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJwqaXWto1QDEAkw8RAl1zAJ9ViAyxnbRZyzxJYUGHTkoZWcYQWgCffeBO
YMh/rVFmbuWHJ97fSAAslcY=
=aCNE
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
