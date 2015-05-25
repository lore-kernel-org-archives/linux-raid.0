From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V3 03/11] home-cluster while creating an array
Date: Mon, 25 May 2015 14:19:09 +1000
Message-ID: <20150525141909.7daeb1fc@notabene.brown>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
	<1432092043-24220-4-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/YGm0FvNuKBHB3QP3ljY205d"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432092043-24220-4-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

--Sig_/YGm0FvNuKBHB3QP3ljY205d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2015 11:20:35 +0800 Guoqing Jiang <gqjiang@suse.com> wrote:

> The home-cluster is stored in the bitmap super block of the
> array. The device can be assembled on a cluster with the
> cluster name same as the one recorded in the bitmap.
>=20
> If home-cluster is not specified, this is auto-detected using
> dlopen corosync cmap library.
>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Create.c   |  1 +
>  Makefile   |  1 +
>  ReadMe.c   |  1 +
>  config.c   | 27 ++++++++++++++++++++++++++-
>  mdadm.8.in |  6 ++++++
>  mdadm.c    | 25 +++++++++++++++++++++++++
>  mdadm.h    |  5 +++++
>  super1.c   |  3 +++
>  util.c     | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  9 files changed, 118 insertions(+), 1 deletion(-)
>=20
> diff --git a/Create.c b/Create.c
> index e4577af..9663dc4 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -532,6 +532,7 @@ int Create(struct supertype *st, char *mddev,
>  		warn =3D 1;
>  	}
>  	st->nodes =3D c->nodes;
> +	st->cluster_name =3D c->homecluster;
> =20
>  	if (warn) {
>  		if (c->runstop!=3D 1) {
> diff --git a/Makefile b/Makefile
> index a7d8c5c..431f08b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -101,6 +101,7 @@ endif
>  # If you want a static binary, you might uncomment these
>  # LDFLAGS =3D -static
>  # STRIP =3D -s
> +LDLIBS=3D-ldl
> =20
>  INSTALL =3D /usr/bin/install
>  DESTDIR =3D
> diff --git a/ReadMe.c b/ReadMe.c
> index 30c569d..c6286ae 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -141,6 +141,7 @@ struct option long_options[] =3D {
>      {"symlinks",  1, 0,  Symlinks},
>      {"data-offset",1, 0, DataOffset},
>      {"nodes",1, 0, Nodes},
> +    {"home-cluster",1, 0, ClusterName},
> =20
>      /* For assemble */
>      {"uuid",      1, 0, 'u'},
> diff --git a/config.c b/config.c
> index 7342c42..21b6afd 100644
> --- a/config.c
> +++ b/config.c
> @@ -77,7 +77,7 @@ char DefaultAltConfFile[] =3D CONFFILE2;
>  char DefaultAltConfDir[] =3D CONFFILE2 ".d";
> =20
>  enum linetype { Devices, Array, Mailaddr, Mailfrom, Program, CreateDev,
> -		Homehost, AutoMode, Policy, PartPolicy, LTEnd };
> +		Homehost, HomeCluster, AutoMode, Policy, PartPolicy, LTEnd };
>  char *keywords[] =3D {
>  	[Devices]  =3D "devices",
>  	[Array]    =3D "array",
> @@ -86,6 +86,7 @@ char *keywords[] =3D {
>  	[Program]  =3D "program",
>  	[CreateDev]=3D "create",
>  	[Homehost] =3D "homehost",
> +	[HomeCluster] =3D "homecluster",
>  	[AutoMode] =3D "auto",
>  	[Policy]   =3D "policy",
>  	[PartPolicy]=3D"part-policy",
> @@ -562,6 +563,21 @@ void homehostline(char *line)
>  	}
>  }
> =20
> +static char *home_cluster =3D NULL;
> +void homeclusterline(char *line)
> +{
> +	char *w;
> +
> +	for (w=3Ddl_next(line); w !=3D line ; w=3Ddl_next(w)) {
> +		if (home_cluster =3D=3D NULL) {
> +			if (strcasecmp(w, "<none>")=3D=3D0)
> +				home_cluster =3D xstrdup("");
> +			else
> +				home_cluster =3D xstrdup(w);
> +		}
> +	}
> +}
> +
>  char auto_yes[] =3D "yes";
>  char auto_no[] =3D "no";
>  char auto_homehost[] =3D "homehost";
> @@ -724,6 +740,9 @@ void conf_file(FILE *f)
>  		case Homehost:
>  			homehostline(line);
>  			break;
> +		case HomeCluster:
> +			homeclusterline(line);
> +			break;
>  		case AutoMode:
>  			autoline(line);
>  			break;
> @@ -884,6 +903,12 @@ char *conf_get_homehost(int *require_homehostp)
>  	return home_host;
>  }
> =20
> +char *conf_get_homecluster(void)
> +{
> +	load_conffile();
> +	return home_cluster;
> +}
> +
>  struct createinfo *conf_get_create_info(void)
>  {
>  	load_conffile();
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 9c1497e..56d9bcc 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -415,6 +415,12 @@ This functionality is currently only provided by
>  and
>  .BR \-\-monitor .
> =20
> +.TP
> +.B \-\-home\-cluster=3D
> +specifies the cluster name for the md device. The md device can be assem=
bled
> +only on the cluster which matches the name specified. If this option is =
not
> +provided, mdadm tried to detect the cluster name automatically.

"... mdadm tries to detect...."   s, not d.


> +
>  .SH For create, build, or grow:
> =20
>  .TP
> diff --git a/mdadm.c b/mdadm.c
> index 15a43d2..8f567d8 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -596,6 +596,13 @@ int main(int argc, char *argv[])
>  				exit(2);
>  			}
>  			continue;
> +		case O(CREATE, ClusterName):
> +			c.homecluster =3D optarg;
> +			if (strlen(c.homecluster) > 64) {
> +				pr_err("Cluster name too big.\n");
> +				exit(ERANGE);
> +			}
> +			continue;
>  		case O(CREATE,'x'): /* number of spare (eXtra) disks */
>  			if (s.sparedisks) {
>  				pr_err("spare-devices set twice: %d and %s\n",
> @@ -1276,6 +1283,18 @@ int main(int argc, char *argv[])
>  		c.require_homehost =3D 0;
>  	}
> =20
> +	if (c.homecluster =3D=3D NULL && (c.nodes > 0)) {
> +		c.homecluster =3D conf_get_homecluster();
> +		if (c.homecluster =3D=3D NULL)
> +			rv =3D get_cluster_name(&c.homecluster);
> +		if (rv =3D=3D 0) {
> +			c.homehost =3D xstrdup(c.homecluster);
> +			/* Add a : to differentiate between a host
> +			 * and a cluster */
> +			strcat(c.homehost, ":");
> +		}

That ':' will be copied over the last byte allocated by 'strdup', and the
'\0' will be written beyond the memory allocated by strdup.  That could
corrupt something.


> +	}
> +
>  	if (c.backup_file && data_offset !=3D INVALID_SECTORS) {
>  		pr_err("--backup-file and --data-offset are incompatible\n");
>  		exit(2);
> @@ -1407,6 +1426,12 @@ int main(int argc, char *argv[])
>  				rv =3D 1;
>  				break;
>  			}
> +			if (c.homecluster) {
> +				pr_err("--home-cluster argument is incompatible with --bitmap=3D%s.\=
n",
> +					s.bitmap_file);
> +				rv =3D 1;
> +				break;
> +			}

Better make sure s.bitmap_file is not NULL here too.


Thanks,
NeilBrown


>  		}
> =20
>  		if (s.write_behind && !s.bitmap_file) {
> diff --git a/mdadm.h b/mdadm.h
> index 9d55801..f56d9d6 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -345,6 +345,7 @@ enum special_options {
>  	Restore,
>  	Action,
>  	Nodes,
> +	ClusterName,
>  };
> =20
>  enum prefix_standard {
> @@ -420,6 +421,7 @@ struct context {
>  	int	invalid_backup;
>  	char	*action;
>  	int	nodes;
> +	char	*homecluster;
>  };
> =20
>  struct shape {
> @@ -1032,6 +1034,7 @@ struct supertype {
>  	int devcnt;
>  	int retry_soon;
>  	int nodes;
> +	char *cluster_name;
> =20
>  	struct mdinfo *devs;
> =20
> @@ -1308,6 +1311,7 @@ extern char *conf_get_mailaddr(void);
>  extern char *conf_get_mailfrom(void);
>  extern char *conf_get_program(void);
>  extern char *conf_get_homehost(int *require_homehostp);
> +extern char *conf_get_homecluster(void);
>  extern char *conf_line(FILE *file);
>  extern char *conf_word(FILE *file, int allow_key);
>  extern void print_quoted(char *str);
> @@ -1416,6 +1420,7 @@ extern char *stat2devnm(struct stat *st);
>  extern char *fd2devnm(int fd);
> =20
>  extern int in_initrd(void);
> +extern int get_cluster_name(char **name);
> =20
>  #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
>  #define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
> diff --git a/super1.c b/super1.c
> index 78d98a7..60f470b 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2145,6 +2145,9 @@ add_internal_bitmap1(struct supertype *st,
>  	bms->sync_size =3D __cpu_to_le64(size);
>  	bms->write_behind =3D __cpu_to_le32(write_behind);
>  	bms->nodes =3D __cpu_to_le32(st->nodes);
> +	if (st->cluster_name)
> +	    strncpy((char *)bms->cluster_name,
> +		    st->cluster_name, strlen(st->cluster_name));
> =20
>  	*chunkp =3D chunk;
>  	return 1;
> diff --git a/util.c b/util.c
> index cc98d3b..ed9a745 100644
> --- a/util.c
> +++ b/util.c
> @@ -34,6 +34,8 @@
>  #include	<ctype.h>
>  #include	<dirent.h>
>  #include	<signal.h>
> +#include	<dlfcn.h>
> +#include	<corosync/cmap.h>
> =20
>  /*
>   * following taken from linux/blkpg.h because they aren't
> @@ -1976,3 +1978,51 @@ void reopen_mddev(int mdfd)
>  	if (fd >=3D 0 && fd !=3D mdfd)
>  		dup2(fd, mdfd);
>  }
> +
> +int get_cluster_name(char **cluster_name)
> +{
> +        void *lib_handle =3D NULL;
> +        int rv =3D -1;
> +
> +        cmap_handle_t handle;
> +        static int (*initialize)(cmap_handle_t *handle);
> +        static int (*get_string)(cmap_handle_t handle,
> +                        const char *string,
> +                        char **name);
> +        static int (*finalize)(cmap_handle_t handle);
> +
> +
> +        lib_handle =3D dlopen("libcmap.so.4", RTLD_NOW | RTLD_LOCAL);
> +        if (!lib_handle)
> +                return rv;
> +
> +        initialize =3D dlsym(lib_handle, "cmap_initialize");
> +        if (!initialize)
> +                goto out;
> +
> +        get_string =3D dlsym(lib_handle, "cmap_get_string");
> +        if (!get_string)
> +                goto out;
> +
> +        finalize =3D dlsym(lib_handle, "cmap_finalize");
> +        if (!finalize)
> +                goto out;
> +
> +        rv =3D initialize(&handle);
> +        if (rv !=3D CS_OK)
> +                goto out;
> +
> +        rv =3D get_string(handle, "totem.cluster_name", cluster_name);
> +        if (rv !=3D CS_OK) {
> +                free(*cluster_name);
> +                rv =3D -1;
> +                goto name_err;
> +        }
> +
> +        rv =3D 0;
> +name_err:
> +        finalize(handle);
> +out:
> +        dlclose(lib_handle);
> +        return rv;
> +}


--Sig_/YGm0FvNuKBHB3QP3ljY205d
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWKivTnsnt1WYoG5AQI2mQ/+NmstjyuxYpzDWPCxkM+ogynHTNTSQ/ds
zVoh3yfBc2yffayzcbY7CXbVowhQzT6mfQqXwRSWc3PyghyVwdUjak08v+uiAl0y
PfEuKk2EymJBv4bUlBSOQj6KN9xagN1NCo/ENZdEqGDdbysOO8cK6iXweX0VeC+l
6bHtAd7udMsL1PeplEs1tt6L2NrP0+KEMw6Bv9ERf+rB62uUR4YTIY9BZONYQDQ4
uDf9ywEKqZnRhXMSGHuBV2iqn49c9GYzD/aWm8tZypB80Bim/nNmtMLnfFVexUdT
LBgghJsxyC7KrWupnbokziy910y6v1f2H+C71y02HYSdYeh7pG5rBlHSzcnDlUZC
zNn4X+XqPggxjGK+jaanHuTbwND70xFXZ38PaZtZug+hWJ7jWZx2Ye8UfZEo5PSv
ZE9qYs3a1MBK98zok+C4b+L6gR+TnP/rY8cRGJj21dwvBre+NWx1+tW0PFWzjP59
HmOe4r8vovLlJ2U6dU3F3MeTiCUflOTIgSgAqooPGmTM0peoKdbGY3xKB0UbLjeo
/wwV5lWEXuvLkLIM6SuXIoiaiVLG5zquHXJhaxQUJXEUx26uYlA2JDyB7niU8h1K
62sDWg9iGp+qja6D6qGo4G2Ryo+C57F6xz5IY4ehornKionV+G5BZ3O1HBmyhX3o
Ma7H9GP2twY=
=GvCa
-----END PGP SIGNATURE-----

--Sig_/YGm0FvNuKBHB3QP3ljY205d--
