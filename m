From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/8] Add continue option to grow command
Date: Mon, 3 Oct 2011 09:27:38 +1100
Message-ID: <20111003092738.43609fa8@notabene.brown>
References: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
	<20110927120448.4890.78828.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JJ=gP9jrI=JyggHnF4AEn+I"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110927120448.4890.78828.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/JJ=gP9jrI=JyggHnF4AEn+I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2011 14:04:48 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> To allow for reshape continuation '--continue' option is added
> to grow command.
> Function that will be executed in grow-continue case doesn't require
> information about reshape geometry. All required information are read
> from metadata.
> For external metadata reshape can be run for monitored array/container
> only. In case when array/container is not monitored run mdmon for it.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Applied this just some minor fixes,

Thanks,
NeilBrown


> ---
>=20
>  Grow.c   |  132 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  ReadMe.c |    1=20
>  mdadm.c  |   14 ++++++-
>  mdadm.h  |    6 +++
>  4 files changed, 151 insertions(+), 2 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 4509488..768fc86 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3636,6 +3636,138 @@ int Grow_restart(struct supertype *st, struct mdi=
nfo *info, int *fdlist, int cnt
>  	return 1;
>  }
> =20
> +int Grow_continue_command(char *devname, int fd,
> +			  char *backup_file, int verbose)
> +{
> +	int ret_val =3D 0;
> +	struct supertype *st =3D NULL;
> +	struct mdinfo *content =3D NULL;
> +	struct mdinfo array;
> +	char *subarray =3D NULL;
> +	struct mdinfo *cc =3D NULL;
> +	struct mdstat_ent *mdstat =3D NULL;
> +	char buf[40];
> +	int cfd =3D -1;
> +	int fd2 =3D -1;
> +
> +	dprintf("Grow continue from command line called for %s\n",
> +		devname);
> +
> +	st =3D super_by_fd(fd, &subarray);
> +	if (!st || !st->ss) {
> +		fprintf(stderr,
> +			Name ": Unable to determine metadata format for %s\n",
> +			devname);
> +		return 1;
> +	}
> +	dprintf("Grow continue is run for ");
> +	if (st->ss->external =3D=3D 0) {
> +		dprintf("native array (%s)\n", devname);
> +		if (ioctl(fd, GET_ARRAY_INFO, &array) < 0) {
> +			fprintf(stderr, Name ": %s is not an active md array -"
> +				" aborting\n", devname);
> +			ret_val =3D 1;
> +			goto Grow_continue_command_exit;
> +		}
> +		content =3D &array;
> +		sysfs_init(content, fd, st->devnum);
> +	} else {
> +		int container_dev;
> +
> +		if (subarray) {
> +			dprintf("subarray (%s)\n", subarray);
> +			container_dev =3D st->container_dev;
> +			cfd =3D open_dev_excl(st->container_dev);
> +		} else {
> +			container_dev =3D st->devnum;
> +			close(fd);
> +			cfd =3D open_dev_excl(st->devnum);
> +			dprintf("container (%i)\n", container_dev);
> +			fd =3D cfd;
> +		}
> +		if (cfd < 0) {
> +			fprintf(stderr, Name ": Unable to open container "
> +				"for %s\n", devname);
> +			ret_val =3D 1;
> +			goto Grow_continue_command_exit;
> +		}
> +		fmt_devname(buf, container_dev);
> +
> +		/* find in container array under reshape
> +		 */
> +		ret_val =3D st->ss->load_container(st, cfd, NULL);
> +		if (ret_val) {
> +			fprintf(stderr,
> +				Name ": Cannot read superblock for %s\n",
> +				devname);
> +			ret_val =3D 1;
> +			goto Grow_continue_command_exit;
> +		}
> +
> +		cc =3D st->ss->container_content(st, NULL);
> +		for (content =3D cc; content ; content =3D content->next) {
> +			char *array;
> +
> +			if (content->reshape_active =3D=3D 0)
> +				continue;
> +
> +			array =3D strchr(content->text_version+1, '/')+1;
> +			mdstat =3D mdstat_by_subdev(array, container_dev);
> +			if (!mdstat)
> +				continue;
> +			break;
> +		}
> +		if (!content) {
> +			fprintf(stderr,
> +				Name ": Unable to determine reshaped "
> +				"array for %s\n", devname);
> +			ret_val =3D 1;
> +			goto Grow_continue_command_exit;
> +		}
> +		fd2 =3D open_dev(mdstat->devnum);
> +		if (fd2 < 0) {
> +			fprintf(stderr, Name ": cannot open (md%i)\n",
> +				mdstat->devnum);
> +			ret_val =3D 1;
> +			goto Grow_continue_command_exit;
> +		}
> +
> +		sysfs_init(content, fd2, mdstat->devnum);
> +
> +		/* start mdmon in case it is not run
> +		 */
> +		if (!mdmon_running(container_dev))
> +			start_mdmon(container_dev);
> +		ping_monitor(buf);
> +
> +		if (mdmon_running(container_dev))
> +			st->update_tail =3D &st->updates;
> +		else {
> +			fprintf(stderr, Name ":  No mdmon found. "
> +				"Grow cannot continue.\n");
> +			ret_val =3D 1;
> +			goto Grow_continue_command_exit;
> +		}
> +	}
> +
> +	/* continue reshape
> +	 */
> +	ret_val =3D Grow_continue(fd, st, content, backup_file,
> +				FREEZE_RESHAPE_NONE);
> +
> +Grow_continue_command_exit:
> +	if (fd2 > -1)
> +		close(fd2);
> +	if (cfd > -1)
> +		close(cfd);
> +	st->ss->free_super(st);
> +	free_mdstat(mdstat);
> +	sysfs_free(cc);
> +	free(subarray);
> +
> +	return ret_val;
> +}
> +
>  int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
>  		  char *backup_file, int freeze_reshape)
>  {
> diff --git a/ReadMe.c b/ReadMe.c
> index 89dd7af..25426d3 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -191,6 +191,7 @@ struct option long_options[] =3D {
>      {"backup-file", 1,0, BackupFile},
>      {"invalid-backup",0,0,InvalidBackup},
>      {"array-size", 1, 0, 'Z'},
> +    {"continue", 0, 0, Continue},
> =20
>      /* For Incremental */
>      {"rebuild-map", 0, 0, RebuildMapOpt},
> diff --git a/mdadm.c b/mdadm.c
> index 18ca2ee..9fe09ea 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -74,6 +74,7 @@ int main(int argc, char *argv[])
>  	int export =3D 0;
>  	int assume_clean =3D 0;
>  	char *symlinks =3D NULL;
> +	int grow_continue =3D FREEZE_RESHAPE_NONE;
>  	/* autof indicates whether and how to create device node.
>  	 * bottom 3 bits are style.  Rest (when shifted) are number of parts
>  	 * 0  - unset
> @@ -995,7 +996,11 @@ int main(int argc, char *argv[])
>  			}
>  			backup_file =3D optarg;
>  			continue;
> -
> +		case O(GROW, Continue):
> +			/* Continuer broken grow
> +			 */
> +			grow_continue =3D FREEZE_RESHAPE_CONTINUE;
> +			continue;
>  		case O(ASSEMBLE, InvalidBackup):
>  			/* Acknowledge that the backupfile is invalid, but ask
>  			 * to continue anyway
> @@ -1649,7 +1654,12 @@ int main(int argc, char *argv[])
>  				delay =3D DEFAULT_BITMAP_DELAY;
>  			rv =3D Grow_addbitmap(devlist->devname, mdfd, bitmap_file,
>  					    bitmap_chunk, delay, write_behind, force);
> -		} else if (size >=3D 0 || raiddisks !=3D 0 || layout_str !=3D NULL
> +		} else if (grow_continue) {
> +			rv =3D Grow_continue_command(devlist->devname,
> +						   mdfd, backup_file,
> +						   verbose);
> +			break;
> +		} else	if (size >=3D 0 || raiddisks !=3D 0 || layout_str !=3D NULL
>  			   || chunk !=3D 0 || level !=3D UnSet) {
>  			rv =3D Grow_reshape(devlist->devname, mdfd, quiet, backup_file,
>  					  size, level, layout_str, chunk, raiddisks,
> diff --git a/mdadm.h b/mdadm.h
> index 073deb9..8f3e786 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -314,6 +314,7 @@ enum special_options {
>  	InvalidBackup,
>  	UdevRules,
>  	FreezeReshape,
> +	Continue,
>  };
> =20
>  /* structures read from config file */
> @@ -1037,9 +1038,11 @@ extern int Grow_continue(int mdfd, struct supertyp=
e *st,
>  /* define stages for freeze assembly feature
>   * FREEZE_RESHAPE_NONE     : disabled
>   * FREEZE_RESHAPE_ASSEMBLY : assemby phase
> + * FREEZE_RESHAPE_CONTINUE : grow continue phase
>   */
>  #define FREEZE_RESHAPE_NONE		0
>  #define FREEZE_RESHAPE_ASSEMBLY		1
> +#define FREEZE_RESHAPE_CONTINUE		2
> =20
>  extern int restore_backup(struct supertype *st,
>  			  struct mdinfo *content,
> @@ -1047,6 +1050,8 @@ extern int restore_backup(struct supertype *st,
>  			  int spares,
>  			  char *backup_file,
>  			  int verbose);
> +extern int Grow_continue_command(char *devname, int fd,
> +				 char *backup_file, int verbose);
> =20
>  extern int Assemble(struct supertype *st, char *mddev,
>  		    struct mddev_ident *ident,
> @@ -1185,6 +1190,7 @@ extern char *human_size(long long bytes);
>  extern char *human_size_brief(long long bytes);
>  extern void print_r10_layout(int layout);
> =20
> +
>  #define NoMdDev (1<<23)
>  extern int find_free_devnum(int use_partitions);
> =20


--Sig_/JJ=gP9jrI=JyggHnF4AEn+I
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOiOVaG5fc6gV+Wb0RAqq6AKC42kvVLzXGVy9ptIVbqU8eSKEHtwCg2rsZ
COzQviF+w/5+zngRrCKVEog=
=u30Y
-----END PGP SIGNATURE-----

--Sig_/JJ=gP9jrI=JyggHnF4AEn+I--
