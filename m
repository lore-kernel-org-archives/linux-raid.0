From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/4] md-cluster: remove capabilities
Date: Thu, 9 Apr 2015 09:24:34 +1000
Message-ID: <20150409092434.7d0759f1@notabene.brown>
References: <20150408192247.GA9682@shrek.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/gbl._J0gPgO0Il+ZoeFhl+v"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150408192247.GA9682@shrek.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-raid@vger.kernel.org, GQJiang@suse.com
List-Id: linux-raid.ids

--Sig_/gbl._J0gPgO0Il+ZoeFhl+v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Apr 2015 14:22:47 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrot=
e:

> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Hi Goldwyn,
 where really need to be more words here.  What is the purpose of this
 "remove capabilities"? How are they used?


> ---
>  drivers/md/md-cluster.c | 47 +++++++++++++++++++++++++++++++++++++++++++=
++++
>  drivers/md/md-cluster.h |  1 +
>  drivers/md/md.c         | 24 +++++++++++++++---------
>  drivers/md/md.h         |  1 +
>  4 files changed, 64 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 96679b2..d036c83 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -72,6 +72,7 @@ enum msg_type {
>  	METADATA_UPDATED =3D 0,
>  	RESYNCING,
>  	NEWDISK,
> +	REMOVE,
>  };
> =20
>  struct cluster_msg {
> @@ -186,6 +187,20 @@ static char *pretty_uuid(char *dest, char *src)
>  	return dest;
>  }
> =20
> +static struct md_rdev *find_rdev_uuid(struct mddev *mddev, char *uuid)
> +{
> +	struct md_rdev *rdev;
> +	struct mdp_superblock_1 *sb;
> +
> +	rdev_for_each_rcu(rdev, mddev) {
> +		sb =3D page_address(rdev->sb_page);
> +		if (!strncmp(uuid, sb->device_uuid, 16)) {
> +			return rdev;
> +		}
> +	}
> +	return NULL;
> +}

I'm not at all comfortable about this.

Any code that "knows" about a particular metadata format should be accessed
through the super_types[] array.

I think I would rather you used 'desc_nr' to identify the device to be
removed.  This number is determined from the metadata so every node will see
the same number for the same device.  And it is independent of metadata typ=
e.

