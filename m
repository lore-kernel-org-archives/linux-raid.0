From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] imsm: FIX: Chunk size migration is not possible
Date: Thu, 15 Dec 2011 15:01:59 +1100
Message-ID: <20111215150159.44f8e1c9@notabene.brown>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
	<20111214150704.21483.66299.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KfFM6MzxLye1ckRq0u6M+GB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111214150704.21483.66299.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/KfFM6MzxLye1ckRq0u6M+GB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Dec 2011 16:07:05 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> Chunk size only migration for raid0 and raid5 is not possible.
> (mdadm UT 15* fails). Mdadm exits with information:
>    mdadm: imsm unknown layout 0xffffffff for this raid level 0
>=20
> Problem was introduced in patch (2011-11-16):
>    imsm: platform capabilities are not validated during level migration
>=20
> During chunk size migration layout variable is not set correctly.
> Set it correctly for this migration type.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>


Applied, thanks.

NeilBrown







> ---
>=20
>  super-intel.c |   19 ++++++++++++-------
>  1 files changed, 12 insertions(+), 7 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 3a34f5a..e1073ef 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -9050,8 +9050,10 @@ enum imsm_reshape_type imsm_analyze_change(struct =
supertype *st,
>  	int change =3D -1;
>  	int check_devs =3D 0;
>  	int chunk;
> -	int devNumChange=3D0;
> -	int layout =3D -1;
> +	/* number of added/removed disks in operation result */
> +	int devNumChange =3D 0;
> +	/* imsm compatible layout value for array geometry verification */
> +	int imsm_layout =3D -1;
> =20
>  	getinfo_super_imsm_volume(st, &info, NULL);
>  	if ((geo->level !=3D info.array.level) &&
> @@ -9069,14 +9071,14 @@ enum imsm_reshape_type imsm_analyze_change(struct=
 supertype *st,
>  					change =3D -1;
>  					goto analyse_change_exit;
>  				}
> -				layout =3D  geo->layout;
> +				imsm_layout =3D  geo->layout;
>  				check_devs =3D 1;
>  				devNumChange =3D 1; /* parity disk added */
>  			} else if (geo->level =3D=3D 10) {
>  				change =3D CH_TAKEOVER;
>  				check_devs =3D 1;
>  				devNumChange =3D 2; /* two mirrors added */
> -				layout =3D 0x102; /* imsm supported layout */
> +				imsm_layout =3D 0x102; /* imsm supported layout */
>  			}
>  			break;
>  		case 1:
> @@ -9085,7 +9087,7 @@ enum imsm_reshape_type imsm_analyze_change(struct s=
upertype *st,
>  				change =3D CH_TAKEOVER;
>  				check_devs =3D 1;
>  				devNumChange =3D -(geo->raid_disks/2);
> -				layout =3D 0; /* imsm raid0 layout */
> +				imsm_layout =3D 0; /* imsm raid0 layout */
>  			}
>  			break;
>  		}
> @@ -9120,8 +9122,11 @@ enum imsm_reshape_type imsm_analyze_change(struct =
supertype *st,
>  			change =3D -1;
>  			goto analyse_change_exit;
>  		}
> -	} else
> +	} else {
>  		geo->layout =3D info.array.layout;
> +		if (imsm_layout =3D=3D -1)
> +			imsm_layout =3D info.array.layout;
> +	}
> =20
>  	if ((geo->chunksize > 0) && (geo->chunksize !=3D UnSet)
>  	    && (geo->chunksize !=3D info.array.chunk_size))
> @@ -9132,7 +9137,7 @@ enum imsm_reshape_type imsm_analyze_change(struct s=
upertype *st,
>  	chunk =3D geo->chunksize / 1024;
>  	if (!validate_geometry_imsm(st,
>  				    geo->level,
> -				    layout,
> +				    imsm_layout,
>  				    geo->raid_disks + devNumChange,
>  				    &chunk,
>  				    geo->size,


--Sig_/KfFM6MzxLye1ckRq0u6M+GB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTulxNznsnt1WYoG5AQL4aw//cqo0s0S1RZY+C4Nsv2fPsPDRaR2MoP9K
SN6IeeTVrkLFyNPqyKhBOayWEXsYEjHEgJZb+ITk2ymDv15k0DnAWHzNNPJMMf/b
voFhlivfoiCWgQKlXL2BQyb18VOvvIfQ7NN0qAZf41nQF+DzP1k1thK28r7+4THe
O64w6ZaPPT6VJ46ES06DuchtfSthCN0bOsjzrKeB3syqWJbNOnqJ2OBtZBwMuWhl
LTwKHsZGkb6ke9u70bRTjzEhV+/wski7pFqbdGNCym4HeadkegdWYTLgngPxZ/Oh
WpI/8ReCrpFPxUbr4z70N9sqMU22HuNSbMoc3VG1LaqO5rKDT+z7C33OYlLDeolu
kj7QGtNwYRuQEuZUy4rGhWtFbk+iKG5bztOZKb2rlL6f7kI7jHxYekOh8QagPpPV
Dhoxgc4uvMjpZryl/nIdvohTCBUlCv0jvS9jIGCoFWFGcvXtxWmXYz2NBY7+VInS
Nyh5rYtb9Pxd5RXB1ExIZvnzNkOGQK6SXwrLmBMEA6rJddml2gw1gBu53LhsGjmB
1t85h591jx1M7jJKFrdjC2c5Meso6vXEybdLCcj5qLbAAYqK6p+gUIjBzTrcs8ib
19cLwHMqyO4RRlHv/R+GRzCWz41am9I2fR1HJQ9tQfaAGGHbgersmDBJLaLarnrc
iNf0LQcIkzU=
=yLt1
-----END PGP SIGNATURE-----

--Sig_/KfFM6MzxLye1ckRq0u6M+GB--
