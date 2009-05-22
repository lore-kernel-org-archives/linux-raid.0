From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH v2 09/11] async_tx: add support for asynchronous RAID6 recovery operations
Date: Fri, 22 May 2009 10:29:08 +0200
Message-ID: <20090522082908.GN11504@skl-net.de>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com> <20090519010012.4104.50825.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aSnC4ZPPfhCvD8sN"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090519010012.4104.50825.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--aSnC4ZPPfhCvD8sN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2009 at 06:00:12PM -0700, Dan Williams wrote:
> +/**
> + * async_raid6_2data_recov - asynchronously calculate two missing data b=
locks
> + * @disks: number of disks in the RAID-6 array
> + * @bytes: block size
> + * @faila: first failed drive index
> + * @failb: second failed drive index
> + * @blocks: array of source pointers where the last two entries are p an=
d q
> + * @submit: submission/completion modifiers
> + */
> +struct dma_async_tx_descriptor *
> +async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
> +			struct page **blocks, struct async_submit_ctl *submit)
> +{

[...]

> +	/* Dx =3D A*(P+Pxy) + B*(Q+Qxy) */
> +	srcs[0] =3D dp;
> +	srcs[1] =3D dq;
> +	coef[0] =3D raid6_gfexi[failb-faila];

Here it's essential that faila < failb. This should either be clearly
documented and checked for, or (better) the function should swap
faila and failb if they are in the wrong order.

> +	p =3D blocks[disks-2];
> +	q =3D blocks[disks-1];
> +
> +	/* Compute syndrome with zero for the missing data page
> +	   Use the dead data page as temporary storage for delta q */
> +	dq =3D blocks[faila];
> +	blocks[faila] =3D (void *)raid6_empty_zero_page;
> +	blocks[disks-1] =3D dq;
> +
> +	submit->flags &=3D ~ASYNC_TX_ACK;
> +	submit->cb_fn =3D NULL;
> +	submit->cb_param =3D NULL;
> +	tx =3D async_gen_syndrome(blocks, 0, disks, bytes, submit);
> +	submit->depend_tx =3D tx;
> +
> +	/* Restore pointer table */
> +	blocks[faila]   =3D dq;
> +	blocks[disks-1] =3D q;
> +
> +	/* Now, pick the proper data tables */
> +	coef =3D raid6_gfinv[raid6_gfexp[faila]];

Pick data tables? The formula for recovering the data block is

        (q + dq) / g^faila

(with g being the generator). What this line actually does is computing
g^{-faila}.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--aSnC4ZPPfhCvD8sN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKFmJUWto1QDEAkw8RAjodAJ93zWs2yPA8chSvvGC7KAa3dMOn4QCgoPMQ
wiRqEK5pWfgEUysdKSR7n+8=
=1G4W
-----END PGP SIGNATURE-----

--aSnC4ZPPfhCvD8sN--
