From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: resolve make everything compilation error
Date: Tue, 6 Dec 2011 11:56:59 +1100
Message-ID: <20111206115659.1ea5448e@notabene.brown>
References: <20111205120816.30466.14434.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2mZ_ZR6.kDYHx6bmoRVlXbx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111205120816.30466.14434.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/2mZ_ZR6.kDYHx6bmoRVlXbx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 05 Dec 2011 13:08:16 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When mdadm is compiled using e.g. 'everything' option, mdasseble
> compilation is broken.
>=20
> Change code to enable mdasseble compilation
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  mdassemble.c  |    2 +-
>  super-intel.c |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/mdassemble.c b/mdassemble.c
> index 66e480a..f5bc746 100644
> --- a/mdassemble.c
> +++ b/mdassemble.c
> @@ -85,7 +85,7 @@ int main(int argc, char *argv[]) {
>  			rv |=3D Assemble(array_list->st, array_list->devname,
>  				       array_list, NULL, NULL, 0,
>  				       readonly, runstop, NULL, NULL, 0,
> -				       verbose, force);
> +				       verbose, force, 1);
>  		}
>  	return rv;
>  }
> diff --git a/super-intel.c b/super-intel.c
> index a0672bf..82eba7b 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -1014,12 +1014,12 @@ static unsigned long long min_acceptable_spare_si=
ze_imsm(struct supertype *st)
>  	return rv * 512;
>  }
> =20
> +static int is_gen_migration(struct imsm_dev *dev);
> +
>  #ifndef MDASSEMBLE
>  static __u64 blocks_per_migr_unit(struct intel_super *super,
>  				  struct imsm_dev *dev);
> =20
> -static int is_gen_migration(struct imsm_dev *dev);
> -
>  static void print_imsm_dev(struct intel_super *super,
>  			   struct imsm_dev *dev,
>  			   char *uuid,
> @@ -5618,6 +5618,7 @@ static int update_subarray_imsm(struct supertype *s=
t, char *subarray,
> =20
>  	return 0;
>  }
> +#endif /* MDASSEMBLE */
> =20
>  static int is_gen_migration(struct imsm_dev *dev)
>  {
> @@ -5632,7 +5633,6 @@ static int is_gen_migration(struct imsm_dev *dev)
> =20
>  	return 0;
>  }
> -#endif /* MDASSEMBLE */
> =20
>  static int is_rebuilding(struct imsm_dev *dev)
>  {


Applied.  Thanks for testing "make everything" !

NeilBrown

--Sig_/2mZ_ZR6.kDYHx6bmoRVlXbx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt1oWznsnt1WYoG5AQKUFQ/+PLBpEbjdWcBY0qzxce1FVdZ8DcuOABWM
/lROkDJu72CfpYdHFDMRFRIx5r6Yv9q9CNlqEngMH6kqJSOc9P27Wl99y/fc+4lA
aJNicyubOi9VSPFiOO9pkU2Y6ZASdaGV9TtTOIiy8vAKaDOGP1F5NS8FqP+AYwzv
PjyuubHYrDjT91FU4ZA7rkf1tSdkMXvJjWez4pmI+hrddUVfVmsk9uJZO3WCaEaf
lK7I1Bx2NtC67zj+squ6tKM9VwjGtneJAnyoQMoVmEjHyMItPduxxynC9U5pz60G
i+52lfqRNyAyehJVU/OiQ/uHstbmKRGJKQII98DZsMQK9OcqK3LAH3epsRtadaQQ
bxw936Dh2o3Hq+JREbiBk5xFiWtWLLzFNK9zQ68MFu+h01pgv7lJZj1aAcB4psC0
FRfyM8gRDktJirrIDQTes5jx+n/fvXTIABqO1M9pY9+17ANMGWkWARIVaQjecReo
CiGbqP74W/6InfzQhidRwNwfhA8fKZex8J1OxJux5bLDrDe2lps2lQKbpFbH2VHU
8OTli1vTtWcAEKUqLvlr5pvM4J1229IwUUAvuD50JcoBjG5TAZhJlhaZBdvbeZjz
mBz02zgpBDGZyAPzAqklDDI0wMa5pWsAU2gqQ60frLYRUK7O+9u03q1S8JfM0sLn
iz+jV5yGoSM=
=vmfp
-----END PGP SIGNATURE-----

--Sig_/2mZ_ZR6.kDYHx6bmoRVlXbx--
