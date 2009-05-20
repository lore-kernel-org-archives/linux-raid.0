From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH v2 03/11] async_tx: structify submission arguments, add scribble
Date: Wed, 20 May 2009 10:06:54 +0200
Message-ID: <20090520080654.GS6403@skl-net.de>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com> <20090519005941.4104.24363.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOmQO3H5Qmmwdmk8"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090519005941.4104.24363.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--hOmQO3H5Qmmwdmk8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2009 at 05:59:41PM -0700, Dan Williams wrote:

> diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcp=
y.c
> index 7117ec6..c9342ae 100644
> --- a/crypto/async_tx/async_memcpy.c
> +++ b/crypto/async_tx/async_memcpy.c
> @@ -35,26 +35,23 @@
>   * @src: src page
>   * @offset: offset in pages to start transaction
>   * @len: length in bytes
> - * @flags: ASYNC_TX_ACK
> - * @depend_tx: memcpy depends on the result of this transaction
> - * @cb_fn: function to call when the memcpy completes
> - * @cb_param: parameter to pass to the callback routine
> + * @submit: submission / completion modifiers
>   */
>  struct dma_async_tx_descriptor *
>  async_memcpy(struct page *dest, struct page *src, unsigned int dest_offs=
et,
> -	unsigned int src_offset, size_t len, enum async_tx_flags flags,
> -	struct dma_async_tx_descriptor *depend_tx,
> -	dma_async_tx_callback cb_fn, void *cb_param)
> +	     unsigned int src_offset, size_t len,
> +	     struct async_submit_ctl *submit)
>  {

The third parameter is called "dest_offset", but the comment refers to
"@offset".

> +struct async_submit_ctl {
> +	enum async_tx_flags flags;
> +	struct dma_async_tx_descriptor *depend_tx;
> +	dma_async_tx_callback cb_fn;
> +	void *cb_param;
> +	void *scribble;
> +};

Can't scribble be of type addr_conv_t *?

Apart from these two minor issues the patch looks really nice. Thanks
for taking the time to combine the common submission parameters to
the new structure. This improves readability of the code and makes
adaptation to future needs easier.

Signed-off-by: Andre Noll <maan@systemlinux.org>

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe


--hOmQO3H5Qmmwdmk8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD4DBQFKE7oeWto1QDEAkw8RAhH5AJMGQhCEgL8nsmN9Bv15ZQFZuB62AJ90VBUJ
ag2Asz6gWlmqurEwM2UEUw==
=UmXv
-----END PGP SIGNATURE-----

--hOmQO3H5Qmmwdmk8--
