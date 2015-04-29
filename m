From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 05/10] Add a new clustered disk
Date: Wed, 29 Apr 2015 11:45:32 +1000
Message-ID: <20150429114532.568d58bd@notabene.brown>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
	<1429860641-5839-6-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6=LVv32=RMXrlcG83Gt0kM9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429860641-5839-6-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: gqjiang@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

--Sig_/6=LVv32=RMXrlcG83Gt0kM9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Apr 2015 15:30:36 +0800 gqjiang@suse.com wrote:

> From: Guoqing Jiang <gqjiang@suse.com>
>=20
> A clustered disk is added by the traditional --add sequence.
> However, other nodes need to acknowledge that they can "see"
> the device. This is done by --cluster-confirm:
>=20
> --cluster-confirm Y:/dev/whatever (if disk is found)
> or
> --cluster-confirm Y:missing (if disk is not found)
>=20
> The node initiating the --add, has the disk state tagged with
> MD_DISK_CLUSTER_ADD and the one confirming tag the disk with
> MD_DISK_CANDIDATE.

You haven't explained 'Y' here.  It looks like it means 'Yes', but it doesn=
't.


>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Manage.c   | 33 +++++++++++++++++++++++++++++----
>  ReadMe.c   |  1 +
>  md_p.h     |  7 +++++++
>  md_u.h     |  1 +
>  mdadm.8.in |  9 +++++++++
>  mdadm.c    |  4 ++++
>  mdadm.h    |  2 ++
>  util.c     | 11 +++++++++++
>  8 files changed, 64 insertions(+), 4 deletions(-)
>=20
> diff --git a/Manage.c b/Manage.c
> index d3cfb55..4c3d451 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -690,7 +690,8 @@ skip_re_add:
>  int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  	       struct supertype *tst, mdu_array_info_t *array,
>  	       int force, int verbose, char *devname,
> -	       char *update, unsigned long rdev, unsigned long long array_size)
> +	       char *update, unsigned long rdev, unsigned long long array_size,
> +	       int raid_slot)
>  {
>  	unsigned long long ldsize;
>  	struct supertype *dev_st =3D NULL;
> @@ -879,7 +880,10 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  	}
>  	disc.major =3D major(rdev);
>  	disc.minor =3D minor(rdev);
> -	disc.number =3Dj;
> +	if (raid_slot < 0)
> +		disc.number =3D j;
> +	else
> +		disc.number =3D raid_slot;
>  	disc.state =3D 0;
>  	if (array->not_persistent=3D=3D0) {
>  		int dfd;
> @@ -920,6 +924,14 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  			}
>  		free(used);
>  	}
> +
> +	if (array->state & (1 << MD_SB_CLUSTERED)) {
> +		if (dv->disposition =3D=3D 'c')
> +			disc.state |=3D (1 << MD_DISK_CANDIDATE);
> +		else
> +			disc.state |=3D (1 << MD_DISK_CLUSTER_ADD);
> +	}
> +
>  	if (dv->writemostly =3D=3D 1)
>  		disc.state |=3D (1 << MD_DISK_WRITEMOSTLY);
>  	if (tst->ss->external) {
> @@ -1239,6 +1251,7 @@ int Manage_subdevs(char *devname, int fd,
>  	 *        variant on 'A'
>  	 *  'F' - Another variant of 'A', where the device was faulty
>  	 *        so must be removed from the array first.
> +	 *  'c' - confirm the device as found (for clustered environments)
>  	 *
>  	 * For 'f' and 'r', the device can also be a kernel-internal
>  	 * name such as 'sdb'.
> @@ -1254,6 +1267,7 @@ int Manage_subdevs(char *devname, int fd,
>  	struct mdinfo info;
>  	int frozen =3D 0;
>  	int busy =3D 0;
> +	int raid_slot =3D -1;
> =20
>  	if (ioctl(fd, GET_ARRAY_INFO, &array)) {
>  		pr_err("Cannot get array info for %s\n",
> @@ -1282,6 +1296,11 @@ int Manage_subdevs(char *devname, int fd,
>  		int rv;
>  		int mj,mn;
> =20
> +		raid_slot =3D -1;
> +		if (dv->disposition =3D=3D 'c')
> +			parse_cluster_confirm_arg(dv->devname, &dv->devname,
> +					&raid_slot);
> +
>  		if (strcmp(dv->devname, "failed") =3D=3D 0 ||
>  		    strcmp(dv->devname, "faulty") =3D=3D 0) {
>  			if (dv->disposition !=3D 'A'
> @@ -1307,6 +1326,11 @@ int Manage_subdevs(char *devname, int fd,
>  		if (strcmp(dv->devname, "missing") =3D=3D 0) {
>  			struct mddev_dev *add_devlist =3D NULL;
>  			struct mddev_dev **dp;
> +			if (dv->disposition =3D=3D 'c') {
> +				rv =3D ioctl(fd, CLUSTERED_DISK_NACK, NULL);
> +				break;
> +			}
> +
>  			if (dv->disposition !=3D 'A') {
>  				pr_err("'missing' only meaningful with --re-add\n");
>  				goto abort;
> @@ -1399,7 +1423,7 @@ int Manage_subdevs(char *devname, int fd,
>  			else {
>  				int open_err =3D errno;
>  				if (stat(dv->devname, &stb) !=3D 0) {
> -					pr_err("Cannot find %s: %s\n",
> +					pr_err("%s: %d Cannot find %s: %s\n", __func__, __LINE__,
>  					       dv->devname, strerror(errno));
>  					goto abort;
>  				}
> @@ -1437,6 +1461,7 @@ int Manage_subdevs(char *devname, int fd,
>  		case 'A':
>  		case 'M': /* --re-add missing */
>  		case 'F': /* --re-add faulty  */
> +		case 'c': /* --cluster-confirm */
>  			/* add the device */
>  			if (subarray) {
>  				pr_err("Cannot add disks to a \'member\' array, perform this operati=
on on the parent container\n");
> @@ -1470,7 +1495,7 @@ int Manage_subdevs(char *devname, int fd,
>  			}
>  			rv =3D Manage_add(fd, tfd, dv, tst, &array,
>  					force, verbose, devname, update,
> -					rdev, array_size);
> +					rdev, array_size, raid_slot);
>  			close(tfd);
>  			tfd =3D -1;
>  			if (rv < 0)
> diff --git a/ReadMe.c b/ReadMe.c
> index c6286ae..c854cd5 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -169,6 +169,7 @@ struct option long_options[] =3D {
>      {"wait",	  0, 0,  WaitOpt},
>      {"wait-clean", 0, 0, Waitclean },
>      {"action",    1, 0, Action },
> +    {"cluster-confirm", 0, 0, ClusterConfirm},
> =20
>      /* For Detail/Examine */
>      {"brief",	  0, 0, Brief},
> diff --git a/md_p.h b/md_p.h
> index c4846ba..e59504f 100644
> --- a/md_p.h
> +++ b/md_p.h
> @@ -78,6 +78,12 @@
>  #define MD_DISK_ACTIVE		1 /* disk is running but may not be in sync */
>  #define MD_DISK_SYNC		2 /* disk is in sync with the raid set */
>  #define MD_DISK_REMOVED		3 /* disk is in sync with the raid set */
> +#define MD_DISK_CLUSTER_ADD     4 /* Initiate a disk add across the clus=
ter
> +				   * For clustered enviroments only.
> +				   */
> +#define MD_DISK_CANDIDATE	5 /* disk is added as spare (local) until conf=
irmed
> +				   * For clustered enviroments only.
> +				   */
> =20
>  #define	MD_DISK_WRITEMOSTLY	9 /* disk is "write-mostly" is RAID1 config.
>  				   * read requests will only be sent here in
> @@ -106,6 +112,7 @@ typedef struct mdp_device_descriptor_s {
>  #define MD_SB_BLOCK_CONTAINER_RESHAPE 3 /* block container wide reshapes=
 */
>  #define MD_SB_BLOCK_VOLUME	4 /* block activation of array, other arrays
>  				   * in container can be activated */
> +#define MD_SB_CLUSTERED		5 /* MD is clustered  */
>  #define	MD_SB_BITMAP_PRESENT	8 /* bitmap may be present nearby */
> =20
>  typedef struct mdp_superblock_s {
> diff --git a/md_u.h b/md_u.h
> index be9868a..76068d6 100644
> --- a/md_u.h
> +++ b/md_u.h
> @@ -44,6 +44,7 @@
>  #define STOP_ARRAY		_IO (MD_MAJOR, 0x32)
>  #define STOP_ARRAY_RO		_IO (MD_MAJOR, 0x33)
>  #define RESTART_ARRAY_RW	_IO (MD_MAJOR, 0x34)
> +#define CLUSTERED_DISK_NACK	_IO (MD_MAJOR, 0x35)
> =20
>  typedef struct mdu_version_s {
>  	int major;
> diff --git a/mdadm.8.in b/mdadm.8.in
> index c015cbf..6873cc7 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -1405,6 +1405,15 @@ will avoid reading from these devices if possible.
>  .BR \-\-readwrite
>  Subsequent devices that are added or re\-added will have the 'write-most=
ly'
>  flag cleared.
> +.TP
> +.BR \-\-cluster\-confirm
> +Confirm the existence of the device. This is issued in response to an \-=
\-add
> +request by a node in a cluster. When a node adds a device it sends a mes=
sage
> +to all nodes in the cluster to look for a device with a UUID. This trans=
lates
> +to a udev notification with the UUID of the device to be added and the s=
lot
> +number. The receiving node must acknowledge this message
> +with \-\-cluster\-confirm. Valid arguments are <slot>:<devicename> in ca=
se
> +the device is found or <slot>:missing in case the device is not found.
> =20
>  .P
>  Each of these options requires that the first device listed is the array
> diff --git a/mdadm.c b/mdadm.c
> index 6963a09..5b4b3ef 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -196,6 +196,7 @@ int main(int argc, char *argv[])
>  		case 'f':
>  		case Fail:
>  		case ReAdd: /* re-add */
> +		case ClusterConfirm:
>  			if (!mode) {
>  				newmode =3D MANAGE;
>  				shortopt =3D short_bitmap_options;
> @@ -933,6 +934,9 @@ int main(int argc, char *argv[])
>  					   * remove the device */
>  			devmode =3D 'f';
>  			continue;
> +		case O(MANAGE, ClusterConfirm):
> +			devmode =3D 'c';
> +			continue;
>  		case O(MANAGE,Replace):
>  			/* Mark these devices for replacement */
>  			devmode =3D 'R';
> diff --git a/mdadm.h b/mdadm.h
> index f56d9d6..00c726e 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -346,6 +346,7 @@ enum special_options {
>  	Action,
>  	Nodes,
>  	ClusterName,
> +	ClusterConfirm,
>  };
> =20
>  enum prefix_standard {
> @@ -1281,6 +1282,7 @@ extern int parse_uuid(char *str, int uuid[4]);
>  extern int parse_layout_10(char *layout);
>  extern int parse_layout_faulty(char *layout);
>  extern long parse_num(char *num);
> +extern int parse_cluster_confirm_arg(char *inp, char **devname, int *slo=
t);
>  extern int check_ext2(int fd, char *name);
>  extern int check_reiser(int fd, char *name);
>  extern int check_raid(int fd, char *name);
> diff --git a/util.c b/util.c
> index ed9a745..1d82fc7 100644
> --- a/util.c
> +++ b/util.c
> @@ -273,6 +273,17 @@ long parse_num(char *num)
>  }
>  #endif
> =20
> +int parse_cluster_confirm_arg(char *input, char **devname, int *slot)
> +{
> +	char *dev;
> +	*slot =3D strtoul(input, &dev, 10);
> +	if (dev[0] =3D=3D ':')
> +		*devname =3D dev+1;
> +	else
> +		return -1;
> +	return 0;
> +}

The logic here hurts my brain :-(

 *slot =3D strtoul(input, &dev, 10);
 if (dev =3D=3D input || dev[0] !=3D ':')
     return -1;
 *devname =3D dev+1;
 return 0;

> +
>  void remove_partitions(int fd)
>  {
>  	/* remove partitions from this block devices.

Thanks,
NeilBrown


--Sig_/6=LVv32=RMXrlcG83Gt0kM9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUA3vTnsnt1WYoG5AQJVnw/+KGGjyMyBd7hIKkwD8hWCBAO2Spyj2sps
QGi+LeCPL8wwAwvvcGNmnMn4OQ+IXLEMs456K5gvuuE/xVlCKV2/KO3fWgCy176x
D/NIJv1zoWGlikxb/ntMdNr9f0TruDAS6Zrr3zziO6EHdhSg1d2Of3xO/UibBXEj
Ikc9g5WYD/kJvnjeAnhvdUiY3N1YmvnppgdZYdvT3FFfPAPbvQmD5wKAbrebAKT0
2XFEEJouWqGajHL1ivPgrqJBWqt3oqDPkZgLPJSK2HfWl913fsc4VLK5sTzaSACF
ywfaMBkPIv8VCYZWXlM2Sjt99uBVdzI6L5tXIZQquLumMeiK+ecZIZIbyvzarSGs
iAAPTVRau+Kvs4Xfyd307g/iEAWafPPXM1wb5L67oFVJdK52ICErmuVF/uLdWzmK
UVjbPyoPcQe3F4r9VmOZgrq8yDn5wARnsdoGzOkYeP9biHPVs/giT0C81J3mfCip
6lwkYombwRHSf9JAtobKjRrkICDKI2EvsEd1PhVPCDc9c4mWMDaVIUvMWEZU7WqA
PNQ5ZYU/4JtOsUOq4FaqcM6YpfJIS4BLp2X1KGdd2XBZTqMgNwn84gi24/FodVlm
IadSFZEQ6FHI+L9VnqP7J20J5YLzafGV8ArTrZFafLUDNl7NEOmOVckiHU5yJ3g5
q8DeMQiFO7U=
=sqpM
-----END PGP SIGNATURE-----

--Sig_/6=LVv32=RMXrlcG83Gt0kM9--
