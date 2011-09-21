From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 04/14] Add continue option to grow command
Date: Wed, 21 Sep 2011 12:22:07 +1000
Message-ID: <20110921122207.0f3e65b3@notabene.brown>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115417.5201.51789.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m1K4vtn5EBo0xcDWQ7da6Hj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115417.5201.51789.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

--Sig_/m1K4vtn5EBo0xcDWQ7da6Hj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Sep 2011 13:54:17 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> To allow for reshape continuation, 'continue' option is added
> to grow command. It is not possible to check, if any existing mdadm
> instance is going to take ownership on blocked md array or it is
> orphaned/interrupted reshape.
> To resolve this problem grow command with continue option,
> is allowed when current mdadm instance is only one in the system.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Checking how many instances of mdadm are running is definitely wrong.
What are you trying to guard against here?

If we do need locking to prevent two processes trying to manage an array at
the same time, I would suggest creating a 'pid' file
- /var/run/mdadm-reshape-mdXXX.pid
or something like that.

NeilBrown


> ---
>=20
>  ReadMe.c |    1 +
>  mdadm.c  |   17 ++++++++++++++++-
>  mdadm.h  |    2 ++
>  util.c   |   37 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 56 insertions(+), 1 deletions(-)
>=20
> diff --git a/ReadMe.c b/ReadMe.c
> index b658841..f0dc0d9 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -190,6 +190,7 @@ struct option long_options[] =3D {
>      {"backup-file", 1,0, BackupFile},
>      {"invalid-backup",0,0,InvalidBackup},
>      {"array-size", 1, 0, 'Z'},
> +    {"continue", 0, 0, Continue},
> =20
>      /* For Incremental */
>      {"rebuild-map", 0, 0, RebuildMapOpt},
> diff --git a/mdadm.c b/mdadm.c
> index 4b817ab..f30534a 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -74,6 +74,7 @@ int main(int argc, char *argv[])
>  	int export =3D 0;
>  	int assume_clean =3D 0;
>  	char *symlinks =3D NULL;
> +	int grow_continue =3D 0;
>  	/* autof indicates whether and how to create device node.
>  	 * bottom 3 bits are style.  Rest (when shifted) are number of parts
>  	 * 0  - unset
> @@ -988,7 +989,21 @@ int main(int argc, char *argv[])
>  			}
>  			backup_file =3D optarg;
>  			continue;
> -
> +		case O(GROW, Continue):
> +			/* Continuer broken grow
> +			 * To be sure that continuation is allowed check
> +			 * if there is only one (current) mdadm instance
> +			 */
> +			grow_continue =3D count_mdadms();
> +			fprintf(stderr, Name ": %i mdadm instance(s) found\n",
> +				grow_continue);
> +			if (grow_continue !=3D 1) {
> +				fprintf(stderr, Name ": Grow continuation "
> +					"requires single mdadm instance "
> +					"running.\n");
> +				exit(2);
> +			}
> +			continue;
>  		case O(ASSEMBLE, InvalidBackup):
>  			/* Acknowledge that the backupfile is invalid, but ask
>  			 * to continue anyway
> diff --git a/mdadm.h b/mdadm.h
> index 9035e67..7e3a618 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -313,6 +313,7 @@ enum special_options {
>  	RebuildMapOpt,
>  	InvalidBackup,
>  	UdevRules,
> +	Continue,
>  };
> =20
>  /* structures read from config file */
> @@ -1162,6 +1163,7 @@ extern char *human_size_brief(long long bytes);
>  extern void print_r10_layout(int layout);
> =20
>  extern int initramfs_is_in_use(void);
> +extern int count_mdadms(void);
>  #define INITRAMFS_IS_IN_USE		1
>  #define INITRAMFS_NOT_USED		0
> =20
> diff --git a/util.c b/util.c
> index 7186f3f..5077c2f 100644
> --- a/util.c
> +++ b/util.c
> @@ -1790,3 +1790,40 @@ int initramfs_is_in_use(void)
> =20
>  	return ret_val;
>  }
> +
> +int count_mdadms(void)
> +{
> +	int ret_val =3D 0;
> +	DIR *dirp;
> +	struct dirent *d_entry;
> +	int fd;
> +
> +	dirp =3D opendir("/proc");
> +	if (!dirp)
> +		return -1;
> +
> +	while ((d_entry =3D readdir(dirp)) !=3D NULL) {
> +		char p[PATH_MAX];
> +
> +		if (!strcmp(d_entry->d_name, ".") ||
> +			!strcmp(d_entry->d_name, "..") ||
> +			!strcmp(d_entry->d_name, "self"))
> +			continue;
> +		errno =3D 0;
> +		fd =3D (int)strtol(d_entry->d_name, NULL, 10);
> +		if (errno)
> +			continue;
> +		sprintf(p, "/proc/%s/cmdline", d_entry->d_name);
> +		fd =3D open(p, O_RDONLY);
> +		if (fd < 0)
> +			continue;
> +		if (read(fd, p, PATH_MAX) > 0) {
> +			if (strcmp(p, "mdadm") =3D=3D 0)
> +				ret_val++;
> +		}
> +		close(fd);
> +	}
> +	closedir(dirp);
> +
> +	return ret_val;
> +}
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/m1K4vtn5EBo0xcDWQ7da6Hj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeUpPG5fc6gV+Wb0RAgncAJ0eHlgvGZ1DNY5nVwh36C4y+a6WGACgv5DU
hwwyTZZH6aByM7b6nMqU54o=
=a/9F
-----END PGP SIGNATURE-----

--Sig_/m1K4vtn5EBo0xcDWQ7da6Hj--
