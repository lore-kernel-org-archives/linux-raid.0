From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/4] md-cluster: re-add
Date: Thu, 9 Apr 2015 09:55:01 +1000
Message-ID: <20150409095501.536f6216@notabene.brown>
References: <20150408192414.GA9693@shrek.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/KFf7esYkI+GeigyMam/E7mL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150408192414.GA9693@shrek.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-raid@vger.kernel.org, GQJiang@suse.com
List-Id: linux-raid.ids

--Sig_/KFf7esYkI+GeigyMam/E7mL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Apr 2015 14:24:14 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrot=
e:

> This extends the capabilites of re-adding a failed device
> to the clustering environment.
>=20
> A new function gather_bitmaps gathers set bits from bitmaps of
> all nodes, sends a message to all nodes to readd the disk
> and then initiates the recovery process.
>=20
> Question: Do you see a race in sending a READD and then performing
> the bitmap resync/recovery? Should the initiating node perform the
> recovery before sending the READD message? The recovery will send a
> METADATA_UPDATE anyways.

The RE-ADD has to happen *before* the bitmaps are gathered.
After the RE-ADD, all writes will go to the new device.
Any write before that RE-ADD will be recorded in the bitmap.
To ensure that the recovery handles all regions affected by writes, it needs
to know about all writes that didn't go to the new device.  So it needs to
collect bitmaps only once new writes have started going to the new device.

Is that clear?  If not, I'll try again.


NeilBrown

