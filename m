From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH v2 11/11] async_tx: raid6 recovery self test
Date: Fri, 22 May 2009 10:29:23 +0200
Message-ID: <20090522082923.GO11504@skl-net.de>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com> <20090519010022.4104.8698.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ck22u5fw4m2k6hx2"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090519010022.4104.8698.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Ck22u5fw4m2k6hx2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2009 at 06:00:22PM -0700, Dan Williams wrote:

> +static void makedata(void)
> +{
> +	int i, j;
> +
> +	for (i =3D 0; i < NDISKS; i++) {

i < NDISKS - 2 would be sufficient.

> +static char disk_type(int d)
> +{
> +	switch (d) {
> +	case NDISKS-2:
> +		return 'P';
> +	case NDISKS-1:
> +		return 'Q';
> +	default:
> +		return 'D';
> +	}
> +}

I like this function very much because "if (disk_type(faila) =3D=3D 'Q')"
is so much more readable than "if (faila =3D=3D num_disks - 1)". It's a
pity that we only have it in this test module ;)

> +/* Recover two failed blocks. */
> +static void raid6_dual_recov(int disks, size_t bytes, int faila, int fai=
lb, struct page **ptrs)

As disks is always NDISKS, the disks parameter could be removed.

> +{
> +	struct async_submit_ctl submit;
> +	addr_conv_t addr_conv[NDISKS];
> +	struct completion cmp;
> +	struct dma_async_tx_descriptor *tx =3D NULL;
> +	enum sum_check_flags result =3D ~0;
> +	bool dataq =3D false;
> +
> +	if (faila > failb)
> +		swap(faila, failb);
> +
> +	init_async_submit(&submit, 0, NULL, NULL, NULL, addr_conv);
> +	if (failb =3D=3D disks-1) {

if (disk_type(failb) =3D=3D 'Q'). Similar for the other tests in this funct=
ion.

> +	/* Generate assumed good syndrome */
> +	init_completion(&cmp);
> +	init_async_submit(&submit, ASYNC_TX_ACK, NULL, callback, &cmp, addr_con=
v);
> +	async_gen_syndrome(dataptrs, 0, NDISKS, PAGE_SIZE, &submit);

How hard would it be to also test the fallback code for the synchronous
paths? AFAICS this test module wouldn't notice errors in the fallback
logic.

> +config ASYNC_RAID6_TEST
> +	tristate "Self test for hardware accelerated raid6 recovery"
> +	depends on MD_RAID6_PQ
> +	select ASYNC_RAID6_RECOV
> +	---help---
> +	  This is a one-shot self test that permutes through the
> +	  recovery of all the possible two disk failure scenarios for a
> +	  N-disk array.  Recovery is performed with the asynchronous

Currently N is 16. So s/N-disk/raid6 perhaps?

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Ck22u5fw4m2k6hx2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKFmJjWto1QDEAkw8RAhYEAKCHkU/FYAxzI4UGMlVFdMbuqhWYqgCfaYRN
bXTHc07+8Om6aNw7N6YUblA=
=KoGi
-----END PGP SIGNATURE-----

--Ck22u5fw4m2k6hx2--
