From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH v2 05/11] md/raid5: add scribble region for buffer lists
Date: Wed, 20 May 2009 10:09:10 +0200
Message-ID: <20090520080910.GU6403@skl-net.de>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com> <20090519005951.4104.27062.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JcGvecxLhm+LytDG"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090519005951.4104.27062.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--JcGvecxLhm+LytDG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2009 at 05:59:51PM -0700, Dan Williams wrote:

> +static size_t scribble_len(int num)
> +{
> +	size_t len;
> +
> +	/* return enough space for an array of page pointers and dma
> +	 * addresses for the ddf raid6 layout
> +	 */
> +	len =3D sizeof(struct page *) * (num+2) + sizeof(addr_conv_t) * (num+2);
> +
> +	return len;
> +}

The comment is a bit misleading as the function only returns the
_amount_ of space needed. It should probably also explain the meaning
of the "+2".

> +/* return a pointer to the address conversion region of the scribble buf=
fer */
> +static addr_conv_t *sh_to_addr_conv(struct stripe_head *sh)
> +{
> +	return sh->scribble + sizeof(struct page *) * (sh->disks + 2);
> +}

Maybe it's safer to return NULL if sh->scribble is NULL.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe


--JcGvecxLhm+LytDG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKE7qmWto1QDEAkw8RAp1pAKCHzd0hL9/7QTD03jQJ32DeMIbIRACdFLeA
N5Sy6bGqKv/anaFDpkQsz5E=
=i+qn
-----END PGP SIGNATURE-----

--JcGvecxLhm+LytDG--