>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/bitmap.c     | 20 +++++++++++---------
>  drivers/md/bitmap.h     |  2 +-
>  drivers/md/md-cluster.c | 50 +++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  drivers/md/md-cluster.h |  1 +
>  drivers/md/md.c         |  2 ++
>  5 files changed, 64 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index eccfa27..3e69583 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -1869,7 +1869,7 @@ EXPORT_SYMBOL_GPL(bitmap_load);
>   * to our bitmap
>   */
>  int bitmap_copy_from_slot(struct mddev *mddev, int slot,
> -		sector_t *low, sector_t *high)
> +		sector_t *low, sector_t *high, bool clear_bits)
>  {
>  	int rv =3D 0, i, j;
>  	sector_t block, lo =3D 0, hi =3D 0;
> @@ -1896,14 +1896,16 @@ int bitmap_copy_from_slot(struct mddev *mddev, in=
t slot,
>  		}
>  	}
> =20
> -	bitmap_update_sb(bitmap);
> -	/* Setting this for the ev_page should be enough.
> -	 * And we do not require both write_all and PAGE_DIRT either
> -	 */
> -	for (i =3D 0; i < bitmap->storage.file_pages; i++)
> -		set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
> -	bitmap_write_all(bitmap);
> -	bitmap_unplug(bitmap);
> +	if (clear_bits) {
> +		bitmap_update_sb(bitmap);
> +		/* Setting this for the ev_page should be enough.
> +		 * And we do not require both write_all and PAGE_DIRT either
> +		 */
> +		for (i =3D 0; i < bitmap->storage.file_pages; i++)
> +			set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
> +		bitmap_write_all(bitmap);
> +		bitmap_unplug(bitmap);
> +	}
>  	*low =3D lo;
>  	*high =3D hi;
>  err:
> diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
> index e838ea7..74bffc7 100644
> --- a/drivers/md/bitmap.h
> +++ b/drivers/md/bitmap.h
> @@ -263,7 +263,7 @@ void bitmap_daemon_work(struct mddev *mddev);
>  int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>  		  int chunksize, int init);
>  int bitmap_copy_from_slot(struct mddev *mddev, int slot,
> -				sector_t *lo, sector_t *hi);
> +				sector_t *lo, sector_t *hi, bool clear_bits);
>  #endif
> =20
>  #endif
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index d036c83..afffbee 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -50,6 +50,7 @@ struct md_cluster_info {
>  	/* dlm lock space and resources for clustered raid. */
>  	dlm_lockspace_t *lockspace;
>  	int slot_number;
> +	int total_slots;
>  	struct completion completion;
>  	struct dlm_lock_resource *sb_lock;
>  	struct mutex sb_mutex;
> @@ -73,6 +74,7 @@ enum msg_type {
>  	RESYNCING,
>  	NEWDISK,
>  	REMOVE,
> +	READD,
>  };
> =20
>  struct cluster_msg {
> @@ -267,7 +269,7 @@ void recover_bitmaps(struct md_thread *thread)
>  					str, ret);
>  			goto clear_bit;
>  		}
> -		ret =3D bitmap_copy_from_slot(mddev, slot, &lo, &hi);
> +		ret =3D bitmap_copy_from_slot(mddev, slot, &lo, &hi, true);
>  		if (ret) {
>  			pr_err("md-cluster: Could not copy data from bitmap %d\n", slot);
>  			goto dlm_unlock;
> @@ -427,6 +429,17 @@ static void process_remove_disk(struct mddev *mddev,=
 struct cluster_msg *msg)
>  		pr_warn("%s: %d Could not find disk with uuid: %s", __func__, __LINE__=
, pretty_uuid(uuid, msg->uuid));
>  }
> =20
> +static void process_readd_disk(struct mddev *mddev, struct cluster_msg *=
msg)
> +{
> +	struct md_rdev *rdev =3D find_rdev_uuid(mddev, msg->uuid);
> +	char uuid[32];
> +
> +	if (rdev)
> +		clear_bit(Faulty, &rdev->flags);
> +	else
> +		pr_warn("%s: %d Could not find disk with uuid: %s", __func__, __LINE__=
, pretty_uuid(uuid, msg->uuid));
> +}
> +
>  static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *m=
sg)
>  {
>  	switch (msg->type) {
> @@ -451,6 +464,11 @@ static void process_recvd_msg(struct mddev *mddev, s=
truct cluster_msg *msg)
>  			__func__, __LINE__, msg->slot);
>  		process_remove_disk(mddev, msg);
>  		break;
> +	case READD:
> +		pr_info("%s: %d Received READD from %d\n",
> +			__func__, __LINE__, msg->slot);
> +		process_readd_disk(mddev, msg);
> +		break;
>  	default:
>  		pr_warn("%s:%d Received unknown message from %d\n",
>  			__func__, __LINE__, msg->slot);
> @@ -653,6 +671,7 @@ static int join(struct mddev *mddev, int nodes)
>  		ret =3D -ERANGE;
>  		goto err;
>  	}
> +	cinfo->total_slots =3D nodes;
>  	cinfo->sb_lock =3D lockres_init(mddev, "cmd-super",
>  					NULL, 0);
>  	if (!cinfo->sb_lock) {
> @@ -900,6 +919,34 @@ static int remove_disk(struct mddev *mddev, struct m=
d_rdev *rdev)
>  	return __sendmsg(cinfo, &cmsg);
>  }
> =20
> +static int gather_bitmaps(struct md_rdev *rdev)
> +{
> +	int sn, err;
> +	sector_t lo, hi;
> +	struct cluster_msg cmsg;
> +	struct mddev *mddev =3D rdev->mddev;
> +	struct md_cluster_info *cinfo =3D mddev->cluster_info;
> +	struct mdp_superblock_1 *sb =3D page_address(rdev->sb_page);
> +	char *uuid =3D sb->device_uuid;
> +
> +	for (sn =3D 0; sn < cinfo->total_slots; sn++) {
> +		if (sn =3D=3D (cinfo->slot_number - 1))
> +			continue;
> +		err =3D bitmap_copy_from_slot(mddev, sn, &lo, &hi, false);
> +		if (err) {
> +			pr_warn("md-cluster: Could not gather bitmaps from slot %d", sn);
> +			goto out;
> +		}
> +		if ((hi > 0) && (lo < mddev->recovery_cp))
> +			mddev->recovery_cp =3D lo;
> +	}
> +	cmsg.type =3D READD;
> +	memcpy(cmsg.uuid, uuid, 16);
> +	err =3D sendmsg(cinfo, &cmsg);
> +out:
> +	return err;
> +}
> +
>  static struct md_cluster_operations cluster_ops =3D {
>  	.join   =3D join,
>  	.leave  =3D leave,
> @@ -915,6 +962,7 @@ static struct md_cluster_operations cluster_ops =3D {
>  	.add_new_disk_finish =3D add_new_disk_finish,
>  	.new_disk_ack =3D new_disk_ack,
>  	.remove_disk =3D remove_disk,
> +	.gather_bitmaps =3D gather_bitmaps,
>  };
> =20
>  static int __init cluster_init(void)
> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
> index 71e5143..6817ee0 100644
> --- a/drivers/md/md-cluster.h
> +++ b/drivers/md/md-cluster.h
> @@ -23,6 +23,7 @@ struct md_cluster_operations {
>  	int (*add_new_disk_finish)(struct mddev *mddev);
>  	int (*new_disk_ack)(struct mddev *mddev, bool ack);
>  	int (*remove_disk)(struct mddev *mddev, struct md_rdev *rdev);
> +	int (*gather_bitmaps)(struct md_rdev *rdev);
>  };
> =20
>  #endif /* _MD_CLUSTER_H */
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 83a8e91..a233c09 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2847,6 +2847,8 @@ state_store(struct md_rdev *rdev, const char *buf, =
size_t len)
>  			err =3D 0;
>  		}
>  	} else if (cmd_match(buf, "re-add")) {
> +		if (mddev_is_clustered(rdev->mddev))
> +			md_cluster_ops->gather_bitmaps(rdev);
>  		clear_bit(Faulty, &rdev->flags);
>  		err =3D add_bound_rdev(rdev);
>  	}


