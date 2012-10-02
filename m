From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/6] imsm: Add --controller-path option for
 --detail-platform.
Date: Tue, 2 Oct 2012 16:36:30 +1000
Message-ID: <20121002163630.1e2f7713@notabene.brown>
References: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
	<20120926114250.328.89530.stgit@gklab-128-174.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CrhnKVLxtISfrs4iGzog1iZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120926114250.328.89530.stgit@gklab-128-174.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

--Sig_/CrhnKVLxtISfrs4iGzog1iZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Sep 2012 13:42:50 +0200 Maciej Naruszewicz
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
> $ mdadm --detail-platform --controller-path=3D/sys/devices/pci0000:00/000=
0:00:1f.2
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
> $ mdadm --detail-platform --controller-path=3D/sys/devices/pci0000:00/000=
0:00:1f.2 --export
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
> $ mdadm --detail-platform --controller-path=3D/sys/devices/pci0000:00/000=
0:00:1f.0 # This isn't an IMSM-capable controller
> mdadm: no active Intel(R) RAID controller found under /sys/devices/pci000=
0:00/0000:00:1f.0

hi,
 I think this functionality is good.  I think the implementation is not.

1/ Don't have a "--controller-path" option, just require any name
   given as a bare argument to the controller path - and probably require
   there is either 0 or 1.
   So:
      mdadm --detail-platform  /sys/devices/pci0000:00/0000:00:1f.0

   is the correct usage.

