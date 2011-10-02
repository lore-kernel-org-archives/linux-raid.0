From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/8] Do not continue reshape during initrd phase
Date: Mon, 3 Oct 2011 09:19:20 +1100
Message-ID: <20111003091920.79347dbf@notabene.brown>
References: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
	<20110927120439.4890.75281.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/X5Ivlbf+hywsZeaVo.MMnJ7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110927120439.4890.75281.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/X5Ivlbf+hywsZeaVo.MMnJ7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2011 14:04:39 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> During initrd phase continuing reshape will cause file system context
> lost. This blocks ability to control reshape using checkpoints.
>=20
> To avoid this, during initrd phase assemble has to be executed with
> '--freeze-reshape' option. This causes that mdadm restores reshape
> critical section only.
>=20
> Reshape can be continued later after system full boot.

Thanks.
I've applied this with a few small changes:

- The constants FREEZE_RESHAPE_NONE and FREEZE_RESHAPE_ASSEMBLY are not
  necessary and don't help readability.  Just treat "freeze_reshape" as a
  boolean, either true or false.

- The change to share_reshape as unnecessary so I removed it.

Thanks,
NeilBrown


>
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Assemble.c    |   12 +++++++-----
>  Grow.c        |   52 ++++++++++++++++++++++++++++++++++++++--------------
>  Incremental.c |   16 ++++++++++------
>  ReadMe.c      |    1 +
>  mdadm.c       |   33 ++++++++++++++++++++++++---------
>  mdadm.h       |   18 ++++++++++++++----
>  6 files changed, 94 insertions(+), 38 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index c6aad20..afca38e 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -138,7 +138,7 @@ int Assemble(struct supertype *st, char *mddev,
>  	     char *backup_file, int invalid_backup,
>  	     int readonly, int runstop,
>  	     char *update, char *homehost, int require_homehost,
> -	     int verbose, int force)
> +	     int verbose, int force, int freeze_reshape)
>  {
>  	/*
>  	 * The task of Assemble is to find a collection of
> @@ -697,7 +697,7 @@ int Assemble(struct supertype *st, char *mddev,
>  		int err;
>  		err =3D assemble_container_content(st, mdfd, content, runstop,
>  						 chosen_name, verbose,
> -						 backup_file);
> +						 backup_file, freeze_reshape);
>  		close(mdfd);
>  		return err;
>  	}
> @@ -1344,7 +1344,8 @@ int Assemble(struct supertype *st, char *mddev,
>  #ifndef MDASSEMBLE
>  			if (content->reshape_active &&
>  			    content->delta_disks <=3D 0)
> -				rv =3D Grow_continue(mdfd, st, content, backup_file);
> +				rv =3D Grow_continue(mdfd, st, content,
> +						   backup_file, freeze_reshape);
>  			else
>  #endif
>  				rv =3D ioctl(mdfd, RUN_ARRAY, NULL);
> @@ -1511,7 +1512,7 @@ int Assemble(struct supertype *st, char *mddev,
>  int assemble_container_content(struct supertype *st, int mdfd,
>  			       struct mdinfo *content, int runstop,
>  			       char *chosen_name, int verbose,
> -			       char *backup_file)
> +			       char *backup_file, int freeze_reshape)
>  {
>  	struct mdinfo *dev, *sra;
>  	int working =3D 0, preexist =3D 0;
> @@ -1560,7 +1561,8 @@ int assemble_container_content(struct supertype *st=
, int mdfd,
>  					   spare, backup_file, verbose) =3D=3D 1)
>  				return 1;
> =20
> -			err =3D Grow_continue(mdfd, st, content, backup_file);
> +			err =3D Grow_continue(mdfd, st, content, backup_file,
> +					    freeze_reshape);
>  		} else switch(content->array.level) {
>  		case LEVEL_LINEAR:
>  		case LEVEL_MULTIPATH:
> diff --git a/Grow.c b/Grow.c
> index 4a25165..4509488 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -696,10 +696,16 @@ static int subarray_set_num(char *container, struct=
 mdinfo *sra, char *name, int
>  	return rc;
>  }
> =20
> -int start_reshape(struct mdinfo *sra, int already_running)
> +int start_reshape(struct mdinfo *sra, int already_running, int freeze_re=
shape)
>  {
>  	int err;
> -	sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
> +
> +	/* do not block array as we not continue reshape this time
> +	 */
> +	if (freeze_reshape =3D=3D FREEZE_RESHAPE_NONE)
> +		sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
> +	else
> +		sysfs_set_num(sra, NULL, "suspend_lo", 0);
>  	err =3D sysfs_set_num(sra, NULL, "suspend_hi", 0);
>  	err =3D err ?: sysfs_set_num(sra, NULL, "suspend_lo", 0);
>  	if (!already_running)
> @@ -1344,13 +1350,13 @@ static int reshape_array(char *container, int fd,=
 char *devname,
>  			 struct supertype *st, struct mdinfo *info,
>  			 int force, struct mddev_dev *devlist,
>  			 char *backup_file, int quiet, int forked,
> -			 int restart);
> +			 int restart, int freeze_reshape);
>  static int reshape_container(char *container, char *devname,
>  			     struct supertype *st,=20
>  			     struct mdinfo *info,
>  			     int force,
>  			     char *backup_file,
> -			     int quiet, int restart);
> +			     int quiet, int restart, int freeze_reshape);
> =20
>  int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
>  		 long long size,
> @@ -1761,7 +1767,7 @@ int Grow_reshape(char *devname, int fd, int quiet, =
char *backup_file,
>  		 * performed at the level of the container
>  		 */
>  		rv =3D reshape_container(container, devname, st, &info,
> -				       force, backup_file, quiet, 0);
> +				       force, backup_file, quiet, 0, 0);
>  		frozen =3D 0;
>  	} else {
>  		/* get spare devices from external metadata
> @@ -1789,7 +1795,7 @@ int Grow_reshape(char *devname, int fd, int quiet, =
char *backup_file,
>  		}
>  		sync_metadata(st);
>  		rv =3D reshape_array(container, fd, devname, st, &info, force,
> -				   devlist, backup_file, quiet, 0, 0);
> +				   devlist, backup_file, quiet, 0, 0, 0);
>  		frozen =3D 0;
>  	}
>  release:
> @@ -1802,7 +1808,7 @@ static int reshape_array(char *container, int fd, c=
har *devname,
>  			 struct supertype *st, struct mdinfo *info,
>  			 int force, struct mddev_dev *devlist,
>  			 char *backup_file, int quiet, int forked,
> -			 int restart)
> +			 int restart, int freeze_reshape)
>  {
>  	struct reshape reshape;
>  	int spares_needed;
> @@ -2241,7 +2247,7 @@ started:
>  		}
>  	}
> =20
> -	err =3D start_reshape(sra, restart);
> +	err =3D start_reshape(sra, restart, freeze_reshape);
>  	if (err) {
>  		fprintf(stderr,=20
>  			Name ": Cannot %s reshape for %s\n",
> @@ -2251,6 +2257,15 @@ started:
>  	}
>  	if (restart)
>  		sysfs_set_str(sra, NULL, "array_state", "active");
> +	if (freeze_reshape =3D=3D FREEZE_RESHAPE_ASSEMBLY) {
> +		free(fdlist);
> +		free(offsets);
> +		sysfs_free(sra);
> +		fprintf(stderr, Name ": Reshape has to be continued from"
> +			" location %llu when root fileststem will be mounted\n",
> +			sra->reshape_progress);
> +		return 1;
> +	}
> =20
>  	/* Now we just need to kick off the reshape and watch, while
>  	 * handling backups of the data...
> @@ -2389,7 +2404,7 @@ int reshape_container(char *container, char *devnam=
e,
>  		      struct mdinfo *info,
>  		      int force,
>  		      char *backup_file,
> -		      int quiet, int restart)
> +		      int quiet, int restart, int freeze_reshape)
>  {
>  	struct mdinfo *cc =3D NULL;
>  	int rv =3D restart;
> @@ -2418,7 +2433,9 @@ int reshape_container(char *container, char *devnam=
e,
>  		unfreeze(st);
>  		return 1;
>  	default: /* parent */
> -		printf(Name ": multi-array reshape continues in background\n");
> +		if (freeze_reshape =3D=3D FREEZE_RESHAPE_NONE)
> +			printf(Name ": multi-array reshape continues"
> +			       "in background\n");
>  		return 0;
>  	case 0: /* child */
>  		break;
> @@ -2473,8 +2490,15 @@ int reshape_container(char *container, char *devna=
me,
> =20
>  		rv =3D reshape_array(container, fd, adev, st,
>  				   content, force, NULL,
> -				   backup_file, quiet, 1, restart);
> +				   backup_file, quiet, 1, restart,
> +				   freeze_reshape);
>  		close(fd);
> +
> +		if (freeze_reshape) {
> +			sysfs_free(cc);
> +			exit(0);
> +		}
> +
>  		restart =3D 0;
>  		if (rv)
>  			break;
> @@ -3613,7 +3637,7 @@ int Grow_restart(struct supertype *st, struct mdinf=
o *info, int *fdlist, int cnt
>  }
> =20
>  int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
> -		  char *backup_file)
> +		  char *backup_file, int freeze_reshape)
>  {
>  	char buf[40];
>  	char *container =3D NULL;
> @@ -3640,9 +3664,9 @@ int Grow_continue(int mdfd, struct supertype *st, s=
truct mdinfo *info,
>  			close(cfd);
>  			return reshape_container(container, NULL,
>  						 st, info, 0, backup_file,
> -						 0, 1);
> +						 0, 1, freeze_reshape);
>  		}
>  	}
>  	return reshape_array(container, mdfd, "array", st, info, 1,
> -			     NULL, backup_file, 0, 0, 1);
> +			     NULL, backup_file, 0, 0, 1, freeze_reshape);
>  }
> diff --git a/Incremental.c b/Incremental.c
> index 791ad85..571d45d 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -44,7 +44,8 @@ static int try_spare(char *devname, int *dfdp, struct d=
ev_policy *pol,
> =20
>  static int Incremental_container(struct supertype *st, char *devname,
>  				 char *homehost,
> -				 int verbose, int runstop, int autof);
> +				 int verbose, int runstop, int autof,
> +				 int freeze_reshape);
> =20
>  static struct mddev_ident *search_mdstat(struct supertype *st,
>  					   struct mdinfo *info,
> @@ -53,7 +54,7 @@ static struct mddev_ident *search_mdstat(struct superty=
pe *st,
> =20
>  int Incremental(char *devname, int verbose, int runstop,
>  		struct supertype *st, char *homehost, int require_homehost,
> -		int autof)
> +		int autof, int freeze_reshape)
>  {
>  	/* Add this device to an array, creating the array if necessary
>  	 * and starting the array if sensible or - if runstop>0 - if possible.
> @@ -140,7 +141,8 @@ int Incremental(char *devname, int verbose, int runst=
op,
>  		close(dfd);
>  		if (!rv && st->ss->container_content)
>  			return Incremental_container(st, devname, homehost,
> -						     verbose, runstop, autof);
> +						     verbose, runstop, autof,
> +						     freeze_reshape);
> =20
>  		fprintf(stderr, Name ": %s is not part of an md array.\n",
>  			devname);
> @@ -450,7 +452,8 @@ int Incremental(char *devname, int verbose, int runst=
op,
>  		close(mdfd);
>  		sysfs_free(sra);
>  		rv =3D Incremental(chosen_name, verbose, runstop,
> -				 NULL, homehost, require_homehost, autof);
> +				 NULL, homehost, require_homehost, autof,
> +				 freeze_reshape);
>  		if (rv =3D=3D 1)
>  			/* Don't fail the whole -I if a subarray didn't
>  			 * have enough devices to start yet
> @@ -1416,7 +1419,7 @@ static char *container2devname(char *devname)
> =20
>  static int Incremental_container(struct supertype *st, char *devname,
>  				 char *homehost, int verbose,
> -				 int runstop, int autof)
> +				 int runstop, int autof, int freeze_reshape)
>  {
>  	/* Collect the contents of this container and for each
>  	 * array, choose a device name and assemble the array.
> @@ -1551,7 +1554,8 @@ static int Incremental_container(struct supertype *=
st, char *devname,
>  		}
> =20
>  		assemble_container_content(st, mdfd, ra, runstop,
> -					   chosen_name, verbose, NULL);
> +					   chosen_name, verbose, NULL,
> +					   freeze_reshape);
>  		close(mdfd);
>  	}
> =20
> diff --git a/ReadMe.c b/ReadMe.c
> index b658841..89dd7af 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -153,6 +153,7 @@ struct option long_options[] =3D {
>      {"scan",      0, 0, 's'},
>      {"force",	  0, 0, Force},
>      {"update",	  1, 0, 'U'},
> +    {"freeze-reshape", 0, 0, FreezeReshape},
> =20
>      /* Management */
>      {"add",       0, 0, Add},
> diff --git a/mdadm.c b/mdadm.c
> index 1533510..18ca2ee 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -112,6 +112,8 @@ int main(int argc, char *argv[])
> =20
>  	int mdfd =3D -1;
> =20
> +	int freeze_reshape =3D FREEZE_RESHAPE_NONE;
> +
>  	srandom(time(0) ^ getpid());
> =20
>  	ident.uuid_set=3D0;
> @@ -612,8 +614,12 @@ int main(int argc, char *argv[])
>  		case O(MANAGE,Force): /* add device which is too large */
>  			force=3D1;
>  			continue;
> -
>  			/* now for the Assemble options */
> +		case O(ASSEMBLE, FreezeReshape):   /* Freeze reshape during
> +						    * initrd phase */
> +		case O(INCREMENTAL, FreezeReshape):
> +			freeze_reshape =3D FREEZE_RESHAPE_ASSEMBLY;
> +			continue;
>  		case O(CREATE,'u'): /* uuid of array */
>  		case O(ASSEMBLE,'u'): /* uuid of array */
>  			if (ident.uuid_set) {
> @@ -1228,14 +1234,16 @@ int main(int argc, char *argv[])
>  					       NULL, backup_file, invalid_backup,
>  					       readonly, runstop, update,
>  					       homehost, require_homehost,
> -					       verbose-quiet, force);
> +					       verbose-quiet, force,
> +					       freeze_reshape);
>  			}
>  		} else if (!scan)
>  			rv =3D Assemble(ss, devlist->devname, &ident,
>  				      devlist->next, backup_file, invalid_backup,
>  				      readonly, runstop, update,
>  				      homehost, require_homehost,
> -				      verbose-quiet, force);
> +				      verbose-quiet, force,
> +				      freeze_reshape);
>  		else if (devs_found>0) {
>  			if (update && devs_found > 1) {
>  				fprintf(stderr, Name ": can only update a single array at a time\n");
> @@ -1259,7 +1267,8 @@ int main(int argc, char *argv[])
>  					       NULL, backup_file, invalid_backup,
>  					       readonly, runstop, update,
>  					       homehost, require_homehost,
> -					       verbose-quiet, force);
> +					       verbose-quiet, force,
> +					       freeze_reshape);
>  			}
>  		} else {
>  			struct mddev_ident *a, *array_list =3D  conf_get_ident(NULL);
> @@ -1300,7 +1309,8 @@ int main(int argc, char *argv[])
>  						     NULL, NULL, 0,
>  						     readonly, runstop, NULL,
>  						     homehost, require_homehost,
> -						     verbose-quiet, force);
> +						     verbose-quiet, force,
> +						     freeze_reshape);
>  					if (r =3D=3D 0) {
>  						a->assembled =3D 1;
>  						successes++;
> @@ -1325,9 +1335,13 @@ int main(int argc, char *argv[])
>  						rv2 =3D Assemble(ss, NULL,
>  							       &ident,
>  							       devlist, NULL, 0,
> -							       readonly, runstop, NULL,
> -							       homehost, require_homehost,
> -							       verbose-quiet, force);
> +							       readonly,
> +							       runstop, NULL,
> +							       homehost,
> +							       require_homehost,
> +							       verbose-quiet,
> +							       force,
> +							       freeze_reshape);
>  						if (rv2=3D=3D0) {
>  							cnt++;
>  							acnt++;
> @@ -1681,7 +1695,8 @@ int main(int argc, char *argv[])
>  		else
>  			rv =3D Incremental(devlist->devname, verbose-quiet,
>  					 runstop, ss, homehost,
> -					 require_homehost, autof);
> +					 require_homehost, autof,
> +					 freeze_reshape);
>  		break;
>  	case AUTODETECT:
>  		autodetect();
> diff --git a/mdadm.h b/mdadm.h
> index 8dd37d9..073deb9 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -313,6 +313,7 @@ enum special_options {
>  	RebuildMapOpt,
>  	InvalidBackup,
>  	UdevRules,
> +	FreezeReshape,
>  };
> =20
>  /* structures read from config file */
> @@ -1030,7 +1031,16 @@ extern int Grow_reshape(char *devname, int fd, int=
 quiet, char *backup_file,
>  extern int Grow_restart(struct supertype *st, struct mdinfo *info,
>  			int *fdlist, int cnt, char *backup_file, int verbose);
>  extern int Grow_continue(int mdfd, struct supertype *st,
> -			 struct mdinfo *info, char *backup_file);
> +			 struct mdinfo *info, char *backup_file,
> +			 int freeze_reshape);
> +
> +/* define stages for freeze assembly feature
> + * FREEZE_RESHAPE_NONE     : disabled
> + * FREEZE_RESHAPE_ASSEMBLY : assemby phase
> + */
> +#define FREEZE_RESHAPE_NONE		0
> +#define FREEZE_RESHAPE_ASSEMBLY		1
> +
>  extern int restore_backup(struct supertype *st,
>  			  struct mdinfo *content,
>  			  int working_disks,
> @@ -1044,7 +1054,7 @@ extern int Assemble(struct supertype *st, char *mdd=
ev,
>  		    char *backup_file, int invalid_backup,
>  		    int readonly, int runstop,
>  		    char *update, char *homehost, int require_homehost,
> -		    int verbose, int force);
> +		    int verbose, int force, int freeze_reshape);
> =20
>  extern int Build(char *mddev, int chunk, int level, int layout,
>  		 int raiddisks, struct mddev_dev *devlist, int assume_clean,
> @@ -1078,7 +1088,7 @@ extern int WaitClean(char *dev, int sock, int verbo=
se);
> =20
>  extern int Incremental(char *devname, int verbose, int runstop,
>  		       struct supertype *st, char *homehost, int require_homehost,
> -		       int autof);
> +		       int autof, int freeze_reshape);
>  extern void RebuildMap(void);
>  extern int IncrementalScan(int verbose);
>  extern int IncrementalRemove(char *devname, char *path, int verbose);
> @@ -1157,7 +1167,7 @@ extern void append_metadata_update(struct supertype=
 *st, void *buf, int len);
>  extern int assemble_container_content(struct supertype *st, int mdfd,
>  				      struct mdinfo *content, int runstop,
>  				      char *chosen_name, int verbose,
> -				      char *backup_file);
> +				      char *backup_file, int freeze_reshape);
>  extern struct mdinfo *container_choose_spares(struct supertype *st,
>  					      unsigned long long min_size,
>  					      struct domainlist *domlist,


--Sig_/X5Ivlbf+hywsZeaVo.MMnJ7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOiONoG5fc6gV+Wb0RAkSzAJ9p7kRhHDEUKBZ8DdWaf5F9ZjtWTACfaaXg
kQKx9xlyAGzcSZ7Cmf0l1bo=
=t7ov
-----END PGP SIGNATURE-----

--Sig_/X5Ivlbf+hywsZeaVo.MMnJ7--
