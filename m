From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix: correct adding and activation of spare disks
Date: Wed, 5 Oct 2011 14:19:14 +1100
Message-ID: <20111005141914.1b64aa62@notabene.brown>
References: <20111004145654.25974.12262.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OoJyYum5r1WuLwcwc9dTZeV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111004145654.25974.12262.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/OoJyYum5r1WuLwcwc9dTZeV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 04 Oct 2011 16:56:54 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> During activation of spare disks, only one of all available
> spare disks can be activated at this moment.
> It causes that for example during take-over from
> RAID0 with 2 disks to RAID10, only one of two spare disks
> is taken for recovery and a degraded RAID10 array
> with only 3 of 4 working disks is created.
> It has been fixed by adding more than one of all available
> spare disks and saving them in additional_test_list
> which is passed to imsm_add_spare().
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  super-intel.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 7de207a..3185e91 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -6672,9 +6672,9 @@ static struct mdinfo *imsm_activate_spare(struct ac=
tive_array *a,
>  		 */
>  		dl =3D imsm_readd(super, i, a);
>  		if (!dl)
> -			dl =3D imsm_add_spare(super, i, a, 0, NULL);
> +			dl =3D imsm_add_spare(super, i, a, 0, rv);
>  		if (!dl)
> -			dl =3D imsm_add_spare(super, i, a, 1, NULL);
> +			dl =3D imsm_add_spare(super, i, a, 1, rv);
>  		if (!dl)
>  			continue;
>  =20
> @@ -6711,8 +6711,6 @@ static struct mdinfo *imsm_activate_spare(struct ac=
tive_array *a,
>  		num_spares++;
>  		dprintf("%x:%x to be %d at %llu\n", dl->major, dl->minor,
>  			i, di->data_offset);
> -
> -		break;
>  	}
> =20
>  	if (!rv)


applied, thanks,

NeilBrown

--Sig_/OoJyYum5r1WuLwcwc9dTZeV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOi8yyG5fc6gV+Wb0RAs4lAJ9HQNa2ghJj1DYAEL8ozAroDJEqzQCeI4eU
tAKGf88HtHV7Y955IpfJZ3c=
=SL/x
-----END PGP SIGNATURE-----

--Sig_/OoJyYum5r1WuLwcwc9dTZeV--
