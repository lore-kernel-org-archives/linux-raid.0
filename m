From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 09/18] md/raid6: remove expectation that Q device is immediately after P device.
Date: Thu, 12 Feb 2009 17:56:25 +0100
Message-ID: <20090212165625.GH32416@skl-net.de>
References: <20090212031009.23983.14496.stgit@notabene.brown> <20090212031010.23983.26264.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RwGu8mu1E+uYXPWP"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090212031010.23983.26264.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--RwGu8mu1E+uYXPWP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14:10, NeilBrown wrote:

> -static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int prev=
ious);
> +static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int prev=
ious,
> +			   int *qd_idx);

That's a bit ugly, isn't it? The function computes both the p index
and the q index which is not obvious from its name. Also, the p index
is the return value and the q index is returned via a pointer which
is a bit unsymmetric.

static void get_parity_indices(sector_t stripe, raid5_conf_t *conf, int pre=
vious,
				 int *pd_idx, int *qd_idx);

perhaps?

> +	/* Note that unlike RAID-5, the ordering of the disks matters greatly.*/
> +	/* FIX: Is this ordering of drives even remotely optimal? */
> +	count =3D 0;
> +	i =3D d0_idx;
> +	do {
> +		if (i =3D=3D sh->pd_idx)
> +			ptrs[disks-2] =3D page_address(sh->dev[i].page);
> +		else if (i =3D=3D sh->qd_idx)
> +			ptrs[disks-1] =3D page_address(sh->dev[i].page);
> +		else {
>  			ptrs[count++] =3D page_address(sh->dev[i].page);
> -			if (count <=3D disks-2 && !test_bit(R5_UPTODATE, &sh->dev[i].flags))
> +			if (!test_bit(R5_UPTODATE, &sh->dev[i].flags))
>  				printk("block %d/%d not uptodate on parity calc\n", i,count);
> -			i =3D raid6_next_disk(i, disks);
> -		} while ( i !=3D d0_idx );
> -//		break;
> -//	}
> +		}
> +		i =3D raid6_next_disk(i, disks);
> +	} while (i !=3D d0_idx);
> +	BUG_ON(count+2 !=3D disks);

Isn't it really dangerous to ignore a dirty stripe head during parity
calculation? I understand that compute_parity6() does not have a
return value and that dirty stripe heads have always been ignored by
compute_parity6(). But it looks much saner to fail in this case.

BTW, the printk lacks a KERN_ERR.

> +	/**** FIX THIS: This could be very bad if disks is close to 256 ****/
> +	void *ptrs[disks];

How serious is this? It's probably not a problem for version 0.90
superblocks as one can't have more than 26 disks. OTOH, for version
1 superblocks we might end up using up to 2K of stack space on 64
bit machines.

Would it be a reasonable to always allocate 26 pointers, say, and
fall back to malloc() if this turns out to be too small?

> +	count =3D 0;
> +	i =3D d0_idx;
> +	do {
> +		int slot;
> +		if (i =3D=3D sh->pd_idx)
> +			slot =3D disks-2;
> +		else if (i =3D=3D sh->qd_idx)
> +			slot =3D disks-1;
> +		else
> +			slot =3D count++;
> +		ptrs[slot] =3D page_address(sh->dev[i].page);
> +		if (i =3D=3D dd_idx1)
> +			faila =3D slot;
> +		if (i =3D=3D dd_idx2)
> +			failb =3D slot;
> +		i =3D raid6_next_disk(i, disks);
> +	} while (i !=3D d0_idx);
> +	BUG_ON(count+2 !=3D disks);

Deja vu. How about using a helper function like

static inline int is_parity_idx(int idx, struct stripe_head_sh)
{
	if (idx =3D=3D sh->pd_idx)
		return sh->disks - 2;
	if (idx =3D=3D sh->qd_idx)
		return sh->disks - 1;
	return 0;
}

Then the above becomes

	int slot =3D is_parity_idx(i, sh);
	if (!slot)
		slot =3D count++;

And in compute_parity6() we could write

	count =3D 0;
	i =3D d0_idx;
	do {
		int slot =3D is_parity_idx(i, sh);
		if (!slot)
			slot =3D count++;
		ptrs[slot] =3D page_address(sh->dev[i].page);


Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--RwGu8mu1E+uYXPWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJlFS5Wto1QDEAkw8RAgO4AJ9bvVCGI+Mpq/w4MFLDdLggwPUN9wCfeuaE
6Em7JCY2qkVCE9IHr+XR5hY=
=ib70
-----END PGP SIGNATURE-----

--RwGu8mu1E+uYXPWP--