--Sig_/KFf7esYkI+GeigyMam/E7mL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSW/1Tnsnt1WYoG5AQJHCBAAwJAFGvoepgXyrXMX4UqKejDDXlFJOQcm
dmeOs7c1QAgYK0PpWyrJMPF3DWHjONdL8YfVhpjA++7Y0doA/AkHLOmxLMEtf8SD
oJ+QAuYqfr5N+DY2p0FdLTdVR7cWtM5Wl8gX/TOp/4XdUnrCb/m7aN7R0Hj9FBzv
sqqDLFX8UvIjEJjyPQ7B87+6gUxrDnl2Oe8IocYLRxSUDOEn3pg7e7JuOIkoLGyY
kbNaJS6pRtCb3idvLtl7L/DnEEcMCAAujS7JW3+f26ef7GjRJvaeOKzlU+ZEM3HK
FdiOqQQ6NTi2iSbcSCBqfHnkP7f56vyLGXl2gP11foMg0KK6j/I++3nTnqV2FWhS
qgsuq9/ECbJF8uO8sUcTqTg9bf22+i1ih+Gvg9LMkt7WANS/QAo/C3E/y34d2gMi
wmc1SLMHRddKp8UWOpMfyYqr+SiYxGMbEZC9IYZc62nvi277m61OSHiqg8tV023p
mTLITOkG3YPL1g4QQGFv3UAw5nrblkNqebAoH9ICZeypXdXMDXNvDESDH7aQkgpW
scpIlmaUuoWeRq/rcJaqPyqF38u1WtH8WxHXBfLABjhNPSdY3ZiJvg495+73p6iB
h3Zqpmd8PgSnuuhPuaERKlCXcIw2rwsDJO8qKwOB4BO6YkFam/pAY6QdVkIj0sda
etAizn8EAYk=
=RLNi
-----END PGP SIGNATURE-----

--Sig_/KFf7esYkI+GeigyMam/E7mL--
