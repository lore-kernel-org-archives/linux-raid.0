From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH - v2] DM RAID: Add ability to restore transiently failed
 devices on resume
Date: Mon, 6 May 2013 16:00:35 +1000
Message-ID: <20130506160035.2b84bda5@notabene.brown>
References: <1365712023.9799.1.camel@f16>
	<1367522364.23442.1.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qtmot3UA.785y39X1hpQi=L"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1367522364.23442.1.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, agk@redhat.com
List-Id: linux-raid.ids

--Sig_/qtmot3UA.785y39X1hpQi=L
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 02 May 2013 14:19:24 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> DM RAID: Add ability to restore transiently failed devices on resume
>=20
> This patch adds code to the resume function to check over the devices
> in the RAID array.  If any are found to be marked as failed and their
> superblocks can be read, an attempt is made to reintegrate them into
> the array.  This allows the user to refresh the array with a simple
> suspend and resume of the array - rather than having to load a
> completely new table, allocate and initialize all the structures and
> throw away the old instantiation.
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/dm-raid.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/dm-raid.c
> +++ linux-upstream/drivers/md/dm-raid.c
> @@ -1574,12 +1574,54 @@ static void raid_postsuspend(struct dm_t
> =20
>  static void raid_resume(struct dm_target *ti)
>  {
> +	int i;
> +	uint64_t failed_devices, cleared_failed_devices =3D 0;
> +	unsigned long flags;
> +	struct dm_raid_superblock *sb;
>  	struct raid_set *rs =3D ti->private;
> +	struct md_rdev *r;
> =20
>  	set_bit(MD_CHANGE_DEVS, &rs->md.flags);
>  	if (!rs->bitmap_loaded) {
>  		bitmap_load(&rs->md);
>  		rs->bitmap_loaded =3D 1;
> +	} else {
> +		/*
> +		 * A secondary resume while the device is active.
> +		 * Take this opportunity to check whether any failed
> +		 * devices are reachable again.
> +		 */
> +		for (i =3D 0; i < rs->md.raid_disks; i++) {
> +			r =3D &rs->dev[i].rdev;
> +			if (test_bit(Faulty, &r->flags) && r->sb_page &&
> +			    sync_page_io(r, 0, r->sb_size,
> +					 r->sb_page, READ, 1)) {
> +				DMINFO("Faulty device #%d has readable super"
> +				       "block.  Attempting to revive it.", i);
> +				r->raid_disk =3D i;
> +				r->saved_raid_disk =3D i;
> +				flags =3D r->flags;
> +				clear_bit(Faulty, &r->flags);
> +				clear_bit(WriteErrorSeen, &r->flags);
> +				clear_bit(In_sync, &r->flags);
> +				if (r->mddev->pers->hot_add_disk(r->mddev, r)) {
> +					r->raid_disk =3D -1;
> +					r->saved_raid_disk =3D -1;
> +					r->flags =3D flags;
> +				} else {
> +					r->recovery_offset =3D 0;
> +					cleared_failed_devices |=3D 1 << i;
> +				}
> +			}
> +		}
> +		if (cleared_failed_devices) {
> +			rdev_for_each(r, &rs->md) {
> +				sb =3D page_address(r->sb_page);
> +				failed_devices =3D le64_to_cpu(sb->failed_devices);
> +				failed_devices &=3D ~cleared_failed_devices;
> +				sb->failed_devices =3D cpu_to_le64(failed_devices);
> +			}
> +		}
>  	}
> =20
>  	clear_bit(MD_RECOVERY_FROZEN, &rs->md.recovery);
> @@ -1588,7 +1630,7 @@ static void raid_resume(struct dm_target
> =20
>  static struct target_type raid_target =3D {
>  	.name =3D "raid",
> -	.version =3D {1, 5, 0},
> +	.version =3D {1, 5, 1},
>  	.module =3D THIS_MODULE,
>  	.ctr =3D raid_ctr,
>  	.dtr =3D raid_dtr,
> Index: linux-upstream/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/raid1.c
> +++ linux-upstream/drivers/md/raid1.c
> @@ -1518,8 +1518,9 @@ static int raid1_add_disk(struct mddev *
>  		p =3D conf->mirrors+mirror;
>  		if (!p->rdev) {
> =20
> -			disk_stack_limits(mddev->gendisk, rdev->bdev,
> -					  rdev->data_offset << 9);
> +			if (mddev->gendisk)
> +				disk_stack_limits(mddev->gendisk, rdev->bdev,
> +						  rdev->data_offset << 9);
> =20
>  			p->head_position =3D 0;
>  			rdev->raid_disk =3D mirror;
> @@ -1558,7 +1559,7 @@ static int raid1_add_disk(struct mddev *
>  		clear_bit(Unmerged, &rdev->flags);
>  	}
>  	md_integrity_add_rdev(rdev, mddev);
> -	if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
> +	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
>  		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
>  	print_conf(conf);
>  	return err;
> Index: linux-upstream/drivers/md/raid10.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/raid10.c
> +++ linux-upstream/drivers/md/raid10.c
> @@ -1806,15 +1806,17 @@ static int raid10_add_disk(struct mddev
>  			set_bit(Replacement, &rdev->flags);
>  			rdev->raid_disk =3D mirror;
>  			err =3D 0;
> -			disk_stack_limits(mddev->gendisk, rdev->bdev,
> -					  rdev->data_offset << 9);
> +			if (mddev->gendisk)
> +				disk_stack_limits(mddev->gendisk, rdev->bdev,
> +						  rdev->data_offset << 9);
>  			conf->fullsync =3D 1;
>  			rcu_assign_pointer(p->replacement, rdev);
>  			break;
>  		}
> =20
> -		disk_stack_limits(mddev->gendisk, rdev->bdev,
> -				  rdev->data_offset << 9);
> +		if (mddev->gendisk)
> +			disk_stack_limits(mddev->gendisk, rdev->bdev,
> +					  rdev->data_offset << 9);
> =20
>  		p->head_position =3D 0;
>  		p->recovery_disabled =3D mddev->recovery_disabled - 1;
> Index: linux-upstream/Documentation/device-mapper/dm-raid.txt
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/Documentation/device-mapper/dm-raid.txt
> +++ linux-upstream/Documentation/device-mapper/dm-raid.txt
> @@ -222,3 +222,4 @@ Version History
>  1.4.2   Add RAID10 "far" and "offset" algorithm support.
>  1.5.0   Add message interface to allow manipulation of the sync_action.
>  	New status (STATUSTYPE_INFO) fields: sync_action and mismatch_cnt.
> +1.5.1   Add ability to restore transiently failed devices on resume.
>=20


Applied thanks.  I assume this is heading for 3.11 ?

NeilBrown

--Sig_/qtmot3UA.785y39X1hpQi=L
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYdHAznsnt1WYoG5AQLo5A/6A147jC/BmcmcTM5uVNqy5gwt2poHv8wq
Aazt/CuPyyBlY6QuXos6Uvn9bR/4ChPg+xHunTYie0S0nzdC5VQbnYgYHsJ7admI
FN9mGBkarOaCwTFKGfTw1M9Gw43+z8u3OvrAEpUbSDcFsp277J4mlnc83Jrxfji3
wqljWXqKbohXu3MqOhUT0pAydf5NfSDAq0EXT846moX0mJduVzigDw9lleakP6kV
oL3CnMOkB7Sy2Kwy/LtnEPSi3NUmApSJr8qluVN4JX5PSbkzAdmHbsSQPCM15lsM
r7af02VaFXHLy/EsdwGD+hiD2rRUVM5Som/gR8QlKpsYPr4HbKIsqX9d5sl2H8N0
y73nsj6OZvSGvlhs4vmuJ7RkqfPQlmBKY87LBC6+hfb+uD32TpIBALxzdrZIzPxx
DtaAjCGeVYuLdS6TmXvBU0WZ9bQy+S4iRJv4+CXiXLkcCA+FPJmi92sNxOURtonk
fNY028PSvpPcCfZK6/AoqjfOk4sckpQ6KzuIL4YekJHcxDsWLVHP7uGrbRMzdUa8
BU+wkG5YLujyGNCoeg02vj62Na4JfxX13RQN4x+TBvP1J00QAypJOyytFJnvyVJr
bJHN/INclgYjC66kTysFBm7w+CJj/OIRDScptWr1cbs4AfK4jseruoutsOQVg60z
tEcL648zNmA=
=7lvZ
-----END PGP SIGNATURE-----

--Sig_/qtmot3UA.785y39X1hpQi=L--