> +
>  static void add_resync_info(struct mddev *mddev, struct dlm_lock_resourc=
e *lockres,
>  		sector_t lo, sector_t hi)
>  {
> @@ -401,6 +416,17 @@ static void process_metadata_update(struct mddev *md=
dev, struct cluster_msg *msg
>  	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
>  }
> =20
> +static void process_remove_disk(struct mddev *mddev, struct cluster_msg =
*msg)
> +{
> +	struct md_rdev *rdev =3D find_rdev_uuid(mddev, msg->uuid);
> +	char uuid[32];
> +
> +	if (rdev)
> +		md_kick_rdev_from_array(rdev);
> +	else
> +		pr_warn("%s: %d Could not find disk with uuid: %s", __func__, __LINE__=
, pretty_uuid(uuid, msg->uuid));
> +}
> +
>  static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *m=
sg)
>  {
>  	switch (msg->type) {
> @@ -419,6 +445,15 @@ static void process_recvd_msg(struct mddev *mddev, s=
truct cluster_msg *msg)
>  		pr_info("%s: %d Received message: NEWDISK from %d\n",
>  			__func__, __LINE__, msg->slot);
>  		process_add_new_disk(mddev, msg);
> +		break;
> +	case REMOVE:
> +		pr_info("%s: %d Received REMOVE from %d\n",
> +			__func__, __LINE__, msg->slot);
> +		process_remove_disk(mddev, msg);
> +		break;
> +	default:
> +		pr_warn("%s:%d Received unknown message from %d\n",
> +			__func__, __LINE__, msg->slot);
>  	};
>  }
> =20
> @@ -854,6 +889,17 @@ static int new_disk_ack(struct mddev *mddev, bool ac=
k)
>  	return 0;
>  }
> =20
> +static int remove_disk(struct mddev *mddev, struct md_rdev *rdev)
> +{
> +	struct cluster_msg cmsg;
> +	struct md_cluster_info *cinfo =3D mddev->cluster_info;
> +	struct mdp_superblock_1 *sb =3D page_address(rdev->sb_page);
> +	char *uuid =3D sb->device_uuid;
> +	cmsg.type =3D REMOVE;
> +	memcpy(cmsg.uuid, uuid, 16);
> +	return __sendmsg(cinfo, &cmsg);
> +}
> +
>  static struct md_cluster_operations cluster_ops =3D {
>  	.join   =3D join,
>  	.leave  =3D leave,
> @@ -868,6 +914,7 @@ static struct md_cluster_operations cluster_ops =3D {
>  	.add_new_disk_start =3D add_new_disk_start,
>  	.add_new_disk_finish =3D add_new_disk_finish,
>  	.new_disk_ack =3D new_disk_ack,
> +	.remove_disk =3D remove_disk,
>  };
> =20
>  static int __init cluster_init(void)
> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
> index 7417133..71e5143 100644
> --- a/drivers/md/md-cluster.h
> +++ b/drivers/md/md-cluster.h
> @@ -22,6 +22,7 @@ struct md_cluster_operations {
>  	int (*add_new_disk_start)(struct mddev *mddev, struct md_rdev *rdev);
>  	int (*add_new_disk_finish)(struct mddev *mddev);
>  	int (*new_disk_ack)(struct mddev *mddev, bool ack);
> +	int (*remove_disk)(struct mddev *mddev, struct md_rdev *rdev);
>  };
> =20
>  #endif /* _MD_CLUSTER_H */
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index bc11551..0c65e51 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2291,11 +2291,12 @@ static void export_rdev(struct md_rdev * rdev)
>  	kobject_put(&rdev->kobj);
>  }
> =20
> -static void kick_rdev_from_array(struct md_rdev * rdev)
> +void md_kick_rdev_from_array(struct md_rdev * rdev)
>  {
>  	unbind_rdev_from_array(rdev);
>  	export_rdev(rdev);
>  }
> +EXPORT_SYMBOL_GPL(md_kick_rdev_from_array);

You didn't create this patch against upstream code did you?  The space
between '*' and 'rdev' disappeared in 3.18.
I think I would prefer a separate patch which renames and exports
kick_rdev_from_array, and then a much smaller (easier to review) patch which
adds the 'remove capabilities'.

Thanks,
NeilBrown



--Sig_/gbl._J0gPgO0Il+ZoeFhl+v
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSW4sjnsnt1WYoG5AQIydRAApQlpUhXRjj25xHAJKynywMekPXcbayg3
NAgqszdzk/X20w+933xjyVqtTN2LYP+2Myopunii5jMPb0ULlvLBs3WZNofwKKmH
XOadxJBSKJScAI9TMC8HVliTi0Yk15qj75ig2/PnLZcGZEJg7fxcfgfXakwKw0gB
pkJan/KuR0eSYC+XkiIoOjEp4hFjmIePEq9ctakbnIKX9GFUVi9jbf6acYGzhuL6
i2j3LilckOmvv044lac5hnH+cq6Xx0H7dKCQqDszvPtGbe4GdPFcPIHdyBoZeCBg
Gcb9JWPDINCcDyNWvlc9gZECZGH+1w4XlSUS+foIvjWN/c7ZjQPeXU8CbVS4eFWF
3dZEMkLJnMsPbBUhovOwXoYPSkxazE5qQMP9sthYv3PUBGGROikQV23gXJ9mT3MW
5tGY/HqBu0K4jezKgtzTaK1F5TnO5VavP8sSIeQ1+H5qpIQS7VAOSeoK3/928MQN
2MsXhrjQ1dZlrHiGGSFyHeXhWJRtOzhM2MlTPHDwqIxNQtv49/2Ujcue5hBfZ6vR
T3IdBw02ee9cbHHER/zhybQpBplRlOoE/erKxqnAHAJp1x0xSY82ljz/yVRwib3Q
FEeS0Nv5UhEEWgDaP8puov5zUTVcb17JlK+cwdenev/rdApeHjEQv1i9oipYk0KS
Yq+Yv85ZZj8=
=rQV3
-----END PGP SIGNATURE-----

--Sig_/gbl._J0gPgO0Il+ZoeFhl+v--