2/ You really don't need to=20
     if (asprintf(&c.controller_path, "%s", optarg) <=3D 0) {

   just use 'optarg' directly.

3/ Don't use 'realpath' and 'strcmp'.  To compare two paths, use "stat" and
    compare st_dev and st_ino.

So: not applied.

Thanks,
NeilBrown



>=20
> Signed-off-by: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
> ---
>  Create.c      |    2 +-
>  Detail.c      |   10 +++++-----
>  ReadMe.c      |    2 ++
>  mdadm.8.in    |    8 ++++++++
>  mdadm.c       |   32 +++++++++++++++++++++++++++++++-
>  mdadm.h       |    8 +++++---
>  super-intel.c |   45 +++++++++++++++++++++++++--------------------
>  7 files changed, 77 insertions(+), 30 deletions(-)
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
> diff --git a/ReadMe.c b/ReadMe.c
> index 346f08c..0c9c80b 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -159,6 +159,7 @@ struct option long_options[] =3D {
>      {"sparc2.2",  0, 0, Sparc22},
>      {"test",      0, 0, 't'},
>      {"prefer",    1, 0, Prefer},
> +    {"controller-path",1, 0, ControllerPath},
> =20
>      /* For Follow/monitor */
>      {"mail",      1, 0, EMail},
> @@ -240,6 +241,7 @@ char OptionHelp[] =3D
>  "  --brief       -b   : Be less verbose, more brief\n"
>  "  --export      -Y   : With --detail, --detail-platform or --examine us=
e\n"
>  "                       key=3Dvalue format for easy import into environm=
ent\n"
> +"  --controller-path  : Specify controller for --detail-platform\n"
>  "  --force       -f   : Override normal checks and be more forceful\n"
>  "\n"
>  "  --assemble    -A   : Assemble an array\n"
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 38c8bc8..8792e54 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -1329,6 +1329,14 @@ output will be formatted as
>  pairs for easy import into the environment.
> =20
>  .TP
> +.BR \-\-controller\-path
> +When used with
> +.BR \-\-detail\-platform ,
> +mdadm will only print information about the specified controller. The
> +controller should be given in form of an absolute filepath, e.g.
> +.B \-\-controller\-path /sys/devices/pci0000:00/0000:00:1f.0 .
> +
> +.TP
>  .BR \-E ", " \-\-examine
>  Print contents of the metadata stored on the named device(s).
>  Note the contrast between
> diff --git a/mdadm.c b/mdadm.c
> index 3ee7ddb..d313b76 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -93,6 +93,7 @@ int main(int argc, char *argv[])
>  	int rebuild_map =3D 0;
>  	char *remove_path =3D NULL;
>  	char *udev_filename =3D NULL;
> +	char *actual_controller_path;
> =20
>  	int print_help =3D 0;
>  	FILE *outf;
> @@ -151,6 +152,35 @@ int main(int argc, char *argv[])
>  		case 'Y': c.export++;
>  			continue;
> =20
> +		case ControllerPath:
> +			if (c.controller_path)
> +				free(c.controller_path);
> +			if (asprintf(&c.controller_path, "%s", optarg) <=3D 0) {
> +				pr_err("Empty or wrong controller path, \'%s\' ignored.\n",
> +					c.controller_path);
> +				c.controller_path =3D NULL;
> +			}
> +			else {
> +				struct stat st;
> +				if (stat(c.controller_path, &st) !=3D 0) {
> +					pr_err("Specified controller path %s doesn't exist.\n",
> +						c.controller_path);
> +					exit(2);
> +				}
> +				else {
> +					actual_controller_path =3D realpath(c.controller_path,NULL);
> +					if (actual_controller_path) {
> +						if(asprintf(&c.controller_path, "%s", actual_controller_path) > 0)
> +							free(actual_controller_path);
> +						else
> +							free(c.controller_path);
> +					}
> +					else
> +						free(c.controller_path);
> +				}
> +			}
> +			continue;
> +
>  		case HomeHost:
>  			if (strcasecmp(optarg, "<ignore>") =3D=3D 0)
>  				c.require_homehost =3D 0;
> @@ -1344,7 +1374,7 @@ int main(int argc, char *argv[])
>  			}
>  			rv =3D Examine(devlist, &c, ss);
>  		} else if (devmode =3D=3D DetailPlatform) {
> -			rv =3D Detail_Platform(ss ? ss->ss : NULL, ss ? c.scan : 1, c.verbose=
, c.export);
> +			rv =3D Detail_Platform(ss ? ss->ss : NULL, ss ? c.scan : 1, c.verbose=
, c.export, c.controller_path);
>  		} else if (devlist =3D=3D NULL) {
>  			if (devmode =3D=3D 'S' && c.scan)
>  				rv =3D stop_scan(c.verbose);
> diff --git a/mdadm.h b/mdadm.h
> index 6d219f7..e27275b 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -326,6 +326,7 @@ enum special_options {
>  	OffRootOpt,
>  	Prefer,
>  	KillOpt,
> +	ControllerPath,
>  };
> =20
>  /* structures read from config file */
> @@ -394,6 +395,7 @@ struct context {
>  	int	freeze_reshape;
>  	char	*backup_file;
>  	int	invalid_backup;
> +	char	*controller_path;
>  };
> =20
>  struct shape {
> @@ -654,8 +656,8 @@ extern struct superswitch {
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
> @@ -1122,7 +1124,7 @@ extern int Create(struct supertype *st, char *mddev,
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
> diff --git a/super-intel.c b/super-intel.c
> index fdf441a..cedc976 100644
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
> +		if (controller_path !=3D NULL && ( strcmp(hba->path,controller_path) !=
=3D 0 ))
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
> +	if (controller_path !=3D NULL && result =3D=3D 1)
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
> +		if (controller_path !=3D NULL && ( strcmp(hba->path,controller_path) !=
=3D 0 ))
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
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/CrhnKVLxtISfrs4iGzog1iZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGqLbjnsnt1WYoG5AQKT/g//Y5kT5dr3PYymqZHIgW9F7Xj7sTN1h8Ad
fIpvQGh4qsm0+n7JDdhE9L/m0opnouU+/3VoXG/98lwhnp8jQnhwoJ54h9g1N43E
UQGbgT7lRwJQa+lTPdKFBYuRlqYiXV1xPJuy141K/RbyA0u3z9tMPZNvE/Vu/rVc
slURMlHQiUdtGt0dD1Z4+n8NQuEt9hTE5Ty7bGYLX0PJElrV8Fn58r6BAkk7RJhg
fNc/t4QtQJ6LDT4iQ0IdHHZckAS9Zg2OElY7QfPVm9rZtH1ZO5ekdtOI4VawoIN1
ET9b2iHm4B7IyAffacwuJb0Hj5NhvXeMEFsYYLnOQfUXtSNPBlg9BqPsva1GEeS8
Cka8VS1TfDZ2Mct+aRpKNYMnq0XVjhIcOX9MezkXCM1QH3EgLHzN7eMclchij/QZ
H51Axorg1YKdpmx4hfypbFd6rppbnY1mWXStLamTK01aFg/i4NbT4W0NUv1Llbxg
mjxQmUryUsZMJDmJPlWDV91ByCi9LHLYl7rh5D1UOR4Jzmdsox4pniUfWOW88a3a
qqkBA9tHi/qrkAXXmUMdvygA1jOenJC3HkRsTrHCHN70aABxImRhEEskECNU0Fqs
Xd4YjC8DCJIv7HOHRQ75mqcQAbmA8BnyMY2qIKeRAqv6XbT94FsSua6cbd6xDOKc
gPI+Rd9Jcpk=
=fvz8
-----END PGP SIGNATURE-----

--Sig_/CrhnKVLxtISfrs4iGzog1iZ--
