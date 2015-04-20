From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] md-cluster: re-add capabilities
Date: Mon, 20 Apr 2015 12:01:21 +1000
Message-ID: <20150420120121.374b72f3@notabene.brown>
References: <20150414154541.GA4138@shrek.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/0yUEb3/+KVcTpsXI9Q/kSva"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150414154541.GA4138@shrek.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: GQJiang@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0yUEb3/+KVcTpsXI9Q/kSva
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Apr 2015 10:45:42 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wro=
te:

> When "re-add" is writted to /sys/block/mdXX/md/dev-YYY/state,
> the clustered md:
>=20
> 1. Sends RE_ADD message with the desc_nr. Nodes receiving the message
>    clear the Faulty bit in their respective rdev->flags.
> 2. The node initiating re-add, gathers the bitmaps of all nodes
>    and copies them into the local bitmap. It does not clear the bitmap
>    from which it is copying.
> 3. Initiating node schedules a md recovery to sync the devices.
>=20
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/bitmap.c     | 20 +++++++++++---------
>  drivers/md/bitmap.h     |  2 +-
>  drivers/md/md-cluster.c | 48 +++++++++++++++++++++++++++++++++++++++++++=
++++-
>  drivers/md/md-cluster.h |  1 +
>  drivers/md/md.c         | 12 ++++++++++++
>  5 files changed, 72 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 5ff67c3..956cfb9 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -1852,7 +1852,7 @@ EXPORT_SYMBOL_GPL(bitmap_load);
>   * to our bitmap
>   */
>  int bitmap_copy_from_slot(struct mddev *mddev, int slot,
> -		sector_t *low, sector_t *high)
> +		sector_t *low, sector_t *high, bool clear_bits)
>  {
>  	int rv =3D 0, i, j;
>  	sector_t block, lo =3D 0, hi =3D 0;
> @@ -1879,14 +1879,16 @@ int bitmap_copy_from_slot(struct mddev *mddev, in=
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
> index 4aabc74..f1f4dd0 100644
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
> index 82f1b7b..ad2b5b7 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -73,6 +73,7 @@ enum msg_type {
>  	RESYNCING,
>  	NEWDISK,
>  	REMOVE,
> +	RE_ADD,
>  };
> =20
>  struct cluster_msg {
> @@ -253,7 +254,7 @@ void recover_bitmaps(struct md_thread *thread)
>  					str, ret);
>  			goto clear_bit;
>  		}
> -		ret =3D bitmap_copy_from_slot(mddev, slot, &lo, &hi);
> +		ret =3D bitmap_copy_from_slot(mddev, slot, &lo, &hi, true);
>  		if (ret) {
>  			pr_err("md-cluster: Could not copy data from bitmap %d\n", slot);
>  			goto dlm_unlock;
> @@ -412,6 +413,16 @@ static void process_remove_disk(struct mddev *mddev,=
 struct cluster_msg *msg)
>  		pr_warn("%s: %d Could not find disk(%d) to REMOVE\n", __func__, __LINE=
__, msg->raid_slot);
>  }
> =20
> +static void process_readd_disk(struct mddev *mddev, struct cluster_msg *=
msg)
> +{
> +	struct md_rdev *rdev =3D md_find_rdev_nr_rcu(mddev, msg->raid_slot);
> +
> +	if (rdev && test_bit(Faulty, &rdev->flags))
> +		clear_bit(Faulty, &rdev->flags);
> +	else
> +		pr_warn("%s: %d Could not find disk(%d) which is faulty", __func__, __=
LINE__, msg->raid_slot);
> +}
> +
>  static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *m=
sg)
>  {
>  	switch (msg->type) {
> @@ -436,6 +447,11 @@ static void process_recvd_msg(struct mddev *mddev, s=
truct cluster_msg *msg)
>  			__func__, __LINE__, msg->slot);
>  		process_remove_disk(mddev, msg);
>  		break;
> +	case RE_ADD:
> +		pr_info("%s: %d Received RE_ADD from %d\n",
> +			__func__, __LINE__, msg->slot);
> +		process_readd_disk(mddev, msg);
> +		break;
>  	default:
>  		pr_warn("%s:%d Received unknown message from %d\n",
>  			__func__, __LINE__, msg->slot);
> @@ -883,6 +899,35 @@ static int remove_disk(struct mddev *mddev, struct m=
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
> +
> +	cmsg.type =3D RE_ADD;
> +	cmsg.raid_slot =3D rdev->desc_nr;
> +	err =3D sendmsg(cinfo, &cmsg);
> +	if (err)
> +		goto out;
> +
> +	for (sn =3D 0; sn < mddev->bitmap_info.nodes; sn++) {
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
> +out:
> +	return err;
> +}
> +
>  static struct md_cluster_operations cluster_ops =3D {
>  	.join   =3D join,
>  	.leave  =3D leave,
> @@ -898,6 +943,7 @@ static struct md_cluster_operations cluster_ops =3D {
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
> index ba01605..8c37bbf 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2599,11 +2599,23 @@ state_store(struct md_rdev *rdev, const char *buf=
, size_t len)
>  			err =3D 0;
>  		}
>  	} else if (cmd_match(buf, "re-add") && (test_bit(Faulty, &rdev->flags) =
|| (rdev->raid_disk =3D=3D -1))) {
> +			/* clear_bit is performed _after_ all the devices
> +			 * have their local Faulty bit cleared. If any writes
> +			 * happen in the meantime in the local node, they
> +			 * will land in the local bitmap, which will be synced
> +			 * by this node eventually
> +			 */
> +			if (mddev_is_clustered(rdev->mddev)) {
> +				err =3D md_cluster_ops->gather_bitmaps(rdev);
> +				if (err)
> +					goto out;
> +			}
>  			clear_bit(Faulty, &rdev->flags);
>  			err =3D add_bound_rdev(rdev);
>  		}
>  	if (!err)
>  		sysfs_notify_dirent_safe(rdev->sysfs_state);
> +out:
>  	return err ? err : len;
>  }
>  static struct rdev_sysfs_entry rdev_state =3D

I changed this to:

			if (!mddev_is_clustered(rdev->mddev) ||
			    (err =3D md_cluster_ops->gather_bitmaps(rdev)) =3D=3D 0) {
				clear_bit(Faulty, &rdev->flags);
				err =3D add_bound_rdev(rdev);
			}

because I think it makes the code a bit clearer.

otherwise, applied.
Thanks,
NeilBrown



--Sig_/0yUEb3/+KVcTpsXI9Q/kSva
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTRd8Tnsnt1WYoG5AQJtuxAAm3yFjHCPu4LWnGMsH53gH2xBDS0fzXkS
5dNyld/emmoWRVfMWnDevq6OKgzpp2U56YZPCjcV6DCalwyzvC5gLExNI0M/JQz9
2Q8hIDfJZEjIrD186S2rjYeE5wYDfZY+7TCpvQxmZ/4ZzHU/go6X6JHfodlR7PTI
whhusseNeXhutJrio4a+AM7l3w7PVTRTV/qSmHpo/9yZvEuxzGDBGUKAlAAup9BT
LoABhwO8hDtLaRrsgmX8QFYOvWfaiB6XBocib5Z3oVdy8VDoISSvH63R/nl+2XSp
z4sQgGfuFUkBNZs/Kz3HoqvgHdJRxf7vRNVLdmsFQGDnkSXArVIC/j4uPSPhY1BD
jTmhbSTCsC0BZJNjX12SF1sp3tTJmgoSsAUjSiasZrMlBFXTtRtY/3rpg2mbtUUQ
wDXsCrnpQpdICjuYYjXo6fG38F1+PwOSg2kQk1fftB1emjnHveMp+nQR/ovlQBda
i2n0XO7TauYRNQOPb/98GIxMqpdvvUTahAOBy4/f9BH5uUQEXFFy83Di3V3kJjMJ
a2WprAn09BRCBi+EHTwtiB1Zow4AXTrxakAbDlrxeMivXupt2p95AVCFLehdo34z
fzZ8rg8yILq8QUqWcCCD5tGb0zNyn1cwHwZTMnmbduMt+uKRhrhbd+ND/EusSMHa
eVz8HfJVsGM=
=4TFV
-----END PGP SIGNATURE-----

--Sig_/0yUEb3/+KVcTpsXI9Q/kSva--
