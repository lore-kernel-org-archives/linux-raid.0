From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: Remember the last sync operation that was performed
Date: Wed, 26 Jun 2013 12:00:24 +1000
Message-ID: <20130626120024.3ab35f02@notabene.brown>
References: <1372141439.2016.4.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/a/rmNTYdueRs25MyuHXRNBn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372141439.2016.4.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/a/rmNTYdueRs25MyuHXRNBn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Jun 2013 01:23:59 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> MD:  Remember the last sync operation that was performed
>=20
> This patch adds a field to the mddev structure to track the last
> sync operation that was performed.  This is especially useful when
> it comes to what is recorded in mismatch_cnt in sysfs.  If the
> last operation was "data-check", then it reports the number of
> descrepancies found by the user-initiated check.  If it was a
> "repair" operation, then it is reporting the number of
> descrepancies repaired.  etc.
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/dm-raid.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/dm-raid.c
> +++ linux-upstream/drivers/md/dm-raid.c
> @@ -1388,6 +1388,7 @@ static void raid_status(struct dm_target
>  		 *   performing a "check" of the array.
>  		 */
>  		DMEMIT(" %llu",
> +		       (strcmp(rs->md.last_sync_action, "data-check")) ? 0 :
>  		       (unsigned long long)
>  		       atomic64_read(&rs->md.resync_mismatches));
>  		break;
> @@ -1651,7 +1652,7 @@ static void raid_resume(struct dm_target
> =20
>  static struct target_type raid_target =3D {
>  	.name =3D "raid",
> -	.version =3D {1, 5, 1},
> +	.version =3D {1, 5, 2},
>  	.module =3D THIS_MODULE,
>  	.ctr =3D raid_ctr,
>  	.dtr =3D raid_dtr,
> Index: linux-upstream/drivers/md/md.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/md.c
> +++ linux-upstream/drivers/md/md.c
> @@ -521,6 +521,7 @@ void mddev_init(struct mddev *mddev)
>  	init_waitqueue_head(&mddev->recovery_wait);
>  	mddev->reshape_position =3D MaxSector;
>  	mddev->reshape_backwards =3D 0;
> +	mddev->last_sync_action =3D "none";
>  	mddev->resync_min =3D 0;
>  	mddev->resync_max =3D MaxSector;
>  	mddev->level =3D LEVEL_NONE;
> @@ -4272,6 +4273,17 @@ action_store(struct mddev *mddev, const
>  	return len;
>  }
> =20
> +static struct md_sysfs_entry md_scan_mode =3D
> +__ATTR(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
> +
> +static ssize_t
> +last_sync_action_show(struct mddev *mddev, char *page)
> +{
> +	return sprintf(page, "%s\n", mddev->last_sync_action);
> +}
> +
> +static struct md_sysfs_entry md_last_scan_mode =3D __ATTR_RO(last_sync_a=
ction);
> +
>  static ssize_t
>  mismatch_cnt_show(struct mddev *mddev, char *page)
>  {
> @@ -4280,10 +4292,6 @@ mismatch_cnt_show(struct mddev *mddev, c
>  		       atomic64_read(&mddev->resync_mismatches));
>  }
> =20
> -static struct md_sysfs_entry md_scan_mode =3D
> -__ATTR(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
> -
> -
>  static struct md_sysfs_entry md_mismatches =3D __ATTR_RO(mismatch_cnt);
> =20
>  static ssize_t
> @@ -4686,6 +4694,7 @@ static struct attribute *md_default_attr
> =20
>  static struct attribute *md_redundancy_attrs[] =3D {
>  	&md_scan_mode.attr,
> +	&md_last_scan_mode.attr,
>  	&md_mismatches.attr,
>  	&md_sync_min.attr,
>  	&md_sync_max.attr,
> @@ -7336,7 +7345,7 @@ void md_do_sync(struct md_thread *thread
>  		if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
>  			desc =3D "data-check";
>  		else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
> -			desc =3D "requested-resync";
> +			desc =3D "requested-resync"; /* AKA "repair" */
>  		else
>  			desc =3D "resync";
>  	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> @@ -7344,6 +7353,8 @@ void md_do_sync(struct md_thread *thread
>  	else
>  		desc =3D "recovery";
> =20
> +	mddev->last_sync_action =3D desc;
> +
>  	/* we overload curr_resync somewhat here.
>  	 * 0 =3D=3D not engaged in resync at all
>  	 * 2 =3D=3D checking that there is no conflict with another sync
> Index: linux-upstream/drivers/md/md.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/md.h
> +++ linux-upstream/drivers/md/md.h
> @@ -268,6 +268,14 @@ struct mddev {
> =20
>  	struct md_thread		*thread;	/* management thread */
>  	struct md_thread		*sync_thread;	/* doing resync or reconstruct */
> +
> +	/* 'last_sync_action' is initialized to "none".  It is set when a
> +	 * sync operation (i.e "data-check", "requested-resync", "resync",
> +	 * "recovery", or "reshape") is started.  It holds this value even
> +	 * when the sync thread is "frozen" (interrupted) or "idle" (stopped
> +	 * or finished).  It is overwritten when a new sync operation is begun.
> +	 */
> +	char				*last_sync_action;
>  	sector_t			curr_resync;	/* last block scheduled */
>  	/* As resync requests can complete out of order, we cannot easily track
>  	 * how much resync has been completed.  So we occasionally pause until
> Index: linux-upstream/Documentation/device-mapper/dm-raid.txt
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/Documentation/device-mapper/dm-raid.txt
> +++ linux-upstream/Documentation/device-mapper/dm-raid.txt
> @@ -223,3 +223,4 @@ Version History
>  1.5.0   Add message interface to allow manipulation of the sync_action.
>  	New status (STATUSTYPE_INFO) fields: sync_action and mismatch_cnt.
>  1.5.1   Add ability to restore transiently failed devices on resume.
> +1.5.2   'mismatch_cnt' is zero unless [last_]sync_action is "check".
>=20
>=20

Looks sane.  Applied, thanks.

NeilBrown

--Sig_/a/rmNTYdueRs25MyuHXRNBn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcpLODnsnt1WYoG5AQJ8NA/+JqBnVWMGqyc01+AHDjQLvc+i+Cq/g6W9
IxYg9XbIsJyk6bbr3+F+3M6iBfIF5AGFvxJ7aWpwoYou9bGN4rsNhQTqRqJx/vJy
tPToDbOrco3pqDjlFlkoWml1ST1QY+yAubtnozZRbhlYvSSsgZukKkwAsXSLotVA
s1hu/w+rbKkOA2awNoKN+tjmOK6+nRfM3SDAu6Y7BY5MitrZG4eYF1PBKIyrGG4e
yn42PYKTTuzK5f5KfU7i9ZoWRnhJNjN7I6TL/4efx6Iv0AtK1UP69xITH60o6wP8
RybS2B8Jydrii2GcWjOOETqb4pXpNhrlbwEqKLczfQ2KUpDPC8mal+40Uo77sw8P
xiJ3/wv3d59nAOHSOOwAFEyDDTntoq8XYxp8PK1R0G3J+q4GNRiQa8SPE9oOpOSa
3ZmqREpwJIpHzNL9oZQte/sud3RbnDf9GDWHoDPhh81pxX4lg0c2zlKKhBTv57zS
ioc+93sFmIhzMRDf3PAg97gI8ed6DJiw064HWhQDIdIQX6vQrmuWUk+jxaDyFOJb
0awuZY5bFXrGw6k30JwJaw7Ufs4AHBqY38lLIXJmMPimCIQgHU8vsV0wWzhASx4n
9dRmH0yTYx64eKvjuCgQyqT08KjHhKK3abK4DKc9JTtOmhHT5tRw90/J1jctNzvM
FUr5P1OWk60=
=vdss
-----END PGP SIGNATURE-----

--Sig_/a/rmNTYdueRs25MyuHXRNBn--
