From: NeilBrown <neilb@suse.de>
Subject: Re: [v3 PATCH] imsm: Allow to specify controller for
 --detail-platform.
Date: Thu, 4 Oct 2012 16:34:37 +1000
Message-ID: <20121004163437.72c73d46@notabene.brown>
References: <20121003082130.18987.72713.stgit@gklab-128-174.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/A408dOWwX4NQXoVXfgJ4zaX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121003082130.18987.72713.stgit@gklab-128-174.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

--Sig_/A408dOWwX4NQXoVXfgJ4zaX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 03 Oct 2012 10:21:30 +0200 Maciej Naruszewicz
<maciej.naruszewicz@intel.com> wrote:

> Usually, 'mdadm --detail-platform -e imsm' scans all the controllers
> looking for IMSM capabilities. This patch provides the possibility
> to specify a controller to scan, enabling custom usage by other
> processes - especially with the --export switch.
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
> $ mdadm --detail-platform /sys/devices/pci0000:00/0000:00:1f.2
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
> $ mdadm --detail-platform /sys/devices/pci0000:00/0000:00:1f.2 --export
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
> $ mdadm --detail-platform /sys/devices/pci0000:00/0000:00:1f.0 # This isn=
't an IMSM-capable controller
> mdadm: no active Intel(R) RAID controller found under /sys/devices/pci000=
0:00/0000:00:1f.0
>=20
> Signed-off-by: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
> ---
>  Create.c      |    2 +-
>  Detail.c      |   10 +++++-----
>  mdadm.8.in    |    6 +++++-
>  mdadm.c       |   11 +++++++++--
>  mdadm.h       |    7 ++++---
>  super-intel.c |   45 +++++++++++++++++++++++++--------------------
>  util.c        |   21 +++++++++++++++++++++
>  7 files changed, 70 insertions(+), 32 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index 32683a8..2da07d0 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -492,7 +492,7 @@ int Create(struct supertype *st, char *mddev,
>  		warn =3D 1;
>  	}
> =20
> -	if (st->ss->detail_platform && st->ss->detail_platform(0, 1) !=3D 0) {
> +	if (st->ss->detail_platform && st->ss->detail_platform(0, 1, NULL) !=3D=
 0) {
>  		if (c->runstop !=3D 1 || c->verbose >=3D 0)
>  			pr_err("%s unable to enumerate platform support\n"
>  				"    array may not be compatible with hardware/firmware\n",
> diff --git a/Detail.c b/Detail.c
> index b0c31e6..57faf3c 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -616,7 +616,7 @@ out:
>  	return rv;
>  }
> =20
> -int Detail_Platform(struct superswitch *ss, int scan, int verbose, int e=
xport)
> +int Detail_Platform(struct superswitch *ss, int scan, int verbose, int e=
xport, char *controller_path)
>  {
>  	/* display platform capabilities for the given metadata format
>  	 * 'scan' in this context means iterate over all metadata types
> @@ -625,9 +625,9 @@ int Detail_Platform(struct superswitch *ss, int scan,=
 int verbose, int export)
>  	int err =3D 1;
> =20
>  	if (ss && export && ss->export_detail_platform)
> -		err =3D ss->export_detail_platform(verbose);
> +		err =3D ss->export_detail_platform(verbose, controller_path);
>  	else if (ss && ss->detail_platform)
> -		err =3D ss->detail_platform(verbose, 0);
> +		err =3D ss->detail_platform(verbose, 0, controller_path);
>  	else if (ss) {
>  		if (verbose > 0)
>  			pr_err("%s metadata is platform independent\n",
> @@ -653,9 +653,9 @@ int Detail_Platform(struct superswitch *ss, int scan,=
 int verbose, int export)
>  				pr_err("%s metadata is platform independent\n",
>  					meta->name ? : "[no name]");
>  		} else if (export){
> -			err |=3D meta->export_detail_platform(verbose);
> +			err |=3D meta->export_detail_platform(verbose, controller_path);
>  		} else
> -			err |=3D meta->detail_platform(verbose, 0);
> +			err |=3D meta->detail_platform(verbose, 0, controller_path);
>  	}
> =20
>  	return err;
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 38c8bc8..8570e9d 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -1316,7 +1316,11 @@ Print details of one or more md devices.
>  .TP
>  .BR \-\-detail\-platform
>  Print details of the platform's RAID capabilities (firmware / hardware
> -topology) for a given metadata format.
> +topology) for a given metadata format. If used without argument, mdadm
> +will scan all controllers looking for their capabilities. Otherwise, mda=
dm
> +will only look at the controller specified by the argument in form of an
> +absolute filepath or a link, e.g.
> +.IR /sys/devices/pci0000:00/0000:00:1f.2 .
> =20
>  .TP
>  .BR \-Y ", " \-\-export
> diff --git a/mdadm.c b/mdadm.c
> index 3ee7ddb..7bbf6ba 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -324,8 +324,15 @@ int main(int argc, char *argv[])
>  			continue;
>  		}
>  		if (opt =3D=3D 1) {
> -		        /* an undecorated option - must be a device name.
> +			/* an undecorated option - must be a device name.
>  			 */
> +
> +			if (devs_found > 0 && devmode =3D=3D DetailPlatform) {
> +				pr_err("controller may only be specified once. %s ignored\n",
> +						optarg);
> +				continue;
> +			}
> +
>  			if (devs_found > 0 && mode =3D=3D MANAGE && !devmode) {
>  				pr_err("Must give one of -a/-r/-f"
>  					" for subsequent devices at %s\n", optarg);
> @@ -1344,7 +1351,7 @@ int main(int argc, char *argv[])
>  			}
>  			rv =3D Examine(devlist, &c, ss);
>  		} else if (devmode =3D=3D DetailPlatform) {
> -			rv =3D Detail_Platform(ss ? ss->ss : NULL, ss ? c.scan : 1, c.verbose=
, c.export);
> +			rv =3D Detail_Platform(ss ? ss->ss : NULL, ss ? c.scan : 1, c.verbose=
, c.export, devlist ? devlist->devname : NULL);
>  		} else if (devlist =3D=3D NULL) {
>  			if (devmode =3D=3D 'S' && c.scan)
>  				rv =3D stop_scan(c.verbose);
> diff --git a/mdadm.h b/mdadm.h
> index 6d219f7..432e5b2 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -654,8 +654,8 @@ extern struct superswitch {
>  	void (*export_detail_super)(struct supertype *st);
> =20
>  	/* Optional: platform hardware / firmware details */
> -	int (*detail_platform)(int verbose, int enumerate_only);
> -	int (*export_detail_platform)(int verbose);
> +	int (*detail_platform)(int verbose, int enumerate_only, char *controlle=
r_path);
> +	int (*export_detail_platform)(int verbose, char *controller_path);
> =20
>  	/* Used:
>  	 *   to get uuid to storing in bitmap metadata
> @@ -1122,7 +1122,7 @@ extern int Create(struct supertype *st, char *mddev,
>  		  struct context *c);
> =20
>  extern int Detail(char *dev, struct context *c);
> -extern int Detail_Platform(struct superswitch *ss, int scan, int verbose=
, int export);
> +extern int Detail_Platform(struct superswitch *ss, int scan, int verbose=
, int export, char *controller_path);
>  extern int Query(char *dev);
>  extern int Examine(struct mddev_dev *devlist, struct context *c,
>  		   struct supertype *forcest);
> @@ -1176,6 +1176,7 @@ extern int open_dev_flags(int devnum, int flags);
>  extern int open_dev_excl(int devnum);
>  extern int is_standard(char *dev, int *nump);
>  extern int same_dev(char *one, char *two);
> +extern int compare_paths (char* path1,char* path2);
> =20
>  extern int parse_auto(char *str, char *msg, int config);
>  extern struct mddev_ident *conf_get_ident(char *dev);
> diff --git a/super-intel.c b/super-intel.c
> index fdf441a..64f181e 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -1833,7 +1833,7 @@ static void print_imsm_capability_export(const stru=
ct imsm_orom *orom)
>  	printf("IMSM_MAX_VOLUMES_PER_CONTROLLER=3D%d\n",orom->vphba);
>  }
> =20
> -static int detail_platform_imsm(int verbose, int enumerate_only)
> +static int detail_platform_imsm(int verbose, int enumerate_only, char *c=
ontroller_path)
>  {
>  	/* There are two components to imsm platform support, the ahci SATA
>  	 * controller and the option-rom.  To find the SATA controller we
> @@ -1850,7 +1850,7 @@ static int detail_platform_imsm(int verbose, int en=
umerate_only)
>  	struct sys_dev *list, *hba;
>  	int host_base =3D 0;
>  	int port_count =3D 0;
> -	int result=3D0;
> +	int result=3D1;
> =20
>  	if (enumerate_only) {
>  		if (check_env("IMSM_NO_PLATFORM"))
> @@ -1864,6 +1864,8 @@ static int detail_platform_imsm(int verbose, int en=
umerate_only)
>  				result =3D 2;
>  				break;
>  			}
> +			else
> +				result =3D 0;
>  		}
>  		free_sys_dev(&list);
>  		return result;
> @@ -1880,34 +1882,38 @@ static int detail_platform_imsm(int verbose, int =
enumerate_only)
>  		print_found_intel_controllers(list);
> =20
>  	for (hba =3D list; hba; hba =3D hba->next) {
> +		if (controller_path && (compare_paths(hba->path,controller_path) !=3D =
0))
> +			continue;
>  		orom =3D find_imsm_capability(hba->type);
>  		if (!orom)
>  			pr_err("imsm capabilities not found for controller: %s (type %s)\n",
>  				hba->path, get_sys_dev_type(hba->type));
> -		else
> +		else {
> +			result =3D 0;
>  			print_imsm_capability(orom);
> -	}
> -
> -	for (hba =3D list; hba; hba =3D hba->next) {
> -		printf(" I/O Controller : %s (%s)\n",
> -			hba->path, get_sys_dev_type(hba->type));
> -
> -		if (hba->type =3D=3D SYS_DEV_SATA) {
> -			host_base =3D ahci_get_port_count(hba->path, &port_count);
> -			if (ahci_enumerate_ports(hba->path, port_count, host_base, verbose)) {
> -				if (verbose > 0)
> -					pr_err("failed to enumerate "
> -						"ports on SATA controller at %s.", hba->pci_id);
> -				result |=3D 2;
> +			printf(" I/O Controller : %s (%s)\n",
> +				hba->path, get_sys_dev_type(hba->type));
> +			if (hba->type =3D=3D SYS_DEV_SATA) {
> +				host_base =3D ahci_get_port_count(hba->path, &port_count);
> +				if (ahci_enumerate_ports(hba->path, port_count, host_base, verbose))=
 {
> +					if (verbose > 0)
> +						pr_err("failed to enumerate "
> +							"ports on SATA controller at %s.\n", hba->pci_id);
> +					result |=3D 2;
> +				}
>  			}
>  		}
>  	}
> =20
> +	if (controller_path && result =3D=3D 1)
> +		pr_err("no active Intel(R) RAID "
> +				"controller found under %s\n",controller_path);
> +
>  	free_sys_dev(&list);
>  	return result;
>  }
> =20
> -static int export_detail_platform_imsm(int verbose)
> +static int export_detail_platform_imsm(int verbose, char *controller_pat=
h)
>  {
>  	const struct imsm_orom *orom;
>  	struct sys_dev *list, *hba;
> @@ -1923,6 +1929,8 @@ static int export_detail_platform_imsm(int verbose)
>  	}
> =20
>  	for (hba =3D list; hba; hba =3D hba->next) {
> +		if (controller_path && (compare_paths(hba->path,controller_path) !=3D =
0))
> +			continue;
>  		orom =3D find_imsm_capability(hba->type);
>  		if (!orom) {
>  			if (verbose > 0)
> @@ -1934,9 +1942,6 @@ static int export_detail_platform_imsm(int verbose)
>  		}
>  	}
> =20
> -	if (result =3D=3D 1 && verbose > 0)
> -		pr_err("IMSM_DETAIL_PLATFORM_ERROR=3DNO_IMSM_CAPABLE_DEVICES\n");
> -
>  	return result;
>  }
> =20
> diff --git a/util.c b/util.c
> index c63a232..4a7a1d1 100644
> --- a/util.c
> +++ b/util.c
> @@ -1808,3 +1808,24 @@ struct mdinfo *container_choose_spares(struct supe=
rtype *st,
>  	}
>  	return disks;
>  }
> +
> +/* Checks if paths point to the same device
> + * Returns 0 if they do.
> + * Returns 1 if they don't.
> + * Returns -1 if something went wrong,
> + * e.g. paths are empty or the files
> + * they point to don't exist */
> +int compare_paths (char* path1, char* path2)
> +{
> +	struct stat st1,st2;
> +
> +	if (path1 =3D=3D NULL || path2 =3D=3D NULL)
> +		return -1;
> +	if (stat(path1,&st1) !=3D 0)
> +		return -1;
> +	if (stat(path2,&st2) !=3D 0)
> +		return -1;
> +	if ((st1.st_ino =3D=3D st2.st_ino) && (st1.st_dev =3D=3D st2.st_dev))
> +		return 0;
> +	return 1;
> +}


Applied, thanks.

NeilBrown

--Sig_/A408dOWwX4NQXoVXfgJ4zaX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUG0t/jnsnt1WYoG5AQL8yQ/+MW8awoH3BTBfvYBlpNbHXl64FzwdZWHl
iv0HRUw8xtRS1ucAJa4wEPzrFwjnA3rkdVFH6JClPv4GPFB42hoQnerpe5ypT8oo
0wIqGxoF4DsKDiJ3HaNMHh0GLiul2BwFmkH0e5qgJZH4XIUqRp+mxw8eG/7jV4fr
aSTF4GdZ7OGjA2bl12VsgIx7M4TQkgfM83V7m61pY23XaPZyPwUvld04u9Frs27V
WRh8hatpFTeeFNO2BTJq2pe+NB9FkLdpUWYchoQ2fPu4NDfmJdOfUISwAlxbP0EE
MkTR5asjjbYqRQaNRG7ZhmtBmnBmcfP4HsBZWVnjtujZhxu1lrJFB/0cSHMpvQwy
qNDXsfsTRE3zUzPj/SXvi99I3+331RT0rnH11JB8/WcpmzgBL/zcrTUTTl+aDthc
rBrRKerMfJXflZbjP+PEPm3uIuwityFQ24CaD9pCyiM5Vibcg9ox5XPXEjApbIRR
i/+8t32Kf6zjjwP/dxxFd6eVAsyYizsbvF50/PzqZm+HLzIwgY5QLhJHSff5MebB
j5dSRu1PF5AwDOeW3QvydcfegSVYDckngpGRotv2FaEMM721cBr6oZhQQXltens8
ShNGKllZxoBbHvRpnLRl/zWLx0gnumK3rY2mSA6WZFEretDxxju02xwiEx2RGhx6
qoima6KXDaU=
=B+Uq
-----END PGP SIGNATURE-----

--Sig_/A408dOWwX4NQXoVXfgJ4zaX--
