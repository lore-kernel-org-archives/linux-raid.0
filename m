From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/6] imsm: Add --export option for --detail-platform
Date: Tue, 2 Oct 2012 16:28:22 +1000
Message-ID: <20121002162822.1f9df652@notabene.brown>
References: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
	<20120926114243.328.15028.stgit@gklab-128-174.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_hbv.MLyqIbIOuQp+ng/S61"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120926114243.328.15028.stgit@gklab-128-174.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

--Sig_/_hbv.MLyqIbIOuQp+ng/S61
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Sep 2012 13:42:43 +0200 Maciej Naruszewicz
<maciej.naruszewicz@intel.com> wrote:

> This option will provide most of information we can get via
> mdadm --detail-platform [-e format] in the key=3Dvalue format.
> Example output:
>=20
> $ mdadm --detail-platform
>        Platform : Intel(R) Matrix Storage Manager
>         Version : 9.5.0.1037
>     RAID Levels : raid0 raid1 raid10 raid5
>     Chunk Sizes : 4k 8k 16k 32k 64k 128k
>     2TB volumes : supported
>       2TB disks : not supported
>       Max Disks : 7
>     Max Volumes : 2 per array, 4 per controller
>  I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)
>=20
> $ mdadm --detail-platform --export
> MD_FIRMWARE_TYPE=3Dimsm
> IMSM_VERSION=3D9.5.0.1037
> IMSM_SUPPORTED_RAID_LEVELS=3Draid0 raid1 raid10 raid5
> IMSM_SUPPORTED_CHUNK_SIZES=3D4k 8k 16k 32k 64k 128k
> IMSM_2TB_VOLUMES=3Dyes
> IMSM_2TB_DISKS=3Dno
> IMSM_MAX_DISKS=3D7
> IMSM_MAX_VOLUMES_PER_ARRAY=3D2
> IMSM_MAX_VOLUMES_PER_CONTROLLER=3D4
>=20
> Signed-off-by: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
> ---
>  Detail.c      |    8 +++++--
>  ReadMe.c      |    4 ++-
>  mdadm.8.in    |    2 +-
>  mdadm.c       |    2 +-
>  mdadm.h       |    3 ++
>  super-intel.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  6 files changed, 82 insertions(+), 7 deletions(-)
>=20
> diff --git a/Detail.c b/Detail.c
> index f633d93..b0c31e6 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -616,7 +616,7 @@ out:
>  	return rv;
>  }
> =20
> -int Detail_Platform(struct superswitch *ss, int scan, int verbose)
> +int Detail_Platform(struct superswitch *ss, int scan, int verbose, int e=
xport)
>  {
>  	/* display platform capabilities for the given metadata format
>  	 * 'scan' in this context means iterate over all metadata types
> @@ -624,7 +624,9 @@ int Detail_Platform(struct superswitch *ss, int scan,=
 int verbose)
>  	int i;
>  	int err =3D 1;
> =20
> -	if (ss && ss->detail_platform)
> +	if (ss && export && ss->export_detail_platform)
> +		err =3D ss->export_detail_platform(verbose);
> +	else if (ss && ss->detail_platform)
>  		err =3D ss->detail_platform(verbose, 0);
>  	else if (ss) {
>  		if (verbose > 0)
> @@ -650,6 +652,8 @@ int Detail_Platform(struct superswitch *ss, int scan,=
 int verbose)
>  			if (verbose > 0)
>  				pr_err("%s metadata is platform independent\n",
>  					meta->name ? : "[no name]");
> +		} else if (export){
> +			err |=3D meta->export_detail_platform(verbose);
>  		} else
>  			err |=3D meta->detail_platform(verbose, 0);
>  	}

I changed this to:

  } else if (export && meta->export_detail_platform) {

otherwise looks good,
thanks,
NeilBrown

--Sig_/_hbv.MLyqIbIOuQp+ng/S61
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGqJhjnsnt1WYoG5AQJRFA/9GpfX3q4KCVyiPvjfHk0g6Ei2Yh2KDHMi
Bc8F0gfg8ctJYk7nXxKTz2AJxIqg3WthdOYsKwM0BR0J4XR9RqnY+gPJjVzZvMjD
Z4UXikYsouXiSi9XFGdOuDSaWb8JzCtZQf03Ljtxms9qYIV6Po69fhQCYLtaNvMZ
jk8HTzogZEwBxl45pPqKMDK6FBKdUvMq4mxoJ46pIlCB6z2JUDTWRyiY/IpNbYrY
OgONFjkVcHcd7Eotev/sXkvdUjz2bwGckomz8v7jCUiHEGbmcMZUDnTLFEBhJvLY
C1+malRLlzIJ0LJ9phxcawFrgsHoaaBeX2sDI/6/Q4v/3l4ZEccX7B2IQfB1j/HB
IfPUayCssWM/XyP4bvhWR+JJAls3Zlglsrpgu4HqHR7Hru/rxmJJOYtfmG8c2j/y
pcglnlRXf4RM0G5xcMNOU4FSx4BfkTAfnS0TdEeoDKIVWnfP9/LJ3oPVWaU93iwm
U/4WtTn7qVNlKGdq3dZNctG5zujZX91tsxY53s7g3uLhh2xEb0qG/KTaIr4UcKnn
33PKhWX1G9EAGOHuJcmhD172Fjvdini1v9U4mmrF7Y0bmKZ+tjBGSRUyNGwk3VJP
UUc+YMUdTtiODDfky2fBWKqqb6AdQ40+hdCmQQQjLzz34JBm7G1QeMnWhPOsz/EH
/5hT+F2qsho=
=XgeC
-----END PGP SIGNATURE-----

--Sig_/_hbv.MLyqIbIOuQp+ng/S61--
