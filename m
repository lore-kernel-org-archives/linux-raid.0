From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 08/10] mdadm: add the ability to change cluster name
Date: Wed, 29 Apr 2015 11:50:33 +1000
Message-ID: <20150429115033.1191a357@notabene.brown>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
	<1429860641-5839-9-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/JcxYM+3J14_WR++xP8fY2qu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429860641-5839-9-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: gqjiang@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

--Sig_/JcxYM+3J14_WR++xP8fY2qu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Apr 2015 15:30:39 +0800 gqjiang@suse.com wrote:

> From: Guoqing Jiang <gqjiang@suse.com>
>=20
> To support change the cluster name, the commit do the followings:
>=20
> 1. extend original write_bitmap function for new scenario.
> 2. add the scenarion to handle the modification of cluster's name
>    in write_bitmap1.
> 3. make update_super1 can change the name in mdp_superblock_1.
>=20
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Assemble.c |  5 +++++
>  Grow.c     |  2 +-
>  mdadm.c    |  3 +++
>  mdadm.h    |  7 ++++++-
>  super0.c   |  4 ++--
>  super1.c   | 46 ++++++++++++++++++++++++++++++++++++++++++++--
>  6 files changed, 61 insertions(+), 6 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 25a103d..e1b846c 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -644,6 +644,11 @@ static int load_devices(struct devs *devices, char *=
devmap,
>  				*stp =3D st;
>  				return -1;
>  			}
> +			if (strcmp(c->update, "home-cluster") =3D=3D 0) {
> +				err =3D tst->ss->update_super(tst, content, c->update,
> +							    devname, 0, 0, c->homecluster);
> +				tst->ss->write_bitmap(tst, dfd, NameUpdate);
> +			}
>  			if (strcmp(c->update, "uuid")=3D=3D0 &&
>  			    !ident->uuid_set) {
>  				ident->uuid_set =3D 1;
> diff --git a/Grow.c b/Grow.c
> index 1122cec..bf44e66 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -420,7 +420,7 @@ int Grow_addbitmap(char *devname, int fd, struct cont=
ext *c, struct shape *s)
>  						    bitmapsize, offset_setable,
>  						    major)
>  						)
> -						st->ss->write_bitmap(st, fd2);
> +						st->ss->write_bitmap(st, fd2, NoUpdate);
>  					else {
>  						pr_err("failed to create internal bitmap - chunksize problem.\n");
>  						close(fd2);
> diff --git a/mdadm.c b/mdadm.c
> index 5b4b3ef..20f195d 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -598,6 +598,7 @@ int main(int argc, char *argv[])
>  			}
>  			continue;
>  		case O(CREATE, ClusterName):
> +		case O(ASSEMBLE, ClusterName):
>  			c.homecluster =3D optarg;
>  			if (strlen(c.homecluster) > 64) {
>  				pr_err("Cluster name too big.\n");
> @@ -741,6 +742,8 @@ int main(int argc, char *argv[])
>  				continue;
>  			if (strcmp(c.update, "homehost")=3D=3D0)
>  				continue;
> +			if (strcmp(c.update, "home-cluster")=3D=3D0)
> +				continue;
>  			if (strcmp(c.update, "devicesize")=3D=3D0)
>  				continue;
>  			if (strcmp(c.update, "no-bitmap")=3D=3D0)
> diff --git a/mdadm.h b/mdadm.h
> index 00c726e..d8b0749 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -354,6 +354,11 @@ enum prefix_standard {
>  	IEC
>  };
> =20
> +enum bitmap_update {
> +    NoUpdate,
> +    NameUpdate,
> +};
> +
>  /* structures read from config file */
>  /* List of mddevice names and identifiers
>   * Identifiers can be:
> @@ -850,7 +855,7 @@ extern struct superswitch {
>  	/* if add_internal_bitmap succeeded for existing array, this
>  	 * writes it out.
>  	 */
> -	int (*write_bitmap)(struct supertype *st, int fd);
> +	int (*write_bitmap)(struct supertype *st, int fd, enum bitmap_update up=
date);
>  	/* Free the superblock and any other allocated data */
>  	void (*free_super)(struct supertype *st);
> =20
> diff --git a/super0.c b/super0.c
> index deb5999..6ad9d39 100644
> --- a/super0.c
> +++ b/super0.c
> @@ -900,7 +900,7 @@ static int write_init_super0(struct supertype *st)
>  		rv =3D store_super0(st, di->fd);
> =20
>  		if (rv =3D=3D 0 && (sb->state & (1<<MD_SB_BITMAP_PRESENT)))
> -			rv =3D st->ss->write_bitmap(st, di->fd);
> +			rv =3D st->ss->write_bitmap(st, di->fd, NoUpdate);
> =20
>  		if (rv)
>  			pr_err("failed to write superblock to %s\n",
> @@ -1175,7 +1175,7 @@ static void locate_bitmap0(struct supertype *st, in=
t fd)
>  	lseek64(fd, offset, 0);
>  }
> =20
> -static int write_bitmap0(struct supertype *st, int fd)
> +static int write_bitmap0(struct supertype *st, int fd, enum bitmap_updat=
e update)
>  {
>  	unsigned long long dsize;
>  	unsigned long long offset;
> diff --git a/super1.c b/super1.c
> index 3c2fce2..e43bef1 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1073,6 +1073,25 @@ static int update_super1(struct supertype *st, str=
uct mdinfo *info,
>  		info->name[32] =3D 0;
>  	}
> =20
> +	if (strcmp(update, "home-cluster") =3D=3D 0 &&
> +	    homehost) {
> +		/* Note that 'home-cluster' is to change the name of cluster,
> +		 * it is another "name" update.
> +		 */
> +		char *new_name =3D xmalloc(sizeof(sb->set_name));
> +		if (strrchr(sb->set_name, ':')) {
> +			strcpy(new_name, strchr(sb->set_name, ':'));
> +		}
> +
> +		memset(sb->set_name, 0, sizeof(sb->set_name));
> +		strcpy(sb->set_name, homehost);
> +		if (new_name)
> +			strcat(sb->set_name, new_name);
> +
> +		free(new_name);
> +		goto out;
> +	}
> +

Please get rid of the 'goto out' and put an 'else' in here.

"homehost" is special because it translates to "name".
"home-cluster" is not special.


>  	if (strcmp(update, "force-one")=3D=3D0) {
>  		/* Not enough devices for a working array,
>  		 * so bring this one up-to-date
> @@ -1313,6 +1332,7 @@ static int update_super1(struct supertype *st, stru=
ct mdinfo *info,
>  	else
>  		rv =3D -1;
> =20
> +out:
>  	sb->sb_csum =3D calc_sb_1_csum(sb);
>  	return rv;
>  }
> @@ -1691,7 +1711,7 @@ static int write_init_super1(struct supertype *st)
>  		sb->sb_csum =3D calc_sb_1_csum(sb);
>  		rv =3D store_super1(st, di->fd);
>  		if (rv =3D=3D 0 && (__le32_to_cpu(sb->feature_map) & 1))
> -			rv =3D st->ss->write_bitmap(st, di->fd);
> +			rv =3D st->ss->write_bitmap(st, di->fd, NoUpdate);
>  		close(di->fd);
>  		di->fd =3D -1;
>  		if (rv)
> @@ -2175,7 +2195,7 @@ static void locate_bitmap1(struct supertype *st, in=
t fd)
>  	lseek64(fd, offset<<9, 0);
>  }
> =20
> -static int write_bitmap1(struct supertype *st, int fd)
> +static int write_bitmap1(struct supertype *st, int fd, enum bitmap_updat=
e update)
>  {
>  	struct mdp_superblock_1 *sb =3D st->sb;
>  	bitmap_super_t *bms =3D (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
> @@ -2185,6 +2205,28 @@ static int write_bitmap1(struct supertype *st, int=
 fd)
>  	struct align_fd afd;
>  	unsigned int i;
> =20
> +	switch (update) {
> +	case NameUpdate:
> +	{
> +	    char *new_name =3D xmalloc(sizeof(sb->set_name));
> +
> +	    strncpy(new_name, sb->set_name, sizeof(sb->set_name));
> +	    memset((char *)bms->cluster_name, 0, sizeof(bms->cluster_name));
> +
> +	    if (strtok(new_name, ":"))
> +		strncpy((char *)bms->cluster_name, new_name, strlen(sb->set_name));
> +	    else
> +		/* In case the original set_name doesn't like aaa:md* */
> +		strncpy((char *)bms->cluster_name, sb->set_name, strlen(sb->set_name));
> +
> +	    free(new_name);
> +	    break;
> +	}

I don't like the braces there - too confusing.
Just make 'new_name' a top-level variable and get rid of the {}

Thanks,
NeilBrown


> +	case NoUpdate:
> +	default:
> +	    break;
> +	}
> +
>  	init_afd(&afd, fd);
> =20
>  	locate_bitmap1(st, fd);


--Sig_/JcxYM+3J14_WR++xP8fY2qu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUA46Tnsnt1WYoG5AQL5kg/+MbRYJ++1PQXWYKn/ne657c+Vq+G53IBD
SOx4ZFKz86fxmUlsK6AMN2vObwXorpiLtmJF06O1Lc3BRokGoB+7Apaj3HknGwWe
Ku4UeKc80uJR/2MGr71fxRiYxlZuzIoqbLqp/Q+iVAG0r3XxIJfxikQz1SJRRMlc
dAewnDNz30GQRNPxaVPHv7x2TMReXJXlkLpIRWR+ZQeVajbc+bJrtgv4JFa08aCM
6Xot/SnBCOeaH1CjEjXJODb54RX0eDR8xOvCXzuqMPIf0O+zP5wIKcfm/+To0w70
TzJm0Iu7spaH674fw+CCAXliHiCKmAd8BR6keseNpen2ripkT4Wwtu/+XL67bsOp
znik9es2wK6/QeXSV69aM5OhXxqYwbtOMVbDJNJzOKMa7cUkTiPcOxl0fJVUnHD4
zIh1o0CZiUhYxAQ0ZMj3VxwHVidPIvqLzlougRgD6SiYVauzT/k/m6wU0mmKAGkO
N2mp9L7pdJlBNzIF+ZzffseQQfS6UmelWOX8VRsAcOQT8HgOzjh/pQbGm3JSzQHK
Eott2mmul8dskQLkABpX732IdMQ0fEELRaeaLN7GTQW4VYZAo5Yew/oiR8+Dj7Sq
7eNVSy0SiWw5LI1XoZhDOTqTAsvn/+NG1iXtFWsKYO3lG2iVZ3y1rufDMsIgpziD
pMRHGmDR03U=
=2gkV
-----END PGP SIGNATURE-----

--Sig_/JcxYM+3J14_WR++xP8fY2qu--
